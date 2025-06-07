extends Node

var segundo_personagem_desbloqueado = false

@export var cat_reset_pos: Vector2 = Vector2(1900, 170) # Defina isso no Inspetor
@export var rat_reset_pos: Vector2 = Vector2(1900, 170) # Defina isso no Inspetor

@onready var cat_node = $Cat
@onready var rat_node = $Rat

func _ready():
	if cat_node:
		cat_node.reset_position = cat_reset_pos
	if rat_node:
		rat_node.reset_position = rat_reset_pos
