extends Node

var CHARACTER_HANDLER = null # declared by character handler in ready function
var ROOT = null
var MENUS = null # declared by Main scene in ready function

onready var STATUS_EFFECT_HANDLER = preload("res://Common/StatusEffects/StatusEffectHandler.tscn")

func ready():
	ROOT = get_tree().root


var LEVEL_PATH_TEST = "res://World/TestLevel.tscn"

func load_level(level):
	var instance = null
	match(level):
		"TestLevel":
			instance = load("res://World/TestLevel.tscn").instance()
		_:
			return null
	if instance == null:
		return null
	ROOT.add_child(instance)
	return instance
