local cache = cache

local function getPed()
    if cache and cache.ped then return cache.ped end
    return PlayerPedId()
end

local ESX = exports["es_extended"]:getSharedObject()

local policeAdded = false

local function isPolice()
    return ESX and ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name == 'police'
end

local policeGlobalId = 'ox_police_global'
local policeMenuId = 'ox_police_menu'

local function notify(text)
    local title = (Locales and Locales['police_title']) or 'Polizei'
    lib.notify({title = title, description = text})
end

local function getClosestPlayer(maxDist)
    local players = GetActivePlayers()
    local ped = getPed()
    local closestPlayer = nil
    local closestDist = maxDist or 3.0
    local px, py, pz = table.unpack(GetEntityCoords(ped))
    for _, player in ipairs(players) do
        local pPed = GetPlayerPed(player)
        if pPed and pPed ~= ped then
            local x, y, z = table.unpack(GetEntityCoords(pPed))
            local dist = Vdist(px, py, pz, x, y, z)
            if dist <= closestDist then
                closestDist = dist
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

local function getTargetServerId()
    local player = getClosestPlayer(3.0)
    if not player then return nil end
    return GetPlayerServerId(player)
end

exports.ox_lib:registerRadial({
    id = policeMenuId,
    items = {
        {
            label = (Locales and Locales['police_check_identity']) or 'Identität überprüfen',
            icon = 'id-card',
            onSelect = function()
                local sid = getTargetServerId()
                if not sid then notify((Locales and Locales['police_no_player_near']) or 'Es befindet sich niemand in der Nähe, um die Identität zu überprüfen.') return end
                RadialTriggers.checkIdentity()
            end
        },
        {
            label = (Locales and Locales['police_check_vehicle_owner']) or 'Fahrzeugbesitz überprüfen',
            icon = 'car-side',
            onSelect = function()
                local sid = getTargetServerId()
                if not sid then notify((Locales and Locales['police_no_vehicle_near']) or 'Kein Fahrzeug in der Nähe, um den Besitz zu überprüfen.') return end
                RadialTriggers.checkVehicleOwner()
            end
        },
        {
            label = (Locales and Locales['police_manage_licenses']) or 'Lizenzen Verwalten',
            icon = 'id-badge',
            onSelect = function()
                local sid = getTargetServerId()
                if not sid then notify((Locales and Locales['police_no_player_for_licenses']) or 'Es befindet sich niemand in der Nähe, um Lizenzen zu verwalten.') return end
                RadialTriggers.checkLicenses()
            end
        },
        {
            label = (Locales and Locales['police_lockpick_car']) or 'Fahrzeug Aufbrechen',
            icon = 'unlock',
            onSelect = function()
                local sid = getTargetServerId()
                if not sid then notify((Locales and Locales['police_no_vehicle_near']) or 'Kein Fahrzeug in der Nähe, das aufgebrochen werden kann.') return end
                RadialTriggers.lockpickCar()
            end
        }
    }
})

local function updatePoliceRadial()
        if isPolice() then
        if not policeAdded then
            exports.ox_lib:addRadialItem({ id = policeGlobalId, label = (Locales and Locales['police_title']) or 'Polizei', icon = 'shield', menu = policeMenuId })
            policeAdded = true
        end
    else
        if policeAdded then
            exports.ox_lib:removeRadialItem(policeGlobalId)
            policeAdded = false
        end
    end
end

RegisterNetEvent('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
    updatePoliceRadial()
end)

RegisterNetEvent('esx:setJob', function(job)
    if ESX.PlayerData then ESX.PlayerData.job = job end
    updatePoliceRadial()
end)

CreateThread(function()
    local tries = 0
    while (not ESX.PlayerData or not ESX.PlayerData.job) and tries < 50 do
        tries = tries + 1
        Wait(200)
    end
    updatePoliceRadial()
end)
