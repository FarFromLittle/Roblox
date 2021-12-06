__Usage__

```lua
local Trigger = require(PATH_TO_MODULE)

-- Optional: This particular function returns a player instance
-- when touching it's HumanoidRootPart
local function partFilter(hit)
	return hit == hit.Parent.PrimaryPart and game.Players:GetPlayerFromCharacter(hit.Parent)
end

local trigger = Trigger.new(part, partFilter)
trigger.Touched:Connect(function (plr) print("Hello", plr.Name) end)
trigger.TouchEnded:Connect(function (plr) print("Goodbye", plr.Name) end)
```
