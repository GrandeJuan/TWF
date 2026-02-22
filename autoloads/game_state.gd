## GameState — Global singleton that tracks overall game progress and current phase.
## Accessible from any script via the autoload name "GameState".
extends Node


# --- State Variables ---

## Which phase the game is currently in: "base", "map", or "battle"
var current_phase: String = "base"

## Current tier of the war.
## 1-4 = early game trench tiers, 0 = Ferro Isthmus (mid game), -1 = offensive (late game)
var current_tier: int = 1

## List of active FrontData resources representing all battle fronts on the map.
var active_fronts: Array = []

## Whether the game has been won (Veranthos IV saved).
var game_won: bool = false

## Whether the game has been lost (trench line overrun with no fallback).
var game_lost: bool = false


# --- Lifecycle ---

func _ready() -> void:
	pass
