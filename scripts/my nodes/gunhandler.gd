extends RigidBody3D

@onready var bullet = preload("res://scenes/bullet.tscn")

@onready var ammoLabel = Labels.get_node("VBoxContainer/ammoLabel")
@onready var WeapponNameLabel = Labels.get_node("VBoxContainer/weaponName")

@export var WeaponName: String = ""

@export var interactColliderObject: StaticBody3D
@export var gun: RigidBody3D
@export var barrel: RayCast3D
@export var handle: Marker3D

@export var InteractCollider: Node3D

@export var damage: int
@export var auto_delay: float
@export var single_delay: float
@export var mag_size: int
@export var ammo_reserve: int
@export var ammo_reserve_size: int
@export var ammo: int

@export var is_auto: bool

@export var eqquiped: bool
signal WeaponEquipped
signal WeaponUnequipped
signal fired
signal reloading

var interacted

var can_fire: bool
func _ready():
	self.set_gravity_scale(1)
	can_fire = true

var is_reloading = false

var player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if eqquiped == true:
		ammoLabel.text = str(ammo) + "/" + str(ammo_reserve)
		WeapponNameLabel.text = WeaponName
		#self.global_transform = player.get_node("Camera3D/HandlePoint").global_transform
		self.set_gravity_scale(0)
		if Input.is_action_just_pressed("reload") and is_reloading == false and not ammo == mag_size:
			print("reload")
			emit_signal("reloading")
			is_reloading = true
		if !is_reloading:
			shoot()
			drop()
		if Input.is_action_just_pressed("ui_accept"):
			print("can_fire " + str(can_fire) + " / " + "ammo " + str(ammo) + " / " + "is_auto " + str(is_auto))
	if eqquiped == false:
		self.set_gravity_scale(1)


func shoot():
	if Input.is_action_pressed("fire") and is_auto == true and ammo > 0 and can_fire == true:
		can_fire = false
		emit_signal("fired")
		spawn_bullet()
		ammo -= 1
		await get_tree().create_timer(auto_delay).timeout
		can_fire = true
	if Input.is_action_just_pressed("fire") and is_auto == false and ammo > 0 and can_fire == true:
		can_fire = false
		emit_signal("fired")
		spawn_bullet()
		ammo -= 1
		await get_tree().create_timer(single_delay).timeout
		can_fire = true

func spawn_bullet():
	var b = bullet.instantiate()
	b.damage = damage
	b.player = player
	b.gun = gun
	b.guninteract = interactColliderObject
	self.add_child(b)
	b.top_level = true
	b.global_transform.origin = gun.global_transform.origin

func reload():
	var old_ammo
	var new_ammo
	old_ammo = ammo
	if ammo_reserve >= mag_size:
		new_ammo = mag_size
		ammo_reserve -= (mag_size - old_ammo)
		ammo = new_ammo
		is_reloading = false
	if ammo_reserve < mag_size:
		new_ammo = ammo_reserve
		ammo_reserve = 0
		ammo = new_ammo
		is_reloading = false
	

func _on_interacted(body):
	player = body
	interacted = true
	if eqquiped == false and interacted == true:
		InteractCollider.disabled = true
		emit_signal("WeaponEquipped")
		eqquiped = true
		interacted = false

func drop():
	if Input.is_action_just_pressed("drop"):
		ammoLabel.text = ""
		WeapponNameLabel.text = ""
		InteractCollider.disabled = false
		emit_signal("WeaponUnequipped")
		eqquiped = false
		interacted = false


func _on_inputs_complete():
	if eqquiped:
		reload()
