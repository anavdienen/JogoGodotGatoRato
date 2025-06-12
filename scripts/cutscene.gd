# Script: CochiloTrigger.gd
extends Area2D

# Referências aos personagens (AJUSTE ESTES NODE PATHS DE ACORDO COM SUA CENA)
@onready var cat = $"../Cat" # Exemplo: Se Gato está no mesmo nível que o CochiloTrigger
@onready var rat = $"../Rat1" # Exemplo: Se Rato está no mesmo nível que o CochiloTrigger

# Referências aos sons (filhos deste Area2D)
@onready var ronco_sfx = $RoncoSFX
@onready var barulho_acorda_sfx = $BarulhoAcordaSFX

@export var hud_path: NodePath 

const DIALOG_SCREEN: PackedScene = preload("res://dialog/dialog_screen.tscn") 

var dialog_data_cutscene := {
	0: {
		"faceset": "res://dialog/imagens/cat.png", 
		"dialog": "Zzzzz... (ronco) Zzzzz...\n\n(enter)",
		"title": "Gato"
	},
	1: {
		"faceset": "res://dialog/imagens/rat.png", 
		"dialog": "(Sons de sono) ...zZZzzz...\n\n(enter)",
		"title": "Rato"
	},
	2: {
		"faceset": "", 
		"dialog": "Um barulho alto e repentino ecoa pela mansão!",
		"title": "" 
	},
	3: {
		"faceset": "res://dialog/imagens/cat.png", 
		"dialog": "O que foi isso?! Um barulho estranho, e muito alto!",
		"title": "Gato"
	},
	4: {
		"faceset": "res://dialog/imagens/rat.png", 
		"dialog": "A-algo se moveu lá fora! Não estamos seguros aqui!",
		"title": "Rato"
	},
	5: {
		"faceset": "res://dialog/imagens/cat.png", 
		"dialog": "Precisamos sair daqui, AGORA!",
		"title": "Gato"
	}
}

var cochilo_active = false
var cat_in_area = false
var rat_in_area = false

var current_cutscene_step = 0

func _ready():

	pass

func _on_body_entered(body: Node2D) -> void:
	if body == cat: 
		cat_in_area = true
	if body == rat: 
		rat_in_area = true

	if cat_in_area and rat_in_area and not cochilo_active:
		cochilo_active = true
		print("Gato e Rato entraram na área do cochilo. Iniciando rotina...")
		
		start_sleep_sequence()

func _on_body_exited(body: Node2D) -> void:
	if body == cat:
		cat_in_area = false
	if body == rat:
		rat_in_area = false


func start_sleep_sequence() -> void:

	if is_instance_valid(cat):
		cat.can_move = false
		cat.play_animation("sleeping")
	if is_instance_valid(rat):
		rat.can_move = false
		rat.play_animation("sleeping")
	

	print("Personagens dormindo...")
	await get_tree().create_timer(5.0).timeout 
	print("5 segundos se passaram.")

	if is_instance_valid(ronco_sfx) and ronco_sfx.playing:
		ronco_sfx.stop()
	if is_instance_valid(barulho_acorda_sfx):
		barulho_acorda_sfx.play()
	
	print("Barulho! Iniciando diálogo...")
	current_cutscene_step = 0 
	show_next_dialog_part()

func show_next_dialog_part() -> void:

	if current_cutscene_step < dialog_data_cutscene.size():
		var hud = get_node(hud_path)
		if not is_instance_valid(hud):
			push_error("HUD node not found at path: ", hud_path)
			return

		var dialog_instance = DIALOG_SCREEN.instantiate()
		dialog_instance.data = { 0: dialog_data_cutscene[current_cutscene_step] } 

		dialog_instance.dialog_finished.connect(_on_dialog_finished_from_cutscene_part)
		hud.add_child(dialog_instance)
	else:
		finish_sleep_sequence()

func _on_dialog_finished_from_cutscene_part():
	current_cutscene_step += 1
	show_next_dialog_part()


func finish_sleep_sequence() -> void:
	print("Diálogo terminado. Personagens levantando...")

	if is_instance_valid(cat) and cat.has_method("play_animation"):
		cat.play_animation("idle") 
	if is_instance_valid(rat) and rat.has_method("play_animation"):
		rat.play_animation("idle") 

	if is_instance_valid(cat):
		cat.can_move = true
	if is_instance_valid(rat):
		rat.can_move = true

	print("Sequência de cochilo finalizada. Jogo retomado.")
