# godot-agent-assist-template

A Godot 4.7 starter for **agent-assisted** development: you build the game in the Godot editor, and a coding agent (Claude Code, Codex, etc.) helps you write GDScript. The agent is set up to follow Godot 4 conventions, not to build the game for you.

## Prerequisites

- [Godot 4.7+](https://godotengine.org/download) (standard build, not .NET)
- Git
- A coding agent such as Claude Code or Codex, started from the repo root so it picks up `AGENTS.md`

## Use this template

1. Click **Use this template → Create a new repository** on GitHub. Don't fork or clone this repo directly; the template creates a clean repo with its own history.
2. Clone your new repo.
3. **Rename the project before importing it** into Godot: change `config/name="My Game"` in `project.godot`. You can rename it later under *Project → Project Settings → Application → Config*, but the name is what shows in the Project Manager.
4. Open Godot 4.7+, click **Import**, and pick the `project.godot` file.
5. Replace this README and `LICENSE` with your own (see [License](#license)).

## What's inside

```
.claude/skills/godot-gdscript-conventions/  GDScript conventions (Claude skill; other agents read it via AGENTS.md)
.claude/agents/gdscript-reviewer.md         Subagent that reviews GDScript against the conventions
AGENTS.md                                   Agent instructions (CLAUDE.md imports it)
autoloads/event_bus.gd                      Global signal bus (Autoload "EventBus")
components/health_component.gd              Reusable health node
scenes/main/                                Main scene: floor, light, sky, player
scenes/player/                              CharacterBody3D player, stats Resource
assets/                                     Models, textures, audio
```

Folders are organized by feature: a scene lives next to its script and data. Add new features as `scenes/<feature>/`.

The example is a capsule you can move with **WASD** and **Space**. Falling off the floor kills the player and reloads the scene, which shows a component, a Resource, a signal going up to the parent, and the EventBus.

## Remove the example

When you start your own game:

1. Create your own main scene and set it under *Project → Project Settings → Application → Run → Main Scene*.
2. Delete `scenes/main/` and `scenes/player/` in the Godot FileSystem dock (it keeps `.uid` files in sync).
3. Remove `signal player_died` from `autoloads/event_bus.gd`.
4. Keep or delete `components/health_component.gd` and the input actions under *Project Settings → Input Map*.

## Working with an agent

- Agents read `AGENTS.md`, which points them to the GDScript conventions and tells them how to check scripts headless.
- Keep scene and node work in the editor. Ask the agent for scripts, refactors, reviews and debugging, for example:
  - "Write a script for an enemy that walks toward the player and deals damage on contact."
  - "Add a pause menu script that toggles `get_tree().paused` on Escape."
  - "Review my changes in `scenes/player/`."
- If `godot` isn't on your PATH, tell the agent where the Godot executable is.

## Large assets

Git handles a few images and sounds fine, but big models, textures and audio bloat the history. When your assets grow, install [Git LFS](https://git-lfs.com/) and uncomment the LFS lines in `.gitattributes`. Mind GitHub's LFS storage and bandwidth quotas.

## License

The template is released under the [MIT License](LICENSE). Projects you create from it are yours: replace `LICENSE` with whatever license you choose.
