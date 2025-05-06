RegisterNetEvent("hexguard:ForceSocialClubUpdate", function()
    ForceSocialClubUpdate()
end)

RegisterNetEvent("hexguard:ForceUpdate", function()
    ForceSocialClubUpdate()
    NetworkIsPlayerActive(PlayerId())
    NetworkIsPlayerConnected(PlayerId())
end)

RegisterNetEvent("hexguard:ShowPermaBanCard", function(cardData)
    ForceSocialClubUpdate()
end) 


RegisterNetEvent("checkalive", function ()
    TriggerServerEvent("addalive")
end)

RegisterNetEvent("hexguard:Client:getEncryptionKey", function(key)
end)
