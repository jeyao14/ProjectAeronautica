extends Node

var CHARACTER_HANDLER = null # declared by character handler in ready function
var ROOT = null
var MENUS = null # declared by Main scene in ready function

var paused = false setget set_pause

onready var STATUS_EFFECT_HANDLER = preload("res://Common/StatusEffects/StatusEffectHandler.tscn")

# MENU ELEMENTS ----------------------------------
var MAIN_MENU = "res://UI/TestMainMenu.tscn"
var PAUSE_MENU = "res://UI/PauseMenu.tscn"

# UI ELEMENTS ------------------------------------
var GUI = "res://UI/GUI.tscn"
var GAME_OVER = "res://UI/EndGameScreen.tscn"

# LEVEL ELEMENTS _________________________________
var TEST_LEVEL = "res://World/TestLevel.tscn"

# CHARACTER ELEMENTS -----------------------------
export var HANDLER = "res://Characters/Shared/CharacterHandler.tscn"
export var MARIA = "res://Characters/TestCharacter/TestCharacter.tscn"
export var RHODES = "res://Characters/TestCharacter2/TestCharacter2.tscn"
export var OLIVE = "res://Characters/TestCharacter3/TestCharacter3.tscn"

func ready():
	ROOT = get_tree().root


func load_level(level):
	var instance = null
	# Add new level types here
	match(level):
		"TestLevel":
			instance = load("res://World/TestLevel.tscn").instance()
		_:
			return null
	if instance == null:
		return null
	ROOT.add_child(instance)
	return instance

func set_pause(value):
	paused = value
	get_tree().paused = value
