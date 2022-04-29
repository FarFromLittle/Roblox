--[[
Trigger | Proximity-based Interactions w/ Touched!
By FarFromLittle

For details, visit: https://devforum.roblox.com/t/trigger-proximity-based-interactions-w-touched/1765730

Trigger.new(touchPart, debounce, partFilter, ...)

|    NAME    |   TYPE   | DEFAULT | DESCRIPTION
|  touchPart | BasePart |         | Part to listen for touch events. CanCollide must be false.
|   debounce |   number |    0    | Disconnect delay; represents minimum touch time.
| partFilter | function |   nil   | Part predicate used for filtering.
|        ... |  Variant |   nil   | Extra *partFilter* arguments.

--]]

export type Trigger = {
	BasePart:BasePart,
	Debounce:number,
	FilterExtra:{any}|false?,
	PartFilter:(hit:BasePart, ...any?)->()?,
	Touched:RBXScriptSignal,
	TouchEnded:RBXScriptSignal,
	TouchingParts:{[BasePart]:any},
	TouchingResults:{[any]:number}
}

local Trigger = {}

local HumanoidRootPart:"HumanoidRootPart" = "HumanoidRootPart"

--[[ Begin Filters ]]

function Trigger.Attribute(otherPart:BasePart, attribute:string, value:any)
	return otherPart:GetAttribute(attribute) == value and otherPart or false
end

function Trigger.Character(otherPart:BasePart, player:Player?)
	local mdl = otherPart.Parent.ClassName == "Model" and otherPart.Parent or otherPart:FindFirstAncestorOfClass("Model")
	if player then return mdl == player.Character and mdl end
	return if mdl:FindFirstChildOfClass("Humanoid") then mdl else false
end

function Trigger.Collection(otherPart, tagName)
	return game.CollectionService:HasTag(otherPart, tagName) and otherPart
end

function Trigger.Model(otherPart:BasePart)
	return if otherPart.Parent.ClassName ~= "Model" then otherPart.Parent:FindFirstAncestorOfClass("Model") or false else otherPart.Parent 
end

function Trigger.Player(otherPart:BasePart, player:Player?)
	local mdl = otherPart.Parent.ClassName == "Model" and otherPart.Parent or otherPart.Parent:FindFirstAncestorOfClass("Model")
	if not mdl then return false end
	if player then return mdl == player.Character and player end
	return game.Players:GetPlayerFromCharacter(mdl) or false
end

function Trigger.Property(otherPart:BasePart, property:string, value:any)
	return otherPart[property] == value and otherPart
end

--[[ End Filters ]]

local function ontouch(self, part, event)
	if self.TouchingParts[part] or part.Name == HumanoidRootPart then return end
	
	if self.PartFilter then
		local res
		
		if self.FilterExtra then
			res = self.PartFilter(part, unpack(self.FilterExtra))
		else
			res = self.PartFilter(part)
		end
		
		if not res then return end
		
		self.TouchingParts[part], part = res, res
	end
	
	if self.TouchingResults[part] then
		self.TouchingResults[part] += 1
		return
	end
	
	self.TouchingResults[part] = 0
	
	return event:Fire(part)
end

local function ontouchend(self, part, event)
	part, self.TouchingParts[part] = self.TouchingParts[part], nil
	
	if not self.TouchingResults[part] then return end
	
	task.wait(self.Debounce)
	
	if 0 < self.TouchingResults[part] then
		self.TouchingResults[part] -= 1
		return
	end
	
	self.TouchingResults[part] = nil
	
	return event:Fire(part)
end

function Trigger.new(basePart:BasePart, debounce:number?, partFilter:(BasePart)->(any)?, ...:any?):Trigger
	assert(basePart:IsA("BasePart"), "Trigger: basePart must be a BasePart.")
	assert(debounce == nil or 0 <= debounce, "Trigger: debounce must be a number >= 0.")
	assert(partFilter == nil or type(partFilter) == "function", "Trigger: partFilter must be a function.")
	
	local touched = Instance.new("BindableEvent")
	local touchEnded = Instance.new("BindableEvent")
	
	local self = {
		BasePart = basePart,
		Debounce = debounce or 0,
		FilterExtra = if 0 < select("#", ...) then {...} else false,
		PartFilter = partFilter,
		TouchingParts = {},
		TouchingResults = {},
		Touched = touched.Event,
		TouchEnded = touchEnded.Event
	}
	
	basePart.Touched:Connect(function (otherPart)
		return ontouch(self, otherPart, touched)
	end)
	
	basePart.TouchEnded:Connect(function (otherPart)
		return ontouchend(self, otherPart, touchEnded)
	end)
	
	return setmetatable(self, Trigger)
end

return Trigger
