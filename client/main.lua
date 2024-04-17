local isQBCore = true -- Set this to false if you are using ESX instead of QBCore
local CoreObject, playerData

if isQBCore then
    CoreObject = exports['qb-core']:GetCoreObject() -- Get the QBCore object
    playerData = CoreObject.Functions.GetPlayerData() -- Fetch player data
else
    ESX = exports["es_extended"]:getSharedObject() -- Get the ESX object using the new method
    playerData = ESX.GetPlayerData() -- Fetch player data
end

local musicStopped = false -- Flag to control the music stopping logic

-- Event handler for player spawn
AddEventHandler('playerSpawned', function()
    if not musicStopped then
        StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE") -- Start an audio scene when the player spawns
        musicStopped = true -- Set the flag to true to prevent repeating this audio scene
    end
end)

-- Thread to handle in-vehicle radio control
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Wait 1 second between checks
        local ped = PlayerPedId() -- Get the player's PED ID
        
        if not IsPedInAnyVehicle(ped, false) then -- Check if the player is not in any vehicle
            StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE") -- Start audio scene if out of vehicle
        else
            SetUserRadioControlEnabled(false) -- Disable the player's radio control when in a vehicle
            if GetPlayerRadioStationName() ~= nil then -- Check if there is a radio station active
                SetVehRadioStation(GetVehiclePedIsIn(ped), "OFF") -- Turn off the radio
            end
        end
    end
end)
