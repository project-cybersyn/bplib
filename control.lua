--------------------------------------------------------------------------------
-- BPLIB CONTROL PHASE
-- This just serves as a central repository of custom entity data that can be
-- accessed via the remote interface. This allows mods to customize entity snap
-- data without needing to modify the base mod.
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

remote.add_interface("bplib", {
	---@return bplib.EntityDirectionalSnapData
	get_custom_entity_types = function() return custom_entity_types end,
	---@return bplib.EntityDirectionalSnapData
	get_custom_entity_names = function() return custom_entity_names end,
	---@param name string
	---@param snap_data bplib.DirectionalSnapData
	set_custom_entity_type = function(name, snap_data)
		custom_entity_types[name] = snap_data
	end,
	---@param name string
	---@param snap_data bplib.DirectionalSnapData
	set_custom_entity_name = function(name, snap_data)
		custom_entity_names[name] = snap_data
	end,
})
