class_name Shmup
extends CameraControllerBase

@export var top_left:Vector2 = Vector2(-5, 5)
@export var bottom_right:Vector2 = Vector2(20, -20)
@export var autoscroll_speed:Vector3 = Vector3(0.1, 0, 0)

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
	
	# autoscroll the camera
	global_position.x += autoscroll_speed.x
	target.global_position.x += autoscroll_speed.x
	
	# boundary checks
	# left barrier that pushes vessel forward and prevents from moving backwards
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x + top_left.x / 2.0)
	if diff_between_left_edges < 0:
		target.position.x = cpos.x + top_left.x / 2.0
		
	# right barrier that prevents vessel from moving ahead
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + bottom_right.x / 2.0)
	if diff_between_right_edges > 0:
		target.position.x = cpos.x + bottom_right.x / 2.0
		
	# top barrier that prevents vessel from moving above
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) + (cpos.z + top_left.y / 2.0)
	if diff_between_top_edges < 0:
		target.position.z = cpos.z - top_left.y / 2.0
		
	# bottom barrier that prevents vessel from moving below
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) + (cpos.z + bottom_right.y / 2.0)
	if diff_between_bottom_edges > 0:
		target.position.z = cpos.z - bottom_right.y / 2.0
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Use this as an example to correlate what equals what!
	# top_left:Vector2 = Vector2(-25, 20)
	# bottom_right:Vector2 = Vector2(10, -10)

	var left:float = top_left.x / 2.0  # -25
	var right:float = bottom_right.x / 2.0 # 10
	var top:float = top_left.y / 2.0 # 20
	var bottom:float = bottom_right.y / 2.0 # -10
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# right line
	immediate_mesh.surface_add_vertex(Vector3(right, 0, -bottom))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, -top))
	
	
	# bottom line
	immediate_mesh.surface_add_vertex(Vector3(right, 0, -bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, -bottom))
	
	# left line
	immediate_mesh.surface_add_vertex(Vector3(left, 0, -bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, -top))
	
	# top line
	immediate_mesh.surface_add_vertex(Vector3(left, 0, -top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, -top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
