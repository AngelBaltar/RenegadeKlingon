require 'middleclass/middleclass'
require 'GameFrameWork/PlayerShip'

GameScreen = class('GameScreen',Screen)


function Screen:initialize()
    self._player=PlayerShip:new()
end

function Screen:draw()
	self._player:draw()
end

function Screen:update(dt)
	
   if love.keyboard.isDown("escape") then
    	return Screen:getExitMark()
   end
   self._player:pilot()
end

function Screen:keypressed(key, unicode)
end