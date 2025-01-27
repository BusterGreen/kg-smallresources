local KGCore = exports['kg-core']:GetCoreObject()
local isLoggedIn = LocalPlayer.state.isLoggedIn
local checkUser = true
local prevPos, time = nil, nil
local timeMinutes = {
    ['900'] = 'minutes',
    ['600'] = 'minutes',
    ['300'] = 'minutes',
    ['150'] = 'minutes',
    ['60'] = 'minutes',
    ['30'] = 'seconds',
    ['20'] = 'seconds',
    ['10'] = 'seconds',
}

local function updatePermissionLevel()
    KGCore.Functions.TriggerCallback('kg-afkkick:server:GetPermissions', function(userGroups)
        for k in pairs(userGroups) do
            if Config.AFK.ignoredGroups[k] then
                checkUser = false
                break
            end
            checkUser = true
        end
    end)
end

RegisterNetEvent('KGCore:Client:OnPlayerLoaded', function()
    updatePermissionLevel()
    isLoggedIn = true
end)

RegisterNetEvent('KGCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('KGCore:Client:OnPermissionUpdate', function()
    updatePermissionLevel()
end)

CreateThread(function()
    while true do
        Wait(10000)
        local ped = PlayerPedId()
        if isLoggedIn == true or Config.AFK.kickInCharMenu == true then
            if checkUser then
                local currPos = GetEntityCoords(ped, true)
                if prevPos then
                    if currPos == prevPos then
                        if time then
                            if time > 0 then
                                local _type = timeMinutes[tostring(time)]
                                if _type == 'minutes' then
                                    KGCore.Functions.Notify(Lang:t('afk.will_kick') .. math.ceil(time / 60) .. Lang:t('afk.time_minutes'), 'error', 10000)
                                elseif _type == 'seconds' then
                                    KGCore.Functions.Notify(Lang:t('afk.will_kick') .. time .. Lang:t('afk.time_seconds'), 'error', 10000)
                                end
                                time -= 10
                            else
                                TriggerServerEvent('KickForAFK')
                            end
                        else
                            time = Config.AFK.secondsUntilKick
                        end
                    else
                        time = Config.AFK.secondsUntilKick
                    end
                end
                prevPos = currPos
            end
        end
    end
end)