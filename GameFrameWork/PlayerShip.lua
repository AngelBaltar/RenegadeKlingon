require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Bullet'

PlayerShip = class('GameFrameWork.PlayerShip',SpaceObject)

local SHOT_CADENCE=0.3
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function PlayerShip:initialize(space)
  self._ship=love.graphics.newImage("Resources/destructor_klingon.png")
  SpaceObject.initialize(self,space, self._ship,0,0)
  self._lastShot=SHOT_CADENCE
end

--return the width of this ship
function PlayerShip:getWidth()
	return self._ship:getWidth()
end

--return the height of this ship
function PlayerShip:getHeight()
	return self._ship:getHeight()
end

--Performs movements changing the position of the object, firing bullets...
function PlayerShip:pilot(dt)
 
end

--Read from keyboard
function PlayerShip:keypressed(key, unicode)
  local step=4
  local position_x=SpaceObject.getPositionX(self)
  local position_y=SpaceObject.getPositionY(self)
  local my_space=SpaceObject.getSpace(self)

  local x_relative_step=0
  local y_relative_step=0

  local shot_emit_x=0
  local shot_emit_y=0


  if key=="up" then
    if(position_y>0)then
      SpaceObject.setPositionY(self,position_y-step)
      y_relative_step=y_relative_step-step
    end
   end
  if key=="down" then
    if(position_y<love.graphics.getHeight()-self:getHeight())then
      SpaceObject.setPositionY(self,position_y+step)
      y_relative_step=y_relative_step+step
    end
   end

   if key=="left" then
    if(position_x>0)then
      SpaceObject.setPositionX(self,position_x-step)
      x_relative_step=x_relative_step-step
    end
   end
  if key=="right" then
    if(position_x<love.graphics.getWidth()-self:getWidth())then
      SpaceObject.setPositionX(self,position_x+step)
      x_relative_step=x_relative_step+step
    end
   end
   
   --actualize positions now
   position_x=SpaceObject.getPositionX(self)
   position_y=SpaceObject.getPositionY(self)
   shot_emit_x=position_x+self:getWidth()
   shot_emit_y=position_y+self:getHeight()/2

   if key=="a" then
        shot_emit_x=
      my_space:addSpaceObject(Bullet:new(my_space,shot_emit_x,shot_emit_y,6+x_relative_step,0+y_relative_step))
      self._lastShot=0
   end
end

--im the player, ovewritting from SpaceObject
function PlayerShip:isPlayerShip()
	return true
end
