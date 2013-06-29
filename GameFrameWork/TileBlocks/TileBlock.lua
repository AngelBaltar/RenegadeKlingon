require 'GameFrameWork/SpaceObject'

TileBlock = class('GameFrameWork.TileBlocks.TileBlock',SpaceObject)

--constructor
function TileBlock:initialize(space,tile,x,y,health)
  self._tile=tile
  if health==nil then
    health=5000
  end
  SpaceObject.initialize(self,space,tile,x,y,health)
  self._timingCadence=1
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
end

function TileBlock:pilot(dt)
  local step=20*dt
  local my_space=self:getSpace()
  local player=my_space:getPlayerShip()
  local x=self:getPositionX()
  local y=self:getPositionY()

  if(player==nil) then
    return nil
  end

  player_x=player:getPositionX()
  local delta_x=0

  -- scrolling the posX to the left
 -- if  player_x>=my_space:getPlayerBackGroundScroll() then

        x=x-self._timingCadence*step

        player_x=player:getPositionX()
        self._timingCadence=my_space:getBackGroundTimingCadence()*2
        self:setPosition(x,y)
 -- end

  

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