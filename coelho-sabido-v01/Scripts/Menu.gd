extends Node



func _on_começar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Motivo.tscn")



func _on_sair_pressed() -> void:
	get_tree().quit()
