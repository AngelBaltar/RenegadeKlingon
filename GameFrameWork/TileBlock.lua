require 'GameFrameWork/SpaceObject'

TileBlock = class('GameFrameWork.Harverstables.TileBlock',SpaceObject)

--constructor
function TileBlock:initialize(space,tile_img_path,x,y)
  local tile_img=love.graphics.newImage(tile_img_path)
  SpaceObject.initialize(self,space,tile_img,x,y,5000)

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

      
      delta_x=player_x-my_space:getPlayerBackGroundScroll()
      if delta_x<=0 then
        x = x - 2 
      elseif delta_x<=40 then
        x = x - 3
      elseif delta_x<=80 then
        x = x - 4
      else
        x = x - 5
      end
  end

  self:setPositionX(x)

end


--im the TileBlock, ovewritting from SpaceObject
function TileBlock:isTileBlock()
	return true
end