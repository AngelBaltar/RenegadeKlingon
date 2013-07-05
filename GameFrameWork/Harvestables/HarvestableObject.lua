require 'GameFrameWork/SpaceObject'

HarvestableObject = class('GameFrameWork.Harverstables.HarvestableObject',SpaceObject)

--constructor
function HarvestableObject:initialize(space,drawable,posx,posy,health)
  --3 health for the HarvestableObject
  SpaceObject.initialize(self,space,drawable,posx,posy,health)

  self._directionX=-1
  self._directionY=-1
  self._timer=0
end

function HarvestableObject:collision(object,damage)
     if not (object:isBullet()) and
     not (object:isEnemyShip()) and 
     not (object:isHarvestableObject())then
       self:die()
     end
end


function HarvestableObject:getWidth()
  local obj=SpaceObject.getDrawableObject(self)
 return obj:getWidth()
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_HarvestableObject.png")
function HarvestableObject:getHeight()
  local obj=SpaceObject.getDrawableObject(self)
 return obj:getHeight()
end

function HarvestableObject:pilot(dt)
  SpaceObject.pilot(self,dt)
  if not self:isEnabled() then
    return nil
  end
  
  local my_space=self:getSpace()
  local x_i=my_space:getXinit()
  local x_e=my_space:getXend()-self:getWidth()

  local y_i=my_space:getYinit()
  local y_e=my_space:getYend()-self:getHeight()

  local pos_x=self:getPositionX()
  local pos_y=self:getPositionY()

  self._timer=self._timer+dt
  math.randomseed(self:getHeight()*self:getWidth())
  math.randomseed(math.random())
  if(math.random()>0.5) then
    -- if(self._timer>0.5) then
    --   self._directionX=self._directionX*-1
    -- end

    if(self._timer>1) then
      self._directionY=self._directionY*-1
      self._timer=0
    end
  else
     if(self._timer>0.7) then
      self._directionY=self._directionY*-1
    end

    -- if(self._timer<0.6) then
    --   self._directionX=self._directionX*-1
    --   self._timer=0
    -- end
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

  self:setPosition(pos_x+self._directionX,pos_y+self._directionY)

end


--im the HarvestableObject, ovewritting from SpaceObject
function HarvestableObject:isHarvestableObject()
	return true
end

function HarvestableObject:toString()
  return "harvestable"
end