require 'middleclass/middleclass'

Menu = class('Menu') 

function Menu:initialize(X,Y)
	self.itemsList={}
	self.insertAt=0
	self.posX=X
	self.posY=Y
end

function Menu:addItem(item)
	self.itemsList[self.insertAt]=item
	self.insertAt=self.insertAt+1
end

function Menu:print()
	i=0
	tittle="a"
	x=self.posX
	y=self.posY
	love.graphics.setColor(255,0,0,255)
	while (i<self.insertAt) do
           love.graphics.print(self.itemsList[i].." "..i+1, x, y)
           y=y+love.graphics.getFont():getHeight()+3
           i=i+1
    end
end

function Menu:read()
	i=0
	
	while (i<self.insertAt) do
           if(love.keyboard.isDown(i+1)) then
           		return i+1
           end
           i=i+1
    end
    return 0
end
