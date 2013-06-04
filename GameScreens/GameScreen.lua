require 'middleclass/middleclass'
require 'GameFrameWork/PlayerShip'
require 'GameFrameWork/Space'
require 'GameFrameWork/Enemy'
require 'GameFrameWork/Hud'

GameScreen = class('GameScreen',Screen)


function GameScreen:initialize()
    self._bg1=love.graphics.newImage("Resources/gfx/space-1.png")
    self._bg2=love.graphics.newImage("Resources/gfx/space-2.png")
    self._bgPos=0
    self._space=Space:new()
    Hud:new(self._space)
    PlayerShip:new(self._space)
    Enemy:new(self._space)
    --Enemy:new(self._space)
end

 local _printBackground=function(self)
    love.graphics.draw(self._bg1, self._bgPos, 0) -- this is the original image
    love.graphics.draw(self._bg2, self._bgPos + self._bg1:getWidth(), 0) -- this is the copy that we draw to the original's right
    
    self._bgPos = self._bgPos - 1 -- scrolling the posX to the left

     if self._bgPos*-1 > self._bg1:getWidth() then
      self._bgPos = 0
      imaux=self._bg1
      self._bg1=self._bg2
      self._bg2=imaux
    end
end


function GameScreen:draw()
   local player=self._space:getPlayerShip()
   _printBackground(self)
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