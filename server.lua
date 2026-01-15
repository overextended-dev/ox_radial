RegisterNetEvent('ox_radial:requestRemoveMask')
AddEventHandler('ox_radial:requestRemoveMask', function(targetSid)
    local requester = source
    local target = tonumber(targetSid)
    if not target then
        TriggerClientEvent('ox_radial:notifyRequester', requester, 'Ungültige Ziel-ID')
        return
    end
    if target == requester then
        TriggerClientEvent('ox_radial:notifyRequester', requester, 'Du kannst deine eigene Maske nicht entfernen')
        return
    end
    TriggerClientEvent('ox_radial:doRemoveMask', target, requester)
end)

RegisterNetEvent('ox_radial:maskRemoved')
AddEventHandler('ox_radial:maskRemoved', function(requesterSid)
    local targetSource = source
    local requester = tonumber(requesterSid)
    if requester then
        TriggerClientEvent('ox_radial:notifyRequester', requester, 'Maske erfolgreich entfernt')
    end
end)

ESX = ESX or nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('frak:server:requestList')
AddEventHandler('frak:server:requestList', function(jobName)
    local src = source
    if not jobName or jobName == '' then
        local xSrc = ESX and ESX.GetPlayerFromId and ESX.GetPlayerFromId(src) or nil
        jobName = xSrc and xSrc.job and xSrc.job.name or nil
        if not jobName or jobName == '' then
            TriggerClientEvent('frak:client:notify', src, 'Ungültiger Jobname')
            return
        end
    end
    local function sendList(list)
        TriggerClientEvent('frak:client:showList', src, list)
    end

    local function normalizeName(row)
        if not row then return nil end
        if row.firstname and row.lastname then
            return tostring(row.firstname) .. ' ' .. tostring(row.lastname)
        end
        if row.name then return tostring(row.name) end
        if row.playername then return tostring(row.playername) end
        if row.identifier then return tostring(row.identifier) end
        return nil
    end

    local list = {}
    local byIdentifier = {}

    local jobGrades = {}
    if ESX and ESX.Jobs and ESX.Jobs[jobName] and ESX.Jobs[jobName].grades then
        for g, info in pairs(ESX.Jobs[jobName].grades) do
            table.insert(jobGrades, { grade = tonumber(g), label = tostring(info.label or info.name or ('Rang ' .. tostring(g))) })
        end
        table.sort(jobGrades, function(a,b) return a.grade < b.grade end)
    end

    local function mergeRow(name, grade, sid, identifier, gradeLabel)
        local key = identifier or tostring(sid or name)
        if byIdentifier[key] then return end
        local entry = { name = name or ('Spieler ' .. tostring(sid or key)), grade = grade or 0, grade_label = gradeLabel, sid = sid, identifier = identifier }
        table.insert(list, entry)
        byIdentifier[key] = true
    end

    local fetched = false
    if exports and exports.oxmysql then
        exports.oxmysql:execute('SELECT * FROM users WHERE job = ?', {jobName}, function(rows)
            if rows and #rows > 0 then
                for _, row in ipairs(rows) do
                    local name = normalizeName(row)
                    local grade = tonumber(row.job_grade or row.jobgrade or row.grade or 0)
                    local gradeLabel = nil
                    if jobGrades and #jobGrades > 0 then
                        for _, g in ipairs(jobGrades) do if g.grade == grade then gradeLabel = g.label break end end
                    end
                    mergeRow(name, grade, nil, row.identifier, gradeLabel)
                end
            end
            fetched = true
            for _, pid in ipairs(GetPlayers()) do
                local id = tonumber(pid)
                local xPlayer = ESX and ESX.GetPlayerFromId(id) or nil
                if xPlayer and xPlayer.job and xPlayer.job.name == jobName then
                    local pname = GetPlayerName(id) or (xPlayer.identifier or ('Spieler ' .. tostring(id)))
                    local gradeLabel = xPlayer.job.grade_name or xPlayer.job.gradeLabel or nil
                    mergeRow(pname, xPlayer.job.grade or 0, id, xPlayer.identifier or nil, gradeLabel)
                end
            end
            sendList({ list = list, grades = jobGrades })
        end)
    elseif MySQL and MySQL.Async and MySQL.Async.fetchAll then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE job = @job', {['@job'] = jobName}, function(rows)
            if rows and #rows > 0 then
                for _, row in ipairs(rows) do
                    local name = normalizeName(row)
                    local grade = tonumber(row.job_grade or row.jobgrade or row.grade or 0)
                    local gradeLabel = nil
                    if jobGrades and #jobGrades > 0 then
                        for _, g in ipairs(jobGrades) do if g.grade == grade then gradeLabel = g.label break end end
                    end
                    mergeRow(name, grade, nil, row.identifier, gradeLabel)
                end
            end
            fetched = true
            for _, pid in ipairs(GetPlayers()) do
                local id = tonumber(pid)
                local xPlayer = ESX and ESX.GetPlayerFromId(id) or nil
                if xPlayer and xPlayer.job and xPlayer.job.name == jobName then
                    local pname = GetPlayerName(id) or (xPlayer.identifier or ('Spieler ' .. tostring(id)))
                    mergeRow(pname, xPlayer.job.grade or 0, id, xPlayer.identifier or nil)
                end
            end
            sendList({ list = list, grades = jobGrades })
        end)
    else
        for _, pid in ipairs(GetPlayers()) do
            local id = tonumber(pid)
            local xPlayer = ESX and ESX.GetPlayerFromId(id) or nil
            if xPlayer and xPlayer.job and xPlayer.job.name == jobName then
                local pname = GetPlayerName(id) or (xPlayer.identifier or ('Spieler ' .. tostring(id)))
                local gradeLabel = xPlayer.job.grade_name or xPlayer.job.gradeLabel or nil
                mergeRow(pname, xPlayer.job.grade or 0, id, xPlayer.identifier or nil, gradeLabel)
            end
        end
        sendList({ list = list, grades = jobGrades })
    end
