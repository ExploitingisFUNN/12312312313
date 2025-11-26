--[[

    Milenium Library
    -> Made by @finobe 
    -> Kind of got bored idk what to do with life
    -> Idk who or why this got leaked, ui was VERY popular and high in demand with customers
]]

-- Variables 
local uis = game:GetService("UserInputService") 
local players = game:GetService("Players") 
local ws = game:GetService("Workspace")
local rs = game:GetService("ReplicatedStorage")
local http_service = game:GetService("HttpService")
local gui_service = game:GetService("GuiService")
local lighting = game:GetService("Lighting")
local run = game:GetService("RunService")
local stats = game:GetService("Stats")
local coregui = game:GetService("CoreGui")
local debris = game:GetService("Debris")
local tween_service = game:GetService("TweenService")
local sound_service = game:GetService("SoundService")

local vec2 = Vector2.new
local vec3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new 
local rect = Rect.new
local cfr = CFrame.new
local empty_cfr = cfr()
local point_object_space = empty_cfr.PointToObjectSpace
local angle = CFrame.Angles
local dim_offset = UDim2.fromOffset

local color = Color3.new
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local hsv = Color3.fromHSV
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new
local numseq = NumberSequence.new
local numkey = NumberSequenceKeypoint.new

local camera = ws.CurrentCamera
local lp = players.LocalPlayer 
local mouse = lp:GetMouse() 
local gui_offset = gui_service:GetGuiInset().Y

local max = math.max 
local floor = math.floor 
local min = math.min 
local abs = math.abs 
local noise = math.noise
local rad = math.rad 
local random = math.random 
local pow = math.pow 
local sin = math.sin 
local pi = math.pi 
local tan = math.tan 
local atan2 = math.atan2 
local clamp = math.clamp 

local insert = table.insert 
local find = table.find 
local remove = table.remove
local concat = table.concat
-- 

-- Library init
getgenv().    library = {
        directory = "milenium",
        folders = {
            "/fonts",
            "/configs",
        },
        flags = {},
        flag_objects = {},
        connections = {},   
        notifications = {notifs = {}},
        current_open;
        config = {
            folder = "milenium/configs",
            current = nil,
            autoload_file = "milenium/autoload.txt"
        }
    }

local themes = {
    preset = {
        accent = rgb(240, 80, 61),
    }, 

    utility = {
        accent = {
            BackgroundColor3 = {}, 	
            TextColor3 = {}, 
            ImageColor3 = {}, 
            ScrollBarImageColor3 = {},
            Color = {}
        },
    }
}

local keys = {
    [Enum.KeyCode.LeftShift] = "LS",
    [Enum.KeyCode.RightShift] = "RS",
    [Enum.KeyCode.LeftControl] = "LC",
    [Enum.KeyCode.RightControl] = "RC",
    [Enum.KeyCode.Insert] = "INS",
    [Enum.KeyCode.Backspace] = "BS",
    [Enum.KeyCode.Return] = "Ent",
    [Enum.KeyCode.LeftAlt] = "LA",
    [Enum.KeyCode.RightAlt] = "RA",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.KeypadOne] = "Num1",
    [Enum.KeyCode.KeypadTwo] = "Num2",
    [Enum.KeyCode.KeypadThree] = "Num3",
    [Enum.KeyCode.KeypadFour] = "Num4",
    [Enum.KeyCode.KeypadFive] = "Num5",
    [Enum.KeyCode.KeypadSix] = "Num6",
    [Enum.KeyCode.KeypadSeven] = "Num7",
    [Enum.KeyCode.KeypadEight] = "Num8",
    [Enum.KeyCode.KeypadNine] = "Num9",
    [Enum.KeyCode.KeypadZero] = "Num0",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.Tilde] = "~",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.RightParenthesis] = ")",
    [Enum.KeyCode.LeftParenthesis] = "(",
    [Enum.KeyCode.Semicolon] = ",",
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = "\\",
    [Enum.KeyCode.Comma] = ",",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Asterisk] = "*",
    [Enum.KeyCode.Plus] = "+",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
    [Enum.KeyCode.Escape] = "ESC",
    [Enum.KeyCode.Space] = "SPC",
}
    
library.__index = library

for _, path in next, library.folders do 
    makefolder(library.directory .. path)
end

local flags = library.flags
local notifications = library.notifications 

if run:IsStudio() then
    if uis.TouchEnabled and not uis.MouseEnabled then
        library.is_mobile = true
    else
        library.is_mobile = false
    end
else
    pcall(function()
        library.device_platform = uis:GetPlatform()
    end)
    library.is_mobile = (library.device_platform == Enum.Platform.Android or library.device_platform == Enum.Platform.IOS)
end
library.cant_drag_forced = false

