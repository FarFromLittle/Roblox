function addStyle(obj, dfn)
	local i, val, _type
	
	-- Parenting done last
	local _parent = dfn.Parent or nil
	dfn.Parent = nil
	
	-- Iterate indexed values first
	for i = 1, #dfn do
		val = dfn[i]
		_type = typeof(val)
		if _type == "table" then addStyle(obj, val) -- Style declaration
		elseif _type == "function" then val(obj) -- Modifier
		else -- Add as child
			if val.LayoutOrder then val.LayoutOrder = i end -- Maintain order for guis
			val.Parent = obj
		end
		dfn[i] = nil
	end
	
	-- Associate values last (Named values aren't overidden)
	for i, val in pairs(dfn) do
		_type = type(val)
		if _type == "table" then -- Arguments passed
			_type = typeof(obj[i]) -- Get target type
			if _type == "function" then obj[i](unpack(val)) -- Method with no return (Tweens)
			else obj[i] = getfenv(0)[_type].new(unpack(val)) -- Create new datatype
			end
		elseif _type == "function" and typeof(obj[i]) == "RBXScriptSignal" then obj[i]:Connect(val) -- Event hook
		else obj[i] = val
		end
	end
	
	if _parent then obj.Parent = _parent end
	
	return obj
end

function NewInstance(obj)
	if type(obj) == "string" then obj = Instance.new(obj)
	else assert(typeof(obj) == "Instance", "Expected instance. Got "..typeof(obj)..".")
		obj = obj:Clone()
	end
	assert(obj, "Failed to create "..tostring(obj)..'.')
	return function (dfn) return addStyle(obj, dfn) end
end

return NewInstance
