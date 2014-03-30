-- /* RenegadeKlingon - LÖVE2D GAME
--  * TileBlock.lua
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
require 'Utils/Debugging'

TileBlock = class('GameFrameWork.TileBlocks.TileBlock',SpaceObject)

--constructor
function TileBlock:initialize(space,tile,x,y,health)
  self._tile=tile
  
  if health==nil then
    health=5000
  end
  SpaceObject.initialize(self,space,tile,x,y,health)
end


function TileBlock:collision(object,damage)
    if not object:isTileBlock() then
      SpaceObject.collision(self,object,damage)
    end
end

function TileBlock:getWidth()
  return self._tile.width
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_TileBlock.png")
function TileBlock:getHeight()
  return self._tile.height
end

function TileBlock:die()
  SpaceObject.die(self)
  --DEBUG_PRINT("tileblock dies\n")
end

function TileBlock:pilot(dt)
  SpaceObject.pilot(self,dt)
end

--Draws the object in the screen
function TileBlock:draw()
  local x=self:getPositionX()
  local y=self:getPositionY()
  --DEBUG_PRINT("draw tileblock "..x.." "..y)
  --love.graphics.draw(self._tile.tileset.image,x,y)
  self._tile:draw(x, y, 0, 1, 1, 0,0)
end


--im the TileBlock, ovewritting from SpaceObject
function TileBlock:isTileBlock()
	return true
end

function TileBlock:toString()
  return "tile"
end