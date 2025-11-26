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

local ThemeManager = {}
do
    ThemeManager.Folder = "MilleniumThemes"
    ThemeManager.Library = nil
    ThemeManager.BuiltInThemes = {
        ["Default"] = { 1, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"191919","AccentColor":"f0503d","BackgroundColor":"0f0f0f","OutlineColor":"282828"}]]) },
        ["BBot"] = { 2, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}]]) },
        ["Fatality"] = { 3, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}]]) },
        ["Jester"] = { 4, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737"}]]) },
        ["Mint"] = { 5, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737"}]]) },
        ["Tokyo Night"] = { 6, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}]]) },
        ["Ubuntu"] = { 7, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919"}]]) },
        ["Quartz"] = { 8, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"232330","AccentColor":"426e87","BackgroundColor":"1d1b26","OutlineColor":"27232f"}]]) },
    }

    function ThemeManager:SetLibrary(library)
        self.Library = library
    end

    function ThemeManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    function ThemeManager:BuildFolderTree()
        local paths = {
            self.Folder,
            self.Folder .. "/themes",
            self.Folder .. "/settings"
        }

        for i = 1, #paths do
            local path = paths[i]
            if not isfolder(path) then
                pcall(makefolder, path)
            end
        end
    end

    function ThemeManager:ApplyTheme(theme)
        if type(theme) == "string" then
            theme = self.BuiltInThemes[theme] or self.CustomThemes[theme]
        end

        if theme then
            if type(theme) == "table" and theme[2] then
                theme = theme[2]
            end

            local scheme = {}
            for key, value in pairs(theme) do
                if typeof(value) == "string" and key ~= "CustomSound" then
                    local success, color = pcall(function()
                        return Color3.fromHex(value)
                    end)

                    if success then
                        scheme[key] = color
                    end
                elseif key == "CustomSound" then
                    scheme[key] = value
                end
            end

            if self.Library and self.Library.UpdateColors then
                self.Library:UpdateColors(scheme)
            end
        end
    end

    function ThemeManager:ThemeUpdate()
        local opts = self.Library and self.Library.Options or {}
        local function pick(name, fallback)
            local o = opts[name]
            if o and o.Value and typeof(o.Value) == "Color3" then
                return o.Value:ToHex()
            end
            return fallback
        end

        local theme = {
            FontColor = pick("FontColor", "ffffff"),
            MainColor = pick("MainColor", "191919"),
            AccentColor = pick("AccentColor", "f0503d"),
            BackgroundColor = pick("BackgroundColor", "0f0f0f"),
            OutlineColor = pick("OutlineColor", "282828")
        }

        self:ApplyTheme(theme)
    end

    function ThemeManager:LoadDefault()
        local path = self.Folder .. "/settings/theme.txt"

        if isfile(path) then
            local success, content = pcall(readfile, path)
            if success and content then
                content = content:gsub("\"", "")
                local themeName = self.BuiltInThemes[content] and content or nil

                if themeName then
                    self:ApplyTheme(themeName)
                end
            end
        end
    end

    function ThemeManager:SaveDefault(theme)
        if theme and self.BuiltInThemes[theme] then
            local path = self.Folder .. "/settings/theme.txt"

            writefile(path, theme)
        end
    end

    function ThemeManager:CreateThemeManager(groupbox)
        groupbox:AddColorPicker("BackgroundColor", {
            Name = "Background Color",
            Default = Color3.fromRGB(25, 25, 25),
            Callback = function(color)
                if self.Library then
                    self:ThemeUpdate()
                end
            end
        })

        groupbox:AddColorPicker("MainColor", {
            Name = "Main Color",
            Default = Color3.fromRGB(35, 35, 35),
            Callback = function(color)
                if self.Library then
                    self:ThemeUpdate()
                end
            end
        })

        groupbox:AddColorPicker("AccentColor", {
            Name = "Accent Color",
            Default = Color3.fromRGB(0, 85, 255),
            Callback = function(color)
                if self.Library then
                    self:ThemeUpdate()
                end
            end
        })

        groupbox:AddColorPicker("OutlineColor", {
            Name = "Outline Color",
            Default = Color3.fromRGB(0, 0, 0),
            Callback = function(color)
                if self.Library then
                    self:ThemeUpdate()
                end
            end
        })

        groupbox:AddColorPicker("FontColor", {
            Name = "Font Color",
            Default = Color3.fromRGB(255, 255, 255),
            Callback = function(color)
                if self.Library then
                    self:ThemeUpdate()
                end
            end
        })

        groupbox:AddDropdown("FontFace", {
            Name = "Font Face",
            Default = "Code",
            Values = {"BuilderSans","Code","Fantasy","Gotham","Jura","Roboto","RobotoMono","SourceSans"}
        })

        groupbox:AddDivider()

        local ThemesArray = {}
        for Name, Theme in pairs(self.BuiltInThemes) do
            table.insert(ThemesArray, Name)
        end

        table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

        groupbox:AddDropdown("ThemeManager_ThemeList", {
            Name = "Theme List",
            Values = ThemesArray,
            Default = 1,
            Callback = function(option)
                self:ApplyTheme(option)
            end
        })

        groupbox:AddButton({
            Name = "Set as Default",
            Callback = function()
                self:SaveDefault(self.Library.flags.ThemeManager_ThemeList)
                self.Library:Notify("Set default theme to " .. self.Library.flags.ThemeManager_ThemeList)
            end
        })

        self:LoadDefault()
    end

    function ThemeManager:SetupThemeManager(TabObj)
        self:BuildFolderTree()
        
        if not self.Library then
            return
        end

        local section
        
        if TabObj then
            section = TabObj:AddLeftGroupbox("Themes", 2)
        else
            if not self.Library.window then
                if type(self.Library.CreateWindow) == "function" then
                    self.Library.window = self.Library:CreateWindow({Title = "Theme Manager"})
                else
                    return
                end
            end
            
            local window = self.Library.window
            
            local configs = window:tab({name = "Theme Manager", tabs = {"Themes"}})
            local column = configs:column({})
            section = column:section({name = "Theme Manager", size = 1, default = true})
        end

        self:CreateThemeManager(section)
    end
end

return ThemeManager