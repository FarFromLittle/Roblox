local GuiManager = {}
GuiManager.__index = GuiManager

local activeGui, screenGui = {}, {}
local onGuiAdded, onGuiRemoved, onActiveGuiChanged = {}, {}, {}

function GuiManager.new(scrn)
	assert(typeof(scrn) == "Instance" and scrn:IsA("LayerCollector"), "Expected LayerCollector. Got "..typeof(scrn)..".")
	local self = {}
		self[activeGui] = scrn
		self[screenGui] = scrn
		self[onGuiAdded] = Instance.new("BindableEvent")
		self[onGuiRemoved] = Instance.new("BindableEvent")
		self[onActiveGuiChanged] = Instance.new("BindableEvent")
		
		self.GuiAdded = self[onGuiAdded].Event
		self.GuiRemoved = self[onGuiRemoved].Event
		self.ActiveGuiChanged = self[onActiveGuiChanged].Event
	return setmetatable(self, GuiManager)
end

function GuiManager:AddGui(gui, clr)
	if clr then self[screenGui]:ClearAllChildern() end
	self:SetActiveGui(gui)
	return gui
end

function GuiManager:Contains(gui)
	assert(typeof(gui) == "Instance" and gui:IsA("GuiObject"), "Expected GuiObject. Got "..typeof(gui)..".")
	return gui:IsDescendantOf(self[activeGui])
end

function GuiManager:GetActiveGui()
	return self[activeGui]
end

function GuiManager:RemoveGui(gui)
	assert(self:Contains(gui), "Invalid argument.")
	if gui == self[activeGui] or gui:IsAncestorOf(self[activeGui]) then self:SetActiveGui(gui.Parent) end
	gui.Parent = nil
	self[onGuiRemoved]:Fire(gui)
	return gui
end

function GuiManager:SetActiveGui(gui)
	assert(typeof(gui) == "Instance" and gui:IsA("GuiBase2d"), "Expected GuiObject. Got "..typeof(gui)..".")
	local old = self[activeGui]
	gui.Parent = old
	self[activeGui] = gui
	self[onActiveGuiChanged]:Fire(old, gui)
end

return GuiManager
