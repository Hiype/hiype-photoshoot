Conf = {}

Conf.TableName = "hiype_screenshots"
Conf.BlipName = "Photoshoot"

Conf.StudioLocation = vector4(-75.87, -824.33, 284.4, 344.56)
Conf.EntranceSpawnLocation = vector4(-84.21, -821.51, 35.44, 349.44)
Conf.EntraceCameraLocation = vector4(-72.63, -829.07, 286.0, 159.83)
Conf.ExitSpawnLocation = vector4(-73.18, -814.64, 285.0, 159.83)
Conf.ExitCameraLocation = vector4(-79.1, -769.77, 39.79, 169.55)
Conf.StudioCameras = {
    { location = vector3(-71.68, -818.77, 285.5), FOV = 40 },
    { location = vector3(-71.68, -827.6, 285.0), FOV = 40 },
}

Conf.UseQBCore = true
Conf.CamPointAtPlayer = true
Conf.HideHUD = false -- STOPS QB-HUD SERVER-WIDE FOR THE DURATION OF PHOTOSHOOT
Conf.PlayerCanGetOutOfCar = true
Conf.PlayerInvisible = false
Conf.SetVehicleInPlace = true
Conf.ShowBlip = true

Conf.DefaultCamera = 1
Conf.DefaultFOV = 40.0
Conf.MinFOV = 1.0
Conf.MaxFOV = 130.0
Conf.DefaultAnimationTime = 1000

Conf.EntranceBoxLocation = vector3(-84.21, -821.51, 35.44)
Conf.EntranceBoxLength = 8.0
Conf.EntranceBoxWidth = 5.0
Conf.EntranceBoxHeading = 351
Conf.EntranceBoxMinZ = 34.95
Conf.EntranceBoxMaxZ = 38.15
Conf.EntranceBoxDebugPoly = false

Conf.ExitBoxLocation = vector3(-71.92, -812.21, 285.0)
Conf.ExitBoxLength = 4.0
Conf.ExitBoxWidth = 8.0
Conf.ExitBoxHeading = 340
Conf.ExitBoxMinZ = 284.0
Conf.ExitBoxMaxZ = 289.4
Conf.ExitBoxDebugPoly = false

Conf.StudioBoxLocation = vector3(-74.34, -820.27, 285.0)
Conf.StudioBoxLength = 24.4
Conf.StudioBoxWidth = 20.6
Conf.StudioBoxHeading = 70
Conf.StudioBoxMinZ = 284.0
Conf.StudioBoxMaxZ = 289.4
Conf.StudioBoxDebugPoly = false

Conf.StartBoxLocation = vector3(-75.31, -823.01, 285.0)
Conf.StartBoxLength = 24.2
Conf.StartBoxWidth = 14.8
Conf.StartBoxHeading = 70
Conf.StartBoxMinZ = 284.0
Conf.StartBoxMaxZ = 289.4
Conf.StartBoxDebugPoly = false