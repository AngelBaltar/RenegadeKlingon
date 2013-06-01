require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Bullet'

Enemy = class('GameFrameWork.Enemy',SpaceObject)

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Enemy:initialize(space)
  self._ship=love.graphics.newImage("Resources/federation1.png")
  
  --100 health for the enemy
  SpaceObject.initialize(self,space, self._ship,100,300,500)
  --place it in free space
  space:placeOnfreeSpace(self)
end

--return the width of this ship
function Enemy:getWidth()
	return self._ship:getWidth()
end

--return the height of this ship
function Enemy:getHeight()
	return self._ship:getHeight()
end

--Performs movements changing the position of the object, firing bullets...
function Enemy:pilot(dt)
   local step=4
  local position_x=SpaceObject.getPositionX(self)
  local position_y=SpaceObject.getPositionY(self)
  local my_space=SpaceObject.getSpace(self)
  --SpaceObject.setPositionY(self,position_y-1)

 local shot_emit_x=position_x-1
 local shot_emit_y=position_y+self:getHeight()/2
 local player=my_space:getPlayerShip()
 if(player==nil) then
    return --no enemy to kill
 end
 local player_x=player:getPositionX()
 local player_y=player:getPositionY()
 
 if(math.abs(position_y-player_y)<5) then --shoot that guy
    Bullet:new(my_space,shot_emit_x,shot_emit_y,-6,0)
 else
    if(player_y>position_y) then
        self:setPositionY(position_y+step)
    else
        self:setPositionY(position_y-step)
    end
 end

end

--Read from keyboard
function Enemy:keypressed(key, unicode)

end

--im the enemy, ovewritting from SpaceObject
function Enemy:isEnemyShip()
	return true
end