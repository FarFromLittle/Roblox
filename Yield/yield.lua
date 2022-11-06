local function yield(src, obj, sec)
	local res = obj or game
	for i in src:gmatch("%P+") do
		local child = res:FindFirstChild(i)
		if not child then
			local delay
			repeat
				delay = task.delay(sec or 10, warn, "Infinite yield possible:", src)
				child = res.ChildAdded:Wait()
				task.cancel(delay)
			until child.Name == i
		end
		res = child
	end
	return res
end
