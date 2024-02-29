extends Node

var dog_sleeping_sounds = [
	preload("res://assets/sounds/dog_sleeping/65601__becks77__rocco_russa.ogg"), preload("res://assets/sounds/dog_sleeping/106580__dibubba__opie-snoring-100-2.ogg"), preload("res://assets/sounds/dog_sleeping/106580__dibubba__opie-snoring-100.ogg"), preload("res://assets/sounds/dog_sleeping/156597__samueljustice00__animal_pug_dog_sleep_snore_inhale_exhale_breath_h4n_ntg3_20120527.ogg"), preload("res://assets/sounds/dog_sleeping/156597__samueljustice00__animal_pug_dog_sleep_snore_inhale_exhale_breath_h4n_ntg3_20120527_2.ogg"), preload("res://assets/sounds/dog_sleeping/185876__gurkboll__dog_is_snoring_20130424t1140.ogg"), preload("res://assets/sounds/dog_sleeping/234145__mingusassin__dog-snores.ogg"), preload("res://assets/sounds/dog_sleeping/235874__delphidebrain__sjuulke-snoring-2.ogg"), preload("res://assets/sounds/dog_sleeping/255129__alba_mtg__sam-snoring.ogg"), preload("res://assets/sounds/dog_sleeping/255129__alba_mtg__sam-snoring_2.ogg"), preload("res://assets/sounds/dog_sleeping/271446__mrauralization__snoring.ogg"), preload("res://assets/sounds/dog_sleeping/436940__filmscore__small-dog-snoring.ogg"), preload("res://assets/sounds/dog_sleeping/436940__filmscore__small-dog-snoring_2.ogg"), preload("res://assets/sounds/dog_sleeping/443292__ted__little-dog-snoring.ogg"), preload("res://assets/sounds/dog_sleeping/443292__ted__little-dog-snoring_2.ogg"), preload("res://assets/sounds/dog_sleeping/444864__alec_havinmaa__dog-snoring.ogg"), preload("res://assets/sounds/dog_sleeping/459990__lisa2shoes__pug-snoring2.ogg"), preload("res://assets/sounds/dog_sleeping/459990__lisa2shoes__pug-snoring2_2.ogg"), preload("res://assets/sounds/dog_sleeping/462926__ddustin99__dog-sleeping_1.ogg"), preload("res://assets/sounds/dog_sleeping/516871__filmscore__small-dog-snoring-3.ogg"), preload("res://assets/sounds/dog_sleeping/516871__filmscore__small-dog-snoring-3_2.ogg"), preload("res://assets/sounds/dog_sleeping/516871__filmscore__small-dog-snoring-3_3.ogg"), preload("res://assets/sounds/dog_sleeping/516872__filmscore__small-dog-snoring-2.ogg"), preload("res://assets/sounds/dog_sleeping/543643__5ound5murf23__zoom0027-dog-snore-3.ogg"), preload("res://assets/sounds/dog_sleeping/543643__5ound5murf23__zoom0027-dog-snore-3_2.ogg"), preload("res://assets/sounds/dog_sleeping/543644__5ound5murf23__zoom0025-dog-snore-2_2.ogg"), preload("res://assets/sounds/dog_sleeping/543645__5ound5murf23__dog-snore-1.ogg"), preload("res://assets/sounds/dog_sleeping/562867__buzzatsea__dog-snoring.ogg"), preload("res://assets/sounds/dog_sleeping/700316__daddy_z__french-bulldog-snoring.ogg"), preload("res://assets/sounds/dog_sleeping/705722__mudflea2__a-dog-snoring.ogg")
]

# [ [ bus_index, target ], ... ]
var volume_targets = []

var dog_sleeping_sounds_index = 0

var init_done = false

# AudioSourceObjects use get_dog_sleeping_sound() in their _ready() and that
# might happen before _ready() of this? probably not. maybe, not sure. init
# here, just to be sure
func init():
	randomize()
	dog_sleeping_sounds.shuffle()
	
	volume_targets.append([ AudioServer.get_bus_index("Master"), 0.0 ])
	volume_targets.append([ AudioServer.get_bus_index("background_menu"), -100.0 ])
	volume_targets.append([ AudioServer.get_bus_index("background_level"), -100.0 ])
	volume_targets.append([ AudioServer.get_bus_index("effects_excited"), -100.0 ])
	
	init_done = true

func get_dog_sleeping_sound():
	if not init_done:
		init()
	
	dog_sleeping_sounds_index += 1
	
	return dog_sleeping_sounds[dog_sleeping_sounds_index % dog_sleeping_sounds.size()]

func smooth2(a: float, b: float):
	return a + (b - a) * 0.1

func fade_process():
	for param in volume_targets:
		if abs(AudioServer.get_bus_volume_db(param[0]) - param[1]) > 0.01:
			AudioServer.set_bus_volume_db(param[0], smooth2(AudioServer.get_bus_volume_db(param[0]), param[1]))

func fade_set(bus_name: String, volume: float):
	var index = AudioServer.get_bus_index(bus_name)
	
	if index == null:
		return
	
	for param in volume_targets:
		if param[0] == index:
			param[1] = volume
			break

func _ready():
	if not init_done:
		init()

func _process(_delta):
	fade_process()
