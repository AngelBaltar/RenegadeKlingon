require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Bullet'
require 'GameFrameWork/Explosions/AnimatedExplosion'
require 'GameFrameWork/Weapons/DestructorKlingonBasicWeapon'

PlayerShip = class('GameFrameWork.PlayerShip',SpaceObject)

PlayerShip.static.SHIP = love.graphics.newImage("Resources/gfx/destructor_klingon.png")
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function PlayerShip:initialize(space)
  --100 health for the player
  SpaceObject.initialize(self,space, PlayerShip.static.SHIP,0,400,100)
  self._basic_weapon=DestructorKlingonBasicWeapon:new(self)
end

--return the width of this ship
function PlayerShip:getWidth()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getWidth()
end

--return the height of this ship
function PlayerShip:getHeight()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getHeight()
end

function PlayerShip:die()
  local my_space=SpaceObject.getSpace(self)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  AnimatedExplosion:new(my_space,x,y,64,64,"Resources/gfx/explosion.png")
  SpaceObject.die(self)
end

function PlayerShip:collision(object,damage)
  --my bullets do not hit me
  if not ( object:isBullet() and object:getEmmiter():isPlayerShip()) then
    SpaceObject.collision(self,object,damage)
  end
end

--Performs movements changing the position of the object, firing bullets...
function PlayerShip:pilot(dt)
   local step=4
  local position_x=SpaceObject.getPositionX(self)
  local position_y=SpaceObject.getPositionY(self)
  local my_space=SpaceObject.getSpace(self)

  local inf_y=my_space:getYinit()+4
  local inf_x=my_space:getXinit()+4

  local sup_y=my_space:getYend()-self:getHeight()-4
  local sup_x=my_space:getXend()-self:getWidth()-4

  if love.keyboard.isDown("up") then
    if(position_y>inf_y)then
      SpaceObject.setPositionY(self,position_y-step)
    end
   end
  if love.keyboard.isDown("down") then
    if(position_y<sup_y)then
      SpaceObject.setPositionY(self,position_y+step)
    end
   end

   if love.keyboard.isDown("left") then
    if(position_x>inf_x)then
      SpaceObject.setPositionX(self,position_x-step)
    end
   end
  if love.keyboard.isDown("right") then
    if(position_x<sup_x)then
      SpaceObject.setPositionX(self,position_x+step)
    end
   end
end

--Read from keyboard
function PlayerShip:keypressed(key, unicode)

   if key=="a" then
    self._basic_weapon:fire()
   end
end

--im the player, ovewritting from SpaceObject
function PlayerShip:isPlayerShip()
	return true
end