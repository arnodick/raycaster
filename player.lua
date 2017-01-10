local function make(a)
	--a.spr=0
	a.size=1
	a.c=7
	a.rays={}
end

local function control(a,gs)
	if love.keyboard.isDown("up") then
		a.vel=0.1
	elseif love.keyboard.isDown("down") then
		a.vel=-0.1
	else
		a.vel=0
	end
	if love.keyboard.isDown("right") then
		a.d=math.clamp(a.d+0.05,0,math.pi*2,true)
	end
	if love.keyboard.isDown("left") then
		a.d=math.clamp(a.d-0.05,0,math.pi*2,true)
	end
	a.rays={}
	for i=-Camera.fov/2,Camera.fov/2,Camera.resolution do
		local r=actor.raycast(a.x,a.y,a.d+i,30,0.1)
		r.len=r.len*math.cos(i)
		table.insert(a.rays,r)
		--table.insert(a.rays,actor.raycast(a,a.d+i,30,0.1))
	end
end

local function hitground(a)

end

local function draw(a)
	for i,v in ipairs(a.rays) do
		local columnwidth=Game.width/#a.rays
		love.graphics.setColor(255,255,255,255-v.len*8)
		love.graphics.rectangle("fill",(i-1)*columnwidth,(Game.height/2)-(200/v.len),columnwidth,400/v.len)
	end
	if DebugMode then
		love.graphics.setColor(Palette[11])
		love.graphics.line(a.x,a.y,a.x+a.vec[1]*10,a.y+a.vec[2]*10)
		love.graphics.setColor(Palette[8])
		for i=1,#a.rays do
			local vecx=math.cos(a.rays[i].d)
			local vecy=math.sin(a.rays[i].d)
			local len=a.rays[i].len
			love.graphics.line(a.x,a.y,a.x+vecx*len,a.y+vecy*len)
		end
	end
end

return
{
	make = make,
	control = control,
	hitground = hitground,
	draw = draw,
}
