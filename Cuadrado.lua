require 'middleclass/middleclass'

Cuadrado = class('Cuadrado') --this is the same as class('Person', Object) or Object:subclass('Person')
function Cuadrado:initialize(l)
  self.lado = l
end
function Cuadrado:Area()
  return self.lado*self.lado
end