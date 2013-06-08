require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Bullet'
require 'GameFrameWork/Enemy'
require 'GameFrameWork/AnimatedExplosion'

RomulanScout = class('GameFrameWork.RomulanScout',Enemy)

local SHOOT_CADENCE=0.5

RomulanScout.static.SHIP = love.graphics.newImage("Resources/gfx/RomulanScout.png")
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function RomulanScout:initialize(space)
  self._last_shoot=1
  Enemy.initialize(self,space,RomulanScout.static.SHIP,6)
  
end

function RomulanScout:die()
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
function RomulanScout:getWidth()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getWidth()
end

--return the height of this ship
function RomulanScout:getHeight()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getHeight()
end

--Performs movements changing the position of the object, firing bullets...
function RomulanScout:pilot(dt)
  local step=1
  local position_x=SpaceObject.getPositionX(self)
  local position_y=SpaceObject.getPositionY(self)
  local my_space=SpaceObject.getSpace(self)
  local direction=-1

  if(position_x>200) then
    direction=-1
  end
  if(position_y<100) then
    direction=1
  end
  --SpaceObject.setPositionY(self,position_y-1)
 local shot_emit_x=position_x-15
 local shot_emit_y=position_y+self:getHeight()/2
 local player=my_space:getPlayerShip()
 if(player==nil) then
    return --no enemy to kill
 end
 local player_x=player:getPositionX()
 local player_y=player:getPositionY()
 
 local delta_x=-3
 local delta_y=3*((player_y-position_y)/(math.abs(player_x-position_x)))
 self._last_shoot=self._last_shoot+dt
 if(self._last_shoot>SHOOT_CADENCE) then
      Bullet:new(my_space,shot_emit_x,shot_emit_y,delta_x,delta_y,Bullet.static.BLUE_BULLET)
      self._last_shoot=0
 end
 self:setPositionX(position_x+step*direction)
 --self:setPositionY(position_y+step*direction)

end