-- /* RenegadeKlingon - LÖVE2D GAME
--  * HealthObject.lua
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
require 'GameFrameWork/Harvestables/HarvestableObject'


HealthObject = class('GameFrameWork.Harverstables.HealthObject',HarvestableObject)

HealthObject.static.HEALTH_IMG=love.graphics.newImage("Resources/gfx/health.png")

--constructor
function HealthObject:initialize(space,posx,posy)

  HarvestableObject.initialize(self,space,HealthObject.static.HEALTH_IMG,posx,posy,-20)
end

function HealthObject:toString()
	return "health"
end