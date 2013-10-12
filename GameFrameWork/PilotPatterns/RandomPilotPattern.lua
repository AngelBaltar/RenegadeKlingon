require 'GameFrameWork/PilotPatterns/PilotPattern'
require 'GameFrameWork/PilotPatterns/AvoidCollisionPilotPattern'

RandomPilotPattern = class('GameFrameWork.PilotPatterns.RandomPilotPattern',PilotPattern)

--constructor
function RandomPilotPattern:initialize(ship)
    PilotPattern.initialize(self,ship)
    self._timer=0
    self._directionX=-1
    self._directionY=1
    self._avoidCollision=AvoidCollisionPilotPattern:new(ship)
end

function RandomPilotPattern:setShip(ship)
  PilotPattern.setShip(self,ship)
  self._avoidCollision:setShip(ship)
end

function RandomPilotPattern:pilot(dt)
  
  local ship=self:getShip()

  SpaceObject.pilot(ship,dt)
  
  if not ship:isEnabled() then
    return nil
  end

  local speed=ship:getSpeed()
  local my_space=ship:getSpace()
  local x_i=my_space:getXend()/4
  local x_e=my_space:getXend()-ship:getWidth()

  local y_i=my_space:getYinit()
  local y_e=my_space:getYend()-ship:getHeight()

  local pos_x=ship:getPositionX()
  local pos_y=ship:getPositionY()
  local tile_blocks=my_space:getAllTileBlocks()
  local collision=false
  
  ship._weapon:fire()


if(self._timer>0.8) then
    self._directionY=self._directionY*-2
end

  if(self._timer>1) then
    self._directionX=self._directionX*-2
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

  ship:setPosition(pos_x+self._directionX*speed,pos_y+self._directionY*speed)
  local collides=self._avoidCollision:pilot(dt)
  if(collides) then
    self._directionX=self._directionX*-1
    self._directionY=self._directionY*-1
  end
end