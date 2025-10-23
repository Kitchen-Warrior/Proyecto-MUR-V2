extends Node2D


@export var distancia_min := 300.0
@export var distancia_max := 500.0
@export var altura_min := -100.0
@export var altura_max := 100.0
@export var offset_inicial := 600.0

@onready var camera_2d: Camera2D = $"../Camera2D"

var plataforma_scene = preload("res://src/scenes/plataforms/square plataform.tscn")
var ultima_x := 0


func _ready() -> void:
	ultima_x = offset_inicial
	

#COMO SE GENERA LA PLATAFORMA QUE VIENE DESPUÉS
		
func spawn_plataforma():
	var nueva_plataforma := plataforma_scene.instantiate()
	self.add_child(nueva_plataforma)
		
	var distancia := randf_range(distancia_min, distancia_max)
	var altura := randf_range(altura_min, altura_max)
	
	var nuevas_pos := Vector2(ultima_x + distancia, 
						randf_range(distancia_min, distancia_max) + altura)
	nueva_plataforma.global_position = nuevas_pos
	
	ultima_x = nuevas_pos.x
	
