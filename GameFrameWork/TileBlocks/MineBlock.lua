require 'GameFrameWork/TileBlocks/TileBlock'
require 'Utils/Animation'
require 'Utils/Debugging'


MineBlock = class('GameFrameWork.TileBlocks.MineBlock',TileBlock)
local MINE1 = love.graphics.newImage("Resources/gfx/mine.png")

local mines_tab={}
mines_tab[0]={     sprite=MINE1,
                        size_x=48,
                        size_y=48,
                        n_steps=3,
                        delay=0.1,
                        mode="loop",
                        zoom=0.7}

--constructor
function MineBlock:initialize(space,tile,x,y)
  local random_mine=0
  self._mine=newAnimation(mines_tab[random_mine].sprite,
                                mines_tab[random_mine].size_x,
                                mines_tab[random_mine].size_y,
                                mines_tab[random_mine].delay,
                                mines_tab[random_mine].n_steps)

  self._mine:setMode(mines_tab[random_mine].mode)
  self._zoom=mines_tab[random_mine].zoom
  TileBlock.initialize(self,space,tile,x,y,50)
  self._mine:play()
end

function MineBlock:die()
  local my_space=SpaceObject.getSpace(self)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  
  --it only causes explosion if dies because a collision
  --no by out of bounds
  SpaceObject.die(self)
  if my_space:isInBounds(self) then
    AnimatedExplosion:new(my_space,x,y)
  end
end

function MineBlock:getWidth()
  return self._mine:getWidth()*self._zoom
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_MineBlock.png")
function MineBlock:getHeight()
  return self._mine:getHeight()*self._zoom
end

function MineBlock:pilot(dt)
  self._mine:update(dt)
  TileBlock.pilot(self,dt)   
end

--Draws the object in the screen
function MineBlock:draw()
  self._mine:draw(SpaceObject.getPositionX(self), SpaceObject.getPositionY(self),0,self._zoom) 
end