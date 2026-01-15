local cache = cache

ESX = exports['es_extended']:getSharedObject()

local frakGlobalId = 'ox_frak_global'
local frakMenuId = 'ox_frak_menu'

local function notify(text)
    local title = (Locales and Locales['frak_title']) or 'Fraktions Management'
    lib.notify({title = title, description = text})
end

local function getPed()
    if cache and cache.ped then return cache.ped end
    return PlayerPedId()
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

local function isBoss()
    local pd = ESX.GetPlayerData and ESX.GetPlayerData() or ESX.PlayerData
    if not pd or not pd.job then return false end
    local grade = pd.job.grade_name or pd.job.gradeLabel or pd.job.grade
    if not grade then return false end
    return tostring(grade):lower() == 'boss'
end

local function doEmoteAndFreezeCmd(emoteCmd, durationMs)
    CreateThread(function()
        local ped = PlayerPedId()
        if not emoteCmd or emoteCmd == '' then return end
        ExecuteCommand(emoteCmd)
        FreezeEntityPosition(ped, true)
        local start = GetGameTimer()
        while GetGameTimer() - start < (durationMs or 6000) do
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            Wait(0)
        end
        FreezeEntityPosition(ped, false)
        ExecuteCommand('e c')
    end)
end

RegisterNetEvent('frak:client:doEmoteAndFreeze')
AddEventHandler('frak:client:doEmoteAndFreeze', function(durationMs, emoteCmd)
    doEmoteAndFreezeCmd(emoteCmd or 'e clipboard2', durationMs or 6000)
end)

exports.ox_lib:registerRadial({
    id = frakMenuId,
    items = {
        {
            label = (Locales and Locales['frak_employee_list']) or 'Mitarbeiterliste',
            icon = 'list',
            onSelect = function()
                TriggerServerEvent('frak:server:requestList')
            end
        },
        {
            label = (Locales and Locales['frak_hire']) or 'Einstellen',
            icon = 'user-plus',
            onSelect = function()
                if not isBoss() then notify((Locales and Locales['not_boss']) or 'Du bist kein Boss deiner Fraktion') return end
                local target = getClosestPlayer(3.0)
                if not target then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                local sid = GetPlayerServerId(target)
                local pd = ESX.GetPlayerData and ESX.GetPlayerData() or ESX.PlayerData
                local jobName = pd and pd.job and pd.job.name or nil
                TriggerServerEvent('frak:server:hire', sid, jobName)
            end
        },
        {
            label = (Locales and Locales['frak_fire']) or 'Kündigen',
            icon = 'user-minus',
            onSelect = function()
                if not isBoss() then notify((Locales and Locales['not_boss']) or 'Du bist kein Boss deiner Fraktion') return end
                local target = getClosestPlayer(3.0)
                if not target then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                local sid = GetPlayerServerId(target)
                local pd = ESX.GetPlayerData and ESX.GetPlayerData() or ESX.PlayerData
                local jobName = pd and pd.job and pd.job.name or nil
                TriggerServerEvent('frak:server:fire', sid, jobName)
            end
        },
        {
            label = (Locales and Locales['frak_promote']) or 'Befördern',
            icon = 'arrow-up',
            onSelect = function()
                if not isBoss() then notify((Locales and Locales['not_boss']) or 'Du bist kein Boss deiner Fraktion') return end
                local target = getClosestPlayer(3.0)
                if not target then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                local sid = GetPlayerServerId(target)
                local pd = ESX.GetPlayerData and ESX.GetPlayerData() or ESX.PlayerData
                local jobName = pd and pd.job and pd.job.name or nil
                TriggerServerEvent('frak:server:promote', sid, jobName)
            end
        },
        {
            label = (Locales and Locales['frak_demote']) or 'Dekadrieren',
            icon = 'arrow-down',
            onSelect = function()
                if not isBoss() then notify((Locales and Locales['not_boss']) or 'Du bist kein Boss deiner Fraktion') return end
                local target = getClosestPlayer(3.0)
                if not target then notify((Locales and Locales['no_player_near']) or 'Keine Person in der Nähe') return end
                local sid = GetPlayerServerId(target)
                local pd = ESX.GetPlayerData and ESX.GetPlayerData() or ESX.PlayerData
                local jobName = pd and pd.job and pd.job.name or nil
                TriggerServerEvent('frak:server:demote', sid, jobName)
            end
        }
    }
})

if isBoss() then
    exports.ox_lib:addRadialItem({ id = frakGlobalId, label = (Locales and Locales['frak_title']) or 'Fraktions Management', icon = 'users', menu = frakMenuId })
end

