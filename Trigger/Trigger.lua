local Trigger = {}

local Part = {} -- Part to be used in the trigger system
local TouchCount = {} -- Touch count for individual parts
local Touches = {} -- Filtered list of touching parts
local Touched = {} -- BindableEvent for Touched
local TouchEnded = {} -- BindableEvent for TouchEnded
local TouchedEvent = {} -- Exposed reference to Touched.Event
local TouchEndedEvent = {} -- Exposed reference to TouchEnded.Event
local TouchedConnection = {} -- Reference to Part.Touched:Connect()
local TouchEndedConnection = {} -- Reference to Part.TouchEnded:Connect()

local ReadOnly = {
	Part = Part,
	Touched = TouchedEvent,
	TouchEnded = TouchEndedEvent
}

function Trigger.__index(self, name)
	return ReadOnly[name] and self[ReadOnly[name]] or nil
end

function Trigger.new(part, pred)
	local touches = {} -- Filtered parts touching
	local touchCount = {} -- Number of times a part is touching
	local touched = Instance.new("BindableEvent")
	local touchEnded = Instance.new("BindableEvent")
	
	if not pred then pred = function (hit) return hit end end
	
	local self = {
		[Part] = part,
		[TouchCount] = touchCount,
		[Touches] = touches,
		[Touched] = touched,
		[TouchEnded] = touchEnded,
		[TouchedEvent] = touched.Event,
		[TouchEndedEvent] = touchEnded.Event
	}

	self[TouchedConnection] = part.Touched:Connect(function (hit)
		hit = pred(hit)

		if not hit then return end

		if not touchCount[hit] then
			touchCount[hit] = 1
		else
			touchCount[hit] += 1
			return
		end

		-- Add to parts touching
		touches[#touches+1] = hit

		-- Begin touch
		touched:Fire(hit)
	end)

	self[TouchEndedConnection] = part.TouchEnded:Connect(function (hit)
		hit = pred(hit)
		
		if not hit then return end

		-- Give time to twitch
		wait()

		-- Adjust touch count
		touchCount[hit] -= 1

		-- Sink all but last event
		if 0 < touchCount[hit] then return end

		-- Remove from touches
		local j for i = #touches, 1, -1 do
			touches[i], j = j, touches[i]
			if j == hit then break end
		end

		-- Remove touch counter
		touchCount[hit] = nil

		-- End touch
		touchEnded:Fire(hit)
	end)
	
	return setmetatable(self, Trigger)
end

function Trigger:Destroy()
	--print("Destroying Trigger")
	
	local touches = self[Touches]
	local touchCount = self[TouchCount]
	
	for n = #touches, 1, -1 do
		self[TouchEnded]:Fire(touches[n])
		touches[n], touchCount[touches[n]] = nil
	end
	
	self[TouchedConnection]:Disconnect()
	self[TouchEndedConnection]:Disconnect()
	
	self[Part], self[Touched], self[TouchEnded], self[TouchedEvent], self[TouchEndedEvent], self[TouchedConnection], self[TouchEndedConnection] = nil
end

return Trigger
