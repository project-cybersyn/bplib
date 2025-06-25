data:extend({
	{ type = "custom-event", name = "bplib-on_blueprint_extract" },
	-- Raised when a tagged ghost is created. (See `tags.lua`.)
	{
		type = "custom-event",
		name = "bplib_on_tagged_ghost_created",
	},
	-- Raised when an entity is revived from a tagged ghost. (See `tags.lua`.)
	{
		type = "custom-event",
		name = "bplib_on_tagged_ghost_revived",
	},
	-- Raised when a tagged ghost is deleted without being revived. (See `tags.lua`.)
	{ type = "custom-event", name = "bplib_on_tagged_ghost_deleted" },
	-- Raised when a tagged entity is created without going through the ghost revival process, eg by the map editor.
	{ type = "custom-event", name = "bplib_on_tagged_entity_placed" },
})
