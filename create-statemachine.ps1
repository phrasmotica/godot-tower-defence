param(
	[string] $Name,
	[string] $ParentDir
)

function PascalToSnake([string] $Value) {
	# taken from https://gist.github.com/awakecoding/acc626741704e8885da8892b0ac6ce64
	return [Regex]::Replace($Value, '(?<=.)(?=[A-Z])', '_').ToLower()
}

if (-not $Name) {
	Write-Error "Please provide a name for the machine!"
	return
}

Write-Host "Generating new state machine for '$Name'..."

$baseDir = PascalToSnake -Value $Name

mkdir "$ParentDir\$baseDir" | Out-Null

$baseFileName = "$(PascalToSnake -Value $Name).gd"

Write-Host "Writing base file '$baseFileName'..."

[IO.File]::WriteAllLines(
	"$ParentDir\$baseDir\$baseFileName",
	[string[]]@(
		"class_name $Name",
		"extends Node"
	)
)

$baseFileName = "$(PascalToSnake -Value $Name).gd"

Write-Host "Writing base file '$baseFileName'..."

[IO.File]::WriteAllLines(
	"$ParentDir\$baseDir\$baseFileName",
	[string[]]@(
		"class_name $Name",
		"extends Node",
		"",
		"enum State { ENABLED }"
	)
)

$stateFactoryFileName = "$(PascalToSnake -Value $Name)_state_factory.gd"

Write-Host "Writing state factory file '$stateFactoryFileName'..."

[IO.File]::WriteAllLines(
	"$ParentDir\$baseDir\$stateFactoryFileName",
	[string[]]@(
		"class_name $($Name)StateFactory",
		"",
		"var states: Dictionary",
		"",
		"func _init() -> void:",
		"`tstates = {",
		"`t`t$($Name).State.ENABLED: $($Name)StateEnabled,",
		"`t}",
		"",
		"func get_fresh_state(state: $($Name).State) -> $($Name)State:",
		"`tassert(states.has(state), `"State is missing!`")",
		"`treturn states.get(state).new()"
	)
)

$statesDir = "states"

mkdir "$ParentDir\$baseDir\$statesDir" | Out-Null

$stateDataFileName = "$(PascalToSnake -Value $Name)_state_data.gd"

Write-Host "Writing state data file '$stateDataFileName'..."

[IO.File]::WriteAllLines(
	"$ParentDir\$baseDir\$statesDir\$stateDataFileName",
	[string[]]@(
		"class_name $($Name)StateData",
		"",
		"static func build() -> $($Name)StateData:",
			"`treturn $($Name)StateData.new()"
	)
)

$baseStateFileName = "$(PascalToSnake -Value $Name)_state.gd"

Write-Host "Writing base state file '$baseStateFileName'..."

[IO.File]::WriteAllLines(
	"$ParentDir\$baseDir\$statesDir\$baseStateFileName",
	[string[]]@(
		"class_name $($Name)State",
		"extends Node",
		""
		"signal state_transition_requested(new_state: $($Name).State, state_data: $($Name)StateData)"
		""
		"var _button: $($Name) = null"
		"var _state_data: $($Name)StateData = null"
		""
		"func setup("
		"`tbutton: $($Name),"
		"`tstate_data: $($Name)StateData,"
		") -> void:"
		"`t_button = button"
		"`t_state_data = state_data"
		""
		"func transition_state("
		"`tnew_state: $($Name).State,"
		"`tstate_data := $($Name)StateData.new(),"
		") -> void:"
		"`tstate_transition_requested.emit(new_state, state_data)"
	)
)

$enabledStateFileName = "$(PascalToSnake -Value $Name)_state_enabled.gd"

Write-Host "Writing enabled state file '$enabledStateFileName'..."

[IO.File]::WriteAllLines(
	"$ParentDir\$baseDir\$statesDir\$enabledStateFileName",
	[string[]]@(
		"class_name $($Name)StateEnabled",
		"extends $($Name)State",
		"",
		"func _enter_tree() -> void:"
			"`tprint(`"$Name is now enabled`")"
	)
)
