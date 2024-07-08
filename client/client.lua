local lastActivityTime = GetGameTimer()
local isAFK = false
local afkPlayers = {}

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
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 75)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if Config.AFKSystemEnabled then
            local currentTime = GetGameTimer()
            
            -- Check for player activity
            if IsControlJustPressed(0, 1) or IsControlJustPressed(0, 2) or IsControlJustPressed(0, 32) or IsControlJustPressed(0, 33) or IsControlJustPressed(0, 34) or IsControlJustPressed(0, 35) then
                lastActivityTime = currentTime
                if isAFK then
                    isAFK = false
                    local playerPed = PlayerPedId()
                    SetEntityInvincible(playerPed, false)
                    TriggerServerEvent('b2_afkSystem:playerReturn')
                    print("Player returned from AFK")
                end
            end

            -- Check if player is AFK
            if not isAFK and (currentTime - lastActivityTime) > (Config.IdleTimeThreshold * 1000) then
                isAFK = true
                local playerPed = PlayerPedId()
                SetEntityInvincible(playerPed, true)
                TriggerServerEvent('b2_afkSystem:playerAFK')
                print("Player is AFK")
            end
        end
    end
end)

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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for playerId, _ in pairs(afkPlayers) do
            local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
            if playerPed then
                local coords = GetEntityCoords(playerPed)
                DrawText3D(coords.x, coords.y, coords.z + 1.0, "AFK")
            end
        end
    end
end)
