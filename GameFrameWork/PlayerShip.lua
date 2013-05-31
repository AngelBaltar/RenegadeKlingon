require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Bullet'

PlayerShip = class('GameFrameWork.PlayerShip',SpaceObject)

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function PlayerShip:initialize(space)
  self._ship=love.graphics.newImage("Resources/destructor_klingon.png")
  --100 health for the player
  SpaceObject.initialize(self,space, self._ship,0,400,100)
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
   local step=4
  local position_x=SpaceObject.getPositionX(self)
  local position_y=SpaceObject.getPositionY(self)


  if love.keyboard.isDown("up") then
    if(position_y>0)then
      SpaceObject.setPositionY(self,position_y-step)
    end
   end
  if love.keyboard.isDown("down") then
    if(position_y<love.graphics.getHeight()-self:getHeight())then
      SpaceObject.setPositionY(self,position_y+step)
    end
   end

   if love.keyboard.isDown("left") then
    if(position_x>0)then
      SpaceObject.setPositionX(self,position_x-step)
    end
   end
  if love.keyboard.isDown("right") then
    if(position_x<love.graphics.getWidth()-self:getWidth())then
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
     Bullet:new(my_space,shot_emit_x,shot_emit_y,6+x_relative_step,0+y_relative_step)
   end
end

--im the player, ovewritting from SpaceObject
function PlayerShip:isPlayerShip()
	return true
end
