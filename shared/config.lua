Config = {}

Config.Debug = false

Config.OpenHour = 1
Config.CloseHour = 5 

Config.UseMenu = true -- Set to true if you want to use qb-menu instead of inventory

Config.DisplayBlip = false -- Set to true if you want the location to be shown on the map
Config.BlipName = 'Unknown'

Config.BlackListedJobs = { -- Add jobs you dont want using the black market
    'police',
    'ambulance'
}

Config.DoorLocations = {
    ['1'] = {name = 'Strawberry', location = vector3(347.83, -1255.43, 32.7)},
    -- ['2'] = {name = 'Rancho', location = vector3(420.41, -2064.29, 22.14)} -- Add more locations if you want to
}

Config.Items = { 
    label = 'Black Market',
    slots = 20,
    items = {
        [1] = {name = 'advancedlockpick', price = 100, amount = 50, info = {}, type = 'item', slot = 1, header = 'Advanced Lockpick', description = '?', icon = 'fas fa-screwdriver-wrench'}, -- icons can be found on fontawesome.com/icons (free section)
        [2] = {name = 'weapon_appistol', price = 20000, amount = 50, info = {}, type = 'item', slot = 2, header = 'AP Pistol', description = 'This could come in handy...', icon = 'fas fa-gun'},
        [3] = {name = 'radio', price = 20, amount = 50, info = {}, type = 'item', slot = 3, header = 'Radio', description = 'Just a normal radio', icon = 'fas fa-walkie-talkie'}
    }
}
