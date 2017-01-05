local function make(a)
	a.spr=0
	a.size=1
	a.c=7
	a.rays={}
end

local function control(a,gs)
	if love.keyboard.isDown("up") then
		a.vel=1
	end
	if love.keyboard.isDown("down") then
		a.vel=0
	end
	if love.keyboard.isDown("right") then
		a.d=a.d+0.1
	end
	if love.keyboard.isDown("left") then
		a.d=a.d-0.1
	end
	a.rays={}
	for i=-Camera.resolution/2,Camera.resolution/2,0.05 do
		local ray={}
		ray.d=a.d+i
		for j=1,100,0.5 do
			local x=math.floor(a.x+math.cos(ray.d)*j)
			local y=math.floor(a.y+math.sin(ray.d)*j)
			local cell=Map[y][x]
			if cell then
				if cell==1 then
					ray.len=j
					break
				end
			end
			ray.len=100
		end
		table.insert(a.rays,ray)
	end
end

local function hitground(a)

end

local function draw(a)
	if DebugMode then
		love.graphics.setColor(Palette[11])
		love.graphics.line(a.x,a.y,a.x+a.vec[1]*10,a.y+a.vec[2]*10)

	end
		love.graphics.setColor(Palette[8])
		for i=1,#a.rays do
			local vecx=math.cos(a.rays[i].d)
			local vecy=math.sin(a.rays[i].d)
			local len=a.rays[i].len
			love.graphics.line(a.x,a.y,a.x+vecx*len,a.y+vecy*len)
		end
end

return
{
	make = make,
	control = control,
	hitground = hitground,
	draw = draw,
}
