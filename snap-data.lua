--------------------------------------------------------------------------------
-- SNAP DATA FOR UNUSUAL ENTITIES
--
-- This is used to override the behavior of the snapping algorithm when
-- an entity can't be placed using ordinary snapping rules. Mods can add
-- their own entities here by using the remote interface.
--------------------------------------------------------------------------------

---@type bplib.DirectionalSnapData
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
---@type bplib.DirectionalSnapData
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
---@type bplib.DirectionalSnapData
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

---@type bplib.DirectionalSnapData
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

---@type bplib.EntityDirectionalSnapData
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

---@type bplib.EntityDirectionalSnapData
local custom_entity_names = {}

---@return bplib.EntityDirectionalSnapData
_G.api.get_custom_snap_types = function() return custom_entity_types end

---@return bplib.EntityDirectionalSnapData
_G.api.get_custom_snap_names = function() return custom_entity_names end

---@param name string
---@param snap_data bplib.DirectionalSnapData
_G.api.set_custom_snap_type = function(name, snap_data)
	custom_entity_types[name] = snap_data
end

---@param name string
---@param snap_data bplib.DirectionalSnapData
_G.api.set_custom_snap_name = function(name, snap_data)
	custom_entity_names[name] = snap_data
end
