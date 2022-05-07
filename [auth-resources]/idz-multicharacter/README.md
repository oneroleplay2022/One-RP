Thank you for purchasing idz-multicharacter. 
Here are a few things you should probably change-

Starting off, You shouldn't have both `multi-clothes-charactercurrent.lua` and 
`multi-clothes-playerskins.lua` running together.

Check your database tables, if it contains a `playerskins` table, do the following:
    Go over to idz-multicharacter/fxmanifest.lua
    Remove the `multi-clothes-charactercurrent.lua` line from :
    shared_scripts {
        'multi-config.lua',
        'multi-clothes-playerskins.lua',
        'multi-clothes-charactercurrent.lua'
    }

    # Should look like this:
    shared_scripts {
        'multi-config.lua',
        'multi-clothes-playerskins.lua',
    }


If it contains a `character_current` table, do the following:
    Go over to idz-multicharacter/fxmanifest.lua
    Remove the `multi-clothes-playerskins.lua` line from :
    shared_scripts {
        'multi-config.lua',
        'multi-clothes-playerskins.lua',
        'multi-clothes-charactercurrent.lua'
    }

    # Should look like this:
    shared_scripts {
        'multi-config.lua',
        'multi-clothes-charactercurrent.lua'
    }



For any other clothing table, you should contact your developer and mainpulate the existing ones to fit your server. (We will not give support on this matter).

Another common issue you might encounter is when getting QBCore as nil.
This is either caused by 2 problems:
    1. You don't have a `GetCoreObject` export on your core, this can be easily fixed:
        local QBCore = nil 
        TriggerEvent("QBCore:GetObject", function(core) QBCore = core end)
        return QBCore
    2. Your core name is not qbcore, in this case:
        return exports["your-core-name-here"]:GetCoreObject()
(Change above in Config.getCoreObject function at idz-multicharacter/multi-config.lua)


For any help during the setup, contact our support via discord-
https://discord.idz-scripts.shop

Sincerely yours,
Ido from IDZ Scripts.