end)

local function notifyTo(src, msg)
    TriggerClientEvent('frak:client:notify', src, msg)
end

local function getXPlayer(id)
    if not ESX then return nil end
    return ESX.GetPlayerFromId(tonumber(id))
end

local function findOnlineByIdentifier(identifier)
    if not ESX then return nil end
    for _, pid in ipairs(GetPlayers()) do
        local id = tonumber(pid)
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer and xPlayer.identifier and tostring(xPlayer.identifier) == tostring(identifier) then
            return xPlayer
        end
    end
    return nil
end

local function fetchUserFromDB(identifier, cb)
    if not identifier then cb(nil) return end
    if exports and exports.oxmysql then
        exports.oxmysql:execute('SELECT * FROM users WHERE identifier = ?', {identifier}, function(rows)
            cb(rows and rows[1] or nil)
        end)
    elseif MySQL and MySQL.Async and MySQL.Async.fetchAll then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {['@identifier'] = identifier}, function(rows)
            cb(rows and rows[1] or nil)
        end)
    else
        cb(nil)
    end
end

local function updateUserJobInDB(identifier, jobName, grade, cb)
    if not identifier then if cb then cb(false) end return end
    if exports and exports.oxmysql then
        exports.oxmysql:execute('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {jobName, grade, identifier}, function(affected)
            if cb then cb(true, affected) end
        end)
    elseif MySQL and MySQL.Async and MySQL.Async.execute then
        MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @grade WHERE identifier = @identifier', {['@job'] = jobName, ['@grade'] = grade, ['@identifier'] = identifier}, function(affected)
            if cb then cb(true, affected) end
        end)
    else
        if cb then cb(false) end
    end
end

