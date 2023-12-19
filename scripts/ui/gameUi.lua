local assets = require("assets")
local interfaceManager = require("scripts.ui.interfaceManager")
local gameUi = {}

local function menuButtonClick()
    GameState = "menu"
end

function gameUi:createHUDCanvas()
    self.hud = interfaceManager:newCanvas()
    self.hud:newImage(assets.images.ui.healthBar, {97, 465}, {2.35,2.35}, 0, "x+")
    --Health counter
    self.hud.healthText = self.hud:newTextLabel(
        Player.health, {55, 490}, 48, "x+", "left", "disposable-droid", {1,1,1,1}
    )
    --Armor counters
    self.hud.armorText = self.hud:newTextLabel(
        Player.armor, {44, 448}, 32, "x+", "left", "disposable-droid", {1,1,1,1}
    )

    --Current weapon index
    self.hud.weaponIndex = self.hud:newTextLabel(
        "1", {700, 470}, 24, "++", "left", "disposable-droid", {1,1,1,1}
    )

    --Current weapon image
    self.hud.weaponImg = self.hud:newImage(
        assets.images.ui.pistolImg, {760, 480}, {3,3}, 0, "++"
    )
    --Current weapon mag ammo
    self.hud.weaponMagAmmo = self.hud:newTextLabel(
        "12", {800, 455}, 36, "++", "left", "disposable-droid-bold", {1,1,1,1}
    )
    --Ammunition of current weapon
    self.hud.weaponAmmunition = self.hud:newTextLabel(
        "94", {800, 485}, 20, "++", "left", "disposable-droid", {1,1,1,1}
    )
    
    --Other weapons 1 index
    self.hud.weapon2Index = self.hud:newTextLabel(
        "2", {840, 430}, 16, "++", "left", "disposable-droid", {1,1,1,1}
    )
    --Other weapons 1 image
    self.hud.weapon2Img = self.hud:newImage(
        assets.images.ui.ARImg, {890, 440}, {2,2}, 0, "++"
    )
    --Other weapons 2 index
    self.hud.weapon3Index = self.hud:newTextLabel(
        "3", {840, 480}, 16, "++", "left", "disposable-droid", {1,1,1,1}
    )
    --Other weapons 2 image
    self.hud.weapon3Img = self.hud:newImage(
        assets.images.ui.shotgunImg, {890, 490}, {2,2}, 0, "++"
    )
end

function gameUi:createPauseCanvas()
    self.pauseMenu = interfaceManager:newCanvas()
    --Background
    self.pauseMenu.background = self.pauseMenu:newRectangle(
        {0,0}, {960, 540}, {0, 0, 0, 0.6}, "xx"
    )
    --Title
    self.pauseMenu.title = self.pauseMenu:newTextLabel(
        "ETERNAL HORIZONS", {50, 50}, 64, "xx", "left", "disposable-droid", {1,1,1,1}
    )
    --Continue button
    self.pauseMenu.continue = self.pauseMenu:newButton(
        {70, 200}, {0,0}, {1,1,1,1}, 1, "Continue", 30,
        "disposable-droid", "xx", function() GamePaused = false end
    )
    --Settings button
    self.pauseMenu.settings = self.pauseMenu:newButton(
        {70, 240}, {0,0}, {1,1,1,1}, 1, "Settings", 30,
        "disposable-droid", "xx", nil
    )
    --Menu button
    self.pauseMenu.menu = self.pauseMenu:newButton(
        {70, 280}, {0,0}, {1,1,1,1}, 1, "Main Menu", 30,
        "disposable-droid", "xx", menuButtonClick
    )
    --Quit button
    self.pauseMenu.quit = self.pauseMenu:newButton(
        {70, 320}, {0,0}, {1,1,1,1}, 1, "Quit", 30,
        "disposable-droid", "xx", function () love.event.quit() end
    )
end

function gameUi:updateHUDCanvas()
    --Health & Armor bars
    self.hud.healthText.text = Player.health
    self.hud.armorText.text = Player.armor
    --Current weapon
    local weapon = Player.inventory.weapons[Player.inventory.slot]
    if weapon then
        self.hud.weaponImg.source = assets.images.ui[string.lower(weapon.name) .. "Img"]
        self.hud.weaponMagAmmo.text = weapon.magAmmo
        self.hud.weaponAmmunition.text = Player.inventory.ammunition[weapon.ammoType]
    else
        self.hud.weaponImg.source = nil
        self.hud.weaponMagAmmo.text = "-"
        self.hud.weaponAmmunition.text = "-"
    end
    self.hud.weaponIndex.text = Player.inventory.slot
end

function gameUi:updatePauseCanvas(delta)
    self.pauseMenu.enabled = GamePaused
    --Smooth alpha transitioning
    local smoothness = 7
    if GamePaused then
        self.pauseMenu.alpha = self.pauseMenu.alpha + (1 - self.pauseMenu.alpha) * smoothness * delta
    else
        self.pauseMenu.alpha = 0.4
    end
    --Scale background to fit screen
    self.pauseMenu.background.size = {ScreenWidth, ScreenHeight}
end

function gameUi:setCanvasState()
    self.hud.enabled = GameState == "game"
    self.pauseMenu.enabled = GameState == "game" and GamePaused
end

function gameUi:load()
    self:createHUDCanvas()
    self:createPauseCanvas()
end

function gameUi:update(delta)
    self:setCanvasState()
    if GameState ~= "game" then return end
    self:updatePauseCanvas(delta)
    if GamePaused then return end
    self:updateHUDCanvas()
end

return gameUi