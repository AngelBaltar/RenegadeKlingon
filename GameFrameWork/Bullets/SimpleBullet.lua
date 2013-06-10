require 'GameFrameWork/Bullets/Bullet'
require 'GameFrameWork/Explosions/ParticleExplosion'


SimpleBullet = class('GameFrameWork.SimpleBullet',Bullet)

SimpleBullet.static.BLUE_BULLET = love.graphics.newImage("Resources/gfx/blue_bullet.png")
SimpleBullet.static.RED_BULLET =love.graphics.newImage("Resources/gfx/red_bullet.png")
--ps:setColor(255,255,255,255,255,255,255,0)
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function SimpleBullet:initialize(space,emmiter,x,y,stepx,stepy,SimpleBullet_type)
  --3 health for the SimpleBullet
  Bullet.initialize(self,space,emmiter,x,y,stepx,stepy,3,SimpleBullet_type)

end

--return the width of this ship
function SimpleBullet:getWidth()
  local bll=Bullet.getDrawableObject(self)
	return bll:getWidth()
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_SimpleBullet.png")
function SimpleBullet:getHeight()
  local bll=Bullet.getDrawableObject(self)
	return bll:getHeight()
end