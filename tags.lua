---Get the tags associated with an entity or ghost. Exactly one of the
---parameters must be provided, and it determines which entity to get tags for.
---@param entity LuaEntity? If provided, the entity to get tags for.
---@param unit_number uint? If provided, the unit number of the entity to get tags for
---@param bplib_id uint? If provided, the bplib ID of the entity to get tags for.
---@return bplib.Error? err `nil` if the operation succeeded, otherwise error information.
---@return Tags? tags table of tags associated with the entity or ghost. `nil` if there are no tags or the operation failed.
---@return uint? bplib_id The bplib ID assigned to the entity. `nil` if there is no such entity known to bplib or the operation failed.
_G.api.get_tags = function(entity, unit_number, bplib_id)
	-- XXX
	debug_log({
		fn = "get_tags",
		entity = entity,
		unit_number = unit_number,
		bplib_id = bplib_id,
	})
end

---Set the tags associated with an entity or ghost. Existing tags will be
---destroyed and replaced with the provided tags. If `tags` is `nil`, all
---tags will be removed and bplib will forget the entity.
---@param entity LuaEntity A **valid** entity or ghost.
---@param tags Tags? Table of tags to associate with the entity. If `nil`, all tags will be removed and bplib will forget the entity.
---@return bplib.Error? err `nil` if the operation succeeded, otherwise error information.
---@return uint? bplib_id The bplib ID assigned to the entity. `nil` if the operation failed or `tags` is `nil`.
_G.api.set_tags = function(entity, tags)
	-- XXX
	debug_log({ fn = "set_tags", entity = entity, tags = tags })
end
