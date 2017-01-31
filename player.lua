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
		a.d=math.clamp(a.d+0.05,-math.pi,math.pi,true)
	end
	if love.keyboard.isDown("left") then
		a.d=math.clamp(a.d-0.05,-math.pi,math.pi,true)
	end
	a.rays={}
	local x=1
	for i=-Camera.fov/2,Camera.fov/2,Camera.resolution do
		local r=actor.raycast(a.x,a.y,a.d+i,Drawdist,0.1)
		r.len=r.len*math.cos(i)
		r.x=x
		x=x+1
		table.insert(a.rays,r)
	end
	local function raysort(a,b)
		if a.len<b.len then
			return true
		else
			return false
		end
	end
	table.sort(a.rays, raysort)
end

local function hitground(a)

end

local function draw(a)
--[[
	for i=1,math.floor(Raycount) do
		local columnwidth=Game.width/#a.rays
		local v=a.rays[i]
		love.graphics.setColor(255,255,255,255-v.len*8)
		--love.graphics.rectangle("fill",(i-1)*columnwidth,(Game.height/2)-(200/v.len),columnwidth,400/v.len)
		love.graphics.rectangle("fill",(v.x-1)*columnwidth,(Game.height/2)-(200/v.len),columnwidth,400/v.len)
	end
--]]

	for i=#a.rays,1,-1 do
		v=a.rays[i]
		local columnwidth=Game.width/#a.rays
		if math.ceil(v.len)<=30 then
			if #Enemies[math.ceil(v.len)]>0 then
				local index=Enemies[math.ceil(v.len)][1]
				actor.draw(index)
			end
		end
		love.graphics.setColor(255,255,255,255-v.len*8)
		love.graphics.rectangle("fill",(v.x-1)*columnwidth,(Game.height/2)-(200/v.len),columnwidth,400/v.len)
	end
--[[
	for i,v in ipairs(a.rays) do
		local columnwidth=Game.width/#a.rays
		love.graphics.setColor(255,255,255,255-v.len*8)
		love.graphics.rectangle("fill",(v.x-1)*columnwidth,(Game.height/2)-(200/v.len),columnwidth,400/v.len)
	end
--]]

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
