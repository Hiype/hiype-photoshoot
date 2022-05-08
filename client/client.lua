
local QBCore = nil

if Conf.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
end

local player = PlayerPedId()
local UI_hidden = false
local inProgress = false
local inside = false
local screenW, screenH = GetScreenResolution()
currentCamera = Conf.DefaultCamera
isPlayerInvisible = Conf.PlayerInvisible
cams = {}

local entranceBox
local exitBox
local studioBox
local startBox

if Conf.UseQBCore then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        LocalPlayer.state:set('isLoggedIn', true, false)
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        LocalPlayer.state:set('isLoggedIn', false, false)
    end)
end

function tPrint(tbl, indent)
    indent = indent or 0
    for k, v in pairs(tbl) do
        local tblType = type(v)
        local formatting = ("%s ^3%s:^0"):format(string.rep("  ", indent), k)

        if tblType == "table" then
            print(formatting)
            tPrint(v, indent + 1)
        elseif tblType == 'boolean' then
            print(("%s^1 %s ^0"):format(formatting, v))
        elseif tblType == "function" then
            print(("%s^9 %s ^0"):format(formatting, v))
        elseif tblType == 'number' then
            print(("%s^5 %s ^0"):format(formatting, v))
        elseif tblType == 'string' then
            print(("%s ^2'%s' ^0"):format(formatting, v))
        else
            print(("%s^2 %s ^0"):format(formatting, v))
        end
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if Conf.UseQBCore then
            LocalPlayer.state:set('isLoggedIn', true, false)
        end

        local blipCoords = Conf.EntranceSpawnLocation
        if Conf.ShowBlip then
            local blip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
            SetBlipSprite(blip, 184)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Conf.BlipName)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

RegisterNetEvent('hiype-sst:takeScreenshot', function()
    takeScreenshot()
end)

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextOutline(1)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 235)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function Draw2DText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

CreateThread(function()
    while true do
        Wait(500)
        while inProgress do
            Wait(1)
            if isPlayerInvisible then 
                SetEntityLocallyInvisible(PlayerPedId())
            end
        end
    end
end)

local function hideRadar(player_ped_id)
    CreateThread(function()
        while inProgress do
            Wait(1)
            HideHudAndRadarThisFrame()
            print(isPlayerInvisible)
            SetPlayerInvisibleLocally(player_ped_id, isPlayerInvisible)
        end
    end)
end

local function tpPlayer(coords)
    local player_ped_id = PlayerPedId()
    SetPedCoordsKeepVehicle(player_ped_id, coords.x, coords.y, coords.z)
    SetEntityHeading(player_ped_id, coords.w)
    SetEntityHeading(GetVehiclePedIsIn(player_ped_id), coords.w)
end

local function tpPlayerIn(coords)
    DoScreenFadeOut(500)
    local entraceCameraLocation = Conf.EntraceCameraLocation
    local entrance_cam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", entraceCameraLocation.x, entraceCameraLocation.y, entraceCameraLocation.z, 0.0, 0.0, 0.0, 60.0, true, 2)
    PointCamAtEntity(exit_cam, GetVehiclePedIsIn(PlayerPedId()), 0.0, 0.0, 0.0, true)
    Wait(500)
    RenderScriptCams(true, false, 0, true, true)
    inside = true
    tpPlayer(coords)
    Wait(500)
    DoScreenFadeIn(1000)
    Wait(1000)
    RenderScriptCams(false, true, 2000, true, true)
end

local function tpPlayerOut(coords)
    DoScreenFadeOut(500)
    local exitCameraLocation = Conf.ExitCameraLocation
    local exit_cam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", exitCameraLocation.x, exitCameraLocation.y, exitCameraLocation.z, 0.0, 0.0, 0.0, 50.0, true, 2)
    PointCamAtEntity(exit_cam, PlayerPedId(), 0.0, 0.0, 0.0, true)
    Wait(500)
    RenderScriptCams(true, false, 0, true, true)
    inside = false
    tpPlayer(coords)
    Wait(500)
    DoScreenFadeIn(1000)
    Wait(1000)
    RenderScriptCams(false, true, 2000, true, true)
end

local function sendToDB(image_link, citizenid)
    TriggerServerEvent('hiype-sst:saveImage', image_link, citizenid)
end

function takeScreenshot()
    exports['screenshot-basic']:requestScreenshotUpload('https://api.imgur.com/3/upload', 'image', function(data)
        local response = json.decode(data)
        TriggerEvent('chat:addMessage', { args = { response.data.link } })
        local citizenid = nil
        if Conf.UseQBCore then citizenid = QBCore.Functions.GetPlayerData().citizenid else citizenid = PlayerId() end
        sendToDB(response.data.link, citizenid)
        inProgress = false
    end)
end

