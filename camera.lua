local function make(x,y)
	local c={}
	c.x=x
	c.y=y
	c.shake=0
	c.hit=0
	c.fov=math.pi*2
	c.resolution=0.01
	return c
end

local function control(c,t)

end

return
{
	make = make,
	control = control,
}
