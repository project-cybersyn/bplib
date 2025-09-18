---Certain entities in Factorio have non-standard geometry. For those entities,
---custom empirical tables must be provided in order to compute information
---about their bounding boxes and how they snap to the tile grid.
---
---At the time of this writing, I believe it is impossible for mods to create
---custom entities that are as "Cursed" as the ones listed below, so for the
---time being the remote interface for registering more of these is disabled.
---Should community need arise, a new interface for adding entities will
---be published through the `mod-data` API.

local lib = {}

---Straight-straight rails are 2x2. Diagonal-straight rails are 4x4.
---@type bplib.internal.DirectionalSnapData
local straight_rail_table = {
	[0] = { -1, -1, 1, 1, 1, 1 },
	[2] = { -2, -2, 2, 2, 2, 2 },
	[4] = { -1, -1, 1, 1, 1, 1 },
	[6] = { -2, -2, 2, 2, 2, 2 },
	[8] = { -1, -1, 1, 1, 1, 1 },
	[10] = { -2, -2, 2, 2, 2, 2 },
	[12] = { -1, -1, 1, 1, 1, 1 },
	[14] = { -2, -2, 2, 2, 2, 2 },
}

---Treat curved-rail-a as 2x4 centered on its position. See:
---https://forums.factorio.com/viewtopic.php?p=613478#p613478
---@type bplib.internal.DirectionalSnapData
local curved_rail_a_table = {
	[0] = { -1, -2, 1, 2, 1, 2 },
	[2] = { -1, -2, 1, 2, 1, 2 },
	[4] = { -2, -1, 2, 1, 2, 1 },
	[6] = { -2, -1, 2, 1, 2, 1 },
	[8] = { -1, -2, 1, 2, 1, 2 },
	[10] = { -1, -2, 1, 2, 1, 2 },
	[12] = { -2, -1, 2, 1, 2, 1 },
	[14] = { -2, -1, 2, 1, 2, 1 },
}

---Treat curved-rail-b as a 4x4 centered on its position.
---This is from empirical observation in-game.
---@type bplib.internal.DirectionalSnapData
local curved_rail_b_table = {
	[0] = { -2, -2, 2, 2, 1, 1 },
	[2] = { -2, -2, 2, 2, 1, 1 },
	[4] = { -2, -2, 2, 2, 1, 1 },
	[6] = { -2, -2, 2, 2, 1, 1 },
	[8] = { -2, -2, 2, 2, 1, 1 },
	[10] = { -2, -2, 2, 2, 1, 1 },
	[12] = { -2, -2, 2, 2, 1, 1 },
	[14] = { -2, -2, 2, 2, 1, 1 },
}

---Half-diagonal rails are always 4x4.
---@type bplib.internal.DirectionalSnapData
local half_diagonal_rail_table = {
	[0] = { -2, -2, 2, 2, 1, 1 },
	[2] = { -2, -2, 2, 2, 1, 1 },
	[4] = { -2, -2, 2, 2, 1, 1 },
	[6] = { -2, -2, 2, 2, 1, 1 },
	[8] = { -2, -2, 2, 2, 1, 1 },
	[10] = { -2, -2, 2, 2, 1, 1 },
	[12] = { -2, -2, 2, 2, 1, 1 },
	[14] = { -2, -2, 2, 2, 1, 1 },
}

---@type bplib.internal.EntityDirectionalSnapData
local custom_entity_types = {
	["straight-rail"] = straight_rail_table,
	["curved-rail-a"] = curved_rail_a_table,
	["curved-rail-b"] = curved_rail_b_table,
	["half-diagonal-rail"] = half_diagonal_rail_table,
	["elevated-straight-rail"] = straight_rail_table,
	["elevated-curved-rail-a"] = curved_rail_a_table,
	["elevated-curved-rail-b"] = curved_rail_b_table,
	["elevated-half-diagonal-rail"] = half_diagonal_rail_table,
	["train-stop"] = {
		[0] = { -1, -1, 1, 1, 1, 1 },
		[4] = { -1, -1, 1, 1, 1, 1 },
		[8] = { -1, -1, 1, 1, 1, 1 },
		[12] = { -1, -1, 1, 1, 1, 1 },
	},
}

---@param bp_entity BlueprintEntity
---@param eproto LuaEntityPrototype
---@return bplib.internal.SnapData|nil
function lib.get_snap_data_for_direction(bp_entity, eproto)
	local type_info = custom_entity_types[eproto.type]
	if type_info then return type_info[bp_entity.direction or 0] end
	return nil
end

return lib
