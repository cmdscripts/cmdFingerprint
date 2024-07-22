ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback("cmd:playerInit", function(source, cb)
    local plr = {}

    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        table.insert(plr, {
            identifier = xPlayer.identifier,
            name = xPlayer.getName(),
            id = xPlayer.source
        })
    end
    cb(plr)
end)

RegisterNetEvent('cmd:scanFinger', function(identifier, clientKey)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if clientKey == key then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = ?', {
            identifier
        }, function(result)
            if result[1] then
                if result[1].fingerAbdruck then
                    TriggerClientEvent('cmd:successPrint', xPlayer.source, true)
                else
                    TriggerClientEvent('cmd:successPrint', xPlayer.source, false)
                end
            else
                print(GetCurrentResourceName() .. ' <ERROR> - Identifier does not exist, please check the Database.')
            end
        end)
    else
        xPlayer.kick('check Key: T1')
    end
end)

RegisterNetEvent('cmd:createDocument', function(identifier, clientKey)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if clientKey == key then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = ?', {
            identifier
        }, function(result)
            if result[1] then
                if result[1].fingerAbdruck then
                    TriggerClientEvent('cmd:successCreate', xPlayer.source, false)
                    return
                end

                MySQL.Async.execute('UPDATE users SET fingerAbdruck = true WHERE identifier = ?', {
                    identifier
                }, function()
                    TriggerClientEvent('cmd:successCreate', xPlayer.source, true)
                end)
            else
                print(GetCurrentResourceName() .. ' <ERROR> - Identifier does not exist, please check the Database.')
            end
        end)
    else
        xPlayer.kick('check key: T2')
    end
end)