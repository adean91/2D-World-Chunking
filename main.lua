io.stdout:setvbuf("no")

local world = require("world")

function love.load()
	world:randomize(16,16,32,32,1, {50,50})
end

function love.update(dt)
	--print("FPS: ".. 1/dt)
end

function love.draw()
	local mx, my = love.mouse.getPosition()
	world:draw(mx, my)
end

function love.keypressed(k)
	if k == "escape" then love.event.quit() end
end

