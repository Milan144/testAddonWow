-- Frame pour écouter les événements
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LEVEL_UP") -- Événement level up
frame:RegisterEvent("PLAYER_LOGIN")    -- Événement connexion du joueur

-- Variables pour le temps
local sessionStartTime = GetTime()
local lastLevelTime = GetTime()

-- Créer une interface simple
local uiFrame = CreateFrame("Frame", "TawUIFrame", UIParent, "BasicFrameTemplateWithInset")
uiFrame:SetSize(300, 150) -- Largeur, hauteur
uiFrame:SetPoint("CENTER") -- Position au centre de l'écran
uiFrame:Hide() -- Caché par défaut

-- Titre de la fenêtre
local title = uiFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("Temps de Session")

-- Texte pour afficher le temps écoulé
local timeText = uiFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
timeText:SetPoint("CENTER", 0, 0)
timeText:SetText("Temps écoulé : 0 minutes")

-- Bouton pour fermer la fenêtre
local closeButton = CreateFrame("Button", nil, uiFrame, "UIPanelButtonTemplate")
closeButton:SetSize(80, 22) -- Largeur, hauteur
closeButton:SetPoint("BOTTOM", 0, 10)
closeButton:SetText("Fermer")
closeButton:SetScript("OnClick", function()
    uiFrame:Hide()
end)

-- Fonction pour mettre à jour le texte avec le temps de session
local function updateTime()
    local currentTime = GetTime()
    local elapsedTime = currentTime - sessionStartTime
    timeText:SetText(string.format("Temps écoulé : %.2f minutes", elapsedTime / 60))
end

-- Commande /taw pour afficher la fenêtre
SLASH_TAW1 = "/taw"
SlashCmdList["TAW"] = function()
    updateTime()
    uiFrame:Show()
end

-- Joue une musique
local function playLevelUpMusic()
    PlaySoundFile("Interface\\AddOns\\testAddonWow\\levelup.mp3", "Master")
end

-- Affiche un message à l'écran
local function showMessage(message, r, g, b)
    print(message)
    UIErrorsFrame:AddMessage(message, r or 1.0, g or 1.0, b or 0.0, 53, 5)
end

-- Evénement "PLAYER_LEVEL_UP"
local function onPlayerLevelUp(level)
    local currentTime = GetTime()
    local elapsedTime = currentTime - lastLevelTime

    playLevelUpMusic()
    local levelMessage = string.format("Félicitations pour le niveau %d! Temps écoulé depuis le dernier niveau: %.2f minutes.", level, elapsedTime / 60)
    showMessage(levelMessage, 0, 1, 0)

    lastLevelTime = currentTime
end

-- Evénement "PLAYER_LOGIN"
local function onPlayerLogin()
    showMessage("Bienvenue, " .. UnitName("player") .. "!", 1, 0.5, 0)
    sessionStartTime = GetTime()
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