RegisterNetEvent('frak:client:showList')
AddEventHandler('frak:client:showList', function(payload)
    local list = payload and payload.list or {}
    local grades = payload and payload.grades or {}
    if type(list) ~= 'table' or #list == 0 then
        notify((Locales and Locales['no_employees_found']) or 'Keine Mitarbeiter gefunden')
        return
    end

    local options = {}
    local function findGradeLabel(gradeNum)
        if not gradeNum or not grades then return nil end
        for _, g in ipairs(grades) do
            if tonumber(g.grade) == tonumber(gradeNum) then
                return g.label or tostring(g.grade)
            end
        end
        return nil
    end
    for i=1, #list do
        local entry = list[i]
        local name = entry.name or entry.label or ('Spieler ' .. tostring(i))
        local rawGrade = entry.grade or entry.rank or ''
        local gradeNum = tonumber(rawGrade) or nil
        local gradeLabel = entry.grade_label or findGradeLabel(gradeNum)
        local grade = tostring(gradeLabel or (gradeNum and tostring(gradeNum) or ''))
        local sid = entry.sid or entry.serverId or entry.source or entry.id
        local gradeLabel = entry.grade_label or nil

        table.insert(options, {
            title = name,
            description = ((Locales and Locales['rank_label_prefix']) or 'Rang: ') .. grade,
            onSelect = function()
                local pd = ESX.GetPlayerData and ESX.GetPlayerData() or ESX.PlayerData
                local jobName = pd and pd.job and pd.job.name or nil

                local actionId = frakMenuId .. '_actions_' .. tostring(sid or (entry.identifier or i))
                local actions = {}
                table.insert(actions, {
                    title = (Locales and Locales['frak_promote']) or 'Befördern',
                    description = (Locales and Locales['rank_select']) or 'Rang auswählen',
                    onSelect = function()
                        local promoteId = actionId .. '_promote'
                        local promoteOptions = {}
                        local curGrade = tonumber(entry.grade) or nil
                        local myGrade = pd and pd.job and tonumber(pd.job.grade) or nil
                        for _, g in ipairs(grades) do
                            local gnum = tonumber(g.grade) or nil
                            if not curGrade or (gnum and curGrade and gnum > curGrade and gnum < myGrade) then
                                table.insert(promoteOptions, {
                                    title = tostring(g.label or ((Locales and Locales['rank_label_prefix']) and (Locales['rank_label_prefix'] .. tostring(g.grade)) or ('Rang ' .. tostring(g.grade)))),
                                    description = ((Locales and Locales['rank_set_desc_prefix']) or 'Setzt Rang: ') .. tostring(g.grade),
                                    onSelect = function()
                                        local targetKey = sid or entry.identifier
                                        TriggerServerEvent('frak:server:setgrade', targetKey, jobName, g.grade)
                                    end
                                })
                            end
                        end
                        if #promoteOptions == 0 then
                            table.insert(promoteOptions, { title = (Locales and Locales['no_higher_ranks']) or 'No higher ranks', description = '', disabled = true })
                        end
                        exports.ox_lib:registerContext({ id = promoteId, title = ((Locales and Locales['frak_promote']) or 'Befördern') .. ' - ' .. name, options = promoteOptions })
                        exports.ox_lib:showContext(promoteId)
                    end
                })
                table.insert(actions, {
                    title = (Locales and Locales['frak_demote']) or 'Dekadrieren',
                    description = (Locales and Locales['rank_select']) or 'Rang auswählen',
                    onSelect = function()
                        local demoteId = actionId .. '_demote'
                        local demoteOptions = {}
                        local curGrade = tonumber(entry.grade) or nil
                        for _, g in ipairs(grades) do
                            local gnum = tonumber(g.grade) or nil
                            if curGrade and gnum and gnum < curGrade then
                                table.insert(demoteOptions, {
                                    title = tostring(g.label or ('Rang ' .. tostring(g.grade))),
                                    description = ((Locales and Locales['rank_set_desc_prefix']) or 'Setzt Rang: ') .. tostring(g.grade),
                                    onSelect = function()
                                        local targetKey = sid or entry.identifier
                                        TriggerServerEvent('frak:server:setgrade', targetKey, jobName, g.grade)
                                    end
                                })
                            end
                        end
                        if #demoteOptions == 0 then
                            table.insert(demoteOptions, { title = (Locales and Locales['no_lower_ranks']) or 'Keine niedrigeren Ränge', description = '', disabled = true })
                        end
                        exports.ox_lib:registerContext({ id = demoteId, title = ((Locales and Locales['frak_demote']) or 'Dekadrieren') .. ' - ' .. name, options = demoteOptions })
                        exports.ox_lib:showContext(demoteId)
                    end
                })
                table.insert(actions, {
                    title = (Locales and Locales['frak_fire']) or 'Kündigen',
                    description = (Locales and Locales['removed_from_faction']) or 'Entfernt die Person aus der Fraktion',
                    onSelect = function()
                        local targetKey = sid or entry.identifier
                        TriggerServerEvent('frak:server:fire', targetKey, jobName)
                    end
                })

                exports.ox_lib:registerContext({
                    id = actionId,
                    title = name,
                    options = actions
                })

                exports.ox_lib:showContext(actionId)
            end
        })
    end

    local listId = frakMenuId .. '_list'
    exports.ox_lib:registerContext({
        id = listId,
        title = (Locales and Locales['frak_employee_list']) or 'Mitarbeiterliste',
        options = options
    })

    exports.ox_lib:showContext(listId)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if ESX.GetPlayerData then
        ESX.GetPlayerData().job = job
    else
        ESX.PlayerData = ESX.PlayerData or {}
        ESX.PlayerData.job = job
    end
    Citizen.SetTimeout(200, function()
        if isBoss() then
            exports.ox_lib:addRadialItem({ id = frakGlobalId, label = 'Fraktions Management', icon = 'users', menu = frakMenuId })
        else
            pcall(function()
                exports.ox_lib:removeRadialItem(frakGlobalId)
            end)
        end
    end)
end)

CreateThread(function()
    local tries = 0
    while tries < 50 do
        local pd = ESX.GetPlayerData and ESX.GetPlayerData() or ESX.PlayerData
        if pd and pd.job then break end
        tries = tries + 1
        Wait(100)
    end
        if isBoss() then
        exports.ox_lib:addRadialItem({ id = frakGlobalId, label = (Locales and Locales['frak_title']) or 'Fraktions Management', icon = 'users', menu = frakMenuId })
    else
        pcall(function() exports.ox_lib:removeRadialItem(frakGlobalId) end)
    end
end)

RegisterNetEvent('frak:client:notify')
AddEventHandler('frak:client:notify', function(text)
    notify(text)
end)