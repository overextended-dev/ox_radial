local cache = cache

local autoGlobalId = 'ox_auto_global'
local autoMenuId = 'ox_auto_menu'
local windowsMenuId = 'ox_windows_menu'
local doorsMenuId = 'ox_doors_menu'
local extrasMenuId = 'ox_extras_menu'
local seatsMenuId = 'ox_seats_menu'

local function notify(text)
    lib.notify({title = 'Auto', description = text})
end

exports.ox_lib:registerRadial({
    id = autoMenuId,
    items = {
        {
            label = Locales['motor_start'],
            icon = 'power-off',
            onSelect = function()
                local ped = cache.ped
                local veh = GetVehiclePedIsIn(ped, false)
                if not veh or veh == 0 then
                    notify(Locales['not_in_vehicle'])
                    return
                end
                local driver = GetPedInVehicleSeat(veh, -1)
                if driver ~= ped then
                    notify(Locales['only_driver_engine'])
                    return
                end
                local running = GetIsVehicleEngineRunning(veh)
                SetVehicleEngineOn(veh, not running, false, true)
                notify(not running and Locales['motor_started'] or Locales['motor_stopped'])
            end
        },
        {
            label = Locales['seat_change'],
            icon = 'chair',
            menu = seatsMenuId
        },
        {
            label = Locales['windows'],
            icon = 'window-maximize',
            menu = windowsMenuId
        },
        {
            label = Locales['doors'],
            icon = 'car-side',
            menu = doorsMenuId
        },
        {
            label = Locales['car_extras'],
            icon = 'microchip',
            menu = extrasMenuId
        }
    }
})

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = cache.ped
        local veh = GetVehiclePedIsIn(ped, false)

        if IsPedGettingIntoAVehicle(ped) then
            if veh and veh ~= 0 then
                if not GetIsVehicleEngineRunning(veh) then
                    SetVehicleEngineOn(veh, false, true, true)
                    DisableControlAction(2, 71, true)
                end
            end
        end

        if veh and veh ~= 0 then
            if not GetIsVehicleEngineRunning(veh) then
                DisableControlAction(2, 71, true)
            end
        end
		
        if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
            if veh and veh ~= 0 then
                local engineWasRunning = GetIsVehicleEngineRunning(veh)
                if engineWasRunning then
                    Citizen.Wait(150)
                    SetVehicleEngineOn(veh, true, true, false)
                end
                TaskLeaveVehicle(ped, veh, 0)
            end
        end
    end
end)

exports.ox_lib:registerRadial({
    id = extrasMenuId,
    items = {}
})

exports.ox_lib:registerRadial({
    id = seatsMenuId,
    items = {}
})

