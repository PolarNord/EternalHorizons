local assets = {}

function assets.load()
    assets.images = {
        player = {
            body = love.graphics.newImage("images/player/body.png");
            handDefault = love.graphics.newImage("images/player/hand_default.png")
        };
        tiles = {
            prototypeGreen = love.graphics.newImage("images/texture_09.png")
        }
    }
end

function assets.unloadAll()
    assets = {}
end

return assets