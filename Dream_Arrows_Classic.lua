----------------------------------------------------------------------
--  Dream Arrows Classic 1.5.0 (April 18, 2020)                     --
----------------------------------------------------------------------
--                                                                  --
--  01:SetUp            02:Functions            03:Commands         --   
--                                                                  --
----------------------------------------------------------------------
--  DA01: SetUp                                                     --
----------------------------------------------------------------------
local UserPositionFrame; -- frame which stores user position arrow on the world map
    for dataProvider, _ in pairs(WorldMapFrame.dataProviders) do
        if dataProvider.SetUnitPinSize and dataProvider.pin and dataProvider.pin:GetObjectType() == "UnitPositionFrame" then
            UserPositionFrame = dataProvider.pin
        end
    end

local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
    frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
    frame:RegisterEvent("PLAYER_LOGOUT"); -- Fired when saved variables are loaded
    frame:RegisterEvent("PLAYER_LOGIN");

frame:SetScript("OnEvent", frame.OnEvent);

----------------------------------------------------------------------
--  DA02: Functions                                                 --
----------------------------------------------------------------------
function split(pString, pPattern)
    local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table,cap)
        end
        last_end = e+1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end

function delay(tick)
    local th = coroutine.running()
    C_Timer.After(tick, function() coroutine.resume(th) end)
    coroutine.yield()
end

function frame:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "DreamArrowsClassic" then
        -- Our saved variables are ready at this point. If there are none, all variables will set to nil.
        if Size == nil or WSize == nil or Color == nil or Toggle == nil or Style == nil then -- first time loading addon
            print("First time running this version of Dream Arrows Classic. Setting things up...")

            if Color  == nil then Color = 'silver' end
            if Size   == nil then Size = 20 end
            if Style  == nil then Style = 'orb' end
            if Toggle == nil then Toggle = 1 end
            if WSize  == nil then WSize = 30 end

            print("Dream Arrows Classic loaded")

            updateWorldMapArrowTexture()
            updateMinimapArrowTexture()

            coroutine.wrap(waitUpdateMinimapArrowTexture)(1)
            coroutine.wrap(waitUpdateMinimapArrowTexture)(5)
            coroutine.wrap(waitUpdateMinimapArrowTexture)(10)
       end
    elseif event == "PLAYER_LOGIN" then
        updateWorldMapArrowTexture()
        updateMinimapArrowTexture()
        coroutine.wrap(waitUpdateMinimapArrowTexture)(1)
        coroutine.wrap(waitUpdateMinimapArrowTexture)(5)
        coroutine.wrap(waitUpdateMinimapArrowTexture)(10)
    end
end

function updateMinimapArrowTexture()
    Minimap:SetPlayerTexture("Interface\\AddOns\\DreamArrowsClassic\\arrows\\" .. Style .. "\\" .. Color .. "\\arrow" .. Size)
end

function updateWorldMapArrowTexture()
    UserPositionFrame:SetPinTexture("player", "Interface\\AddOns\\DreamArrowsClassic\\arrows\\" .. Style .. "\\" .. Color .. "\\arrow" .. WSize)
end

function waitUpdateMinimapArrowTexture(_d)
    delay(_d)
    updateMinimapArrowTexture()
end

local function ColorUsage()
    print(' /da color [amethyst, aquamarine, citrine, gold, jade, obsidian, ruby, silver] - modify the color of the arrows')
end

local function FlushUsage()
    print(' /da flush - re-set the arrow textures')
end

local function ResetUsage()
    print(' /da reset - reset to addon defaults')
end

local function SizeUsage()
    print(' /da size [1-40] - modify the size of the minimap arrow (e.g. /da size 20)')
end

local function StyleUsage()
    print(' /da style [arrow, hollow, orb, tear] - modify the style of the arrows')
end

local function WSizeUsage()
    print(' /da wsize [1-40] - modify the size of the world map arrow (e.g. /da wsize 30)')
end

local function ToggleUsage()
    print(' /da toggle [0-1] - toggle showing the world map arrow (e.g. to hide the arrow use /da toggle 0)')
end

