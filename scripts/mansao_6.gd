extends Node2D 

var segundo_personagem_desbloqueado = false

@onready var main_camera: Camera2D = $Camera 

var tremor_ativo = false
var tremidas_restantes = 0
var tempo_proxima_tremida = 0.0

const NUM_TREMIDAS_POR_CICLO = 2
const TEMPO_ENTRE_TREMIDAS_NO_CICLO = 0.2 
const TEMPO_DE_PAUSA_DO_CICLO = 1.8 
const DURACAO_CADA_TREMIDA = 0.1   
const INTENSIDADE_CADA_TREMIDA = 8.0    
const DECAIMENTO_CADA_TREMIDA = 10.0    

func _ready():
	await get_tree().create_timer(1.0).timeout
	start_tremor_pattern()
	print("Ciclo de tremor agendado para iniciar.")

func _process(delta: float):
	if tremor_ativo:
		if tremidas_restantes > 0 and Time.get_ticks_msec() / 1000.0 >= tempo_proxima_tremida:
			if main_camera:
				main_camera.start_shake(DURACAO_CADA_TREMIDA, INTENSIDADE_CADA_TREMIDA, DECAIMENTO_CADA_TREMIDA)
				tremidas_restantes -= 1
				if tremidas_restantes > 0:
					tempo_proxima_tremida = Time.get_ticks_msec() / 1000.0 + TEMPO_ENTRE_TREMIDAS_NO_CICLO
				else:
					tempo_proxima_tremida = Time.get_ticks_msec() / 1000.0 + TEMPO_DE_PAUSA_DO_CICLO
					
					tremor_ativo = false 
					
					await get_tree().create_timer(TEMPO_DE_PAUSA_DO_CICLO).timeout
					start_tremor_pattern() 

func start_tremor_pattern():
	if main_camera:
		tremor_ativo = true
		tremidas_restantes = NUM_TREMIDAS_POR_CICLO
		tempo_proxima_tremida = Time.get_ticks_msec() / 1000.0

	else:
		printerr("Erro: Nó 'Camera' não encontrado para iniciar o padrão de tremor. Verifique o caminho em @onready var main_camera no script da Mansão.")

func stop_tremor_pattern():
	tremor_ativo = false
	tremidas_restantes = 0
	tempo_proxima_tremida = 0.0
	if main_camera:
		main_camera.start_shake(0.0, 0.0, 0.0) 
