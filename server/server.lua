local afkPlayers = {}

RegisterServerEvent('b2_afkSystem:playerAFK')
AddEventHandler('b2_afkSystem:playerAFK', function()
    local src = source
    afkPlayers[src] = GetGameTimer()
    TriggerClientEvent('b2_afkSystem:applyAFKState', -1, src)

    -- Kick player after Config.KickTime
    if Config.KickTime > 0 then
        Citizen.CreateThread(function()
            Citizen.Wait(Config.KickTime * 1000)
            if afkPlayers[src] then
                DropPlayer(src, "You were kicked for being AFK too long.")
            end
        end)
    end
end)

RegisterServerEvent('b2_afkSystem:playerReturn')
AddEventHandler('b2_afkSystem:playerReturn', function()
    local src = source
    afkPlayers[src] = nil
    TriggerClientEvent('b2_afkSystem:removeAFKState', -1, src)
end)

RegisterServerEvent('b2_afkSystem:checkPlayerGroup')
AddEventHandler('b2_afkSystem:checkPlayerGroup', function()
    local src = source
    for _, group in ipairs(Config.IgnoredGroups) do
        if IsPlayerAceAllowed(src, "group." .. group) then
            TriggerClientEvent('b2_afkSystem:setPlayerGroup', src, group)
            return
        end
    end
    TriggerClientEvent('b2_afkSystem:setPlayerGroup', src, "user")
end)
