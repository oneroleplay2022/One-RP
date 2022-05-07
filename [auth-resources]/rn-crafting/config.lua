Config = {}
Config.Core = {
    name = "CRCore",
    gettingCoreObject = "event", -- event/export
    gettingObjectName = "CRCore:GetObject", -- the event name / export name for getting the core object.
    core_resource_name = "cr-core" -- the core resource name.
}

Config.Coords = {coords = vector3(-458.17, -2266.14, 8.51), heading = 222.0}

Config.craftResources = {
    item1 = {
        name = "plastic", -- The name of the item.
        label = "Plastic", -- The label of the item.
        image = "cr-inventory/html/images/plastic.png" -- The direction of the image.
    },
    item2 = {
        name = "metalscrap",
        label = "Scrap Metal",
        image = "cr-inventory/html/images/metalscrap.png"
    },
    item3 = {
        name = "aluminum",
        label = "Aluminium",
        image = "cr-inventory/html/images/aluminum.png"
    },
    item4 = {
        name = "snspistol_stage_1",
        label = "Weapon Body",
        image = "cr-inventory/html/images/snspistol_stage_1.png"
    },
}

Config.Crafting = {
    categories = {
        {
            item = "pistol", -- The name of the weapon category. Example in this config we have this categories: default, pistol, smg, rifle.
            itemName = "", -- The name of the item that required to be in the inventory to open the category.
            itemlabel = "Pistols", -- The label of the item.
            itemImg = "cr-inventory/html/images/browning.png" -- The name of the image(In the inventory). Example: pistol50.png => pistol50.
        },
        {
            item = "melee",
            itemName = "",
            itemlabel = "Melee",
            itemImg = "cr-inventory/html/images/knife.png"
        },
        -- {
        --     item = "weaponattachments",
        --     itemName = "",
        --     itemlabel = "Attachments",
        --     itemImg = "cr-inventory/html/images/ssilencer.png"
        -- },
        -- {
        --     item = "ammo",
        --     itemName = "",
        --     itemlabel = "Ammo Magazines",
        --     itemImg = "cr-inventory/html/images/rifle_ammo.png"
        -- },
    },
    --------------------------------------------------------------------------------------------------------------
    pistol = {
        {
            weaponName = "weapon_pistol", -- The name of the item.
            weaponLabel = "Colt 1911", -- The label of the item.
            weaponResources = {
                item1 = 130, -- The amount that should be in the inventory to build the weapon. the items from here: **Config.craftResources**
                item2 = 130,
                item3 = 130,
                item4 = 1
            },
            price = 0 -- The price for crafting weapon.
        },
        {
            weaponName = "weapon_combatpistol",
            weaponLabel = "FN FNX-45",
            weaponResources = {
                item1 = 200,
                item2 = 200,
                item3 = 200,
                item4 = 1
            },
            price = 0    
        },
        {
            weaponName = "weapon_browning",
            weaponLabel = "Browning Hi-Power",
            weaponResources = {
                item1 = 270,
                item2 =  270,
                item3 =  270,
                item4 =  1
            },
            price = 0
        }, 
    },
    smg = {
        {
            weaponName = "weapon_microsmg",
            weaponLabel = "Micro SMG",
            weaponResources = {
                item1 = 650,
                item2 = 650,
                item3 = 650,
                item4 = 1
            },
            price = 0
        },
        { 
            weaponName = "weapon_minismg",
            weaponLabel = "Skorpion",
            weaponResources = {
                item1 = 670,
                item2 = 670,
                item3 = 670,
                item4 = 1
            },
            price = 0
        },
        { 
            weaponName = "weapon_machinepistol",
            weaponLabel = "Tec 9",
            weaponResources = {
                item1 = 500,
                item2 = 500,
                item3 = 500,
                item4 = 1
            },
            price = 0
        }
    },
    rifle = {
        {
            weaponName = "weapon_compactrifle",
            weaponLabel = "Compact Rifle",
            weaponResources = {
                item1 = 700,
                item2 = 700,
                item3 = 700,
                item4 = 1
            },
            price = 0
        }
    },
    melee = {
        {
            weaponName = "weapon_knife",
            weaponLabel = "Knife",
            weaponResources = {
                item1 = 5,
                item2 = 5,
                item3 = 15,
                item4 = 0
            },
            price = 0
        },
        {
            weaponName = "weapon_switchblade",
            weaponLabel = "Shank",
            weaponResources = {
                item1 = 5,
                item2 = 5,
                item3 = 15,
                item4 = 0
            },
            price = 0
        },
        {
            weaponName = "weapon_machete",
            weaponLabel = "Machete",
            weaponResources = {
                item1 = 5,
                item2 = 5,
                item3 = 30,
                item4 = 0
            },
            price = 0
        }
    },
    weaponattachments = {
        {
            weaponName = "pistol_suppressor",
            weaponLabel = "Pistol Suppressor",
            weaponResources = {
                item1 = 10,
                item2 = 10,
                item3 = 10,
                item4 = 0
            },
            price = 0
        },
        {
            weaponName = "smg_suppressor",
            weaponLabel = "SMG Suppressor",
            weaponResources = {
                item1 = 10,
                item2 = 10,
                item3 = 10,
                item4 = 0
            },
            price = 0
        },
        {
            weaponName = "smg_extendedclip",
            weaponLabel = "SMG Extended",
            weaponResources = {
                item1 = 5,
                item2 = 5,
                item3 = 5,
                item4 = 0
            },
            price = 0
        },
        {
            weaponName = "rifle_extendedclip",
            weaponLabel = "Rifle Extended",
            weaponResources = {
                item1 = 5,
                item2 = 5,
                item3 = 5,
                item4 = 0
            },
            price = 0
        },
        {
            weaponName = "pistol_extendedclip",
            weaponLabel = "Pistol Extended",
            weaponResources = {
                item1 = 5,
                item2 = 5,
                item3 = 5,
                item4 = 0
            },
            price = 0
        }
    },
    ammo = {
        {
            weaponName = "smg_ammo",
            weaponLabel = "SMG Ammo x50",
            weaponResources = {
                item1 = 10,
                item2 = 10,
                item3 = 10,
                item4 = 0
            },
            price = 0
        },
        {
            weaponName = "rifle_ammo",
            weaponLabel = "Rifle Ammo x50",
            weaponResources = {
                item1 = 15,
                item2 = 15,
                item3 = 15,
                item4 = 0
            },
            price = 0
        }
    },
}
-- Server:
Config.GetPlayerMoney = function(playerId,Core)
    --[[
      This function is used for getting the player's money.
      Parameters:
        @playerId: The player server id/source.
        @Core: The current core object.
      
      Example for Qbus implementation is down below.
      ]]
      if type(playerId) == "number" then
          local player = Core.Functions.GetPlayer(playerId)
          if player then
              return player.PlayerData.money["cash"]
          end
      end
  end
  
Config.RemovePlayerMoney = function(playerId, amount, Core)
--[[
    This function is used for paying for the vehicle/testdrive.
    Parameters:
    @playerId: The player server id/source.
    @amount: the amount to pay.
    @Core: The current core object.
    
    Example for Qbus implementation is down below.
    ]]
    local player = Core.Functions.GetPlayer(playerId)
    if player then
        player.Functions.RemoveMoney("cash", amount)
    end
end