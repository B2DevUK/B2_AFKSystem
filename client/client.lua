local lastActivityTime = GetGameTimer()
local isAFK = false
local afkPlayers = {}

-- Function to draw 3D text
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 75)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if Config.AFKSystemEnabled then
            local playerPed = PlayerPedId()
            local currentTime = GetGameTimer()
            
            -- Check for player activity
            if IsControlJustPressed(0, 1) or IsControlJustPressed(0, 2) or IsControlJustPressed(0, 32) or IsControlJustPressed(0, 33) or IsControlJustPressed(0, 34) or IsControlJustPressed(0, 35) then
                lastActivityTime = currentTime
                if isAFK then
                    isAFK = false
                    TriggerServerEvent('b2_afkSystem:playerReturn')
                end
            end

            -- Check if player is AFK
            if not isAFK and (currentTime - lastActivityTime) > (Config.IdleTimeThreshold * 1000) then
                isAFK = true
                TriggerServerEvent('b2_afkSystem:playerAFK')
            end
        end
    end
end)

RegisterNetEvent('b2_afkSystem:applyAFKState')
AddEventHandler('b2_afkSystem:applyAFKState', function(playerId)
    afkPlayers[playerId] = true
end)

RegisterNetEvent('b2_afkSystem:removeAFKState')
AddEventHandler('b2_afkSystem:removeAFKState', function(playerId)
    afkPlayers[playerId] = nil
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for playerId, _ in pairs(afkPlayers) do
            local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
            local coords = GetEntityCoords(playerPed)
            DrawText3D(coords.x, coords.y, coords.z + 1.0, "AFK")
        end
    end
end)
