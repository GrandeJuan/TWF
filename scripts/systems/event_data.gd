## EventData — Resource that defines a narrative event.
## Each event has a title, flavor text, and 2-3 choices with consequences.
## Stored in data/ folder as .tres files.
class_name EventData
extends Resource


## Unique identifier for this event (e.g. "grakk_infiltrators").
@export var id: String = ""

## Title displayed at the top of the event card (e.g. "Grakk Infiltrators Detected").
@export var title: String = ""

## Narrative description of the situation shown in the card body.
@export_multiline var flavor_text: String = ""

## Which phase this event can appear in: "base" or "battle".
@export var phase: String = "battle"

## List of choices the player can pick. Each is a Dictionary with:
##   "text": String — the choice label shown on the button
##   "consequences": Array[Dictionary] — list of effects applied when chosen
##     Each consequence: { "type": String, "target": String, "value": int }
##     Example types: "resource", "morale", "supply", "spawn_event"
@export var choices: Array[Dictionary] = []
