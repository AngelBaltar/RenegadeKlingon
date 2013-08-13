require 'GameScreens/Screen'

CreditsScreen = class('CreditsScreen', Screen)

local config=GameConfig.getInstance()


function CreditsScreen:initialize()
  self._xPos=0
  self._yPos=50
end 


function CreditsScreen:draw()

	 love.graphics.setColor(255,0,0,255)
	 love.graphics.print("Main Developement:Angel Baltar Diaz\n"..
	 					"Executive Producer:Angel Baltar Diaz"
	 					, self._xPos, self._yPos)
end

function CreditsScreen:update(dt)
	self._yPos=self._yPos+1
end

function CreditsScreen:readPressed()
	if config:isDownEscape() then
		self._xPos=0
		self._yPos=0
    	return Screen:getExitMark()
   end
   return 1
end