local fonts = {}; do
    function Register_Font(Name, Weight, Style, Asset)
        if not isfile(Asset.Id) then
            writefile(Asset.Id, Asset.Font)
        end

        if isfile(Name .. ".font") then
            delfile(Name .. ".font")
        end

        local Data = {
            name = Name,
            faces = {
                {
                    name = "Normal",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Asset.Id),
                },
            },
        }

        writefile(Name .. ".font", http_service:JSONEncode(Data))

        return getcustomasset(Name .. ".font");
    end
    
    local Medium = Register_Font("Medium", 200, "Normal", {
        Id = "Medium.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf"),
    })

    local SemiBold = Register_Font("SemiBold", 200, "Normal", {
        Id = "SemiBold.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf"),
    })

    fonts = {
        small = Font.new(Medium, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        font = Font.new(SemiBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    }
end
--

-- Google Translate Integration
local function req(opt)
    local fn=(syn and syn.request) or (http and http.request) or http_request or request
    if fn then return fn(opt) end
    return http_service:RequestAsync(opt)
end

local gv=isfile and isfile("googlev.txt") and readfile("googlev.txt") or ""

local function consent(body)
    local t={}
    for tag in body:gmatch('<input type="hidden" name=".-" value=".-">') do
        local k,v=tag:match('<input type="hidden" name="(.-)" value="(.-)">'); t[k]=v
    end
    gv=t.v or ""; if writefile then writefile("googlev.txt",gv) end
end

local function got(url,method,body)
    method=method or "GET"
    local res=req({Url=url,Method=method,Headers={cookie="CONSENT=YES+"..(gv or "")},Body=body})
    local b=res.Body or res.body or ""; if type(b)~="string" then b=tostring(b) end
    if b:match("https://consent.google.com/s") then
        consent(b)
        res=req({Url=url,Method="GET",Headers={cookie="CONSENT=YES+"..(gv or "")}})
    end
    return res
end

local langs={
    auto="Automatic",af="Afrikaans",sq="Albanian",am="Amharic",ar="Arabic",hy="Armenian",az="Azerbaijani",eu="Basque",be="Belarusian",bn="Bengali",bs="Bosnian",bg="Bulgarian",ca="Catalan",ceb="Cebuano",ny="Chichewa",
    ["zh-cn"]="Chinese Simplified",["zh-tw"]="Chinese Traditional",co="Corsican",hr="Croatian",cs="Czech",da="Danish",nl="Dutch",en="English",eo="Esperanto",et="Estonian",tl="Filipino",fi="Finnish",fr="French",fy="Frisian",
    gl="Galician",ka="Georgian",de="German",el="Greek",gu="Gujarati",ht="Haitian Creole",ha="Hausa",haw="Hawaiian",iw="Hebrew",hi="Hindi",hmn="Hmong",hu="Hungarian",is="Icelandic",ig="Igbo",id="Indonesian",ga="Irish",it="Italian",
    ja="Japanese",jw="Javanese",kn="Kannada",kk="Kazakh",km="Khmer",ko="Korean",ku="Kurdish (Kurmanji)",ky="Kyrgyz",lo="Lao",la="Latin",lv="Latvian",lt="Lithuanian",lb="Luxembourgish",mk="Macedonian",mg="Malagasy",ms="Malay",
    ml="Malayalam",mt="Maltese",mi="Maori",mr="Marathi",mn="Mongolian",my="Myanmar (Burmese)",ne="Nepali",no="Norwegian",ps="Pashto",fa="Persian",pl="Polish",pt="Portuguese",pa="Punjabi",ro="Romanian",ru="Russian",sm="Samoan",
    gd="Scots Gaelic",sr="Serbian",st="Sesotho",sn="Shona",sd="Sindhi",si="Sinhala",sk="Slovak",sl="Slovenian",so="Somali",es="Spanish",su="Sundanese",sw="Swahili",sv="Swedish",tg="Tajik",ta="Tamil",te="Telugu",th="Thai",tr="Turkish",
    uk="Ukrainian",ur="Urdu",uz="Uzbek",vi="Vietnamese",cy="Welsh",xh="Xhosa",yi="Yiddish",yo="Yoruba",zu="Zulu"
}

local function iso(s)
    if not s then return end
    for k,v in pairs(langs) do if k==s or v==s then return k end end
end

local function q(data)
    local s=""
    for k,v in pairs(data) do
        if type(v)=="table" then for _,vv in pairs(v) do s..="&"..http_service:UrlEncode(k).."="..http_service:UrlEncode(vv) end
        else s..="&"..http_service:UrlEncode(k).."="..http_service:UrlEncode(v) end
    end
    return s:sub(2)
end

local jE=function(x) return http_service:JSONEncode(x) end
local jD=function(x) return http_service:JSONDecode(x) end

local rpc="MkEWBc"
local root="https://translate.google.com/"
local exec="https://translate.google.com/_/TranslateWebserverUi/data/batchexecute"
local fsid,bl,rid=nil,nil,math.random(1000,9999)

task.spawn(function()
    pcall(function()
        local b=(got(root).Body or "")
        fsid=b:match('"FdrFJe":"(.-)"'); bl=b:match('"cfb2h":"(.-)"')
        if fsid and bl then
            print("[Translator] Google API initialized successfully")
        else
            warn("[Translator] Failed to initialize Google API")
        end
    end)
end)

local function translate(txt,tgt,src)
    if not txt or txt == "" then return txt end
    if not fsid or not bl then 
        warn("[Translator] Google API not initialized")
        return txt 
    end
    
    local success, result = pcall(function()
        rid+=10000
        tgt=iso(tgt) or "en"; src=iso(src) or "auto"
        local data={{txt,src,tgt,true},{nil}}
        local freq={{{rpc,jE(data),nil,"generic"}}}
        local url=exec.."?"..q{rpcids=rpc,["f.sid"]=fsid,bl=bl,hl="en",_reqid=rid-10000,rt="c"}
        local body=q{["f.req"]=jE(freq)}
        local res=got(url,"POST",body)
        
        if not res or not res.Body then
            warn("[Translator] No response from Google")
            return nil
        end
        
        local ok,out=pcall(function() 
            local arr=jD((res.Body or ""):match("%[.-%]\n"))
            if not arr then return nil end
            local decoded = jD(arr[1][3])
            if not decoded then return nil end
            return decoded[2][1][1][6][1][1]
        end)
        
        if not ok then 
            return nil 
        end
        return out
    end)
    
    if not success then
        warn("[Translator] Error translating:", txt, result)
        return txt
    end
    
    return result or txt
end

local translator = {
    enabled = false,
    current_lang = "en",
    text_elements = {},
    original_texts = {},
    rich_text_patterns = {},
    registered_count = 0
}

function translator:add_element(element, property, rich_text_format)
    if not element or not property then return end
    local id = tostring(element)
    local ok, debug_id = pcall(function()
        return element:GetDebugId()
    end)
    if ok and debug_id then
        id = tostring(debug_id)
    end
    if not self.original_texts[id] then
        self.original_texts[id] = element[property]
    end
    self.text_elements[id] = {elem = element, prop = property}
    if rich_text_format then
        self.rich_text_patterns[id] = rich_text_format
    end
    self.registered_count += 1
end

function translator:strip_rich_text(text)
    if not text then return "" end
    local plain = text:gsub("<[^>]+>", "")
    return plain
end

function translator:apply_rich_text(text, pattern)
    if not pattern then return text end
    return string.format(pattern, text)
end

function translator:translate_all()
    if not self.enabled or self.current_lang == "en" then
        for id, data in pairs(self.text_elements) do
            if data.elem and self.original_texts[id] then
                pcall(function()
                    data.elem[data.prop] = self.original_texts[id]
                end)
            end
        end
        return
    end
    
    task.spawn(function()
        local texts_to_translate = {}
        local element_map = {}
        
        for id, data in pairs(self.text_elements) do
            if data.elem and self.original_texts[id] and data.elem.Parent then
                local original = self.original_texts[id]
                local plain_text = self:strip_rich_text(original)
                
                if plain_text ~= "" and plain_text ~= " " and #plain_text > 0 then
                    table.insert(texts_to_translate, plain_text)
                    table.insert(element_map, {
                        id = id,
                        data = data,
                        original = original
                    })
                end
            end
        end
        
        if #texts_to_translate == 0 then return end
        
        local translated_count = 0
        local batch_size = 10
        
        for batch_start = 1, #texts_to_translate, batch_size do
            local batch_end = math.min(batch_start + batch_size - 1, #texts_to_translate)
            local batch_texts = {}
            
            for i = batch_start, batch_end do
                table.insert(batch_texts, texts_to_translate[i])
            end
            
            local separator = " §§§ "
            local combined = table.concat(batch_texts, separator)
            local translated_combined = translate(combined, self.current_lang, "auto")
            
            if translated_combined and translated_combined ~= "" then
                local translated_parts = {}
                for part in translated_combined:gmatch("([^§]+)") do
                    local trimmed = part:gsub("^%s*", ""):gsub("%s*$", "")
                    if trimmed ~= "" then
                        table.insert(translated_parts, trimmed)
                    end
                end
                
                for i = 1, math.min(#translated_parts, #batch_texts) do
                    local map_index = batch_start + i - 1
                    local map = element_map[map_index]
                    local translated_text = translated_parts[i]
                    
                    if map and translated_text then
                        local final_text = translated_text
                        
                        if self.rich_text_patterns[map.id] then
                            final_text = self:apply_rich_text(final_text, self.rich_text_patterns[map.id])
                        elseif map.original:match("<.->") then
                            local prefix = map.original:match("^(<.->)")
                            local suffix = map.original:match("(<.->)$")
                            if prefix and suffix then
                                final_text = prefix .. final_text .. suffix
                            end
                        end
                        
                        local success = pcall(function()
                            map.data.elem[map.data.prop] = final_text
                        end)
                        
                        if success then
                            translated_count = translated_count + 1
                        end
                    end
                end
            end
            
            if batch_end < #texts_to_translate then
                task.wait(0.15)
            end
        end
        
        print(string.format("[Translator] Translated %d/%d elements in %d batches", translated_count, #element_map, math.ceil(#element_map / batch_size)))
    end)
end

getgenv().translator = translator

function translator:create_language_dropdown(parent_section)
    if not parent_section then 
        warn("[Translator] No parent section provided for language dropdown")
        return 
    end
    
    parent_section:dropdown({
        name = "Language",
        options = {
            "English", "Spanish", "French", "German", "Japanese", "Korean", 
            "Chinese Simplified", "Russian", "Portuguese", "Italian", "Arabic", 
            "Hindi", "Thai", "Vietnamese", "Turkish", "Dutch", "Polish", 
            "Swedish", "Finnish", "Norwegian"
        },
        default = "English",
        seperator = false,
        callback = function(selected)
            local lang_map = {
                ["English"] = "en", ["Spanish"] = "es", ["French"] = "fr",
                ["German"] = "de", ["Japanese"] = "ja", ["Korean"] = "ko",
                ["Chinese Simplified"] = "zh-cn", ["Russian"] = "ru",
                ["Portuguese"] = "pt", ["Italian"] = "it", ["Arabic"] = "ar",
                ["Hindi"] = "hi", ["Thai"] = "th", ["Vietnamese"] = "vi",
                ["Turkish"] = "tr", ["Dutch"] = "nl", ["Polish"] = "pl",
                ["Swedish"] = "sv", ["Finnish"] = "fi", ["Norwegian"] = "no"
            }
            
            self.current_lang = lang_map[selected] or "en"
            self.enabled = (self.current_lang ~= "en")
            
            local element_count = 0
            for _ in pairs(self.text_elements) do
                element_count = element_count + 1
            end
            print(string.format("[Translator] Found %d registered elements", element_count))
            
            if not fsid or not bl then
                warn("[Translator] Google API not initialized! Waiting...")
                task.wait(2)
            end
            
            self:translate_all()
        end
    })
end
--

-- Library functions 
-- Misc functions
    function library:tween(obj, properties, easing_style, time) 
        local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()
            
        return tween
    end

    function library:resizify(frame) 
        local Frame = Instance.new("TextButton")
        Frame.Position = dim2(1, -10, 1, -10)
        Frame.BorderColor3 = rgb(0, 0, 0)
        Frame.Size = dim2(0, 10, 0, 10)
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = rgb(255, 255, 255)
        Frame.Parent = frame
        Frame.BackgroundTransparency = 1 
        Frame.Text = ""

        local resizing = false 
        local start_size 
        local start 
        local og_size = frame.Size  

        Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                start = input.Position
                start_size = frame.Size
            end
        end)

        Frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = false
            end
        end)

        library:connection(uis.InputChanged, function(input, game_event) 
            if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local viewport_x = camera.ViewportSize.X
                local viewport_y = camera.ViewportSize.Y

                local current_size = dim2(
                    start_size.X.Scale,
                    math.clamp(
                        start_size.X.Offset + (input.Position.X - start.X),
                        og_size.X.Offset,
                        viewport_x
                    ),
                    start_size.Y.Scale,
                    math.clamp(
                        start_size.Y.Offset + (input.Position.Y - start.Y),
                        og_size.Y.Offset,
                        viewport_y
                    )
                )

                library:tween(frame, {Size = current_size}, Enum.EasingStyle.Linear, 0.05)
            end
        end)
    end 

    function fag(tbl)
        local Size = 0
        
        for _ in tbl do
            Size = Size + 1
        end
    
        return Size
    end
    
    function library:next_flag()
        local index = fag(library.flags) + 1;
        local str = string.format("flagnumber%s", index)
        
        return str;
    end 

    function library:mouse_in_frame(uiobject)
        local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
        local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

        return (y_cond and x_cond)
    end

    function library:draggify(frame, ignore_lock)
        local dragging = false 
        local start_size = frame.Position
        local start 

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if library.dragIgnore and input.Target and (input.Target == library.dragIgnore or input.Target:IsDescendantOf(library.dragIgnore)) then return end
                if not ignore_lock and library.cant_drag_forced then return end
                dragging = true
                start = input.Position
                start_size = frame.Position
            end
        end)

        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        library:connection(uis.InputChanged, function(input, game_event) 
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local viewport_x = camera.ViewportSize.X
                local viewport_y = camera.ViewportSize.Y

                local current_position = dim2(
                    0,
                    clamp(
                        start_size.X.Offset + (input.Position.X - start.X),
                        0,
                        viewport_x - frame.Size.X.Offset
                    ),
                    0,
                    math.clamp(
                        start_size.Y.Offset + (input.Position.Y - start.Y),
                        0,
                        viewport_y - frame.Size.Y.Offset
                    )
                )

                library:tween(frame, {Position = current_position}, Enum.EasingStyle.Linear, 0.05)
                library:close_element()
            end
        end)
    end 

    function library:convert(str)
        local values = {}

        for value in string.gmatch(str, "[^,]+") do
            insert(values, tonumber(value))
        end
        
        if #values == 4 then              
            return unpack(values)
        else 
            return
        end
    end
    
    function library:convert_enum(enum)
        local enum_parts = {}
    
        for part in string.gmatch(enum, "[%w_]+") do
            insert(enum_parts, part)
        end
    
        local enum_table = Enum
        for i = 2, #enum_parts do
            local enum_item = enum_table[enum_parts[i]]
    
            enum_table = enum_item
        end
    
        return enum_table
    end






    
    function library:round(number, float) 
        local multiplier = 1 / (float or 1)

        return floor(number * multiplier + 0.5) / multiplier
    end 

    function library:apply_theme(instance, theme, property)
        if not instance then return end
        if not themes.utility[theme] then return end
        if not themes.utility[theme][property] then 
            themes.utility[theme][property] = {}
        end
        insert(themes.utility[theme][property], instance)
    end

    function library:update_theme(theme, color)
        for _, property in themes.utility[theme] do 

            for m, object in property do 
                if object[_] == themes.preset[theme] then 
                    object[_] = color 
                end 
            end 
        end 

        themes.preset[theme] = color 
    end 

    function library:connection(signal, callback)
        local connection = signal:Connect(callback)
        
        insert(library.connections, connection)

        return connection 
    end

    function library:close_element(new_path) 
        local open_element = library.current_open

        if open_element and new_path ~= open_element then
            open_element.set_visible(false)
            open_element.open = false;
        end 

        if new_path ~= open_element then 
            library.current_open = new_path or nil;
        end
    end 

    function library:create(instance, options)
        local ins = Instance.new(instance) 
        
        for prop, value in options do 
            ins[prop] = value
        end
        
        return ins 
    end

    function library:unload_menu() 
        if library[ "items" ] then 
            library[ "items" ]:Destroy()
        end

        if library[ "other" ] then 
            library[ "other" ]:Destroy()
        end 
        
        for index, connection in library.connections do 
            connection:Disconnect() 
            connection = nil 
        end
        
        library = nil 
    end 
--

-- Library element functions
    function library:window(properties)
        local cfg = { 
            suffix = properties.suffix or properties.Suffix or "";
            name = properties.name or properties.Name or "";
            game_name = properties.gameInfo or properties.game_info or properties.GameInfo or "";
            footer = properties.footer or properties.Footer or "";
            size = properties.size or properties.Size or (library.is_mobile and dim2(0, 480, 0, 360) or dim2(0, 700, 0, 565));
            selected_tab;
            items = {};

            tween;
        }
        
        library[ "cache" ] = Instance.new("Folder")
        library[ "cache" ].Name = "\0"
        library[ "cache" ].Parent = coregui;

        library[ "items" ] = library:create( "ScreenGui" , {
            Parent = coregui;
            Name = "\0";
            Enabled = true;
            ZIndexBehavior = Enum.ZIndexBehavior.Global;
            IgnoreGuiInset = true;
        });
        
        library[ "other" ] = library:create( "ScreenGui" , {
            Parent = coregui;
            Name = "\0";
            Enabled = false;
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
            IgnoreGuiInset = true;
        }); 
        
        if library.is_mobile and not library[ "mobile" ] then
            library[ "mobile" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            });
        end

        local items = cfg.items; do
            items[ "main" ] = library:create( "Frame" , {
                Parent = library[ "items" ];
                Size = cfg.size;
                Name = "\0";
                Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
                BorderColor3 = rgb(0, 0, 0);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(14, 14, 16);
                ClipsDescendants = true
            }); items[ "main" ].Position = dim2(0, items[ "main" ].AbsolutePosition.X, 0, items[ "main" ].AbsolutePosition.Y)
            
            library:create( "UICorner" , {
                Parent = items[ "main" ];
                CornerRadius = dim(0, 10)
            });
            
            library:create( "UIStroke" , {
                Color = rgb(23, 23, 29);
                Parent = items[ "main" ];
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            });
            
            items[ "side_frame" ] = library:create( "Frame" , {
                Parent = items[ "main" ];
                BackgroundTransparency = 1;
                Name = "\0";
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 196, 1, -25);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(14, 14, 16)
            });
            
            library:create( "Frame" , {
                AnchorPoint = vec2(1, 0);
                Parent = items[ "side_frame" ];
                Position = dim2(1, 0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 1, 1, 0);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(21, 21, 23)
            });
            
            items[ "button_holder" ] = library:create( "ScrollingFrame" , {
                Parent = items[ "side_frame" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Position = dim2(0, 0, 0, 60);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 0, 1, -60);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
                ScrollBarThickness = library.is_mobile and 4 or 2;
                AutomaticCanvasSize = Enum.AutomaticSize.Y;
                CanvasSize = dim2(0,0,0,0);
                ScrollingDirection = Enum.ScrollingDirection.Y;
                ClipsDescendants = true;
                Active = true;
                ScrollBarImageColor3 = themes.preset.accent;
                ScrollingEnabled = true
            }); cfg.button_holder = items[ "button_holder" ];
            library:apply_theme(items[ "button_holder" ], "accent", "ScrollBarImageColor3");
            
            library:create( "UIListLayout" , {
                Parent = items[ "button_holder" ];
                Padding = dim(0, 5);
                SortOrder = Enum.SortOrder.LayoutOrder
            });
            
            library:create( "UIPadding" , {
                PaddingTop = dim(0, 16);
                PaddingBottom = dim(0, 36);
                Parent = items[ "button_holder" ];
                PaddingRight = dim(0, 11);
                PaddingLeft = dim(0, 10)
            });

            local accent = themes.preset.accent
            items[ "title" ] = library:create( "TextLabel" , {
                FontFace = fonts.font;
                BorderColor3 = rgb(0, 0, 0);
                Text = name;
                Parent = items[ "side_frame" ];
                Name = "\0";
                Text = string.format('<u>%s</u>', cfg.name);
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 0, 70);
                TextColor3 = themes.preset.accent;
                BorderSizePixel = 0;
                RichText = true;
                TextSize = 30;
                BackgroundColor3 = rgb(255, 255, 255)
            }); library:apply_theme(items[ "title" ], "accent", "TextColor3");
            if getgenv().translator then getgenv().translator:add_element(items[ "title" ], "Text", "<u>%s</u>") end
            
            items[ "multi_holder" ] = library:create( "Frame" , {
                Parent = items[ "main" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Position = dim2(0, 196, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, -196, 0, 56);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255)
            }); cfg.multi_holder = items[ "multi_holder" ];
            
            items[ "burger_holder" ] = library:create( "Frame" , {
                Parent = items[ "multi_holder" ];
                Name = "\0";
                Position = dim2(0, 10, 0, 10);
                Size = dim2(0, 30, 0, 30);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                ZIndex = 10
            });
            
            items[ "burger_button" ] = library:create( "TextButton" , {
                Parent = items[ "burger_holder" ];
                Name = "\0";
                Text = "";
                AutoButtonColor = false;
                Size = dim2(1, 0, 1, 0);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                ZIndex = 11
            });
            
            items[ "burger_line1" ] = library:create( "Frame" , {
                Parent = items[ "burger_holder" ];
                Name = "\0";
                Position = dim2(0, 5, 0, 7);
                Size = dim2(0, 20, 0, 3);
                BackgroundColor3 = rgb(255, 255, 255);
                BorderSizePixel = 0;
                ZIndex = 11
            });
            
            library:create( "UICorner" , {
                Parent = items[ "burger_line1" ];
                CornerRadius = dim(0, 2)
            });
            
            items[ "burger_line2" ] = library:create( "Frame" , {
                Parent = items[ "burger_holder" ];
                Name = "\0";
                Position = dim2(0, 5, 0, 13);
                Size = dim2(0, 20, 0, 3);
                BackgroundColor3 = rgb(255, 255, 255);
                BorderSizePixel = 0;
                ZIndex = 11
            });
            
            library:create( "UICorner" , {
                Parent = items[ "burger_line2" ];
                CornerRadius = dim(0, 2)
            });
            
            items[ "burger_line3" ] = library:create( "Frame" , {
                Parent = items[ "burger_holder" ];
                Name = "\0";
                Position = dim2(0, 5, 0, 19);
                Size = dim2(0, 20, 0, 3);
                BackgroundColor3 = rgb(255, 255, 255);
                BorderSizePixel = 0;
                ZIndex = 11
            });
            
            library:create( "UICorner" , {
                Parent = items[ "burger_line3" ];
                CornerRadius = dim(0, 2)
            });
            
            library:create( "Frame" , {
                AnchorPoint = vec2(0, 1);
                Parent = items[ "multi_holder" ];
                Position = dim2(0, 0, 1, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 0, 0, 1);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(21, 21, 23)
            });
            
            items[ "shadow" ] = library:create( "ImageLabel" , {
                ImageColor3 = themes.preset.accent;
                ScaleType = Enum.ScaleType.Slice;
                Parent = items[ "main" ];
                BorderColor3 = rgb(0, 0, 0);
                Name = "\0";
                BackgroundColor3 = rgb(255, 255, 255);
                Size = dim2(1, 75, 1, 75);
                AnchorPoint = vec2(0.5, 0.5);
                Image = "rbxassetid://112971167999062";
                BackgroundTransparency = 1;
                Position = dim2(0.5, 0, 0.5, 0);
                SliceScale = 0.75;
                ZIndex = -100;
                BorderSizePixel = 0;
                SliceCenter = rect(vec2(112, 112), vec2(147, 147));
                ImageTransparency = 0.8
            }); library:apply_theme(items[ "shadow" ], "accent", "ImageColor3");
            
            items[ "global_fade" ] = library:create( "Frame" , {
                Parent = items[ "main" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Position = dim2(0, 196, 0, 56);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, -196, 1, -81);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(14, 14, 16);
                ZIndex = 2;
                ClipsDescendants = true
            });                

            library:create( "UICorner" , {
                Parent = items[ "shadow" ];
                CornerRadius = dim(0, 5)
            });
            task.spawn(function()
                local dir = -1
                while items and items["shadow"] and items["shadow"].Parent do
                    local img = items["shadow"]
                    img.ImageTransparency = math.clamp(img.ImageTransparency + (dir * 0.02), 0.6, 0.9)
                    if img.ImageTransparency <= 0.6 then dir = 1 elseif img.ImageTransparency >= 0.9 then dir = -1 end
                    task.wait(0.05)
                end
            end)
            
            items[ "info" ] = library:create( "Frame" , {
                AnchorPoint = vec2(0, 1);
                Parent = items[ "main" ];
                Name = "\0";
                Position = dim2(0, 0, 1, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 0, 0, 25);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(23, 23, 25)
            });
            
            library:create( "UICorner" , {
                Parent = items[ "info" ];
                CornerRadius = dim(0, 10)
            });
            
            items[ "grey_fill" ] = library:create( "Frame" , {
                Name = "\0";
                Parent = items[ "info" ];
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 0, 0, 6);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(23, 23, 25)
            });
            
            -- unified centered footer label
            items[ "footer" ] = library:create( "TextLabel" , {
                FontFace = fonts.font;
                Parent = items[ "info" ];
                TextColor3 = rgb(72, 72, 73);
                BorderColor3 = rgb(0, 0, 0);
                Text = (cfg.footer ~= "" and cfg.footer) or (cfg.game_name ~= "" and cfg.game_name) or cfg.name;
                Name = "\0";
                Size = dim2(1, 0, 1, 0);
                AnchorPoint = vec2(0.5, 0.5);
                Position = dim2(0.5, 0, 0.5, -1);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Center;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            });

            local ResizeButton = library:create("TextButton", {
                AnchorPoint = vec2(1, 0), BackgroundTransparency = 1, Text = "",
                Position = dim2(1, 0, 0, 0), Size = dim2(0, 36, 1, 0),
                SizeConstraint = Enum.SizeConstraint.RelativeYY, Parent = items["info"], Name = "\0",
            })

            local Grip = library:create("ImageLabel", {
                Image = "rbxassetid://112971167999062", ImageTransparency = 0.5,
                BackgroundTransparency = 1, Position = dim2(0, 2, 0, 2), Size = dim2(1, -4, 1, -4),
                Parent = ResizeButton, Name = "\0",
            })

            local dragging, startPos, startSize
            ResizeButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    startPos = input.Position
                    startSize = items["main"].Size
                end
            end)
            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            library:connection(uis.InputChanged, function(input)
                if not dragging then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
                local delta = input.Position - startPos
                local minW, minH = 420, 300
                local newW = math.max(minW, startSize.X.Offset + delta.X)
                local newH = math.max(minH, startSize.Y.Offset + delta.Y)
                items["main"].Size = dim2(0, newW, 0, newH)
            end)
        end 

        do
            library:draggify(items[ "main" ])
            library:resizify(items[ "main" ])
            if library.is_mobile then
                items[ "main" ].Active = true
                items[ "main" ].Selectable = true
            end
            
            cfg.SidebarVisible = true
            
            function cfg.ToggleSidebar()
                cfg.SidebarVisible = not cfg.SidebarVisible
                
                if cfg.SidebarVisible then
                    library:tween(items[ "side_frame" ], {Position = dim2(0, 0, 0, 0)}, Enum.EasingStyle.Quad, 0.3)
                    library:tween(items[ "multi_holder" ], {Position = dim2(0, 196, 0, 0), Size = dim2(1, -196, 0, 56)}, Enum.EasingStyle.Quad, 0.3)
                    library:tween(items[ "global_fade" ], {Position = dim2(0, 196, 0, 56), Size = dim2(1, -196, 1, -81)}, Enum.EasingStyle.Quad, 0.3)
                else
                    library:tween(items[ "side_frame" ], {Position = dim2(0, -196, 0, 0)}, Enum.EasingStyle.Quad, 0.3)
                    library:tween(items[ "multi_holder" ], {Position = dim2(0, 0, 0, 0), Size = dim2(1, 0, 0, 56)}, Enum.EasingStyle.Quad, 0.3)
                    library:tween(items[ "global_fade" ], {Position = dim2(0, 0, 0, 56), Size = dim2(1, 0, 1, -81)}, Enum.EasingStyle.Quad, 0.3)
                end
                
                if cfg.selected_tab and cfg.selected_tab[4] then
                    local TabHolder = cfg.selected_tab[4]
                    local TabHolderPosX = cfg.SidebarVisible and 196 or 0
                    local SidebarOffset = cfg.SidebarVisible and -196 or 0
                    
                    library:tween(TabHolder, {Position = dim2(0, TabHolderPosX, 0, 56), Size = dim2(1, SidebarOffset, 1, -81)}, Enum.EasingStyle.Quad, 0.3)
                end
            end
            
            items[ "burger_button" ].MouseButton1Click:Connect(function()
                cfg.ToggleSidebar()
            end)
        end 

        if library.is_mobile then
            local toggleButton = library:create( "TextButton" , {
                Parent = library[ "mobile" ] or library[ "items" ];
                Text = "Toggle";
                FontFace = fonts.font;
                TextColor3 = rgb(245, 245, 245);
                AutoButtonColor = false;
                Size = dim2(0, 100, 0, 36);
                Position = dim2(1, -6, 0, 6);
                AnchorPoint = vec2(1, 0);
                BackgroundColor3 = rgb(33, 33, 35);
                BorderSizePixel = 0;
                ZIndex = 1000;
            })
            library:create( "UICorner" , { Parent = toggleButton; CornerRadius = dim(0, 6) })
            do
                local dragging = false
                local startPos
                local startOffset
                toggleButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        startPos = input.Position
                        startOffset = toggleButton.Position
                    end
                end)
                toggleButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                library:connection(uis.InputChanged, function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local delta = input.Position - startPos
                        local viewport = camera.ViewportSize
                        local size = toggleButton.AbsoluteSize
                        local anchor = toggleButton.AnchorPoint
                        local desiredFinalX = startOffset.X.Scale * viewport.X + startOffset.X.Offset + delta.X
                        local desiredFinalY = startOffset.Y.Scale * viewport.Y + startOffset.Y.Offset + delta.Y
                        local minFinalX = 10 + anchor.X * size.X
                        local maxFinalX = viewport.X - 10 - (1 - anchor.X) * size.X
                        local minFinalY = 10 + anchor.Y * size.Y
                        local maxFinalY = viewport.Y - 10 - (1 - anchor.Y) * size.Y
                        local clampedFinalX = math.clamp(desiredFinalX, minFinalX, maxFinalX)
                        local clampedFinalY = math.clamp(desiredFinalY, minFinalY, maxFinalY)
                        local newOffsetX = clampedFinalX - startOffset.X.Scale * viewport.X
                        local newOffsetY = clampedFinalY - startOffset.Y.Scale * viewport.Y
                        toggleButton.Position = dim2(startOffset.X.Scale, newOffsetX, startOffset.Y.Scale, newOffsetY)
                    end
                end)
            end
            toggleButton.MouseButton1Click:Connect(function()
                cfg.toggle_menu(not library[ "items" ].Enabled)
            end)

            local lockButton = library:create( "TextButton" , {
                Parent = library[ "mobile" ] or library[ "items" ];
                Text = "Lock";
                FontFace = fonts.font;
                TextColor3 = rgb(245, 245, 245);
                AutoButtonColor = false;
                Size = dim2(0, 100, 0, 36);
                Position = dim2(1, -6, 0, 46);
                AnchorPoint = vec2(1, 0);
                BackgroundColor3 = rgb(33, 33, 35);
                BorderSizePixel = 0;
                ZIndex = 1000;
            })
            library:create( "UICorner" , { Parent = lockButton; CornerRadius = dim(0, 6) })
            do
                local dragging = false
                local startPos
                local startOffset
                lockButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        startPos = input.Position
                        startOffset = lockButton.Position
                    end
                end)
                lockButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                library:connection(uis.InputChanged, function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local delta = input.Position - startPos
                        local viewport = camera.ViewportSize
                        local size = lockButton.AbsoluteSize
                        local anchor = lockButton.AnchorPoint
                        local desiredFinalX = startOffset.X.Scale * viewport.X + startOffset.X.Offset + delta.X
                        local desiredFinalY = startOffset.Y.Scale * viewport.Y + startOffset.Y.Offset + delta.Y
                        local minFinalX = 10 + anchor.X * size.X
                        local maxFinalX = viewport.X - 10 - (1 - anchor.X) * size.X
                        local minFinalY = 10 + anchor.Y * size.Y
                        local maxFinalY = viewport.Y - 10 - (1 - anchor.Y) * size.Y
                        local clampedFinalX = math.clamp(desiredFinalX, minFinalX, maxFinalX)
                        local clampedFinalY = math.clamp(desiredFinalY, minFinalY, maxFinalY)
                        local newOffsetX = clampedFinalX - startOffset.X.Scale * viewport.X
                        local newOffsetY = clampedFinalY - startOffset.Y.Scale * viewport.Y
                        lockButton.Position = dim2(startOffset.X.Scale, newOffsetX, startOffset.Y.Scale, newOffsetY)
                    end
                end)
            end
            local function updateLockText()
                lockButton.Text = library.cant_drag_forced and "Unlock" or "Lock"
            end
            lockButton.MouseButton1Click:Connect(function()
                library.cant_drag_forced = not library.cant_drag_forced
                updateLockText()
            end)
            updateLockText()
        end

        function cfg.toggle_menu(bool) 
            -- WIP 
            -- if cfg.tween then 
            --     cfg.tween:Cancel()
            -- end 

            -- items[ "main" ].Size = dim2(items[ "main" ].Size.Scale.X, items[ "main" ].Size.Offset.X - 20, items[ "main" ].Size.Scale.Y, items[ "main" ].Size.Offset.Y - 20)
            -- library:tween(items[ "tab_holder" ], {Size = dim2(1, -196, 1, -81)}, Enum.EasingStyle.Quad, 0.4)
            -- cfg.tween = 
            
            library[ "items" ].Enabled = bool
            if library[ "other" ] then library[ "other" ].Enabled = bool end
        end 
        
        library:load_autoload()
            
        return setmetatable(cfg, library)
    end 

    function library:tab(properties)
        local cfg = {
            name = properties.name or properties.Name or "visuals"; 
            icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608";
            
            -- multi 
            tabs = properties.tabs or properties.Tabs or {"Main", "Misc."};
            pages = {}; -- data store for multi sections
            current_multi; 
            
            items = {};
        } 

        local items = cfg.items; do 
            items[ "tab_holder" ] = library:create( "ScrollingFrame" , {
                Parent = library[ "cache" ];
                Name = "\0";
                Visible = false;
                BackgroundTransparency = 1;
                Position = library.is_mobile and dim2(0, 196, 0, 40) or dim2(0, 196, 0, 56);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, -216, 1, -101);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
                ClipsDescendants = true;
                Active = true;
                ScrollBarThickness = library.is_mobile and 8 or 3;
                ScrollingDirection = Enum.ScrollingDirection.Y;
                AutomaticCanvasSize = Enum.AutomaticSize.Y;
                CanvasSize = dim2(0,0,0,0);
                ElasticBehavior = Enum.ElasticBehavior.Always;
                ScrollingEnabled = true;
                ScrollBarImageColor3 = themes.preset.accent;
                VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
            }); library:apply_theme(items[ "tab_holder" ], "accent", "ScrollBarImageColor3");
            cfg.tab_holder = items[ "tab_holder" ];

            library:create( "UIListLayout" , {
                Parent = items[ "tab_holder" ];
                Padding = dim(0, library.is_mobile and 14 or 7);
                SortOrder = Enum.SortOrder.LayoutOrder;
                FillDirection = Enum.FillDirection.Vertical
            });
            
            -- Tab buttons 
                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "button_holder" ];
                    AutoButtonColor = false;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 35);
                    BorderSizePixel = 0;
                    TextSize = 16;
                    BackgroundColor3 = rgb(29, 29, 29)
                });
                
                items[ "icon" ] = library:create( "ImageLabel" , {
                    ImageColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "button" ];
                    AnchorPoint = vec2(0, 0.5);
                    Image = "http://www.roblox.com/asset/?id=6034767608";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0.5, 0);
                    Name = "\0";
                    Size = dim2(0, 22, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "icon" ], "accent", "ImageColor3");
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    Size = dim2(0, 0, 1, 0);
                    Position = dim2(0, 40, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                if getgenv().translator then getgenv().translator:add_element(items[ "name" ], "Text") end
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 7)
                });
                
                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "button" ];
                    Enabled = false;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });
            -- 

            -- Multi Sections
                items[ "multi_section_button_holder" ] = library:create( "Frame" , {
                    Parent = library.cache;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Visible = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "multi_section_button_holder" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                library:create( "UIPadding" , {
                    PaddingTop = dim(0, 8);
                    PaddingBottom = dim(0, 7);
                    Parent = items[ "multi_section_button_holder" ];
                    PaddingRight = dim(0, 10);
                    PaddingLeft = dim(0, 50)
                });                        

                for _, section in cfg.tabs do
                    local data = {items = {}} 

                    local multi_items = data.items; do 
                        -- Button
                            multi_items[ "button" ] = library:create( "TextButton" , {
                                FontFace = fonts.font;
                                TextColor3 = rgb(255, 255, 255);
                                BorderColor3 = rgb(0, 0, 0);
                                AutoButtonColor = false;
                                Text = "";
                                Parent = items[ "multi_section_button_holder" ];
                                Name = "\0";
                                Size = dim2(0, 0, 0, 39);
                                BackgroundTransparency = 1;
                                ClipsDescendants = true;
                                BorderSizePixel = 0;
                                AutomaticSize = Enum.AutomaticSize.X;
                                TextSize = 16;
                                BackgroundColor3 = rgb(25, 25, 29)
                            });
                            
                            multi_items[ "name" ] = library:create( "TextLabel" , {
                                FontFace = fonts.font;
                                TextColor3 = rgb(62, 62, 63);
                                BorderColor3 = rgb(0, 0, 0);
                                Text = section;
                                Parent = multi_items[ "button" ];
                                Name = "\0";
                                Size = dim2(0, 0, 1, 0);
                                BackgroundTransparency = 1;
                                TextXAlignment = Enum.TextXAlignment.Left;
                                BorderSizePixel = 0;
                                AutomaticSize = Enum.AutomaticSize.XY;
                                TextSize = 16;
                                BackgroundColor3 = rgb(255, 255, 255)
                            });
                            if getgenv().translator then getgenv().translator:add_element(multi_items[ "name" ], "Text") end
                            
                            library:create( "UIPadding" , {
                                Parent = multi_items[ "name" ];
                                PaddingRight = dim(0, 5);
                                PaddingLeft = dim(0, 5)
                            });
                            
                            multi_items[ "accent" ] = library:create( "Frame" , {
                                BorderColor3 = rgb(0, 0, 0);
                                AnchorPoint = vec2(0, 1);
                                Parent = multi_items[ "button" ];
                                BackgroundTransparency = 1;
                                Position = dim2(0, 10, 1, 4);
                                Name = "\0";
                                Size = dim2(1, -20, 0, 6);
                                BorderSizePixel = 0;
                                BackgroundColor3 = themes.preset.accent
                            }); library:apply_theme(multi_items[ "accent" ], "accent", "BackgroundColor3");
                            
                            library:create( "UICorner" , {
                                Parent = multi_items[ "accent" ];
                                CornerRadius = dim(0, 999)
                            });
                            
                            library:create( "UIPadding" , {
                                Parent = multi_items[ "button" ];
                                PaddingRight = dim(0, 10);
                                PaddingLeft = dim(0, 10)
                            });
                            
                            library:create( "UICorner" , {
                                Parent = multi_items[ "button" ];
                                CornerRadius = dim(0, 7)
                            }); 
                        --

                        -- Tab 
                            multi_items[ "tab" ] = library:create( "Frame" , {
                                Parent = library.cache;
                                BackgroundTransparency = 1;
                                Name = "\0";
                                BorderColor3 = rgb(0, 0, 0);
                                Size = dim2(1, 0, 0, 0);
                                BorderSizePixel = 0;
                                Visible = false;
                                BackgroundColor3 = rgb(255, 255, 255);
                                ClipsDescendants = true;
                                AutomaticSize = Enum.AutomaticSize.Y
                            });

                            library:create( "UIListLayout" , {
                                Parent = multi_items[ "tab" ];
                                Padding = dim(0, library.is_mobile and 14 or 7);
                                SortOrder = Enum.SortOrder.LayoutOrder;
                                FillDirection = Enum.FillDirection.Vertical
                            });
                            
                            library:create( "UIListLayout" , {
                                FillDirection = Enum.FillDirection.Vertical;
                                HorizontalFlex = Enum.UIFlexAlignment.Fill;
                                Parent = multi_items[ "tab" ];
                                Padding = dim(0, library.is_mobile and 12 or 7);
                                SortOrder = Enum.SortOrder.LayoutOrder;
                                VerticalFlex = Enum.UIFlexAlignment.Fill
                            });
                            
                            library:create( "UIPadding" , {
                                PaddingTop = dim(0, library.is_mobile and 10 or 7);
                                PaddingBottom = dim(0, library.is_mobile and 10 or 7);
                                Parent = multi_items[ "tab" ];
                                PaddingRight = dim(0, library.is_mobile and 10 or 7);
                                PaddingLeft = dim(0, library.is_mobile and 10 or 7)
                            });
                        --
                    end

                    data.text = multi_items[ "name" ]
                    data.accent = multi_items[ "accent" ]
                    data.button = multi_items[ "button" ]
                    data.page = multi_items[ "tab" ]
                    data.parent = setmetatable(data, library):sub_tab({}).items[ "tab_parent" ]
                    
                    -- Old column code
                    -- data.left = multi_items[ "left" ]
                    -- data.right = multi_items[ "right" ]

                    function data.open_page()
                        local page = cfg.current_multi; 
                        
                        if page and page.text ~= data.text then 
                            self.items[ "global_fade" ].BackgroundTransparency = 0
                            library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                            
                            local old_size = page.page.Size
                            page.page.Size = dim2(1, -20, 1, -20)
                        end

                        if page then
                            library:tween(page.text, {TextColor3 = rgb(62, 62, 63)})
                            library:tween(page.accent, {BackgroundTransparency = 1})
                            library:tween(page.button, {BackgroundTransparency = 1})

                            page.page.Visible = false
                            page.page.Parent = library[ "cache" ] 
                        end 
                        
                        library:tween(data.text, {TextColor3 = rgb(255, 255, 255)})
                        library:tween(data.accent, {BackgroundTransparency = 0})
                        library:tween(data.button, {BackgroundTransparency = 0})
                        library:tween(data.page, {Size = dim2(1, 0, 1, 0)}, Enum.EasingStyle.Quad, 0.4)

                        data.page.Visible = true
                        data.page.Parent = items["tab_holder"]

                        cfg.current_multi = data

                        library:close_element()
                    end

                    multi_items[ "button" ].MouseButton1Down:Connect(function()
                        data.open_page() 
                    end)

                    cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
                end 

                cfg.pages[1].open_page()
            --
        end 

        function cfg.open_tab() 
            local selected_tab = self.selected_tab
            
            if selected_tab then 
                if selected_tab[ 4 ] ~= items[ "tab_holder" ] then 
                    self.items[ "global_fade" ].BackgroundTransparency = 0
                    
                    library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                    selected_tab[ 4 ].Size = dim2(1, -216, 1, -101)
                end

                library:tween(selected_tab[ 1 ], {BackgroundTransparency = 1})
                library:tween(selected_tab[ 2 ], {ImageColor3 = rgb(72, 72, 73)})
                library:tween(selected_tab[ 3 ], {TextColor3 = rgb(72, 72, 73)})

                selected_tab[ 4 ].Visible = false
                selected_tab[ 4 ].Parent = library[ "cache" ]
                selected_tab[ 5 ].Visible = false
                selected_tab[ 5 ].Parent = library[ "cache" ]
            end

            library:tween(items[ "button" ], {BackgroundTransparency = 0})
            library:tween(items[ "icon" ], {ImageColor3 = themes.preset.accent})
            library:tween(items[ "name" ], {TextColor3 = rgb(255, 255, 255)})
            
            local SidebarOffset = self.SidebarVisible and -196 or 0
            library:tween(items[ "tab_holder" ], {Size = dim2(1, SidebarOffset, 1, -81)}, Enum.EasingStyle.Quad, 0.4)
            
            items[ "tab_holder" ].Visible = true 
            items[ "tab_holder" ].Parent = self.items[ "main" ]
            
            local TabHolderPosX = self.SidebarVisible and 196 or 0
            items[ "tab_holder" ].Position = dim2(0, TabHolderPosX, 0, 56)
            
            items[ "tab_holder" ].AutomaticCanvasSize = Enum.AutomaticSize.None
            items[ "tab_holder" ].CanvasSize = dim2(0,0,0,5000)
            items[ "tab_holder" ].ScrollBarThickness = library.is_mobile and 6 or 3
            items[ "tab_holder" ].ScrollingEnabled = true
            items[ "tab_holder" ].Active = true
            items[ "tab_holder" ].ElasticBehavior = Enum.ElasticBehavior.Always
            items[ "multi_section_button_holder" ].Visible = true 
            items[ "multi_section_button_holder" ].Parent = self.items[ "multi_holder" ]

            self.selected_tab = {
                items[ "button" ];
                items[ "icon" ];
                items[ "name" ];
                items[ "tab_holder" ];
                items[ "multi_section_button_holder" ];
            }

            library:close_element()
        end

        items[ "button" ].MouseButton1Down:Connect(function()
            cfg.open_tab()
        end)
        
        if not self.selected_tab then 
            cfg.open_tab(true) 
        end

        return unpack(cfg.pages)
    end

    function library:seperator(properties)
        local cfg = {items = {}, name = properties.Name or properties.name or "General"}

        local items = cfg.items do 
            items[ "name" ] = library:create( "TextLabel" , {
                FontFace = fonts.font;
                TextColor3 = rgb(72, 72, 73);
                BorderColor3 = rgb(0, 0, 0);
                Text = cfg.name;
                Parent = self.items[ "button_holder" ];
                Name = "\0";
                Size = dim2(1, 0, 0, 0);
                Position = dim2(0, 40, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0; 
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            library:create( "UIPadding" , {
                Parent = items[ "name" ];
                PaddingRight = dim(0, 5);
                PaddingLeft = dim(0, 5)
            });                
        end;    

        return setmetatable(cfg, library)
    end 

    -- Miscellaneous 
        function library:column(properties) 
            local cfg = {items = {}, size = properties.size or 1}

            local items = cfg.items; do     
                items[ "column" ] = library:create( "Frame" , {
                    Parent = self[ "parent" ] or self.items["tab_parent"];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = library.is_mobile and dim2(1, -4, 0, 0) or dim2(0, 0, cfg.size, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255),
                    AutomaticSize = library.is_mobile and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = library.is_mobile and dim(0, 5) or dim(0, 10);
                    PaddingTop = library.is_mobile and dim(0, 5) or dim(0, 0);
                    Parent = items[ "column" ]
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "column" ];
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Padding = dim(0, library.is_mobile and 8 or 10);
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
            end 

            return setmetatable(cfg, library)
        end 

        function library:sub_tab(properties) 
            local cfg = {items = {}, order = properties.order or 0; size = properties.size or 1}

            local items = cfg.items; do 
                local properties = {
                    Parent = self.items[ "tab" ],
                    BackgroundTransparency = 1,
                    Name = "\0",
                    Size = dim2(1,0,cfg.size,0),
                    BorderColor3 = rgb(0, 0, 0),
                    BorderSizePixel = 0,
                    Visible = true,
                    BackgroundColor3 = rgb(255, 255, 255)
                }
                
                properties.ScrollBarThickness = library.is_mobile and 6 or 3
                properties.AutomaticCanvasSize = Enum.AutomaticSize.Y
                properties.CanvasSize = dim2(0,0,0,0)
                properties.ScrollingDirection = Enum.ScrollingDirection.Y
                properties.ScrollingEnabled = true
                properties.Active = true
                properties.BackgroundTransparency = library.is_mobile and 0.95 or 1
                items[ "tab_parent" ] = library:create("ScrollingFrame", properties)
                
                library:create( "UIListLayout" , {
                    FillDirection = library.is_mobile and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal;
                    Parent = items[ "tab_parent" ];
                    Padding = library.is_mobile and dim(0, 4) or dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    HorizontalFlex = not library.is_mobile and Enum.UIFlexAlignment.Fill or nil;
                    VerticalFlex = not library.is_mobile and Enum.UIFlexAlignment.Fill or nil;
                });
            end

            return setmetatable(cfg, library)
        end 
    --

    function library:section(properties)
        local cfg = {
            name = properties.name or properties.Name or "section"; 
            side = properties.side or properties.Side or "left";
            default = properties.default or properties.Default or false;
            size = properties.size or properties.Size or self.size or 0.5; 
            icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6022668898";
            fading_toggle = properties.fading or properties.Fading or false;
            items = {};
        };
        
        local items = cfg.items; do 
            items[ "outline" ] = library:create( "Frame" , {
                Name = "\0";
                Parent = self.items[ "column" ];
                BorderColor3 = rgb(0, 0, 0);
                Size = library.is_mobile and dim2(1, 0, 0, 0) or dim2(1, 0, cfg.size, -3);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(25, 25, 29),
                AutomaticSize = library.is_mobile and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
                LayoutOrder = library.is_mobile and (cfg.order or 0) or nil
            });

            library:create( "UICorner" , {
                Parent = items[ "outline" ];
                CornerRadius = dim(0, 7)
            });
            
            items[ "inline" ] = library:create( "Frame" , {
                Parent = items[ "outline" ];
                Name = "\0";
                Position = dim2(0, 1, 0, 1);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, -2, 1, -2);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(22, 22, 24),
                AutomaticSize = library.is_mobile and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
            });
            
            library:create( "UICorner" , {
                Parent = items[ "inline" ];
                CornerRadius = dim(0, 7)
            });
            
            items[ "scrolling" ] = library:create( library.is_mobile and "Frame" or "ScrollingFrame" , {
                ScrollBarImageColor3 = not library.is_mobile and themes.preset.accent or nil;
                Active = not library.is_mobile and true or nil;
                AutomaticCanvasSize = not library.is_mobile and Enum.AutomaticSize.Y or nil;
                ScrollBarThickness = not library.is_mobile and 2 or nil;
                Parent = items[ "inline" ];
                Name = "\0";
                Size = library.is_mobile and dim2(1, -10, 0, 0) or dim2(1, -10, 1, -40);
                BackgroundTransparency = 1;
                Position = dim2(0, 5, 0, 35);
                BackgroundColor3 = rgb(255, 255, 255);
                BorderColor3 = rgb(0, 0, 0);
                BorderSizePixel = 0;
                ClipsDescendants = true;
                ScrollingDirection = not library.is_mobile and Enum.ScrollingDirection.Y or nil;
                ScrollingEnabled = not library.is_mobile and true or nil;
                ElasticBehavior = not library.is_mobile and Enum.ElasticBehavior.Always or nil;
                AutomaticSize = library.is_mobile and Enum.AutomaticSize.Y or nil
            }); if not library.is_mobile then library:apply_theme(items[ "scrolling" ], "accent", "ScrollBarImageColor3"); end
            
            items[ "elements" ] = library:create( "Frame" , {
                BorderColor3 = rgb(0, 0, 0);
                Parent = items[ "scrolling" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Position = library.is_mobile and dim2(0, 0, 0, 0) or dim2(0, 10, 0, 10);
                Size = library.is_mobile and dim2(1, 0, 0, 0) or dim2(1, -20, 0, 0);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.Y;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            library:create( "UIListLayout" , {
                Parent = items[ "elements" ];
                Padding = dim(0, library.is_mobile and 4 or 10);
                SortOrder = Enum.SortOrder.LayoutOrder
            });
            
            if library.is_mobile then
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 8);
                    PaddingTop = dim(0, 5);
                    Parent = items[ "elements" ]
                });
            else
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
                });
            end
            
            items[ "button" ] = library:create( "TextButton" , {
                FontFace = fonts.font;
                TextColor3 = rgb(255, 255, 255);
                BorderColor3 = rgb(0, 0, 0);
                Text = "";
                AutoButtonColor = false;
                Parent = items[ "outline" ];
                Name = "\0";
                Position = dim2(0, 1, 0, 1);
                Size = dim2(1, -2, 0, 35);
                BorderSizePixel = 0;
                TextSize = 16;
                BackgroundColor3 = rgb(19, 19, 21)
            });
            
            library:create( "UIStroke" , {
                Color = rgb(23, 23, 29);
                Parent = items[ "button" ];
                Enabled = false;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            });
            
            library:create( "UICorner" , {
                Parent = items[ "button" ];
                CornerRadius = dim(0, 7)
            });
            
            items[ "Icon" ] = library:create( "ImageLabel" , {
                ImageColor3 = themes.preset.accent;
                BorderColor3 = rgb(0, 0, 0);
                Parent = items[ "button" ];
                AnchorPoint = vec2(0, 0.5);
                Image = cfg.icon;
                BackgroundTransparency = 1;
                Position = dim2(0, 10, 0.5, 0);
                Name = "\0";
                Size = dim2(0, 22, 0, 22);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255)
            }); library:apply_theme(items[ "Icon" ], "accent", "ImageColor3");
            
            items[ "section_title" ] = library:create( "TextLabel" , {
                FontFace = fonts.font;
                TextColor3 = rgb(255, 255, 255);
                BorderColor3 = rgb(0, 0, 0);
                Text = cfg.name;
                Parent = items[ "button" ];
                Name = "\0";
                Size = dim2(0, 0, 1, 0);
                Position = dim2(0, 40, 0, -1);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextWrapped = true;
                TextTruncate = Enum.TextTruncate.None;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.X;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            if getgenv().translator then getgenv().translator:add_element(items[ "section_title" ], "Text") end
            
            library:create( "Frame" , {
                AnchorPoint = vec2(0, 1);
                Parent = items[ "button" ];
                Position = dim2(0, 0, 1, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 0, 0, 1);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(36, 36, 37)
            });
            
            if cfg.fading_toggle then 
                items[ "toggle" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    AutoButtonColor = false;
                    Text = "";
                    AnchorPoint = vec2(1, 0.5);
                    Parent = items[ "button" ];
                    Name = "\0";
                    Position = dim2(1, -9, 0.5, 0);
                    Size = dim2(0, 36, 0, 18);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(58, 58, 62)
                });  library:apply_theme(items[ "toggle" ], "accent", "BackgroundColor3");
                
                library:create( "UICorner" , {
                    Parent = items[ "toggle" ];
                    CornerRadius = dim(0, 999)
                });
                
                items[ "toggle_outline" ] = library:create( "Frame" , {
                    Parent = items[ "toggle" ];
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    BorderMode = Enum.BorderMode.Inset;
                    BorderColor3 = rgb(0, 0, 0);
                    Position = dim2(0, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(50, 50, 50)
                });  library:apply_theme(items[ "toggle_outline" ], "accent", "BackgroundColor3");
                
                library:create( "UICorner" , {
                    Parent = items[ "toggle_outline" ];
                    CornerRadius = dim(0, 999)
                });
                
                library:create( "UIGradient" , {
                    Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                    Parent = items[ "toggle_outline" ]
                });
                
                items[ "toggle_circle" ] = library:create( "Frame" , {
                    Parent = items[ "toggle_outline" ];
                    Name = "\0";
                    Position = dim2(0, 2, 0, 2);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 12, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(86, 86, 88)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "toggle_circle" ];
                    CornerRadius = dim(0, 999)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });
            
                items[ "fade" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    BackgroundTransparency = 0.800000011920929;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "fade" ];
                    CornerRadius = dim(0, 7)
                });
            end 
        end;

        do
            if library.is_mobile then
                local function recompute_mobile_section()
                    items[ "outline" ].AutomaticSize = Enum.AutomaticSize.Y
                    items[ "inline" ].AutomaticSize = Enum.AutomaticSize.Y
                    items[ "scrolling" ].Size = dim2(1, -10, 0, 0)
                    items[ "scrolling" ].AutomaticSize = Enum.AutomaticSize.Y
                end

                local function bind_mobile_resize(node)
                    if not node then return end
                    if node:IsA("GuiObject") then
                        library:connection(node:GetPropertyChangedSignal("AbsoluteSize"), recompute_mobile_section)
                    end
                    library:connection(node.ChildAdded, function(child)
                        task.wait()
                        recompute_mobile_section()
                    end)
                    library:connection(node.ChildRemoved, function()
                        task.wait()
                        recompute_mobile_section()
                    end)
                end

                task.defer(function()
                    bind_mobile_resize(items[ "elements" ])
                    recompute_mobile_section()
                end)
            else
                local MIN_SECTION_HEIGHT = 140
                local HEADER_HEIGHT = 35

                local function recompute_section_height()
                    items[ "outline" ].AutomaticSize = Enum.AutomaticSize.Y
                    items[ "inline" ].AutomaticSize = Enum.AutomaticSize.Y
                    items[ "scrolling" ].AutomaticCanvasSize = Enum.AutomaticSize.Y
                    items[ "scrolling" ].Size = dim2(1, 0, 1, -HEADER_HEIGHT)
                end

                local function bind_resize_watch(node)
                    if not node then return end
                    if node:IsA("GuiObject") then
                        library:connection(node:GetPropertyChangedSignal("AbsoluteSize"), recompute_section_height)
                        library:connection(node:GetPropertyChangedSignal("Visible"), recompute_section_height)
                    end
                    library:connection(node.ChildAdded, function(child)
                        bind_resize_watch(child)
                        recompute_section_height()
                    end)
                    library:connection(node.ChildRemoved, recompute_section_height)
                    for _, ch in node:GetDescendants() do
                        if ch:IsA("GuiObject") then bind_resize_watch(ch) end
                    end
                end

                task.defer(function()
                    bind_resize_watch(items[ "elements" ])
                    recompute_section_height()
                end)
            end
        end

        if cfg.fading_toggle then
            items[ "button" ].MouseButton1Click:Connect(function()
                cfg.default = not cfg.default 
                cfg.toggle_section(cfg.default) 
            end)

            function cfg.toggle_section(bool)
                library:tween(items[ "toggle" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                library:tween(items[ "toggle_outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                library:tween(items[ "toggle_circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                library:tween(items[ "fade" ], {BackgroundTransparency = bool and 1 or 0.8}, Enum.EasingStyle.Quad)
            end 
        end 

        return setmetatable(cfg, library)
    end  

    function library:toggle(options) 
        local cfg = {
            enabled = options.enabled or nil,
            name = options.name or "Toggle",
            info = options.info or nil,
            flag = options.flag or library:next_flag(),
            
            type = options.type and string.lower(options.type) or "toggle";

            default = options.default or false,
            folding = options.folding or false, 
            callback = options.callback or function() end,
            
            keybind = options.keybind ~= false,
            keybind_flag = options.flag and (options.flag .. "_keybind") or library:next_flag(),
            keybind_default = options.keybind_default or nil,

            items = {};
            seperator = options.seperator or options.Seperator or false;
        }

        flags[cfg.flag] = cfg.default
        flags[cfg.keybind_flag] = {key = cfg.keybind_default, active = false, mode = "Toggle"}

        local items = cfg.items; do
            items[ "toggle" ] = library:create( "TextButton" , {
                FontFace = fonts.small;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Text = "";
                Parent = self.items[ "elements" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 0, 0);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.Y;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            items[ "name" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(245, 245, 245);
                BorderColor3 = rgb(0, 0, 0);
                Text = cfg.name;
                Parent = items[ "toggle" ];
                Name = "\0";
                Size = dim2(1, 0, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            if getgenv().translator then getgenv().translator:add_element(items[ "name" ], "Text") end

            if cfg.info then 
                items[ "info" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(130, 130, 130);
                    BorderColor3 = rgb(0, 0, 0);
                    TextWrapped = true;
                    Text = cfg.info;
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Position = dim2(0, 5, 0, 17);
                    Size = dim2(1, -10, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                if getgenv().translator then getgenv().translator:add_element(items[ "info" ], "Text") end
            end 
            
            library:create( "UIPadding" , {
                Parent = items[ "name" ];
                PaddingRight = dim(0, 5);
                PaddingLeft = dim(0, 5)
            });
            
            items[ "right_components" ] = library:create( "Frame" , {
                Parent = items[ "toggle" ];
                Name = "\0";
                Position = dim2(1, 0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 0, 1, 0);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            library:create( "UIListLayout" , {
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                Parent = items[ "right_components" ];
                Padding = dim(0, 9);
                SortOrder = Enum.SortOrder.LayoutOrder
            });
            
            -- Toggle
                if cfg.type == "checkbox" then 
                    items[ "toggle_button" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        LayoutOrder = 2;
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, 16, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(67, 67, 68)
                    }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");
                    
                    library:create( "UICorner" , {
                        Parent = items[ "toggle_button" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "outline" ] = library:create( "Frame" , {
                        Parent = items[ "toggle_button" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 24)
                    }); library:apply_theme(items[ "outline" ], "accent", "BackgroundColor3");
                    
                    items[ "tick" ] = library:create( "ImageLabel" , {
                        ImageTransparency = 1;
                        BorderColor3 = rgb(0, 0, 0);
                        Image = "rbxassetid://111862698467575";
                        BackgroundTransparency = 1;
                        Position = dim2(0, -1, 0, 0);
                        Parent = items[ "outline" ];
                        Size = dim2(1, 2, 1, 2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255);
                        ZIndex = 1;
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    library:create( "UIGradient" , {
                        Enabled = false;
                        Parent = items[ "outline" ];
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))}
                    });  
                else 
                    items[ "toggle_button" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        LayoutOrder = 2;
                        AnchorPoint = vec2(1, 0.5);
                        Parent = items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, -9, 0.5, 0);
                        Size = dim2(0, 36, 0, 18);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = themes.preset.accent
                    }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");
                    
                    library:create( "UICorner" , {
                        Parent = items[ "toggle_button" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    items[ "inline" ] = library:create( "Frame" , {
                        Parent = items[ "toggle_button" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.accent
                    }); library:apply_theme(items[ "inline" ], "accent", "BackgroundColor3");
                    
                    library:create( "UICorner" , {
                        Parent = items[ "inline" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "inline" ]
                    });
                    
                    items[ "circle" ] = library:create( "Frame" , {
                        Parent = items[ "inline" ];
                        Name = "\0";
                        Position = dim2(1, -14, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "circle" ];
                        CornerRadius = dim(0, 999)
                    });                        
                end 
            --
            
            if cfg.keybind then
                items[ "keybind_holder" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(86, 86, 87);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "[NONE]";
                    AutoButtonColor = false;
                    LayoutOrder = 1;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    Size = dim2(0, 0, 0, 16);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 12;
                    BackgroundColor3 = rgb(33, 33, 35)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "keybind_holder" ];
                    CornerRadius = dim(0, 4)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "keybind_holder" ];
                    PaddingTop = dim(0, 1);
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                cfg.binding = nil
                cfg.keybind_key = cfg.keybind_default
            end                
        end;
        
        function cfg.set(bool)
            cfg.enabled = bool
            
            if cfg.type == "checkbox" then 
                library:tween(items[ "tick" ], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
                library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(67, 67, 68)})
                library:tween(items[ "outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(22, 22, 24)})
            else
                library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                library:tween(items[ "inline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                library:tween(items[ "circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
            end

            cfg.callback(bool)

            if cfg.folding then 
                elements.Visible = bool
            end

            flags[cfg.flag] = bool
        end 
        
        items[ "toggle" ].MouseButton1Click:Connect(function()
            cfg.enabled = not cfg.enabled 
            cfg.set(cfg.enabled)
        end)

        items[ "toggle_button" ].MouseButton1Click:Connect(function()
            cfg.enabled = not cfg.enabled 
            cfg.set(cfg.enabled)
        end)
        
        if cfg.keybind then
            function cfg.set_keybind(key)
                cfg.keybind_key = key
                local text = "NONE"
                
                if key and tostring(key) ~= "Enums" then
                    text = keys[key] or tostring(key):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
                end
                
                items[ "keybind_holder" ].Text = "[" .. text .. "]"
                flags[cfg.keybind_flag] = {key = key, active = false, mode = "Toggle"}
                library.flag_objects[cfg.keybind_flag] = {
                    set = function(value)
                        if type(value) == "table" and value.key then
                            cfg.set_keybind(value.key)
                        end
                    end
                }
            end
            
            items[ "keybind_holder" ].MouseButton1Click:Connect(function()
                items[ "keybind_holder" ].Text = "[...]"
                
                cfg.binding = library:connection(uis.InputBegan, function(input, gpe)
                    local key = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
                    
                    if key == Enum.KeyCode.Escape then
                        cfg.set_keybind(nil)
                    else
                        cfg.set_keybind(key)
                    end
                    
                    cfg.binding:Disconnect()
                    cfg.binding = nil
                end)
            end)
            
            library:connection(uis.InputBegan, function(input, gpe)
                if gpe or cfg.binding then return end
                
                local key = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
                
                if key == cfg.keybind_key and cfg.keybind_key then
                    cfg.enabled = not cfg.enabled
                    cfg.set(cfg.enabled)
                end
            end)
            
            cfg.set_keybind(cfg.keybind_key)
        end
        
        if cfg.seperator then -- ok bro my lua either sucks or this was a pain in the ass to make (simple if statement aswell 💔)
            library:create( "Frame" , {
                AnchorPoint = vec2(0, 1);
                Parent = self.items[ "elements" ];
                Position = dim2(0, 0, 1, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 1, 0, 1);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(36, 36, 37)
            });
        end

        cfg.set(cfg.default)
        
        library.flag_objects[cfg.flag] = cfg



        return setmetatable(cfg, library)
    end 
    
    function library:slider(options) 
        local cfg = {
            name = options.name or nil,
            suffix = options.suffix or "",
            flag = options.flag or library:next_flag(),
            callback = options.callback or function() end, 
            info = options.info or nil; 

            -- value settings
            min = options.min or options.minimum or 0,
            max = options.max or options.maximum or 100,
            intervals = options.interval or options.decimal or 1,
            default = options.default or 10,
            value = options.default or 10, 
            seperator = options.seperator or options.Seperator or true;

            dragging = false,
            items = {}
        } 

        flags[cfg.flag] = cfg.default

        local items = cfg.items; do
            items[ "slider_object" ] = library:create( "TextButton" , {
                FontFace = fonts.small;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Text = "";
                Parent = self.items[ "elements" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 0, 0);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.Y;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            items[ "name" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(245, 245, 245);
                BorderColor3 = rgb(0, 0, 0);
                Text = cfg.name;
                Parent = items[ "slider_object" ];
                Name = "\0";
                Size = dim2(1, 0, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            if getgenv().translator then getgenv().translator:add_element(items[ "name" ], "Text") end
            
            if cfg.info then 
                items[ "info" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(130, 130, 130);
                    BorderColor3 = rgb(0, 0, 0);
                    TextWrapped = true;
                    Text = cfg.info;
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Position = dim2(0, 5, 0, 37);
                    Size = dim2(1, -10, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                if getgenv().translator then getgenv().translator:add_element(items[ "info" ], "Text") end
            end 

            library:create( "UIPadding" , {
                Parent = items[ "name" ];
                PaddingRight = dim(0, 5);
                PaddingLeft = dim(0, 5)
            });
            
            items[ "right_components" ] = library:create( "Frame" , {
                Parent = items[ "slider_object" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Position = dim2(0, 4, 0, 23);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 0, 0, 12);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            library:create( "UIListLayout" , {
                Parent = items[ "right_components" ];
                Padding = dim(0, 7);
                SortOrder = Enum.SortOrder.LayoutOrder;
                FillDirection = Enum.FillDirection.Horizontal
            });
            
            items[ "slider" ] = library:create( "TextButton" , {
                FontFace = fonts.small;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Text = "";
                AutoButtonColor = false;
                AnchorPoint = vec2(1, 0);
                Parent = items[ "right_components" ];
                Name = "\0";
                Position = dim2(1, 0, 0, 0);
                Size = dim2(1, -4, 0, 4);
                BorderSizePixel = 0;
                TextSize = 14;
                BackgroundColor3 = rgb(33, 33, 35)
            });
            
            library:create( "UICorner" , {
                Parent = items[ "slider" ];
                CornerRadius = dim(0, 999)
            });
            
            items[ "fill" ] = library:create( "Frame" , {
                Name = "\0";
                Parent = items[ "slider" ];
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0.5, 0, 0, 4);
                BorderSizePixel = 0;
                BackgroundColor3 = themes.preset.accent
            });  library:apply_theme(items[ "fill" ], "accent", "BackgroundColor3");
            
            library:create( "UICorner" , {
                Parent = items[ "fill" ];
                CornerRadius = dim(0, 999)
            });
            
            items[ "circle" ] = library:create( "Frame" , {
                AnchorPoint = vec2(0.5, 0.5);
                Parent = items[ "fill" ];
                Name = "\0";
                Position = dim2(1, 0, 0.5, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 12, 0, 12);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(244, 244, 244)
            });
            
            library:create( "UICorner" , {
                Parent = items[ "circle" ];
                CornerRadius = dim(0, 999)
            });
            
            library:create( "UIPadding" , {
                Parent = items[ "right_components" ];
                PaddingTop = dim(0, 4)
            });
            
            items[ "value" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(72, 72, 73);
                BorderColor3 = rgb(0, 0, 0);
                Text = tostring(cfg.value) .. cfg.suffix;
                Parent = items[ "slider_object" ];
                Name = "\0";
                Size = dim2(1, 0, 0, 0);
                Position = dim2(0, 6, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Right;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            library:create( "UIPadding" , {
                Parent = items[ "value" ];
                PaddingRight = dim(0, 5);
                PaddingLeft = dim(0, 5)
            });                
        end 

        function cfg.set(value)
            cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

            library:tween(items[ "fill" ], {Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), cfg.value == cfg.min and 0 or -4, 0, 2)}, Enum.EasingStyle.Linear, 0.05)
            items[ "value" ].Text = tostring(cfg.value) .. cfg.suffix

            flags[cfg.flag] = cfg.value
            cfg.callback(flags[cfg.flag])
        end

        items[ "slider" ].MouseButton1Down:Connect(function()
            cfg.dragging = true 
            library:tween(items[ "value" ], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)
        end)

        library:connection(uis.InputChanged, function(input)
            if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
                local size_x = (input.Position.X - items[ "slider" ].AbsolutePosition.X) / items[ "slider" ].AbsoluteSize.X
                local value = ((cfg.max - cfg.min) * size_x) + cfg.min
                cfg.set(value)
            end
        end)

        library:connection(uis.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                cfg.dragging = false
                library:tween(items[ "value" ], {TextColor3 = rgb(72, 72, 73)}, Enum.EasingStyle.Quad, 0.2) 
            end 
        end)

        if cfg.seperator then 
            library:create( "Frame" , {
                AnchorPoint = vec2(0, 1);
                Parent = self.items[ "elements" ];
                Position = dim2(0, 0, 1, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 1, 0, 1);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(36, 36, 37)
            });
        end 

        cfg.set(cfg.default)
        
        library.flag_objects[cfg.flag] = cfg


        return setmetatable(cfg, library)
    end 

    function library:dropdown(options) 
        local cfg = {
            name = options.name or nil;
            info = options.info or nil;
            flag = options.flag or library:next_flag();
            options = options.options or options.items or {""};
            callback = options.callback or function() end;
            multi = options.multi or false;
            scrolling = options.scrolling or false;
            width = options.width or 130;

            -- Ignore these 
            open = false;
            option_instances = {};
            multi_items = {};
            ignore = options.ignore or false;
            items = {};
            y_size;
            seperator = options.seperator or options.Seperator or true;
        }   
        
        cfg.default = options.default or (cfg.multi and {cfg.options[1]}) or cfg.options[1] or "None"
        flags[cfg.flag] = cfg.default

        local items = cfg.items; do 
            -- Element
                items[ "dropdown_object" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "Dropdown";
                    Parent = items[ "dropdown_object" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                if getgenv().translator then getgenv().translator:add_element(items[ "name" ], "Text") end
                
                if cfg.info then 
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    if getgenv().translator then getgenv().translator:add_element(items[ "info" ], "Text") end
                end 

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "dropdown_object" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                items[ "dropdown" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(0, cfg.width, 0, 16);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "dropdown" ];
                    CornerRadius = dim(0, 6)
                });
                -- Clean outline only for dropdown (flatter look)
                library:create( "UIStroke" , { Parent = items[ "dropdown" ]; Color = rgb(23,23,29); ApplyStrokeMode = Enum.ApplyStrokeMode.Border; Transparency = 0.3 });
                
                items[ "sub_text" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(86, 86, 87);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "awdawdawdawdawdawdawdaw";
                    Parent = items[ "dropdown" ];
                    Name = "\0";
                    Size = dim2(1, -12, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "sub_text" ];
                    PaddingTop = dim(0, 1);
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "indicator" ] = library:create( "ImageLabel" , {
                    ImageColor3 = rgb(86, 86, 87);
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "dropdown" ];
                    AnchorPoint = vec2(1, 0.5);
                    Image = "rbxassetid://101025591575185";
                    BackgroundTransparency = 1;
                    Position = dim2(1, -5, 0.5, 0);
                    Name = "\0";
                    Size = dim2(0, 12, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
            -- 

            -- Element Holder
                items[ "dropdown_holder" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = library[ "items" ];
                    Name = "\0";
                    Visible = true;
                    BackgroundTransparency = 1;
                    Size = dim2(0, 0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0);
                    ZIndex = 10;
                });
                
                items[ "outline" ] = library:create( "Frame" , {
                    Parent = items[ "dropdown_holder" ];
                    Size = dim2(1, 0, 1, 0);
                    ClipsDescendants = true;
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(33, 33, 35);
                    ZIndex = 10;
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 6);
                    PaddingTop = dim(0, 3);
                    PaddingLeft = dim(0, 3);
                    Parent = items[ "outline" ]
                });

                items[ "list_scroller" ] = library:create( "ScrollingFrame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Position = dim2(0, 3, 0, 3);
                    Size = dim2(1, -6, 1, -9);
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    CanvasSize = dim2(0, 0, 0, 0);
                    ScrollBarThickness = 2;
                    ZIndex = 10;
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "list_scroller" ];
                    Padding = dim(0, 4);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 4)
                });
            -- 
        end 

        function cfg.render_option(text)
            local button = library:create( "TextButton" , {
                FontFace = fonts.small;
                TextColor3 = rgb(72, 72, 73);
                BorderColor3 = rgb(0, 0, 0);
                Text = tostring(text);
                Parent = items[ "list_scroller" ];
                Name = "\0";
                Size = dim2(1, -12, 0, 24);
                BackgroundTransparency = 0;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                TextSize = 14;
                BackgroundColor3 = rgb(33, 33, 35);
                ZIndex = 10;
            }); library:apply_theme(button, "accent", "TextColor3");
            library:create( "UICorner" , { Parent = button; CornerRadius = dim(0,4) });
            library:create( "UIStroke" , { Parent = button; Color = rgb(23,23,29); ApplyStrokeMode = Enum.ApplyStrokeMode.Border });
            
            library:create( "UIPadding" , {
                Parent = button;
                PaddingTop = dim(0, 2);
                PaddingRight = dim(0, 5);
                PaddingLeft = dim(0, 5);
                PaddingBottom = dim(0, 2)
            });
            
            return button
        end
        
        function cfg.set_visible(bool)
            local maxVisible = 10
            local rowHeight = 28
            local itemCount = math.max(1, #cfg.option_instances)
            local visibleHeight = math.min(maxVisible, itemCount) * rowHeight + 9
            local fullHeight = math.max(25, cfg.y_size)

            local targetHeight = bool and math.max(25, math.min(fullHeight, visibleHeight)) or 0
            library:tween(items[ "dropdown_holder" ], {Size = dim_offset(items[ "dropdown" ].AbsoluteSize.X, targetHeight)})

            items[ "dropdown_holder" ].Position = dim2(0, items[ "dropdown" ].AbsolutePosition.X, 0, items[ "dropdown" ].AbsolutePosition.Y + 20)

            if items[ "list_scroller" ] then
                items[ "list_scroller" ].CanvasSize = dim2(0, 0, 0, math.max(0, fullHeight - visibleHeight))
                items[ "list_scroller" ].ScrollBarThickness = (fullHeight > visibleHeight) and 2 or 0
            end

            if not (self.sanity and library.current_open == self) then 
                library:close_element(cfg)
            end
        end
        
        function cfg.set(value)
            local selected = {}
            local isTable = type(value) == "table"

            for _, option in cfg.option_instances do 
                if option.Text == value or (isTable and find(value, option.Text)) then 
                    insert(selected, option.Text)
                    cfg.multi_items = selected
                    option.TextColor3 = themes.preset.accent
                else
                    option.TextColor3 = rgb(72, 72, 73)
                end
            end

            items[ "sub_text" ].Text = isTable and concat(selected, ", ") or selected[1] or ""
            flags[cfg.flag] = isTable and selected or selected[1]
            
            cfg.callback(flags[cfg.flag]) 
        end
        
        function cfg.refresh_options(list) 
            if type(list) ~= "table" then return end
            cfg.options = list;
            cfg.y_size = 0

            for _, option in cfg.option_instances do 
                option:Destroy() 
            end
            
            cfg.option_instances = {} 

            for _, option in list do 
                local button = cfg.render_option(option)
                cfg.y_size += 29
                insert(cfg.option_instances, button)
                
                button.MouseButton1Down:Connect(function()
                    if cfg.multi then 
                        local selected_index = find(cfg.multi_items, button.Text)
                        
                        if selected_index then 
                            remove(cfg.multi_items, selected_index)
                        else
                            insert(cfg.multi_items, button.Text)
                        end
                        
                        cfg.set(cfg.multi_items) 				
                    else 
                        cfg.set_visible(false)
                        cfg.open = false 
                        
                        cfg.set(button.Text)
                    end
                end)
            end
        end

        items[ "dropdown" ].MouseButton1Click:Connect(function()
            cfg.refresh_options(cfg.options)
            cfg.open = not cfg.open 
            cfg.set_visible(cfg.open)
        end)

        if cfg.seperator then 
            library:create( "Frame" , {
                AnchorPoint = vec2(0, 1);
                Parent = self.items[ "elements" ];
                Position = dim2(0, 0, 1, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 1, 0, 1);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(36, 36, 37)
            });
        end 

        flags[cfg.flag] = {} 

        
        cfg.refresh_options(cfg.options)
        cfg.set(cfg.default)
        
        library.flag_objects[cfg.flag] = cfg
            
        return setmetatable(cfg, library)
    end

    function library:label(options)
        local cfg = {
            enabled = options.enabled or nil,
            name = options.name or "Toggle",
            seperator = options.seperator or options.Seperator or false;
            info = options.info or nil; 

            items = {};
        }

        local items = cfg.items; do 
            items[ "label" ] = library:create( "TextButton" , {
                FontFace = fonts.small;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Text = "";
                Parent = self.items[ "elements" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 0, 0);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.Y;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            items[ "name" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(245, 245, 245);
                BorderColor3 = rgb(0, 0, 0);
                Text = cfg.name;
                Parent = items[ "label" ];
                Name = "\0";
                Size = dim2(1, 0, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextWrapped = true;
                TextTruncate = Enum.TextTruncate.None;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            if getgenv().translator then getgenv().translator:add_element(items[ "name" ], "Text") end

            if cfg.info then 
                items[ "info" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(130, 130, 130);
                    BorderColor3 = rgb(0, 0, 0);
                    TextWrapped = true;
                    Text = cfg.info;
                    Parent = items[ "label" ];
                    Name = "\0";
                    Position = dim2(0, 5, 0, 17);
                    Size = dim2(1, -10, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                if getgenv().translator then getgenv().translator:add_element(items[ "info" ], "Text") end
            end 
            
            library:create( "UIPadding" , {
                Parent = items[ "name" ];
                PaddingRight = dim(0, 5);
                PaddingLeft = dim(0, 5)
            });
            
            items[ "right_components" ] = library:create( "Frame" , {
                Parent = items[ "label" ];
                Name = "\0";
                Position = dim2(1, 0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 0, 1, 0);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            library:create( "UIListLayout" , {
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                Parent = items[ "right_components" ];
                Padding = dim(0, 9);
                SortOrder = Enum.SortOrder.LayoutOrder
            });                
        end 
        
        function cfg.set_text(text)
            cfg.name = text
            items[ "name" ].Text = text
        end
        
        function cfg.set_name(text)
            cfg.set_text(text)
        end

        if cfg.seperator then 
            library:create( "Frame" , {
                AnchorPoint = vec2(0, 1);
                Parent = self.items[ "elements" ];
                Position = dim2(0, 0, 1, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 1, 0, 1);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(36, 36, 37)
            });
        end 

        return setmetatable(cfg, library)
    end 
    
    function library:colorpicker(options) 
        local cfg = {
            name = options.name or "Color", 
            flag = options.flag or library:next_flag(),

            color = options.color or color(1, 1, 1), -- Default to white color if not provided
            alpha = options.alpha and 1 - options.alpha or 0,
            
            open = false, 
            callback = options.callback or function() end,
            items = {};

            seperator = options.seperator or options.Seperator or false;
        }

        local dragging_sat = false 
        local dragging_hue = false 
        local dragging_alpha = false 

        local h, s, v = cfg.color:ToHSV() 
        local a = cfg.alpha 

        flags[cfg.flag] = {Color = cfg.color, Transparency = cfg.alpha}

        local label; 
        if not self.items.right_components then 
            label = self:label({name = cfg.name, seperator = cfg.seperator})
        end

        local items = cfg.items; do 
            -- Component
                items[ "colorpicker" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = label and label.items.right_components or self.items[ "right_components" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(0, 16, 0, 16);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(54, 31, 184)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "colorpicker" ];
                    CornerRadius = dim(0, 4)
                });
                
                items[ "colorpicker_inline" ] = library:create( "Frame" , {
                    Parent = items[ "colorpicker" ];
                    Size = dim2(1, -2, 1, -2);
                    Name = "\0";
                    BorderMode = Enum.BorderMode.Inset;
                    BorderColor3 = rgb(0, 0, 0);
                    Position = dim2(0, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(54, 31, 184)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "colorpicker_inline" ];
                    CornerRadius = dim(0, 4)
                });
                
                library:create( "UIGradient" , {
                    Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                    Parent = items[ "colorpicker_inline" ]
                });         
            --
            
            -- Colorpicker
                items[ "colorpicker_holder" ] = library:create( "Frame" , {
                    Parent = library[ "other" ];
                    Name = "\0";
                    Position = dim2(0.20000000298023224, 20, 0.296999990940094, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 166, 0, 197);
                    BorderSizePixel = 0;
                    Visible = false;
                    BackgroundColor3 = rgb(25, 25, 29)
                });

                items[ "colorpicker_fade" ] = library:create( "Frame" , {
                    Parent = items[ "colorpicker_holder" ];
                    Name = "\0";
                    BackgroundTransparency = 0;
                    Position = dim2(0, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    ZIndex = 100;
                    BackgroundColor3 = rgb(25, 25, 29)
                });
                
                items[ "colorpicker_components" ] = library:create( "Frame" , {
                    Parent = items[ "colorpicker_holder" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(22, 22, 24)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "colorpicker_components" ];
                    CornerRadius = dim(0, 6)
                });
                
                items[ "saturation_holder" ] = library:create( "Frame" , {
                    Parent = items[ "colorpicker_components" ];
                    Name = "\0";
                    Position = dim2(0, 7, 0, 7);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -14, 1, -80);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 39, 39)
                });
                
                items[ "sat" ] = library:create( "TextButton" , {
                    Parent = items[ "saturation_holder" ];
                    Name = "\0";
                    Size = dim2(1, 0, 1, 0);
                    Text = "";
                    AutoButtonColor = false;
                    BorderColor3 = rgb(0, 0, 0);
                    ZIndex = 2;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "sat" ];
                    CornerRadius = dim(0, 4)
                });
                
                library:create( "UIGradient" , {
                    Rotation = 270;
                    Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                    Parent = items[ "sat" ];
                    Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                });
                
                items[ "val" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "saturation_holder" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIGradient" , {
                    Parent = items[ "val" ];
                    Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "val" ];
                    CornerRadius = dim(0, 4)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "saturation_holder" ];
                    CornerRadius = dim(0, 4)
                });
                
                items[ "satvalpicker" ] = library:create( "TextButton" , {
                    BorderColor3 = rgb(0, 0, 0);
                    AutoButtonColor = false;
                    Text = "";
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "saturation_holder" ];
                    Name = "\0";
                    Position = dim2(0, 0, 4, 0);
                    Size = dim2(0, 8, 0, 8);
                    ZIndex = 5;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 0, 0)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "satvalpicker" ];
                    CornerRadius = dim(0, 9999)
                });
                
                library:create( "UIStroke" , {
                    Color = rgb(255, 255, 255);
                    Parent = items[ "satvalpicker" ];
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                });
                
                items[ "hue_gradient" ] = library:create( "TextButton" , {
                    Parent = items[ "colorpicker_components" ];
                    Name = "\0";
                    Position = dim2(0, 10, 1, -64);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -20, 0, 8);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255);
                    AutoButtonColor = false;
                    Text = "";
                });
                
                library:create( "UIGradient" , {
                    Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))};
                    Parent = items[ "hue_gradient" ]
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "hue_gradient" ];
                    CornerRadius = dim(0, 6)
                });
                
                items[ "hue_picker" ] = library:create( "TextButton" , {
                    BorderColor3 = rgb(0, 0, 0);
                    AutoButtonColor = false;
                    Text = "";
                    AnchorPoint = vec2(0, 0.5);
                    Parent = items[ "hue_gradient" ];
                    Name = "\0";
                    Position = dim2(0, 0, 0.5, 0);
                    Size = dim2(0, 8, 0, 8);
                    ZIndex = 5;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 0, 0)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "hue_picker" ];
                    CornerRadius = dim(0, 9999)
                });
                
                library:create( "UIStroke" , {
                    Color = rgb(255, 255, 255);
                    Parent = items[ "hue_picker" ];
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                });
                
                items[ "alpha_gradient" ] = library:create( "TextButton" , {
                    Parent = items[ "colorpicker_components" ];
                    Name = "\0";
                    Position = dim2(0, 10, 1, -46);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -20, 0, 8);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(25, 25, 29);
                    AutoButtonColor = false;
                    Text = "";
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "alpha_gradient" ];
                    CornerRadius = dim(0, 6)
                });
                
                items[ "alpha_picker" ] = library:create( "TextButton" , {
                    BorderColor3 = rgb(0, 0, 0);
                    AutoButtonColor = false;
                    Text = "";
                    AnchorPoint = vec2(0, 0.5);
                    Parent = items[ "alpha_gradient" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0.5, 0);
                    Size = dim2(0, 8, 0, 8);
                    ZIndex = 5;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 0, 0)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "alpha_picker" ];
                    CornerRadius = dim(0, 9999)
                });
                
                library:create( "UIStroke" , {
                    Color = rgb(255, 255, 255);
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Parent = items[ "alpha_picker" ]
                });
                
                library:create( "UIGradient" , {
                    Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255))};
                    Parent = items[ "alpha_gradient" ]
                });
                
                items[ "alpha_indicator" ] = library:create( "ImageLabel" , {
                    ScaleType = Enum.ScaleType.Tile;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "alpha_gradient" ];
                    Image = "rbxassetid://18274452449";
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 1, 0);
                    TileSize = dim2(0, 6, 0, 6);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                library:create( "UIGradient" , {
                    Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, rgb(255, 0, 0))};
                    Transparency = numseq{numkey(0, 0.8062499761581421), numkey(1, 0)};
                    Parent = items[ "alpha_indicator" ]
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "alpha_indicator" ];
                    CornerRadius = dim(0, 6)
                });
                
                library:create( "UIGradient" , {
                    Rotation = 90;
                    Parent = items[ "colorpicker_components" ];
                    Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(66, 66, 66))}
                });

                items[ "input" ] = library:create( "TextBox" , {
                    FontFace = fonts.font;
                    AnchorPoint = vec2(1, 1);
                    Text = "";
                    Parent = items[ "colorpicker_components" ];
                    Name = "\0";
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    PlaceholderColor3 = rgb(255, 255, 255);
                    CursorPosition = -1;
                    ClearTextOnFocus = false;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255);
                    TextColor3 = rgb(72, 72, 72);
                    BorderColor3 = rgb(0, 0, 0);
                    Position = dim2(1, -8, 1, -11);
                    Size = dim2(1, -16, 0, 18);
                    BackgroundColor3 = rgb(33, 33, 35)
                }); 
                
                library:create( "UICorner" , {
                    Parent = items[ "input" ];
                    CornerRadius = dim(0, 3)
                });
                
                items[ "UICorenr" ] = library:create( "UICorner" , { -- fire misstypo (im not fixing this RAWR)
                    Parent = items[ "colorpicker_holder" ];
                    Name = "\0";
                    CornerRadius = dim(0, 4)
                });
            --                  
        end;

        function cfg.set_visible(bool)
            items[ "colorpicker_fade" ].BackgroundTransparency = 0
            items[ "colorpicker_holder" ].Parent = bool and library[ "items" ] or library[ "other" ]
            items[ "colorpicker_holder" ].Visible = bool
            items[ "colorpicker_holder" ].Position = dim_offset(items[ "colorpicker" ].AbsolutePosition.X, items[ "colorpicker" ].AbsolutePosition.Y + items[ "colorpicker" ].AbsoluteSize.Y + 45)

            library:tween(items[ "colorpicker_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
            library:tween(items[ "colorpicker_holder" ], {Position = items[ "colorpicker_holder" ].Position + dim_offset(0, 20)}) -- p100 check
            
            if not (self.sanity and library.current_open == self and self.open) then 
                library:close_element(cfg)
            end
        end

        function cfg.set(color, alpha)
            if type(color) == "boolean" then 
                return
            end 

            if color then 
                h, s, v = color:ToHSV()
            end
            
            if alpha then 
                a = alpha
            end 
            
            local Color = hsv(h, s, v)

            -- Ok so quick story, should I cache any of this? no...?? anyways I know this code is very bad but its your fault for buying a ui with animations (on a serious note im too lazy to make this look nice)
            -- Also further note, yeah I kind of did this scale_factor * size-valuesize.plane because then I would have to do tomfoolery to make it clip properly.
            library:tween(items[ "hue_picker" ], {Position = dim2(0, (items[ "hue_gradient" ].AbsoluteSize.X - items[ "hue_picker" ].AbsoluteSize.X) * h, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
            library:tween(items[ "alpha_picker" ], {Position = dim2(0, (items[ "alpha_gradient" ].AbsoluteSize.X - items[ "alpha_picker" ].AbsoluteSize.X) * (1 - a), 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
            library:tween(items[ "satvalpicker" ], {Position = dim2(0, s * (items[ "saturation_holder" ].AbsoluteSize.X - items[ "satvalpicker" ].AbsoluteSize.X), 1, 1 - v * (items[ "saturation_holder" ].AbsoluteSize.Y - items[ "satvalpicker" ].AbsoluteSize.Y))}, Enum.EasingStyle.Linear, 0.05)

            items[ "alpha_indicator" ]:FindFirstChildOfClass("UIGradient").Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))}; -- shit code
            
            items[ "colorpicker" ].BackgroundColor3 = Color
            items[ "colorpicker_inline" ].BackgroundColor3 = Color
            items[ "saturation_holder" ].BackgroundColor3 = hsv(h, 1, 1)

            items[ "hue_picker" ].BackgroundColor3 = hsv(h, 1, 1)
            items[ "alpha_picker" ].BackgroundColor3 = hsv(h, 1, 1 - a)
            items[ "satvalpicker" ].BackgroundColor3 = hsv(h, s, v)

            flags[cfg.flag] = {
                Color = Color;
                Transparency = a 
            }
            
            local color = items[ "colorpicker" ].BackgroundColor3
            items[ "input" ].Text = string.format("%s, %s, %s, ", library:round(color.R * 255), library:round(color.G * 255), library:round(color.B * 255))
            items[ "input" ].Text ..= library:round(1 - a, 0.01)
            
            cfg.callback(Color, a)
        end
        
        function cfg.update_color() 
            local mouse = uis:GetMouseLocation() 
            local offset = vec2(mouse.X, mouse.Y - gui_offset) 

            if dragging_sat then	
                s = math.clamp((offset - items["sat"].AbsolutePosition).X / items["sat"].AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp((offset - items["sat"].AbsolutePosition).Y / items["sat"].AbsoluteSize.Y, 0, 1)
            elseif dragging_hue then
                h = math.clamp((offset - items[ "hue_gradient" ].AbsolutePosition).X / items[ "hue_gradient" ].AbsoluteSize.X, 0, 1)
            elseif dragging_alpha then
                a = 1 - math.clamp((offset - items[ "alpha_gradient" ].AbsolutePosition).X / items[ "alpha_gradient" ].AbsoluteSize.X, 0, 1)
            end

            cfg.set()
        end

        items[ "colorpicker" ].MouseButton1Click:Connect(function()
            cfg.open = not cfg.open 

            cfg.set_visible(cfg.open)            
        end)

        uis.InputChanged:Connect(function(input)
            if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
                cfg.update_color() 
            end
        end)

        library:connection(uis.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging_sat = false
                dragging_hue = false
                dragging_alpha = false
            end
        end)    

        items[ "alpha_gradient" ].MouseButton1Down:Connect(function()
            dragging_alpha = true 
        end)
        
        items[ "hue_gradient" ].MouseButton1Down:Connect(function()
            dragging_hue = true 
        end)
        
        items[ "sat" ].MouseButton1Down:Connect(function()
            dragging_sat = true  
        end)

        items[ "input" ].FocusLost:Connect(function()
            local text = items[ "input" ].Text
            local r, g, b, a = library:convert(text)
            
            if r and g and b and a then 
                cfg.set(rgb(r, g, b), 1 - a)
            end 
        end)

        items[ "input" ].Focused:Connect(function()
            library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
        end)

        items[ "input" ].FocusLost:Connect(function()
            library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
        end)
        
        cfg.set(cfg.color, cfg.alpha)
        
        library.flag_objects[cfg.flag] = cfg


        return setmetatable(cfg, library)
    end 

    function library:textbox(options) 
        local cfg = {
            name = options.name or "TextBox",
            placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
            default = options.default or "",
            flag = options.flag or library:next_flag(),
            callback = options.callback or function() end,
            visible = options.visible or true,
            items = {};
        }

        flags[cfg.flag] = cfg.default

        local items = cfg.items; do 
            items[ "textbox" ] = library:create( "TextButton" , {
                LayoutOrder = -1;
                FontFace = fonts.font;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Text = "";
                Parent = self.items[ "elements" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 0, 0);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.Y;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            items[ "name" ] = library:create( "TextLabel" , {
                FontFace = fonts.font;
                TextColor3 = rgb(245, 245, 245);
                BorderColor3 = rgb(0, 0, 0);
                Text = cfg.name;
                Parent = items[ "textbox" ];
                Name = "\0";
                Size = dim2(1, 0, 0, 0);
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 16;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            if getgenv().translator then getgenv().translator:add_element(items[ "name" ], "Text") end
            
            library:create( "UIPadding" , {
                Parent = items[ "name" ];
                PaddingRight = dim(0, 5);
                PaddingLeft = dim(0, 5)
            });
            
            items[ "right_components" ] = library:create( "Frame" , {
                Parent = items[ "textbox" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Position = dim2(0, 4, 0, 19);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 0, 0, 12);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            library:create( "UIListLayout" , {
                Parent = items[ "right_components" ];
                Padding = dim(0, 7);
                SortOrder = Enum.SortOrder.LayoutOrder;
                FillDirection = Enum.FillDirection.Horizontal
            });
            
            items[ "input" ] = library:create( "TextBox" , {
                FontFace = fonts.font;
                Text = "";
                Parent = items[ "right_components" ];
                Name = "\0";
                TextTruncate = Enum.TextTruncate.AtEnd;
                BorderSizePixel = 0;
                PlaceholderColor3 = rgb(255, 255, 255);
                CursorPosition = -1;
                ClearTextOnFocus = false;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255);
                TextColor3 = rgb(72, 72, 72);
                BorderColor3 = rgb(0, 0, 0);
                Position = dim2(1, 0, 0, 0);
                Size = dim2(1, -4, 0, 30);
                BackgroundColor3 = rgb(33, 33, 35)
            }); 

            library:create( "UICorner" , {
                Parent = items[ "input" ];
                CornerRadius = dim(0, 3)
            });                
            
            library:create( "UIPadding" , {
                Parent = items[ "right_components" ];
                PaddingTop = dim(0, 4);
                PaddingRight = dim(0, 4)
            });
        end 
        
        function cfg.set(text) 
            flags[cfg.flag] = text

            items[ "input" ].Text = text

            cfg.callback(text)
        end 
        
        function cfg.get()
            return items[ "input" ].Text
        end
        
        function cfg.clear()
            cfg.set("")
        end
        
        items[ "input" ]:GetPropertyChangedSignal("Text"):Connect(function()
            cfg.set(items[ "input" ].Text) 
        end)

        items[ "input" ].Focused:Connect(function()
            library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
        end)

        items[ "input" ].FocusLost:Connect(function()
            library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
        end)
            
        if cfg.default then 
            cfg.set(cfg.default) 
        end
        
        library.flag_objects[cfg.flag] = cfg



        return setmetatable(cfg, library)
    end

    function library:keybind(options) 
        local cfg = {
            flag = options.flag or library:next_flag(),
            callback = options.callback or function() end,
            name = options.name or nil, 
            ignore_key = options.ignore or false, 

            key = options.key or nil, 
            mode = options.mode or "Toggle",
            active = options.default or false, 

            open = false,
            binding = nil, 

            hold_instances = {},
            items = {};
        }

        flags[cfg.flag] = {
            mode = cfg.mode,
            key = cfg.key, 
            active = cfg.active
        }

        local items = cfg.items; do 
            -- Component
                items[ "keybind_element" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "keybind_element" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                if getgenv().translator then getgenv().translator:add_element(items[ "name" ], "Text") end
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "keybind_element" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                items[ "keybind_holder" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = items[ "right_components" ];
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Size = dim2(0, 0, 0, 16);
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "keybind_holder" ];
                    CornerRadius = dim(0, 4)
                });
                
                items[ "key" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(86, 86, 87);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "LSHIFT";
                    Parent = items[ "keybind_holder" ];
                    Name = "\0";
                    Size = dim2(1, -12, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "key" ];
                    PaddingTop = dim(0, 1);
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });                                  
            -- 
            
            -- Mode Holder
                items[ "dropdown" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = library.items;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 0);
                    Size = dim2(0, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "dropdown" ];
                    Size = dim2(1, 0, 1, 0);
                    Name = "\0";
                    ClipsDescendants = true;
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(22, 22, 24)
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 6);
                    PaddingTop = dim(0, 3);
                    PaddingLeft = dim(0, 3);
                    Parent = items[ "inline" ]
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "inline" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 4)
                });
                
                local options = {"Hold", "Toggle", "Always"}
                
                cfg.y_size = 20
                for _, option in options do                        
                    local name = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = option;
                        Parent = items[ "inline" ];
                        Name = "\0";
                        Size = dim2(0, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); cfg.hold_instances[option] = name
                    library:apply_theme(name, "accent", "TextColor3")
                    
                    cfg.y_size += name.AbsoluteSize.Y

                    library:create( "UIPadding" , {
                        Parent = name;
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    name.MouseButton1Click:Connect(function()
                        cfg.set(option)

                        cfg.set_visible(false)

                        cfg.open = false
                    end)
                end
            -- 
        end 
        
        function cfg.modify_mode_color(path) -- ts so frikin tuff 💀
            for _, v in cfg.hold_instances do 
                v.TextColor3 = rgb(72, 72, 72)
            end 

            cfg.hold_instances[path].TextColor3 = themes.preset.accent
        end

        function cfg.set_mode(mode) 
            cfg.mode = mode 

            if mode == "Always" then
                cfg.set(true)
            elseif mode == "Hold" then
                cfg.set(false)
            end

            flags[cfg.flag]["mode"] = mode
            cfg.modify_mode_color(mode)
        end 

        function cfg.set(input)
            if type(input) == "boolean" then 
                cfg.active = input

                if cfg.mode == "Always" then 
                    cfg.active = true
                end
            elseif tostring(input):find("Enum") then 
                input = input.Name == "Escape" and "NONE" or input
                
                cfg.key = input or "NONE"	
            elseif find({"Toggle", "Hold", "Always"}, input) then 
                if input == "Always" then 
                    cfg.active = true 
                end 

                cfg.mode = input
                cfg.set_mode(cfg.mode) 
            elseif type(input) == "table" then 
                input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key) or input.key
                input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key

                cfg.key = input.key or "NONE"
                cfg.mode = input.mode or "Toggle"

                if input.active then
                    cfg.active = input.active
                end

                cfg.set_mode(cfg.mode) 
            end 

            cfg.callback(cfg.active)

            local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
            local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))
            
            items[ "key" ].Text = __text

            flags[cfg.flag] = {
                mode = cfg.mode,
                key = cfg.key, 
                active = cfg.active
            }
        end

        function cfg.set_visible(bool)
            local size = bool and cfg.y_size or 0
            library:tween(items[ "dropdown" ], {Size = dim_offset(items[ "keybind_holder" ].AbsoluteSize.X, size)})

            items[ "dropdown" ].Position = dim_offset(items[ "keybind_holder" ].AbsolutePosition.X, items[ "keybind_holder" ].AbsolutePosition.Y + items[ "keybind_holder" ].AbsoluteSize.Y + 60)
        end
    
        items[ "keybind_holder" ].MouseButton1Down:Connect(function()
            task.wait()
            items[ "key" ].Text = "..."	

            cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)  
                cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)
                
                cfg.binding:Disconnect() 
                cfg.binding = nil
            end)
        end)

        items[ "keybind_holder" ].MouseButton2Down:Connect(function()
            cfg.open = not cfg.open 

            cfg.set_visible(cfg.open)
        end)

        library:connection(uis.InputBegan, function(input, game_event) 
            if not game_event then
                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                if selected_key == cfg.key then 
                    if cfg.mode == "Toggle" then 
                        cfg.active = not cfg.active
                        cfg.set(cfg.active)
                    elseif cfg.mode == "Hold" then 
                        cfg.set(true)
                    end
                end
            end
        end)    

        library:connection(uis.InputEnded, function(input, game_event) 
            if game_event then 
                return 
            end 

            local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

            if selected_key == cfg.key then
                if cfg.mode == "Hold" then 
                    cfg.set(false)
                end
            end
        end)
        
        cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})
        
        library.flag_objects[cfg.flag] = cfg


        return setmetatable(cfg, library)
    end

    function library:button(options) 
        local cfg = {
            name = options.name or "TextBox",
            callback = options.callback or function() end,
            items = {};
        }
        
        local items = cfg.items; do 
            items[ "button_element" ] = library:create( "Frame" , {
                Parent = self.items[ "elements" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.Y;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            items[ "button" ] = library:create( "TextButton" , {
                FontFace = fonts.font;
                TextColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Text = "";
                AutoButtonColor = false;
                AnchorPoint = vec2(1, 0);
                Parent = items[ "button_element" ];
                Name = "\0";
                Position = dim2(1, -4, 0, 0);
                Size = dim2(1, -8, 0, 30);
                BorderSizePixel = 0;
                TextSize = 14;
                BackgroundColor3 = rgb(33, 33, 35)
            });
            
            library:create( "UICorner" , {
                Parent = items[ "button" ];
                CornerRadius = dim(0, 6)
            });
            library:create( "UIStroke" , { Parent = items[ "button" ]; Color = rgb(23,23,29); ApplyStrokeMode = Enum.ApplyStrokeMode.Border; Transparency = 0.3 });
            
            items[ "name" ] = library:create( "TextLabel" , {
                FontFace = fonts.small;
                TextColor3 = rgb(245, 245, 245);
                BorderColor3 = rgb(0, 0, 0);
                Text = cfg.name;
                Parent = items[ "button" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 1, 0);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            }); library:apply_theme(items[ "name" ], "accent", "BackgroundColor3");
            if getgenv().translator then getgenv().translator:add_element(items[ "name" ], "Text") end                            
        end 

        items[ "button" ].MouseButton1Click:Connect(function()
            cfg.callback()

            items[ "name" ].TextColor3 = themes.preset.accent 
            library:tween(items[ "name" ], {TextColor3 = rgb(245, 245, 245)})
        end)
        
        return setmetatable(cfg, library)
    end 

    function library:settings(options)  
        local cfg = {
            open = false; 
            items = {}; 
            sanity = true; -- made this for my own sanity.
        }

        local items = cfg.items; do 
            items[ "outline" ] = library:create( "Frame" , {
                Name = "\0";
                Visible = true;
                Parent = library[ "items" ];
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 0, 0, 0);
                ClipsDescendants = true;
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.Y;
                BackgroundColor3 = rgb(25, 25, 29)
            });
            
            items[ "inline" ] = library:create( "Frame" , {
                Parent = items[ "outline" ];
                Name = "\0";
                Position = dim2(0, 1, 0, 1);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, -2, 1, -2);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(22, 22, 24)
            });
            
            library:create( "UICorner" , {
                Parent = items[ "inline" ];
                CornerRadius = dim(0, 7)
            });
            
            items[ "elements" ] = library:create( "Frame" , {
                BorderColor3 = rgb(0, 0, 0);
                Parent = items[ "inline" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Position = library.is_mobile and dim2(0, 5, 0, 5) or dim2(0, 10, 0, 10);
                Size = library.is_mobile and dim2(1, -10, 0, 0) or dim2(1, -20, 0, 0);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.Y;
                BackgroundColor3 = rgb(255, 255, 255),
                ClipsDescendants = false
            });
            
            library:create( "UIListLayout" , {
                Parent = items[ "elements" ];
                Padding = dim(0, library.is_mobile and 35 or 10);
                SortOrder = Enum.SortOrder.LayoutOrder;
                HorizontalAlignment = Enum.HorizontalAlignment.Center;
                VerticalAlignment = Enum.VerticalAlignment.Top
            });
            
            library:create( "UIPadding" , {
                PaddingTop = dim(0, library.is_mobile and 20 or 10);
                PaddingBottom = dim(0, library.is_mobile and 20 or 15);
                Parent = items[ "elements" ];
                PaddingLeft = dim(0, library.is_mobile and 10 or 5);
                PaddingRight = dim(0, library.is_mobile and 10 or 5)
            });
            
            library:create( "UICorner" , {
                Parent = items[ "outline" ];
                CornerRadius = dim(0, 7)
            });
            
            library:create( "UICorner" , {
                Parent = items[ "fade" ];
                CornerRadius = dim(0, 7)
            });
            
            items[ "tick" ] = library:create( "ImageButton" , {
                Image = "rbxassetid://128797200442698";
                Name = "\0";
                AutoButtonColor = false;
                Parent = self.items[ "right_components" ];
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 16, 0, 16);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255)
            });                
        end 

        function cfg.set_visible(bool)                 
            library:tween(items[ "outline" ], {Size = dim_offset(bool and 240 or 0, 0)})
            items[ "outline" ].Position = dim_offset(items[ "tick" ].AbsolutePosition.X, items[ "tick" ].AbsolutePosition.Y + 90)
            library:close_element(cfg)
        end
        
        items[ "tick" ].MouseButton1Click:Connect(function()
            cfg.open = not cfg.open

            cfg.set_visible(cfg.open)
        end)

        cfg = setmetatable(cfg, library)
        
        return cfg
    end 

    function library:list(properties) 
        local cfg = {
            items = {};
            options = properties.options or {"1", "2", "3"};
            flag = properties.flag or library:next_flag();    
            callback = properties.callback or function() end;
            data_store = {};        
            current_element = nil;
        }

        local items = cfg.items; do
            items[ "list" ] = library:create( "Frame" , {
                Parent = self.items[ "elements" ];
                BackgroundTransparency = 1;
                Name = "\0";
                Size = dim2(1, 0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            
            library:create( "UIListLayout" , {
                Parent = items[ "list" ];
                Padding = dim(0, 10);
                SortOrder = Enum.SortOrder.LayoutOrder
            });
            
            library:create( "UIPadding" , {
                Parent = items[ "list" ];
                PaddingRight = dim(0, 4);
                PaddingLeft = dim(0, 4)
            });
        end 

        function cfg.refresh_options(options_to_refresh) -- ignore goofy parameter
            for _,option in pairs(cfg.data_store) do 
                option:Destroy()
            end
            
            cfg.data_store = {}
            
            for i = 1, #options_to_refresh do
                local option_data = options_to_refresh[i]
                local button = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "list" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, 0, 0, 30);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                }); cfg.data_store[#cfg.data_store + 1] = button;

                local name = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = option_data;
                    Parent = button;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UICorner" , {
                    Parent = button;
                    CornerRadius = dim(0, 3)
                });     

                button.MouseButton1Click:Connect(function()
                    local current = cfg.current_element 
                    if current and current ~= name then 
                        library:tween(current, {TextColor3 = rgb(72, 72, 72)})
                    end

                    flags[cfg.flag] = option_data
                    cfg.callback(option_data)
                    library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                    cfg.current_element = name
                end)

                name.MouseEnter:Connect(function()
                    if cfg.current_element == name then 
                        return 
                    end 

                    library:tween(name, {TextColor3 = rgb(140, 140, 140)})
                end)

                name.MouseLeave:Connect(function()
                    if cfg.current_element == name then 
                        return 
                    end 

                    library:tween(name, {TextColor3 = rgb(72, 72, 72)})
                end)
            end
        end

        cfg.refresh_options(cfg.options)

        return setmetatable(cfg, library)
    end 

    function library:config_manager(properties)
        local cfg = {
            items = {};
            selected_config = nil;
            autoload_enabled = false;
        }

        local name_textbox = self:textbox({
            name = "Config Name",
            placeholder = "Enter config name...",
            default = "",
            flag = library:next_flag()
        })

        local available_configs = library:get_configs()
        if #available_configs == 0 then
            available_configs = {"No configs found"}
        end

        local config_dropdown = self:dropdown({
            name = "Select Config",
            options = available_configs,
            default = available_configs[1],
            flag = library:next_flag(),
            width = 220,
            callback = function(selected)
                if selected and selected ~= "No configs found" then
                    cfg.selected_config = selected
                    name_textbox.set(selected)
                end
            end
        })

        local save_button = self:button({
            name = "Save Config",
            callback = function()
                local config_name = flags[name_textbox.flag]
                if config_name and config_name ~= "" then
                    if library:save_config(config_name) then
                        local configs = library:get_configs()
                        if #configs == 0 then configs = {"No configs found"} end
                        config_dropdown.refresh_options(configs)
                        config_dropdown.set(config_name)
                    end
                end
            end
        })

        local load_button = self:button({
            name = "Load Config",
            callback = function()
                local config_name = cfg.selected_config or flags[name_textbox.flag]
                if config_name and config_name ~= "" and config_name ~= "No configs found" then
                    library:load_config(config_name)
                end
            end
        })

        local delete_button = self:button({
            name = "Delete Config",
            callback = function()
                local config_name = cfg.selected_config or flags[name_textbox.flag]
                if config_name and config_name ~= "" and config_name ~= "No configs found" then
                    if library:delete_config(config_name) then
                        local configs = library:get_configs()
                        if #configs == 0 then configs = {"No configs found"} end
                        config_dropdown.refresh_options(configs)
                        config_dropdown.set(configs[1])
                    end
                end
            end
        })

        local duplicate_button = self:button({
            name = "Duplicate Config",
            callback = function()
                local old_name = cfg.selected_config
                local new_name = flags[name_textbox.flag]
                if old_name and old_name ~= "" and old_name ~= "No configs found" and new_name and new_name ~= "" and old_name ~= new_name then
                    if library:duplicate_config(old_name, new_name) then
                        local configs = library:get_configs()
                        if #configs == 0 then configs = {"No configs found"} end
                        config_dropdown.refresh_options(configs)
                        config_dropdown.set(new_name)
                    end
                end
            end
        })

        local rename_button = self:button({
            name = "Rename Config",
            callback = function()
                local old_name = cfg.selected_config
                local new_name = flags[name_textbox.flag]
                if old_name and old_name ~= "" and old_name ~= "No configs found" and new_name and new_name ~= "" and old_name ~= new_name then
                    if library:rename_config(old_name, new_name) then
                        local configs = library:get_configs()
                        if #configs == 0 then configs = {"No configs found"} end
                        config_dropdown.refresh_options(configs)
                        config_dropdown.set(new_name)
                    end
                end
            end
        })

        local refresh_button = self:button({
            name = "Refresh List",
            callback = function()
                local configs = library:get_configs()
                if #configs == 0 then configs = {"No configs found"} end
                config_dropdown.refresh_options(configs)
                notifications:create_notification({
                    name = "Config List",
                    info = "Refreshed config list",
                    lifetime = 2
                })
            end
        })

        local export_textbox = self:textbox({
            name = "Import/Export",
            placeholder = "Paste config data here...",
            default = "",
            flag = library:next_flag()
        })

        local export_button = self:button({
            name = "Export to Clipboard",
            callback = function()
                local config_name = cfg.selected_config or flags[name_textbox.flag]
                if config_name and config_name ~= "" and config_name ~= "No configs found" then
                    local exported = library:export_config(config_name)
                    if exported then
                        export_textbox.set(exported)
                        if setclipboard then
                            setclipboard(exported)
                            notifications:create_notification({
                                name = "Config Exported",
                                info = "Copied to clipboard!",
                                lifetime = 3
                            })
                        else
                            notifications:create_notification({
                                name = "Config Exported",
                                info = "Copy from textbox",
                                lifetime = 3
                            })
                        end
                    end
                end
            end
        })

        local import_button = self:button({
            name = "Import from Textbox",
            callback = function()
                local import_data = flags[export_textbox.flag]
                local config_name = flags[name_textbox.flag]
                if import_data and import_data ~= "" and config_name and config_name ~= "" then
                    if library:import_config(import_data, config_name) then
                        local configs = library:get_configs()
                        if #configs == 0 then configs = {"No configs found"} end
                        config_dropdown.refresh_options(configs)
                        config_dropdown.set(config_name)
                    end
                end
            end
        })

        local autoload_toggle = self:toggle({
            name = "Auto-load on startup",
            default = false,
            flag = library:next_flag(),
            callback = function(enabled)
                cfg.autoload_enabled = enabled
                if enabled and cfg.selected_config then
                    library:set_autoload(cfg.selected_config)
                else
                    library:set_autoload(nil)
                end
            end
        })

        if library:get_autoload() then
            autoload_toggle.set(true)
            cfg.autoload_enabled = true
        end
    end


