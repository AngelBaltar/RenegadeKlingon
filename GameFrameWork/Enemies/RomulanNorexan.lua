require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Weapons/EnemyBasicWeapon'
require 'GameFrameWork/Enemies/Enemy'
require 'GameFrameWork/Explosions/AnimatedExplosion'
require 'GameFrameWork/PilotPatterns/RandomPilotPattern'

RomulanNorexan = class('GameFrameWork.Enemies.RomulanNorexan',Enemy)


RomulanNorexan.static.SHIP = love.graphics.newImage("Resources/gfx/RomulanNorexan.png")
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function RomulanNorexan:initialize(space,posx,posy)
  Enemy.initialize(self,space,RomulanNorexan.static.SHIP,posx,posy,50,3)
  self._randomMove=RandomPilotPattern:new(self)
  self._weapon=EnemyBasicWeapon:new(self)
end

--return the width of this ship
function RomulanNorexan:getWidth()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getWidth()
end

--return the height of this ship
function RomulanNorexan:getHeight()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getHeight()
end

--Performs movements changing the position of the object, firing bullets...
function RomulanNorexan:pilot(dt)
  self._randomMove:pilot(dt)
end