extends KinematicBody2D

var vectorVelocity=Vector2()
const horizontalSpeed=155

const jumpForce=290
var numberOfJumps=0
const maxNumberOfJumps=1

var jumpBuffer=0
var maximumJumpBuffer=10

var jumpPressBuffer=0
var maximumJumpPressBuffer=5

var gravity=0
var realGravity=0
var gravityHolding=12
var gravityNormal=17

var glitchABit=false
var anim=""

export (int) var blinkRadius=25
var daggerCount=1
var hasDagger=false

var glitchAura=preload("res://scenes/glitchAura/glitchAura.tscn")
var glitchDagger=preload("res://scenes/glitchDagger/glitchDagger.tscn")

var spawnCheckpoint=preload("res://scenes/checkpoint/checkpoint.tscn")
var checkpoint

func _ready():
#	OS.window_size*=2
	$glitchAim.visible=false
	self.add_to_group("Unglitchable")
	self.add_to_group("Player")
	var i=spawnCheckpoint.instance()
	i.global_position=self.global_position
	i.visible=false
	checkpoint=i
	get_parent().add_child(i)
	set_physics_process(true)
	getDagger()

func _physics_process(delta):
	if glitchABit:
		$sprite.vframes=int(rand_range(1,6))
		$sprite.hframes=int(rand_range(1,6))
	if anim!=$animationPlayer.current_animation:$animationPlayer.play(anim)
	
	jumpBuffer+=1
	jumpPressBuffer+=1
	
	gravity=gravityHolding if Input.is_action_pressed("ui_jump") else gravityNormal
	realGravity=lerp(realGravity,gravity,0.25)
	
	if self.is_on_floor():
		jumpBuffer=0
		numberOfJumps=0
	
	var inputDirection=Vector2()
	inputDirection.x=1 if Input.is_action_pressed("ui_right") else -1 if Input.is_action_pressed("ui_left") else 0
	inputDirection.y=1 if Input.is_action_pressed("ui_down") else -1 if Input.is_action_pressed("ui_up") else 0
	
	$sprite.flip_h=0 if inputDirection.x==1 else 1 if inputDirection.x==-1 else $sprite.flip_h
	$spriteWithDagger.flip_h=0 if inputDirection.x==1 else 1 if inputDirection.x==-1 else $spriteWithDagger.flip_h
	$spriteGlitched.flip_h=0 if inputDirection.x==1 else 1 if inputDirection.x==-1 else $spriteGlitched.flip_h
	
	$glitchAim.position=blinkRadius*(get_global_mouse_position()-self.global_position).normalized()
	
	if Input.is_action_just_pressed("ui_jump"):
		jumpPressBuffer=0
		
	if jumpPressBuffer<maximumJumpPressBuffer and numberOfJumps<maxNumberOfJumps and jumpBuffer<maximumJumpBuffer:
		vectorVelocity.y=-jumpForce
		numberOfJumps+=1
	
	if Input.is_action_just_pressed("ui_lmb") and daggerCount>0 and hasDagger:
		var i=glitchDagger.instance()
		i.global_position=$glitchAim.global_position
		i.direction=$glitchAim.position.normalized()
		i.returnTo=self
		i.add_collision_exception_with(self)
		get_parent().add_child(i)
		loseDagger()
#		daggerCount-=1
	
	if Input.is_action_just_pressed("ui_die"): self.die()

	var lerpConstant=0.1 if inputDirection.x!=0 else 0.25
	vectorVelocity.x=lerp(vectorVelocity.x,horizontalSpeed*inputDirection.x,lerpConstant)
	vectorVelocity.y+=realGravity
	
	vectorVelocity=move_and_slide(vectorVelocity,Vector2(0,-1))
	
	if self.is_on_floor():
		if abs(vectorVelocity.x)>0.5 and inputDirection.x!=0:
			anim="runCycle"
		else:
			anim="idle"
	else:
		if vectorVelocity.y<0:
			anim="jumpUp"
		else:
			anim="jumpDown"
	
func glitch():pass
func die():
	self.vectorVelocity=Vector2()
	self.global_position=checkpoint.global_position+Vector2(0,-16)
	
func loseDagger():
	self.hasDagger=false
	$sprite.visible=true
	$spriteWithDagger.visible=false
	$glitchAim.visible=true
	glitchABit=true
	$tmrToUnglitch.wait_time=rand_range(0.05,0.15)
	$tmrToUnglitch.start()
	if rand_range(0,1)>0.95 or true:
		$spriteGlitched.visible=true
		$spriteGlitched.frame=($spriteGlitched.frame+1)%$spriteGlitched.hframes
#		$sprite.visible=false

func getDagger():
	self.hasDagger=true
	$sprite.visible=false
	$spriteWithDagger.visible=true
	$glitchAim.visible=true
	glitchABit=false

func _on_tmrToUnglitch_timeout():
	glitchABit=false
#	$sprite.visible=true
	$sprite.vframes=4
	$sprite.hframes=8
	$spriteWithDagger.vframes=4
	$spriteWithDagger.hframes=8
	$spriteGlitched.visible=false
