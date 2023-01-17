extends Node

var CHARACTER_HANDLER = null # declared by character handler in ready function
var ROOT = null
var MENUS = null # declared by Main scene in ready function

var paused = false setget set_pause
var in_menu = false

onready var STATUS_EFFECT_HANDLER = preload("res://Common/StatusEffects/StatusEffectHandler.tscn")

# MENU ELEMENTS ----------------------------------
var MAIN_MENU = "res://UI/TestMainMenu.tscn"
var PAUSE_MENU = "res://UI/PauseMenu.tscn"
var PARTY_MENU = "res://UI/inventory.tscn"
var OPTIONS_MENU  = "res://UI/Options.tscn"
var PARTY_SETUP = "res://UI/PartySelection/PartySelection.tscn"

# UI ELEMENTS ------------------------------------
var GUI = "res://UI/GUI.tscn"
var GAME_OVER = "res://UI/EndGameScreen.tscn"

# LEVEL ELEMENTS _________________________________
var TEST_LEVEL = "res://World/TestLevel.tscn"
var HUB_WORLD = "res://World/Hubworld.tscn"

# CHARACTER ELEMENTS -----------------------------
export var HANDLER = "res://Characters/Shared/CharacterHandler.tscn"
export var MARIA = "res://Characters/Maria/TestCharacter.tscn"
export var RHODES = "res://Characters/Rhodes/TestCharacter2.tscn"
export var OLIVE = "res://Characters/Olive/TestCharacter3.tscn"
export var SAN = "res://Characters/San/San.tscn"

func ready():
	ROOT = get_tree().root


func load_level(level):
	var instance = null
	# Add new level types here
	match(level):
		"TestLevel":
			instance = load("res://World/TestLevel.tscn").instance()
		"Hubworld":
			instance = load("res://World/Hubworld.tscn").instance()
		_:
			return null
	if instance == null:
		return null
	ROOT.add_child(instance)
	return instance

func set_pause(value):
	paused = value
	get_tree().paused = value
