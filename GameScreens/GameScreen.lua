require 'middleclass/middleclass'
require 'GameFrameWork/PlayerShip'
require 'GameFrameWork/Space'
require 'GameFrameWork/Enemy'
require 'GameFrameWork/Hud'

GameScreen = class('GameScreen',Screen)


function GameScreen:initialize()
    self._bgList={}
    self._bgList[0]=love.graphics.newImage("Resources/gfx/space-1.png")
    self._bgList[1]=love.graphics.newImage("Resources/gfx/space-2.png")
    self._bgList[2]=love.graphics.newImage("Resources/gfx/space-3.png")
    self._bgList[3]=love.graphics.newImage("Resources/gfx/space-4.png")
    self._bgPos=0
    self._bgActual=0
    self._bgSize=4
    self._bgWidth=self._bgList[0]:getWidth()
    self._space=Space:new()
    Hud:new(self._space)
    PlayerShip:new(self._space)
    Enemy:new(self._space)
    --Enemy:new(self._space)
end

 local _printBackground=function(self)
    love.graphics.draw(self._bgList[self._bgActual], self._bgPos, 0) -- this is the original image
    love.graphics.draw(self._bgList[(self._bgActual+1)%self._bgSize],self._bgPos + self._bgWidth, 0) -- this is the copy that we draw to the original's right
    
    self._bgPos = self._bgPos - 1 -- scrolling the posX to the left

     if self._bgPos*-1 > self._bgWidth then
      self._bgPos = 0
      --imaux=self._bg1
      --self._bg1=self._bg2
      --self._bg2=imaux
      self._bgActual=(self._bgActual+1)%self._bgSize
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