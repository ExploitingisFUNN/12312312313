local cloneref = (cloneref or clonereference or function(instance) return instance end)
local httpService = cloneref(game:GetService("HttpService"))
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

local SaveManager = {} do
    SaveManager.Folder = "MilleniumLibSettings"
    SaveManager.SubFolder = ""
    SaveManager.Ignore = {}
    SaveManager.Library = nil
    SaveManager.Parser = {
        Toggle = {
            Save = function(idx, object)
                return { type = "Toggle", idx = idx, value = object.value }
            end,
            Load = function(idx, data)
                if SaveManager.Library.flags[idx] ~= nil then
                    SaveManager.Library.flags[idx] = data.value
                end
            end,
        },
        Slider = {
            Save = function(idx, object)
                return { type = "Slider", idx = idx, value = object }
            end,
            Load = function(idx, data)
                if SaveManager.Library.flags[idx] ~= nil then
                    SaveManager.Library.flags[idx] = data.value
                end
            end,
        },
        Dropdown = {
            Save = function(idx, object)
                return { type = "Dropdown", idx = idx, value = object }
            end,
            Load = function(idx, data)
                if SaveManager.Library.flags[idx] ~= nil then
                    SaveManager.Library.flags[idx] = data.value
                end
            end,
        },
        Colorpicker = {
            Save = function(idx, object)
                return { type = "Colorpicker", idx = idx, value = object:ToHex() }
            end,
            Load = function(idx, data)
                if SaveManager.Library.flags[idx] ~= nil then
                    SaveManager.Library.flags[idx] = Color3.fromHex(data.value)
                end
            end,
        },
        Keybind = {
            Save = function(idx, object)
                return { type = "Keybind", idx = idx, mode = object.mode, key = object.key }
            end,
            Load = function(idx, data)
                if SaveManager.Library.flags[idx] ~= nil then
                    SaveManager.Library.flags[idx] = { key = data.key, mode = data.mode }
                end
            end,
        },
        Textbox = {
            Save = function(idx, object)
                return { type = "Textbox", idx = idx, text = object }
            end,
            Load = function(idx, data)
                if SaveManager.Library.flags[idx] ~= nil then
                    SaveManager.Library.flags[idx] = data.text
                end
            end,
        },
    }

    function SaveManager:SetLibrary(library)
        self.Library = library
    end

    function SaveManager:IgnoreThemeSettings()
        self:SetIgnoreIndexes({
            "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", 
            "ThemeManagerList", "ThemeManagerCustomList", "ThemeManagerCustomName", 
        })
    end

    function SaveManager:CheckSubFolder(createFolder)
        if typeof(self.SubFolder) ~= "string" or self.SubFolder == "" then return false end

        if createFolder == true then
            if not isfolder(self.Folder .. "/settings/" .. self.SubFolder) then
                makefolder(self.Folder .. "/settings/" .. self.SubFolder)
            end
        end

        return true
    end

    function SaveManager:GetPaths()
        local paths = {}

        local parts = self.Folder:split("/")
        for idx = 1, #parts do
            local path = table.concat(parts, "/", 1, idx)
            if not table.find(paths, path) then paths[#paths + 1] = path end
        end

        paths[#paths + 1] = self.Folder .. "/themes"
        paths[#paths + 1] = self.Folder .. "/settings"

        if self:CheckSubFolder(false) then
            local subFolder = self.Folder .. "/settings/" .. self.SubFolder
            parts = subFolder:split("/")

            for idx = 1, #parts do
                local path = table.concat(parts, "/", 1, idx)
                if not table.find(paths, path) then paths[#paths + 1] = path end
            end
        end

        return paths
    end

    function SaveManager:BuildFolderTree()
        local paths = self:GetPaths()

        for i = 1, #paths do
            local str = paths[i]
            if isfolder(str) then continue end

            makefolder(str)
        end
    end

    function SaveManager:CheckFolderTree()
        if isfolder(self.Folder) then return end
        SaveManager:BuildFolderTree()

        task.wait(0.1)
    end

    function SaveManager:SetIgnoreIndexes(list)
        for _, key in pairs(list) do
            self.Ignore[key] = true
        end
    end

    function SaveManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    function SaveManager:SetSubFolder(folder)
        self.SubFolder = folder
        self:BuildFolderTree()
    end

    function SaveManager:Save(name)
        if (not name) then
            return false, "no config file is selected"
        end
        SaveManager:CheckFolderTree()

        local fullPath = self.Folder .. "/settings/" .. name .. ".json"
        if SaveManager:CheckSubFolder(true) then
            fullPath = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
        end

        local data = {
            objects = {}
        }

        for idx, value in pairs(self.Library.flags) do
            if self.Ignore[idx] then continue end
            
            if typeof(value) == "boolean" then
                table.insert(data.objects, self.Parser.Toggle.Save(idx, { value = value }))
            elseif typeof(value) == "number" then
                table.insert(data.objects, self.Parser.Slider.Save(idx, value))
            elseif typeof(value) == "string" then
                table.insert(data.objects, self.Parser.Textbox.Save(idx, value))
            elseif typeof(value) == "table" and value.key ~= nil then
                table.insert(data.objects, self.Parser.Keybind.Save(idx, value))
            elseif typeof(value) == "Color3" then
                table.insert(data.objects, self.Parser.Colorpicker.Save(idx, value))
            elseif typeof(value) == "EnumItem" or typeof(value) == "Instance" then
                -- Skip these types
            else
                table.insert(data.objects, self.Parser.Dropdown.Save(idx, value))
            end
        end

        local success, encoded = pcall(httpService.JSONEncode, httpService, data)
        if not success then
            return false, "failed to encode data"
        end

        writefile(fullPath, encoded)
        return true
    end

    function SaveManager:Load(name)
        if (not name) then
            return false, "no config file is selected"
        end
        SaveManager:CheckFolderTree()

        local file = self.Folder .. "/settings/" .. name .. ".json"
        if SaveManager:CheckSubFolder(true) then
            file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
        end

        if not isfile(file) then return false, "invalid file" end

        local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
        if not success then return false, "decode error" end

        for _, option in pairs(decoded.objects) do
            if not option.type then continue end
            if not self.Parser[option.type] then continue end

            task.spawn(self.Parser[option.type].Load, option.idx, option)
        end

        return true
    end

    function SaveManager:Delete(name)
        if (not name) then
            return false, "no config file is selected"
        end

        local file = self.Folder .. "/settings/" .. name .. ".json"
        if SaveManager:CheckSubFolder(true) then
            file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
        end

        if not isfile(file) then return false, "invalid file" end

        local success = pcall(delfile, file)
        if not success then return false, "delete file error" end

        return true
    end

    function SaveManager:RefreshConfigList()
        local success, data = pcall(function()
            SaveManager:CheckFolderTree()

            local list = {}
            local out = {}

            if SaveManager:CheckSubFolder(true) then
                list = listfiles(self.Folder .. "/settings/" .. self.SubFolder)
            else
                list = listfiles(self.Folder .. "/settings")
            end
            if typeof(list) ~= "table" then list = {} end

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
        end)

        if (not success) then
            if self.Library then
                self.Library.notifications:create_notification({name = "Save Manager", info = "Failed to load config list: " .. tostring(data)})
            else
                warn("Failed to load config list: " .. tostring(data))
            end

            return {}
        end

        return data
    end

    function SaveManager:GetAutoloadConfig()
        SaveManager:CheckFolderTree()

        local autoLoadPath = self.Folder .. "/settings/autoload.txt"
        if SaveManager:CheckSubFolder(true) then
            autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
        end

        if isfile(autoLoadPath) then
            local successRead, name = pcall(readfile, autoLoadPath)
            if not successRead then
                return "none"
            end

            name = tostring(name)
            return if name == "" then "none" else name
        end

        return "none"
    end

    function SaveManager:LoadAutoloadConfig()
        SaveManager:CheckFolderTree()

        local autoLoadPath = self.Folder .. "/settings/autoload.txt"
        if SaveManager:CheckSubFolder(true) then
            autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
        end

        if isfile(autoLoadPath) then
            local successRead, name = pcall(readfile, autoLoadPath)
            if not successRead then
                return self.Library.notifications:create_notification({name = "Save Manager", info = "Failed to load autoload config: write file error"})
            end

            local success, err = self:Load(name)
            if not success then
                return self.Library.notifications:create_notification({name = "Save Manager", info = "Failed to load autoload config: " .. err})
            end

            self.Library.notifications:create_notification({name = "Save Manager", info = "Auto loaded config: " .. name})
        end
    end

    function SaveManager:SaveAutoloadConfig(name)
        SaveManager:CheckFolderTree()

        local autoLoadPath = self.Folder .. "/settings/autoload.txt"
        if SaveManager:CheckSubFolder(true) then
            autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
        end

        local success = pcall(writefile, autoLoadPath, name)
        if not success then return false, "write file error" end

        return true, ""
    end

    function SaveManager:DeleteAutoLoadConfig()
        SaveManager:CheckFolderTree()

        local autoLoadPath = self.Folder .. "/settings/autoload.txt"
        if SaveManager:CheckSubFolder(true) then
            autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
        end

        local success = pcall(delfile, autoLoadPath)
        if not success then return false, "delete file error" end

        return true, ""
    end

    function SaveManager:SetupSaveManager()
        assert(self.Library, "Must set SaveManager.Library first!")

        self:BuildFolderTree()
        
        if not self.Library or not self.Library.window then
            return
        end
        
        local window = self.Library.window
        
        local configs = window:tab({name = "Save Manager", tabs = {"Configs"}})
        local column = configs:column({})
        local section = column:section({name = "Configuration", size = 1, default = true})

        section:textbox({name = "Config Name", flag = "SaveManagerConfigName"})

        section:button({name = "Create Config", callback = function()
            local name = self.Library.flags.SaveManagerConfigName

            if name:gsub(" ", "") == "" then
                return self.Library.notifications:create_notification({name = "Save Manager", info = "Invalid config name (empty)"})
            end

            local success, err = self:Save(name)
            if not success then
                return self.Library.notifications:create_notification({name = "Save Manager", info = "Failed to create config: " .. err})
            end

            self.Library.notifications:create_notification({name = "Save Manager", info = "Created config: " .. name})
            self.Library.flags.SaveManagerConfigList = self:RefreshConfigList()
        end})

        section:seperator({})

        section:dropdown({name = "Config List", flag = "SaveManagerConfigList", options = self:RefreshConfigList(), callback = function() end})

        section:button({name = "Load Config", callback = function()
            local name = self.Library.flags.SaveManagerConfigList
            if not name then return end
            
            local success, err = self:Load(name)
            if not success then
                return self.Library.notifications:create_notification({name = "Save Manager", info = "Failed to load config: " .. err})
            end

            self.Library.notifications:create_notification({name = "Save Manager", info = "Loaded config: " .. name})
        end})

        section:button({name = "Overwrite Config", callback = function()
            local name = self.Library.flags.SaveManagerConfigList
            if not name then return end
            
            local success, err = self:Save(name)
            if not success then
                return self.Library.notifications:create_notification({name = "Save Manager", info = "Failed to overwrite config: " .. err})
            end

            self.Library.notifications:create_notification({name = "Save Manager", info = "Overwrote config: " .. name})
        end})

        section:button({name = "Delete Config", callback = function()
            local name = self.Library.flags.SaveManagerConfigList
            if not name then return end
            
            local success, err = self:Delete(name)
            if not success then
                return self.Library.notifications:create_notification({name = "Save Manager", info = "Failed to delete config: " .. err})
            end

            self.Library.notifications:create_notification({name = "Save Manager", info = "Deleted config: " .. name})
            self.Library.flags.SaveManagerConfigList = self:RefreshConfigList()
        end})

        section:button({name = "Refresh List", callback = function()
            self.Library.flags.SaveManagerConfigList = self:RefreshConfigList()
        end})

        section:button({name = "Set as Autoload", callback = function()
            local name = self.Library.flags.SaveManagerConfigList
            if not name then return end
            
            local success, err = self:SaveAutoloadConfig(name)
            if not success then
                return self.Library.notifications:create_notification({name = "Save Manager", info = "Failed to set autoload config: " .. err})
            end

            self.autoloadLabel:SetText("Current autoload config: " .. name)
            self.Library.notifications:create_notification({name = "Save Manager", info = "Set autoload to: " .. name})
        end})

        section:button({name = "Reset Autoload", callback = function()
            local success, err = self:DeleteAutoLoadConfig()
            if not success then
                return self.Library.notifications:create_notification({name = "Save Manager", info = "Failed to reset autoload config: " .. err})
            end

            self.Library.notifications:create_notification({name = "Save Manager", info = "Reset autoload to none"})
            self.autoloadLabel:SetText("Current autoload config: none")
        end})

        self.autoloadLabel = section:label({text = "Current autoload config: " .. self:GetAutoloadConfig()})

        self:IgnoreThemeSettings()
        self:SetIgnoreIndexes({ "SaveManagerConfigList", "SaveManagerConfigName" })
    end

    SaveManager:BuildFolderTree()
end

return SaveManager
