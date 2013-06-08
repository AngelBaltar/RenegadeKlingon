
local debug_enabled=0

function DEBUG(statements)
  
  
  if debug_enabled==1 then
    return loadstring( 'return ' .. statements )()
  end
end

function DEBUG_PRINT(string)
 if debug_enabled==1 then
    print(string)
  end
end