local function make(t,st,x,y,c,d,vel,...)
	local a={}
	a.t=t
	a.st=st
	a.x=x
	a.y=y
	a.c=c or Enums.colours.red
	a.d=d or 0
	a.vel=vel or 0
	a.vec={math.cos(a.d),math.sin(a.d)}
	a.delta=Timer
	a.accel=0.08
	a.decel=0.02
	a.maxvel=5
	a.delete=false
	a.flags = 0x0
	--a.flags = actor.setflags( 0x0, Enums.flags.gravity,Enums.flags.explosive,Enums.flags.ground_delta)
	if _G[Enums.actornames[a.t]]["make"] then
		_G[Enums.actornames[a.t]]["make"](a,...)
	end
	table.insert(Actors,a)
	return a
end

local function control(a,gs,index)
	a.vec[1]=math.cos(a.d)
	a.vec[2]=math.sin(a.d)
	if Map[math.floor(a.y)][math.floor(a.x+a.vec[1]*a.vel*10)]~=1 then
		a.x=a.x+a.vec[1]*a.vel
	end
	if Map[math.floor(a.y+a.vec[2]*a.vel*10)][math.floor(a.x)]~=1 then
		a.y=a.y+a.vec[2]*a.vel
	end
	--a.x=a.x+a.vec[1]*a.vel
	--a.y=a.y+a.vec[2]*a.vel

	if a.spr then
		local dist=math.floor(vector.distance(Player.x,Player.y,a.x,a.y))
		if dist<=Drawdist then
			table.insert(Enemies[dist],a)
		end
	end

	if _G[Enums.actornames[a.t]]["control"] then
		_G[Enums.actornames[a.t]]["control"](a)
	end
end

local function draw(a)
	--love.graphics.setColor(Palette[a.c])
	if DebugMode then
		if a.spr then
			local anim=0
			if a.anim then
				anim=math.floor((Timer/a.anim.speed)%a.anim.frames)
			end
			--love.graphics.draw(Spritesheet[a.size],Quads[a.size][a.spr+anim],a.x,a.y,a.d,1,1,(a.size*Game.tile.width)/2,(a.size*Game.tile.height)/2)
		end
	end

---[[
	if a.spr then
		local dir=vector.direction(vector.components(Player.x,Player.y,a.x,a.y))
		local dist=vector.distance(Player.x,Player.y,a.x,a.y)
		local ray=actor.raycast(Player.x,Player.y,dir,dist,0.1)
		--if ray.len>=dist*math.cos(dir-Player.d) then
			local anim=0
			if a.anim then
				anim=math.floor((Timer/a.anim.speed)%a.anim.frames)
			end
			--love.graphics.setColor(255,0,77,255-dist*8)
			--love.graphics.setColor(255,0,77,0+dist*8)--ghosties oouuuououuou
			love.graphics.setColor(255-dist*8,0,77-dist*8,255)
			local deltadir=dir-(Player.d-Camera.fov/2)
			x=(deltadir)*Game.width
			love.graphics.draw(Spritesheet[a.size],Quads[a.size][a.spr+anim],x,(Game.height/2)+(100/dist),a.d,25/dist,25/dist,(a.size*Game.tile.width)/2,(a.size*Game.tile.height)/2)
		--end
	end
--]]

	if _G[Enums.actornames[a.t]]["draw"] then
		_G[Enums.actornames[a.t]]["draw"](a)
	end
end

local function damage(a,d)

end

local function impulse(a,dir,vel,glitch)
	glitch=glitch or false
	local vecx=math.cos(a.d)
	local vecy=math.sin(a.d)
	local impx=math.cos(dir)
	local impy=math.sin(dir)

	if glitch then
		impy = -impy
	end

	local outx,outy=vector.normalize(vecx+impx,vecy-impy)
	local outvel=a.vel+vel

	return vector.direction(outx,outy), outvel
end

local function raycast(x,y,d,dist,step)
	local ray={}
	ray.d=d
	for j=step,dist,step do
		local cellx=math.floor(x+math.cos(d)*j)
		local celly=math.floor(y+math.sin(d)*j)
		local cell=Map[celly][cellx]
		if cell then
			if cell==1 then
				local xlast=x+math.cos(d)*(j-step)
				local ylast=y+math.sin(d)*(j-step)
				local ray2=actor.raycast(xlast,ylast,d,step,step/10)
				ray.len=j+ray2.len
				return ray
			end
		end
	end
	ray.len=dist
	return ray
end

local function collision(a,enemy)
	if enemy.hitbox then
		if a.x>enemy.x+enemy.hitbox.x then
		if a.x<enemy.x+enemy.hitbox.x+enemy.hitbox.w then
		if a.y>enemy.y+enemy.hitbox.y then
		if a.y<enemy.y+enemy.hitbox.y+enemy.hitbox.h then
			return true
		end
		end
		end
		end
	end
	return false
end

local function getflag(bytes,f)
	--takes an actor's hex flags attribute and an integer flag position
	--returns true if that flag position is set
	local flag = 2^(f-1) --converts flag position to its actual hex number value (ie: f 1 = 1, f 2 = 2, f 3 = 4, f 4 = 8 etc.)
	if bit.band(bytes,flag) == flag then --checks if flag f is set in actor's flags. ignores other flags.
		return true
	else
		return false
	end
end

local function setflags(bytes,...)
	--takes an actor's hex flag attribute and a table of flag positions
	--SWITCHES the bit pointed to by each flag position
	--doesn't just turn ON bits, can turn OFF a bit by using a flag position that has already been set in the byte
	--returns updated flags
	local flags={...}
	for a=1,#flags do
		--print(flags[a])
		local flag = 2^(flags[a]-1) --converts flag position to its actual hex number value (ie: f 1 = 1, f 2 = 2, f 3 = 4, f 4 = 8 etc.)
		bytes=bit.bxor(bytes,flag)
	end
	return bytes
end

local function makehitbox(a,x,y,w,h)
	a.hitbox={}
	a.hitbox.x=x
	a.hitbox.y=y
	a.hitbox.w=w
	a.hitbox.h=h
end

local function makeanim(a,speed,frames)
	--sets actor to have an animation
	--speed is how many steps it takes for animation to cycle (higher number is slower animation)
	--frames is how many frames are in the animation
	a.anim={}
	a.anim.speed=speed
	a.anim.frames=frames
end

return
{
	make = make,
	control = control,
	draw = draw,
	makehitbox = makehitbox,
	makeanim = makeanim,
	raycast = raycast,
	collision = collision,
	damage = damage,
	impulse = impulse,
	getflag = getflag,
	setflags = setflags,
}
