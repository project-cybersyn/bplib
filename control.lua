--------------------------------------------------------------------------------
-- BPLIB CONTROL PHASE
--------------------------------------------------------------------------------

local counters = require("lib.core.counters")
local events = require("lib.core.events")
local actual = require("api.actual")

local function debug_log(...)
	local x = table.pack(...)
	x.n = nil
	if #x == 1 then x = x[1] end
	if game then
		game.print(serpent.line(x, { nocode = true }), {
			skip = defines.print_skip.never,
			sound = defines.print_sound.never,
			game_state = false,
		})
	else
		log(serpent.line(x, { nocode = true }))
	end
end
_G.debug_log = debug_log
events.set_strace_handler(debug_log)

require("control.events")
require("control.storage")

-- Enable support for the Global Variable Viewer debugging mod, if it is
-- installed.
if script.active_mods["gvv"] then require("__gvv__.gvv")() end

-- Startup

on_startup(counters.init, true)

script.on_init(raise_init)
on_init(function() raise_startup({}) end, true)
script.on_load(raise_load)

-- Blueprinting

script.on_event(defines.events.on_player_setup_blueprint, function(event)
	local player = game.get_player(event.player_index)
	if not player then return end
	local bp = actual.get_actual_blueprint(player, event.record, event.stack)
	if not bp then return end
	raise_blueprint_extract(event, player, bp)
end)

script.on_event(defines.events.on_pre_build, function(event)
	local player = game.get_player(event.player_index)
	if not player then return end
	-- Blueprint
	if player.is_cursor_blueprint() then
		local bp = actual.get_actual_blueprint(
			player,
			player.cursor_record,
			player.cursor_stack
		)
		if not bp then return end
		return raise_blueprint_apply(player, bp, player.surface, event)
	end
	-- Other buildable item
	raise_pre_build_from_item(event, player)
end)

-- Construction

---@param event AnyFactorioBuildEventData
local function handle_built_with_tags(event)
	raise_unified_build(event, event.entity, event.tags)
end

script.on_event(defines.events.on_built_entity, handle_built_with_tags)
script.on_event(defines.events.on_robot_built_entity, handle_built_with_tags)
script.on_event(
	defines.events.on_space_platform_built_entity,
	handle_built_with_tags
)
script.on_event(defines.events.on_entity_cloned, raise_entity_cloned)
script.on_event(defines.events.script_raised_built, function()
	-- TODO: tags not present here
end)
script.on_event(defines.events.script_raised_revive, handle_built_with_tags)

-- Deconstruction and death

local function handle_destroyed(event)
	raise_unified_destroy(event, event.entity)
end

script.on_event(defines.events.on_player_mined_entity, handle_destroyed)
script.on_event(defines.events.on_robot_mined_entity, handle_destroyed)
script.on_event(defines.events.on_space_platform_mined_entity, handle_destroyed)
script.on_event(defines.events.script_raised_destroy, handle_destroyed)

script.on_event(defines.events.on_post_entity_died, raise_entity_died)

-- Orientation

script.on_event(
	defines.events.on_player_flipped_entity,
	function(event) raise_player_flipped_entity(event, event.entity) end
)

script.on_event(
	defines.events.on_player_rotated_entity,
	function(event) raise_player_rotated_entity(event, event.entity) end
)

-- Settings

script.on_event(
	defines.events.on_entity_settings_pasted,
	function(event)
		raise_entity_settings_pasted(event, event.source, event.destination)
	end
)

-- API

remote.add_interface("bplib", _G.api)
