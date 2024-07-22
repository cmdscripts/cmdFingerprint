local key = math.random(10000, 1000000) * 1.0007;

RegisterNetEvent('cmd-events:requestKey', function()
    TriggerClientEvent('cmd-events:receiveKey', key);
end);