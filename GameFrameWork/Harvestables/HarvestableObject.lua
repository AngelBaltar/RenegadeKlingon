-- /* RenegadeKlingon - LÖVE2D GAME
--  * HarvestableObject.lua
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
require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/PilotPatterns/HarvestablePilotPattern'

HarvestableObject = class('GameFrameWork.Harverstables.HarvestableObject',SpaceObject)

--constructor
function HarvestableObject:initialize(space,drawable,posx,posy,health)
  --3 health for the HarvestableObject
  SpaceObject.initialize(self,space,drawable,posx,posy,health)

  self._pilot_pattern=HarvestablePilotPattern:new(self)
  self._speed=1
end

function HarvestableObject:getSpeed()
  return self._speed
end

function HarvestableObject:collision(object,damage)
     if not (object:isBullet()) and
     not (object:isEnemyShip()) and 
     not (object:isHarvestableObject())then
       self:die()
     end
end


function HarvestableObject:getWidth()
  local obj=SpaceObject.getDrawableObject(self)
 return obj:getWidth()
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_HarvestableObject.png")
function HarvestableObject:getHeight()
  local obj=SpaceObject.getDrawableObject(self)
 return obj:getHeight()
end

function HarvestableObject:pilot(dt)
  self._pilot_pattern:pilot(dt)
end


--im the HarvestableObject, ovewritting from SpaceObject
function HarvestableObject:isHarvestableObject()
	return true
end

function HarvestableObject:toString()
  return "harvestable"
end