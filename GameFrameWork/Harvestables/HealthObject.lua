require 'GameFrameWork/Harvestables/HarvestableObject'


HealthObject = class('GameFrameWork.Harverstables.HealthObject',HarvestableObject)

HealthObject.static.HEALTH_IMG=love.graphics.newImage("Resources/gfx/health.png")

--constructor
function HealthObject:initialize(space,posx,posy)

  HarvestableObject.initialize(self,space,HealthObject.static.HEALTH_IMG,posx,posy,-5)
end