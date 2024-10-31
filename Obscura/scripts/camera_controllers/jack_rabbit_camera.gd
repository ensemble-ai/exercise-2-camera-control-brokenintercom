class_name LerpTargetFocus
extends CameraControllerBase


@export var vertical_line:float = 5.0
@export var horizontal_line:float = 5.0

@export var lead_speed:float = 2.0
@export var catchup_delay_duration:float = 0.2
@export var catchup_speed:float = 5.0
@export var leash_distance:float = 2.0

func _ready() -> void:
	super()
	position = target.position
	
# running timer to decide when to trigger the camera moving back
var elapsed_time:float = 0

func _process(delta: float) -> void:
	if !current:
		global_position = target.position
		return
	
	if draw_camera_logic: 
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	# calculate distance between the camera and the vessel
	var distance:float = global_position.distance_to(target.global_position) - 20

	# This chunk handles the camera moving in front of the camera
	# right
	if target.velocity.x > 0:
		global_position.x += target.velocity.x * lead_speed * delta
	# left
	if target.velocity.x < 0:
		global_position.x += target.velocity.x * lead_speed * delta
	# up
	if target.velocity.z > 0:
		global_position.z += target.velocity.z * lead_speed * delta
	# down
	if target.velocity.z < 0:
		global_position.z += target.velocity.z * lead_speed * delta		
		
	# Preven the camera from moving too far from the vessel via a leash
	if distance >= leash_distance:
		global_position.x -= (global_position.x - target.global_position.x) * 0.1
		global_position.z -= (global_position.z - target.global_position.z) * 0.1
	
	# If the vessel stops moving, wait until the delay ends to start adjusting the camera
	if (target.velocity.x == 0) && (target.velocity.z == 0):
		elapsed_time += delta
		if elapsed_time >= catchup_delay_duration:
			# if the vessel isn't moving up, have the camera catch up in the z-axis
			if (position.z > target.position.z) && (target.velocity.z == 0):
				position.z += (target.position.z - position.z) * catchup_speed * delta
			
			# if the vessel isn't moving down, have the camera catch up in the z-axis
			if (position.z < target.position.z) && (target.velocity.z == 0):
				position.z += (target.position.z - position.z) * catchup_speed * delta
			
			# if the vessel isn't moving left, have the camera catch up in the x-axis
			if (position.x > target.position.x) && (target.velocity.x == 0):
				position.x += (target.position.x - position.x) * catchup_speed * delta
				
			# if the vessel isn't moving right, have the camera catch up in the x-axis
			if (position.x < target.position.x) && (target.velocity.x == 0):
				position.x += (target.position.x - position.x) * catchup_speed * delta
	else:
		# reset the timer if the vessel is moving again
		elapsed_time = 0

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
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, 
	global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
