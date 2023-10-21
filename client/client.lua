local QBCore = exports['qb-core']:GetCoreObject()

local function CheckMoney(itemPrice)
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.money['cash'] >= itemPrice then
        return false
    else 
        return true
    end
end

local function PromptAmount()
    local amount
    local dialog = exports['qb-input']:ShowInput({
        header = 'Choose Amount',
        submitText = 'Confirm',
        inputs = {
            {
                text = 'Amount',
                name = 'amount',
                type = 'number',
                isRequired = true
            }
        },
    })

    if dialog ~= nil then
        for k, v in pairs(dialog) do
            print(k .. " : " .. v)
            amount = tonumber(v)
        end
    end
    return amount
end

Citizen.CreateThread(function()
    if Config.DisplayBlip then
        for _, v in pairs(Config.DoorLocations) do
            local blip = AddBlipForCoord(v.location)
            SetBlipSprite(blip, 66)
            SetBlipDisplay(blip, 6)
            SetBlipScale(blip, 0.7)
            -- SetBlipColour(blip, 1)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(Config.BlipName)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Target Doors
for k, v in pairs(Config.DoorLocations) do
    exports['qb-target']:AddCircleZone(v.name, v.location, 0.4, {
        name = v.Name,
        debugPoly = Config.Debug,
    }, {
        options = {
            {
                num = 1,
                type = 'client',
                event = 'sz-blackmarket:client:DoorKnock',
                icon = 'fas fa-question',
                label = 'Unknown',
                drawDistance = 1,
                drawColor = {255, 255, 255, 255},
                successDrawColor = {30, 144, 255, 255}
            }
        },
        distance = 1
    })
end

RegisterNetEvent('sz-blackmarket:client:PurchaseItem', function(args)
    local amount = PromptAmount()
    if amount > 0 then
        TriggerServerEvent('sz-blackmarket:server:AddItem', args.item, amount)
        TriggerServerEvent('sz-blackmarket:server:PurchaseItem', args.item, amount, args.price)
    else
        QBCore.Functions.Notify('You did not select an amount', 'error', 5000)
    end
end)


RegisterNetEvent('sz-blackmarket:client:DoorKnock', function()
    QBCore.Functions.Progressbar('Knocking', 'Knocking...', 3000, false, true, {
        TriggerEvent('animations:client:EmoteCommandStart', {"knock"}),
        disableMovement = true,
        disableMouse = false, 
        disableCombat = true
    }, {}, {}, {}, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent('sz-blackmarket:client:OpenShop')
    end, function ()
    end)
end)

RegisterNetEvent('sz-blackmarket:client:OpenShop', function()
    local clockTime = GetClockHours()
    if Config.Debug then
        print('Current time: ', clockTime)
    end
    if clockTime >= Config.OpenHour and clockTime <= Config.CloseHour - 1 then
            QBCore.Functions.GetPlayerData(function(PlayerData)
                for j, job in pairs(Config.BlackListedJobs) do
                    if PlayerData.job.name == job then 
                        QBCore.Functions.Notify('\"There is nothing here for you!\"', 'error', 3000)
                        return
                    end
                end
                QBCore.Functions.Notify('\"Give me a moment\"', 'primary', 3000)
                Wait(6000)
                QBCore.Functions.Notify('\"Here\'s what I have to offer\"', 'primary', 2000)
                Wait(2000)

                if Config.UseMenu then
                    local itemsList = {}
                itemsList[#itemsList + 1] = {
                    isMenuHeader = true,
                    header = 'Unknown',
                    icon = 'fa-solid fa-question'
                }
                for k,v in pairs(Config.Items.items) do 
                    itemsList[#itemsList + 1] = { 
                        header = v.header,
                        txt = 'Price: $' .. v.price .. ' | Use: ' .. v.description,
                        icon = v.icon,
                        disabled = CheckMoney(v.price),
                        params = {
                            event = 'sz-blackmarket:client:PurchaseItem', 
                            args = {
                                item = v.name,
                                price = v.price,
                            }
                        }
                    }
                end
                exports['qb-menu']:openMenu(itemsList) 
            else
                TriggerServerEvent("inventory:server:OpenInventory", "shop", "Black Market", Config.Items)
            end
            end)
    elseif clockTime >= Config.CloseHour and clockTime <= Config.OpenHour then
        QBCore.Functions.GetPlayerData(function(PlayerData)
            for k, job in pairs(Config.BlackListedJobs) do
                if PlayerData.job.name == job then 
                    QBCore.Functions.Notify('\"There is nothing here for you!\"', 'error', 3000)
                    return
                end
            end
            QBCore.Functions.Notify('\"I don\'t do business during the day\"')
        end)
    else
        QBCore.Functions.GetPlayerData(function(PlayerData)
            for _, job in pairs(Config.BlackListedJobs) do
                if PlayerData.job.name == job then 
                    QBCore.Functions.Notify('\"There is nothing here for you!\"', 'error', 3000)
                    return
                end
            end
            QBCore.Functions.Notify('\"I don\'t do business during the day\"')
        end)
    end
end)
