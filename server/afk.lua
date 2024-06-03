local KGCore = exports['kg-core']:GetCoreObject()

RegisterNetEvent('KickForAFK', function()
	DropPlayer(source, Lang:t("afk.kick_message"))
end)

KGCore.Functions.CreateCallback('kg-afkkick:server:GetPermissions', function(source, cb)
    cb(KGCore.Functions.GetPermission(source))
end)
