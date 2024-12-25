local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")

AddEventHandler('onResourceStart',function(r)
    if GetCurrentResourceName()~=r then return end
    print('[^5Wave HUD^7] Online')
end)

RegisterNetEvent("wave-hud:getMoney")
AddEventHandler("wave-hud:getMoney",function()
    local s = source
    local u = vRP.getUserId({s})
    if not u then return end
    TriggerClientEvent("wave-hud:update",s,vRP.getMoney({u}),vRP.getBankMoney({u}),u,vRP.getPlayerName({s}))
end)