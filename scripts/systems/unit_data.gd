## UnitData — Resource that defines a unit type's base stats.
## Used as a template when spawning units. Does not change at runtime.
## Stored in data/ folder as .tres files.
class_name UnitData
extends Resource


## Unique identifier for this unit type (e.g. "line_infantry", "grakk_mob").
@export var id: String = ""

## Name shown to the player (e.g. "Line Infantry", "Grakk Mob").
@export var display_name: String = ""

## Which side this unit belongs to: "human" or "grakk".
@export var faction: String = "human"

## Base health points. If health reaches 0, the unit is destroyed.
@export var health: int = 100

## Base damage dealt per attack.
@export var damage: int = 10

## Movement speed in pixels per second.
@export var speed: float = 50.0

## Base morale points. If morale reaches 0, a Morale Break Event triggers.
@export var morale: int = 100

## Base supply capacity. Drains passively during battle.
@export var supply: int = 100

## Path to the sprite texture for this unit type.
@export var sprite_path: String = ""
