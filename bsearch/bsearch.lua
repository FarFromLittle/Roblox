local bsearch = {}

local function compare(a, b) return a - b end

function bsearch.lbound(tbl, val, cmp)
	local min, max, mid = 1, #tbl
	if not cmp then cmp = compare end
	if max < 1 or cmp(tbl[max], val) < 0 then return max + 1 end
	while min < max do
		mid = math.floor((min + max)/2)
		if cmp(val, tbl[mid]) <= 0 then max = mid - 1
		else min = mid + 1 end
	end
	return min
end

function bsearch.ubound(tbl, val, cmp)
	local min, max, mid = 1, #tbl
	if not cmp then cmp = compare end
	if max < 1 or 0 < cmp(tbl[min], val) then return min end
	while min <= max do
		mid = math.floor((min + max)/2)
		if cmp(val, tbl[mid]) < 0 then max = mid - 1
		else min = mid + 1 end
	end
	return max + 1
end

function bsearch.search(tbl, val, cmp)
	local min, max, mid, res = 1, #tbl
	if not cmp then cmp = compare end
	while min <= max do
		mid = math.floor((min + max)/2)
		res = cmp(val, tbl[mid])
		if res < 0 then max = mid - 1
		elseif res > 0 then min = mid + 1
		else return mid end
	end
	return nil
end

function bsearch.insert(tbl, val, cmp)
	local i = bsearch.ubound(tbl, val, cmp)
	table.insert(tbl, i, val)
	return i
end

return bsearch
