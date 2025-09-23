local event = require("lib.core.events").create_event

_G.on_init, _G.raise_init = event("init", "nil", "nil", "nil", "nil", "nil")

_G.on_load, _G.raise_load = event("load", "nil", "nil", "nil", "nil", "nil")

---Information relating to resetting stored game state.
---@class bplib.ResetData

---Event raised on startup or after clearing the global state.
---* Arg 1 - `bplib.ResetData` - The reset data object. May contain handoff
---information if called after a reset.
_G.on_startup, _G.raise_startup =
	event("startup", "bplib.ResetData", "nil", "nil", "nil", "nil")

---String event names for debugging.
_G.DEFINES_EVENTS_REVERSE_MAP = {
	[defines.events.on_built_entity] = "on_built_entity",
	[defines.events.on_robot_built_entity] = "on_robot_built_entity",
	[defines.events.on_space_platform_built_entity] = "on_space_platform_built_entity",
	[defines.events.script_raised_revive] = "script_raised_revive",
	[defines.events.on_entity_cloned] = "on_entity_cloned",
	[defines.events.script_raised_built] = "script_raised_built",
	[defines.events.on_player_mined_entity] = "on_player_mined_entity",
	[defines.events.on_robot_mined_entity] = "on_robot_mined_entity",
	[defines.events.on_space_platform_mined_entity] = "on_space_platform_mined_entity",
	[defines.events.script_raised_destroy] = "script_raised_destroy",
}

---@alias AnyFactorioBuildEventData EventData.script_raised_built|EventData.script_raised_revive|EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_entity_cloned|EventData.on_space_platform_built_entity

---@alias AnyFactorioDestroyEventData EventData.on_player_mined_entity|EventData.on_robot_mined_entity|EventData.on_space_platform_mined_entity|EventData.script_raised_destroy

---Event raised representing a union of all Factorio's possible build events.
_G.on_unified_build, _G.raise_unified_build = event(
	"unified_build",
	"AnyFactorioBuildEventData",
	"LuaEntity",
	"Tags",
	"nil",
	"nil"
)

---@class bplib.BlueprintExtractionState
---@field player LuaPlayer The player extracting the blueprint.
---@field blueprint bplib.Blueprintish The blueprint being extracted.
---@field cause EventData.on_player_setup_blueprint The original event data from Factorio.
---@field mapping {[uint]: LuaEntity} Mapping from blueprint indices to actual entities.

---Event raised when a player extracts a blueprint.
_G.on_blueprint_extract, _G.raise_blueprint_extract = event(
	"blueprint_extract",
	"EventData.on_player_setup_blueprint",
	"LuaPlayer",
	"bplib.Blueprintish",
	"nil",
	"nil"
)

---Event raised when a player pre-builds a blueprint.
_G.on_blueprint_apply, _G.raise_blueprint_apply = event(
	"blueprint_apply",
	"LuaPlayer",
	"bplib.Blueprintish",
	"LuaSurface",
	"EventData.on_pre_build",
	"nil"
)

---Player pre-builds something from a non-blueprint item.
_G.on_pre_build_from_item, _G.raise_pre_build_from_item = event(
	"pre_build_from_item",
	"EventData.on_pre_build",
	"LuaPlayer",
	"nil",
	"nil",
	"nil"
)

_G.on_entity_cloned, _G.raise_entity_cloned = event(
	"entity_cloned",
	"EventData.on_entity_cloned",
	"nil",
	"nil",
	"nil",
	"nil"
)

_G.on_unified_destroy, _G.raise_unified_destroy = event(
	"unified_destroy",
	"AnyFactorioDestroyEventData",
	"LuaEntity",
	"nil",
	"nil",
	"nil"
)

_G.on_entity_died, _G.raise_entity_died = event(
	"entity_died",
	"EventData.on_post_entity_died",
	"nil",
	"nil",
	"nil",
	"nil"
)

_G.on_player_flipped_entity, _G.raise_player_flipped_entity = event(
	"player_flipped_entity",
	"EventData.on_player_flipped_entity",
	"LuaEntity",
	"nil",
	"nil",
	"nil"
)

_G.on_player_rotated_entity, _G.raise_player_rotated_entity = event(
	"player_rotated_entity",
	"EventData.on_player_rotated_entity",
	"LuaEntity",
	"nil",
	"nil",
	"nil"
)

_G.on_entity_settings_pasted, _G.raise_entity_settings_pasted = event(
	"entity_settings_pasted",
	"EventData.on_entity_settings_pasted",
	"LuaEntity",
	"LuaEntity",
	"nil",
	"nil"
)
