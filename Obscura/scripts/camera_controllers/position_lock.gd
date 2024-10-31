class_name PositionLockCamera
extends CameraControllerBase


@export var vertical_line:float = 5.0
@export var horizontal_line:float = 5.0


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	# Simply lock the camera to wherever the vessel moves
	global_position = target.global_position
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# Vertical line of the crosshair
	immediate_mesh.surface_add_vertex(Vector3(0, 0, vertical_line))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -vertical_line))
	
	# Horizontal line of the crosshair
	immediate_mesh.surface_add_vertex(Vector3(horizontal_line, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(-horizontal_line, 0, 0))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
