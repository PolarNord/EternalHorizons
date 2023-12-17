local assets = require("assets")
local coreFuncs = require("coreFuncs")
local humanoid = require("scripts.humanoid")

local player = {}

function player.new()
    local instance = humanoid.new()

    --Player variables
    instance.inventory.previousSlot = nil
    instance.keyPressData = {
        ["q"] = false;
    }

    --Changes camera zoom dynamically depending on current sprinting state.
    function instance:changeCameraZoom(delta)
        local smoothness = 10
        local d
        if self.sprinting then
            d = (1.035-Camera.zoom) * smoothness * delta
        else
            d = (1-Camera.zoom) * smoothness * delta
        end
        Camera.zoom = Camera.zoom + d
    end

    function instance:movement(delta)
        local speed = 140
        self.velocity = {0, 0}
        --Get key input
        if love.keyboard.isDown("a") then
            self.velocity[1] = self.velocity[1] - 1
        end
        if love.keyboard.isDown("d") then
            self.velocity[1] = self.velocity[1] + 1
        end
        if love.keyboard.isDown("w") then
            self.velocity[2] = self.velocity[2] - 1
        end
        if love.keyboard.isDown("s") then
            self.velocity[2] = self.velocity[2] + 1
        end
        --Sprinting
        local sprintMultiplier = 1.6
        self.sprinting = love.keyboard.isDown("lshift")
        if self.sprinting then
            self.velocity[1] = self.velocity[1] * sprintMultiplier
            self.velocity[2] = self.velocity[2] * sprintMultiplier
        end
        --Normalize velocity
        if math.abs(self.velocity[1]) == math.abs(self.velocity[2]) then
            self.velocity[1] = self.velocity[1] * math.sin(math.pi/4)
            self.velocity[2] = self.velocity[2] * math.sin(math.pi/4)
        end
        self.moving = math.abs(self.velocity[1]) > 0 or math.abs(self.velocity[2]) > 0
        --Move by velocity
        self.position[1] = self.position[1] + (self.velocity[1]*speed*delta)
        self.position[2] = self.position[2] + (self.velocity[2]*speed*delta)
    end

    function instance:pointTowardsMouse()
        local mouseX, mouseY = love.mouse.getPosition()
        local pos = coreFuncs.getRelativePosition(self.position, Camera)
        local dx = mouseX-pos[1] ; local dy = mouseY-pos[2]
        self.rotation = math.atan2(dy, dx)
    end

    function instance:slotSwitching()
        --Switch slot with number keys
        for i = 1, 3 do
            if love.keyboard.isDown(tostring(i)) and i ~= self.inventory.slot then
                self.inventory.previousSlot = self.inventory.slot
                self.inventory.slot = i
            end
        end
        --Quick slot switching
        if love.keyboard.isDown("q") and not self.keyPressData["q"] and self.inventory.previousSlot then
            local temp = self.inventory.previousSlot
            self.inventory.previousSlot = self.inventory.slot
            self.inventory.slot = temp
        end
        self.keyPressData["q"] = love.keyboard.isDown("q")
    end

    --Core functions
    function instance:update(delta)
        if GamePaused then return end
        self:movement(delta)
        self:pointTowardsMouse()
        self:slotSwitching()
        Camera:followTarget(self, 8, delta)
        self:changeCameraZoom(delta)
        self:doWalkingAnim()
    end

    function instance:draw()
        --Draw hands
        self:drawHands()
        -- Draw body
        local src = assets.images.player.body
        local width = src:getWidth() ;  local height = src:getHeight()
        local pos = coreFuncs.getRelativePosition(self.position, Camera)
        love.graphics.draw(
            src, pos[1], pos[2], self.rotation,
            4*Camera.zoom + self.animationSizeDiff, 4*Camera.zoom + self.animationSizeDiff, width/2, height/2
        )
    end

    return instance
end

return player