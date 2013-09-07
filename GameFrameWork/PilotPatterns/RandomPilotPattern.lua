require 'GameFrameWork/PilotPatterns/PilotPattern'

RandomPilotPattern = class('GameFrameWork.PilotPatterns.RandomPilotPattern',PilotPattern)

--constructor
function RandomPilotPattern:initialize(ship)
    PilotPattern.initialize(self,ship)
    self._timer=0
    self._directionX=-1
    self._directionY=1
end

function RandomPilotPattern:pilot(dt)
  
  local ship=self:getShip()

  SpaceObject.pilot(ship,dt)
  
  if not ship:isEnabled() then
    return nil
  end

  local my_space=ship:getSpace()
  local x_i=my_space:getXend()/4
  local x_e=my_space:getXend()-ship:getWidth()

  local y_i=my_space:getYinit()
  local y_e=my_space:getYend()-ship:getHeight()

  local pos_x=ship:getPositionX()
  local pos_y=ship:getPositionY()
  local tile_blocks=my_space:getAllTileBlocks()
  local collision=false
  local rnd1=0
  local rnd2=0
  local rnd3=0
  local dir1=1
  local dir2=1
  local iter=0
  local iter_max=10
  
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

  ship:setPosition(pos_x+self._directionX,pos_y+self._directionY)

  collision=false
  for obj,_ in pairs(tile_blocks) do
    collision=collision or my_space:naturalCollisionCheck(obj,ship)
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

  ship:setPosition(pos_x+rnd1*dir1,pos_y+rnd1*dir2)
  collision=false
  for obj,_ in pairs(tile_blocks) do
    collision=collision or my_space:naturalCollisionCheck(obj,ship)
    if collision then
      break
    end
  end
end
end