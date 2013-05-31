require 'middleclass/middleclass'
require 'GameFrameWork/PlayerShip'
require 'GameFrameWork/Space'
require 'GameFrameWork/Enemy'
require 'GameFrameWork/Hud'

GameScreen = class('GameScreen',Screen)


function Screen:initialize()
    self._space=Space:new()
    PlayerShip:new(self._space)
    Enemy:new(self._space)
    Hud:new(self._space)
end

function Screen:draw()
	self._space:draw()
end

function Screen:update(dt)
   self._space:update(dt)
end

function Screen:keypressed(key, unicode)
	if key=="escape" then
    	return Screen:getExitMark()
   end
   self._space:keypressed(key,unicode)
end