require 'GameScreens/Screen'

CreditsScreen = class('CreditsScreen', Screen)

local config=GameConfig.getInstance()


function CreditsScreen:initialize()
  self._xPos=450
  self._yPos=nil -- if depends of the font of the system, we cant do this here, will do in the first update
  self._creditNumLines=18
end 


function CreditsScreen:draw()
	 love.graphics.setColor(255,0,0,255)
	 love.graphics.print("SPECIAL THANKS:\n"..
	 					"    with2balls.com\n"..
	 					"    David Antúnez Gonzalez\n\n"..
	 					"GRAPHIC DESIGNS:\n"..
	 					"    Angel Baltar Diaz\n"..
	 					"    opengameart.org\n\n"..
	 					"MUSIC AND SOUND:\n"..
	 					"    opengameart.org\n\n"..
	 					"GAME DESIGN:\n"..
	 					"    Angel Baltar Diaz\n\n"..
	 					"GAME PROGRAMMING:\n"..
	 					"    Angel Baltar Diaz\n\n"
	 					, self._xPos, self._yPos)

end

function CreditsScreen:update(dt)
	font=love.graphics.getFont()
	if(self._yPos==nil) then
	 	self._yPos=(2-self._creditNumLines)*font:getHeight()
	end
	self._yPos=self._yPos+0.5
	if(self._yPos>self._creditNumLines*font:getHeight()) then
		self._yPos=(2-self._creditNumLines)*font:getHeight()
	end
end

function CreditsScreen:readPressed()
	if config:isDownEscape() then
		self._xPos=0
		self._yPos=0
    	return Screen:getExitMark()
   end
   return 1
end