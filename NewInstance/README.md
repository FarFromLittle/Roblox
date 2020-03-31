# NewInstance

A module script to aid the the creation of Roblox Instances.

## Getting Started

This module provides access to a function that accepts a string representation of a Roblox instance, or another instance to serve as a template.

```lua
local TextLabel = NewInstance("TextLabel") {
	Text = "Hello Roblox!",
	BackgroundTransparency = 1,
	TextColor3 = { 1, 1, 1 },
	TextStrokeColor3 = { 0, 0, 0 },
	TextStrokeTransparency = 0
}
```
This bit of code returns a TextLabel containing text that is white, with a black outline.