exports.ox_lib:registerRadial({
    id = windowsMenuId,
    items = {
        {
            label = Locales['window_front_left'],
            icon = 'window-maximize',
            onSelect = function()
                local ped = cache.ped
                local veh = GetVehiclePedIsIn(ped, false)
                if not veh or veh == 0 then
                    notify(Locales['not_in_vehicle'])
                    return
                end
                local idx = 0
                local intact = IsVehicleWindowIntact(veh, idx)
                if intact then
                    RollDownWindow(veh, idx)
                    notify(Locales['window_front_left'] .. ' ' .. Locales['window_opened'])
                else
                    RollUpWindow(veh, idx)
                    notify(Locales['window_front_left'] .. ' ' .. Locales['window_closed'])
                end
            end
        },
        {
            label = Locales['window_front_right'],
            icon = 'window-maximize',
            onSelect = function()
                local ped = cache.ped
                local veh = GetVehiclePedIsIn(ped, false)
                if not veh or veh == 0 then
                    notify(Locales['not_in_vehicle'])
                    return
                end
                local idx = 1
                local intact = IsVehicleWindowIntact(veh, idx)
                if intact then
                    RollDownWindow(veh, idx)
                    notify(Locales['window_front_right'] .. ' ' .. Locales['window_opened'])
                else
                    RollUpWindow(veh, idx)
                    notify(Locales['window_front_right'] .. ' ' .. Locales['window_closed'])
                end
            end
        },
        {
            label = Locales['window_back_left'],
            icon = 'window-maximize',
            onSelect = function()
                local ped = cache.ped
                local veh = GetVehiclePedIsIn(ped, false)
                if not veh or veh == 0 then
                    notify(Locales['not_in_vehicle'])
                    return
                end
                local idx = 2
                local intact = IsVehicleWindowIntact(veh, idx)
                if intact then
                    RollDownWindow(veh, idx)
                    notify(Locales['window_back_left'] .. ' ' .. Locales['window_opened'])
                else
                    RollUpWindow(veh, idx)
                    notify(Locales['window_back_left'] .. ' ' .. Locales['window_closed'])
                end
            end
        },
        {
            label = Locales['window_back_right'],
            icon = 'window-maximize',
            onSelect = function()
                local ped = cache.ped
                local veh = GetVehiclePedIsIn(ped, false)
                if not veh or veh == 0 then
                    notify(Locales['not_in_vehicle'])
                    return
                end
                local idx = 3
                local intact = IsVehicleWindowIntact(veh, idx)
                if intact then
                    RollDownWindow(veh, idx)
                    notify(Locales['window_back_right'] .. ' ' .. Locales['window_opened'])
                else
                    RollUpWindow(veh, idx)
                    notify(Locales['window_back_right'] .. ' ' .. Locales['window_closed'])
                end
            end
        },
        {
            label = Locales['window_all'],
            icon = 'window-maximize',
            onSelect = function()
                local ped = cache.ped
                local veh = GetVehiclePedIsIn(ped, false)
                if not veh or veh == 0 then
                    notify(Locales['not_in_vehicle'])
                    return
                end
                local anyClosed = false
                for i = 0, 3 do
                    if IsVehicleWindowIntact(veh, i) then
                        anyClosed = true
                        break
                    end
                end
                if anyClosed then
                    for i = 0, 3 do
                        RollDownWindow(veh, i)
                    end
                    notify(Locales['windows_opened'])
                else
                    for i = 0, 3 do
                        RollUpWindow(veh, i)
                    end
                    notify(Locales['windows_closed'])
                end
            end
        }
    }
})

    exports.ox_lib:registerRadial({
        id = doorsMenuId,
        items = {
            {
                label = Locales['door_front_left'],
                icon = 'door-closed',
                onSelect = function()
                    local ped = cache.ped
                    local veh = GetVehiclePedIsIn(ped, false)
                    if not veh or veh == 0 then
                        notify(Locales['not_in_vehicle'])
                        return
                    end
                    local idx = 0
                    local angle = GetVehicleDoorAngleRatio(veh, idx)
                    if angle and angle > 0.01 then
                        SetVehicleDoorShut(veh, idx, false)
                        notify(Locales['door_front_left'] .. ' ' .. Locales['door_closed'])
                    else
                        SetVehicleDoorOpen(veh, idx, false, false)
                        notify(Locales['door_front_left'] .. ' ' .. Locales['door_opened'])
                    end
                end
            },
            {
                label = Locales['door_front_right'],
                icon = 'door-closed',
                onSelect = function()
                    local ped = cache.ped
                    local veh = GetVehiclePedIsIn(ped, false)
                    if not veh or veh == 0 then
                        notify(Locales['not_in_vehicle'])
                        return
                    end
                    local idx = 1
                    local angle = GetVehicleDoorAngleRatio(veh, idx)
                    if angle and angle > 0.01 then
                        SetVehicleDoorShut(veh, idx, false)
                        notify(Locales['door_front_right'] .. ' ' .. Locales['door_closed'])
                    else
                        SetVehicleDoorOpen(veh, idx, false, false)
                        notify(Locales['door_front_right'] .. ' ' .. Locales['door_opened'])
                    end
                end
            },
            {
                label = Locales['door_back_left'],
                icon = 'door-closed',
                onSelect = function()
                    local ped = cache.ped
                    local veh = GetVehiclePedIsIn(ped, false)
                    if not veh or veh == 0 then
                        notify(Locales['not_in_vehicle'])
                        return
                    end
                    local idx = 2
                    local angle = GetVehicleDoorAngleRatio(veh, idx)
                    if angle and angle > 0.01 then
                        SetVehicleDoorShut(veh, idx, false)
                        notify(Locales['door_back_left'] .. ' ' .. Locales['door_closed'])
                    else
                        SetVehicleDoorOpen(veh, idx, false, false)
                        notify(Locales['door_back_left'] .. ' ' .. Locales['door_opened'])
                    end
                end
            },
            {
                label = Locales['door_back_right'],
                icon = 'door-closed',
                onSelect = function()
                    local ped = cache.ped
                    local veh = GetVehiclePedIsIn(ped, false)
                    if not veh or veh == 0 then
                        notify(Locales['not_in_vehicle'])
                        return
                    end
                    local idx = 3
                    local angle = GetVehicleDoorAngleRatio(veh, idx)
                    if angle and angle > 0.01 then
                        SetVehicleDoorShut(veh, idx, false)
                        notify(Locales['door_back_right'] .. ' ' .. Locales['door_closed'])
                    else
                        SetVehicleDoorOpen(veh, idx, false, false)
                        notify(Locales['door_back_right'] .. ' ' .. Locales['door_opened'])
                    end
                end
            },
            {
                label = Locales['door_all'],
                icon = 'layer-group',
                onSelect = function()
                    local ped = cache.ped
                    local veh = GetVehiclePedIsIn(ped, false)
                    if not veh or veh == 0 then
                        notify(Locales['not_in_vehicle'])
                        return
                    end
                    local anyClosed = false
                    for i = 0, 3 do
                        local angle = GetVehicleDoorAngleRatio(veh, i)
                        if not angle or angle <= 0.01 then
                            anyClosed = true
                            break
                        end
                    end
                    if anyClosed then
                        for i = 0, 3 do
                            SetVehicleDoorOpen(veh, i, false, false)
                        end
                        notify(Locales['doors_opened'])
                    else
                        for i = 0, 3 do
                            SetVehicleDoorShut(veh, i, false)
                        end
                        notify(Locales['doors_closed'])
                    end
                end
            }
        }
    })

