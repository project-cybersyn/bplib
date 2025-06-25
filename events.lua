local event = require("__bplib__.lib.events").create_event

_G.on_init, _G.raise_init = event("init", "nil", "nil", "nil", "nil", "nil")

_G.on_load, _G.raise_load = event("load", "nil", "nil", "nil", "nil", "nil")

---Information relating to resetting stored game state.
---@class bplib.ResetData

---Event raised on startup or after clearing the global state.
---* Arg 1 - `bplib.ResetData` - The reset data object. May contain handoff
---information if called after a reset.
_G.on_startup, _G.raise_startup =
	event("startup", "bplib.ResetData", "nil", "nil", "nil", "nil")

---@class bplib.BlueprintExtractionState
---@field player LuaPlayer The player extracting the blueprint.
---@field blueprint bplib.Blueprintish The blueprint being extracted.
---@field cause EventData.on_player_setup_blueprint The original event data from Factorio.
---@field mapping {[uint]: LuaEntity} Mapping from blueprint indices to actual entities.

_G.on_blueprint_extract, _G.raise_blueprint_extract = event(
	"blueprint_extract",
	"bplib.BlueprintExtractionState",
	"nil",
	"nil",
	"nil",
	"nil"
)

_G.on_blueprint_apply, _G.raise_blueprint_apply = event(
	"blueprint_apply",
	"LuaPlayer",
	"bplib.Blueprintish",
	"LuaSurface",
	"EventData.on_pre_build",
	"nil"
)
