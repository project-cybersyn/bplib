--------------------------------------------------------------------------------
-- BLUEPRINT LIBRARY
-- Primary end-user interfaces.
--------------------------------------------------------------------------------

if ... ~= "__bplib__.blueprint" then return require("__bplib__.blueprint") end
local lib = {}

local bbox_lib = require("__bplib__.bbox")
local pos_lib = require("__bplib__.pos")

local get_blueprint_bbox = bbox_lib.get_blueprint_bbox
local get_blueprint_world_positions = pos_lib.get_blueprint_world_positions

---Given either a record or a stack, which might be a blueprint or a blueprint book,
---return the actual blueprint involved, stripped of any containing books.
---If both arguments are given, the record is preferred over the stack.
---@param player LuaPlayer The player who is manipulating the blueprint.
---@param record? LuaRecord
---@param stack? LuaItemStack
---@return bplib.Blueprintish? blueprintish The actual blueprint involved, stripped of any containing books or nil if not found.
local function get_actual_blueprint(player, record, stack)
	-- Determine the actual blueprint being held is way harder than it should be.
	-- h/t Xorimuth on factorio discord for this code
	if record then
		while record and record.type == "blueprint-book" do
			record = record.contents[record.get_active_index(player)]
		end
		if record and record.type == "blueprint" then return record end
	elseif stack then
		if not stack.valid_for_read then return end
		while stack and stack.is_blueprint_book do
			stack =
				stack.get_inventory(defines.inventory.item_main)[stack.active_index]
		end
		if stack and stack.is_blueprint then return stack end
	end
end
lib.get_actual_blueprint = get_actual_blueprint

--------------------------------------------------------------------------------
-- BLUEPRINTINFO TYPE
--------------------------------------------------------------------------------

---Class for end-to-end manipulation of blueprints. Lazily caches information
---about the blueprint and its entities as necessary.
---@class bplib.BlueprintInfo
---@field public record? LuaRecord The base record being manipulated if any
---@field public stack? LuaItemStack The base item stack being manipulated if any
---@field public player LuaPlayer The player who is manipulating the blueprint.
---@field public actual? bplib.Blueprintish The actual blueprint involved, stripped of any containing books.
---@field public entities? BlueprintEntity[] The entities in the blueprint.
---@field public lazy_bp_to_world? LuaLazyLoadedValue<{[int]: LuaEntity}> A lazy mapping of the blueprint entities to the entities in the world.
---@field public bp_to_world? {[int]: LuaEntity} A mapping of the blueprint entity indices to the entities in the world.
---@field public world_to_bp? {[UnitNumber]: int} A mapping from world entity unit numbers to blueprint entity indices.
---@field public surface? LuaSurface The surface where the blueprint is being placed.
---@field public position? MapPosition The worldspace position where the blueprint is being placed.
---@field public direction? defines.direction The rotation of the blueprint expressed as a Factorio direction.
---@field public flip_horizontal? boolean Whether the blueprint is flipped horizontally.
---@field public flip_vertical? boolean Whether the blueprint is flipped vertically.
---@field public bpspace_bbox? BoundingBox The bounding box of the blueprint in blueprint space.
---@field public bp_to_bbox? {[int]: BoundingBox} A mapping of the blueprint entity indices to the bounding rects of the entities in blueprint space.
---@field public bp_to_world_pos? {[int]: MapPosition} A mapping of the blueprint entity indices to positions in worldspace of where those entities will be when the blueprint is built.
---@field public snap? TilePosition Blueprint snapping grid size
---@field public snap_offset? TilePosition Blueprint snapping grid offset
---@field public snap_absolute? boolean Whether blueprint snapping is absolute or relative
---@field public debug? boolean Whether to draw debug graphics for the blueprint placement.
local BlueprintInfo = {}
BlueprintInfo.__index = BlueprintInfo
lib.BlueprintInfo = BlueprintInfo

---@param setup_event EventData.on_player_setup_blueprint
function BlueprintInfo:create_from_setup_event(setup_event)
	local player = game.get_player(setup_event.player_index)
	if not player then return nil end
	local obj = setmetatable({
		record = setup_event.record,
		stack = setup_event.stack,
		player = player,
		lazy_bp_to_world = setup_event.mapping,
	}, self)

	return obj
end

---@param event EventData.on_pre_build
function BlueprintInfo:create_from_pre_build_event(event)
	local player = game.get_player(event.player_index)
	if not player or not player.is_cursor_blueprint() then return nil end
	local obj = setmetatable({
		record = player.cursor_record,
		stack = player.cursor_stack,
		player = player,
		surface = player.surface,
		position = event.position,
		direction = event.direction,
		flip_horizontal = event.flip_horizontal,
		flip_vertical = event.flip_vertical,
	}, self)

	return obj
end

