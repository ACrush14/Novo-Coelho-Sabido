extends Control

var score = 0
var lives = 3

#Aqui é a variável que guarda o estado.
var selected_num_button: Button = null


#Aqui vão ser definidos os pares, preencher no inspetor do Godot
@export var pares_numeros: Array[NodePath]
@export var pares_palavras: Array[NodePath]

# --- Nós da UI (Opcional) ---
# @onready var score_label = $ScoreLabel
# @onready var lives_label = $LivesLabel

#Função Ready!
func _ready():
	# CORRETO!
	for button in get_tree().get_nodes_in_group("Numeros"):
		button.pressed.connect(_on_number_pressed.bind(button))
		
	# CORRETO!
	for button in get_tree().get_nodes_in_group("Palavras"):
		button.pressed.connect(_on_word_pressed.bind(button))
		
		


#FUNÇÕES DE SINAL
#Função do Numero
func _on_number_pressed(button: Button):
	#Se os botões estão desativado, não faz nada
	if button.disabled:
		return
		
	#Se dois numeros forem clicados seguidamente, jogador perde vida
	if selected_num_button != null:
		print("ERRO: Clicou em numero-numero")
		lose_life() # Ativado
		reset_selection() 
	
	#Jogador vai clicar num numero agora:
	else:
		print("Numero selecionado: ", button.text)
		selected_num_button = button
		#Cor para ajudar 
		button.modulate = Color(0.8, 0.8, 1.0) #um tom azul.
		
#Função da Palavra
func _on_word_pressed(button: Button):
	#Se os botões estão desativado, não faz nada
	if button.disabled:
		return
		
	# CORRIGIDO AQUI: (linha 47)
	# Jogador clicou em uma palavra, mas NÃO tinha número selecionado
	if selected_num_button == null:
		print("ERRO: Clicou em palavra sem número")
		#Perde uma vida por isso
		lose_life() # Ativado
		
	#Se tinha um numero selecionado e clicou na palavra
	else:
		#checagem de par correto
		if is_correct_pair(selected_num_button, button):
			print("Acertou o par!")
			gain_point() # Ativado
			#Desativar os botoes do par para nao serem usados de novo
			selected_num_button.disabled = true
			button.disabled = true
		else:
			print("Erro: Par incorreto")
			lose_life() # Ativado
		#independente de acertar ou errar, reseta a seleção:
		reset_selection()

# LOGICA
func is_correct_pair(num_btn: Button, word_btn: Button) -> bool:
	#Pega o caminho de cada no
	var num_path = self.get_path_to(num_btn)
	var word_path = self.get_path_to(word_btn)
	
	#procura o indice do numero no array de pares
	var index = pares_numeros.find(num_path)
	
	#Se tiver numero e palavra no MESMO INDICE do outro array
	if index != -1 and pares_palavras[index] == word_path:
		return true
		
	#Se não, par errado
	return false
	
func gain_point():
	score += 1
	print("Pontos: ", score)
	# score_label.text = "Pontos: " + str(score)
	# Aqui você pode verificar se o jogador ganhou (ex: score == 4)
	
func lose_life():
	lives -= 1
	print("Vidas: ", lives)
	if lives == 2:
		$Life4.visible = false
		$Nolife5.visible = true
	if lives == 1:
		$Life3.visible = false
		$Nolife4.visible = true
	
	# lives_label.text = "Vidas: " + str(lives)
	# Aqui você pode verificar se é game over (ex: lives <= 0)
	
func reset_selection():
	# CORRIGIDO AQUI: (linha 104)
	#Resetar a cor se um botão estava selecionado
	if selected_num_button != null:
		selected_num_button.modulate = Color(1, 1, 1)
		
	# CORRIGIDO AQUI: (linha 107)
	#Limpa a variavel do estado
	selected_num_button = null
	print("Seleção resetada")
