require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Bullet'
require 'GameFrameWork/Enemy'
require 'GameFrameWork/AnimatedExplosion'

RomulanScout = class('GameFrameWork.RomulanScout',Enemy)

local SHOOT_CADENCE=0.4

RomulanScout.static.SHIP = love.graphics.newImage("Resources/gfx/RomulanScout.png")
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function RomulanScout:initialize(space)
  self._last_shoot=1
  Enemy.initialize(self,space,RomulanScout.static.SHIP,6)
  self._timer=0
  self._directionX=-1
  self._directionY=1
  local absolute_init_x=space:getXinit()
  local absolule_end_x=space:getXend()-self:getWidth()

  local absolute_init_y=space:getYinit()
  local absolule_end_y=space:getYend()-self:getHeight()
  space:placeOnfreeSpace(self,absolule_end_x-200,absolule_end_x,absolule_end_y-50,absolule_end_y)
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
  local my_space=self:getSpace()
  local x_i=my_space:getXinit()
  local x_e=my_space:getXend()

  local y_i=my_space:getYinit()
  local y_e=my_space:getYend()

  local pos_x=self:getPositionX()
  local pos_y=self:getPositionY()
  

 local shot_emit_x=pos_x-50
 local shot_emit_y=pos_y+self:getHeight()/2
 local player=my_space:getPlayerShip()
 if(player==nil) then
    return --no enemy to kill
 end
 local player_x=player:getPositionX()
 local player_y=player:getPositionY()
 
 local delta_x=-3
 
 local delta_y=3*((player_y-pos_y)/(math.abs(player_x-pos_x)))
 self._last_shoot=self._last_shoot+dt
 
 if(self._last_shoot>SHOOT_CADENCE) then
      Bullet:new(my_space,self,shot_emit_x,shot_emit_y,delta_x,delta_y,Bullet.static.BLUE_BULLET)
      self._last_shoot=0
 end


if(self._timer>0.5) then
    self._directionX=self._directionX*-1
  end

  if(self._timer>1) then
    self._directionY=self._directionY*-1
    self._timer=0
  end

  if (math.abs(pos_x-x_i)<5) then
    self._directionX=1
  end

  if (math.abs(pos_x-x_e)<5) then
    self._directionX=-1
  end

  if (math.abs(pos_y-y_i)<5) then
    self._directionY=1
  end

  if (math.abs(pos_y-y_e)<5) then
    self._directionY=-1
  end

  self:setPositionX(pos_x+self._directionX)
  self:setPositionY(pos_y+self._directionY)

end