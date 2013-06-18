require 'GameFrameWork/SpaceObject'

TileBlock = class('GameFrameWork.Harverstables.TileBlock',SpaceObject)

--constructor
function TileBlock:initialize(space,tile,x,y)
  self._tile=tile
  SpaceObject.initialize(self,space,tile,x,y,5000)
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

function TileBlock:pilot(dt)
  
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
  if  player_x>=my_space:getPlayerBackGroundScroll() then

        x=x-self._timingCadence

        player_x=player:getPositionX()
        delta_x=player:getPositionX()-my_space:getPlayerBackGroundScroll()
        


        -- scrolling the posX to the left
       -- scrolling the posX to the left
        
        if delta_x<=0 then
          self._timingCadence=2
        elseif delta_x<=40 then
          self._timingCadence=3
        elseif delta_x<=80 then
          self._timingCadence=4
        else
          self._timingCadence=5
        end
  end

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