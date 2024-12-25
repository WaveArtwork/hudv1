local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local cache = {}

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('[^5Wave HUD^7] Scriptul a pornit cu succes!')
    print('[^5Wave HUD^7] Creat de ^5Wave Artwork Studio^7')
    print('[^5Wave HUD^7] Discord: ^3https://discord.gg/5FySwxQBKC^7')
    print('^7 ================================================')
end)

RegisterNetEvent("wave-hud:getMoney")
AddEventHandler("wave-hud:getMoney", function()
    local source = source
    local user_id = vRP.getUserId({source})
    
    if not user_id then return end
    
    local money = vRP.getMoney({user_id}) or 0
    local bank = vRP.getBankMoney({user_id}) or 0
    local username = vRP.getPlayerName({source}) or ""
    
    TriggerClientEvent("wave-hud:update", source, money, bank, user_id, username)
end)

AddEventHandler("playerDropped", function()
    cache[source] = nil
end)