local cache = {p=0,m=0,b=0,i=0,u="",t="",d="",s=false}
local sz = {{x=-821.2,y=-127.65,z=28.18,r=2500},{x=225.45,y=-857.93,z=30.21,r=2500},{x=441.65,y=-982.81,z=30.69,r=2500}}
local dc = {24,25,37,47,58,140,141,142,263,264}
local lu = 0
local ui = 1000
local ped = nil
local inZone = false
local msg = {type="update"}

local function checkZone()
    if not ped then ped = PlayerPedId() end
    local c = GetEntityCoords(ped)
    for _,z in ipairs(sz) do
        if (c.x-z.x)^2+(c.y-z.y)^2+(c.z-z.z)^2 <= z.r then return true end
    end
    return false
end

local function updateUI()
    msg.id,msg.username = cache.i,cache.u
    msg.players,msg.time = cache.p,cache.t
    msg.date,msg.money = cache.d,cache.m
    msg.bank,msg.inSafezone = cache.b,cache.s
    SendNUIMessage(msg)
end

RegisterNetEvent("wave-hud:update")
AddEventHandler("wave-hud:update",function(m,b,i,u)
    cache.m,cache.b,cache.i,cache.u = m or 0,b or 0,i or 0,u or ""
    updateUI()
end)

CreateThread(function()
    while true do
        local sleep = 1500
        if inZone then
            sleep = 100
            if not ped then ped = PlayerPedId() end
            for _,c in ipairs(dc) do DisableControlAction(0,c,true) end
            SetEntityInvincible(ped,true)
            SetPlayerInvincible(PlayerId(),true)
            DisablePlayerFiring(ped,true)
            SetPedCanPlayGestureAnims(ped,false)
            
            if IsDisabledControlJustPressed(0,24) or IsDisabledControlJustPressed(0,25) then
                TriggerEvent("glc:notify","error","Nu poti folosi arme sau pumni in safezone!",7500)
            end
        else
            if not ped then ped = PlayerPedId() end
            SetEntityInvincible(ped,false)
            SetPlayerInvincible(PlayerId(),false)
            SetPedCanPlayGestureAnims(ped,true)
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local now = GetGameTimer()
        if now - lu >= ui then
            lu = now
            
            local y,m,d,h,min = GetLocalTime()
            cache.t = ("%02d:%02d"):format(h,min)
            cache.d = ("%02d/%02d/%04d"):format(d,m,y)
            
            local c = 0
            for i = 0,255 do
                if NetworkIsPlayerActive(i) then c = c + 1 end
            end
            cache.p = c
            
            inZone = checkZone()
            cache.s = inZone
            updateUI()
            TriggerServerEvent("wave-hud:getMoney")
        end
        Wait(ui)
    end
end)