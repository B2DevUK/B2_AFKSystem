local lastActivityTime = GetGameTimer()
local isAFK = false
local afkPlayers = {}
local isIgnoredGroup = false

-- Function to draw 3D text
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0, 0, 0, 75)
end

function CheckPlayerGroup()
    TriggerServerEvent('b2_afkSystem:checkPlayerGroup')
end

Citizen.CreateThread(function()
    CheckPlayerGroup()
    
    while true do
        Citizen.Wait(1000)

        if Config.AFKSystemEnabled then
            local currentTime = GetGameTimer()
            
            if IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35) or IsPedWalking(PlayerPedId()) or IsPedRunning(PlayerPedId()) or IsPedSprinting(PlayerPedId()) then
                lastActivityTime = currentTime
                if isAFK then
                    isAFK = false
                    if Config.InvincibilityEnabled and not isIgnoredGroup then
                        SetEntityInvincible(PlayerPedId(), false)
                    end
                    TriggerServerEvent('b2_afkSystem:playerReturn')
                end
            end

            if not isAFK and (currentTime - lastActivityTime) > (Config.IdleTimeThreshold * 1000) then
                isAFK = true
                if Config.InvincibilityEnabled and not isIgnoredGroup then
                    SetEntityInvincible(PlayerPedId(), true)
                end
                TriggerServerEvent('b2_afkSystem:playerAFK')
            end
        end
    end
end)

function IsPlayerInIgnoredGroup()
    return playerGroup == "ignored"
end

RegisterNetEvent('b2_afkSystem:applyAFKState')
AddEventHandler('b2_afkSystem:applyAFKState', function(playerId)
    afkPlayers[playerId] = true
    print("Player " .. playerId .. " is marked as AFK")
end)

RegisterNetEvent('b2_afkSystem:removeAFKState')
AddEventHandler('b2_afkSystem:removeAFKState', function(playerId)
    afkPlayers[playerId] = nil
    print("Player " .. playerId .. " is removed from AFK state")
end)

RegisterNetEvent('b2_afkSystem:setPlayerGroup')
AddEventHandler('b2_afkSystem:setPlayerGroup', function(ignored)
    isIgnoredGroup = ignored
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.AFKIconEnabled then
            for playerId, _ in pairs(afkPlayers) do
                local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
                if playerPed then
                    local coords = GetEntityCoords(playerPed)
                    DrawText3D(coords.x, coords.y, coords.z + 1.0, "AFK")
                end
            end
        end
    end
end)
