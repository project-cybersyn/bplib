--------------------------------------------------------------------------------
-- BLUEPRINT LIBRARY
-- Data types and enums.
--------------------------------------------------------------------------------

if ... ~= "__bplib__.types" then return require("__bplib__.types") end
local lib = {}

---A blueprint-like object
---@alias bplib.Blueprintish LuaItemStack|LuaRecord

---Possible types of cursor snapping during relative blueprint placement.
---@enum bplib.SnapType
lib.SnapType = {
	"GRID_POINT",
	"TILE",
	"EVEN_GRID_POINT",
	"EVEN_TILE",
	"ODD_GRID_POINT",
	"ODD_TILE",
	GRID_POINT = 1,
	TILE = 2,
	EVEN_GRID_POINT = 3,
	EVEN_TILE = 4,
	ODD_GRID_POINT = 5,
	ODD_TILE = 6,
}

---Custom empirical data for a single direction of a single entity. Entries are:
---[1] = Left offset from position to bbox edge.
---[2] = Top offset from position to bbox edge.
---[3] = Right offset from position to bbox edge.
---[4] = Bottom offset from position to bbox edge.
---[5] = 2x2 snapping: required parity of X coord of final world position (1=odd, 2=even, `nil`=don't use 2x2 snapping)
---[6] = 2x2 snapping: required parity of Y coord of final world position (1=odd, 2=even, `nil`=don't use 2x2 snapping)
---@alias bplib.SnapData { [1]: int, [2]: int, [3]: int, [4]: int, [5]: int|nil, [6]: int|nil }

---Snap data associated with each valid direction of an entity. Direction `0`
---MUST be provided and is used as a fallback for directions not provided.
---@alias bplib.DirectionalSnapData {[defines.direction]: bplib.SnapData}

---Snap data associated with a collection of entity names or type names.
---@alias bplib.EntityDirectionalSnapData {[string]: bplib.DirectionalSnapData}

return lib
