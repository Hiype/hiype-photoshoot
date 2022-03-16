local QBCore = exports['qb-core']:GetCoreObject()
local player = PlayerPedId()
local UI_hidden = false
local inProgress = false
local inside = false
local screenW, screenH = GetScreenResolution()
local currentCamera = Config.defaultCamera

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    LocalPlayer.state:set('isLoggedIn', true, false)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    LocalPlayer.state:set('isLoggedIn', false, false)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        LocalPlayer.state:set('isLoggedIn', true, false)

        local blipCoords = Config.entranceLocation
        if Config.showBlip then
            local blip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
            SetBlipSprite(blip, 744)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.blipName)
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

local function hideRadar(player_ped_id)
    CreateThread(function()
        while inProgress do
            Wait(1)
            HideHudAndRadarThisFrame()
            if Config.playerInvisible then SetEntityLocallyInvisible(player_ped_id) end
        end
    end)
end

local function tpPlayer(coords)
    local player_ped_id = PlayerPedId()
    SetPedCoordsKeepVehicle(player_ped_id, coords.x, coords.y, coords.z)
    SetEntityHeading(GetVehiclePedIsIn(player_ped_id), coords.w)
end

local function tpPlayerIn(coords)
    DoScreenFadeOut(500)
    local entraceCameraLocation = Config.entraceCameraLocation
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
    local exitCameraLocation = Config.exitCameraLocation
    local exit_cam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", exitCameraLocation.x, exitCameraLocation.y, exitCameraLocation.z, 0.0, 0.0, 0.0, 50.0, true, 2)
    PointCamAtEntity(exit_cam, GetVehiclePedIsIn(PlayerPedId()), 0.0, 0.0, 0.0, true)
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

local function takeScreenshot()
    exports['screenshot-basic']:requestScreenshotUpload('https://api.imgur.com/3/upload', 'image', function(data)
        local response = json.decode(data)
        TriggerEvent('chat:addMessage', { args = { response.data.link } })
        sendToDB(response.data.link, QBCore.Functions.GetPlayerData().citizenid)
    end)
end

local function TakePictures()
    local player_ped_id = PlayerPedId()
    local veh = GetVehiclePedIsIn(player_ped_id, false)
    local veh_coords = GetEntityCoords(veh)
    local studioCameraLocation = Config.studioCameraLocation
    local studioLocation = Config.studioLocation
    local studioCameras = Config.studioCameras
    local cams = {}
    for i=1, #Config.studioCameras, 1 do
        cams[i] = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", studioCameras[i].location.x, studioCameras[i].location.y, studioCameras[i].location.z, 0.0, 0.0, 0.0, studioCameras[i].FOV * 1.0, true, 2)
        if Config.camPointAtPlayer then
            PointCamAtEntity(cams[i], player_ped_id, 0.0, 0.0, 0.0, true)
        else
            PointCamAtEntity(cams[i], veh, 0.0, 0.0, 0.0, true)
        end
    end
    if Config.hideHUD then
        ExecuteCommand("stop qb-hud")
        hideRadar(player_ped_id)
    end
    if Config.setVehicleInPlace then
        SetEntityCoords(veh, studioLocation.x, studioLocation.y, studioLocation.z, 0, 0, 0, false)
        SetEntityHeading(veh, studioLocation.w)
    end
    SetCamActive(cams[currentCamera], true)
    RenderScriptCams(true, true, 1000, true, true)
    Wait(1000)
    while not IsControlPressed(0, 38) do
        local pCoords = GetEntityCoords(player_ped_id)
        if IsControlPressed(0, 246) then
            if currentCamera + 1 > #studioCameras then
                currentCamera = 1
                SetCamActive(cams[currentCamera], true)
                Wait(500)
            else
                currentCamera = currentCamera + 1
                SetCamActive(cams[currentCamera], true)
                Wait(500)
            end
        end
        if Vdist2(pCoords.x, pCoords.y, pCoords.z, studioLocation.x, studioLocation.y, studioLocation.z) > 40 then goto continue end
        Wait(5)
        Draw2DText(string.format("%s (E)", Text.TakeAPicture), 4, {66, 182, 245}, 0.4, 0.01, 0.3)
        Draw2DText(string.format("%s (Y)", Text.ChangeCamera), 4, {66, 182, 245}, 0.4, 0.01, 0.33)
    end
    Wait(100)
    takeScreenshot()
    Wait(200)
    ::continue::
    RenderScriptCams(false, true, 2000, true, true)
    inProgress = false
    Wait(2000)
    if Config.hideHUD then
        ExecuteCommand("start qb-hud")
    end
end

CreateThread(function()
    local studioLocation = Config.studioLocation
    local entranceLocation = Config.entranceLocation
    local exitLocation = Config.exitLocation
    while true do
        Wait(5)
        local pCoords = GetEntityCoords(PlayerPedId())
        if not inside and not inProgress and Vdist2(pCoords.x, pCoords.y, pCoords.z, entranceLocation.x, entranceLocation.y, entranceLocation.z) < 20 then
            DrawText3D(entranceLocation.x, entranceLocation.y, entranceLocation.z, string.format("~y~%s ~w~(E)", Text.Photostudio))
            if IsControlPressed(0, 38) then
                tpPlayerIn(exitLocation)
                Wait(500)
            end
        end
        if inside and not inProgress and Vdist2(pCoords.x, pCoords.y, pCoords.z, studioLocation.x, studioLocation.y, studioLocation.z) < 15 then
            DrawText3D(studioLocation.x, studioLocation.y, studioLocation.z, string.format("~y~%s ~w~(E)", Text.StartPhotoshoot))
            if IsControlPressed(0, 38) then
                inProgress = true
                TakePictures()
                Wait(500)
            end
        end
        if inside and not inProgress and Vdist2(pCoords.x, pCoords.y, pCoords.z, exitLocation.x, exitLocation.y, exitLocation.z) < 10 then
            DrawText3D(exitLocation.x, exitLocation.y, exitLocation.z, string.format("~y~%s ~w~(E)", Text.ExitStudio))
            if IsControlPressed(0, 38) then
                tpPlayerOut(entranceLocation)
                Wait(500)
            end
        end
    end
end)