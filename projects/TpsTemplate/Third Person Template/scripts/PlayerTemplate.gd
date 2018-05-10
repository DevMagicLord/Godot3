extends KinematicBody

var gravity = -9.8 
var velocity = Vector3()

var cam
var anim_player 
var character 


const SPEED=6
const ACCEL = 3
const DEACCEL = 5
 

func _ready():
	anim_player = $AnimationPlayer
	character = get_node(".") 

func _physics_process(delta):
	
	cam = $target/Camera.get_global_transform()	
	
	var dir = Vector3() 
	
	var is_moving = false
	
	if Input.is_action_pressed("up"):
		dir += -cam.basis[2]
		is_moving = true 
	if Input.is_action_pressed("down"):
		dir += cam.basis[2]	
		is_moving = true 
	if Input.is_action_pressed("left"):
		dir += -cam.basis[0]	
		is_moving = true 
	if Input.is_action_pressed("right"):
		dir += cam.basis[0]
		is_moving = true 
		
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y += delta * gravity
	
	var hv= velocity
	hv.y=0
	
	var newpos= dir * SPEED
	var acceleration = DEACCEL
	
	if dir.dot(hv) >0: 
		acceleration = ACCEL
		
	hv = hv.linear_interpolate(	newpos, acceleration * delta) 
	
	velocity.x = hv.x
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	var hvspeed = hv.length()/SPEED 
		
	$AnimationTreePlayer.blend2_node_set_amount("idle_run" ,hvspeed) 
	
	
	if is_moving :
		var angle = atan2(hv.x,hv.z)
		var char_rot = character.get_rotation()
		char_rot.y = angle 
		character.set_rotation(char_rot)
	
	
	#var anim_to_play = "IDLE"
	
	#if is_moving :
	#	anim_to_play = "WALK"
		
	#var current_anim = anim_player.get_current_animation()
	#if current_anim != anim_to_play :	
	#	anim_player.play(anim_to_play,0.5,2,false) 
		
	