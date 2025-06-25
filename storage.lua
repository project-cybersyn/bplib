---@class (exact) bplib.Storage
---@field public entity_data {[uint]: bplib.EntityStorage} Data for tracked entities, indexed by unit number
storage = {}

---@class (exact) bplib.EntityStorage

-- Initialize storage on startup
on_startup(function() storage.entity_data = {} end, true)
