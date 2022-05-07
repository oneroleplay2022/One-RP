local weaponsRes = {}
local show = true

RegisterNetEvent('rn-crafting:UI', function()
    TriggerServerEvent("rn-crafting:server:openUI")
end)

local npcwe = {
    `g_m_m_cartelguards_02`
  }
    exports['cr-target']:AddTargetModel(npcwe, {
        options = {
        {
            event = "rn-crafting:UI", 
            icon = "fas fa-circle",
            label = "What's this?", 
        },
    },
    job = {"all"},
    distance = 2.5
  })

RegisterNetEvent("rn-crafting:client:openUI")
AddEventHandler("rn-crafting:client:openUI", function(items)
    weaponsRes = items 
    SetNuiFocus(true, true)
    for k,v in next,Config.Crafting do 
        if k == "categories" then
            SendNUIMessage({
                action = "show",
                info = v
            })
        end
    end
end)

RegisterNUICallback("choose",function(data,cb)
    for k,v in next,Config.Crafting do
        if k == data.data then
            if data.item == "undefined" or not data.item or HasItem(data.item) then 
                SendNUIMessage({
                    action = "next",
                    invItems = weaponsRes,
                    weapons = v,
                    resources = Config.craftResources,
                    requiredItem = data.item
                })
            else
                CRCore.Functions.Notify("You are missing: "..data.item, "error")
            end
        end
    end
end)

RegisterNUICallback("craft", function(data,cb)
    show = true
    local CraftCoords = Config.Coords.coords
    SetNuiFocus(false, false)
    local PlayerPed = PlayerPedId()
    TaskLookAtCoord(PlayerPed, CraftCoords.x, CraftCoords.y, CraftCoords.z, 3.0, 0, 0)
    TaskPedSlideToCoord(PlayerPed, CraftCoords.x, CraftCoords.y, CraftCoords.z, Config.Coords.heading, 1.0)
    Wait(2000)
    RonRequestAnimDict('mini@repair', function()
        TaskPlayAnim(PlayerPed, 'mini@repair', 'fixing_a_ped', 8.0, -8, -1, 49, 0, 0, 0, 0)
    end)
    CRCore.Functions.Progressbar("craft_weapon", "Crafting", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        flags = 16,
    }, {}, {}, function() -- Done
    end)
    TriggerServerEvent("rn-crafting:downgradeDongle",data.currentRequiredItem)
    TriggerServerEvent("rn-crafting:server:removeItems", data.weaponRes1,data.weaponRes2,data.weaponRes3,data.weaponRes4)
    TriggerServerEvent("rn-crafting:server:giveWeapon", data.currentWeapon)
    TriggerServerEvent("rn-crafting:removemoney", data.weaponPricee)
    Wait(13000)
    CRCore.Functions.Notify("Weapon successfully crafted.", "success")
    show = true
end)

function RonRequestAnimDict(animdict,func)
    if not DoesAnimDictExist(animdict) then return end
    RequestAnimDict(animdict)
    while not HasAnimDictLoaded(animdict) do
        Wait(50)
    end
    return func()
end

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
    show = true
end)

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 41, 11, 41, 68)
    ClearDrawOrigin()
end

RegisterNUICallback("chooseWeapon", function(data,cb)
    local res1 = false
    local res2 = false
    local res3 = false
    local res4 = false
    if data.resources.item1 <= weaponsRes.item1 then
        res1 = true
        SendNUIMessage({action = "have1"})
    else
        res1 = false
        SendNUIMessage({action = "donthave1"})
    end
    if data.resources.item2 <= weaponsRes.item2 then
        res2 = true
        SendNUIMessage({action = "have2"})
    else
        res2 = false
        SendNUIMessage({action = "donthave2"})
    end
    if data.resources.item3 <= weaponsRes.item3 then
        res3 = true
        SendNUIMessage({action = "have3"})
    else
        res3 = false
        SendNUIMessage({action = "donthave3"})
    end
    if data.resources.item4 <= weaponsRes.item4 then
        res4 = true
        SendNUIMessage({action = "have4"})
    else
        res4 = false
        SendNUIMessage({action = "donthave4"})
    end
    CRCore.Functions.TriggerCallback("rn-crafting:checkMoney",function(haveCash)
        if res1 and res2 and res3 and res4 and haveCash then
            SendNUIMessage({action = "addBtn"})
        else
            SendNUIMessage({action = "removeBtn"})
        end
    end, data.weaponPrice)
end)

function HasItem(item)
    if item == "" then return true end
    local retval = nil
    CRCore.Functions.TriggerCallback(Config.Core.name..":HasItem", function(data)
        retval = data
    end, item)

    while retval == nil do
        Wait(1)
    end

    return retval
end