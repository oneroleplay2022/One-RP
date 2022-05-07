-- local CRCore = Config.getCoreObject()

CRCore = nil

Citizen.CreateThread(function()
    while CRCore == nil do
        TriggerEvent('CRCore:GetObject', function(obj) CRCore = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() do
        Citizen.Wait(0)
    end
    TriggerEvent("idz-multicharacter:client:shutdownLoadingscreen")
    TriggerServerEvent("idz-multicharacter:server:requestCharactersMenu")
end)

RegisterNetEvent("idz-multicharacter:client:shutdownLoadingscreen", function()
    SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    Citizen.Wait(1000)
    local interior = GetInteriorAtCoords(-814.89, 181.95, 57.95)
    LoadInterior(interior)
    while not IsInteriorReady(interior) do
        Citizen.Wait(1000)
    end
    Citizen.Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end)

local showPed, showCam, sceneObjects = nil, nil, nil
local showingUi = false
RegisterNetEvent("idz-multicharacter:client:showUi", function(playerChars)

    DoScreenFadeIn(50)
    showCam = CreateCam('DEFAULT_SCRIPTED_CAMERA')
    SetNuiFocus(true, true)
    SendNUIMessage({
        playerCard = true,
        playerChars = json.encode(playerChars),
        emoteKey = Config.emotekey 
    })
    showingUi = true
    SetPlayerInvincible(PlayerPedId(), true)
end)

RegisterNetEvent("idz-multicharacter:client:deleteCams", function(charId, fadeIn)
    RenderScriptCams(false, false, 0, true, true)
    DestroyCam(showCam, false)
    showCam = nil
    SetEntityAsMissionEntity(showPed, true, true)
    DeleteEntity(showPed)
    showPed = nil
    if (charId) then
        CRCore.Functions.TriggerCallback('idz-multicharacter:server:getSkin', function(model, skinData)
            model = model ~= nil and tonumber(model) or 1885233650
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end
            SetPlayerModel(PlayerId(), model)
            SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
            loadClothing(PlayerPedId(), skinData)
        end, charId)
    end
    
    if (fadeIn) then 
        DoScreenFadeIn(50)
    end
    FreezeEntityPosition(PlayerPedId(), false)
end)

RegisterNetEvent("idz-multicharacter:client:createCharUi", function()
    DoScreenFadeIn(50)
    SetEntityCoords(PlayerPedId(), -1037.78, -2737.95, 20.16)
    RequestModel(`mp_m_freemode_01`)
	while (not HasModelLoaded(`mp_m_freemode_01`)) do Wait(50) end

    SetEntityAsMissionEntity(showPed, true, true)
    showPed = CreatePed(3, "mp_m_freemode_01", -1037.78, -2737.95, 19.16, 331.02, false, false)
    SetEntityCoords(PlayerPedId(), -1037.78, -2737.95, 20.16)
    showCam = CreateCam('DEFAULT_SCRIPTED_CAMERA')
    local coordsCam = GetOffsetFromEntityInWorldCoords(showPed, 0.0, 1.5, 0.65)
    local coordsPly = GetEntityCoords(showPed)
    SetCamCoord(showCam, coordsCam)
    PointCamAtCoord(showCam, coordsPly.x, coordsPly.y, coordsPly.z + 0.65)
    SetCamActive(showCam, true)
    RenderScriptCams(true, false, 0, true, true)
    SetNuiFocus(true, true)
    SetPlayerInvincible(PlayerPedId(), true)
    SendNUIMessage({
        newCharMenu = true,
    })
end)

RegisterNUICallback("joinChar", function(data)
    showingUi = false
    ClearPedTasksImmediately(showPed)
    Config.waveEmote(showPed)
    DoScreenFadeOut(100)
    Wait(1000)

    local charId = data.charId
    SetNuiFocus(false, false)
    TriggerServerEvent("idz-multicharacter:server:loginToChar", charId)
    SetPlayerInvincible(PlayerPedId(), false)

    if (type(sceneObjects) == "number") then 
        if (DoesEntityExist(sceneObjects)) then 
            SetEntityAsMissionEntity(sceneObjects, true, true)
            DeleteEntity(sceneObjects)
        end
    elseif (type(sceneObjects) == "table") then 
        for k, v in pairs(sceneObjects) do 
            if (DoesEntityExist(v)) then 
                SetEntityAsMissionEntity(v, true, true)
                DeleteEntity(v)
            end
        end
    end
end)

RegisterNUICallback("deleteChar", function(data)
    showingUi = false
    local citizenId = data.charId
    TriggerServerEvent("idz-multicharacter:server:deleteChar", citizenId)
    Wait(1000)
    SetEntityAsMissionEntity(showPed, true, true)
    DeleteEntity(showPed)
    TriggerServerEvent("idz-multicharacter:server:requestCharactersMenu")
end)

RegisterNUICallback("emote", function(data)
    local charJob = data.charJob
    if (Config.scenesEmotes[charJob]) then 
        local random = math.random(1, #Config.scenesEmotes[charJob])
        playEmote(Config.scenesEmotes[charJob][random], showPed)
    else
        local random = math.random(1, #Config.scenesEmotes["unemployed"])
        playEmote(Config.scenesEmotes["unemployed"][random], showPed)
    end
end)

RegisterNUICallback("notifyError", function(notifyText)
    CRCore.Functions.Notify(notifyText, "error", 2500)
end)

RegisterNUICallback("pedChange", function(data)
    local cardData = data.cardData
    local charJob = cardData.charJob
    CRCore.Functions.TriggerCallback('idz-multicharacter:server:getSkin', function(model, skinData)
        model = model ~= nil and tonumber(model) or 1885233650
        local currentCoords, currentHeading = GetEntityCoords(showPed), GetEntityHeading(showPed)
        SetEntityAsMissionEntity(showPed, true, true)
        DeleteEntity(showPed)
        showPed = nil

        RequestModel(model)
        while (not HasModelLoaded(model)) do Wait(50) end

        showPed = CreatePed(0, model, currentCoords.x, currentCoords.y, currentCoords.z - 1, false, false)
        PlaceObjectOnGroundProperly(showPed)
        SetEntityHeading(showPed, currentHeading)

        loadClothing(showPed, skinData)


        DoScreenFadeOut(100)
        SendNUIMessage({
            loader = true
        })
        if (type(sceneObjects) == "number") then 
            if (DoesEntityExist(sceneObjects)) then 
                SetEntityAsMissionEntity(sceneObjects, true, true)
                DeleteEntity(sceneObjects)
            end
        elseif (type(sceneObjects) == "table") then 
            for k, v in pairs(sceneObjects) do 
                if (DoesEntityExist(v)) then 
                    SetEntityAsMissionEntity(v, true, true)
                    DeleteEntity(v)
                end
            end
        end

        if (Config.scenesEnvironments[charJob]) then
            local random = math.random(1, #Config.scenesEnvironments[charJob])
            sceneObjects = Config.scenesEnvironments[charJob][random](showPed)
        else
            local random = math.random(1, #Config.scenesEnvironments["unemployed"])
            sceneObjects = Config.scenesEnvironments["unemployed"][random](showPed)
        end
        Wait(1000)

        local coordsPly = GetEntityCoords(showPed)
        local coordsCam = GetOffsetFromEntityInWorldCoords(showPed, 0.0, 2.5, 0.65)
        SetCamCoord(showCam, coordsCam)
        PointCamAtCoord(showCam, coordsPly.x, coordsPly.y, coordsPly.z)
        SetCamActive(showCam, true)
        RenderScriptCams(true, false, 0, true, true)
        Wait(500)
        DoScreenFadeIn()
        if (not Config.showMugshots) then
            SendNUIMessage({
                loader = false,
                mugshot = true
            })
        else 
            SendNUIMessage({
                loader = false,
                mugshot = false
            })
        end

        if (Config.showMugshots) then
            getMugshot(showPed)
        end


    end, data.charId)
end)

RegisterNUICallback("checkCreation", function(data, cb)
    local currentAmount = data.currentAmount
    CRCore.Functions.TriggerCallback("idz-multicharacter:server:checkCreation", function(canCreate)
        cb({
            canCreate = canCreate
        })
        if (not canCreate) then 
            CRCore.Functions.Notify("You have reached the maximum amount of characters.", "error", 2500)
        end
    end, currentAmount)
end)

RegisterNUICallback("createChar", function(data)
    showingUi = false
    SetNuiFocus(false, false)
    RenderScriptCams(false, false, 0, true, true)
    DestroyCam(showCam, false)
    showCam = nil
    SetEntityAsMissionEntity(showPed, true, true)
    DeleteEntity(showPed)
    showPed = nil
    local player = PlayerId()
    if (tonumber(data.gender) == 0) then
        local model = GetHashKey('mp_m_freemode_01')
        RequestModel(model)
        while (not HasModelLoaded(model)) do Wait(100) end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
        SetModelAsNoLongerNeeded(model)
    else
        local model = GetHashKey('mp_f_freemode_01')
        RequestModel(model)
        while (not HasModelLoaded(model)) do Wait(100) end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
        SetModelAsNoLongerNeeded(model)
    end

    if (type(sceneObjects) == "number") then 
        if (DoesEntityExist(sceneObjects)) then 
            SetEntityAsMissionEntity(sceneObjects, true, true)
            DeleteEntity(sceneObjects)
        end
    elseif (type(sceneObjects) == "table") then 
        for k, v in pairs(sceneObjects) do 
            if (DoesEntityExist(v)) then 
                SetEntityAsMissionEntity(v, true, true)
                DeleteEntity(v)
            end
        end
    end

    TriggerServerEvent("idz-multicharacter:server:createChar", data)
    SetPlayerInvincible(PlayerPedId(), false)
end)

RegisterNetEvent("idz-multicharacter:client:visitAirport", function()
    SetEntityCoords(PlayerPedId(), -1034.8516845703, -2732.2976074219, 20.164518356323)
    SetEntityHeading(PlayerPedId(), 328.55)
    Wait(2500)
    TriggerEvent("qb-clothes:client:CreateFirstCharacter")
end)

getMugshot = function(ped)
    local last = ""
    local xPosition, yPosition = 0.559, 0.835
    local width, height = 0.040, 0.09


	local screenWidth, screenHeight = GetActiveScreenResolution()
    local handle = RegisterPedheadshot(ped)


    while (not IsPedheadshotReady(handle) and showingUi) do
        Wait(0)
        if (last ~= "unready") then 
            last = "unready"
            SendNUIMessage({
                failedMugshot = true
            })
        end
    end

    local headshot = GetPedheadshotTxdString(handle)
    while (showingUi) do
        Wait(0)
        DrawSprite(headshot, headshot, xPosition, yPosition, width, height, 0.0, 255, 255, 255, 1000)
        if (last == "unready") then 
            last = "ready"
            SendNUIMessage({    
                successMugshot = true
            })
        end
    end
    UnregisterPedheadshot(handle)
end