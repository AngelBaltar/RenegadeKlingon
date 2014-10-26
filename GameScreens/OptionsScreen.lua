-- /* RenegadeKlingon - LÖVE2D GAME
--  * OptionsScreen.lua
--  * Copyright (C) Angel Baltar Diaz
--  *
--  * This program is free software: you can redistribute it and/or
--  * modify it under the terms of the GNU General Public
--  * License as published by the Free Software Foundation; either
--  * version 3 of the License, or (at your option) any later version.
--  *
--  * This program is distributed in the hope that it will be useful,
--  * but WITHOUT ANY WARRANTY; without even the implied warranty of
--  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  * General Public License for more details.
--  *
--  * You should have received a copy of the GNU General Public
--  * License along with this program.  If not, see
--  * <http://www.gnu.org/licenses/>.
--  */
require 'Utils/Menu'
require 'Utils/GameConfig'
require 'GameScreens/Screen'
require 'GameScreens/CreditsScreen'
require 'GameScreens/ControlsScreen'
require 'GameScreens/HighScore'

local config=GameConfig.getInstance()

OptionsScreen = class('OptionsScreen', Screen)

local NONE_OPTION=0
local CREDITS_OPTION=1
local CONTROLS_OPTION=2
local HIGH_SCORE_OPTION=3

function OptionsScreen:initialize()
  self._optionsMenu=Menu:new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
  self._optionsMenu:addItem("Credits")
  if GameConfig.getInstance():getTargetMachine()==GameConfig.static.ANDROID then
  	--no way to change controls on android
  	HIGH_SCORE_OPTION=CREDITS_OPTION+1
  	CONTROLS_OPTION=-1
  else
  	 self._optionsMenu:addItem("Controls")
  	 self._controls=ControlsScreen:new()
  end
  self._optionsMenu:addItem("High Score")
  self._selectedOption=NONE_OPTION
  self._credits=CreditsScreen:new()
  self._scores=HighScore:new()
  Screen.initialize(self)
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
	if(self._selectedOption==HIGH_SCORE_OPTION) then
		self._scores:draw()
	end

end

function OptionsScreen:update(dt)
	
	-- if(self._selectedOption==NONE_OPTION) then
	-- 	Screen.update(self,dt)
	-- end
	if(self._selectedOption==CREDITS_OPTION) then
		self._credits:update(dt)
	end
	if self._selectedOption==CONTROLS_OPTION then
		self._controls:update(dt)
	end
	if self._selectedOption==HIGH_SCORE_OPTION then
		self._scores:update(dt)
	end
	return 1
end

function OptionsScreen:readPressed()
	if(self._selectedOption==NONE_OPTION) then

		self._selectedOption=self._optionsMenu:readPressed()
		if self._selectedOption==Screen:getExitMark() then
			self._selectedOption=NONE_OPTION
		    return Screen:getExitMark()
		end
		
	else
		if(self._selectedOption==CREDITS_OPTION) then
			if self._credits:readPressed()==Screen:getExitMark() then
				self._selectedOption=NONE_OPTION
			end
		end
		if(self._selectedOption==CONTROLS_OPTION) then
			if self._controls:readPressed()==Screen:getExitMark() then
				self._selectedOption=NONE_OPTION
			end
		end
		if(self._selectedOption==HIGH_SCORE_OPTION) then
			if self._scores:readPressed()==Screen:getExitMark() then
				self._selectedOption=NONE_OPTION
			end
		end
	end
end