local world = {
	chunk_row = 32,
	chunk_col = 32,
	tile_row  = 32,
	tile_col  = 32,
	tile_size = 5,

	map = {}
}

local tiles = {
	[0] = {0,0,0},
	[1] = {50,50,50},
	[2] = {100,100,100},
	[3] = {150,150,150},
	[4] = {200,200,200},
	[5] = {0,50,0},
	[6] = {0,100,0},
	[7] = {0,150,0},
	[8] = {0,200,0},
	[9] = {0,255,0}
}

function world:randomize()
	math.randomseed(os.time())
	local tileCount = 0

	for i = 1, self.chunk_col do self.map[i] = {}
		for j = 1, self.chunk_row do self.map[i][j] = {}

			for y = 1, self.tile_col do self.map[i][j][y] = {}
				for x = 1, self.tile_row do 
					tileCount = tileCount + 1
					local t = {
						tile = math.floor(math.random()*10), -- random tile type
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
	local chunkx = math.floor(camx / (self.tile_size * self.tile_row))+1
	local chunky = math.floor(camy / (self.tile_size * self.tile_col))+1
	
	local chunks = {}
	table.insert(chunks, self.map[chunky][chunkx])

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
				local x = ((self.tile_size * self.tile_row) * (tile.cx-1)) + (self.tile_size * (tile.tx-1))
				local y = ((self.tile_size * self.tile_col) * (tile.cy-1)) + (self.tile_size * (tile.ty-1))

				love.graphics.setColor(tiles[tile.tile])
				love.graphics.rectangle("fill", x, y, self.tile_size, self.tile_size)

				--love.graphics.setColor(255,0,0)
				--love.graphics.print(tile.num, x+(self.tile_size*.45), y+(self.tile_size*.45))
			end
		end
	end
end

return world