--

-- Notification Library
    function notifications:refresh_notifs() 
        local offset = 50

        for i, v in notifications.notifs do
            local Position = vec2(20, offset)
            library:tween(v, {Position = dim_offset(Position.X, Position.Y)}, Enum.EasingStyle.Quad, 0.4)
            offset += (v.AbsoluteSize.Y + 10)
        end

        return offset
    end
    
    function notifications:fade(path, is_fading)
        local fading = is_fading and 1 or 0 
        
        library:tween(path, {BackgroundTransparency = fading}, Enum.EasingStyle.Quad, 1)

        for _, instance in path:GetDescendants() do 
            if not instance:IsA("GuiObject") then 
                if instance:IsA("UIStroke") then
                    library:tween(instance, {Transparency = fading}, Enum.EasingStyle.Quad, 1)
                end
    
                continue
            end 
    
            if instance:IsA("TextLabel") then
                library:tween(instance, {TextTransparency = fading})
            elseif instance:IsA("Frame") then
                library:tween(instance, {BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6}, Enum.EasingStyle.Quad, 1)
            end
        end
    end 
    
    function notifications:create_notification(options)
        local cfg = {
            name = options.name or "This is a title!";
            info = options.info or "This is extra info!";
            lifetime = options.lifetime or 3;
            items = {};
            outline;
        }

        local items = cfg.items; do 
            items[ "notification" ] = library:create( "Frame" , {
                Parent = library[ "items" ];
                Size = dim2(0, 210, 0, 53);
                Name = "\0";
                BorderColor3 = rgb(0, 0, 0);
                BorderSizePixel = 0;
                BackgroundTransparency = 1;
                AnchorPoint = vec2(1, 0);
                AutomaticSize = Enum.AutomaticSize.Y;
                BackgroundColor3 = rgb(14, 14, 16)
            });
            
            library:create( "UIStroke" , {
                Color = rgb(23, 23, 29);
                Parent = items[ "notification" ];
                Transparency = 1;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            });
            
            items[ "title" ] = library:create( "TextLabel" , {
                FontFace = fonts.font;
                TextColor3 = rgb(255, 255, 255);
                BorderColor3 = rgb(0, 0, 0);
                Text = cfg.name;
                Parent = items[ "notification" ];
                Name = "\0";
                BackgroundTransparency = 1;
                Position = dim2(0, 7, 0, 6);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            if getgenv().translator then getgenv().translator:add_element(items[ "title" ], "Text") end
            
            library:create( "UICorner" , {
                Parent = items[ "notification" ];
                CornerRadius = dim(0, 3)
            });
            
            items[ "info" ] = library:create( "TextLabel" , {
                FontFace = fonts.font;
                TextColor3 = rgb(145, 145, 145);
                BorderColor3 = rgb(0, 0, 0);
                Text = cfg.info;
                Parent = items[ "notification" ];
                Name = "\0";
                Position = dim2(0, 9, 0, 22);
                BorderSizePixel = 0;
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextWrapped = true;
                AutomaticSize = Enum.AutomaticSize.XY;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            });
            if getgenv().translator then getgenv().translator:add_element(items[ "info" ], "Text") end
            
            library:create( "UIPadding" , {
                PaddingBottom = dim(0, 17);
                PaddingRight = dim(0, 8);
                Parent = items[ "info" ]
            });
            
            items[ "bar" ] = library:create( "Frame" , {
                AnchorPoint = vec2(0, 1);
                Parent = items[ "notification" ];
                Name = "\0";
                Position = dim2(0, 8, 1, -6);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 0, 0, 5);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                BackgroundColor3 = themes.preset.accent
            });
            
            library:create( "UICorner" , {
                Parent = items[ "bar" ];
                CornerRadius = dim(0, 999)
            });
            
            library:create( "UIPadding" , {
                PaddingRight = dim(0, 8);
                Parent = items[ "notification" ]
            });
        end
        
        local index = #notifications.notifs + 1
        notifications.notifs[index] = items[ "notification" ]

        notifications:fade(items[ "notification" ], false)
        
        local offset = notifications:refresh_notifs()

        items[ "notification" ].Position = dim_offset(20, offset)

        library:tween(items[ "notification" ], {AnchorPoint = vec2(0, 0)}, Enum.EasingStyle.Quad, 1)
        library:tween(items[ "bar" ], {Size = dim2(1, -8, 0, 5)}, Enum.EasingStyle.Quad, cfg.lifetime)

        task.spawn(function()
            task.wait(cfg.lifetime)
            
            notifications.notifs[index] = nil
            
            notifications:fade(items[ "notification" ], true)
            
            library:tween(items[ "notification" ], {AnchorPoint = vec2(1, 0)}, Enum.EasingStyle.Quad, 1)

            task.wait(1)
    
            items[ "notification" ]:Destroy() 
        end)
    end

    function library:unload()
        if self.unloading then return end
        self.unloading = true

        if self._onUnloadCallback then
            pcall(self._onUnloadCallback)
        end
        
        if self.items then
            pcall(function() self.items:Destroy() end)
        end

        for _, v in pairs(self.connections) do
            if typeof(v) == "RBXScriptConnection" then
                pcall(function() v:Disconnect() end)
            elseif type(v) == "table" and v.Disconnect then
                pcall(function() v:Disconnect() end)
            end
        end
        self.connections = {}

        if self.notifications and self.notifications.holder then
            pcall(function() self.notifications.holder:Destroy() end)
        end

        if getgenv().library == self then
            getgenv().library = nil
        end
    end

    function library:get_configs()
        local configs = {}
        local success, files = pcall(function()
            return listfiles(library.config.folder)
        end)
        
        if success and files then
            for _, file in pairs(files) do
                local name = file:match("([^/\\]+)%.json$")
                if name then
                    insert(configs, name)
                end
            end
        end
        
        return configs
    end

    function library:save_config(name)
        if not name or name == "" then
            notifications:create_notification({
                name = "Config Error",
                info = "Config name cannot be empty",
                lifetime = 3
            })
            return false
        end
        
        if name:match("[^%w%s_-]") then
            notifications:create_notification({
                name = "Config Error",
                info = "Invalid characters in config name",
                lifetime = 3
            })
            return false
        end
        
        local success, err = pcall(function()
            local data = http_service:JSONEncode(library.flags)
            local path = library.config.folder .. "/" .. name .. ".json"
            writefile(path, data)
            library.config.current = name
        end)
        
        if success then
            notifications:create_notification({
                name = "Config Saved",
                info = "Successfully saved: " .. name,
                lifetime = 3
            })
            return true
        else
            notifications:create_notification({
                name = "Config Error",
                info = "Failed to save config",
                lifetime = 3
            })
            return false
        end
    end

    function library:load_config(name)
        if not name or name == "" then
            notifications:create_notification({
                name = "Config Error",
                info = "Config name cannot be empty",
                lifetime = 3
            })
            return false
        end
        
        local path = library.config.folder .. "/" .. name .. ".json"
        
        local success, result = pcall(function()
            if not isfile(path) then
                error("Config file not found")
            end
            
            local data = readfile(path)
            local decoded = http_service:JSONDecode(data)
            
            for flag, value in pairs(decoded) do
                local flag_obj = library.flag_objects[flag]
                
                if flag_obj and flag_obj.set then
                    pcall(function()
                        flag_obj.set(value)
                    end)
                else
                    library.flags[flag] = value
                end
            end
            
            library.config.current = name
            return true
        end)
        
        if success and result then
            notifications:create_notification({
                name = "Config Loaded",
                info = "Successfully loaded: " .. name,
                lifetime = 3
            })
            return true
        else
            notifications:create_notification({
                name = "Config Error",
                info = "Failed to load config",
                lifetime = 3
            })
            return false
        end
    end

    function library:delete_config(name)
        if not name or name == "" then
            notifications:create_notification({
                name = "Config Error",
                info = "Config name cannot be empty",
                lifetime = 3
            })
            return false
        end
        
        local path = library.config.folder .. "/" .. name .. ".json"
        
        local success = pcall(function()
            if isfile(path) then
                delfile(path)
                if library.config.current == name then
                    library.config.current = nil
                end
            else
                error("Config not found")
            end
        end)
        
        if success then
            notifications:create_notification({
                name = "Config Deleted",
                info = "Successfully deleted: " .. name,
                lifetime = 3
            })
            return true
        else
            notifications:create_notification({
                name = "Config Error",
                info = "Failed to delete config",
                lifetime = 3
            })
            return false
        end
    end

    function library:duplicate_config(old_name, new_name)
        if not old_name or old_name == "" or not new_name or new_name == "" then
            notifications:create_notification({
                name = "Config Error",
                info = "Config names cannot be empty",
                lifetime = 3
            })
            return false
        end
        
        if new_name:match("[^%w%s_-]") then
            notifications:create_notification({
                name = "Config Error",
                info = "Invalid characters in new name",
                lifetime = 3
            })
            return false
        end
        
        local old_path = library.config.folder .. "/" .. old_name .. ".json"
        local new_path = library.config.folder .. "/" .. new_name .. ".json"
        
        local success = pcall(function()
            if not isfile(old_path) then
                error("Source config not found")
            end
            
            local data = readfile(old_path)
            writefile(new_path, data)
        end)
        
        if success then
            notifications:create_notification({
                name = "Config Duplicated",
                info = "Created: " .. new_name,
                lifetime = 3
            })
            return true
        else
            notifications:create_notification({
                name = "Config Error",
                info = "Failed to duplicate config",
                lifetime = 3
            })
            return false
        end
    end

    function library:rename_config(old_name, new_name)
        if not old_name or old_name == "" or not new_name or new_name == "" then
            notifications:create_notification({
                name = "Config Error",
                info = "Config names cannot be empty",
                lifetime = 3
            })
            return false
        end
        
        if new_name:match("[^%w%s_-]") then
            notifications:create_notification({
                name = "Config Error",
                info = "Invalid characters in new name",
                lifetime = 3
            })
            return false
        end
        
        local old_path = library.config.folder .. "/" .. old_name .. ".json"
        local new_path = library.config.folder .. "/" .. new_name .. ".json"
        
        local success = pcall(function()
            if not isfile(old_path) then
                error("Source config not found")
            end
            
            local data = readfile(old_path)
            writefile(new_path, data)
            delfile(old_path)
            
            if library.config.current == old_name then
                library.config.current = new_name
            end
        end)
        
        if success then
            notifications:create_notification({
                name = "Config Renamed",
                info = "Renamed to: " .. new_name,
                lifetime = 3
            })
            return true
        else
            notifications:create_notification({
                name = "Config Error",
                info = "Failed to rename config",
                lifetime = 3
            })
            return false
        end
    end

    function library:export_config(name)
        if not name or name == "" then
            return nil
        end
        
        local path = library.config.folder .. "/" .. name .. ".json"
        
        local success, result = pcall(function()
            if not isfile(path) then
                error("Config not found")
            end
            
            local data = readfile(path)
            local encoded = game:GetService("HttpService"):JSONEncode({
                version = "1.0",
                name = name,
                data = data
            })
            
            local b64 = ""
            local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
            
            for i = 1, #encoded, 3 do
                local c1, c2, c3 = encoded:byte(i, i + 2)
                local n = c1 * 65536 + (c2 or 0) * 256 + (c3 or 0)
                local n1 = math.floor(n / 262144)
                local n2 = math.floor((n % 262144) / 4096)
                local n3 = math.floor((n % 4096) / 64)
                local n4 = n % 64
                b64 = b64 .. b:sub(n1 + 1, n1 + 1) .. b:sub(n2 + 1, n2 + 1) .. 
                      (c2 and b:sub(n3 + 1, n3 + 1) or "=") .. (c3 and b:sub(n4 + 1, n4 + 1) or "=")
            end
            
            return b64
        end)
        
        if success then
            return result
        else
            notifications:create_notification({
                name = "Export Error",
                info = "Failed to export config",
                lifetime = 3
            })
            return nil
        end
    end

    function library:import_config(data, name)
        if not data or data == "" or not name or name == "" then
            notifications:create_notification({
                name = "Import Error",
                info = "Invalid import data or name",
                lifetime = 3
            })
            return false
        end
        
        if name:match("[^%w%s_-]") then
            notifications:create_notification({
                name = "Config Error",
                info = "Invalid characters in config name",
                lifetime = 3
            })
            return false
        end
        
        local success = pcall(function()
            local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
            local decoded = ""
            
            data = data:gsub("[^" .. b .. "=]", "")
            
            for i = 1, #data, 4 do
                local n1 = b:find(data:sub(i, i)) - 1
                local n2 = b:find(data:sub(i + 1, i + 1)) - 1
                local n3 = data:sub(i + 2, i + 2) == "=" and 0 or (b:find(data:sub(i + 2, i + 2)) - 1)
                local n4 = data:sub(i + 3, i + 3) == "=" and 0 or (b:find(data:sub(i + 3, i + 3)) - 1)
                
                local n = n1 * 262144 + n2 * 4096 + n3 * 64 + n4
                local c1 = math.floor(n / 65536)
                local c2 = math.floor((n % 65536) / 256)
                local c3 = n % 256
                
                decoded = decoded .. string.char(c1)
                if data:sub(i + 2, i + 2) ~= "=" then
                    decoded = decoded .. string.char(c2)
                end
                if data:sub(i + 3, i + 3) ~= "=" then
                    decoded = decoded .. string.char(c3)
                end
            end
            
            local config_data = http_service:JSONDecode(decoded)
            local path = library.config.folder .. "/" .. name .. ".json"
            writefile(path, config_data.data)
        end)
        
        if success then
            notifications:create_notification({
                name = "Config Imported",
                info = "Successfully imported: " .. name,
                lifetime = 3
            })
            return true
        else
            notifications:create_notification({
                name = "Import Error",
                info = "Failed to import config",
                lifetime = 3
            })
            return false
        end
    end

    function library:set_autoload(name)
        local success = pcall(function()
            if name and name ~= "" then
                writefile(library.config.autoload_file, name)
            else
                if isfile(library.config.autoload_file) then
                    delfile(library.config.autoload_file)
                end
            end
        end)
        
        return success
    end

    function library:get_autoload()
        local success, name = pcall(function()
            if isfile(library.config.autoload_file) then
                return readfile(library.config.autoload_file)
            end
            return nil
        end)
        
        if success and name and name ~= "" then
            return name
        end
        return nil
    end

    function library:load_autoload()
        local success, name = pcall(function()
            if isfile(library.config.autoload_file) then
                return readfile(library.config.autoload_file)
            end
            return nil
        end)
        
        if success and name and name ~= "" then
            task.spawn(function()
                task.wait(0.5)
                library:load_config(name)
            end)
        end
    end

return library