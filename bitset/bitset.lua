local bitset = {}

function bitset.create(len)
	return table.create(math.ceil(len/32))
end

function bitset.clear(tbl, bit)
	local i = math.floor(bit/32) + 1
	tbl[i] = bit32.band(tbl[i], bit32.bnot(2^(bit % 32)))
end

function bitset.flip(tbl, bit)
	local i = math.floor(bit/32) + 1
	tbl[i] = bit32.bxor(tbl[i], 2^(bit % 32))
end

function bitset.set(tbl, bit)
	local i = math.floor(bit/32) + 1
	tbl[i] = bit32.bor(tbl[i], 2^(bit % 32))
end

function bitset.test(tbl, bit)
	return bit32.band(tbl[math.floor(bit/32) + 1], 2^(bit % 32)) ~= 0
end

return bitset
