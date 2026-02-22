## DoctrineData — Resource that defines a researchable doctrine.
## Doctrines are organized in a tiered tree. Higher tiers require prerequisites.
## Stored in data/ folder as .tres files.
class_name DoctrineData
extends Resource


## Unique identifier (e.g. "concentrated_barrage").
@export var id: String = ""

## Name shown to the player (e.g. "Concentrated Barrage").
@export var display_name: String = ""

## Description of what this doctrine does.
@export_multiline var description: String = ""

## Requisition Point cost to research.
@export var cost_rp: int = 50

## Tier in the research tree (1 = base, 2+ = advanced).
@export var tier: int = 1

## Doctrine IDs that must be researched before this one can be unlocked.
@export var prerequisites: Array[String] = []

## What kind of effect: "passive" (always on), "active" (toggled in battle), "unlock" (enables something).
@export var effect_type: String = "passive"
