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

---@class (exact) bplib.Error
---@field message string

---@class bplib.CustomEventBase
---@field name string The name of the event.
---@field tick uint The tick the event was raised.
---@field bplib_event_id uint? The ID of the event in bplib's event system, if applicable.

return lib