RegisterNetEvent('frak:server:promote')
AddEventHandler('frak:server:promote', function(targetSid, jobName)
    local src = source
    local xSrc = getXPlayer(src)
    if not xSrc then return end
    if not jobName or xSrc.job.name ~= jobName then notifyTo(src, 'Du bist nicht in dieser Fraktion') return end
    local srcGrade = tonumber(xSrc.job.grade) or 0

    local targetNum = tonumber(targetSid)
    if targetNum then
        if targetNum == src then notifyTo(src, 'Du kannst dich nicht selbst befördern') return end
        local xTarget = getXPlayer(targetNum)
        if not xTarget then notifyTo(src, 'Ziel nicht online') return end
        if xTarget.job.name ~= jobName then notifyTo(src, 'Ziel gehört nicht zur Fraktion') return end
        local tgtGrade = tonumber(xTarget.job.grade) or 0
        if tgtGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        local newGrade = tgtGrade + 1
        if newGrade >= srcGrade then
            notifyTo(src, 'Du kannst niemanden auf deinen Rang befördern')
            return
        end
            TriggerClientEvent('frak:client:doEmoteAndFreeze', src, 6000, 'e clipboard2')
            TriggerClientEvent('frak:client:doEmoteAndFreeze', xTarget.source, 6000, 'e clipboard2')
            xTarget.setJob(jobName, newGrade)
            notifyTo(src, 'Person befördert auf Rang ' .. tostring(newGrade))
            notifyTo(xTarget.source, 'Du wurdest befördert auf Rang ' .. tostring(newGrade))
        return
    end

    local identifier = tostring(targetSid)
    if identifier == tostring(xSrc.identifier) then notifyTo(src, 'Du kannst dich nicht selbst befördern') return end
    local onlineTarget = findOnlineByIdentifier(identifier)
    if onlineTarget then
        if tostring(onlineTarget.identifier) == tostring(xSrc.identifier) then notifyTo(src, 'Du kannst dich nicht selbst befördern') return end
        if onlineTarget.job.name ~= jobName then notifyTo(src, 'Ziel gehört nicht zur Fraktion') return end
        local tgtGrade = tonumber(onlineTarget.job.grade) or 0
        if tgtGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        local newGrade = tgtGrade + 1
        if newGrade >= srcGrade then
            notifyTo(src, 'Du kannst niemanden auf deinen Rang befördern')
            return
        end
        onlineTarget.setJob(jobName, newGrade)
        notifyTo(src, 'Person befördert auf Rang ' .. tostring(newGrade))
        notifyTo(onlineTarget.source, 'Du wurdest befördert auf Rang ' .. tostring(newGrade))
        TriggerClientEvent('frak:client:doEmoteAndFreeze', src, 6000, 'e clipboard2')
        TriggerClientEvent('frak:client:doEmoteAndFreeze', onlineTarget.source, 6000, 'e clipboard2')
        return
    end

    fetchUserFromDB(identifier, function(row)
        if not row then notifyTo(src, 'Ziel nicht gefunden') return end
        local dbJob = row.job
        local dbGrade = tonumber(row.job_grade or row.jobgrade or row.grade or 0)
        if dbJob ~= jobName then notifyTo(src, 'Ziel gehört nicht zur Fraktion') return end
        if dbGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        local newGrade = dbGrade + 1
        if newGrade >= srcGrade then notifyTo(src, 'Du kannst niemanden auf deinen Rang befördern') return end
        updateUserJobInDB(identifier, jobName, newGrade, function(ok)
            if ok then
                notifyTo(src, 'Offline-Person befördert auf Rang ' .. tostring(newGrade))
            else
                notifyTo(src, 'Fehler beim Aktualisieren in der DB')
            end
        end)
    end)
end)

RegisterNetEvent('frak:server:demote')
AddEventHandler('frak:server:demote', function(targetSid, jobName)
    local src = source
    local xSrc = getXPlayer(src)
    if not xSrc then return end
    if not jobName or xSrc.job.name ~= jobName then notifyTo(src, 'Du bist nicht in dieser Fraktion') return end
    local srcGrade = tonumber(xSrc.job.grade) or 0

    local targetNum = tonumber(targetSid)
    if targetNum then
        if targetNum == src then notifyTo(src, 'Du kannst dich nicht selbst dekadrieren') return end
        local xTarget = getXPlayer(targetNum)
        if not xTarget then notifyTo(src, 'Ziel nicht online') return end
        if xTarget.job.name ~= jobName then notifyTo(src, 'Ziel gehört nicht zur Fraktion') return end
        local tgtGrade = tonumber(xTarget.job.grade) or 0
        if tgtGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        local newGrade = math.max(tgtGrade - 1, 0)
        if newGrade == tgtGrade then notifyTo(src, 'Kann nicht weiter dekadrieren') return end
            TriggerClientEvent('frak:client:doEmoteAndFreeze', src, 6000, 'e clipboard2')
            TriggerClientEvent('frak:client:doEmoteAndFreeze', xTarget.source, 6000, 'e clipboard2')
            xTarget.setJob(jobName, newGrade)
            notifyTo(src, 'Person dekadriert auf Rang ' .. tostring(newGrade))
            notifyTo(xTarget.source, 'Du wurdest dekadriert auf Rang ' .. tostring(newGrade))
        return
    end

    local identifier = tostring(targetSid)
    if identifier == tostring(xSrc.identifier) then notifyTo(src, 'Du kannst dich nicht selbst dekadrieren') return end
    local onlineTarget = findOnlineByIdentifier(identifier)
    if onlineTarget then
        if tostring(onlineTarget.identifier) == tostring(xSrc.identifier) then notifyTo(src, 'Du kannst dich nicht selbst dekadrieren') return end
        if onlineTarget.job.name ~= jobName then notifyTo(src, 'Ziel gehört nicht zur Fraktion') return end
        local tgtGrade = tonumber(onlineTarget.job.grade) or 0
        if tgtGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        local newGrade = math.max(tgtGrade - 1, 0)
        if newGrade == tgtGrade then notifyTo(src, 'Kann nicht weiter dekadrieren') return end
        onlineTarget.setJob(jobName, newGrade)
        notifyTo(src, 'Person dekadriert auf Rang ' .. tostring(newGrade))
        notifyTo(onlineTarget.source, 'Du wurdest dekadriert auf Rang ' .. tostring(newGrade))
        return
    end

    fetchUserFromDB(identifier, function(row)
        if not row then notifyTo(src, 'Ziel nicht gefunden') return end
        local dbJob = row.job
        local dbGrade = tonumber(row.job_grade or row.jobgrade or row.grade or 0)
        if dbJob ~= jobName then notifyTo(src, 'Ziel gehört nicht zur Fraktion') return end
        if dbGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        local newGrade = math.max(dbGrade - 1, 0)
        if newGrade == dbGrade then notifyTo(src, 'Kann nicht weiter dekadrieren') return end
        updateUserJobInDB(identifier, jobName, newGrade, function(ok)
            if ok then notifyTo(src, 'Offline-Person dekadriert auf Rang ' .. tostring(newGrade)) else notifyTo(src, 'Fehler beim Aktualisieren in der DB') end
        end)
    end)
end)

