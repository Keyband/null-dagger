extends CanvasLayer
var scene
var tweenDuration=0.75
var growingDiamond=preload("res://scenes/growingDiamond/growingDiamond.tscn")
var shrinkingDiamond=preload("res://scenes/shrinkingDiamond/shrinkingDiamond.tscn")
var diamond=preload("res://scenes/diamond/diamond.tscn")
func _ready():
	for x in range(0,11,1):
		for y in range(0,11):
			var i=diamond.instance()
			i.global_position=Vector2(x,y)*OS.window_size/10
			i.tweenDuration=self.tweenDuration
			add_child(i)
#			self.call_deferred("add_child",i)
#	for child in self.get_children():
#		child.grow()
	yield(get_tree().create_timer(tweenDuration),"timeout")
	get_tree().change_scene_to(scene)
	for child in self.get_children():
		child.shrink()
	yield(get_tree().create_timer(tweenDuration),"timeout")
	self.queue_free()
##	$colorRect.visible=false
#	for x in range(0,11,1):
#		for y in range(0,11):
#			var i=growingDiamond.instance()
#			i.global_position=Vector2(x,y)*OS.window_size/10
#			self.call_deferred("add_child",i)
#	yield(get_tree().create_timer(0.6),"timeout")
#	print("ALL BLACK @@@@@@@@@@@@@@@@@@@@")
#	$colorRect.visible=true
#	get_tree().change_scene_to(scene)
#	for x in range(0,11,1):
#		for y in range(0,11):
#			var i=shrinkingDiamond.instance()
#			i.global_position=Vector2(x,y)*OS.window_size/10
#			self.call_deferred("add_child",i)
#	$colorRect.visible=false
#	yield(get_tree().create_timer(0.6),"timeout")
#	print("BAI@@@@@@@@@@@@@@@@@@@@@@@@@")
#	self.queue_free()