require 'GameFrameWork/SpaceObject'

Explosion = class('GameFrameWork.Explosions.Explosion',SpaceObject)



--ps:setColor(255,255,255,255,255,255,255,0)
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Explosion:initialize(space,x,y,drawable)
  SpaceObject.initialize(self,space,drawable,x,y,0)

end

--the explosions do not collide
--overwrite it as nothing
function Explosion:collision(object,damage)

end


--return the width of this explosion
function Explosion:getWidth()
	return 0
end

--return the height of this explosion
function Explosion:getHeight()
	return 0
end


--im the Explosion, ovewritting from SpaceObject
function Explosion:isExplosion()
	return true
end

function Explosion:toString()
  return "explosion"
end