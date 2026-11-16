--- @sync entry
-- Enter the hovered directory, or open the hovered/selected files.
return {
	entry = function()
		local h = cx.active.current.hovered
		if h and h.cha.is_dir then
			ya.emit("enter", {})
		else
			ya.emit("open", {})
		end
	end,
}
