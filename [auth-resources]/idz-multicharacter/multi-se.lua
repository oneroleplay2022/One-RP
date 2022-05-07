-- local CRCore = Config.getCoreObject()

CRCore = nil
TriggerEvent("CRCore:GetObject", function(obj) CRCore = obj end)

RegisterServerEvent("idz-multicharacter:server:requestCharactersMenu", function()
    local src = source
    local license = nil
    for k, v in pairs(GetPlayerIdentifiers(src)) do 
        if (v:match("license:")) then 
            license = v
        end
    end

    if (not license) then 
        print("[IDZ-MULTI] A player has no license.")
        TriggerClientEvent("idz-multicharacter:client:createCharUi", src)
    else 
        local playerCharacters = {}
        local exportsName = Config.sqlExecuter and Config.sqlExecuter or "ghmattimysql"
        exports[tostring(exportsName)]:execute("SELECT * FROM `players` WHERE `license`  = '" .. license .. "'", {}, function(result)
            SetPlayerRoutingBucket(src, src)
            if (result[1]) then
                for k, v in pairs(result) do
                    playerCharacters[#playerCharacters + 1] = {
                        ["charName"] = json.decode(v.charinfo).firstname .. " " .. json.decode(v.charinfo).lastname ,
                        ["charGender"] = json.decode(v.charinfo).gender,
                        ["charNationality"] = json.decode(v.charinfo).nationality,
                        ["charPhone"] = json.decode(v.charinfo).phone,
                        ["charJob"] = json.decode(v.job).name,
                        ["citizenId"] = v.citizenid
                    }
                end
                TriggerClientEvent("idz-multicharacter:client:showUi", src, playerCharacters)
            else
                TriggerClientEvent("idz-multicharacter:client:createCharUi", src)
            end
        end)    
    end
end)

local function loadHouseData()
    local HouseGarages = {}
    local Houses = {}
    local result = exports.oxmysql:executeSync('SELECT * FROM houselocations', {})
    if result[1] then
        for k, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = json.decode(v.garage) or {}
            Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = v.owned,
                price = v.price,
                locked = true,
                adress = v.label, 
                tier = v.tier,
                garage = garage,
                decorations = {},
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage
            }
        end
    end
	TriggerClientEvent("cr-garages:client:houseGarageConfig", -1, HouseGarages)
    TriggerClientEvent("cr-houses:client:setHouseConfig", -1, Houses)
end

RegisterServerEvent("idz-multicharacter:server:loginToChar", function(charId)
    local src = source
    if (CRCore.Player.Login(src, charId)) then
        SetPlayerRoutingBucket(src, 0)
        print("[idz-multi] A new character was loaded [" .. GetPlayerName(src) .. "]")
        CRCore.Commands.Refresh(src)
        loadHouseData()
        TriggerClientEvent("idz-multicharacter:client:deleteCams", src, charId, true)
        Config.spawnFunction(src, charId)
	else 
        print("[idz-multi] There was a problem logging a character in (check your core)")
    end
end)

RegisterServerEvent("idz-multicharacter:server:createChar", function(data)
    local src = source
    local Player = CRCore.Functions.GetPlayer(src)
    local newData = {}
    newData.charinfo = data
    if (CRCore.Player.Login(src, false, newData)) then
        SetPlayerRoutingBucket(src, 0)
        print("[idz-multi] A new character was created [" .. GetPlayerName(src) .. "]")
        CRCore.Commands.Refresh(src)
        TriggerClientEvent("idz-multicharacter:client:deleteCams", src)
        Config.charCreatedFunction(src, charId)
        TriggerEvent('cr-logs:server:createLog', 'characters-create', 'Created Character: Firstname: ' .. Player.PlayerData.charinfo.firstname.."/ Lastname: " ..Player.PlayerData.charinfo.lastname, "", src)
    else
        print("[idz-multi] There was a problem creating a character in (check your core)")
    end
end)

RegisterServerEvent("idz-multicharacter:server:deleteChar", function(citizenId)
    local src = source
    local Player = CRCore.Functions.GetPlayer(src)
    CRCore.Player.DeleteCharacter(src, citizenId)
    TriggerEvent('cr-logs:server:createLog', 'characters-delete', 'Deleted Character: Firstname: ' .. Player.PlayerData.charinfo.firstname.."/ Lastname: " ..Player.PlayerData.charinfo.lastname, "", src)
end)

CRCore.Functions.CreateCallback("idz-multicharacter:server:getSkin", function(source, cb, citizenId)
    local src = source
    requestClothing(citizenId, function(model, skinData)
        cb(model, skinData)    
    end)
end)

CRCore.Functions.CreateCallback("idz-multicharacter:server:checkCreation", function(source, cb, currentAmount)
    local src = source
    local found = false
    for k, v in pairs(GetPlayerIdentifiers(src)) do 
        for l, m in pairs(Config.customMaxCharacters) do
            if (v == l) then 
                if (currentAmount == m) then 
                    cb(false)
                else
                    cb(true)
                end
                found = true
                break
            end
        end
    end
    if (not found) then
        if (currentAmount == Config.defaultMaxCharacters) then 
            cb(false)
        else
            cb(true)
        end
    end
end)

CRCore.Functions.CreateCallback("idz-multicharacter:server:logOut", function(source, cb)
    local src = source 
    CRCore.Player.Logout(src)
    cb()
end)

RegisterServerEvent("CRCore:givenewCharItems")
AddEventHandler("CRCore:givenewCharItems",function(src)
    local src = source
    local Player = CRCore.Functions.GetPlayer(src)
    for k, v in pairs(CRCore.Shared.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "A1-A2-A | AM-B | C1-C-CE"
        end
        Player.Functions.AddItem(v.item, 1, false, info)
    end
end)