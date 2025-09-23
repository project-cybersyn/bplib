---@class (exact) bplib.Storage
---@field public prebuild_entities {[uint]: bplib.PrebuildEntity} Data for entities being prebuilt, indexed by prebuild id
---@field public prebuild_blueprints {[uint]: bplib.PrebuildBlueprint} Data for blueprints being prebuilt, indexed by prebuild id
---@field public entities_by_unit_number {[uint]: bplib.Entity} Data for tracked entities, indexed by unit number.
---@field public entities_by_id {[uint]: bplib.Entity} Data for tracked entities, indexed by bplib ids
---@field public extractions {[uint]: bplib.Extraction} Data for blueprints being extracted, indexed by extraction id
storage = {}

local function init_storage_key(key)
	if storage[key] == nil then storage[key] = {} end
end

function _G.init_storage()
	init_storage_key("prebuild_entities")
	init_storage_key("prebuild_blueprints")
	init_storage_key("entities_by_unit_number")
	init_storage_key("entities_by_id")
end

-- Initialize storage on startup
on_startup(init_storage, true)
