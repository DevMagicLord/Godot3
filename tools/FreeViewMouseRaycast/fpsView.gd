extends Spatial

export(PackedScene) var objectScatter

var cameraAngle =0 
var mouseSensivity = 0.3 
var camera_change = Vector2()

var velocity = Vector3()
var direction = Vector3()

const fly_speed = 1
const fly_accel = 3
var flying = true
var pluginOn = false 
 

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 	  
	
func _physics_process(delta): 
	
	if Input.is_action_pressed("switch"):
		pluginOn = !pluginOn
		if pluginOn : 
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
		if !pluginOn:			
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 	
		
	if !pluginOn:			
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
		aim() 
		fly(delta) 
		
	if pluginOn: 
		if Input.is_action_pressed("right_click"):
			MouseRaycast()
		
	if Input.is_action_pressed("save"):	
		var packed_scene = PackedScene.new()
		packed_scene.pack(get_tree().get_current_scene().get_node("trees"))
		ResourceSaver.save("res://trees.tscn", packed_scene)
		print("saved")
	 
	

func _input(event): 
	if event is InputEventMouseMotion:
		
		camera_change = event.relative
		
			
func fly(delta):
	
	
	
	
	
	direction = Vector3()
	
	var aim = $head/Camera.get_global_transform().basis 
	
	if Input.is_action_pressed("up"):
		direction -= aim.z
	if Input.is_action_pressed("down"):
		direction += aim.z	
	if Input.is_action_pressed("left"):
		direction -= aim.x
	if Input.is_action_pressed("right"):
		direction += aim.x
		
	direction = direction.normalized()	
	
	var target = direction * fly_speed
	
	velocity = velocity.linear_interpolate(target, fly_accel * delta) 
	
	global_transform.origin += velocity
			

		
func aim() :
	if(camera_change.length()>0):
		$head.rotate_y(deg2rad(-camera_change.x * mouseSensivity))
			
		var change = -camera_change.y * mouseSensivity
			
		if change + cameraAngle < 75 && change + cameraAngle >-90 :
			$head/Camera.rotate_x(deg2rad(change))  
			cameraAngle += change
		camera_change = Vector2()			
		
func MouseRaycast():
	var ray_lenght = 1000
	var mouse_pos = get_viewport().get_mouse_position()	
	var camera = $head/Camera
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_lenght
	var space_state = get_world().get_direct_space_state() 
	var result = space_state.intersect_ray( from, to )
	if result.has("collider"):
		print(result["collider"])
	if result.has("position"):
		print(result["position"])	 	
		var loadedScene = objectScatter.instance()		
		get_node("../trees/") .add_child(loadedScene)  
		loadedScene.global_transform.origin = result["position"]		 
		
		
		
	
			