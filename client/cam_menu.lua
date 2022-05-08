local studioCameras = Conf.StudioCameras

local camera_slider_values = {}

for i=1, #studioCameras, 1 do
    table.insert( camera_slider_values, { label = i, value = i, string.format("Select camera %i", i) } )
end

local menu = MenuV:CreateMenu(" ", "Subtitle", "topleft", 255, 0, 0, "size-125", "none", "menuv", "test")

local take_picture_button = menu:AddButton({
    icon = '😃',
    label = text_take_picture(),
    value = "1",
    description = text_take_picture_description()
})
local camera_slider = menu:AddSlider({
    icon = '📷',
    label = text_change_camera(),
    value = 1,
    values = camera_slider_values,
    description = text_change_camera_description()
})
local fov_slider = menu:AddRange({
    icon = '↔️',
    label = text_fov(),
    min = Conf.MinFOV,
    max = Conf.MaxFOV,
    value = studioCameras[1].FOV,
    saveOnUpdate = true,
    description = text_fov_description()
})

local point_at_player_checkbox = menu:AddCheckbox({
    icon = '💡',
    label = text_point_at_player(),
    value = Conf.CamPointAtPlayer,
    description = text_point_at_player_description()
})

local invisible_player_checkbox = menu:AddCheckbox({
    icon = '🕶',
    label = text_player_invisible(),
    value = Conf.PlayerInvisible,
    description = text_player_invisible_description()
})

take_picture_button:On("select", function()
    closeMenu()
    takeScreenshot()
end)

camera_slider:On('change', function(item, value)
    currentCamera = value
    SetCamActive(cams[value], true)
end)

fov_slider:On('change', function(item, newValue, oldValue)
    SetCamFov(cams[currentCamera], newValue * 1.0)
end)

point_at_player_checkbox:On('change', function(item, newValue, oldValue)
    local ped_id = PlayerPedId()
    if newValue then
        PointCamAtEntity(cams[currentCamera], ped_id, 0.0, 0.0, 0.0, true)
    else
        PointCamAtEntity(cams[currentCamera], GetVehiclePedIsIn(ped_id, false), 0.0, 0.0, 0.0, true)
    end
end)

invisible_player_checkbox:On('change', function(item, newValue, oldValue)
    if newValue then
        -- SetEntityLocallyInvisible(PlayerPedId())
        isPlayerInvisible = true
    else
        -- SetPlayerInvisibleLocally(PlayerPedId(), false)
        isPlayerInvisible = false
    end
end)

function openMenu()
    MenuV:OpenMenu(menu)
end

function closeMenu()
    MenuV:CloseMenu(menu)
end