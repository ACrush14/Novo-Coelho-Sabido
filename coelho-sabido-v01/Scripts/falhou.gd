extends Control

func _on_botao_tentar_novamente_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Menu.tscn")
