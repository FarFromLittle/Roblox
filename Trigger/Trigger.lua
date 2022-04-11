export type Trigger = {
	Touched:RBXScriptSignal;
	TouchEnded:RBXScriptSignal;
}

local Trigger = {}

function Trigger.new(touchPart:BasePart, partFilter:(BasePart)->(BasePart)):Trigger
	local conn:RBXScriptConnection
	local touchCount:{[BasePart]:number} = {}
	local touched:BindableEvent = Instance.new("BindableEvent")
	local touchEnded:BindableEvent = Instance.new("BindableEvent")
	
	local self = {
		Touched = touched.Event,
		TouchEnded = touchEnded.Event
	}
	
	local function onTouchEnded(hit:BasePart)
		if partFilter then
			hit = partFilter(hit)
			if not hit then return end
		end
		
		-- Give time to twitch
		task.wait()
		
		-- Adjust touch count
		touchCount[hit] -= 1
		
		-- Sink all but last event
		if 0 < touchCount[hit] then return end
		
		-- Remove touch counter
		touchCount[hit] = nil
		
		if conn.Connected then
			conn:Disconnect()
		end
		
		-- End touch
		touchEnded:Fire(hit)
	end
	
	touchPart.Touched:Connect(function (hit:BasePart)
		if partFilter then
			hit = partFilter(hit)
			if not hit then return end
		end
		
		if touchCount[hit] then
			touchCount[hit] += 1
			return
		end
		
		-- Intiate touch counter
		touchCount[hit] = 1
		
		-- Connect touchEnded
		conn = touchPart.TouchEnded:Connect(onTouchEnded)
		
		-- Begin touch
		touched:Fire(hit)
	end)
	
	return setmetatable(self, Trigger)
end

return Trigger
