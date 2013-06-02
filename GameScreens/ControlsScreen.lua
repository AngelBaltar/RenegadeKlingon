require 'middleclass/middleclass'
require 'GameScreens/Screen'

ControlsScreen = class('ControlsScreen', Screen)


function ControlsScreen:initialize()
  self._xPos=0
  self._yPos=50
end 


function ControlsScreen:draw()

	 love.graphics.setColor(255,0,0,255)
	 love.graphics.print("Up------>move ship up\n"..
	 					 "Down---->move ship down\n"..
	 					 "Left---->move ship left\n"..
	 					 "Right--->move shio rigth\n"..
	 					 "a------->fire\n"
	 					,love.graphics.getWidth()/2-60,love.graphics.getHeight()/2-60)
end

function ControlsScreen:update(dt)

end

function ControlsScreen:keypressed(key, unicode)
	if key=="escape" then
    	return Screen:getExitMark()
   end
   return 1
end