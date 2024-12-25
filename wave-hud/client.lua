local cache = {
    players = 0,
    money = 0,
    bank = 0,
    id = 0,
    username = "",
    time = "",
    date = "",
    inSafezone = false
}

-- Update time function
local function updateTime()
    local year, month, day, hour, minute = GetLocalTime()
    cache.time = string.format("%02d:%02d", hour, minute)
    cache.date = string.format("%02d/%02d/%04d", day, month, year)
end

-- Update players count
local function updatePlayers()
    local count = 0
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            count = count + 1
        end
    end
    cache.players = count
end

-- Safezone coordinates
local safeZones = {
    {x = -821.2, y = -127.65, z = 28.18, radius = 50.0}, -- Legion Square
    {x = 225.45, y = -857.93, z = 30.21, radius = 50.0}, -- Hospital
    {x = 441.65, y = -982.81, z = 30.69, radius = 50.0}  -- Police Department
}

-- Check if player is in safezone
local function isInSafezone()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    for _, zone in ipairs(safeZones) do
        local distance = #(vector3(coords.x, coords.y, coords.z) - vector3(zone.x, zone.y, zone.z))
        if distance < zone.radius then
            return true
        end
    end
    
    return false
end

-- Combat restrictions thread
Citizen.CreateThread(function()
    while true do
        if cache.inSafezone then
            local ped = PlayerPedId()
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 263, true) 
            DisableControlAction(0, 264, true) 

            SetEntityInvincible(ped, true)
            SetPlayerInvincible(PlayerId(), true)

            DisablePlayerFiring(ped, true)
            DisableControlAction(0, 24, true) 
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            
            SetPedCanPlayGestureAnims(ped, false)
            
            if IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 25) or IsDisabledControlJustPressed(0, 140) or IsDisabledControlJustPressed(0, 141) then
                TriggerEvent("glc:notify", "error", "Nu poti folosi arme sau pumni in safezone!", 7500) -- Aici iti pui notify urile tale
            end
        else
-- Iti scoate god mode ul cand iesi din safezone, poti lasa sau poti sterge alegerea ta.
            local ped = PlayerPedId()
            SetEntityInvincible(ped, false)
            SetPlayerInvincible(PlayerId(), false)
            SetPedCanPlayGestureAnims(ped, true)
        end
        
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("wave-hud:update")
AddEventHandler("wave-hud:update", function(money, bank, user_id, username)
    cache.money = money or 0
    cache.bank = bank or 0
    cache.id = user_id or 0
    cache.username = username or ""

    SendNUIMessage({
        type = "update",
        id = cache.id,
        username = cache.username,
        players = cache.players,
        time = cache.time,
        date = cache.date,
        money = cache.money,
        bank = cache.bank,
        inSafezone = cache.inSafezone
    })
end)

Citizen.CreateThread(function()
    while true do
        updateTime()
        updatePlayers()
        
        cache.inSafezone = isInSafezone()
        
        SendNUIMessage({
            type = "update",
            id = cache.id,
            username = cache.username,
            players = cache.players,
            time = cache.time,
            date = cache.date,
            money = cache.money,
            bank = cache.bank,
            inSafezone = cache.inSafezone
        })
        
        TriggerServerEvent("wave-hud:getMoney")
        Citizen.Wait(250)
    end
end)