RegisterNetEvent('frak:server:fire')
AddEventHandler('frak:server:fire', function(targetSid, jobName)
    local src = source
    local xSrc = getXPlayer(src)
    if not xSrc then return end
    if not jobName or xSrc.job.name ~= jobName then notifyTo(src, 'Du bist nicht in dieser Fraktion') return end
    local srcGrade = tonumber(xSrc.job.grade) or 0

    local targetNum = tonumber(targetSid)
    if targetNum then
        if targetNum == src then notifyTo(src, 'Du kannst dich nicht selbst kündigen') return end
        local xTarget = getXPlayer(targetNum)
        if not xTarget then notifyTo(src, 'Ziel nicht online') return end
        if xTarget.job.name ~= jobName then notifyTo(src, 'Ziel gehört nicht zur Fraktion') return end
        local tgtGrade = tonumber(xTarget.job.grade) or 0
        if tgtGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
            TriggerClientEvent('frak:client:doEmoteAndFreeze', src, 6000, 'e clipboard2')
            TriggerClientEvent('frak:client:doEmoteAndFreeze', xTarget.source, 6000, 'e clipboard2')
            xTarget.setJob('unemployed', 0)
            notifyTo(src, 'Person wurde gekündigt')
            notifyTo(xTarget.source, 'Du wurdest aus der Fraktion entfernt')
        return
    end

    local identifier = tostring(targetSid)
    if identifier == tostring(xSrc.identifier) then notifyTo(src, 'Du kannst dich nicht selbst kündigen') return end
    local onlineTarget = findOnlineByIdentifier(identifier)
    if onlineTarget then
        if tostring(onlineTarget.identifier) == tostring(xSrc.identifier) then notifyTo(src, 'Du kannst dich nicht selbst kündigen') return end
        if onlineTarget.job.name ~= jobName then notifyTo(src, 'Ziel gehört nicht zur Fraktion') return end
        local tgtGrade = tonumber(onlineTarget.job.grade) or 0
        if tgtGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        onlineTarget.setJob('unemployed', 0)
        notifyTo(src, 'Person wurde gekündigt')
        notifyTo(onlineTarget.source, 'Du wurdest aus der Fraktion entfernt')
        return
    end

    fetchUserFromDB(identifier, function(row)
        if not row then notifyTo(src, 'Ziel nicht gefunden') return end
        local dbGrade = tonumber(row.job_grade or row.jobgrade or row.grade or 0)
        if dbGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        updateUserJobInDB(identifier, 'unemployed', 0, function(ok)
            if ok then notifyTo(src, 'Offline-Person wurde gekündigt') else notifyTo(src, 'Fehler beim Aktualisieren in der DB') end
        end)
    end)
end)

