require 'middleclass/middleclass'
require 'Utils/Menu'
require 'GameScreens/Screen'
require 'GameScreens/CreditsScreen'

OptionsScreen = class('OptionsScreen', Screen)


function OptionsScreen:initialize()
  self._optionsMenu=Menu:new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
  self._optionsMenu:addItem("Credits")
  self._selectedOption=0
  self._credits=CreditsScreen:new()
end 


function OptionsScreen:draw()
	
	if(self._selectedOption==0) then
		self._optionsMenu:print()
	end
	if(self._selectedOption==1) then
		self._credits:draw()
	end
end

function OptionsScreen:update(dt)

	if(self._selectedOption==1) then
		self._credits:update(dt)
	end
	return 1
end

function OptionsScreen:keypressed(key, unicode)
	if(self._selectedOption==0) then

		if love.keyboard.isDown("escape") then
			self._selectedOption=0
		    return Screen:getExitMark()
		end
		
		self._selectedOption=self._optionsMenu:keypressed(key, unicode)
	else
		if(self._selectedOption==1) then
			if self._credits:keypressed(key,unicode)==Screen:getExitMark() then
				self._selectedOption=0
			end
		end
	end
end