local function Usage()
    print('Dream Arrows Classic usage:')
    print(' /da help - show this help message')
    ColorUsage()
    SizeUsage()
    StyleUsage()
    WSizeUsage()
    ToggleUsage()
    FlushUsage()
    ResetUsage()
end

local function DAColor(commands, command_i)
    Color = commands[command_i]

    if  Color ~= 'amethyst' and Color ~= 'aquamarine' and Color ~= 'citrine' and Color ~= 'gold' and Color ~= 'jade' and Color ~= 'obsidian' and Color ~= 'ruby' then
        Color = 'silver'
    end

    print("Set arrow color to " .. Color)
    updateMinimapArrowTexture()
    updateWorldMapArrowTexture()
end

local function DAReset(commands, command_i)
    Color = 'silver'
    Size = 20
    Style = 'orb'
    Toggle = 1
    WSize = 30    

    updateWorldMapArrowTexture()
    updateMinimapArrowTexture()

    coroutine.wrap(waitUpdateMinimapArrowTexture)(1)
    coroutine.wrap(waitUpdateMinimapArrowTexture)(5)
    coroutine.wrap(waitUpdateMinimapArrowTexture)(10)

    print("Dream Arrows Classic reset to defaults")
end

local function DASize(commands, command_i)
    Size = commands[command_i]
    if Size == nil then
        print('Missing required [size] parameter')
        SizeUsage()
        return
    end

    size_number = tonumber(Size)

    if size_number == nil then
        print('Size parameter must be a valid integer')
        SizeUsage()
        return
    end

    if size_number < 1 or size_number > 40 then
        print('size parameter must be a valid integer between 1 and 40')
        SizeUsage()
        return
    end

    print("Set minimap arrow size to " .. Size)
    updateMinimapArrowTexture()
end

local function DAStyle(commands, command_i)
    Style = commands[command_i]

    if  Style ~= 'arrow' and Style ~= 'hollow' and Style ~= 'tear' and Style ~= '3d' then
        Style = 'orb'
    end

    print("Set arrow style to " .. Style)
    updateMinimapArrowTexture()
    updateWorldMapArrowTexture()
end

local function DAWSize(commands, command_i)
    WSize = commands[command_i]
    if WSize == nil then
        print('Missing required [wsize] parameter')
        WSizeUsage()
        return
    end

    wsize_number = tonumber(WSize)

    if wsize_number == nil then
        print('Size parameter must be a valid integer')
        WSizeUsage()
        return
    end

    if wsize_number < 1 or wsize_number > 40 then
        print('size parameter must be a valid integer between 1 and 40')
        WSizeUsage()
        return
    end

    print("Set world map arrow size to " .. WSize)
    updateWorldMapArrowTexture()
end

local function DAToggle(commands, command_i)
    Toggle = tonumber(commands[command_i])
    if Toggle < 0 or Toggle > 1 then
        print('Toggle value must be 0 or 1')
        ToggleUsage()
        return
    end

    UserPositionFrame:SetAlpha(Toggle)
end

local function DAFlush(commands, command_i)
    updateMinimapArrowTexture()
    updateWorldMapArrowTexture()
end

----------------------------------------------------------------------
--  DA03: Commands                                                  --
----------------------------------------------------------------------
local function MyAddonCommands(msg, editbox)
    commands = split(msg, " ")
    command_i = 1

    if commands[command_i] == "color" then
        DAColor(commands, command_i + 1)
        return
    end
 
    if commands[command_i] == "size" then
        DASize(commands, command_i + 1)
        return
    end
 
   if commands[command_i] == "strata" then
        DAStrata(commands, command_i + 1)
        return
    end
 
    if commands[command_i] == "toggle" then
        DAToggle(commands, command_i + 1)
        return
    end

    if commands[command_i] == "style" then
        DAStyle(commands, command_i + 1)
        return
    end
 
   if commands[command_i] == "wsize" then
        DAWSize(commands, command_i + 1)
        return
    end
 
    if commands[command_i] == "flush" then
        DAFlush(commands, command_i + 1)
        return
    end
 
     if commands[command_i] == "reset" then
        DAReset(commands, command_i + 1)
        return
    end
 
   Usage()
end

SLASH_DA1 = '/da'

SlashCmdList["DA"] = MyAddonCommands   -- add /da to command list