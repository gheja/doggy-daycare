extends Node

# [ [ bus_index, volume, pan, AudioEffectPanner, in_use ],  ... ]
var parameters = []

func bus_index_to_array_index(bus_index):
	for i in range(parameters.size()):
		if parameters[i][0] == bus_index:
			return i
	
	return -1

func set_volume(index: int, volume: float):
	parameters[index][1] = volume

func set_pan(index: int, pan: float):
	parameters[index][2] = pan

func init():
	var s
	var panner
	
	for bus_index in range(AudioServer.bus_count):
		s = AudioServer.get_bus_name(bus_index)
		
		if s.substr(0, 12) == "directional_":
			panner = AudioEffectPanner.new()
			AudioServer.add_bus_effect(bus_index, panner)
			parameters.append([ bus_index, -100.0, 0.0, panner, false ])
			AudioServer.set_bus_volume_db(bus_index, -100.0)
			AudioServer.set_bus_mute(bus_index, false)

func allocate_dam():
	for i in range(parameters.size()):
		if parameters[i][4] == false:
			parameters[i][4] = true
			return i
	
	# print("DAM: could not allocate")
	
	return -1

func release_dam(index: int):
	if index == -1:
		return
	
	parameters[index][1] = -100.0 # volume
	parameters[index][2] = 0.0 # pan
	parameters[index][4] = false # in_use

func get_bus_name(i: int):
	return AudioServer.get_bus_name(parameters[i][0])

func process():
	var bus_index: int
	var panner: AudioEffectPanner
	
	# print("DAM: process")
	
	for param in parameters:
		bus_index = param[0]
		
		# print("DAM: process bus_index ", bus_index)
		
		if param[4] == false: # in_use
			continue
		
		# print(param)
		
		panner = param[3] as AudioEffectPanner
		
		if abs(AudioServer.get_bus_volume_db(bus_index) - param[1]) > 0.01:
			AudioServer.set_bus_volume_db(bus_index, param[1])
		
		if abs(panner.pan - param[2]) > 0.01:
			panner.pan = param[2]

### threading

var thread: Thread
var stopping = false

func start():
	print("DAM: start")
	thread = Thread.new()
	thread.start(self, "main_loop", null, Thread.PRIORITY_HIGH)

func stop():
	print("DAM: stop")
	if not thread:
		return
	
	stopping = true
	thread.wait_to_finish()

func main_loop():
	while not stopping:
		process()
		# OS.delay_usec(200000)
		OS.delay_msec(20)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		stop()
