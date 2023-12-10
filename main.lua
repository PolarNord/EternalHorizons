local assets = require("assets")
local player = require("player")
local rgb = require("coreFuncs").rgb
local camera = require("camera")
local mapRenderer = require("mapRenderer")

local fullscreen = false

function love.keypressed(key, _unicode)
    -- Fullscreen key
    if key == "f11" then
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen, "desktop")
        -- Set window dimensions to default
        if not fullscreen and false then
         love.window.setMode(960, 540, {resizable=true}) end
     end
end

function love.load()
    Player = player.new()
    Camera = camera.new()
    love.graphics.setDefaultFilter("nearest", "nearest")
    assets.load()
    mapRenderer:load()
end

function love.update(delta)
    ScreenWidth, ScreenHeight = love.graphics.getDimensions()
    Player:update(delta)
end

function love.draw()
    love.graphics.setBackgroundColor(rgb(50))
    --Game
    mapRenderer:draw()
    Player:draw()
end
