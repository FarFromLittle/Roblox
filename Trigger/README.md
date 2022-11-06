# [:mouse_trap: Trigger :mouse_trap: ](https://www.roblox.com/library/9337671794/Trigger-Touch-based-Events-w-Part-Filtering)

***A Simple ModuleScript Supporting Touch-based Interactions.***

https://www.roblox.com/library/9337671794/Trigger-Proximity-based-Interactions-w-Touched

> **Please Consider the Following Precautions:**
> - Parts falling in/out of *sleep*, and *streaming*, may still cause events to fire unexpectedly.
> - When deciding on a *touchPart*, consider a part that's less likely to move; best if *Anchored*.
> - It may be necessary to weld a larger *touchPart* to smaller objects, or to provide padding.
> - Account for latency between the client & server when handling interactions server-side.

### Trigger Properties & Descriptions
| Property | Type | Description
|- |- |-
| BasePart | *BasePart (readonly)* | The part to observe for touch events.
| Debounce | *number* | Disconnect delay; represents minimum touch time.
| PartFilter | *function* | Part predicate used for filtering. (See details below.)
| FilterExtras | Variant | Extra parameters passed to *partFilter*.
| TouchingResults | *table (readonly)* | Filtered list of results containing a count touching parts.
| TouchingParts | *table (readonly)* | List of individual parts making up a connection.
| Touched | *RBXScriptSignal* | Triggered when a valid collision is made.
| TouchEnded | *RBXScriptSignal* | Fired upon leaving; delayed be *debounce*.

## Introduction
***Touched*** can be unpredictable and often fire uncontrollably at times, causing performance issues and confusion.  *Trigger* is a part wrapper that aims to smooth out some of these issues and facilitate reliable touch-based events.

>***Some of the benefits of using Trigger over traditional methods:***
>- Maintain constant connections with a built-in *debouce* system.
>- Accepts a part *predicate* to filter and/or group collisions.  *(See details below.)*
>- Easily create *zones* with basic parts.  It even supports unions!
>- Maintains an event-based approach.  Avoiding unnecessary checks & connections.

## How To Use
Constructing a new trigger takes the following form:
```
local trigger = Trigger.new(touchPart, debounce, partFilter, ...)
```
Parameters are defined as the following:
>| Name | Type | Default | Description
>|-|-|-|-
>| *touchPart* | BasePart | | The part to observe for touch events.
>| *debounce* | number | 0 | Disconnect delay; represents minimum touch time.
>| *partFilter* | function | *nil* | Part predicate used for filtering.  (See details below.)
>| *...* | Variant | *nil* | Extra *partFilter* parameters.

All that needs to be done now is connect to `Touched` and `TouchEnded` to observe part collisions.
```
trigger.Touched:Connect(function (otherPart) print(otherPart.Name, "touched") end)
trigger.TouchEnded:Connect(function (otherPart) print(otherPart.Name, "touchEnded") end)
```

## Iterating Over Touching Parts
***Trigger*** provides you with two lists to iterate over.  Take care **not** to alter these lists, as it may cause problems.

To iterate over a list of results returned by our *partFilter*:
```
for result, count in pairs(trigger.Touching) do
	print(result, "is touching with", count, "part(s).")
end
```

Additionally, you can iterate over the individual parts that make up a connection.
```
for part, result in pairs(trigger.TouchingParts) do
	print(result, "is the result of touching", part)
end
```

## Debouncing Connections
The *debounce* timer controls the minimum amount of time a connection is held; in *seconds*.  This only influences connections to *TouchEnded*, it does **not** delay dispatching of *Touched* events.  Useful for keeping a connection intact for a predetermined length of time (ie allowing a player to jump without leaving a platform).

## Part Filtering & Grouping w/ Predicates
*Predicates* are a powerful way to filter and group part collisions; defined as a *function*.  This function takes one or more arguments, processes the collision based on some sort of criteria, and returns an *object* or *false*.  The results are then stored and passed along to events connected to *Touched* and *TouchEnded*.

Predicates also facilitate the ability to redirect or group events, returning a target not capable of receiving touch events natively. (A *Player* or their *Character* for example).

The first parameter passed to the function is always the original part touched, followed by any extra parameters you defining during construction.  A part filter may look something like this:
```
local function partFilter(otherPart)
	if otherPart.Name == "Keep" then
		return otherPart
	else
		return false
	end
end
```
Here, parts that aren't named *Keep* will be filtered.  A collision is valid if the value returned is considered to be *true*.  This can be *otherPart*, another *Instance*, or an altogether custom object.  

Any part not filtered will be stored in the *TouchingParts* property with it's associated result.  Results are stored along with a touch count in the property *TouchingResults*.

***Trigger*** maintains a few commonly used functions in the table below.
| Filter Reference | Parameters | Returns | Description
|- |- |- |-
| `Trigger.Player` | `player` *(optional)* | *Player* | Triggered when contact is made with a player's character.  If a `player` is specified, only that player's character will trigger the event.
| `Trigger.Character` | | *Model* | Filter for characters containing a *Humanoid*; including NPCs.
| `Trigger.Model` | | *Model* | Filters out parts not contained within a *Model*; returns the matched *Model* if found.
| `Trigger.Collection` | `tagName` *(required)* | *BasePart* | Filters for parts contained within a *collection*.

## Conclusion
*Touched* events may not be suitable for all interactions or in all situations.  Even-so, ***Trigger*** extends the use of touch-based connections and helps ease the pain of scripting interactions with *Touched* events.
