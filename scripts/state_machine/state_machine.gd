extends Node

@export var initial_state: State
@onready var label = $"../Label"

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(change_state)
			
	if initial_state:
		initial_state.Enter()
		current_state= initial_state
			
func _process(delta):
	if current_state:
		current_state.Update(delta)
		
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func change_state(state, new_state_name):
	#print('State = ' + str(new_state_name))
	if state != current_state:
		#print("Invalid state change from: " + state.name + "but currently in: " + current_state.name)
		return
		
	var new_state = states.get(new_state_name.to_lower())	
	if !new_state:
		print("New state is empty")
		return
		
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
	label.text = str(current_state.get_name())	


# dangerous
func force_change_state(new_state : String):
	var newState = states.get(new_state.to_lower())
	
	if !newState:
		#print(new_state + "does not exist in the dictionary of states")
		return
	
	if current_state == newState:
		#print("State is the same, aborting")
		return
		
	if current_state:
		var exit_callable = Callable(current_state, "Exit")	
		exit_callable.call_deferred()
	
	newState.Enter()	
	
	current_state = newState
		
	
	
	