Citizen.CreateThread(function()
    local added = false
    local prevWindowMask = -1
    local prevDoorMask = -1
    local prevEngineRunning = nil
    local prevExtrasMask = -1
    local prevSeatsCount = -1
    local prevSeatsModel = nil
    while true do
        local ped = cache.ped
        local veh = GetVehiclePedIsIn(ped, false)
        if veh and veh ~= 0 then
            if not added then
                exports.ox_lib:addRadialItem({ id = autoGlobalId, label = Locales['auto'], icon = 'car', menu = autoMenuId })
                added = true
            end

            local model = GetEntityModel(veh)
            if prevSeatsModel ~= model then
                prevSeatsModel = model
                local modelName = GetDisplayNameFromVehicleModel(model)
                print(('ox_radial DEBUG - vehicle model: %s  hash: %s'):format(modelName, model))
            end
            local windowMask = 0
            for i = 0, 3 do
                if IsVehicleWindowIntact(veh, i) then
                    windowMask = windowMask + (2 ^ i)
                end
            end

            local doorMask = 0
            for i = 0, 3 do
                local angle = GetVehicleDoorAngleRatio(veh, i)
                if angle and angle > 0.01 then
                    doorMask = doorMask + (2 ^ i)
                end
            end

            local extrasMask = 0
            local availableExtras = {}
            for i = 0, 19 do
                if DoesExtraExist(veh, i) then
                    table.insert(availableExtras, i)
                    if IsVehicleExtraTurnedOn(veh, i) then
                        extrasMask = extrasMask + (2 ^ i)
                    end
                end
            end

            if not added or extrasMask ~= prevExtrasMask then
                if extrasMask ~= prevExtrasMask then
                    prevExtrasMask = extrasMask
                end
                local extrasItems = {}
                
                local engineHealth = GetVehicleEngineHealth(veh)
                local bodyHealth = GetVehicleBodyHealth(veh)
                local isVehicleDamaged = engineHealth < 200 or (bodyHealth < 150)
                
                if #availableExtras == 0 then
                    table.insert(extrasItems, {
                        label = Locales['no_extras'],
                        icon = 'ban',
                        disabled = true
                    })
                else
                    for _, extraId in ipairs(availableExtras) do
                        local isOn = IsVehicleExtraTurnedOn(veh, extraId)
                        table.insert(extrasItems, {
                            label = (isOn and Locales['extra'] .. ' ' .. extraId .. ' - ' .. Locales['extra_on'] or Locales['extra'] .. ' ' .. extraId .. ' - ' .. Locales['extra_off']),
                            icon = (isOn and 'toggle-on' or 'toggle-off'),
                            disabled = isVehicleDamaged,
                            onSelect = function()
                                local ped = cache.ped
                                local veh = GetVehiclePedIsIn(ped, false)
                                if veh and veh ~= 0 then
                                    local currentEngineHealth = GetVehicleEngineHealth(veh)
                                    local currentBodyHealth = GetVehicleBodyHealth(veh)
                                    if currentEngineHealth < 200 or currentBodyHealth < 150 then
                                        notify(Locales['vehicle_damaged'])
                                        return
                                    end
                                    local isCurrentlyOn = IsVehicleExtraTurnedOn(veh, extraId)
                                    SetVehicleExtra(veh, extraId, (isCurrentlyOn and 0 or 1))
                                    notify(Locales['extra'] .. ' ' .. extraId .. ' ' .. (isCurrentlyOn and Locales['extra_disabled'] or Locales['extra_enabled']))
                                end
                            end
                        })
                    end
                end
                
                exports.ox_lib:registerRadial({
                    id = extrasMenuId,
                    items = extrasItems
                })
            end

            if windowMask ~= prevWindowMask then
                prevWindowMask = windowMask
                exports.ox_lib:registerRadial({
                    id = windowsMenuId,
                    items = {
                        {
                            label = (IsVehicleWindowIntact(veh, 0) and Locales['window_front_left'] .. ' ' .. Locales['window_open'] or Locales['window_front_left'] .. ' ' .. Locales['window_close']),
                            icon = 'window-maximize',
                            onSelect = function()
                                local idx = 0
                                local intact = IsVehicleWindowIntact(veh, idx)
                                if intact then
                                    RollDownWindow(veh, idx)
                                    notify(Locales['window_front_left'] .. ' ' .. Locales['window_opened'])
                                else
                                    RollUpWindow(veh, idx)
                                    notify(Locales['window_front_left'] .. ' ' .. Locales['window_closed'])
                                end
                            end
                        },
                        {
                            label = (IsVehicleWindowIntact(veh, 1) and Locales['window_front_right'] .. ' ' .. Locales['window_open'] or Locales['window_front_right'] .. ' ' .. Locales['window_close']),
                            icon = 'window-maximize',
                            onSelect = function()
                                local idx = 1
                                local intact = IsVehicleWindowIntact(veh, idx)
                                if intact then
                                    RollDownWindow(veh, idx)
                                    notify(Locales['window_front_right'] .. ' ' .. Locales['window_opened'])
                                else
                                    RollUpWindow(veh, idx)
                                    notify(Locales['window_front_right'] .. ' ' .. Locales['window_closed'])
                                end
                            end
                        },
                        {
                            label = (IsVehicleWindowIntact(veh, 2) and Locales['window_back_left'] .. ' ' .. Locales['window_open'] or Locales['window_back_left'] .. ' ' .. Locales['window_close']),
                            icon = 'window-maximize',
                            onSelect = function()
                                local idx = 2
                                local intact = IsVehicleWindowIntact(veh, idx)
                                if intact then
                                    RollDownWindow(veh, idx)
                                    notify(Locales['window_back_left'] .. ' ' .. Locales['window_opened'])
                                else
                                    RollUpWindow(veh, idx)
                                    notify(Locales['window_back_left'] .. ' ' .. Locales['window_closed'])
                                end
                            end
                        },
                        {
                            label = (IsVehicleWindowIntact(veh, 3) and Locales['window_back_right'] .. ' ' .. Locales['window_open'] or Locales['window_back_right'] .. ' ' .. Locales['window_close']),
                            icon = 'window-maximize',
                            onSelect = function()
                                local idx = 3
                                local intact = IsVehicleWindowIntact(veh, idx)
                                if intact then
                                    RollDownWindow(veh, idx)
                                    notify(Locales['window_back_right'] .. ' ' .. Locales['window_opened'])
                                else
                                    RollUpWindow(veh, idx)
                                    notify(Locales['window_back_right'] .. ' ' .. Locales['window_closed'])
                                end
                            end
                        },
                        {
                            label = (function()
                                for i = 0, 3 do
                                    if IsVehicleWindowIntact(veh, i) then return Locales['window_all'] .. ' ' .. Locales['window_open'] end
                                end
                                return Locales['window_all'] .. ' ' .. Locales['window_close']
                            end)(),
                            icon = 'layer-group',
                            onSelect = function()
                                local anyClosed = false
                                for i = 0, 3 do
                                    if IsVehicleWindowIntact(veh, i) then
                                        anyClosed = true
                                        break
                                    end
                                end
                                if anyClosed then
                                    for i = 0, 3 do
                                        RollDownWindow(veh, i)
                                    end
                                    notify(Locales['windows_opened'])
                                else
                                    for i = 0, 3 do
                                        RollUpWindow(veh, i)
                                    end
                                    notify(Locales['windows_closed'])
                                end
                            end
                        }
                    }
                })
            end

            if doorMask ~= prevDoorMask then
                prevDoorMask = doorMask
                exports.ox_lib:registerRadial({
                    id = doorsMenuId,
                    items = {
                        {
                            label = (GetVehicleDoorAngleRatio(veh, 0) and GetVehicleDoorAngleRatio(veh, 0) > 0.01) and Locales['door_front_left'] .. ' ' .. Locales['door_close'] or Locales['door_front_left'] .. ' ' .. Locales['door_open'],
                            icon = 'door-closed',
                            onSelect = function()
                                local idx = 0
                                local angle = GetVehicleDoorAngleRatio(veh, idx)
                                if angle and angle > 0.01 then
                                    SetVehicleDoorShut(veh, idx, false)
                                    notify(Locales['door_front_left'] .. ' ' .. Locales['door_closed'])
                                else
                                    SetVehicleDoorOpen(veh, idx, false, false)
                                    notify(Locales['door_front_left'] .. ' ' .. Locales['door_opened'])
                                end
                            end
                        },
                        {
                            label = (GetVehicleDoorAngleRatio(veh, 1) and GetVehicleDoorAngleRatio(veh, 1) > 0.01) and Locales['door_front_right'] .. ' ' .. Locales['door_close'] or Locales['door_front_right'] .. ' ' .. Locales['door_open'],
                            icon = 'door-closed',
                            onSelect = function()
                                local idx = 1
                                local angle = GetVehicleDoorAngleRatio(veh, idx)
                                if angle and angle > 0.01 then
                                    SetVehicleDoorShut(veh, idx, false)
                                    notify(Locales['door_front_right'] .. ' ' .. Locales['door_closed'])
                                else
                                    SetVehicleDoorOpen(veh, idx, false, false)
                                    notify(Locales['door_front_right'] .. ' ' .. Locales['door_opened'])
                                end
                            end
                        },
                        {
                            label = (GetVehicleDoorAngleRatio(veh, 2) and GetVehicleDoorAngleRatio(veh, 2) > 0.01) and Locales['door_back_left'] .. ' ' .. Locales['door_close'] or Locales['door_back_left'] .. ' ' .. Locales['door_open'],
                            icon = 'door-closed',
                            onSelect = function()
                                local idx = 2
                                local angle = GetVehicleDoorAngleRatio(veh, idx)
                                if angle and angle > 0.01 then
                                    SetVehicleDoorShut(veh, idx, false)
                                    notify(Locales['door_back_left'] .. ' ' .. Locales['door_closed'])
                                else
                                    SetVehicleDoorOpen(veh, idx, false, false)
                                    notify(Locales['door_back_left'] .. ' ' .. Locales['door_opened'])
                                end
                            end
                        },
                        {
                            label = (GetVehicleDoorAngleRatio(veh, 3) and GetVehicleDoorAngleRatio(veh, 3) > 0.01) and Locales['door_back_right'] .. ' ' .. Locales['door_close'] or Locales['door_back_right'] .. ' ' .. Locales['door_open'],
                            icon = 'door-closed',
                            onSelect = function()
                                local idx = 3
                                local angle = GetVehicleDoorAngleRatio(veh, idx)
                                if angle and angle > 0.01 then
                                    SetVehicleDoorShut(veh, idx, false)
                                    notify(Locales['door_back_right'] .. ' ' .. Locales['door_closed'])
                                else
                                    SetVehicleDoorOpen(veh, idx, false, false)
                                    notify(Locales['door_back_right'] .. ' ' .. Locales['door_opened'])
                                end
                            end
                        },
                        {
                            label = (function()
                                for i = 0, 3 do
                                    local angle = GetVehicleDoorAngleRatio(veh, i)
                                    if not angle or angle <= 0.01 then return Locales['door_all'] .. ' ' .. Locales['door_open'] end
                                end
                                return Locales['door_all'] .. ' ' .. Locales['door_close']
                            end)(),
                            icon = 'layer-group',
                            onSelect = function()
                                local anyClosed = false
                                for i = 0, 3 do
                                    local angle = GetVehicleDoorAngleRatio(veh, i)
                                    if not angle or angle <= 0.01 then
                                        anyClosed = true
                                        break
                                    end
                                end
                                if anyClosed then
                                    for i = 0, 3 do
                                        SetVehicleDoorOpen(veh, i, false, false)
                                    end
                                    notify(Locales['doors_opened'])
                                else
                                    for i = 0, 3 do
                                        SetVehicleDoorShut(veh, i, false)
                                    end
                                    notify(Locales['doors_closed'])
                                end
                            end
                        }
                    }
                })
            end

            if extrasMask ~= prevExtrasMask then
                prevExtrasMask = extrasMask
                local extrasItems = {}
                
                local engineHealth = GetVehicleEngineHealth(veh)
                local bodyHealth = GetVehicleBodyHealth(veh)
                local isVehicleDamaged = engineHealth < 200 or (bodyHealth < 150)
                
                if #availableExtras == 0 then
                    table.insert(extrasItems, {
                        label = Locales['no_extras'],
                        icon = 'ban',
                        disabled = true
                    })
                else
                    for _, extraId in ipairs(availableExtras) do
                        local isOn = IsVehicleExtraTurnedOn(veh, extraId)
                        table.insert(extrasItems, {
                            label = (isOn and Locales['extra'] .. ' ' .. extraId .. ' - ' .. Locales['extra_on'] or Locales['extra'] .. ' ' .. extraId .. ' - ' .. Locales['extra_off']),
                            icon = (isOn and 'toggle-on' or 'toggle-off'),
                            disabled = isVehicleDamaged,
                            onSelect = function()
                                local ped = cache.ped
                                local veh = GetVehiclePedIsIn(ped, false)
                                if veh and veh ~= 0 then
                                    local currentEngineHealth = GetVehicleEngineHealth(veh)
                                    local currentBodyHealth = GetVehicleBodyHealth(veh)
                                    if currentEngineHealth < 200 or currentBodyHealth < 150 then
                                        notify(Locales['vehicle_damaged'])
                                        return
                                    end
                                    local isCurrentlyOn = IsVehicleExtraTurnedOn(veh, extraId)
                                    SetVehicleExtra(veh, extraId, (isCurrentlyOn and 0 or 1))
                                    notify(Locales['extra'] .. ' ' .. extraId .. ' ' .. (isCurrentlyOn and Locales['extra_disabled'] or Locales['extra_enabled']))
                                end
                            end
                        })
                    end
                end
                
                exports.ox_lib:registerRadial({
                    id = extrasMenuId,
                    items = extrasItems
                })
            end

            do
                local model = GetEntityModel(veh)
                local modelName = GetDisplayNameFromVehicleModel(model) or ''
                modelName = tostring(modelName):lower()
                local seatsCount = GetVehicleModelNumberOfSeats(model)
                if not seatsCount or seatsCount < 1 then seatsCount = 4 end

                local vehicleCfg = nil
                if Config and Config.VehicleSeats then
                    vehicleCfg = Config.VehicleSeats[modelName] or Config.VehicleSeats[tostring(model)]
                    if not vehicleCfg then
                        for k, v in pairs(Config.VehicleSeats) do
                            if type(k) == 'string' then
                                if GetHashKey(k) == model then
                                    vehicleCfg = v
                                    break
                                end
                            end
                        end
                    end
                end

                if vehicleCfg and vehicleCfg.seats and #vehicleCfg.seats > 0 then
                    seatsCount = #vehicleCfg.seats
                end

                if seatsCount ~= prevSeatsCount or prevSeatsModel ~= model then
                    prevSeatsCount = seatsCount
                    prevSeatsModel = model
                    local seatsItems = {}
                    for n = 1, seatsCount do
                        local nn = n
                        local seatIndex = (nn == 1) and -1 or (nn - 2)
                        local seatLabel = Locales['seat'] .. ' ' .. nn

                        local seatEntry = nil
                        if vehicleCfg and vehicleCfg.seats then
                            seatEntry = vehicleCfg.seats[nn]
                        end

                        if seatEntry then
                            if type(seatEntry) == 'table' then
                                if seatEntry.label then seatLabel = seatEntry.label end
                                if seatEntry.index ~= nil then seatIndex = seatEntry.index end
                            else
                                seatLabel = seatEntry
                            end
                        end

                        table.insert(seatsItems, {
                            label = seatLabel,
                            icon = 'chair',
                            onSelect = function()
                                local ped = cache.ped
                                local veh2 = GetVehiclePedIsIn(ped, false)
                                if not veh2 or veh2 == 0 then
                                    notify(Locales['not_in_vehicle'])
                                    return
                                end
                                if not IsVehicleSeatFree(veh2, seatIndex) then
                                    notify(Locales['seat_occupied'])
                                    return
                                end
                                TaskWarpPedIntoVehicle(ped, veh2, seatIndex)
                                notify(Locales['seat_changed'] .. ' ' .. seatLabel)
                            end
                        })
                    end
                    exports.ox_lib:registerRadial({ id = seatsMenuId, items = seatsItems })
                end
            end

            local running = GetIsVehicleEngineRunning(veh)
            if prevEngineRunning ~= running then
                prevEngineRunning = running
                exports.ox_lib:registerRadial({
                    id = autoMenuId,
                    items = {
                        {
                            label = running and Locales['motor_stop'] or Locales['motor_start'],
                            icon = 'power-off',
                            onSelect = function()
                                local ped = cache.ped
                                local veh = GetVehiclePedIsIn(ped, false)
                                if not veh or veh == 0 then
                                    notify(Locales['not_in_vehicle'])
                                    return
                                end
                                local driver = GetPedInVehicleSeat(veh, -1)
                                if driver ~= ped then
                                    notify(Locales['only_driver_engine'])
                                    return
                                end
                                local running = GetIsVehicleEngineRunning(veh)
                                SetVehicleEngineOn(veh, not running, false, true)
                                notify(not running and Locales['motor_started'] or Locales['motor_stopped'])
                            end
                        },
                        {
                            label = Locales['seat_change'],
                            icon = 'chair',
                            menu = seatsMenuId
                        },
                        {
                            label = Locales['windows'],
                            icon = 'window-maximize',
                            menu = windowsMenuId
                        },
                        {
                            label = Locales['doors'],
                            icon = 'car-side',
                            menu = doorsMenuId
                        },
                        {
                            label = Locales['car_extras'],
                            icon = 'microchip',
                            menu = extrasMenuId
                        }
                    }
                })
            end
        else
            if added then
                exports.ox_lib:removeRadialItem(autoGlobalId)
                added = false
                prevEngineRunning = nil
                prevExtrasMask = -1
            end
        end
        Wait(1000)
    end
end)
