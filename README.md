# godot-agent-assist-template

A Godot 4.7 starter for **agent-assisted** development: you build the game in the Godot editor, and a coding agent (Claude Code, Codex, etc.) helps you write GDScript. The agent is set up to follow Godot 4 conventions, not to build the game for you.

## Use this template

1. Click **Use this template → Create a new repository** on GitHub. Don't fork or clone this repo directly; the template creates a clean repo with its own history.
2. Clone your new repo.
3. **Rename the project before importing it** into Godot: change `config/name="My Game"` in `project.godot`. You can rename it later under *Project → Project Settings → Application → Config*, but the name is what shows in the Project Manager.
4. Open Godot 4.7+, click **Import**, and pick the `project.godot` file.
5. Replace this README and `LICENSE` with your own (see [License](#license)).

## What's inside

```
.claude/skills/godot-gdscript-conventions/  Agent skill: Godot 4 GDScript conventions
.claude/agents/gdscript-reviewer.md         Subagent that reviews GDScript against the conventions
docs/godot-gdscript-rules.md                Full convention rules, readable by humans and agents
AGENTS.md                                   Agent instructions (CLAUDE.md imports it)
autoloads/event_bus.gd                      Global signal bus (Autoload "EventBus")
components/health_component.gd              Reusable health node
scenes/main/                                Main scene: floor, light, sky, player
scenes/player/                              CharacterBody3D player, stats Resource
assets/                                     Models, textures, audio
```

Folders are organized by feature: a scene lives next to its script and data. Add new features as `scenes/<feature>/`.

The example is a capsule you can move with **WASD** and **Space**. Falling off the floor kills the player and reloads the scene, which shows a component, a Resource, a signal going up to the parent, and the EventBus.

## Working with an agent

- Agents read `AGENTS.md`, which tells them to use the `godot-gdscript-conventions` skill when touching `.gd` files.
- Keep scene and node work in the editor. Ask the agent for scripts, refactors, reviews and debugging.
- Agents can check for script errors by running Godot headless: `godot --headless --path . --quit`.

## License

The template is released under the [MIT License](LICENSE). Projects you create from it are yours: replace `LICENSE` with whatever license you choose.
