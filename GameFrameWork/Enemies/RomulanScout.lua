require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Weapons/EnemyBasicWeapon'
require 'GameFrameWork/Enemies/Enemy'
require 'GameFrameWork/Explosions/AnimatedExplosion'

RomulanScout = class('GameFrameWork.Enemies.RomulanScout',Enemy)


RomulanScout.static.SHIP = love.graphics.newImage("Resources/gfx/RomulanScout.png")
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function RomulanScout:initialize(space,posx,posy)
  Enemy.initialize(self,space,RomulanScout.static.SHIP,posx,posy,6)
  self._randomMove=RandomPilotPattern:new(self)
  self._weapon=EnemyBasicWeapon:new(self)
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
  self._randomMove:pilot(dt)
end

function RomulanScout:toString()
  return "RomulanScout"
end