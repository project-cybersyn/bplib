--------------------------------------------------------------------------------
-- BLUEPRINT LIBRARY
-- Data types and enums.
--------------------------------------------------------------------------------

if ... ~= "__bplib__.types" then return require("__bplib__.types") end
local lib = {}

---A blueprint-like object
---@alias bplib.Blueprintish LuaItemStack|LuaRecord

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

---Info needed to place a blueprint correctly in the world.
---@class bplib.BlueprintPlacementInfo
---@field public surface? LuaSurface The surface where the blueprint is being placed.
---@field public position? MapPosition The worldspace position where the blueprint is being placed.
---@field public direction? defines.direction The rotation of the blueprint expressed as a Factorio direction.
---@field public flip_horizontal? boolean Whether the blueprint is flipped horizontally.
---@field public flip_vertical? boolean Whether the blueprint is flipped vertically.
---@field public snap? TilePosition Blueprint snapping grid size
---@field public snap_offset? TilePosition Blueprint snapping grid offset
---@field public snap_absolute? boolean Whether blueprint snapping is absolute or relative

return lib
