require 'Utils/Menu'
require 'GameScreens/Screen'
require 'GameScreens/CreditsScreen'
require 'GameScreens/ControlsScreen'

local config=GameConfig.getInstance()

OptionsScreen = class('OptionsScreen', Screen)

local NONE_OPTION=0
local CREDITS_OPTION=1
local CONTROLS_OPTION=2

function OptionsScreen:initialize()
  self._optionsMenu=Menu:new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
  self._optionsMenu:addItem("Credits")
  self._optionsMenu:addItem("Controls")
  self._selectedOption=NONE_OPTION
  self._credits=CreditsScreen:new()
  self._controls=ControlsScreen:new()
end 


function OptionsScreen:draw()
	
	if(self._selectedOption==NONE_OPTION) then
		self._optionsMenu:print()
	end
	if(self._selectedOption==CREDITS_OPTION) then
		self._credits:draw()
	end
	if(self._selectedOption==CONTROLS_OPTION) then
		self._controls:draw()
	end
end

function OptionsScreen:update(dt)

	if(self._selectedOption==CREDITS_OPTION) then
		self._credits:update(dt)
	end
	if self._selectedOption==CONTROLS_OPTION then
		self._controls:update(dt)
	end
	return 1
end

function OptionsScreen:readPressed()
	if(self._selectedOption==NONE_OPTION) then

		if config:isDownEscape() then
			self._selectedOption=NONE_OPTION
		    return Screen:getExitMark()
		end
		
		self._selectedOption=self._optionsMenu:readPressed()
	else
		if(self._selectedOption==CREDITS_OPTION) then
			if self._credits:readPressed()==Screen:getExitMark() then
				self._selectedOption=NONE_OPTION
			end
		end
		if(self._selectedOption==CONTROLS_OPTION) then
			if self._controls:readPressed(key,unicode)==Screen:getExitMark() then
				self._selectedOption=NONE_OPTION
			end
		end
	end
end