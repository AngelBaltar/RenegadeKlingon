require 'middleclass/middleclass'

Menu = class('Menu') 

function Menu:initialize(X,Y)
	self._itemsList={}
	self._insertAt=0
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
	love.graphics.setColor(255,0,0,255)
	while (i<self._insertAt) do
           love.graphics.print(self._itemsList[i].." "..i+1, x, y)
           y=y+love.graphics.getFont():getHeight()+3
           i=i+1
    end
end

function Menu:read()
	i=0
	
	while (i<self._insertAt) do
           if(love.keyboard.isDown(i+1)) then
           		return i+1
           end
           i=i+1
    end
    return 0
end
