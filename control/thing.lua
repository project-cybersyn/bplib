local class = require("lib.core.class").class
local counters = require("lib.core.counters")
local StateMachine = require("lib.core.state-machine")

---@enum bplib.ThingManagementFlags
local ThingManagementFlags = {
	--- Force this entity to be destroyed when its parent is.
	DestroyWithParent = 1,
	--- Force this entity to die leaving a ghost when its parent does.
	DieWithParent = 2,
	--- When this entity is revived or built, also revive/build any children that are ghosts.
	ReviveChildren = 4,
	--- Force this entity to maintain its position relative to its parent when the parent is moved/rotated/flipped
	MaintainRelativePosition = 8,
	--- Force this entity to change its orientation relative to its parent when the parent is rotated/flipped
	MaintainRelativeOrientation = 16,
	--- This entity should be treated as immobile. (e.g. a picker dollies integration should ignore it)
	Immobile = 32,
}

---A `Thing` is the extended lifecycle of a collection of game entities that
---actually represent the same ultimate thing. For example, a thing could
---be constructed from a blueprint (entity #1: ghost), built by a bot (entity #2: real),
---killed by a biter and replaced by a ghost (entity #3: ghost),
---rebuilt by a player (entity #4: real), mined by a player (virtual entity
---in an undo buffer), then rebuilt by an undo command. (entity #5). All of
---these entities are different LuaEntity objects, but they all represent
---the same ultimate `Thing`.
---@class bplib.Thing: StateMachine
---@field public id int Unique gamewide id for this thing.
---@field public local_id? int If this entity came from a blueprint, its local id within that blueprint.
---@field public entity LuaEntity? Current entity representing the thing. Due to potential for lifecycle leaks, must be checked for validity each time used.
---@field public tags Tags The tags associated with this entity.
local Thing = class("bplib.Thing", StateMachine)
_G.Thing = Thing

---@return bplib.Thing
function Thing:new()
	local id = counters.next("entity")
	local obj = StateMachine.new(self, "unknown")
	obj.id = id
	obj.tags = {}
	storage.entities_by_id[id] = obj
	return obj
end

---@param id uint?
---@return bplib.Thing?
function _G.get_thing(id) return storage.entities_by_id[id or ""] end

---@param unit_number uint?
---@return bplib.Thing?
function _G.get_thing_by_unit_number(unit_number)
	return storage.entities_by_unit_number[unit_number or ""]
end
