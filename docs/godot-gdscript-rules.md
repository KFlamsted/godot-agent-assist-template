# Godot 4 GDScript Conventions
This document contains Godot 4 GDScript code conventions that has been made from wshobson/agents `godot-gdscript-patterns` (SKILL.md, details.md, advanced-patterns.md).

## Godot 4 only
- Target Godot 4.x. Never emit Godot 3 syntax: `KinematicBody2D`, `export var`, `onready var`, `move_and_slide(velocity)`, `yield`.
- Use `CharacterBody2D/3D` + `velocity` + `move_and_slide()` (no args), `@export`, `@onready`, `await`, `signal.emit()`, `signal.connect(callable)`.

## Script layout (in this order)
1. `class_name`, `extends`
2. `signal` declarations (past tense: `died`, `health_changed`)
3. `enum`, `const`
4. `@export` vars (group with `@export_group`, constrain with `@export_range`)
5. Public vars, then private vars with `_` prefix
6. `@onready` node refs
7. Built-ins (`_ready`, `_process`, `_physics_process`, input), then public methods, then `_private` methods

## Typing
- Type everything: vars, params, return values (`-> void`). Use `:=` when the type is obvious.
- Use typed arrays (`Array[Node]`) and typed math helpers (`maxf`, `mini`, `clampi`).
- Use `StringName` for state names, item types and other identifiers.

## Communication
- Call down, signal up: parents call children's methods; children emit signals.
- Avoid hard references between sibling scenes. Use signals, or `@export var x: SomeType` set in the Inspector.
- Global event bus (Autoload with only `signal` declarations) for events many unrelated systems care about. Don't route everything through it.
- Use property setters to emit change signals (`set(value): score = value; score_changed.emit(score)`).

## Autoloads
- Only for truly global systems: GameManager, EventBus, SceneManager, SaveManager, audio.
- Set `process_mode = PROCESS_MODE_ALWAYS` on managers that must run while the tree is paused (e.g. pause handling).
- Don't make Autoloads depend on each other in `_ready()`; load order is fragile.

## Resources (data)
- Keep static data in custom `Resource` classes (`class_name WeaponData extends Resource`) with `@export` fields. Keep them data-only.
- Resources are shared by default. Before mutating at runtime, copy: `stats = base_stats.duplicate()`.
- `duplicate()` is shallow; use `duplicate(true)` if the resource contains sub-resources you will modify.
- Don't read exported values in a Resource's `_init()`; they aren't applied yet when loading from `.tres`. Initialize runtime state in a separate method.

## State machines
- Node-based: a `StateMachine` node with `State` children (`enter`, `exit`, `update`, `physics_update`, `handle_input`).
- Disable inactive states with `process_mode = PROCESS_MODE_DISABLED`; machine forwards `_process`/`_physics_process`/`_unhandled_input` to the active state.
- `transition_to(name, msg := {})`: validate the name (`push_error` if missing), call `exit()` then `enter(msg)`, emit `state_changed(from, to)`.
- For simple game-wide state, an `enum` + `match` is enough.

## Components (composition over inheritance)
- Split reusable behaviour into child nodes: `HealthComponent`, `HitboxComponent` (deals damage), `HurtboxComponent` (receives it).
- Hitbox ignores its own owner; hurtbox forwards damage to an exported `HealthComponent`.
- `HealthComponent`: clamp health in a setter, return actual damage dealt, emit `damaged`, `healed`, `died`. Ignore damage when already dead or invincible.

## Object pooling
- Pool anything spawned often (bullets, effects, enemies) instead of `instantiate()`/`queue_free()` each time.
- Inactive instances: `process_mode = DISABLED` and `visible = false`. Reactivate with `INHERIT`.
- Pooled objects emit `returned_to_pool` instead of freeing themselves; optional `on_spawn()`/`on_despawn()` hooks reset state.
- Decide whether the pool may grow; `push_warning` when exhausted.

## Scene management
- Central SceneManager Autoload. Load large scenes async with `ResourceLoader.load_threaded_request(path)` and poll `load_threaded_get_status` each frame (`await get_tree().process_frame`).
- Use `ResourceLoader.has_cached(path)` to skip loading. Handle failure status with `push_error`.
- Swap: `queue_free()` old scene, `add_child` new to root, set `get_tree().current_scene`. Await transitions around the swap.

## Saving
- Always save under `user://`, never `res://` (read-only in exports).
- Save plain data (Dictionaries, numbers, strings) via JSON. Never serialize Node references.
- `JSON.parse_string` returns all numbers as `float`; cast back to `int` on load.
- Check `FileAccess.open(...)` for `null` and report errors via a signal or `push_error`.
- A `Saveable` child node with a stable `save_id` can collect/restore per-node data. Prefer an explicit ID over `get_path()`, which breaks when the tree changes.
- `open_encrypted_with_pass` with a key in the source only deters casual editing; it is not real protection.

## Performance
- Cache node refs with `@onready`; never call `$Node`/`get_node()` in `_process` or loops.
- Avoid allocations in hot paths; reuse arrays with `.clear()`.
- Use `_physics_process` for movement/physics, `_process` for visuals.
- Turn off work when idle: `set_process(false)`, `set_physics_process(false)` (e.g. off-screen nodes).
- Measure with the Profiler before optimizing.

## Error handling
- `push_error` for bugs/invalid state, `push_warning` for recoverable issues. Don't fail silently.
- Use `is_instance_valid(node)` before touching nodes that may have been freed, especially after `await`.
