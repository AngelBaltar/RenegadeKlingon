function newCuadrado(l)
  local Cuadrado={
      lado=l;
      Area = function(self)
         return self.lado*self.lado
      end;
  }
  return Cuadrado;
end