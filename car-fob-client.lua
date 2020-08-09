

local function GetClientAllVehicles()

	local ret = {}
	for veh in EnumerateVehicles() do
		table.insert(ret, veh)
    end
    
    return ret
    
end

local function IsOwnedVehicle(vehicle) 

    local plate = GetVehicleNumberPlateText(vehicle)
    return exports["np-keys"]:hasKey(plate)

end

local function IsNearby(vehicle_coords, player_coords)

    return #(vehicle_coords - player_coords) < Config.NearbyCarDistance

end

local function GetOwnedVehicles()

    local owned_vehicles = {}
    local all_vehicles   = GetClientAllVehicles()
    local player_coords  = GetEntityCoords(PlayerPedId())
    for i = 1, #all_vehicles do

        local vehicle_coords = GetEntityCoords(all_vehicles[i])
        if IsNearby(vehicle_coords, player_coords) and IsOwnedVehicle(all_vehicles[i]) then
            owned_vehicles[#owned_vehicles + 1] = {id = all_vehicles[i], plate = plate, model = GetDisplayNameFromVehicleModel(GetEntityModel(all_vehicles[i]))}
        end

    end

    return owned_vehicles

end

local function ToggleVehicleEngine(vehicle)

    if GetIsVehicleEngineRunning(vehicle) then
        exports['mythic_notify']:SendAlert('inform', 'Engine turned off', 2500)
        SetVehicleEngineOn(vehicle, false, true, false)
    else
        exports['mythic_notify']:SendAlert('inform', 'Engine turned on', 2500)
        SetVehicleEngineOn(vehicle, true, true, false)
    end

end

local function ToggleVehicleAlarm(vehicle)

    if IsVehicleAlarmActivated(vehicle) then
        exports['mythic_notify']:SendAlert('inform', 'Car Alarm Off', 2500)
        SetVehicleAlarm(vehicle, false)
    else
        SetVehicleAlarm(vehicle, true)
        exports['mythic_notify']:SendAlert('inform', 'Car Alarm On', 2500)
        SetVehicleAlarmTimeLeft(vehicle, Config.AlarmTimeInSecs * 1000)
    end

end

local function ToggleVehicleLock(vehicle)

    if GetVehicleDoorsLockedForPlayer(vehicle, PlayerPedId()) then
        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
    else
        SetVehicleDoorsLockedForAllPlayers(vehicle, true)
    end

end

RegisterCommand("ShowCarFob", function(source, args, raw_command) 

    local owned_vehicles = GetOwnedVehicles()
    if #owned_vehicles == 0 then
        return
    end

    SendNUIMessage({
        type           = "ToggleCarFob",
        owned_vehicles = owned_vehicles
    })
    SetNuiFocus(true, true)

end)

RegisterNUICallback("EscapeCarFob", function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNUICallback("LockDoors", function(data, cb)
    SoundVehicleHornThisFrame(data.vehicle_id)
    exports['mythic_notify']:SendAlert('inform', 'Locked Doors', 2500)
    SetVehicleDoorsLockedForAllPlayers(data.vehicle_id, true)
end)

RegisterNUICallback("UnlockDoors", function(data, cb)
    SoundVehicleHornThisFrame(data.vehicle_id)
    exports['mythic_notify']:SendAlert('inform', 'Unlocked Doors', 2500)
    SetVehicleDoorsLockedForAllPlayers(data.vehicle_id, false)
end)

RegisterNUICallback("ToggleEngine", function(data, cb)
    SoundVehicleHornThisFrame(data.vehicle_id)
    ToggleVehicleEngine(data.vehicle_id)
end)

RegisterNUICallback("ToggleAlarm", function(data, cb)
    ToggleVehicleAlarm(data.vehicle_id)
end)