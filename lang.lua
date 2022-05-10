local Translations = {
    info = {
        start_photoshoot = "Start photoshoot",
        take_picture = "Take picture",
        take_picture_description = "Takes a picture with no UI",
        photostudio = "Photostudio",
        exit_studio = "Exit studio",
        change_camera = "Change camera",
        change_camera_description = "Change between set cameras",
        fov = "FOV",
        fov_description = "Change current camera FOV",
        point_at_player = "Point at player",
        point_at_player_description = "Toggles pointing current camera at player if inside vehicle",
        player_invisible = "Invisible player",
        player_invisible_description = "Makes player invisible locally",
    },
    error = {
        upload_failed = "Upload failed"
    }
}

Lang = nil

if Conf.UseQBCore then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true
    })
end

function text_start_photoshoot()
    if Conf.UseQBCore then
        return Lang:t("info.start_photoshoot")
    else
        return Translations.info.start_photoshoot
    end
end

function text_take_picture()
    if Conf.UseQBCore then
        return Lang:t("info.take_picture")
    else
        return Translations.info.take_picture
    end
end

function text_take_picture_description()
    if Conf.UseQBCore then
        return Lang:t("info.take_picture_description")
    else
        return Translations.info.take_picture_description
    end
end

function text_photostudio()
    if Conf.UseQBCore then
        return Lang:t("info.photostudio")
    else
        return Translations.info.photostudio
    end
end

function text_exit_studio()
    if Conf.UseQBCore then
        return Lang:t("info.exit_studio")
    else
        return Translations.info.exit_studio
    end
end

function text_change_camera()
    if Conf.UseQBCore then
        return Lang:t("info.change_camera")
    else
        return Translations.info.change_camera
    end
end

function text_change_camera_description()
    if Conf.UseQBCore then
        return Lang:t("info.change_camera_description")
    else
        return Translations.info.change_camera_description
    end
end

function text_fov()
    if Conf.UseQBCore then
        return Lang:t("info.fov")
    else
        return Translations.info.fov
    end
end

function text_fov_description()
    if Conf.UseQBCore then
        return Lang:t("info.fov_description")
    else
        return Translations.info.fov_description
    end
end

function text_point_at_player()
    if Conf.UseQBCore then
        return Lang:t("info.point_at_player")
    else
        return Translations.info.point_at_player
    end
end

function text_point_at_player_description()
    if Conf.UseQBCore then
        return Lang:t("info.point_at_player_description")
    else
        return Translations.info.point_at_player_description
    end
end

function text_player_invisible()
    if Conf.UseQBCore then
        return Lang:t("info.player_invisible")
    else
        return Translations.info.player_invisible
    end
end

function text_player_invisible_description()
    if Conf.UseQBCore then
        return Lang:t("info.player_invisible_description")
    else
        return Translations.info.player_invisible_description
    end
end

function text_upload_failed()
    if Conf.UseQBCore then
        return Lang:t("error.upload_failed")
    else
        return Translations.error.upload_failed
    end
end