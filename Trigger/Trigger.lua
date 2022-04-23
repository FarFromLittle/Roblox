--[[ Trigger - A ModuleScript by FarFromLittle ]]

export type Trigger = {
	Touched:RBXScriptSignal,
	TouchEnded:RBXScriptSignal
}

local Trigger = {}

function Trigger.new(touchPart:BasePart, debounce:number?, partFilter:(BasePart)->(any)?, ...:any):Trigger
	local touched = Instance.new("BindableEvent")
	local touchEnded = Instance.new("BindableEvent")
	local extra = ...
	
	local self = {
		Touched = touched.Event,
		TouchEnded = touchEnded.Event
	}
	
	local touches = {}
	local skipCount = {}
	
	touchPart.TouchEnded:Connect(function (hit)
		if touches[hit] then hit, touches[hit] = touches[hit] end
		
		if not skipCount[hit] then return end
		
		task.wait(debounce)
		
		if 0 < skipCount[hit] then
			skipCount[hit] -= 1
			return
		end
		
		skipCount[hit] = nil
		
		return touchEnded:Fire(hit)
	end)
	
	touchPart.Touched:Connect(function (hit)
		if partFilter then
			local res = partFilter(hit, extra)
			if not res then return end
			touches[hit] = res
			hit = res
		end
		
		if skipCount[hit] then
			skipCount[hit] += 1
			return
		end
		
		skipCount[hit] = 0
		
		return touched:Fire(hit)
	end)
	
	setmetatable(self, Trigger)
	
	return self
end

return Trigger
