QBCore = exports['qb-core']:GetCoreObject()
local lastHealth = 100
local isPlayerLoaded = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    isPlayerLoaded = true
    SendNUIMessage({
        action = "toggleHUD",
        data = { visible = true }
    })
end)

local function updateHUD()
    local ped = PlayerPedId()
    local rawHealth = GetEntityHealth(ped)
    local health = math.max(0, rawHealth - 100) 
    local armor = GetPedArmour(ped)
    local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
    local oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10
    local inWater = IsPedSwimmingUnderWater(ped)

    local playerData = QBCore.Functions.GetPlayerData()
    local hunger = playerData.metadata["hunger"]
    local thirst = playerData.metadata["thirst"]
    local playerId = GetPlayerServerId(PlayerId())
    local playerJob = playerData.job and playerData.job.label or "Unemployed"
    local cash = playerData.money['cash']
    local bank = playerData.money['bank']

    local hudData = {
        health = health,
        armor = armor,
        stamina = stamina,
        oxygen = oxygen,
        inWater = inWater,
        hunger = hunger,
        thirst = thirst
    }

    lastHealth = health

    SendNUIMessage({ action = "update", data = hudData })

    SendNUIMessage({
        action = "playerInfo",
        data = {
            id = playerId,
            job = playerJob,
            cash = cash,
            bank = bank
        }
    })
end

CreateThread(function()
    while not isPlayerLoaded do
        Wait(500)
    end

    Wait(500)

    SendNUIMessage({
        action = "setConfig",
        data = {
            showLogoImage = Config.ShowLogoImage,
            showCash = Config.ShowCash,
            showBank = Config.ShowBank
        }
    })

    SendNUIMessage({
        action = "setColors",
        data = {
            health = Config.HealthColor,   
            armor = Config.ArmorColor,     
            hunger = Config.HungerColor,    
            thirst = Config.ThirstColor,    
            oxygen = Config.OxygenColor,    
            speed = Config.SpeedColor     
        }
    })

    while true do
        Wait(300)
        updateHUD()
    end
end)


local function updateCarHUD()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local inVehicle = veh and veh ~= 0

    if inVehicle then
        local speed = GetEntitySpeed(veh) * Config.Speed 
        local fuel = Config.GetFuel(veh)

        SendNUIMessage({
            action = "updateCarHUD",
            data = {
                speed = speed,
                fuel = math.max(0, fuel),  
                inVehicle = true
            }
        })
    else
        SendNUIMessage({
            action = "updateCarHUD",
            data = { inVehicle = false }
        })
    end
end

CreateThread(function()
    while true do
        Wait(300)

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        local inVehicle = veh and veh ~= 0

        if Config.VehicleMapOnly then
            DisplayRadar(inVehicle)
        else
            DisplayRadar(true)
        end

        updateCarHUD()
    end
end)

CreateThread(function()
    while not isPlayerLoaded do
        Wait(500)
    end

    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
        local streetName = GetStreetNameFromHashKey(streetHash)
        SetBlipAlpha(GetNorthRadarBlip(), 0)

        SendNUIMessage({
            action = "updateStreet",
            data = {
                street = streetName
            }
        })

        Wait(1000)
    end
end)

