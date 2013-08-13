require 'Utils/middleclass/middleclass'
require	'Utils/GameConfig'

Menu = class('Menu') 

local config=GameConfig.getInstance()

function Menu:initialize(X,Y)
	self._itemsList={}
	self._insertAt=0
	self._focus=0
	self._posX=X
	self._posY=Y
end

function Menu:addItem(item)
	self._itemsList[self._insertAt]=item
	self._insertAt=self._insertAt+1
end

function Menu:print()
	i=0
	tittle="a"
	x=self._posX
	y=self._posY
	while (i<self._insertAt) do
		   if(self._focus==i) then
		   	love.graphics.setColor(0,255,0,255)
		   else
		   	love.graphics.setColor(255,0,0,255)
		   end
           love.graphics.print(self._itemsList[i], x, y)
           y=y+love.graphics.getFont():getHeight()+3
           i=i+1
    end
end

function Menu:readPressed()
	i=0
	if(config:isDownDown()) then
		self._focus=self._focus+1
	end
	if(config:isDownUp()) then
		self._focus=self._focus-1
	end
	if(config:isDownEnter()) then
		return self._focus+1
	end
	self._focus=self._focus%self._insertAt
    return 0
end
