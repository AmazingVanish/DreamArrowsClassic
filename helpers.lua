for dataProvider, _ in pairs(WorldMapFrame.dataProviders) do
    if dataProvider.SetUnitPinSize and dataProvider.pin and dataProvider.pin:GetObjectType() == "UnitPositionFrame" then
        UserPositionFrame = dataProvider.pin
    end
end

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

function updateMinimapArrowTexture()
    Minimap:SetPlayerTexture("Interface\\AddOns\\DreamArrowsClassic\\arrows\\" .. Color .. "\\arrow" .. Size)
end

function updateWorldMapArrowTexture()
    UserPositionFrame:SetPinTexture("player", "Interface\\AddOns\\DreamArrowsClassic\\arrows\\" .. Color .. "\\arrow" .. WSize)
end

function waitUpdateMinimapArrowTexture(_d)
    delay(_d)
    updateMinimapArrowTexture()
end
