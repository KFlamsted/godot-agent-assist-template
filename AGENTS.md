# AGENTS.md

This is a Godot 4.7 project. Invoke the `godot-gdscript-conventions` skill before writing, editing or reviewing GDScript. The full rule set is in `docs/godot-gdscript-rules.md`. After bigger GDScript changes, spawn the `gdscript-reviewer` subagent and address its findings.

The human builds scenes, nodes and Inspector settings in the Godot editor; your main job is scripts. Don't create or restructure `.tscn`/`.tres` files unless asked.
