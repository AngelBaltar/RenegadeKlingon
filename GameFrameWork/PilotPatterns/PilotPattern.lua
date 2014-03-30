-- /* RenegadeKlingon - LÖVE2D GAME
--  * PilotPattern.lua
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
require 'Utils/middleclass/middleclass'

PilotPattern = class('GameFrameWork.PilotPatterns.PilotPattern')

--constructor
function PilotPattern:initialize(ship)
    self._ship=ship
end

function PilotPattern:pilot(dt)

end

function PilotPattern:setShip(ship)
	self._ship=ship
end

function PilotPattern:getShip()
	return self._ship
end