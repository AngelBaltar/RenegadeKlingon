require 'middleclass/middleclass'
require 'GameFrameWork/PlayerShip'
require 'GameFrameWork/Space'
require 'GameFrameWork/Enemy'
require 'GameFrameWork/Hud'

GameScreen = class('GameScreen',Screen)


function GameScreen:initialize()
    self._bg=love.graphics.newImage("Resources/background1.png")
    self._space=Space:new()
    Hud:new(self._space)
    PlayerShip:new(self._space)
    Enemy:new(self._space)
    --Enemy:new(self._space)
end

function GameScreen:draw()
   local player=self._space:getPlayerShip()
   love.graphics.draw(self._bg, 0, 0)
   self._space:draw()
   if(player==nil)then
      love.graphics.setColor(255,0,0,255)
      love.graphics.print("GAME OVER", self._space:getXend()/2-70,self._space:getYend()/2-60)
   end
end

function GameScreen:update(dt)
  local player=self._space:getPlayerShip()
   --if player dead!
   if(player==nil)then
   		
  else
      self._space:update(dt)
  end
end

function GameScreen:keypressed(key, unicode)
	if key=="escape" then
    	return Screen:getExitMark()
   end
   self._space:keypressed(key,unicode)
end