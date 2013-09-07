require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Weapons/EnemyBasicWeapon'
require 'GameFrameWork/Enemies/Enemy'
require 'GameFrameWork/Explosions/AnimatedExplosion'

RomulanWarBird = class('GameFrameWork.Enemies.RomulanWarBird',Enemy)


RomulanWarBird.static.SHIP = love.graphics.newImage("Resources/gfx/RomulanWarBird.png")
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function RomulanWarBird:initialize(space,posx,posy)
  Enemy.initialize(self,space,RomulanWarBird.static.SHIP,posx,posy,400)
  self._randomMove=RandomPilotPattern:new(self)
  self._weapon=EnemyBasicWeapon:new(self)
end

--return the width of this ship
function RomulanWarBird:getWidth()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getWidth()
end

--return the height of this ship
function RomulanWarBird:getHeight()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getHeight()
end

--Performs movements changing the position of the object, firing bullets...
function RomulanWarBird:pilot(dt)
    self._randomMove:pilot(dt)
end