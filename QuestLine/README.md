# Create Linear Quests with QuestLine



QuestLine is an open-source, stand-a-lone, module script aimed at advanced developers to minimize the complexity of building a robust quest system.  It doesn't include many of the features found in similar modules and does so for simplicity, and even more so for flexibility.  Managing datastores, rewards, and displaying GUIs are left up to you to implement.

---

## Quest Creation

A quest is created as follows:
```
local myQuest = QuestLine.new(questId:string)
```

An unique identifier is __required__ and correlates to the _key_ of the quest within the player's progress table.

---

## Adding Objectives

Now you need to construct the questline by adding a series of objectives.  Each method returns __self__ to allow the chaining of objectives like so:

    myQuest:Score("Coin", 10):Touch(workspace.DropOff)


### Complete list of objective types

    Event(signal:RBXScriptSignal, count:number)

A generic, signal-based objective.

Note: This objective __requires__ that the first argument passed to a connection be an instance of player to count.  A ProximityPrompt's _Triggered_ event is a good example since the first argument passed is the player who triggered the prompt.

---

    Score(name:string, value:number)
An objective based on the value of a leaderstat.

---

    Timer(seconds:number)
A time-based objective, measured in seconds.

---

    Touch(touchPart:BasePart)
A simple touch-based objective.

---

## Assigning Quests

Players must first be registered with the system before being assigned any quests.

    QuestLine.registerPlayer(player:Player, questData:{[string]:number})

Here, a progression table is supplied along with the player; this is __required__.  Pass an empty table if the player has yet to be registered with the system in a previous session, or for testing purposes.

Upon leaving the game, the player needs to be unregistered too.  This does a bit of cleanup and returns the player's progression table to be saved in a datastore.

    QuestLine.unregisterPlayer(player:Player):{[string]:number}

Player progress is stored in a table where the _key_ is a string (which is supplied by _questId_) and the _value_ is an integer representing progression.

## 

After the player is registered, you can begin assigning them to your questlines:

    myQuest:Assign(player:Player)

---

## Handling Progression

To track player progress, you __must__ override some of the module's default members.  To do so, use one of the following methods:
```
QuestLine.OnAssign = function (self:QuestLine, player:Player) {} -- long form
function QuestLine.OnAssign(self:QuestLine, player:Player) {} -- short form
function QuestLine:OnAssign(player:Player) { } -- shorter form (self implied)
```

### A full list of handles include:

```
QuestLine:OnAssign(player:Player, progress:number, index:number)
```
Called when a player either accepts a quest for the first time, or loads a previously uncompleted quest.

---

```
QuestLine:OnProgress(player:Player, progress:number, index:number)
```
Called upon player progression.  This happens at each step of the progression phase according to the current objective type.

---

```
QuestLine:OnComplete(player:Player)
```
Called to signal the end of the questline.

---

