local cache = cache

local function getPed()
    if cache and cache.ped then return cache.ped end
    return PlayerPedId()
end

local personGlobalId = 'ox_person_global'
local personMenuId = 'ox_person_menu'

local function notify(text)
    local title = (Locales and Locales['person_title']) or 'Person'
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

local function getClosestPlayerInFront(maxDist, minDot)
    local players = GetActivePlayers()
    local ped = getPed()
    local closestPlayer = nil
    local closestDist = maxDist or 3.0
    minDot = minDot or 0.7
    local px, py, pz = table.unpack(GetEntityCoords(ped))
    local fx, fy, fz = table.unpack(GetEntityForwardVector(ped))
    for _, player in ipairs(players) do
        local pPed = GetPlayerPed(player)
        if pPed and pPed ~= ped then
            local x, y, z = table.unpack(GetEntityCoords(pPed))
            local vx, vy, vz = x - px, y - py, z - pz
            local dist = Vdist(px, py, pz, x, y, z)
            if dist <= closestDist then
                local len = math.sqrt(vx * vx + vy * vy + vz * vz)
                if len > 0 then
                    local ndx, ndy, ndz = vx / len, vy / len, vz / len
                    local dot = fx * ndx + fy * ndy + fz * ndz
                    if dot >= minDot then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
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

local function openTargetInventory(sid)
    if exports and exports.ox_inventory then
        local inv = exports.ox_inventory
        if type(inv.openNearbyInventory) == 'function' then
            inv:openNearbyInventory(sid)
            return
        end
        if type(inv.openPlayerInventory) == 'function' then
            inv:openPlayerInventory(sid)
            return
        end
        if type(inv.OpenInventory) == 'function' then
            inv:OpenInventory(sid)
            return
        end
    end
    notify((Locales and Locales['inventory_export_unavailable']) or 'Inventar-Export nicht verfügbar; versuche Admin-Befehl')
    ExecuteCommand('openinv ' .. sid)
end

exports.ox_lib:registerRadial({
    id = personMenuId,
    items = {
        {
            label = (Locales and Locales['person_carry']) or 'Tragen',
            icon = 'hand-holding',
            onSelect = function()
                local sid = getTargetServerId()
                if not sid then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                ExecuteCommand('carry')
            end
        },
        {
            label = (Locales and Locales['person_docs']) or 'Dokumente Ansehen',
            icon = 'hand-holding',
            onSelect = function()
                local sid = getTargetServerId()
                ExecuteCommand('dokumente')
            end
        },
        {
            label = (Locales and Locales['person_hostage']) or 'Als Geisel nehmen',
            icon = 'hand-holding',
            onSelect = function()
                local sid = getTargetServerId()
                if not sid then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                ExecuteCommand('th')
            end
        },
        {
            label = (Locales and Locales['person_handcuff']) or 'Festnehmen/Freilassen',
            icon = 'handcuffs',
            onSelect = function()
                local sid = getTargetServerId()
                if not sid then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                RadialTriggers.Handcuff()
            end
        },
        {
            label = (Locales and Locales['person_remove_mask']) or 'Maske Abziehen',
            icon = 'unlock',
            onSelect = function()
                local player = getClosestPlayerInFront(3.0, 0.75)
                if not player then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                local sid = GetPlayerServerId(player)
                if not sid then notify((Locales and Locales['invalid_target']) or 'Ziel ungültig') return end
                TriggerServerEvent('ox_radial:requestRemoveMask', sid)
            end
        },
        {
            label = (Locales and Locales['person_put_in_car']) or 'Ins Fahrzeug stecken',
            icon = 'car-side',
            onSelect = function()
                local sid = getTargetServerId()
                if not sid then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                RadialTriggers.putInCar()
            end
        },
        {
            label = (Locales and Locales['person_take_from_car']) or 'Aus Fahrzeug holen',
            icon = 'car',
            onSelect = function()
                local sid = getTargetServerId()
                if not sid then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                RadialTriggers.takeFromCar()

            end
        },
        {
            label = (Locales and Locales['person_search']) or 'Durchsuchen',
            icon = 'search',
            onSelect = function()
                local sid = getTargetServerId()
                if not sid then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                openTargetInventory(sid)
            end
        },
        {
            label = (Locales and Locales['person_take']) or 'Nehmen',
            icon = 'hand-holding',
            onSelect = function()
                local sid = getTargetServerId()
                if not sid then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                RadialTriggers.drag()
            end
        }
    }
})

exports.ox_lib:addRadialItem({ id = personGlobalId, label = (Locales and Locales['person_title']) or 'Person', icon = 'user', menu = personMenuId })

RegisterNetEvent('ox_radial:doRemoveMask', function(requesterSid)
    local ped = getPed()
    local requesterId = tonumber(requesterSid)
    local requesterPlayer = GetPlayerFromServerId(requesterId)
    if not requesterPlayer then notify((Locales and Locales['invalid_target']) or 'Anfrage ungültig') return end
    local requesterPed = GetPlayerPed(requesterPlayer)
    if Vdist(table.unpack(GetEntityCoords(ped)), table.unpack(GetEntityCoords(requesterPed))) > 3.5 then
        notify((Locales and Locales['request_too_far']) or 'Person zu weit weg')
        return
    end
    ClearPedProp(ped, 1)
    SetPedComponentVariation(ped, 1, 0, 0, 2)
    notify((Locales and Locales['person_remove_mask']) or 'Maske entfernt')
    TriggerServerEvent('ox_radial:maskRemoved', requesterSid)
end)

RegisterNetEvent('ox_radial:notifyRequester', function(text)
    notify(text)
end)
