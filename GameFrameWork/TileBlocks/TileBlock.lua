require 'GameFrameWork/SpaceObject'
require 'Utils/Debugging'

TileBlock = class('GameFrameWork.TileBlocks.TileBlock',SpaceObject)

--constructor
function TileBlock:initialize(space,tile,x,y,health)
  self._tile=tile
  self._backgroundDistance=1
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


  local step=100*dt/self._backgroundDistance
  local my_space=self:getSpace()
  local x=self:getPositionX()
  local y=self:getPositionY()

  x=x-my_space:getBackGroundCadence()*step
  self:setPosition(x,y)
end

--Draws the object in the screen
function TileBlock:draw()
  local x=self:getPositionX()
  local y=self:getPositionY()
  self._tile:draw(x, y, 0, 1, 1, 0,0)
end


--im the TileBlock, ovewritting from SpaceObject
function TileBlock:isTileBlock()
	return true
end

function TileBlock:toString()
  return "tile"
end