---Gets the actual blueprint being manipulated, stripped of containing books.
function BlueprintInfo:get_actual()
	if not self.actual then
		self.actual = get_actual_blueprint(self.player, self.record, self.stack)
		if self.actual then
			self.snap = self.actual.blueprint_snap_to_grid
			self.snap_offset = self.actual.blueprint_position_relative_to_grid
			self.snap_absolute = self.actual.blueprint_absolute_snapping
		end
	end
	return self.actual
end

---Get the pickled entities from the blueprint
---@param force boolean? If `true`, forcibly refetches from the api even if cached.
function BlueprintInfo:get_entities(force)
	if force or not self.entities then
		local actual = self:get_actual()
		if not actual then return end
		self.entities = actual.get_blueprint_entities()
	end
	return self.entities
end

---Retrieve a map from blueprint entity indices to the real-world entities
---that are being blueprinted. Only valid when a blueprint is being setup.
function BlueprintInfo:get_bp_to_world()
	if not self.bp_to_world then
		if not self.lazy_bp_to_world or not self.lazy_bp_to_world.valid then
			return
		end
		self.bp_to_world = self.lazy_bp_to_world.get() --[[@as table<uint, LuaEntity>]]
	end
	return self.bp_to_world
end

function BlueprintInfo:get_world_to_bp()
	if not self.world_to_bp then
		local bp_to_world = self:get_bp_to_world()
		if not bp_to_world then return end
		self.world_to_bp = {}
		for i, entity in pairs(bp_to_world) do
			local unum = entity.unit_number
			if unum then self.world_to_bp[unum] = i end
		end
	end
	return self.world_to_bp
end

---@param bp_entity_index uint
---@param tags Tags
function BlueprintInfo:apply_tags(bp_entity_index, tags)
	local actual = self:get_actual()
	if not actual then return end
	local old_tags = actual.get_blueprint_entity_tags(bp_entity_index)
	if not old_tags or (table_size(old_tags) == 0) then
		actual.set_blueprint_entity_tags(bp_entity_index, tags)
	else
		for k, v in pairs(tags) do
			old_tags[k] = v
		end
		actual.set_blueprint_entity_tags(bp_entity_index, old_tags)
	end
end

---@param bp_entity_index integer
---@param key string
---@param value AnyBasic
function BlueprintInfo:apply_tag(bp_entity_index, key, value)
	local actual = self:get_actual()
	if not actual then return end
	actual.set_blueprint_entity_tag(bp_entity_index, key, value)
end

---@param bp_entities BlueprintEntity[]
function BlueprintInfo:set_entities(bp_entities)
	local actual = self:get_actual()
	if not actual then return end
	actual.set_blueprint_entities(bp_entities)
	self.entities = nil
	self.bpspace_bbox = nil
	self.bp_to_world_pos = nil
end

function BlueprintInfo:get_bpspace_bbox()
	if not self.bpspace_bbox then
		local bp_entities = self:get_entities()
		if not bp_entities or #bp_entities == 0 then return end

		local bboxes = {} -- XXX
		self.bp_to_bbox = bboxes
		local bbox, snap_index = get_blueprint_bbox(bp_entities, bboxes)
		self.bpspace_bbox = bbox
		self.snap_index = snap_index
	end
	return self.bpspace_bbox
end

---For a blueprint being built, get a map from the blueprint entity indices to
---the positions in worldspace of where those entities will be when the
---blueprint is built.
function BlueprintInfo:get_bp_to_world_pos()
	if self.bp_to_world_pos then return self.bp_to_world_pos end
	local bbox = self:get_bpspace_bbox()
	if not bbox then return end
	local bp_entities = self:get_entities() --[[@as BlueprintEntity[] ]]

	local bp_to_world_pos = get_blueprint_world_positions(
		bp_entities,
		nil,
		bbox,
		self.snap_index,
		self.position,
		self.direction,
		self.flip_horizontal,
		self.flip_vertical,
		self.snap_absolute and self.snap or nil,
		self.snap_offset,
		self.debug and self.surface or nil
	)

	self.bp_to_world_pos = bp_to_world_pos
	return bp_to_world_pos
end

---Obtain a map from blueprint entity indices to the entities in the world
---that would be overlapped by the corresponding blueprint entity when it
---is placed.
---@param entity_filter? fun(bp_entity: BlueprintEntity): boolean? Optional filter function to apply to the blueprint entities before checking for overlap.
---@return {[int]: LuaEntity}? overlap The overlapping entities indexed by the blueprint entity index that will overlap it.
function BlueprintInfo:get_overlap(entity_filter)
	local bpwp = self:get_bp_to_world_pos()
	if not bpwp then return end
	local bp_entities = self:get_entities() --[[@as BlueprintEntity[] ]]
	local surface = self.surface --[[@as LuaSurface]]

	local overlap = {}
	for index, pos in pairs(bpwp) do
		local bp_entity = bp_entities[index]
		if entity_filter and not entity_filter(bp_entity) then goto continue end
		local world_entity = surface.find_entity(bp_entity.name, pos)
		if world_entity then overlap[index] = world_entity end
		::continue::
	end
	return overlap
end

return lib
