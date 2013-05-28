require 'middleclass/middleclass'

GameScreen = class('GameScreen',Screen)


function Screen:initialize()
  self._imgx=0
  self._imgy=0
  self._image = love.graphics.newImage("Resources/destructor_klingon.png")
end

function Screen:draw()
	love.graphics.setColor(255,255,255,255)
   	love.graphics.setBackgroundColor(0,0,0)
   	love.graphics.draw(self._image, self._imgx, self._imgy)
end

function Screen:update(dt)
	step=5
  if love.keyboard.isDown("up") then
		if(self._imgy>0)then
			self._imgy=self._imgy-step
		end
   end
  if love.keyboard.isDown("down") then
		if(self._imgy<love.graphics.getHeight()-self._image:getHeight())then
			self._imgy=self._imgy+step
		end
   end

   if love.keyboard.isDown("left") then
    if(self._imgx>0)then
      self._imgx=self._imgx-step
    end
   end
  if love.keyboard.isDown("right") then
    if(self._imgx<love.graphics.getWidth()-self._image:getWidth()) then
      self._imgx=self._imgx+step
    end
   end
   if love.keyboard.isDown("escape") then
    	return Screen:getExitMark()
   end
end

function Screen:keypressed(key, unicode)
end