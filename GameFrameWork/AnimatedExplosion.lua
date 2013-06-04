require 'middleclass/middleclass'
require 'GameFrameWork/Explosion'
require 'Utils/Animation'

AnimatedExplosion = class('GameFrameWork.AnimatedExplosion',Explosion)



--ps:setColor(255,255,255,255,255,255,255,0)
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function AnimatedExplosion:initialize(space,x,y,sizex,sizey,animation_path)
  local spritesheet = love.graphics.newImage(animation_path) --load the spritesheet image
  spritesheet:setFilter("nearest", "nearest") 
  self._sizeX=sizex      
  self._sizeY=sizey      
  --define the interpolation method used by love when it resizes the spritesheet image
  self._animation = newAnimation(spritesheet, self._sizeX, self._sizeY, 0.2, 16)
  self._animation:setMode("once")
  Explosion.initialize(self,space,x,y,spritesheet)
end

--Performs movements changing the position of the object, firing AnimatedExplosions...
function AnimatedExplosion:pilot(dt)
      self._animation:update(dt)
      if not self._animation:isPlaying() then
        self:die()
      end
end

function AnimatedExplosion:draw()

  self._animation:draw(SpaceObject.getPositionX(self), SpaceObject.getPositionY(self),0,2) 
  --draw the animation object at (16, 16), upright (0 degree), and scale it up 4 times
end