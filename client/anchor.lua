---@type boolean, CKeybind
local shown, keybind = false, nil

lib.onCache('vehicle', function(vehicle)
    if not vehicle then
        if shown then
            HideUI()
            shown = false
        end

        return
    end
    
    if IsPedInAnyBoat(cache.ped) and GetPedInVehicleSeat(cache.vehicle, -1) == GetPlayerPed(-1) then
        local localeName = IsBoatAnchoredAndFrozen(vehicle) and 'raise_anchor' or 'anchor_boat'
        ShowUI(locale(localeName, keybind.currentKey), 'anchor')
        shown = true
    end
end)

keybind = lib.addKeybind({
    name = 'anchor_toggle',
    description = 'Toggles the anchor on your boat.',
    defaultKey = 'G',
    defaultMapper = 'keyboard',
    onReleased = function()
        if not IsPedInAnyBoat(cache.ped) or GetPedInVehicleSeat(cache.vehicle, -1) ~= GetPlayerPed(-1) then return end
        if #GetEntityVelocity(cache.vehicle) > 3.0 and IsPedInAnyBoat(cache.ped) and GetPedInVehicleSeat(cache.vehicle, -1) == GetPlayerPed(-1) then
			ShowNotification(locale('msg_anchor_to_fast'), 'error')
			return end

        if IsBoatAnchoredAndFrozen(cache.vehicle) then
            SetBoatAnchor(cache.vehicle, false)
            ShowUI(locale('anchor_boat', keybind.currentKey), 'anchor')
			ShowNotification(locale('msg_anchor_raised'), 'success')
        else
            SetBoatFrozenWhenAnchored(cache.vehicle, true)
            SetBoatAnchor(cache.vehicle, true)
            ShowUI(locale('raise_anchor', keybind.currentKey), 'anchor')
			ShowNotification(locale('msg_anchor_lowered'), 'success')
        end
    end
})
