-- Import bplib.
local bplib = require("__bplib__.blueprint")
local BlueprintBuild = bplib.BlueprintBuild
local BlueprintSetup = bplib.BlueprintSetup

------------------------------------------
-- SETUP
------------------------------------------

-- Store tags associated with your custom entity whenever a blueprint
-- is being setup. Works with books, inventory, local, and global blueprint
-- libraries. Works with "replace contents" button.
script.on_event(defines.events.on_player_setup_blueprint, function(event)
	-- Create the temporary setup object that allows manipulation via bplib
	local bp_setup = BlueprintSetup:new(event)
	if not bp_setup then return end

	-- Get a map from blueprint indices to world entities.
	local map = bp_setup:map_blueprint_indices_to_world_entities()
	if not map then return end

	-- Check for any entities matching your custom entity
	for bp_index, entity in pairs(map) do
		if entity.name == "my-custom-entity" then
			-- Calculate your custom tags here based on information about your
			-- entity.
			bp_setup:apply_tags(bp_index, { test = "test" })
		end
	end
end)

------------------------------------------
-- BUILD
------------------------------------------

---@param bp_entity BlueprintEntity
local function blueprint_entity_filter(bp_entity)
	return bp_entity.name == "my-custom-entity"
end

---@param tags Tags
---@param entity LuaEntity
local function apply_blueprint_tags(tags, entity)
	-- Insert your custom logic for applying tags to an existing entity.
end

-- When a blueprint containing your custom entity is stamped down over an
-- existing entity, use the tags stored in the blueprint to update your
-- entity's state.
script.on_event(defines.events.on_pre_build, function(event)
	local bp_build = BlueprintBuild:new(event)
	-- Will be `nil` if the event was not a blueprint build.
	if not bp_build then return end

	-- Get entities in the blueprint that (1) match your custom entity and
	-- (2) are being placed over existing entities.
	local overlap_map = bp_build:map_blueprint_indices_to_overlapping_entities(
		blueprint_entity_filter
	)
	if not overlap_map or (not next(overlap_map)) then return end

	-- Map blueprint tags on to the entities
	local bp_entities = bp_build:get_entities() --[[@as BlueprintEntity[] ]]
	for bp_index, entity in pairs(overlap_map) do
		local tags = bp_entities[bp_index].tags or {}
		apply_blueprint_tags(tags, entity)
	end
end)
