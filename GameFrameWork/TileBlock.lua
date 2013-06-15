require 'GameFrameWork/SpaceObject'

TileBlock = class('GameFrameWork.Harverstables.TileBlock',SpaceObject)

--constructor
function TileBlock:initialize(space,tile_img_path,x,y)
  local tile_img=love.graphics.newImage(tile_img_path)
  SpaceObject.initialize(self,space,tile_img,x,y,5000)
  self._timingCadence=1
end


function TileBlock:collision(object,damage)
    if not object:isTileBlock() then
      SpaceObject.collision(self,object,damage)
    end
end

function TileBlock:getWidth()
  local obj=SpaceObject.getDrawableObject(self)
 return obj:getWidth()
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_TileBlock.png")
function TileBlock:getHeight()
  local obj=SpaceObject.getDrawableObject(self)
 return obj:getHeight()
end

function TileBlock:pilot(dt)
  
  local my_space=self:getSpace()
  local player=my_space:getPlayerShip()
  local x=self:getPositionX()


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

  self:setPositionX(x)

end


--im the TileBlock, ovewritting from SpaceObject
function TileBlock:isTileBlock()
	return true
end