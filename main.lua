--[[
    FreeCell game based on solitaire

    Author: Colton Ogden, CS50 Twitch team
    For more info, please check https://www.youtube.com/watch?v=BCp7_n-L-tc
]]

require 'src/Dependencies'

math.randomseed(os.time())

local gameBoard = GameBoard()

function love.load()
    love.window.setTitle('Freecell')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    love.mouse.buttonsPressed = {}
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasButtonPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    gameBoard:update(dt)
    
    love.mouse.buttonsPressed = {}
end

function love.draw()
    gameBoard:render()
end
