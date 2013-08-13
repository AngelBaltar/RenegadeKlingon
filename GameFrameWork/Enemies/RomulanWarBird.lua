require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Weapons/EnemyBasicWeapon'
require 'GameFrameWork/Enemies/Enemy'
require 'GameFrameWork/Explosions/AnimatedExplosion'

RomulanWarBird = class('GameFrameWork.Enemies.RomulanWarBird',Enemy)


RomulanWarBird.static.SHIP = love.graphics.newImage("Resources/gfx/RomulanWarBird.png")
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function RomulanWarBird:initialize(space,posx,posy)
  Enemy.initialize(self,space,RomulanWarBird.static.SHIP,posx,posy,200)
  self._timer=0
  self._directionX=-1
  self._directionY=1
  local absolute_init_x=space:getXinit()
  local absolule_end_x=space:getXend()-self:getWidth()

  local absolute_init_y=space:getYinit()
  local absolule_end_y=space:getYend()-self:getHeight()
  self._weapon=EnemyBasicWeapon:new(self)
end

--return the width of this ship
function RomulanWarBird:getWidth()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getWidth()
end

--return the height of this ship
function RomulanWarBird:getHeight()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getHeight()
end

--Performs movements changing the position of the object, firing bullets...
function RomulanWarBird:pilot(dt)

  SpaceObject.pilot(self,dt)
  if not self:isEnabled() then
    return nil
  end

  local my_space=self:getSpace()
  local x_i=my_space:getXend()/4
  local x_e=my_space:getXend()-self:getWidth()

  local y_i=my_space:getYinit()
  local y_e=my_space:getYend()-self:getHeight()

  local pos_x=self:getPositionX()
  local pos_y=self:getPositionY()
  local tile_blocks=my_space:getAllTileBlocks()
  local collision=false
  local rnd1=0
  local rnd2=0
  local rnd3=0
  local dir1=1
  local dir2=1
  local iter=0
  local iter_max=10
  
  self._weapon:fire()


if(self._timer>0.8) then
    self._directionY=self._directionY*-3
end

  if(self._timer>1) then
    self._directionX=self._directionX*-3
    self._timer=0
  end

  if (math.abs(pos_x-x_i)<20) then
    self._directionX=1
  end

  if (math.abs(pos_x-x_e)<20) then
    self._directionX=-1
  end

  if (math.abs(pos_y-y_i)<20) then
    self._directionY=1
  end

  if (math.abs(pos_y-y_e)<20) then
    self._directionY=-1
  end

  self:setPosition(pos_x+self._directionX,pos_y+self._directionY)

  collision=false
  for obj,_ in pairs(tile_blocks) do
    collision=collision or my_space:naturalCollisionCheck(obj,self)
    if collision then
      break
    end
  end

iter=0
while collision and iter<iter_max do
  iter=iter+1
  rnd1=math.random(5)
  rnd2=math.random()
  rnd3=math.random()
  self._timer=0
  
 
  if(rnd3>0.5) then
    dir1=1
    self._directionX=self._directionX*-1
  else
    dir1=-1
  end

  if(rnd2>0.5) then
    dir2=1
     self._directionY=self._directionY*-1
  else
    dir2=-1
  end

  self:setPosition(pos_x+rnd1*dir1,pos_y+rnd1*dir2)
  collision=false
  for obj,_ in pairs(tile_blocks) do
    collision=collision or my_space:naturalCollisionCheck(obj,self)
    if collision then
      break
    end
  end
end

end