local function TakePictures()
    exports["qb-core"]:HideText()

    local player_ped_id = PlayerPedId()
    local veh = GetVehiclePedIsIn(player_ped_id, false)
    local veh_coords = GetEntityCoords(veh)
    local studioCameraLocation = Conf.StudioCameraLocation
    local studioLocation = Conf.StudioLocation
    local studioCameras = Conf.StudioCameras
    for i=1, #studioCameras, 1 do
        cams[i] = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", studioCameras[i].location.x, studioCameras[i].location.y, studioCameras[i].location.z, 0.0, 0.0, 0.0, studioCameras[i].FOV * 1.0, true, 2)
        if Conf.CamPointAtPlayer then
            PointCamAtEntity(cams[i], player_ped_id, 0.0, 0.0, 0.0, true)
        end
    end
    if Conf.HideHUD then
        if Conf.UseQBCore then
            ExecuteCommand("stop qb-hud")
        end
        hideRadar(player_ped_id)
    end
    if Conf.SetVehicleInPlace then
        SetEntityCoords(veh, studioLocation.x, studioLocation.y, studioLocation.z, 0, 0, 0, false)
        SetEntityHeading(veh, studioLocation.w)
    end
    SetCamActive(cams[currentCamera], true)
    RenderScriptCams(true, true, 1000, true, true)
    Wait(1000)
    openMenu()
    while not IsControlPressed(0, 202) and inProgress and startBox:isPointInside(GetEntityCoords(player_ped_id)) do
        Wait(10)
    end
    closeMenu()
    RenderScriptCams(false, true, 2000, true, true)
    Wait(2000)
    if Conf.HideHUD and Conf.UseQBCore then
        ExecuteCommand("start qb-hud")
    end
    inProgress = false
end

CreateThread(function()
    local entranceSpawnLocation = Conf.EntranceSpawnLocation
    local exitSpawnLocation = Conf.ExitSpawnLocation

    entranceBox = BoxZone:Create(Conf.EntranceBoxLocation, Conf.EntranceBoxLength, Conf.EntranceBoxWidth, {
        name="entrance_box",
        heading=Conf.EntranceBoxHeading,
        debugPoly=Conf.EntranceBoxDebugPoly,
        minZ=Conf.EntranceBoxMinZ,
        maxZ=Conf.EntranceBoxMaxZ
    })

    exitBox = BoxZone:Create(Conf.ExitBoxLocation, Conf.ExitBoxLength, Conf.ExitBoxWidth, {
        name="exit_box",
        heading=Conf.ExitBoxHeading,
        debugPoly=Conf.ExitBoxDebugPoly,
        minZ=Conf.ExitBoxMinZ,
        maxZ=Conf.ExitBoxMaxZ
    })

    studioBox = BoxZone:Create(Conf.StudioBoxLocation, Conf.StudioBoxLength, Conf.StudioBoxWidth, {
        name="studio_box",
        heading=Conf.StudioBoxHeading,
        debugPoly=Conf.StudioBoxDebugPoly,
        minZ=Conf.StudioBoxMinZ,
        maxZ=Conf.StudioBoxMaxZ
    })

    startBox = BoxZone:Create(Conf.StartBoxLocation, Conf.StartBoxLength, Conf.StartBoxWidth, {
        name="start_box",
        heading=Conf.StartBoxHeading,
        debugPoly=Conf.StartBoxDebugPoly,
        minZ=Conf.StartBoxMinZ,
        maxZ=Conf.StartBoxMaxZ
    })
    while true do
        while not LocalPlayer.state['isLoggedIn'] or inProgress do
            Wait(1000)
            print("WAiting")
        end

        if studioBox:isPointInside(GetEntityCoords(PlayerPedId())) then inside = true else inside = false end
        studioBox:destroy()

        while LocalPlayer.state['isLoggedIn'] and not inProgress do
            Wait(50)
            local pCoords = GetEntityCoords(PlayerPedId())
            if inside then
                if not inProgress and startBox:isPointInside(pCoords) then
                    exports["qb-core"]:DrawText(string.format("%s (E)", text_start_photoshoot()), 'left')
                    if IsControlPressed(0, 38) then
                        inProgress = true
                        TakePictures()
                        Wait(500)
                    end
                elseif not inProgress and exitBox:isPointInside(pCoords) then
                    exports["qb-core"]:DrawText(string.format("%s (E)", text_exit_studio()), 'left')
                    if IsControlPressed(0, 38) then
                        tpPlayerOut(entranceSpawnLocation)
                        Wait(500)
                    end
                else
                    exports["qb-core"]:HideText()
                end
            else
                if not inProgress and entranceBox:isPointInside(pCoords) then
                    exports["qb-core"]:DrawText(string.format("%s (E)", text_photostudio()), 'left')
                    if IsControlPressed(0, 38) then
                        tpPlayerIn(exitSpawnLocation)
                        Wait(500)
                    end
                else
                    exports["qb-core"]:HideText()
                end
            end
        end
    end
end)