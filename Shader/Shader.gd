extends Node2D


func add_outline_shader_to_node(node:Node,color:Color=Color(1,0,0,1)):
	var shader_material = ShaderMaterial.new()
	shader_material.shader = preload("res://Shader/outline.gdshader")
	shader_material.set_shader_parameter('outline_color',color)
	shader_material.set_shader_parameter('self_modulate_color',node.self_modulate)
	material = shader_material
	node.material = material

func remove_shader_from_node(node:Node):
	node.material = null
