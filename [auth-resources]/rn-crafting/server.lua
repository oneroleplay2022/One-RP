-- Core = nil

-- if Config.Core.gettingCoreObject == "export" then
--   Core = exports[Config.Core.core_resource_name][Config.Core.gettingObjectName]()
-- else
--   TriggerEvent(Config.Core.gettingObjectName, function(obj) Core = obj end)
-- end

local dongles = {
  ["yellow_dongle"] = 10,
  ["blue_dongle"] = 3,
  ["green_dongle"] = 6
}


RegisterNetEvent("rn-crafting:server:openUI")
AddEventHandler("rn-crafting:server:openUI", function()
  local src = tonumber(source)
  local Player = CRCore.Functions.GetPlayer(src)
  local item = {
    item1 = Player.Functions.GetItemByName(Config.craftResources["item1"].name) and Player.Functions.GetItemByName(Config.craftResources["item1"].name).amount or 0,
    item2 = Player.Functions.GetItemByName(Config.craftResources["item2"].name) and Player.Functions.GetItemByName(Config.craftResources["item2"].name).amount or 0,
    item3 = Player.Functions.GetItemByName(Config.craftResources["item3"].name) and Player.Functions.GetItemByName(Config.craftResources["item3"].name).amount or 0,
    item4 = Player.Functions.GetItemByName(Config.craftResources["item4"].name) and Player.Functions.GetItemByName(Config.craftResources["item4"].name).amount or 0
  }
  TriggerClientEvent("rn-crafting:client:openUI", src, item)
end)

RegisterNetEvent("rn-crafting:server:giveWeapon")
AddEventHandler("rn-crafting:server:giveWeapon", function(weapon)
  local src = tonumber(source)
  local playerName = GetPlayerName(src)
  local Player = CRCore.Functions.GetPlayer(src)
  Player.Functions.AddItem(weapon, 1)
  TriggerEvent('cr-logs:server:createLog', 'crafting', 'The weapon:', "**"..playerName.."** ".."built this weapon: **"..weapon, src)
end)

RegisterNetEvent("rn-crafting:server:removeItems")
AddEventHandler("rn-crafting:server:removeItems", function(amount1,amount2,amount3,amount4)
  local src = tonumber(source)
  local Player = CRCore.Functions.GetPlayer(src)
  Player.Functions.RemoveItem(Config.craftResources["item1"].name, amount1)
  Player.Functions.RemoveItem(Config.craftResources["item2"].name, amount2)
  Player.Functions.RemoveItem(Config.craftResources["item3"].name, amount3)
  Player.Functions.RemoveItem(Config.craftResources["item4"].name, amount4)
end)

CRCore.Functions.CreateCallback("rn-crafting:checkMoney", function(src,cb,amount)
  cb(Config.GetPlayerMoney(src,CRCore) >= amount)      
end)

RegisterNetEvent("rn-crafting:removemoney",function(money)
  local src = source
  Config.RemovePlayerMoney(src,money,CRCore)
end)

RegisterNetEvent("rn-crafting:downgradeDongle",function(itemName)
  if not itemName and not dongles[itemName] then return end
  local src = source
  local char = CRCore.Functions.GetPlayer(src)
  local item = char.Functions.GetItemByName(itemName)

  if char.PlayerData.items[item.slot] ~= nil then
    if not char.PlayerData.items[item.slot].info.uses then
      char.PlayerData.items[item.slot].info.uses = dongles[itemName]
    end
    char.PlayerData.items[item.slot].info.uses = char.PlayerData.items[item.slot].info.uses - 1
    char.Functions.SetInventory(char.PlayerData.items)
  end
  if char.PlayerData.items[item.slot].info.uses <= 0 then
    char.Functions.RemoveItem(itemName,1,item.slot)
    TriggerClientEvent('inventory:client:ItemBox', src, CRCore.Shared.Items[itemName], "remove")
  end
end)