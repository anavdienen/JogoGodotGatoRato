extends Node2D

var segundo_personagem_desbloqueado = false

@export var cat_reset_pos: Vector2 = Vector2(425, 175) # Defina isso no Inspetor
@export var rat1_reset_pos: Vector2 = Vector2(425, 175) # Defina isso no Inspetor

@onready var cat_node = $Cat
@onready var rat1_node = $Rat1

func _ready():
	if cat_node:
		cat_node.reset_position = cat_reset_pos
	if rat1_node:
		rat1_node.reset_position = rat1_reset_pos
