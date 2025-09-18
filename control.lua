--------------------------------------------------------------------------------
-- BPLIB CONTROL PHASE
--------------------------------------------------------------------------------

local counters = require("lib.core.counters")
local events = require("lib.core.events")
local blueprint = require("__bplib__.blueprint")

--------------------------------------------------------------------------------
-- DEBUG
--------------------------------------------------------------------------------

local function debug_log(...)
	local x = table.pack(...)
	x.n = nil
	if #x == 1 then x = x[1] end
	log(serpent.line(x, { nocode = true }))
end
_G.debug_log = debug_log
events.set_strace_handler(debug_log)

local event_name_reverse_map = {
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

-- Remote interface
_G.api = {}

require("control.events")
require("storage")

require("tags")

-- Enable support for the Global Variable Viewer debugging mod, if it is
-- installed.
if script.active_mods["gvv"] then require("__gvv__.gvv")() end

-- Startup

on_startup(counters.init, true)

script.on_init(raise_init)
on_init(function() raise_startup({}) end, true)
script.on_load(raise_load)

---@type serpent.options

-- Blueprinting

---@type bplib.BlueprintExtractionState|nil
_G.blueprint_extraction_state = nil

script.on_event(defines.events.on_player_setup_blueprint, function(event)
	local player = game.get_player(event.player_index)
	if not player then return end
	local bp = blueprint.get_actual_blueprint(player, event.record, event.stack)
	if not bp then return end

	---@type bplib.BlueprintExtractionState
	local state = {
		player = player,
		blueprint = bp,
		cause = event,
		mapping = event.mapping.get(),
	}
	---@diagnostic disable-next-line: global-element
	blueprint_extraction_state = state

	debug_log("extract blueprint begin")
	raise_blueprint_extract(state)
	script.raise_event("bplib-on_blueprint_extract", {
		player_index = player.index,
		key = "on_blueprint_extract",
	})
	debug_log("extract blueprint end")

	---@diagnostic disable-next-line: global-element
	blueprint_extraction_state = nil
end)

script.on_event(defines.events.on_pre_build, function(event)
	local player = game.get_player(event.player_index)
	if (not player) or (not player.is_cursor_blueprint()) then return end
	local bp = blueprint.get_actual_blueprint(
		player,
		player.cursor_record,
		player.cursor_stack
	)
	if not bp then return end
	raise_blueprint_apply(player, bp, player.surface, event)
end)

-- Construction

---@alias bplib.FactorioBuildEventData EventData.script_raised_built|EventData.script_raised_revive|EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_entity_cloned|EventData.on_space_platform_built_entity

---@param event bplib.FactorioBuildEventData
local function handle_built(event)
	local entity = event.entity or event.destination
	if not entity then return end

	if entity.name == "entity-ghost" then
		-- Ghost created
		debug_log("ghost created", entity, event_name_reverse_map[event.name])
	else
		-- Nonghost created
		debug_log("nonghost created", entity, event_name_reverse_map[event.name])
	end
end

script.on_event(defines.events.on_built_entity, handle_built)
script.on_event(defines.events.on_robot_built_entity, handle_built)
script.on_event(defines.events.on_space_platform_built_entity, handle_built)
script.on_event(defines.events.on_entity_cloned, handle_built)
script.on_event(defines.events.script_raised_built, handle_built)
script.on_event(defines.events.script_raised_revive, handle_built)

-- Deconstruction

---@alias bplib.FactorioDestroyEventData EventData.on_player_mined_entity|EventData.on_robot_mined_entity|EventData.on_space_platform_mined_entity|EventData.script_raised_destroy

local function handle_destroyed(event)
	local entity = event.entity
	if not entity then return end

	if entity.name == "entity-ghost" then
		-- Ghost destroyed
		debug_log("ghost destroyed", entity, event_name_reverse_map[event.name])
	else
		-- Nonghost destroyed
		debug_log("nonghost destroyed", entity, event_name_reverse_map[event.name])
	end
end

script.on_event(defines.events.on_player_mined_entity, handle_destroyed)
script.on_event(defines.events.on_robot_mined_entity, handle_destroyed)
script.on_event(defines.events.on_space_platform_mined_entity, handle_destroyed)
script.on_event(defines.events.script_raised_destroy, handle_destroyed)

remote.add_interface("bplib", _G.api)
