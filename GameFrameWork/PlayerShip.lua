require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Bullet'
require 'GameFrameWork/AnimatedExplosion'

PlayerShip = class('GameFrameWork.PlayerShip',SpaceObject)

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function PlayerShip:initialize(space)
  local ship=love.graphics.newImage("Resources/destructor_klingon.png")
  --100 health for the player
  SpaceObject.initialize(self,space, ship,0,400,100)
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
  --AnimatedExplosion:new(my_space,x,y,64,64,"Resources/explosion.png")
  SpaceObject.die(self)
end

--Performs movements changing the position of the object, firing bullets...
function PlayerShip:pilot(dt)
   local step=4
  local position_x=SpaceObject.getPositionX(self)
  local position_y=SpaceObject.getPositionY(self)
  local my_space=SpaceObject.getSpace(self)

  local inf_y=my_space:getYinit()+4
  local inf_x=my_space:getXinit()+4

  local sup_y=my_space:getYend()-self:getHeight()
  local sup_x=my_space:getXend()-self:getWidth()

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

   
   --actualize positions now
   local position_x=SpaceObject.getPositionX(self)
   local position_y=SpaceObject.getPositionY(self)
   local shot_emit_x=position_x+self:getWidth()
   local shot_emit_y=position_y+self:getHeight()/2
   local my_space=SpaceObject.getSpace(self)
   local x_relative_step=0
   local y_relative_step=0

   local shot_emit_x=0
   local shot_emit_y=0
   shot_emit_x=position_x+self:getWidth()+1
   shot_emit_y=position_y+self:getHeight()/2

   if key=="a" then
     Bullet:new(my_space,shot_emit_x,shot_emit_y,6+x_relative_step,0+y_relative_step,"Resources/red_bullet.png")
   end
end

--im the player, ovewritting from SpaceObject
function PlayerShip:isPlayerShip()
	return true
end
