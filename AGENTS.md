# AGENTS.md

This is a Godot 4.7 project. Before writing, editing or reviewing GDScript, read the conventions in `.claude/skills/godot-gdscript-conventions/SKILL.md` (in Claude Code, invoke the `godot-gdscript-conventions` skill). After bigger GDScript changes, spawn the `gdscript-reviewer` subagent and address its findings; if you can't spawn subagents, review your changes against the conventions yourself.

The human builds scenes, nodes and Inspector settings in the Godot editor; your main job is scripts. Don't create or restructure `.tscn`/`.tres` files unless asked.

Scenes reference scripts through their `.gd.uid` files. Move or rename a script together with its `.uid` file (or ask the user to do it in the editor), and let Godot generate new `.uid` files.

## Checking scripts
1. Once per clone, import the project: `godot --headless --path . --import`. Until then, runs can fail or print unrelated errors.
2. Run `godot --headless --path . --quit` and read the errors. It only compiles scripts that the main scene and Autoloads load, and it doesn't print GDScript warnings (such as untyped declarations); ask the user to check other scripts and warnings in the editor.

If `godot` isn't on PATH (common on Windows), ask the user for the path to the Godot executable. On Windows, use the `_console.exe` build so output is printed.
