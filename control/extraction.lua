local class = require("lib.core.class").class
local counters = require("lib.core.counters")

---State of a blueprint being extracted from the world.
---@class bplib.Extraction
---@field public id int The unique extraction id.
---@field public local_id_counter int Counter for assigning local ids within this extraction.
---@field public thing_id_to_local_id {[int]: int} Map from global thing ids to local ids within this extraction.
local Extraction = class("bplib.Extraction")
_G.Extraction = Extraction

function Extraction:new()
	local id = counters.next("extraction")
	local obj = setmetatable({}, self)
	obj.id = id
	obj.local_id_counter = 0
	obj.thing_id_to_local_id = {}
	storage.extractions[id] = obj
	return obj
end

---Map a known thing to its local id within this extraction.
---@param thing bplib.Thing
function Extraction:map(thing)
	local local_id = self:next_local_id()
	self.thing_id_to_local_id[thing.id] = local_id
	return local_id
end

function Extraction:destroy() storage.extractions[self.id] = nil end

function Extraction:next_local_id()
	self.local_id_counter = self.local_id_counter + 1
	return self.local_id_counter
end
