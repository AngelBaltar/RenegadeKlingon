
local debug_enabled=1

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

function enableDebug()
	debug_enabled=1
end

function disableDebug()
	debug_enabled=0
end

function getDebug()
	if debug_enabled==1 then
		return true
	else
		return false
	end
end