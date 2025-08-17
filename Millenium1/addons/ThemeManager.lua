local cloneref = (cloneref or clonereference or function(instance) return instance end)
local httpService = cloneref(game:GetService("HttpService"))
local httprequest = (syn and syn.request) or request or http_request or (http and http.request)
local getassetfunc = getcustomasset or getsynasset
local isfolder, isfile, listfiles = isfolder, isfile, listfiles

if typeof(copyfunction) == "function" then
    local
        isfolder_copy,
        isfile_copy,
        listfiles_copy = copyfunction(isfolder), copyfunction(isfile), copyfunction(listfiles)

    local isfolder_success, isfolder_error = pcall(function()
        return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
    end)

    if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
        isfolder = function(folder)
            local success, data = pcall(isfolder_copy, folder)
            return (if success then data else false)
        end

        isfile = function(file)
            local success, data = pcall(isfile_copy, file)
            return (if success then data else false)
        end

        listfiles = function(folder)
            local success, data = pcall(listfiles_copy, folder)
            return (if success then data else {})
        end
    end
end

local ThemeManager = {} do
    ThemeManager.Folder = "MilleniumLibSettings"
    ThemeManager.Library = nil
    ThemeManager.BuiltInThemes = {
        ["Default"]      = { 1, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"191919","AccentColor":"f0503d","BackgroundColor":"0f0f0f","OutlineColor":"282828"}]]) },
        ["BBot"]         = { 2, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}]]) },
        ["Fatality"]     = { 3, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}]]) },
        ["Jester"]       = { 4, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737"}]]) },
        ["Mint"]         = { 5, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737"}]]) },
        ["Tokyo Night"]  = { 6, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}]]) },
        ["Ubuntu"]       = { 7, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919"}]]) },
        ["Quartz"]       = { 8, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"232330","AccentColor":"426e87","BackgroundColor":"1d1b26","OutlineColor":"27232f"}]]) },
        ["Nord"]         = { 9, httpService:JSONDecode([[{"FontColor":"eceff4","MainColor":"3b4252","AccentColor":"88c0d0","BackgroundColor":"2e3440","OutlineColor":"4c566a"}]]) },
        ["Dracula"]      = { 10, httpService:JSONDecode([[{"FontColor":"f8f8f2","MainColor":"44475a","AccentColor":"ff79c6","BackgroundColor":"282a36","OutlineColor":"6272a4"}]]) },
        ["Monokai"]      = { 11, httpService:JSONDecode([[{"FontColor":"f8f8f2","MainColor":"272822","AccentColor":"f92672","BackgroundColor":"1e1f1c","OutlineColor":"49483e"}]]) },
        ["Gruvbox"]      = { 12, httpService:JSONDecode([[{"FontColor":"ebdbb2","MainColor":"3c3836","AccentColor":"fb4934","BackgroundColor":"282828","OutlineColor":"504945"}]]) },
    }

    function ThemeManager:SetLibrary(library)
        self.Library = library
    end

    function ThemeManager:GetPaths()
        local paths = {}

        local parts = self.Folder:split("/")
        for idx = 1, #parts do
            paths[#paths + 1] = table.concat(parts, "/", 1, idx)
        end

        paths[#paths + 1] = self.Folder .. "/themes"
        
        return paths
    end

    function ThemeManager:BuildFolderTree()
        local paths = self:GetPaths()

        for i = 1, #paths do
            local str = paths[i]
            if isfolder(str) then continue end
            makefolder(str)
        end
    end

    function ThemeManager:CheckFolderTree()
        if isfolder(self.Folder) then return end
        self:BuildFolderTree()

        task.wait(0.1)
    end

    function ThemeManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end
    
    function ThemeManager:ApplyTheme(theme)
        local customThemeData = self:GetCustomTheme(theme)
        local data = customThemeData or self.BuiltInThemes[theme]

        if not data then return end
        
        local scheme = data[2]
        for idx, val in pairs(customThemeData or scheme) do
            if idx == "FontColor" then
                self.Library:update_theme("font", Color3.fromHex(val))
            elseif idx == "MainColor" then
                self.Library:update_theme("main", Color3.fromHex(val))
            elseif idx == "AccentColor" then
                self.Library:update_theme("accent", Color3.fromHex(val))
            elseif idx == "BackgroundColor" then
                self.Library:update_theme("background", Color3.fromHex(val))
            elseif idx == "OutlineColor" then
                self.Library:update_theme("outline", Color3.fromHex(val))
            end
        end
    end

    function ThemeManager:GetCustomTheme(file)
        local path = self.Folder .. "/themes/" .. file .. ".json"
        if not isfile(path) then
            return nil
        end

        local data = readfile(path)
        local success, decoded = pcall(httpService.JSONDecode, httpService, data)
        
        if not success then
            return nil
        end

        return decoded
    end

    function ThemeManager:LoadDefault()
        local theme = "Default"
        local content = isfile(self.Folder .. "/themes/default.txt") and readfile(self.Folder .. "/themes/default.txt")

        local isDefault = true
        if content then
            if self.BuiltInThemes[content] then
                theme = content
            elseif self:GetCustomTheme(content) then
                theme = content
                isDefault = false
            end
        end

        if isDefault then
            if self.Library.flags and self.Library.flags.ThemeManagerList then
                self.Library.flags.ThemeManagerList = theme
            end
        else
            self:ApplyTheme(theme)
        end
    end

    function ThemeManager:SaveDefault(theme)
        writefile(self.Folder .. "/themes/default.txt", theme)
    end

    function ThemeManager:SaveCustomTheme(file)
        if file:gsub(" ", "") == "" then
            return self.Library.notifications:create_notification({name = "Theme Manager", info = "Invalid file name for theme (empty)"})
        end

        local theme = {
            FontColor = self.Library.themes.preset.font:ToHex(),
            MainColor = self.Library.themes.preset.main:ToHex(),
            AccentColor = self.Library.themes.preset.accent:ToHex(),
            BackgroundColor = self.Library.themes.preset.background:ToHex(),
            OutlineColor = self.Library.themes.preset.outline:ToHex()
        }

        writefile(self.Folder .. "/themes/" .. file .. ".json", httpService:JSONEncode(theme))
    end

    function ThemeManager:Delete(name)
        if (not name) then
            return false, "no theme file is selected"
        end

        local file = self.Folder .. "/themes/" .. name .. ".json"
        if not isfile(file) then return false, "invalid file" end

        local success = pcall(delfile, file)
        if not success then return false, "delete file error" end
        
        return true
    end
    
    function ThemeManager:ReloadCustomThemes()
        local list = listfiles(self.Folder .. "/themes")

        local out = {}
        for i = 1, #list do
            local file = list[i]
            if file:sub(-5) == ".json" then
                local pos = file:find(".json", 1, true)
                local start = pos

                local char = file:sub(pos, pos)
                while char ~= "/" and char ~= "\\" and char ~= "" do
                    pos = pos - 1
                    char = file:sub(pos, pos)
                end

                if char == "/" or char == "\\" then
                    table.insert(out, file:sub(pos + 1, start - 1))
                end
            end
        end

        return out
    end

    function ThemeManager:SetupThemeManager(window)
        self:BuildFolderTree()

        local configs = window:tab({name = "Theme Manager", tabs = {"Themes"}})
        local column = configs:column({})
        local section = column:section({name = "Theme Manager", size = 1, default = true})

        section:colorpicker({name = "Background Color", flag = "BackgroundColor", callback = function(color)
            self.Library:update_theme("background", color)
        end, color = self.Library.themes.preset.background})

        section:colorpicker({name = "Main Color", flag = "MainColor", callback = function(color)
            self.Library:update_theme("main", color)
        end, color = self.Library.themes.preset.main})

        section:colorpicker({name = "Accent Color", flag = "AccentColor", callback = function(color)
            self.Library:update_theme("accent", color)
        end, color = self.Library.themes.preset.accent})

        section:colorpicker({name = "Outline Color", flag = "OutlineColor", callback = function(color)
            self.Library:update_theme("outline", color)
        end, color = self.Library.themes.preset.outline})

        section:colorpicker({name = "Font Color", flag = "FontColor", callback = function(color)
            self.Library:update_theme("font", color)
        end, color = self.Library.themes.preset.font})

        section:seperator({})

        local ThemesArray = {}
        for Name, Theme in pairs(self.BuiltInThemes) do
            table.insert(ThemesArray, Name)
        end

        table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

        section:dropdown({name = "Theme List", flag = "ThemeManagerList", options = ThemesArray, callback = function(option)
            self:ApplyTheme(option)
        end})

        section:button({name = "Set as Default", callback = function()
            self:SaveDefault(self.Library.flags.ThemeManagerList)
            self.Library.notifications:create_notification({name = "Theme Manager", info = "Set default theme to " .. self.Library.flags.ThemeManagerList})
        end})

        section:seperator({})

        section:textbox({name = "Custom Theme Name", flag = "ThemeManagerCustomName"})

        section:button({name = "Create Theme", callback = function()
            self:SaveCustomTheme(self.Library.flags.ThemeManagerCustomName)
            self.Library.flags.ThemeManagerCustomList = self:ReloadCustomThemes()
            self.Library.notifications:create_notification({name = "Theme Manager", info = "Created theme: " .. self.Library.flags.ThemeManagerCustomName})
        end})

        section:seperator({})

        section:dropdown({name = "Custom Themes", flag = "ThemeManagerCustomList", options = self:ReloadCustomThemes(), callback = function() end})

        section:button({name = "Load Theme", callback = function()
            local name = self.Library.flags.ThemeManagerCustomList
            if not name then return end
            
            self:ApplyTheme(name)
            self.Library.notifications:create_notification({name = "Theme Manager", info = "Loaded theme: " .. name})
        end})

        section:button({name = "Overwrite Theme", callback = function()
            local name = self.Library.flags.ThemeManagerCustomList
            if not name then return end
            
            self:SaveCustomTheme(name)
            self.Library.notifications:create_notification({name = "Theme Manager", info = "Overwrote theme: " .. name})
        end})

        section:button({name = "Delete Theme", callback = function()
            local name = self.Library.flags.ThemeManagerCustomList
            if not name then return end
            
            local success, err = self:Delete(name)
            if not success then
                return self.Library.notifications:create_notification({name = "Theme Manager", info = "Failed to delete theme: " .. err})
            end

            self.Library.notifications:create_notification({name = "Theme Manager", info = "Deleted theme: " .. name})
            self.Library.flags.ThemeManagerCustomList = self:ReloadCustomThemes()
        end})

        section:button({name = "Refresh List", callback = function()
            self.Library.flags.ThemeManagerCustomList = self:ReloadCustomThemes()
        end})

        section:button({name = "Set as Default", callback = function()
            local name = self.Library.flags.ThemeManagerCustomList
            if not name then return end
            
            self:SaveDefault(name)
            self.Library.notifications:create_notification({name = "Theme Manager", info = "Set default theme to: " .. name})
        end})

        self:LoadDefault()
    end
end

getgenv().MilleniumThemeManager = ThemeManager
return ThemeManager
