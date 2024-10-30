class_name Shmup
extends CameraControllerBase

@export var top_left:Vector2 = Vector2(-15, 15)
@export var bottom_right:Vector2 = Vector2(15, -15)
@export var autoscroll_speed:Vector3 = Vector3(1, 0, 0)

func _ready() -> void:
	super()
	position = target.position
	
	

func _process(delta: float) -> void:
	if !current:
		# reset the autoscroll to start where the player is
		# otherwise it "teleports" the player to where the autoscrolling camera once was
		global_position = target.global_position
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	# autoscroll the camera
	global_position.x += autoscroll_speed.x
	global_position.z += autoscroll_speed.z
	# move the vessel along with the camera
	target.global_position.x += autoscroll_speed.x
	target.global_position.z += autoscroll_speed.z
	
	# Dimensions of vessel for calculating distance between edges to be under line length limit
	var vessel_left:float = tpos.x - target.WIDTH / 2.0
	var vessel_right:float = tpos.x + target.WIDTH / 2.0
	var vessel_top:float = tpos.z - target.HEIGHT / 2.0
	var vessel_bottom:float = tpos.z + target.HEIGHT / 2.0
	
	# boundary checks
	# left barrier that pushes vessel forward and prevents from moving backwards
	var diff_between_left_edges = vessel_left - (cpos.x + top_left.x / 2.0)
	if diff_between_left_edges < 0:
		target.position.x -= diff_between_left_edges
		
	# right barrier that prevents the vessel from moving past the right of the cam
	var diff_right_edges = vessel_right - (cpos.x + bottom_right.x / 2.0)
	if diff_right_edges > 0:
		target.position.x -= diff_right_edges
	
	# top barrier that prevents the vessel from moving past the top of the cam
	var diff_top_edges = vessel_top - (cpos.z + top_left.y / 2.0) + top_left.y
	if diff_top_edges < 0:
		target.position.z -= diff_top_edges 
		
	# bottom barrier that prevents the vessel from moving past the bottom of the cam	
	var diff_bottom_edges = vessel_bottom - (cpos.z + bottom_right.y / 2.0) + bottom_right.y
	if diff_bottom_edges > 0:
		target.position.z -= diff_bottom_edges	
		
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
