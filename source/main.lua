-- Below is a small example program where you can move a circle
-- around with the crank. You can delete everything in this file,
-- but make sure to add back in a playdate.update function since
-- one is required for every Playdate game!
-- =============================================================

-- Importing libraries used for drawCircleAtPoint and crankIndicator
import "CoreLibs/graphics"
import "CoreLibs/ui"

-- Localizing commonly used globals
local pd <const> = playdate
local gfx <const> = playdate.graphics


-- Defining player variables
local playerSize = 10
local playerVelocity = 3

local playerX = 200
local playerY = 120


-- Creating a Ray Function
local function ray(crankAngle)
    local numRays = 30
    local fov = math.rad(60)
    local angleStart = crankAngle - fov / 2
    local rayLength = 90

    for i = 0, numRays - 1 do
        local t = i / (numRays - 1) -- normalize from 0 to 1
        local angle = angleStart + t * fov
    
        local endX = playerX + math.cos(angle) * rayLength
        local endY = playerY + math.sin(angle) * rayLength
    
        gfx.setColor(gfx.kColorWhite)
        gfx.drawLine(playerX, playerY, endX, endY)
    end

end


-- Drawing player image

-- Setting player to color white
gfx.setColor(gfx.kColorWhite)
local playerImage = gfx.image.new(32, 32)

gfx.pushContext(playerImage)
    
    -- Draw light player (Circle)
    gfx.fillCircleAtPoint(16, 16, 10)

gfx.popContext()

-- Defining helper function
local function ring(value, min, max)
	if (min > max) then
		min, max = max, min
	end
	return min + (value - min) % (max - min)
end

-- playdate.update function is required in every project!
function playdate.update()
    -- Clear screen and setting background to black
    gfx.clear(gfx.kColorBlack)

    -- Get crank angle 
    local crankAngle = math.rad(pd.getCrankPosition())

    -- Draw crank indicator if crank is docked
    if pd.isCrankDocked() then
        pd.ui.crankIndicator:draw()
    else
        -- Calculate velocity from crank angle 
        local crankPosition = pd.getCrankPosition() - 90
        local xVelocity = math.cos(math.rad(crankPosition)) * playerVelocity
        local yVelocity = math.sin(math.rad(crankPosition)) * playerVelocity
        -- Move player
        playerX += xVelocity
        playerY += yVelocity
        -- Loop player position
        playerX = ring(playerX, -playerSize, 400 + playerSize)
        playerY = ring(playerY, -playerSize, 240 + playerSize)
    end

    -- Draw Rays
    ray(crankAngle)

    -- Draw player
    playerImage:drawAnchored(playerX, playerY, 0.5, 0.5)
end
