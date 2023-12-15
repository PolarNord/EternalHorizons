local assets = require("assets")
local interfaceManager = require("scripts.ui.interfaceManager")
local gameUi = {}

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
end

function gameUi:createPauseCanvas()
    self.pauseMenu = interfaceManager:newCanvas()
    self.pauseMenu.enabled = false
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
end

function gameUi:updateHUDCanvas()
    self.hud.healthText.text = Player.health
    self.hud.armorText.text = Player.armor
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

function gameUi:load()
    self:createHUDCanvas()
    self:createPauseCanvas()
end

function gameUi:update(delta)
    if GameState ~= "game" then return end
    self:updatePauseCanvas(delta)
    if GamePaused then return end
    self:updateHUDCanvas()
end

return gameUi