RegisterNetEvent('frak:server:hire')
AddEventHandler('frak:server:hire', function(targetSid, jobName)
    local src = source
    local xSrc = getXPlayer(src)
    if not xSrc then return end
    if not jobName or xSrc.job.name ~= jobName then notifyTo(src, 'Du bist nicht in dieser Fraktion') return end
    local srcGrade = tonumber(xSrc.job.grade) or 0
    local hireGrade = math.min(0, srcGrade)

    local targetNum = tonumber(targetSid)
    if targetNum then
        if targetNum == src then notifyTo(src, 'Du kannst dich nicht selbst einstellen') return end
        local xTarget = getXPlayer(targetNum)
        if not xTarget then notifyTo(src, 'Ziel nicht online') return end
        local tgtGrade = tonumber(xTarget.job.grade) or 0
        if tgtGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        if not xTarget.job or tostring(xTarget.job.name) ~= 'unemployed' then notifyTo(src, 'Ziel ist nicht arbeitslos') return end
        TriggerClientEvent('frak:client:doEmoteAndFreeze', src, 3000, 'e clipboard2')
        TriggerClientEvent('frak:client:doEmoteAndFreeze', xTarget.source, 6000, 'e clipboard2')
        xTarget.setJob(jobName, hireGrade)
        notifyTo(src, 'Person eingestellt')
        notifyTo(xTarget.source, 'Du wurdest in die Fraktion eingestellt')
        return
    end

    local identifier = tostring(targetSid)
    if identifier == tostring(xSrc.identifier) then notifyTo(src, 'Du kannst dich nicht selbst einstellen') return end
    local onlineTarget = findOnlineByIdentifier(identifier)
    if onlineTarget then
        if tostring(onlineTarget.identifier) == tostring(xSrc.identifier) then notifyTo(src, 'Du kannst dich nicht selbst einstellen') return end
        local tgtGrade = tonumber(onlineTarget.job.grade) or 0
        if tgtGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        if not onlineTarget.job or tostring(onlineTarget.job.name) ~= 'unemployed' then notifyTo(src, 'Ziel ist nicht arbeitslos') return end
        onlineTarget.setJob(jobName, hireGrade)
        notifyTo(src, 'Person eingestellt')
        notifyTo(onlineTarget.source, 'Du wurdest in die Fraktion eingestellt')
        return
    end

    fetchUserFromDB(identifier, function(row)
        if not row then notifyTo(src, 'Ziel nicht gefunden') return end
        local dbGrade = tonumber(row.job_grade or row.jobgrade or row.grade or 0)
        if dbGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        if not row.job or tostring(row.job) ~= 'unemployed' then notifyTo(src, 'Offline-Person ist nicht arbeitslos') return end
        updateUserJobInDB(identifier, jobName, hireGrade, function(ok)
            if ok then notifyTo(src, 'Offline-Person eingestellt') else notifyTo(src, 'Fehler beim Aktualisieren in der DB') end
        end)
    end)
end)

RegisterNetEvent('frak:server:setgrade')
AddEventHandler('frak:server:setgrade', function(targetSid, jobName, grade)
    local src = source
    local xSrc = getXPlayer(src)
    if not xSrc then return end
    if not jobName or xSrc.job.name ~= jobName then notifyTo(src, 'Du bist nicht in dieser Fraktion') return end
    local gradeNum = tonumber(grade) or 0
    local srcGrade = tonumber(xSrc.job.grade) or 0
    if gradeNum >= srcGrade then notifyTo(src, 'Du kannst niemanden auf deinen Rang oder höher setzen') return end

    local targetNum = tonumber(targetSid)
    if targetNum then
        local xTarget = getXPlayer(targetNum)
        if not xTarget then notifyTo(src, 'Ziel nicht online') return end
        if xTarget.job.name ~= jobName and jobName ~= 'unemployed' then notifyTo(src, 'Ziel gehört nicht zur Fraktion') return end
        local tgtGrade = tonumber(xTarget.job.grade) or 0
        if tgtGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        xTarget.setJob(jobName, gradeNum)
        notifyTo(src, 'Rang gesetzt auf ' .. tostring(gradeNum))
        notifyTo(xTarget.source, 'Dein Rang wurde gesetzt auf ' .. tostring(gradeNum))
        return
    end

    local identifier = tostring(targetSid)
    local onlineTarget = findOnlineByIdentifier(identifier)
    if onlineTarget then
        local tgtGrade = tonumber(onlineTarget.job.grade) or 0
        if tgtGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        onlineTarget.setJob(jobName, gradeNum)
        notifyTo(src, 'Rang gesetzt auf ' .. tostring(gradeNum))
        notifyTo(onlineTarget.source, 'Dein Rang wurde gesetzt auf ' .. tostring(gradeNum))
        return
    end

    fetchUserFromDB(identifier, function(row)
        if not row then notifyTo(src, 'Ziel nicht gefunden') return end
        local dbGrade = tonumber(row.job_grade or row.jobgrade or row.grade or 0)
        if dbGrade >= srcGrade then notifyTo(src, 'Du kannst Personen mit gleichem oder höherem Rang nicht bearbeiten') return end
        updateUserJobInDB(identifier, jobName, gradeNum, function(ok)
            if ok then notifyTo(src, 'Offline-Person Rang gesetzt auf ' .. tostring(gradeNum)) else notifyTo(src, 'Fehler beim Aktualisieren in der DB') end
        end)
    end)
end)
