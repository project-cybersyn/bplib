local tlib = require("lib.core.table")

-- Synthesis of construction events

on_blueprint_extract(function(event, player, bp)
	debug_log("on_blueprint_extract", event)
	local lazy_bp_to_world = event.mapping
	if not lazy_bp_to_world or not lazy_bp_to_world.valid then
		debug_log("on_blueprint_extract: no mapping")
		return
	end
	local bp_to_world = lazy_bp_to_world.get() --[[@as { [integer]: LuaEntity }|nil ]]
	if not bp_to_world then
		debug_log("on_blueprint_extract: empty mapping")
		return
	end

	local extraction = Extraction:new()

	-- Assign internal IDs to entities in the blueprint we know about
	for idx, entity in pairs(bp_to_world) do
		if (not entity.valid) or not entity.unit_number then goto continue end
		local thing = get_thing_by_unit_number(entity.unit_number)
		if not thing then goto continue end
		debug_log("on_blueprint_extract: known entity in blueprint", thing, entity)
		local local_id = extraction:map(thing)
		local tags = tlib.assign({}, thing.tags)
		tags["@i"] = local_id
		tags["@ig"] = nil
		bp.set_blueprint_entity_tags(idx, tags)
		::continue::
	end
	-- Remap parent/child relationships
	-- Store graph relationships

	extraction:destroy()
end)

on_blueprint_apply(function(player, blueprint, surface, event)
	debug_log("on_blueprint_apply", player, blueprint, surface, event)
	-- Create application record
end)

on_pre_build_from_item(
	function(event, player) debug_log("on_pre_build_from_item", event, player) end
)

---@param event AnyFactorioBuildEventData
---@param ghost LuaEntity
---@param tags? Tags
local function built_ghost(event, ghost, tags)
	debug_log("built_ghost", event, ghost, tags)
	-- Sanity check: we shouldnt know about this ghost already
	-- TODO: Remove when stable
	if get_thing_by_unit_number(ghost.unit_number) then
		error("built_ghost: somehow we already know about this ghost")
	end
	-- Ghost is someone we knew who died
	local known = get_thing_by_unit_number(ghost.ghost_unit_number)
	if known then
		debug_log("built_ghost: ghost of a dead bplib entity:", known)
		return
	end
	-- Ghost is a tagged bplib object from a blueprint
	if tags and tags["@i"] then
		local local_id = tags["@i"] --[[@as int]]
		debug_log(
			"built_ghost: ghost from a bplib blueprint with local_id",
			local_id
		)
		-- Start a file on it
		local erec = Thing:new()
		erec.entity = ghost
		erec.local_id = local_id
		-- Remove the tag
		tags["@i"] = nil
		tags["@ig"] = erec.id
		ghost.tags = tags
		erec.tags = tags
		erec:set_state("initial_ghost")
	end
end

local function built_real(event, entity, tags)
	debug_log("built_real", event, entity, tags)
	-- Real is a tagged bplib object from a blueprint.
	-- (It must've been built via cheat/editor because it skipped ghost state)
	if tags and tags["@i"] then
		local local_id = tags["@i"]
		debug_log("built_real: real from a bplib blueprint with local_id", local_id)
		-- Start a file on it
		local erec = Thing:new()
		erec.entity = entity
		erec.local_id = local_id
		-- Remove the tag
		tags["@i"] = nil
		tags["@ig"] = erec.id
		erec.tags = tags
		erec:set_state("real")
	end
end

on_unified_build(function(event, entity, tags)
	debug_log("on_unified_build", event, entity, tags)
	-- debug_log(
	-- 	"n/t sdxn/dxn/mirroring: ",
	-- 	entity.name,
	-- 	entity.type,
	-- 	entity.supports_direction,
	-- 	entity.direction,
	-- 	entity.mirroring
	-- )

	if entity.name == "entity-ghost" then
		built_ghost(event, entity, tags)
	else
		built_real(event, entity, tags)
	end
end)

on_entity_cloned(function(event) debug_log("on_entity_cloned", event) end)

on_player_flipped_entity(function(event, entity)
	debug_log("on_player_flipped_entity", event)
	debug_log("entity flipped", entity.name, entity.direction, entity.mirroring)
end)

on_player_rotated_entity(function(event, entity)
	debug_log("on_player_rotated_entity", event)
	debug_log("entity rotated", entity.name, entity.direction, entity.mirroring)
end)
