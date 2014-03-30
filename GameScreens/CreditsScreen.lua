-- /* RenegadeKlingon - LÖVE2D GAME
--  * CreditsScreen.lua
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
require 'GameScreens/FlowDownTextScreen'

CreditsScreen = class('CreditsScreen', FlowDownTextScreen)


local config=GameConfig.getInstance()


function CreditsScreen:initialize()

  local message="SPECIAL THANKS:\n"..
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
    FlowDownTextScreen.initialize(self,message)
end 