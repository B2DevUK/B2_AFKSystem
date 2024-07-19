local lastActivityTime = GetGameTimer()
local isAFK = false
local afkPlayers = {}
local isIgnoredGroup = false
local localPlayerAFK = false

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

RegisterNetEvent('b2_afkSystem:updateAFKList')
AddEventHandler('b2_afkSystem:updateAFKList', function(serverAFKList)
    afkPlayers = serverAFKList
end)

function CheckPlayerGroup()
    TriggerServerEvent('b2_afkSystem:checkPlayerGroup')
end

Citizen.CreateThread(function()
    CheckPlayerGroup()
    TriggerServerEvent('b2_afkSystem:requestAFKList')
    local lastCamRot = vector3(0, 0, 0)
    
    while true do
        Citizen.Wait(1000)

        if Config.AFKSystemEnabled and isIgnoredGroup ~= nil then
            local currentTime = GetGameTimer()
            local currentCamRot = GetGameplayCamRot(2)
            
            if IsControlPressed(0, 32) or IsControlPressed(0, 33) or 
               IsControlPressed(0, 34) or IsControlPressed(0, 35) or 
               IsPedWalking(PlayerPedId()) or IsPedRunning(PlayerPedId()) or 
               IsPedSprinting(PlayerPedId()) or currentCamRot ~= lastCamRot then
                
                lastActivityTime = currentTime
                lastCamRot = currentCamRot
                
                if isAFK then
                    isAFK = false
                    localPlayerAFK = false
                    if Config.InvincibilityEnabled then
                        SetEntityInvincible(PlayerPedId(), false)
                    end
                    TriggerServerEvent('b2_afkSystem:playerReturn')
                end
            end

            if not isAFK and (currentTime - lastActivityTime) > (Config.IdleTimeThreshold * 1000) then
                isAFK = true
                localPlayerAFK = true
                if Config.InvincibilityEnabled then
                    SetEntityInvincible(PlayerPedId(), true)
                end
                TriggerServerEvent('b2_afkSystem:playerAFK')
            end
        end
    end
end)

RegisterNetEvent('b2_afkSystem:setPlayerGroup')
AddEventHandler('b2_afkSystem:setPlayerGroup', function(ignored)
    isIgnoredGroup = ignored
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.AFKIconEnabled then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            -- Render AFK text for other players
            for playerId, afkData in pairs(afkPlayers) do
                if afkData.time then  -- Check if the player is actually AFK
                    local targetPed = GetPlayerPed(GetPlayerFromServerId(playerId))
                    if targetPed and targetPed ~= playerPed then
                        local targetCoords = GetEntityCoords(targetPed)
                        local distance = #(playerCoords - targetCoords)

                        if distance <= 5.0 then
                            DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.0, "AFK")
                        end
                    end
                end
            end

            -- Render AFK text for local player
            if localPlayerAFK then
                DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 1.0, "AFK")
            end
        end
    end
end)
