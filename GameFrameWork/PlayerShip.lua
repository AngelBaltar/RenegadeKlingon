require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Explosions/AnimatedExplosion'
require 'GameFrameWork/Weapons/DoubleBasicWeapon'
require 'GameFrameWork/Weapons/MachineGunWeapon'
require 'Utils/Debugging'
require 'Utils/GameConfig'

PlayerShip = class('GameFrameWork.PlayerShip',SpaceObject)

PlayerShip.static.SHIP = love.graphics.newImage("Resources/gfx/destructor_klingon.png")
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function PlayerShip:initialize(space,posx,posy)
  --100 health for the player
  SpaceObject.initialize(self,space, PlayerShip.static.SHIP,posx,posy,100)
  --self._basic_weapon=BasicWeapon:new(self)
  self._basic_weapon=DoubleBasicWeapon:new(self)
  self._autopilot=false
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

function PlayerShip:setWeapon(weapon)
  self._basic_weapon=weapon
  weapon:setAttachedShip(self)
end

function PlayerShip:setAutoPilot(autopilot)
  self._autopilot=autopilot
end

function PlayerShip:die()
  local my_space=SpaceObject.getSpace(self)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  AnimatedExplosion:new(my_space,x,y)
  love.graphics.setColor(255,200,200,255)
  SpaceObject.die(self)
end

function PlayerShip:collision(object,damage)
  --my bullets do not hit me
  if not ( object:isBullet() and object:getEmmiter():isPlayerShip()) then
    SpaceObject.collision(self,object,damage)
  end
end

function PlayerShip:autoPilot(dt)
  local step=200*dt
  local position_x=SpaceObject.getPositionX(self)
  local position_y=SpaceObject.getPositionY(self)
  local my_space=SpaceObject.getSpace(self)
  local enemies=my_space:getEnabledEnemies()
  local nenemies=0
  local fired=false

  local inf_y=my_space:getYinit()+4
  local inf_x=my_space:getXinit()+4

  local sup_y=my_space:getYend()-self:getHeight()-4
  local sup_x=my_space:getXend()-self:getWidth()-4
  local shot_emit_x,shot_emit_y,x_relative_step,y_relative_step=self._basic_weapon:calculateFire()

  
  local enemy=nil
  for obj,_ in pairs(enemies) do
    DEBUG_PRINT("diff with "..obj:toString()..":"..math.abs(obj:getPositionY()-position_y))
    nenemies=nenemies+1
    if math.abs(obj:getPositionY()-shot_emit_y)<=0.3 then
      self._basic_weapon:fire(dt)
      fired=true
      break
    end
    enemy=obj
  end

  if not fired then
      if enemy:getPositionY()>position_y then
          
           if(position_y+step<sup_y)then
              position_y=position_y+step
           end
      else
           if(position_y-step>inf_y)then
            position_y=position_y-step
          end
      end
  end


  if nenemies==0 then
    if(position_x+step<sup_x)then
      position_x=position_x+step
    end
  else
      if(position_x-step>inf_x)then
        position_x=position_x-step
      end
  end

  self:setPosition(position_x,position_y)
  return nil
end

--Performs movements changing the position of the object, firing bullets...
function PlayerShip:pilot(dt)
  if not self:isEnabled() then
    return nil
  end
  if self._autopilot then
    return self:autoPilot(dt)
  end
  local step=200*dt
  local position_x=SpaceObject.getPositionX(self)
  local position_y=SpaceObject.getPositionY(self)
  local my_space=SpaceObject.getSpace(self)

  local inf_y=my_space:getYinit()+4
  local inf_x=my_space:getXinit()+4

  local sup_y=my_space:getYend()-self:getHeight()-4
  local sup_x=my_space:getXend()-self:getWidth()-4

  local config=GameConfig.getInstance()

  if config:isDownUp() then
    if(position_y-step>inf_y)then
      position_y=position_y-step
    end
   end
  if config:isDownDown() then
    if(position_y+step<sup_y)then
      position_y=position_y+step
    end
   end

   if config:isDownLeft() then
    if(position_x-step>inf_x)then
      position_x=position_x-step
    end
   end
  if config:isDownRight() then
    if(position_x+step<sup_x)then
      position_x=position_x+step
    end
   end
  if config:isDownFire() then
    self._basic_weapon:fire(dt)
   end
   self:setPosition(position_x,position_y)
end

function PlayerShip:toString()
  return "player"
end

--im the player, ovewritting from SpaceObject
function PlayerShip:isPlayerShip()
	return true
end
