playEmote = function(animation, ped)
	RequestAnimDict(animation.animDictionary)
    while (not HasAnimDictLoaded(animation.animDictionary)) do Wait(50) end 
    TaskPlayAnim(ped, animation.animDictionary, animation.animName, 3.0, 3.0, animation.animTime, 49, 0, false, false, false)
end

