-- Créer un frame pour écouter les événements
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LEVEL_UP") -- Événement pour le level up
frame:RegisterEvent("PLAYER_LOGIN")    -- Événement pour la connexion du joueur

-- Variable pour stocker le temps au dernier niveau
local lastLevelTime = GetTime()

-- Fonction pour jouer une musique
local function playLevelUpMusic()
    PlaySoundFile("Interface\\AddOns\\MonAddon\\levelup.mp3", "Master") -- Remplace par ton fichier audio
end

-- Fonction pour afficher un message à l'écran
local function showMessage(message, r, g, b)
    print(message) -- Affiche dans la console
    UIErrorsFrame:AddMessage(message, r or 1.0, g or 1.0, b or 0.0, 53, 5) -- Affiche sur l'écran
end

-- Réagir à l'événement "PLAYER_LEVEL_UP"
local function onPlayerLevelUp(level)
    local currentTime = GetTime()
    local elapsedTime = currentTime - lastLevelTime -- Temps écoulé depuis le dernier niveau

    playLevelUpMusic()
    local levelMessage = string.format("Félicitations pour le niveau %d ! Temps écoulé depuis le dernier niveau : %.2f minutes.", level, elapsedTime / 60)
    showMessage(levelMessage, 0, 1, 0)

    lastLevelTime = currentTime -- Mettre à jour le temps du dernier niveau
end

-- Réagir à l'événement "PLAYER_LOGIN"
local function onPlayerLogin()
    -- Afficher le nom du personnage
    showMessage("Bienvenue, " .. UnitName("player") .. " !", 1, 0.5, 0)
end

-- Gestionnaire d'événements
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LEVEL_UP" then
        local level = ...
        onPlayerLevelUp(level)
    elseif event == "PLAYER_LOGIN" then
        onPlayerLogin()
    end
end)
