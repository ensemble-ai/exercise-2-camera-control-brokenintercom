class_name PositionLerpSmoothing
extends CameraControllerBase


@export var vertical_line:float = 10.0
@export var horizontal_line:float = 10.0

@export var follow_speed:float = 0.02
@export var catchup_speed:float = 0.1
@export var leash_distance:float = 0.01

# TO TURN VECTOR 3 TO JUST DIRECTION, do VECTOR3.NORMALIZE()
# (tpos-cpos).normalize
# LENGTH()


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
	
	# If the vessel isn't where the camera is, have the camera start catching up
	global_position = lerp(cpos, tpos, follow_speed)
		
		
		
	# Prevent the camera from falling behind via a leash/minimum distance
	

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
