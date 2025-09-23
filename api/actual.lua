local lib = {}

---Given either a record or a stack, which might be a blueprint or a blueprint book,
---return the actual blueprint involved, stripped of any containing books.
---If both arguments are given, the record is preferred over the stack.
---@param player LuaPlayer The player who is manipulating the blueprint.
---@param record? LuaRecord
---@param stack? LuaItemStack
---@return bplib.Blueprintish? blueprintish The actual blueprint involved, stripped of any containing books or nil if not found.
local function get_actual_blueprint(player, record, stack)
	-- Determine the actual blueprint being held is way harder than it should be.
	-- h/t Xorimuth on factorio discord for this code
	if record then
		-- XXX: this is a workaround for a crash in factorio 2.0.66
		-- Pending further investigation of the `is_preview` flag and what it
		-- means, we will just bail out here.
		if record.is_preview then return nil end
		while record and record.type == "blueprint-book" do
			record = record.contents[record.get_active_index(player)]
		end
		if record and record.type == "blueprint" then return record end
	elseif stack then
		if not stack.valid_for_read then return end
		while stack and stack.is_blueprint_book do
			stack =
				stack.get_inventory(defines.inventory.item_main)[stack.active_index]
		end
		if stack and stack.is_blueprint then return stack end
	end
end
lib.get_actual_blueprint = get_actual_blueprint

return lib
