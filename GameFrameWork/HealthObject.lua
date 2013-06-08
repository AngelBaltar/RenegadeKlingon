require 'GameFrameWork/HarvestableObject'


HealthObject = class('GameFrameWork.HealthObject',HarvestableObject)

HealthObject.static.HEALTH_IMG=love.graphics.newImage("Resources/gfx/health.png")

--constructor
function HealthObject:initialize(space)

  HarvestableObject.initialize(self,space,HealthObject.static.HEALTH_IMG,-5)
end