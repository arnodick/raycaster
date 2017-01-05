local function make(a)
	a.spr=0
	a.size=1
	a.c=7
	a.viewleftdir=0
	a.viewrightdir=0
	a.viewleftvecx=0
	a.viewleftvecy=0
	a.viewrightvecx=0
	a.viewrightvecy=0
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
	a.viewleftdir=a.d-(Camera.resolution/2)*math.pi
	a.viewrightdir=a.d+(Camera.resolution/2)*math.pi
	a.viewleftvecx=math.cos(a.viewleftdir)
	a.viewleftvecy=math.sin(a.viewleftdir)
	a.viewrightvecx=math.cos(a.viewrightdir)
	a.viewrightvecy=math.sin(a.viewrightdir)
	a.rays={}
	for i=-Camera.resolution/2,Camera.resolution/2,0.1 do
		table.insert(a.rays,a.d+i)
	end
end

local function hitground(a)

end

local function draw(a)
	if DebugMode then
		love.graphics.setColor(Palette[11])
		love.graphics.line(a.x,a.y,a.x+a.vec[1]*10,a.y+a.vec[2]*10)
		love.graphics.setColor(Palette[8])
		love.graphics.line(a.x,a.y,a.x+a.viewleftvecx*100,a.y+a.viewleftvecy*100)
		love.graphics.line(a.x,a.y,a.x+a.viewrightvecx*100,a.y+a.viewrightvecy*100)
		for i=1,#a.rays do
			local vecx=math.cos(a.rays[i])
			local vecy=math.sin(a.rays[i])
			love.graphics.line(a.x,a.y,a.x+vecx*100,a.y+vecy*100)
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
