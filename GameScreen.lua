require 'middleclass/middleclass'
require 'GameFrameWork/PlayerShip'
require 'GameFrameWork/Space'

GameScreen = class('GameScreen',Screen)


function Screen:initialize()
    self._space=Space:new()
    self._space:addSpaceObject(PlayerShip:new(self._space))
end

function Screen:draw()
	self._space:draw()
end

function Screen:update(dt)
	
   if love.keyboard.isDown("escape") then
    	return Screen:getExitMark()
   end
   self._space:update(dt)
end

function Screen:keypressed(key, unicode)
end