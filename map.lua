local function make(s)
	m={}
	for y=1,s do
		table.insert(m,{})
		for x=1,s do
			--table.insert(m[y],love.math.random(2)-1)
			if y==20 or x==20 or (x==40 and y<40) then
				table.insert(m[y],1)
			else
				table.insert(m[y],0)
			end
		end
	end
	return m
end

local function draw(m)
	for y=1,#m do
		for x=1,#m[y] do
			if m[y][x] == 1 then
				love.graphics.setColor(Palette[7])
				love.graphics.points(x,y)
			end
		end
	end
end

return
{
	make = make,
	draw = draw,
}
