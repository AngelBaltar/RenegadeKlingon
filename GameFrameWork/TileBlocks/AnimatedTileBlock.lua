require 'GameFrameWork/TileBlocks/TileBlock'
require 'Utils/Animation'

AnimatedTileBlock = class('GameFrameWork.AnimatedTileBlock',TileBlock)

AnimatedTileBlock.static.FIRE_BALL = love.graphics.newImage("Resources/gfx/fire_ball.png")

local animation_tab={}
animation_tab[AnimatedTileBlock.static.FIRE_BALL]={size_x=128,
                                                    size_y=128,
                                                    n_steps=10,
                                                    mode="loop",
                                                    zoom=1,
                                                    health=10000}

--constructor
function AnimatedTileBlock:initialize(space,tile,x,y,AnimatedTileBlock_type)
  --3 health for the AnimatedTileBlock
  self._AnimatedTileBlock_type=AnimatedTileBlock_type

  self._animation = newAnimation(AnimatedTileBlock_type,
  					animation_tab[AnimatedTileBlock_type].size_x,
  					animation_tab[AnimatedTileBlock_type].size_y, 0.2, animation_tab[AnimatedTileBlock_type].n_steps)
  self._animation:setMode(animation_tab[AnimatedTileBlock_type].mode)
  TileBlock.initialize(self,space,tile,x,y,animation_tab[AnimatedTileBlock_type].health)
  

end


function AnimatedTileBlock:pilot(dt)
	TileBlock.pilot(self,dt)
	self._animation:update(dt)
end

--return the width of this ship
function AnimatedTileBlock:getWidth()
  return self._animation:getWidth()
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_AnimatedTileBlock.png")
function AnimatedTileBlock:getHeight()
  return self._animation:getHeight()
end

function AnimatedTileBlock:draw()

  self._animation:draw(SpaceObject.getPositionX(self), SpaceObject.getPositionY(self),0,
                      animation_tab[self._AnimatedTileBlock_type].zoom) 
end