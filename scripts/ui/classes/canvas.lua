local image = require("scripts.ui.classes.image")
local textLabel = require("scripts.ui.classes.textLabel")
local rectangle = require("scripts.ui.classes.rectangle")
local button = require("scripts.ui.classes.button")

local canvas = {}

function canvas.new()
    local instance = {
        elements = {};
        enabled = true;
        position = {0, 0};
        alpha = 1;
        index = nil;
    }

    function instance:newImage(source, position, scale, rotation, align, color)
        local instance2 = image.new()
        instance2.source = source
        instance2.position = position
        instance2.scale = scale
        instance2.rotation = rotation
        instance2.align = align
        instance2.color = color or {1,1,1,1}
        instance2.parentCanvas = self
        self.elements[#self.elements+1] = instance2
        return instance2
    end

    function instance:newTextLabel(text, position, size, align, begin, font, color)
        local instance2 = textLabel.new()
        instance2.text = text
        instance2.position = position
        instance2.size = size
        instance2.align = align
        instance2.begin = begin
        instance2.font = font
        instance2.color = color
        instance2.parentCanvas = self
        self.elements[#self.elements+1] = instance2
        return instance2
    end

    function instance:newRectangle(position, size, color, align)
        local instance2 = rectangle.new()
        instance2.position = position
        instance2.size = size
        instance2.color = color
        instance2.align = align
        instance2.parentCanvas = self
        self.elements[#self.elements+1] = instance2
        return instance2
    end

    function instance:newButton(position, size, color, buttonType, buttonText, buttonTextSize, font, align, clickEvent)
        local instance2 = button.new()
        instance2.position = position
        instance2.size = size
        instance2.color = color
        instance2.buttonType = buttonType
        instance2.buttonText = buttonText
        instance2.buttonTextSize = buttonTextSize
        instance2.font = font
        instance2.align = align
        instance2.clickEvent = clickEvent
        instance2.parentCanvas = self
        self.elements[#self.elements+1] = instance2
        return instance2
    end
    
    function instance:update(delta)
        --Update elements
        for _, v in ipairs(self.elements) do
            if v.update then v:update(delta) end
        end
    end
    
    function instance:draw()
        --Draw elements
        for _, v in ipairs(self.elements) do
            v:draw()
        end
    end

    return instance
end

return canvas