extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var health=100 

var turningAngleMax = 45
var turningAngleSpeed= 300

var strafe_speed = 1000
var limitHor = 20 
var limitVer = 20 


var fly_speed = 20


var fly_accel = 10


var deceleration = 0.3 


var direction = Vector3()


var rotationShipY = 0
var speedRotation = 60

var rotationShipX = 0
var speedRotationX = 60




var timerFire= 0.3
var fireDelay = 0.3 

var timerDamage= 0
var timerDamageDelay = 0.3 


var bulletNode

export(PackedScene) var bulletScnFile; 


var turningAngles = Vector3()
var shipAngles = Vector3()
var velocity = Vector3()
var moveZ= 0
var moveY= 0



func _ready():
	#bulletNode = get_tree().get_root().get_node("level").get_node("projectiles");
	linear_velocity =  Vector3(3,0,0)
	turningAngles =  Vector3(0,0,0)
	shipAngles  =  Vector3(0,0,0)

func _process(delta):
	if timerDamage >0:
		timerDamage -= delta
		if timerDamage <=0:
			timerDamage =0
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
	
func _physics_process(delta): 

	fly(delta)
	
	turn(delta)
	
	if Input.is_action_pressed("fire"):
		fire(delta)
	
	print("ship position ", transform.origin)

			
func fly(delta):
	
	
	var posPlayer = transform.origin
	
	direction = Vector3() 
	
	moveZ= 0
	moveY= 0
	
	if Input.is_action_pressed("up"):
		moveY = 1
	if Input.is_action_pressed("down"):
		moveY = -1
	if Input.is_action_pressed("left"):
		moveZ =-1
	if Input.is_action_pressed("right"):
		moveZ = 1
		
		
	if moveZ >0 && posPlayer.z < limitHor : 
		direction.z = moveZ * strafe_speed *  delta
	if moveZ <0 && posPlayer.z >- limitHor : 	
		direction.z = moveZ * strafe_speed *  delta
	if moveY >0 && posPlayer.y < limitVer : 
		direction.y = moveY * strafe_speed *  delta
	if moveY <0 && posPlayer.y > -limitVer : 
		direction.y = moveY * strafe_speed *  delta
	
	print(" posPlayer.z " , posPlayer.z )
	print("moveZ " , moveZ  )	
	print(direction)
	direction.x = fly_speed  *10 *  delta	
	
	linear_velocity = direction
	
	
	

	
func turn(delta):
	
	angular_velocity = Vector3(0,0,0)
	
	var angles = transform.basis.get_euler()
	var anglesDegY = rad2deg(angles.y) 
	#print(" angle Y ", anglesDegY)
	
	turningAngles = Vector3(0,0,0)
		
			
	if moveZ < 0 && anglesDegY < turningAngleMax : 
		turningAngles.y = turningAngleSpeed * delta
		angular_velocity = Vector3(0,turningAngles.y, 0 ) 
		#print(" turning Y ")		
			
	if moveZ > 0 && anglesDegY >- turningAngleMax : 
		turningAngles.y = -turningAngleSpeed * delta
		angular_velocity = Vector3(0,turningAngles.y, 0 ) 
		#print(" turning Y ")		
			
			
	#if anglesDegY >0 or anglesDegY <0 && angular_velocity.y == 0 :
	#	stabilize(delta)	
		

		
	#if moveY > 0 : 
	
	
		 
	#shipAngles = shipAngles.linear_interpolate(	turningAngles, turningAngleSpeed * delta) 
 


	
	
func stabilize(delta):
	
	direction = Vector3(0,0,0)
	
	
	direction.x = fly_speed * delta *10 
	
	velocity = linear_velocity.linear_interpolate(direction,  0.0001 * delta) 
	
	linear_velocity = velocity
	
						
func fire(delta):
	timerFire -= delta
	if timerFire <= 0:
		timerFire = fireDelay
		print("fire")		
		var newBullet = bulletScnFile.instance();
		var levelNode = get_tree().get_root().get_node("Level1")
		#var levelNode = get_tree().get_root().get_node("Level1").get_node("levelBullets") 
		levelNode.add_child(newBullet);
		newBullet.global_transform.origin = $firePosition.global_transform.origin	
		#newBullet.transform.origin = $firePosition.transform.origin	
		newBullet.add_collision_exception_with(self) # Add it to bullet
		newBullet.init(transform.basis.x);
	
	
		

func _integrate_forces(state): 
	
	
	if(state.get_contact_count()>0): 
		
		
		for i in range(state.get_contact_count()):
			
			var cc = state.get_contact_collider_object(i);
			
			var nameObject = cc.get_name();							
		
			#print(state.get_contact_collider_object(i));
			
			if(cc.get_script()!=null && nameObject.begins_with("alienShip")): 
				getDamage(cc.damage);

func getDamage(value):
	if timerDamage == 0: 
		health -= value				
		if(health<=0):
			queue_free()
		timerDamage = timerDamageDelay	
		
		
	
		