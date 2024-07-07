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

RegisterServerEvent('b2_afksystem:playerReturn')
AddEventHandler('b2_afkSystem:playerReturn', function()
    local src = source
    afkPlayers[src] = nil
    TriggerClientEvent('afk:removeAFKState', -1, src)
end)
