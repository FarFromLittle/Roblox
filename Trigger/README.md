__Trigger__
===========
Reliable Roblox touched events with part filtering.

This module aims to provide a simple solution for constant and realiable touch events in Roblox.
There's also a part filtering feature to control which part gets sent to the event handler.

<details>
<summary>Example usage</summary>

```lua

-- Add as a LocalScript to StarterCharacterScripts and scatter
-- a few parts around the workspace tagged with "Interactive"

local Trigger = require(game:GetService("ReplicatedStorage"):WaitForChild("Trigger"))

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local touchPart = Instance.new("Part", character)
touchPart.BrickColor = BrickColor.Blue()
touchPart.CFrame = rootPart.CFrame
touchPart.Material = Enum.Material.ForceField
touchPart.Shape = Enum.PartType.Ball
touchPart.Size = Vector3.new(7, 7, 7)

local touchWeld = Instance.new("Weld", touchPart)
touchWeld.Part0 = rootPart
touchWeld.Part1 = touchPart

local function partFilter(hit)
	return game:GetService("CollectionService"):HasTag(hit, "Interactive") and hit
end

local trigger = Trigger.new(touchPart, partFilter)

trigger.Touched:Connect(function (hit)
	touchPart.BrickColor = BrickColor.Green()
end)

trigger.TouchEnded:Connect(function (hit)
	touchPart.BrickColor = BrickColor.Blue()
end)

```
</details>

__Part Filtering__
------------------
The second argument to `Trigger.new` allows you to pass a function to accept, dismiss, or alter the initial part provided by Roblox.
The function accepts one argument, the Roblox provided part (as with a normal `BasePart.Touched/TouchEnded` signal), and
should return the part required by your `Trigger.Touched/TouchEnded` handler.  If you wish to exclude the part, simply return a falsey value (`nil` or `false`).

For example, suppose you are only interested in colliding with a player's character.  You could use the following part filter.
```lua
local function partFilter(hit)
	return game.Players:GetPlayerFromCharacter(hit.Parent)
end
```
This causes `Trigger.Touched` to be fired once each time a character comes in contact with `touchPart`.
```lua
trigger.Touched:Connect(function (plr)
	print("Contact establishing with", plr.Name)
end)
```

Omitting the `partFilter` allows all parts to be passed to the touched connection as with a normal Roblox signal.
