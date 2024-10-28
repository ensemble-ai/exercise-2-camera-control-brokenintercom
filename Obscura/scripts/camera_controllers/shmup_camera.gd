class_name Shmup
extends CameraControllerBase

@export var top_left:float = 25.0
@export var bottom_right:float = 25.0
@export var autoscroll_speed:float = 0.1

# If I have time, want to make the camera offset to the right to get the shmup effect
@export var cam_offset:float = 10.0


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		# make sure that the camera "resets" onto the player's position when switched off
		global_position = target.global_position
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	# autoscroll the camera
	global_position.x += autoscroll_speed
	target.global_position.x += autoscroll_speed
	
	# boundary checks
	# left barrier that pushes vessel
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - top_left / 2.0)
	if diff_between_left_edges < 0:
		target.position.x = (cpos.x - top_left / 2.0)
		
	# right barrier that prevents vessel from moving ahead
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + bottom_right / 2.0)
	if diff_between_right_edges > 0:
		target.position.x = (cpos.x + bottom_right / 2.0)
		
	# top barrier
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - top_left / 2.0)
	if diff_between_top_edges < 0:
		target.position.z = (cpos.z - top_left / 2.0)
		
	# bottom barrier
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + bottom_right / 2.0)
	if diff_between_bottom_edges > 0:
		target.position.z = (cpos.z + bottom_right / 2.0)
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	var left:float = -top_left / 2 
	var right:float = bottom_right / 2
	var top:float = top_left / 2
	var bottom:float = -bottom_right / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
