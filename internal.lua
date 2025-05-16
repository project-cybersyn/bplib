--------------------------------------------------------------------------------
-- BPLIB INTERNALS
--------------------------------------------------------------------------------

if ... ~= "__bplib__.internal" then return require("__bplib__.internal") end
local lib = {}

---@type bplib.EntityDirectionalSnapData
local internal_custom_entity_types = nil

---@type bplib.EntityDirectionalSnapData
local internal_custom_entity_names = nil

local function get_custom_entity_types()
	if internal_custom_entity_types == nil then
		internal_custom_entity_types =
			remote.call("bplib", "get_custom_entity_types")
	end
	return internal_custom_entity_types
end

local function get_custom_entity_names()
	if internal_custom_entity_names == nil then
		internal_custom_entity_names =
			remote.call("bplib", "get_custom_entity_names")
	end
	return internal_custom_entity_names
end

---@param eproto LuaEntityPrototype
---@return bplib.DirectionalSnapData|nil
local function get_custom_entity_info(eproto)
	local name_info = get_custom_entity_names()[eproto.name]
	if name_info then return name_info end
	local type_info = get_custom_entity_types()[eproto.type]
	if type_info then return type_info end
	return nil
end
lib.get_custom_entity_info = get_custom_entity_info

---@param bp_entity BlueprintEntity
---@param eproto LuaEntityPrototype
---@return bplib.SnapData|nil
function lib.get_snap_data_for_direction(bp_entity, eproto)
	local snap_data = get_custom_entity_info(eproto)
	if not snap_data then return nil end
	local data = snap_data[bp_entity.direction or 0]
	if not data then data = snap_data[0] end
	return data
end

return lib
