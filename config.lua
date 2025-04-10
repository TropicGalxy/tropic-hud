Config = {}

Config.HealthColor = "#ef4444"
Config.ArmorColor = "#3b82f6"
Config.HungerColor = "#f59e0b"
Config.ThirstColor = "#38bdf8"
Config.OxygenColor = "#67e8f9"
Config.SpeedColor = "#ff4d4d"

Config.FuelSystem = "ox"

Config.GetFuel = function(veh)
    if Config.FuelSystem == "cdn-fuel" then
        return exports["cdn-fuel"]:GetFuel(veh)
    elseif Config.FuelSystem == "legacy-fuel" then
        return exports["LegacyFuel"]:GetFuel(veh)
    elseif Config.FuelSystem == "ox" then
        return Entity(veh).state.fuel
    else
        print("Invalid fuel script")
    end
end

Config.Speed = 2.23694 -- 2.23694 for mph, 3.6 for kmh

Config.ShowLogoImage = true

Config.VehicleMapOnly = true -- if you want the minimap to only show when in a car

Config.ShowCash = true  

Config.ShowBank = true
