local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('sz-blackmarket:server:CheckMoney', function()
    return true
end)

RegisterNetEvent('sz-blackmarket:server:PurchaseItem', function(item, amount, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local price = price * amount
    Player.Functions.RemoveMoney('cash', price)
end)

RegisterNetEvent('sz-blackmarket:server:AddItem', function(item,amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add") 
end)