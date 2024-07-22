local currentKey;

CreateThread(function()
    repeat Wait(0) until NetworkIsSessionStarted();

    TriggerSubEvent('cmd-events:requestKey');
end);   

RegisterNetEvent('cmd-events:receiveKey', function(key)
    currentKey = key;   
end);      