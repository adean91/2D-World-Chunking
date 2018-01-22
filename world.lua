local world = {}

function world:randomize(cr, cc, tr, tc, ts, drawOffset, seed)
	self.chunk_row = cr or 16
	self.chunk_col = cc or 16
	self.tile_row  = tr or 32
	self.tile_col  = tc or 32
	self.tile_size = ts or 5
	self.drawOffset = drawOffset or {0,0}

	self.map = {}


	math.randomseed(seed or os.time())
	local tileCount = 0

	for i = 1, self.chunk_col do self.map[i] = {}
		for j = 1, self.chunk_row do self.map[i][j] = {}

			for y = 1, self.tile_col do self.map[i][j][y] = {}
				for x = 1, self.tile_row do 
					tileCount = tileCount + 1
					local t = {
						tile = math.random(),
						num = tileCount,

						cx = j, 
						cy = i, 
						tx = x, 
						ty = y
					}

					--print(string.format("cx=%s\tcy=%s\ttx=%s\tty=%s\tval=%s", t.cx, t.cy, t.tx, t.ty, t.tile))
					self.map[i][j][y][x] = t
				end
			end

		end
	end

	print(string.format("Chunks: %s x %s", self.chunk_row, self.chunk_col))
	print(string.format("Tiles: %s x %s", self.tile_row, self.tile_col))
	print(string.format("Tile Size: %s x %s\n", self.tile_size, self.tile_size))

	local c = self.chunk_col*self.chunk_row
	print("Total chunks: ".. c)
	print("Total tiles: ".. c*(self.tile_col*self.tile_row))
	print("------------------------------\n")
end

function world:draw(camx, camy)
	-- draw rectangle around map
	local map = {
		x = self.drawOffset[1],
		y = self.drawOffset[2],
		w = (self.tile_size * self.tile_row)*self.chunk_row,
		h = (self.tile_size * self.tile_col)*self.chunk_col
	}

	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("line", map.x, map.y, map.w, map.h)

	-- adjust position to offset
	local camx = camx - self.drawOffset[1]
	local camy = camy - self.drawOffset[2]

	-- find adjacent chunks
	local chunkx = math.floor(camx / (self.tile_size * self.tile_row))+1
	local chunky = math.floor(camy / (self.tile_size * self.tile_col))+1
	
	local chunks = {}
	
	if self.map[chunky] and self.map[chunky][chunkx] then
		table.insert(chunks, self.map[chunky][chunkx])
	else return  -- catch oob exception
	end

	if chunky > 1 and chunky < self.chunk_col then 
		table.insert(chunks, self.map[chunky-1][chunkx]) 
		table.insert(chunks, self.map[chunky+1][chunkx]) 
	elseif chunky > 1 then
		table.insert(chunks, self.map[chunky-1][chunkx])
	elseif chunky < self.chunk_col then
		table.insert(chunks, self.map[chunky+1][chunkx]) 
	end

	if chunkx > 1 and chunkx < self.chunk_col then 
		table.insert(chunks, self.map[chunky][chunkx-1]) 
		table.insert(chunks, self.map[chunky][chunkx+1]) 
	elseif chunkx > 1 then
		table.insert(chunks, self.map[chunky][chunkx-1])
	elseif chunkx < self.chunk_col then
		table.insert(chunks, self.map[chunky][chunkx+1]) 
	end


	-------------------------

	for _, chunk in ipairs(chunks) do
		for _, v in ipairs(chunk) do
			for _, tile in ipairs(v) do
				local x = ((self.tile_size * self.tile_row) * (tile.cx-1)) + (self.tile_size * (tile.tx-1)) + self.drawOffset[1]
				local y = ((self.tile_size * self.tile_col) * (tile.cy-1)) + (self.tile_size * (tile.ty-1)) + self.drawOffset[2]

				local color = tile.tile * 255

				love.graphics.setColor(color, color, color)
				love.graphics.rectangle("fill", x, y, self.tile_size, self.tile_size)
			end
		end
	end
end

return world