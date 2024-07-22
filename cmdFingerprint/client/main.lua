CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Wait(0)
    end

    while ESX.GetPlayerData() == nil do
        Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    PlayerData.job = job
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
    PlayerData = response
end)

function showInfobar(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local isMenuOpen = false

CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        local pedCoords = GetEntityCoords(playerPed)

        for _, coords in ipairs(Config.LSPD_POSITIONS) do
            local distance = #(pedCoords - coords)

            if distance < 2.5 then
                if PlayerData and PlayerData.job and contains(Config.jobNames, PlayerData.job.name) then
                    DrawMarker(21, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.0, 1.3, 255, 0, 0, 250, false, false, nil, true, nil, nil, false)
                    if distance < 2.5 then
                        showInfobar(Config.Locale.help_notify)
                        if IsControlJustPressed(1, 38) and not isMenuOpen then
                            ESX.TriggerServerCallback("cmd:playerInit", function(plr)
                                local elements = {}
                                for k, v in pairs(plr) do
                                    if v then
                                        table.insert(elements, {
                                            identifier = v.identifier,
                                            label = v.name .. " [" .. v.id .. "]",
                                            value = k,
                                            bigID = v.id
                                        })
                                    end
                                end

                                if playerPed then
                                    isMenuOpen = true
                                    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "fingermenu", {
                                        title = Config.Locale.menu_title,
                                        align = "center",
                                        elements = {
                                            {label = Config.Locale.scan_finger, value = 'scanFinger'},
                                            {label = Config.Locale.create_document, value = 'createDocument'}
                                        }
                                    }, function(data, menu)
                                        if data.current.value == 'scanFinger' then
                                            ESX.UI.Menu.Open("default", GetCurrentResourceName(), "fingercheck", {
                                                title = Config.Locale.check_finger_title,
                                                align = "center",
                                                elements = elements
                                            }, function(data2, menu2)
                                                menu2.close()
                                                for _, v in pairs(elements) do
                                                    if data2.current.value == v.value then
                                                        Notify(string.format('Fingerabdruck wird für %s gecheckt ...', v.label))
                                                        TriggerSubEvent('cmd:scanFinger', v.identifier, currentKey)
                                                    end
                                                end
                                            end, function(data3, menu3)
                                                menu3.close()
                                            end)
                                        elseif data.current.value == 'createDocument' then
                                            ESX.UI.Menu.Open("default", GetCurrentResourceName(), "createDocument", {
                                                title = Config.Locale.create_doc_title,
                                                align = "center",
                                                elements = elements
                                            }, function(data4, menu4)
                                                menu4.close()
                                                for _, v in pairs(elements) do
                                                    if data4.current.value == v.value then
                                                        Notify(string.format('Dokument wird für %s erstellt ...', v.label))
                                                        TriggerSubEvent('cmd:createDocument', v.identifier, currentKey)
                                                    end
                                                end
                                            end, function(data5, menu5)
                                                menu5.close()
                                            end)
                                        end
                                    end, function(data, menu)
                                        isMenuOpen = false
                                        menu.close()
                                    end)

                                    CreateThread(function()
                                        while isMenuOpen do
                                            Wait(500)
                                            local newCoords = GetEntityCoords(PlayerPedId())
                                            local newDistance = #(newCoords - coords)
                                            if newDistance > 2.5 then
                                                ESX.UI.Menu.CloseAll()
                                                isMenuOpen = false
                                            end
                                        end
                                    end)
                                else
                                    if Config.Debug then
                                        print(Config.Locale.no_person_found)
                                    end
                                end
                            end)
                        end
                    end
                end
                Wait(0)
            end
        end
    end
end)

RegisterNetEvent('cmd:successPrint', function(state)
    if state then
        Notify(Config.Locale.finger_exists)
    else
        Notify(Config.Locale.no_finger_found)
    end
end)

RegisterNetEvent('cmd:successCreate', function(state)
    if state then
        Notify(Config.Locale.doc_created)
    else
        Notify(Config.Locale.already_has_finger)
    end
end)

function contains(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end
