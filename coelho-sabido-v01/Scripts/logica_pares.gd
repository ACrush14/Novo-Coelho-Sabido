extends Control

var score = 0
var lives = 3

#Aqui é a variável que guarda o estado.
var selected_num_button: Button = null
var selected_word_button: Button = null


#Aqui vão ser definidos os pares, preencher no inspetor do Godot
@export var pares_numeros: Array[NodePath]
@export var pares_palavras: Array[NodePath]

#Variaveis para mudar a cena se vencer ou perder, e quantidade de pontos
@export var proxima_cena: PackedScene
@export var cena_falhou: PackedScene
@export var pontos_para_vencer: int

# --- CORREÇÃO 1: Mapeamento Lógico dos Corações ---
@onready var life_coracao_3 = $Life4
@onready var life_coracao_2 = $Life3
@onready var life_coracao_1 = $Life2

@onready var nolife_coracao_3 = $Nolife4 # Par de 3 vidas (Life4)
@onready var nolife_coracao_2 = $Nolife3 # Par de 2 vidas (Life3)
@onready var nolife_coracao_1 = $Nolife5 # Par de 1 vida (Life2)


#Função Ready!
func _ready():
	for button in get_tree().get_nodes_in_group("Numeros"):
		button.pressed.connect(_on_number_pressed.bind(button))
		
	for button in get_tree().get_nodes_in_group("Palavras"):
		button.pressed.connect(_on_word_pressed.bind(button))
		
	update_life_visuals()
		
#FUNÇÕES DE SINAL
#Função do Numero
func _on_number_pressed(button: Button):
	if button.disabled:
		return
		
	if selected_word_button != null:
		check_pair(button, selected_word_button)
	
	# --- CORREÇÃO 2: Checar a variável 'selected_num_button' ---
	elif selected_num_button != null:
		print("ERRO: Clicou em numero-numero")
		lose_life()
		reset_selection() 
	
	else:
		# Corrigido para .name, que é mais útil para botões de número
		print("Numero selecionado: ", button.name) 
		selected_num_button = button
		button.modulate = Color(0.8, 0.8, 1.0)
		
#Função da Palavra
func _on_word_pressed(button: Button):
	if button.disabled:
		return
		
	if selected_num_button != null:
		check_pair(selected_num_button, button)

	# --- CORREÇÃO 2: Checar a variável 'selected_word_button' ---
	elif selected_word_button != null:
		print("ERRO: Clicou em palavra-palavra")
		lose_life()
		reset_selection()
		
	else:
		# Corrigido para .text, que é mais útil para botões de palavra
		print("Palavra selecionada: ", button.text) 
		selected_word_button = button
		button.modulate = Color(0.8, 0.8, 1.0)

# LOGICA

#Função para checar os pares
func check_pair(num_btn: Button, word_btn: Button):
	if is_correct_pair(num_btn, word_btn):
		print("Acertou o par!")
		gain_point()
		num_btn.disabled = true
		word_btn.disabled = true
	else:
		print("Erro: Par incorreto")
		lose_life()
		
	reset_selection()

func is_correct_pair(num_btn: Button, word_btn: Button) -> bool:
	var num_path = self.get_path_to(num_btn)
	var word_path = self.get_path_to(word_btn)
	
	var index = pares_numeros.find(num_path)
	
	if index != -1 and pares_palavras[index] == word_path:
		return true
		
	return false
	
func gain_point():
	score += 1
	print("Pontos: ", score)
	if score >= pontos_para_vencer:
		print("Indo para o prox nivel! Carregando: ", proxima_cena.get_path())
		mudar_cena(proxima_cena)
	
func lose_life():
	lives -= 1
	print("Vidas: ", lives)
	
	update_life_visuals()
	if lives <= 0:
		print("GAME OVER! Carregando: ", cena_falhou.get_path())
		mudar_cena(cena_falhou)
	
func reset_selection():
	# Está correto
	if selected_num_button != null:
		selected_num_button.modulate = Color(1, 1, 1)
		selected_num_button = null
		
	if selected_word_button != null:
		selected_word_button.modulate = Color(1, 1, 1)
		selected_word_button = null
		
	print("Seleção resetada")
		
	
func update_life_visuals():
	#Coração 3, depois 2 depois 1
	life_coracao_3.visible = (lives >= 3)
	nolife_coracao_3.visible = (lives < 3)
	life_coracao_2.visible = (lives >= 2)
	nolife_coracao_2.visible = (lives < 2)
	life_coracao_1.visible = (lives >= 1)
	nolife_coracao_1.visible = (lives < 1)

#Função para mudar de cena
func mudar_cena(cena: PackedScene):
	if cena == null:
		print("ERRO: Coloque uma cena para carregar.")
		return
	
	get_tree().change_scene_to_packed(cena)
