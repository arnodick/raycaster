local function make(a)
	a.d=math.randomfraction(math.pi*2)
	--a.vel=0.05
	a.spr=0
	a.size=2
	actor.makeanim(a,60,2)
end

local function control(a,gs)
	if math.floor(Timer%120)==0 then
		a.d=math.randomfraction(math.pi*2)
	end
end

local function hitground(a)

end

local function draw(a)
end

return
{
	make = make,
	control = control,
	hitground = hitground,
	draw = draw,
}
