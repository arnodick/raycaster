local function update()
	local debuglist={}
	table.insert(debuglist,Timer)
	table.insert(debuglist,"FPS:"..love.timer.getFPS())
	table.insert(debuglist,"Actors:"..#Actors)
	table.insert(debuglist,"player x:"..Player.x)
	table.insert(debuglist,"player y:"..Player.y)
	table.insert(debuglist,"player dir:"..Player.d)
	table.insert(debuglist,"player vx:"..Player.vec[1])
	table.insert(debuglist,"player vy:"..Player.vec[2])
	table.insert(debuglist,"player vel:"..Player.vel)
	table.insert(debuglist,"camx:"..Camera.x)
	table.insert(debuglist,"camy:"..Camera.y)
	table.insert(debuglist,"ray count:"..#Player.rays)
	for i=1,#Player.rays do
		table.insert(debuglist,"ray "..i..": "..Player.rays[i].d)
	end
	return debuglist
end

local function draw(debuglist)
	love.graphics.setFont(FontDebug)
	love.graphics.setColor(Palette[11])
	love.graphics.print("DEBUG",130,0)
	for i,v in ipairs(debuglist) do
		love.graphics.print(v,10,10+FontDebug:getHeight()*i)
	end
	love.graphics.setColor(Palette[16]) --sets draw colour back to normal
	love.graphics.setFont(Font)
end

return
{
	update = update,
	draw = draw,
}
