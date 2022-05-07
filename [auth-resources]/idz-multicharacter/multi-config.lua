Config = {}
Config.emotekey = 32 -- refer keyCode https://keyevents.netlify.app/
Config.showMugshots = false
--[[ 
    Mugshots are experimental. They are not fully working, 
    and might show wrong in different resolutions.
]]

Config.sqlExecuter = "oxmysql"
Config.waveEmote = function(showPed)
    RequestAnimDict("random@mugging5")
    while (not HasAnimDictLoaded("random@mugging5")) do Wait(150) end 
    TaskPlayAnim(showPed, "random@mugging5", "001445_01_gangintimidation_1_female_idle_b", 3.0, 3.0, 850, 49, 0, false, false, false)

    Wait(1500)
end
Config.getCoreObject = function()
    return exports["cr-core"]:GetCoreObject()
end 

Config.defaultMaxCharacters = 1
-- License can be either steamid, license or discord identifier
Config.customMaxCharacters = {
    ["discord:244431276856180736"] = 2 -- twiztid
}

Config.scenesEnvironments =  {
    ["police"] = {
        function(entity)
            RequestModel(GetHashKey("police"))
            while not HasModelLoaded(GetHashKey("police")) do Wait(50) end
            showVeh = CreateVehicle(GetHashKey("police"), -1342.4995117188, -2913.6655273438, 13.551696777344, 218.90, false , false)
            SetEntityCoords(entity, -1340.2779541016, -2917.8989257812, 12.94482421875)
            SetEntityCoords(PlayerPedId(), -1354.2513427734, -2933.0043945312, 13.946972846985)
            SetEntityHeading(entity, 150.0)
            
            TaskStartScenarioInPlace(entity, "WORLD_HUMAN_GUARD_STAND", -1, true)
            return {showVeh}
        end    
    }, 
    ["unemployed"] = {
        function(entity)
            SetEntityCoords(entity, 215.38513183594, -1001.9901123047, 28.204002380371)
            SetEntityCoords(PlayerPedId(), 225.02500915527, -1005.4981079102, 29.289743423462)
            SetEntityHeading(entity, 260.0)
            Wait(100)
            RequestAnimDict("mp_player_inteat@burger")
            while not HasAnimDictLoaded("mp_player_inteat@burger") do Wait(150) end 
            TaskPlayAnim(entity, "mp_player_inteat@burger", "mp_player_int_eat_burger" ,3.0, 3.0, -1, 1, 0, false, false, false)        
            return nil
        end
    },
    ["ambulance"] = {
        function(entity)
            SetEntityCoords(entity, 291.36, -561.58, 43.26)
            SetEntityCoords(PlayerPedId(), 285.57, -558.96, 43.2)
            SetEntityHeading(entity, 67.7)
            RequestAnimDict("missarmenian2") 
            while not HasAnimDictLoaded("missarmenian2") do Wait(150) end
            RequestModel("a_m_m_afriamer_01")
            while not HasModelLoaded("a_m_m_afriamer_01") do Wait(150) end
            local ped = CreatePed(0, "a_m_m_afriamer_01", 291.28, -561.51, 43.26, 38.46, false, false)
            TaskPlayAnim(ped, "missarmenian2", "drunk_loop" ,3.0, 3.0, -1, 1, 0, false, false, false)        
            Wait(100)
            RequestAnimDict("mini@cpr@char_a@cpr_str")
            while not HasAnimDictLoaded("mini@cpr@char_a@cpr_str") do Wait(150) end 
            TaskPlayAnim(entity, "mini@cpr@char_a@cpr_str", "cpr_pumpchest" ,3.0, 3.0, -1, 1, 0, false, false, false)        
            return ped
        end
    },
    ["taxi"] = {
        function(entity)
            RequestAnimDict("amb@world_human_hang_out_street@female_arms_crossed@idle_a") 
            while not HasAnimDictLoaded("amb@world_human_hang_out_street@female_arms_crossed@idle_a") do Wait(150) end
            RequestModel(GetHashKey("taxi"))
            while not HasModelLoaded(GetHashKey("taxi")) do Wait(50) end
            showVeh = CreateVehicle(GetHashKey("taxi"), 919.91, -163.6, 74.41, 279.0, false , false)
            SetEntityCoords(entity, 919.46, -161.8, 74.83)
            SetEntityHeading(entity, 12.7)
            SetEntityCoords(PlayerPedId(), 900.9, -169.62, 74.08)
            
            TaskPlayAnim(entity, "amb@world_human_hang_out_street@female_arms_crossed@idle_a", "idle_a" ,3.0, 3.0, -1, 1, 0, false, false, false)        
            return showVeh
        end    

    },
    ["mechanic"] = {
        function(entity)
            SetEntityCoords(entity, 351.81, -1158.26, 29.29)
            SetEntityHeading(entity, 153.31)
            SetEntityCoords(PlayerPedId(), 342.0, -1160.58, 29.71)
            RequestModel(GetHashKey("bf400"))
            while not HasModelLoaded(GetHashKey("bf400")) do Wait(50) end
            showVeh = CreateVehicle(GetHashKey("bf400"), 351.2, -1159.04, 28.86, 239.42, false , false)
            while not DoesEntityExist(showVeh) do Wait(100) end 
            FreezeEntityPosition(showVeh, true)
            SetEntityCollision(showVeh, false, true)
            if GetVehicleDoorAngleRatio(showVeh, 4) > 0 then
                SetVehicleDoorShut(showVeh, 4, false)
            else
                SetVehicleDoorOpen(showVeh, 4, false, false)
            end
            RequestAnimDict("mini@repair") 
            while not HasAnimDictLoaded("mini@repair") do Wait(150) end
            TaskPlayAnim(entity, "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 1, 0, false, false, false)        

            return showVeh
        end
    }
}

Config.scenesEmotes = {
    ["police"] = {
        {
            ["animDictionary"] = "anim@amb@nightclub@peds@",
            ["animName"] = "rcmme_amanda1_stand_loop_cop",
            ["animTime"] = 850
        },
        {
            ["animDictionary"] = "amb@world_human_hang_out_street@male_c@idle_a",
            ["animName"] = "idle_b",
            ["animTime"] = 850
        }
    },
    ["unemployed"] = {
        {
            ["animDictionary"] = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@",
            ["animName"] = "high_center_down",
            ["animTime"] = 1500
        },
        {
            ["animDictionary"] = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@",
            ["animName"] = "high_center",
            ["animTime"] = 1500
        },
        {
            ["animDictionary"] = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@",
            ["animName"] = "high_center_up",
            ["animTime"] = 1500
        },
    }
}

Config.spawnFunction = function(source, citizenId)
    -- Server ONLY
    local cData = {
        citizenid = citizenId
    }
    TriggerEvent('QBCore:Server:OnPlayerLoaded', source)
    TriggerClientEvent('QBCore:Client:OnPlayerLoaded', source)
    TriggerClientEvent('apartments:client:setupSpawnUI', source, cData)
end
Config.charCreatedFunction = function(source, citizenId)
    -- Server ONLY
    local cData = {
        citizenid = citizenId
    }
    TriggerEvent('QBCore:Server:OnPlayerLoaded', source)
    TriggerClientEvent('QBCore:Client:OnPlayerLoaded', source)
    TriggerClientEvent('apartments:client:setupSpawnUI', source, cData)
end