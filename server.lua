local afkPlayers = {}

RegisterServerEvent('b2_afkSystem:playerAFK')
AddEventHandler('b2_afkSystem:playerAFK', function()
    local src = source
    local isIgnored = IsPlayerAceAllowed(src, "b2_afk_ignore")
    
    afkPlayers[src] = {
        time = GetGameTimer(),
        ignored = isIgnored
    }
    TriggerClientEvent('b2_afkSystem:updateAFKList', -1, afkPlayers)

    -- Only set up kick timer for non-ignored players
    if not isIgnored and Config.KickTime > 0 then
        Citizen.SetTimeout(Config.KickTime * 1000, function()
            if afkPlayers[src] and not afkPlayers[src].ignored then
                DropPlayer(src, "You were kicked for being AFK too long.")
            end
        end)
    end
end)

RegisterServerEvent('b2_afkSystem:playerReturn')
AddEventHandler('b2_afkSystem:playerReturn', function()
    local src = source
    afkPlayers[src] = nil
    TriggerClientEvent('b2_afkSystem:updateAFKList', -1, afkPlayers)
end)

RegisterServerEvent('b2_afkSystem:requestAFKList')
AddEventHandler('b2_afkSystem:requestAFKList', function()
    local src = source
    TriggerClientEvent('b2_afkSystem:updateAFKList', src, afkPlayers)
end)

RegisterServerEvent('b2_afkSystem:checkPlayerGroup')
AddEventHandler('b2_afkSystem:checkPlayerGroup', function()
    local src = source
    local isIgnored = IsPlayerAceAllowed(src, "b2_afk_ignore")
    TriggerClientEvent('b2_afkSystem:setPlayerGroup', src, isIgnored)
end)