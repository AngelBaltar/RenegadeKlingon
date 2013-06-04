require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Bullet'
require 'GameFrameWork/AnimatedExplosion'

Enemy = class('GameFrameWork.Enemy',SpaceObject)

local SHOOT_CADENCE=0.07

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Enemy:initialize(space)
  local ship=love.graphics.newImage("Resources/gfx/federation1.png")
  
  self._last_shoot=1
  --100 health for the enemy
  SpaceObject.initialize(self,space, ship,100,300,100)
  --place it in free space
  space:placeOnfreeSpace(self)
end

function Enemy:die()
  local my_space=SpaceObject.getSpace(self)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  
  --it only causes explosion if dies because a collision
  --no by out of bounds
  SpaceObject.die(self)
  if my_space:isInBounds(self) then
    AnimatedExplosion:new(my_space,x,y,64,64,"Resources/gfx/explosion.png")
  end
end

--return the width of this ship
function Enemy:getWidth()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getWidth()
end

--return the height of this ship
function Enemy:getHeight()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getHeight()
end

--Performs movements changing the position of the object, firing bullets...
function Enemy:pilot(dt)
   local step=4
  local position_x=SpaceObject.getPositionX(self)
  local position_y=SpaceObject.getPositionY(self)
  local my_space=SpaceObject.getSpace(self)
  --SpaceObject.setPositionY(self,position_y-1)

 local shot_emit_x=position_x-6
 local shot_emit_y=position_y+self:getHeight()/2
 local player=my_space:getPlayerShip()
 if(player==nil) then
    return --no enemy to kill
 end
 local player_x=player:getPositionX()
 local player_y=player:getPositionY()
 
 self._last_shoot=self._last_shoot+dt
 if(math.abs(position_y-player_y)<5)  then --shoot that guy
    if(self._last_shoot>SHOOT_CADENCE) then
      Bullet:new(my_space,shot_emit_x,shot_emit_y,-6,0,"Resources/gfx/blue_bullet.png")
      self._last_shoot=0
    end
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