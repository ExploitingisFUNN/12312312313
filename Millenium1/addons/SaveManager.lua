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

local SaveManager = {}
do
    SaveManager.Folder = "MilleniumConfigs"
    SaveManager.SubFolder = ""
    SaveManager.Ignore = {}
    SaveManager.Library = nil
    SaveManager.Parser = {
        Toggle = {
            Save = function(idx, object)
                return { type = "Toggle", idx = idx, value = object.Value }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Toggles[idx] then
                    SaveManager.Library.Toggles[idx]:SetValue(data.value)
                end
            end,
        },
        Slider = {
            Save = function(idx, object)
                return { type = "Slider", idx = idx, value = object.Value }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Options[idx] then
                    SaveManager.Library.Options[idx]:SetValue(data.value)
                end
            end,
        },
        Dropdown = {
            Save = function(idx, object)
                return { type = "Dropdown", idx = idx, value = object.Value, values = object.Values }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Options[idx] then
                    SaveManager.Library.Options[idx]:SetValue(data.value)
                end
            end,
        },
        ColorPicker = {
            Save = function(idx, object)
                return { type = "ColorPicker", idx = idx, value = object.Value:ToHex() }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Options[idx] then
                    SaveManager.Library.Options[idx]:SetValueRGB(Color3.fromHex(data.value))
                end
            end,
        },
        KeyPicker = {
            Save = function(idx, object)
                return { type = "KeyPicker", idx = idx, mode = object.Mode, key = object.Value }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Options[idx] then
                    SaveManager.Library.Options[idx]:SetValue({ data.key, data.mode })
                end
            end,
        },
        Input = {
            Save = function(idx, object)
                return { type = "Input", idx = idx, text = object.Value }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Options[idx] then
                    SaveManager.Library.Options[idx]:SetValue(data.text)
                end
            end,
        },
    }

    function SaveManager:SetLibrary(library)
        self.Library = library
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

    function SaveManager:SetSubFolder(subfolder)
        self.SubFolder = subfolder
    end

    function SaveManager:BuildFolderTree()
        local paths = {
            self.Folder,
            self.Folder .. "/configs",
            self.Folder .. "/settings"
        }

        for i = 1, #paths do
            local path = paths[i]
            if not isfolder(path) then
                pcall(makefolder, path)
            end
        end

        if self.SubFolder and self.SubFolder ~= "" then
            local subfolderPath = self.Folder .. "/settings/" .. self.SubFolder
            if not isfolder(subfolderPath) then
                pcall(makefolder, subfolderPath)
            end
            local configSubPath = self.Folder .. "/configs/" .. self.SubFolder
            if not isfolder(configSubPath) then
                pcall(makefolder, configSubPath)
            end
        end
    end

    function SaveManager:CheckSubFolder(createIfNotExist)
        if self.SubFolder and self.SubFolder ~= "" then
            local path = self.Folder .. "/settings/" .. self.SubFolder
            if not isfolder(path) and createIfNotExist then
                pcall(makefolder, path)
            end
            return isfolder(path)
        end
        return false
    end

    function SaveManager:Save(name)
        if not name or type(name) ~= "string" or name:gsub(" ", "") == "" then
            return false, "invalid name"
        end

        self:BuildFolderTree()

        local configPath
        if self:CheckSubFolder(true) then
            configPath = string.format("%s/configs/%s/%s.json", self.Folder, self.SubFolder, name)
        else
            configPath = string.format("%s/configs/%s.json", self.Folder, name)
        end

        local data = {}
        for idx, option in pairs(self.Library.Options) do
            if not self.Ignore[idx] then
                local parser = self.Parser[option.Type]
                if parser then
                    data[idx] = parser.Save(idx, option)
                end
            end
        end

        local success, err = pcall(writefile, configPath, httpService:JSONEncode(data))

        return success, err or ""
    end

    function SaveManager:Load(name)
        if not name or type(name) ~= "string" or name:gsub(" ", "") == "" then
            return false, "invalid name"
        end

        self:BuildFolderTree()

        local configPath
        if self:CheckSubFolder(true) then
            configPath = string.format("%s/configs/%s/%s.json", self.Folder, self.SubFolder, name)
        else
            configPath = string.format("%s/configs/%s.json", self.Folder, name)
        end

        if not isfile(configPath) then
            return false, "invalid file"
        end

        local success, data = pcall(function()
            return httpService:JSONDecode(readfile(configPath))
        end)

        if not success or type(data) ~= "table" then
            return false, "invalid data"
        end

        for idx, option in pairs(data) do
            local parser = self.Parser[option.type]
            if parser then
                parser.Load(idx, option)
            end
        end

        return true, ""
    end

    function SaveManager:Delete(name)
        if not name or type(name) ~= "string" or name:gsub(" ", "") == "" then
            return false, "invalid name"
        end

        self:BuildFolderTree()

        local configPath
        if self:CheckSubFolder(true) then
            configPath = string.format("%s/configs/%s/%s.json", self.Folder, self.SubFolder, name)
        else
            configPath = string.format("%s/configs/%s.json", self.Folder, name)
        end

        if not isfile(configPath) then
            return false, "invalid file"
        end

        local success = pcall(function()
            return delfile(configPath)
        end)

        return success, ""
    end

    function SaveManager:SaveAutoloadConfig(name)
        if not name or type(name) ~= "string" or name:gsub(" ", "") == "" then
            return false, "invalid name"
        end

        self:BuildFolderTree()

        local autoLoadPath
        if self:CheckSubFolder(true) then
            autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
        else
            autoLoadPath = self.Folder .. "/settings/autoload.txt"
        end

        local success, err = pcall(function()
            return writefile(autoLoadPath, name)
        end)

        return success, err or ""
    end

    function SaveManager:DeleteAutoLoadConfig()
        self:BuildFolderTree()

        local autoLoadPath
        if self:CheckSubFolder(true) then
            autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
        else
            autoLoadPath = self.Folder .. "/settings/autoload.txt"
        end

        if not isfile(autoLoadPath) then
            return true
        end

        local success = pcall(function()
            return delfile(autoLoadPath)
        end)

        return success, ""
    end

    function SaveManager:GetAutoloadConfig()
        self:BuildFolderTree()

        local autoLoadPath
        if self:CheckSubFolder(true) then
            autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
        else
            autoLoadPath = self.Folder .. "/settings/autoload.txt"
        end

        if isfile(autoLoadPath) then
            local success, name = pcall(readfile, autoLoadPath)
            if not success then
                return "none"
            end

            name = tostring(name)
            return name == "" and "none" or name
        end

        return "none"
    end

    function SaveManager:LoadAutoloadConfig()
        self:BuildFolderTree()

        local name = self:GetAutoloadConfig()
        if name ~= "none" then
            self:Load(name)
        end
    end

    function SaveManager:IgnoreThemeSettings()
        self:SetIgnoreIndexes({
            "BackgroundColor",
            "MainColor",
            "AccentColor",
            "OutlineColor",
            "FontColor",
            "ThemeManager_ThemeList",
            "ThemeManager_CustomThemeList",
            "ThemeManager_CustomThemeName"
        })
    end

    function SaveManager:RefreshConfigList()
        self:BuildFolderTree()

        local configPath
        if self:CheckSubFolder(true) then
            configPath = string.format("%s/configs/%s", self.Folder, self.SubFolder)
        else
            configPath = string.format("%s/configs", self.Folder)
        end


        if not isfolder(configPath) then
            pcall(makefolder, configPath)
        end

        local success, data = pcall(function()
            local files = listfiles(configPath)
            local out = {}

            if files then
                for _, file in ipairs(files) do
                    if type(file) == "string" and file:sub(-5) == ".json" then
                        local filename = file:match("([^/\\]+)%.json$")
                        if filename then
                            table.insert(out, filename)
                        end
                    end
                end
            end

            return out
        end)

        if not success then
            if self.Library then
                self.Library:Notify("Failed to load config list: " .. tostring(data))
            else
                warn("Failed to load config list: " .. tostring(data))
            end
            return {"None"}
        end

        if #data == 0 then
            table.insert(data, "None")
        end

        return data
    end

    function SaveManager:SetupSaveManager(TabObj)
        assert(self.Library, "Must set SaveManager.Library first!")

        self:BuildFolderTree()
        
        if not self.Library then
            return
        end
        
        local section
        
        if TabObj then
            section = TabObj:AddRightGroupbox("Configuration")
        else
            if not self.Library.window then
                if type(self.Library.CreateWindow) == "function" then
                    self.Library.window = self.Library:CreateWindow({Title = "Save Manager"})
                else
                    return
                end
            end
            
            local window = self.Library.window
            
            local configs = window:tab({name = "Save Manager", tabs = {"Configs"}})
            local column = configs:column({})
            section = column:section({name = "Configuration", size = 1, default = true})
        end

        local configNameBox = section:textbox({name = "Config Name", flag = "SaveManagerConfigName"})
        if not configNameBox then
            return
        end

        section:button({name = "Create Config", callback = function()
            local name = self.Library.flags and self.Library.flags.SaveManagerConfigName or ""
            
            if name:gsub(" ", "") == "" then
                self.Library:Notify("Invalid config name (empty)")
                return
            end
            
            local success, err = self:Save(name)
            if not success then
                self.Library:Notify("Failed to create config: " .. err)
                return
            end
            
            self.Library:Notify("Created config: " .. name)
            local newList = self:RefreshConfigList()
            if self.Library.Options.SaveManagerConfigList and self.Library.Options.SaveManagerConfigList.SetValues then
                self.Library.Options.SaveManagerConfigList:SetValues(newList)
            end
        end})

        section:seperator({})

        local configList = self:RefreshConfigList()
        if #configList == 0 then
            table.insert(configList, "None")
        end
        section:dropdown({name = "Config List", flag = "SaveManagerConfigList", options = configList})
        
        section:button({name = "Load Config", callback = function()
            local name = self.Library.flags.SaveManagerConfigList
            if not name or name == "None" then
                self.Library:Notify("No config selected")
                return
            end
            
            local success, err = self:Load(name)
            if not success then
                self.Library:Notify("Failed to load config: " .. err)
                return
            end
            
            self.Library:Notify("Loaded config: " .. name)
        end})
        
        section:button({name = "Overwrite Config", callback = function()
            local name = self.Library.flags.SaveManagerConfigList
            if not name or name == "None" then
                self.Library:Notify("No config selected")
                return
            end
            
            local success, err = self:Save(name)
            if not success then
                self.Library:Notify("Failed to overwrite config: " .. err)
                return
            end
            
            self.Library:Notify("Overwrote config: " .. name)
        end})
        
        section:button({name = "Delete Config", callback = function()
            local name = self.Library.flags.SaveManagerConfigList
            if not name or name == "None" then
                self.Library:Notify("No config selected")
                return
            end
            
            local success, err = self:Delete(name)
            if not success then
                self.Library:Notify("Failed to delete config: " .. err)
                return
            end
            
            self.Library:Notify("Deleted config: " .. name)
            local newList = self:RefreshConfigList()
            if #newList == 0 then
                table.insert(newList, "None")
            end
            if self.Library.Options.SaveManagerConfigList and self.Library.Options.SaveManagerConfigList.SetValues then
                self.Library.Options.SaveManagerConfigList:SetValues(newList)
            end
        end})
        
        section:button({name = "Refresh List", callback = function()
            local newList = self:RefreshConfigList()
            if #newList == 0 then
                table.insert(newList, "None")
            end
            if self.Library.Options.SaveManagerConfigList and self.Library.Options.SaveManagerConfigList.SetValues then
                self.Library.Options.SaveManagerConfigList:SetValues(newList)
            end
        end})
        
        section:seperator({})
        
        section:button({name = "Set as Autoload", callback = function()
            local name = self.Library.flags.SaveManagerConfigList
            if not name or name == "None" then
                self.Library:Notify("No config selected")
                return
            end
            
            local success, err = self:SaveAutoloadConfig(name)
            if not success then
                self.Library:Notify("Failed to set autoload config: " .. err)
                return
            end
            
            self.Library:Notify("Set autoload config: " .. name)
        end})
        
        section:button({name = "Clear Autoload", callback = function()
            local success, err = self:DeleteAutoLoadConfig()
            if not success then
                self.Library:Notify("Failed to clear autoload config: " .. err)
                return
            end
            
            self.Library:Notify("Cleared autoload config")
        end})
        
        section:label({text = "Current autoload config: " .. self:GetAutoloadConfig()})
        
        self:SetIgnoreIndexes({"SaveManagerConfigList", "SaveManagerConfigName"})
    end

    SaveManager:BuildFolderTree()
end

return SaveManager