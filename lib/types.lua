--------------------------------------------------------------------------------
-- BPLib INTERNAL types and enums.
-- These are subject to change without warning. Do not use these in APIs or
-- external mods.
--------------------------------------------------------------------------------

---Custom empirical data for a single direction of a single entity. Entries are:
---[1] = Left offset from position to bbox edge.
---[2] = Top offset from position to bbox edge.
---[3] = Right offset from position to bbox edge.
---[4] = Bottom offset from position to bbox edge.
---[5] = 2x2 snapping: required parity of X coord of final world position (1=odd, 2=even, `nil`=don't use 2x2 snapping)
---[6] = 2x2 snapping: required parity of Y coord of final world position (1=odd, 2=even, `nil`=don't use 2x2 snapping)
---@alias bplib.internal.SnapData { [1]: int, [2]: int, [3]: int, [4]: int, [5]: int|nil, [6]: int|nil }

---Snap data associated with each valid direction of an entity. Direction `0`
---MUST be provided and is used as a fallback for directions not provided.
---@alias bplib.internal.DirectionalSnapData {[defines.direction]: bplib.internal.SnapData}

---Snap data associated with a collection of entity names or type names.
---@alias bplib.internal.EntityDirectionalSnapData {[string]: bplib.internal.DirectionalSnapData}
