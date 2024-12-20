--author:  game developer, email, etc.
--desc:    short description
--site:    website link
--license: MIT License (change this to your license of choice)
--version: 0.1
--script:  lua

function BOOT()
	menutiles = {
		logo = {
	[392] = {1,1},
	[393] = {2,1},
	[394] = {3,1},
	[395] = {4,1},
	[396] = {5,1},
	[408] = {1,2},
	[409] = {2,2},
	[410] = {3,2},
	[411] = {4,2},
	[412] = {5,2},
	[413] = {6,2},
	[414] = {7,2},
	},
	icon = {
		[331] = {8,1},
		[347] = {8,2},
		[363] = {8,3},

		[332] = {8,0},
		[364] = {8,4.7},
	}
	}

	gamestate = "mainmenu"

	trace("START HERE ---------")
	gravity = 0.2
	accelx = 0.3
	decelx = 0.8
	jump = 2.75
	maxaccel = 5

	mset(1,1,2566)
	--tags
	--0 = player solid
	--1 = portal surface
	--2 = can let through
	--3 = fizzle
	mapcontent = {
		objectlist = {
			orangeportal,
			blueportal,
			
		},
		interactablelist = {
		},
		entitylist = {
		},
		turretlist = {

		},
	}
	renderorder = {
		mapcontent.objectlist,
		mapcontent.interactablelist,
		mapcontent.entitylist,
	}

	maplist = {
		current = 1,
		[1] = {1,1},
		[2] = {2,1},
	}
	mapnames = {
		[1] = "1 - P-TOL",
		[2] = "2 - Wheato",
	}

	tiletypes = {
		[64] = {"cube","interactable",true,false,64,{["true"]=64,["false"]=64},0,00,"x","y",1,{0,0,8,8},nil,{"interactablelist","entitylist"}},
		[32] = {"button","activator",false,true,32,{["true"]=32,["false"]=33},0,00,"x","y",1,{1,6,14,2},"door1",{"interactablelist","objectlist"}},
		[49] = {"button","clickable",false,false,49,{["true"]=49,["false"]=49},0,00,"x","y",1,{0,0,8,8},"door1",{"interactablelist","objectlist"}},
		[81] = {"prop","door",false,false,81,{["true"]=97,["false"]=81},0,00,"x","y",1,{0,0,8,8},nil,{"interactablelist","objectlist"}},
		[65] = {"turret","x","y",1,{0,0,8,8},{"turretlist","interactablelist","entitylist"}}
	}
	entitycounts = {
		["button"] = 0,
		["cube"] = 0,
		["turret"] = 0,
		["prop"] = 0,
	}

	orangeportal = newPortal("orangeportal")
	blueportal = newPortal("blueportal")

	UIlist, UIelems, wheatleyface = getUI()
	t=1
	pcollidetime = 6
	portalcooldown = 0
	useCooldown = 0
	loadMap()

	music(0,0,0,true,true)
end




function loadMap()
	--x of maptiles, y of maptiles, no to draw, 
	local offsetx = (maplist[maplist.current][1]-1)*30
	local offsety = (maplist[maplist.current][2]-1)*29


	for x = 0,29 do
		for y = 0,16 do
		local tile = mget(offsetx + x, offsety + y)
		if tile == 128 then
			player,gun = newPlayer(x,y)
			mset(offsetx + x, offsety + y,15)
		end
		--elseif tile == 64 then
		if tiletypes[tile] then --if tile exists that has special function

			local object
			if tiletypes[tile][#tiletypes[tile]][1] == "interactablelist" then --if first entry of types has interactable then assign it to be interactable
				object = newInteractable(loadSprite(tile,x,y))
			end
			if tiletypes[tile][#tiletypes[tile]][1] == "objectlist" then --if first entry of types has object then assign it to be interactable
				object = newObject(loadSprite(tile,x,y))
			end
			if tiletypes[tile][#tiletypes[tile]][1] == "turretlist" then
				object = newTurret(loadSprite(tile,x,y))
			end

			for _,tble in pairs(tiletypes[tile][#tiletypes[tile]]) do
				if tble=="entitylist" then
					--table.insert(mapcontent.entitylist,object[1],object)
					mapcontent.entitylist[object.name] = object
				elseif tble=="interactablelist" then
					--table.insert(mapcontent.interactablelist,object[1],object)
					mapcontent.interactablelist[object.name] = object
				elseif tble=="objectlist" then
					--table.insert(mapcontent.objectlist,object[1],object)
					mapcontent.objectlist[object.name] = object
				elseif tble=="turretlist" then
					--table.insert(mapcontent.objectlist,object[1],object)
					mapcontent.turretlist[object.name] = object
				end
			end
			
			mset(offsetx + x, offsety + y,15)
		end
	end
	end
	for x,val in pairs(mapcontent) do
		for _,v in pairs(val) do
			trace(x)
			trace(_.." "..v.name)
		end
	end
	
	--return player,gun
end

function loadSprite(tile, x,y)

	local temp = {}
	for k, v in pairs(tiletypes[tile]) do temp[k] = v end
	entitycounts[tiletypes[tile][1]] = entitycounts[tiletypes[tile][1]]+1
	temp[1] = temp[1]..entitycounts[tiletypes[tile][1]]

	for _,val in pairs(temp) do
		if val == "x" then
			temp[_] = x*8
		elseif val == "y" then
			temp[_] = y*8
		end
	end
	return table.unpack(temp)
end



function getUI()
	local UIlist = {
		
		{0,104,240,32,00},

		{2,108,77,1,14},
		{2,109,77,30,15},

		{82,108,76,1,14},
		{82,109,76,30,15},

		{161,108,37,1,14},
		{161,109,37,30,15},

		{201,108,37,1,14},
		{201,109,37,30,15},

		{41,110,34,1,13},
		{41,111,34,9,14},

		{41,122,34,1,13},
		{41,123,34,10,14},


		{86,111,70,23,14},
		{87,112,68,21,00},
	}
	local UIelems = {
		oportal = {{496,0},{496,1},{496,2},{496,3}},
		bportal = {{497,0},{497,1},{497,2},{497,3}},
		noportal = {{498,0},{498,1},{498,2},{498,3}},
		heart = 499,
		noheart = 500,
		coin = 501,
		nocoin = 502,
		core = {{464,0},{464,1},{480,0},{480,1}}
	}

	local wheatleyface = {
		etop = {state=0, 
			{[5] = {15,14,13,14,15},  
			[6] = {14,15,13,13,14}
			}
		},
		ebot = {state=0, {[1] = {14,14,14,14,14}, [2] = {15,15,15,15,15}}},
	}
	return UIlist, UIelems, wheatleyface
end

function newPlayer(xx,yy)
	local player = {}
	player.name = "player"
	player.spval = 256
	player.splist = {
		idle={256,257},
		run={258,259}
	}
	player.x = xx*8
	player.y = yy*8
	player.nodraw = 00
	player.scale = 1
	player.flip = false
	player.rotate = 0

	player.gravity = gravity
	player.dogravity = true
	player.ax = accelx
	player.ay = jump
	player.dx = decelx
	player.maxax = maxaccel
	player.vx = 0
	player.vy = 0

	player.state = "idle"
	player.draw = true
	player.dotilecollide = {true,true,true}
	player.doportalcollide = true
	player.excludeportal = false
	player.portalcollidelen = 0
	player.isHolding = nil
	player.outline = {false,12}

	player.hearts = 3
	player.coins = 1

	mapcontent.entitylist[player.name] = player
	return player, newGun(player)
end
function newGun(player)
	local gun = {}

	gun.name = "gun"
	gun.spval = 272
	gun.splist = {272,273,288}
	gun.x = player.x
	gun.y = player.y
	gun.nodraw = 00
	gun.scale = 1
	gun.flip = player.flip
	gun.rotate = 0

	gun.gravity = 0
	gun.dogravity = false
	gun.ax = 0
	gun.ay = 0
	gun.dx = 0
	gun.maxax = 0
	gun.vx = 0
	gun.vy = 0
	gun.rect = {0,0,0,0}
	gun.state = nil
	gun.draw = true
	gun.dotilecollide = {false,false,false}
	gun.doportalcollide = false
	gun.portalcollidelen = 0
	gun.excludeportal = true
	gun.outline = {false,12}
	gun.ignore = true
	gun.type="gun"

	mapcontent.entitylist[gun.name] = gun
	return gun
end
function newPortal(type)
	local portal = {}
	portal.name = type
	if type=="orangeportal" then portal.spval = 274
	else portal.spval = 275 end
	portal.nodraw = 00
	portal.scale = 1
	portal.state = 1
	portal.flip = false
	portal.rotate = 0
	portal.draw = false
	portal.face = 1
	portal.dotilecollide = {false,false,false}

	portal.x = -1
	portal.y = -1
	portal.gravity = 0
	portal.dogravity = false
	portal.ax = 0
	portal.ay = 0
	portal.dx = 0
	portal.maxax = 0
	portal.vx = 0
	portal.vy = 0
	portal.rect = {0,0,0,0}
	portal.type="portal"
	portal.ignore = true

	portal.outline = {false,12}
	portal.excludeportal = true

	mapcontent.entitylist[portal.name] = portal
	return portal
end

function newTurret(name,xx,yy,scale,rect)
	local entity = {}
	entity.type = "turret"
	entity.name = name
	entity.spval = 65
	entity.splist = {["true"]=97,["false"]=65}
	entity.nodraw = 00
	entity.x = xx
	entity.y = yy
	entity.cangrab = true


	entity.gravity = gravity
	entity.dogravity = true
	entity.ax = accelx
	entity.ay = jump
	entity.dx = decelx
	entity.maxax = maxaccel
	entity.vx = 0
	entity.vy = 0



	entity.firetimer = 0
	entity.scale = scale
	entity.rect = rect
	entity.draw = true
	entity.flip = false
	entity.outline = {false,12}
	entity.grabbable = true
	entity.portalcollidelen = 0
	entity.canmove = true
	entity.dotilecollide = {true,true,true}

	return entity
end

function newBullet(xx,yy,angle,speed)
	entity = {}

	entity.type = "bullet"
	entity.name = "bullet"
	entity.spval = 113
	entity.splist = {}
	entity.nodraw = 00
	entity.x = xx
	entity.y = yy


	entity.gravity = 0
	entity.dogravity = false
	entity.ax = 20
	entity.ay = jump
	entity.dx = decelx
	entity.maxax = maxaccel
	entity.vx = 20
	entity.vy = 0


	entity.scale = scale
	entity.rect = {2,2,4,6}
	entity.draw = true
	entity.flip = false
	entity.outline = {false,12}
	entity.grabbable = false
	entity.portalcollidelen = 0
	entity.canmove = true
	entity.dotilecollide = {true,true,true}

	return entity

end


function newObject(name,spval,splist,xx,yy,scale,rect,multi,typer)
	local object = {}
	object.name = name
	object.spval = spval
	object.splist = splist
	object.x = xx
	object.y = yy
	object.scale = scale
	object.rect = rect
	object.multi = multi
	object.type = typer
	object.nodraw = 00
	object.draw = true
	object.outline = {false,12}
	

	return object
end
function newInteractable(name,objtype,grabbable,multi,spval,splist,flip,ndraw,xx,yy,scale,rect,clickable,linkname)
	local entity = {}
	entity.type = objtype
	entity.cangrab = grabbable
	entity.spval = spval
	entity.splist = splist
	entity.draw = true
	entity.x = xx
	entity.y = yy
	entity.scale = scale
	entity.state = false
	entity.outline = {false,12}
	entity.name = name
	entity.flip = flip
	entity.colliding = {true,true,true}
	
	entity.nodraw = ndraw
	entity.vx = 0
	entity.vy = 0
	entity.ax = 0
	entity.ay = 0
	entity.dx = 0
	entity.maxax = 0
	entity.rect = rect
	entity.portalcollidelen = 0
	entity.multi = multi
	
	if objtype == ("activator") then
		entity.link = linkname
		entity.dogravity = false
		entity.gravity = 0
		entity.canmove = false
		entity.dotilecollide = {false,false,false}
		entity.outline = {false,06}
	elseif objtype == ("clickable") then
		entity.link = linkname
		entity.dogravity = false
		entity.gravity = 0
		entity.canmove = false
		entity.dotilecollide = {false,false,false}
		entity.clickable = true
		entity.timer = 0
		entity.outline = {false,02}
	else
		entity.dotilecollide = {true,true,true}
		entity.canmove = true
		entity.gravity = gravity
		entity.dogravity = true
	end

	return entity
end


function boolToVal(input)
	local booltoval = {[true]=1,[false]=0, [2]=2, [3]=3}
	return booltoval[input]
end
function gmouse()
	local m = {}
	m.x,m.y,m.left,m.middle,m.right,m.scrollx,m.scrolly = mouse()
	return m
end
function drawLine(p1,p2,clr)
	line(p1.x+4,p1.y+4,p2.x+4,p2.y+4,clr)
end

function drawtextoutline(text,x,y,colour)
	print(text,x-1,y,colour)
	print(text,x+1,y,colour)
	print(text,x,y+1,colour)
	print(text,x,y-1,colour)
end

function draw(sprite)
	if sprite.draw then
	if sprite.outline[1] then
		for x=0,15,1 do
			poke4(0x3FF0*2+x,sprite.outline[2])
		end

		spr(sprite.spval,sprite.x-1,sprite.y,0,1,boolToVal(sprite.flip))
		spr(sprite.spval,sprite.x+1,sprite.y,0,1,boolToVal(sprite.flip))
		spr(sprite.spval,sprite.x,sprite.y+1,0,1,boolToVal(sprite.flip))
		spr(sprite.spval,sprite.x,sprite.y-1,0,1,boolToVal(sprite.flip))

		if sprite.multi then
			spr(sprite.spval,sprite.x+8+1,sprite.y,0,1,boolToVal(true))
			spr(sprite.spval,sprite.x+8,sprite.y+1,0,1,boolToVal(true))
			spr(sprite.spval,sprite.x+8,sprite.y-1,0,1,boolToVal(true))
		end
		for c=0,15 do
			poke4(0x3FF0*2+c,c)
		end
	end

	
		if sprite.multi then
			spr(sprite.spval, sprite.x+8, sprite.y, sprite.nodraw,sprite.scale,boolToVal(true),sprite.rotate)
		end
		spr(sprite.spval, sprite.x, sprite.y, sprite.nodraw,sprite.scale,boolToVal(sprite.flip),sprite.rotate)
	end
end



function getPortalrect(portal)
	if portal.face==1 then
		return portal.x,portal.y,2,8
	elseif portal.face==2 then
		return portal.x,portal.y,8,2
	elseif portal.face == 3 then
		return portal.x+6,portal.y,2,8
	elseif portal.face==4 then
		return portal.x,portal.y+6,8,2
	end
end
function getInteractrect(sprite)
	--rect(sprite.x+sprite.rect[1],sprite.y+sprite.rect[2],sprite.rect[3],sprite.rect[4],2)
	return sprite.x+sprite.rect[1],sprite.y+sprite.rect[2],sprite.rect[3],sprite.rect[4]
end
	

function sprmega(sprite,x,y,nodraw)
	local xz=0
	local yz=0
		for _,sp in pairs(sprite) do
			if xz>1 then
				xz=0
				yz=8
			end
			spr(sp[1],x+((xz)*8),y+yz,nodraw,1,sp[2])
			xz=xz+1
		end
end

function drawUI()
	
	for _,pos in pairs(UIlist) do
		rect(pos[1],pos[2],pos[3],pos[4],pos[5])
	end	

	
	local x = 0
	local y = 0

	

	sprmega(UIelems.noportal,90,114,00)
	sprmega(UIelems.noportal,136,114,00)
	

	for x=1,3 do
		spr(UIelems.noheart, 46+((x-1) *9 ), 111, 06)
		spr(UIelems.nocoin, 45+((x-1) *10 ), 124, 06)
	end
	
	print("HEALTH",5,113,00)
	print("HEALTH",4,112,02)
	print("COINS",5,126,00)
	print("COINS",4,125,03)


	
	
end
function solid(x,y)
	return fget(mget((x//8) + ((maplist[maplist.current][1]-1)*30),(y)//8),0)
end
function solidportal(x,y,type)
	return fget(mget((x//8) + ((maplist[maplist.current][1]-1)*30),(y)//8),type)
end

function spriteoverlap(ax,ay,aw,ah, bx,by,bw,bh)
	return ax<bx+bw and bx<ax+aw and ay<by+bh and by<ay+ah
end

function spriteoverlapall(ax,ay,aw,ah,name)
	for _,val in pairs(mapcontent.objectlist) do 
		if spriteoverlap(ax,ay,aw,ah,getInteractrect(val)) and name ~= val.name and val.draw then
			return true 
		end
	end
	return false
end

function UIinteractable()
	if orangeportal.draw then sprmega(UIelems.oportal,90,114,00) wheatleyface.etop.state = 1 end
	if blueportal.draw then sprmega(UIelems.bportal,136,114,00) wheatleyface.ebot.state = 1 end
	for x=1,player.hearts do spr(UIelems.heart, 45+((x-1) *9 ), 111, 00) end
	for x=1,player.coins do spr(UIelems.coin, 44+((x-1) *10 ), 124, 00) end


	if wheatleyface.etop.state > 0 then
		replacepixarea(UIelems.core[1][1],wheatleyface.etop[1],{5,5},{7,6})
		wheatleyface.etop.state = wheatleyface.etop.state-0.05
	end
	if wheatleyface.ebot.state > 0 then
		replacepixarea(UIelems.core[3][1],wheatleyface.ebot[1],{5,1},{7,2})
		wheatleyface.ebot.state = wheatleyface.ebot.state-0.05
	end


	sprmega(UIelems.core,112,114,6)
end

function velocity()
	for _,sprite in pairs(mapcontent.entitylist) do
		if math.abs(sprite.vy) > (4.5) then
			if sprite.vy < 0 then sprite.vy = (-4.5 ) else sprite.vy = (4.5) end
		end


		sprite.x = sprite.x + (sprite.vx)
		sprite.y = sprite.y + (sprite.vy)



		sprite.vx = sprite.vx*(sprite.dx)
		if math.abs(sprite.vx) < (0.05 ) then sprite.vx = 0 end
	end
	for _,sprite in pairs(mapcontent.interactablelist) do
		if sprite.canmove then
			if math.abs(sprite.vy) > (4.5 ) then
				if sprite.vy < 0 then sprite.vy = (-4.5 ) else sprite.vy = (4.5) end
			end


			sprite.x = sprite.x + (sprite.vx)
			sprite.y = sprite.y + (sprite.vy)



			sprite.vx = sprite.vx*(sprite.dx )
			if math.abs(sprite.vx) < (0.05 ) then sprite.vx = 0 end
		end
	end
end

function collideTile()
	for _, sp in pairs(mapcontent.entitylist) do
		


		sp.colliding = {false,false,false}

		floor={nil}
		roof={nil}
		side={nil}
		side2={nil}
		if sp.dotilecollide[1] then floor = {solid(sp.x+2, sp.y+sp.vy+8), solid(sp.x+6, sp.y+sp.vy+8)}  end
		if sp.dotilecollide[2] then roof = {solid(sp.x+2, sp.y+sp.vy), solid(sp.x+6, sp.y+sp.vy)} end
		if sp.dotilecollide[3] then 
			side = {solid(sp.x+sp.vx+1, sp.y+2), solid(sp.x+sp.vx+1, sp.y+6)}
			side2 = {solid(sp.x + sp.vx+6, sp.y+2), solid(sp.x + sp.vx+6, sp.y+6)}
		end
		
		--floor collision
		if floor[1] or floor[2] then
			
			sp.vy = 0
			if (solid(sp.x+2,sp.y+8) and solid(sp.x+6,sp.y+8)) and (sp.y+sp.vy+8) % 8 ~= 0 then
				sp.y = sp.y - (sp.y+sp.vy+8) % 8
			end
			sp.colliding[1] = true
		else --apply gravity
			if sp.dogravity then
				sp.vy = sp.vy+(sp.gravity)
				sp.colliding[1] = false
			end
			
		end
		--roof collision
		if roof[1] or roof[2] then
			sp.vy = math.abs(sp.vy)
			sp.colliding[2] = true
		else
			sp.colliding[2] = false
		end
		--side collision
		if side[1] or side[2] or side2[1] or side2[2] then
			sp.vx = 0
			sp.colliding[3] = true
		else
			sp.colliding[3] = false
		end

		collideInteractables(sp)

		collideObjects(sp)
		
	end
end

function collideObjects(spr)
	--for _,spr in pairs(mapcontent.entitylist) do
		for _,obj in pairs(mapcontent.objectlist) do

			if spr.draw and obj.draw and spr.name ~= obj.name and not spr.ignore and not obj.ignore and (obj.type == "activator" or (obj.type == "prop" and obj.state==false)) then

				local sides = spriteoverlap(spr.x+spr.vx,spr.y+spr.vy,8,8, getInteractrect(obj))
					--local sideleft = spriteoverlap(spr.x,spr.y,1,8, obj.x+7,obj.y+1,1,6)
				local roof = spriteoverlap(spr.x+spr.vx+1,spr.y+spr.vy+6,6,4, getInteractrect(obj))
				if roof then
					if spr.y+8 < obj.y+8 then
						if not spr.colliding[1] then
							spr.colliding[1] = true
						end
						if spr.vy > 0 then
							spr.vy=0
						end
					end
					
				end
				if sides then
					spr.colliding[3] = true
					obj.colliding[3] = true
					if obj.rect[4] < 4 then
						spr.y = spr.y-obj.rect[2]
						if spr.vy > 0 then
							spr.vy=0
						end
					end
					if spr.x > obj.x+8 and spr.vx < 0 then
						spr.vx=0
					elseif spr.x+8 < obj.x and spr.vx > 0 then
						spr.vx =0 
					end
					
				end
				if sides or roof then
					obj.state = true
				end
			end
			if obj.clickable then
				if spriteoverlap(spr.x,spr.y,8,8,getInteractrect(obj)) then
					obj.inrange = true
				end
			end
		end
	--end
end

function collideInteractables(spr)
		for _,obj in pairs(mapcontent.interactablelist) do
			if spr.draw and obj.draw and obj.canmove and spr.name ~= obj.name and not spr.ignore and not obj.ignore then
				local sides = spriteoverlap(spr.x+spr.vx+1,spr.y+spr.vy+1,6,6, getInteractrect(obj))
				local roof = spriteoverlap(spr.x+1,spr.y+4+spr.vy,6,4, getInteractrect(obj))
				local floor = spriteoverlap(spr.x+1,spr.y,6,2,getInteractrect(obj))
				local inblock = spriteoverlap(spr.x+1,spr.y+spr.vy,6,6,getInteractrect(obj))

				if inblock then
					if spr.x < obj.x then
						if spr.vx > 0 then
							spr.vx=0
						end
					elseif spr.x > obj.x then
						if spr.vx < 0 then
							spr.vx=0
						end
					elseif spr.x < obj.x then
						if spr.vx < 0 then
							spr.vx=0
						end
						if spr.vx > 0 then
							spr.vx=0
						end
					end
				end

				if roof then --top of cube
					--if obj.colliding[1] then
						spr.colliding[1] = true
						if spr.vy > 0 then
							spr.vy=0
						end
					--end
				end
				if floor and not roof then
					obj.colliding[1] = true
					if spr.vy > 0 then
						spr.vy=0
					end
					if obj.vy > 0 then
						obj.vy=0
					end
				end
				if sides then
					if not obj.colliding[3] then
						if spr.x < obj.x and spr.vx > 0 then
								obj.vx = spr.vx
								spr.vx = obj.vx
						elseif spr.x+8 > obj.x+8 and spr.vx < 0 then
							obj.vx = spr.vx
							spr.vx = obj.vx
						end
					else
						
						if spr.x < obj.x and spr.vx > 0 then
							spr.vx = 0
						elseif spr.x+8 > obj.x+8 and spr.vx < 0 then
							spr.vx = 0
						end
					end
				end
			end
		end
end

function holdobject(sprite)
	object = sprite.isHolding
	local m = gmouse()	
	local angle, l = getAngleDistance(sprite,gmouse())
	

	if length > 12 then length = 12 end
	if sprite.vy == 0 then
		if (math.deg(angle) > 15 and math.deg(angle) < 90) then
			angle = math.rad(25)
		elseif (math.deg(angle) > 90 and math.deg(angle) < 181) then
			angle = math.rad(165)
		end
	end

	local tx = (length * math.cos(angle) + sprite.x)
	local ty = (length * math.sin(angle) + sprite.y)

	if length < 2 or not object.doportalcollide then
		dropobject(sprite)
	end
	if solid(tx+8+sprite.vx,ty+4+sprite.vy) or solid(tx+sprite.vx,ty+4+sprite.vy) or solid(tx+4+sprite.vx,ty+6) or spriteoverlapall(tx+1,ty+1,6,6,object.name) then --or solid(tx+10+sprite.vx,ty+4+sprite.vy) or solid(tx+4+sprite.vx,ty+7+sprite.vy) then
		length = length - 1
		tx = (length * math.cos(angle) + sprite.x)
		ty = (length * math.sin(angle) + sprite.y)
		
		--length = getAngleDistance({x=tx+8+sprite.vx, y=ty+4+sprite.vy},object)
	else
		if length < 12 then
			length = length+1
		end
	end

	object.x = tx
	object.y = ty

	if object.x < sprite.x then
		object.flip = true
	else
		object.flip = false
	end
	portalcooldown = 8
end

function grabobject(sprite)
	local angle,maxl = getAngleDistance(sprite,gmouse())

	length = 2
	if maxl > 46 then
		return
	end

	while length < maxl do
		ax = length * math.cos(angle) + sprite.x+4
		ay = length * math.sin(angle) + sprite.y+4

		pix(ax,ay,2)
		for _,obj in pairs(mapcontent.interactablelist) do
			if obj.cangrab and obj.draw then
				if solid(ax,ay) then
					return
				end

				if spriteoverlap(ax,ay,2,2, obj.x,obj.y,8,8) then
					player.isHolding = obj
					obj.dogravity = false
					return true
				end
			end
		end

		if solid(ax,ay) then
			maxl = length-1
		end
		length=length+4
	end
	return nil

end

function dropobject(sprite)
	sprite.isHolding.dogravity = true
	sprite.isHolding = nil
end

function getAngleDistance(sprite,object)
	local xval = (object.x - sprite.x) * (object.x - sprite.x) 
	local yval = (object.y-sprite.y) * (object.y-sprite.y)

	local angle = math.atan2(object.y - sprite.y, object.x - sprite.x)
	local length = (math.sqrt(xval + yval))

	return angle, length
end

function gunUpdate()
	local m = gmouse()

	if m.left and portalcooldown == 0 then
		makePortal(orangeportal)
		if orangeportal.x == blueportal.x and orangeportal.y == blueportal.y then
			orangeportal.draw = false
		end
		portalcooldown = 8
	end
	if m.right and portalcooldown == 0 then
		makePortal(blueportal)
		if orangeportal.x == blueportal.x and orangeportal.y == blueportal.y then
			blueportal.draw = false
		end
		portalcooldown = 8
	end
	if m.middle or solidportal(gun.x+4,gun.y+4,3) then
		orangeportal.draw = false
		blueportal.draw = false
		orangeportal.x= -1
		orangeportal.y= -1
		blueportal.x= -1
		blueportal.y= -1
		
	end
	gunSpriteState()
	gun.scale = player.scale
	gun.x = player.x+2
	gun.y = player.y-1
	gun.flip = player.flip
	if gun.flip then
		gun.x = player.x-2
	end
	if portalcooldown > 0 then
		portalcooldown = portalcooldown-1
	end
end
function gunSpriteState()
	if orangeportal.draw and blueportal.draw then
		poke(0x3FFB,264)
		gun.spval = gun.splist[3]
	elseif orangeportal.draw then
		poke(0x3FFB,262)
		gun.spval = gun.splist[2]
	elseif blueportal.draw then
		poke(0x3FFB,261)
		gun.spval = gun.splist[1]
	else
		poke(0x3FFB,263)
		gun.spval = gun.splist[1]
	end

	if portalcooldown > 0 then
		poke(0x3FFB,264)
		gun.spval = gun.splist[3]
	end
end

function raycast(angle)
	local length = 2
	local px = player.x
	local py = player.y
	local r = 0
	local f = false
	
	local sidec = false
	local side2 = false
	local floorc = false
	local roofc = false

	while true do
		ax = length * math.cos(angle) + px
		ay = length * math.sin(angle) + py
		
	
		inblock = solid(ax+4,ay+4)
		floor = {solid(ax+1,ay+6),solid(ax+7,ay+6)}
		roof = solid(ax+4, ay-1)
		side = {solid(ax+1, ay), solid(ax+1,ay+8)}
		side2 = {solid(ax+7, ay), solid(ax+7,ay+8)}
		
		if spriteoverlapall(ax+4,ay+4,1,1,"temp") then return end
		if solidportal(ax,ay,2) then return end
		ay = math.floor((ay/8)+0.5)*8
		ax = math.floor((ax/8)+0.5)*8
		
		if not inblock then
		--side collision
			if side[1] and side[2] then
				sidec = true
				f = true
				r = 0
			end
			if side2[1] and side2[2] then
				sidec = true
				f = false
				r = 0
				
			end
			
				--floor collision
			if floor[1] and floor[2] then
				floorc = true
			end
			
			--roof collision
			if roof then
				roofc = true
			end
		else
			roofc = true
			ay=ay+8
		end
		
		if sidec or floorc or roofc then
			if floorc and not sidec and not roofc then --if floor detect, rotate down
				r = 1
				f = false
			end
			if roofc and not sidec and not floorc then
				r = 3
				f = false
			end


			if r==1 then
				ty = ay+8
				tx = ax
			elseif r==3 then
				ty = ay-8
				tx = ax
			else
				if f then
					ty = ay
					tx = ax-8
				else
					ty = ay
					tx = ax+8
				end
			end
			if solidportal(tx,ty,1) then
				return {ax,ay,r,f}
			else
				return nil
			end
		end
		length = length+0.5
	end
	return nil
end
function makePortal(portalcol)
	local angle,l = getAngleDistance(player,gmouse())

	local output = raycast(angle)
	if output then
		portalcol.x = output[1]
		portalcol.y = output[2]
		portalcol.rotate = output[3]
		portalcol.flip = output[4]

		if portalcol.flip then portalcol.face = 1 else portalcol.face = 3 end --facing west, if not east
		if portalcol.rotate == 1 then portalcol.face = 4 elseif portalcol.rotate==3 then portalcol.face = 2 end  --facing down if not up
		portalcol.draw = true
		return
	end
	
end

function ObjectUpdate()
	for _,object in pairs(mapcontent.interactablelist) do
		object.spval = object.splist[tostring(not object.state)]
		object.outline[1] = object.state
		if object.clickable then
			if object.inrange then
				object.outline[1] = true
				if object.state then 
					object.outline[2] = 06 
				else
					object.outline[2] = 02
				end
			end
			if object.timer > 0 then
				object.timer = object.timer - 1
				object.state = true
			end
		end
		if solidportal(object.x,object.y,3) then
			object.draw = nil
			if player.isHolding == object then
				dropobject(player)
			end
		end

		object.state = false
		
	end

	

end

function activateobject(sprite)
	for _,obj in pairs(mapcontent.interactablelist) do
		if obj.clickable and obj.inrange then
			obj.state = true
			obj.timer = 120
		end
	end
end

function playerUpdate()
	if key(28) then
		maplist.current = 1
	elseif key(29) then
		maplist.current = 2
	end
	player.state = "idle"
	if (btn(2) or key(01)) and player.doportalcollide then 
		if player.vx > -player.maxax then 
			player.vx = player.vx - (player.ax) 
		end
		player.state = "left"
	end
	if (btn(3) or key(04)) and player.doportalcollide then 
		if player.vx < player.maxax then 
			player.vx = player.vx + (player.ax)
		end
		player.state = "right"
	end
	if (btn(0) or key(48)) and player.colliding[1] then
		player.vy = player.vy-(player.ay)
		player.state = "jump"
	end
	if (btn(1) or key(63)) then
		player.vx = player.vx*0.7
		if player.vy > 0 then
			player.vy = player.vy*(0.9)
		else
			player.vy = player.vy*(0.8)
		end
	end
	
	if keyp(05,1,15) then
		if not player.isHolding then
			
			grabobject(player)
			--activateobject(player)
		else
			dropobject(player)
		end
	end
	playerSpriteState()

	
	if player.isHolding then
		holdobject(player,player.isHolding)
	end
end
function playerSpriteState()
	if gmouse().x < player.x then
		player.flip = true
	else
		player.flip = false
	end


	if player.state == "idle" then --idle
		player.spval = player.splist.idle[math.floor(t/30 % #player.splist.idle) + 1]
	elseif player.state == "left" or player.state == "right" then --run
		player.spval = player.splist.run[math.floor(t/15 % #player.splist.run) + 1]

		if player.state == "right" then --flip on direction
			player.flip = false
		else
			player.flip = true
		end
	end
end

function TurretUpdate()
	for _,obj in pairs(mapcontent.turretlist) do
		--if not obj.flip and player.x > obj.x then
			local angle,distance = getAngleDistance(obj,player)


			if not obj.flip and player.x > obj.x then
				if player.x < obj.x + 64 and (player.y < obj.y+12 and player.y > obj.y-12)  then
					obj.firetimer = obj.firetimer + 1
				end
				if player.x < obj.x + 78 and (player.y < obj.y+12 and player.y > obj.y-12)  then
					obj.seen = true
				else
					obj.seen = false
				end
			elseif obj.flip and player.x < obj.x then
				if player.x+8 > obj.x - 64 and (player.y < obj.y+12 and player.y > obj.y-12)  then
					obj.fire = obj.firetimer + 1
				end
				if player.x+8 > obj.x - 78 and (player.y < obj.y+12 and player.y > obj.y-12)  then
					obj.seen = true
				else
					obj.seen = false
				end
			else
				obj.seen = false
			end

			
			if player.isHolding == obj then
				obj.firetimer = 40
				obj.seen = true
			end
			if obj.firetimer >= 40 then
				obj.fire = true
				if obj.firetimer > 50 then
					obj.firetimer = 50
				end
			elseif obj.firetimer <= 0 then
				obj.fire = false
				obj.firetimer = 0
			end

		--for _,object in pairs(mapcontent.turretlist) do
			if obj.fire then
				if t%12 == 0 then
					sfx(3,'E-3',15,0,15,0)
					sfx(2,'F-4',15,0,12,1)

					table.insert(mapcontent.entitylist,newBullet(obj.x+8,obj.y,10,0))
				end
				if t%10 <= 5 then
					obj.spval = 97
				else
					obj.spval = 65
				end
				obj.firetimer = obj.firetimer - 0.5
			
				
			else
				if obj.seen and obj.firetimer < 20 then
					sfx(4,'D-5',50,0,15,0)
				end
			end

				
			

		--end
	end
end

function addwithSign(num,add)
	if num < 0 then return num - add end
	if num >= 0 then return num + add end
end

function invert(num)
	if num > 0 then return -num 
	else return math.abs(num)
	end
end

function portalLogic()
		for _,sprite in pairs(mapcontent.entitylist) do
			sprite.dotilecollide = {true,true,true}
			if sprite.doportalcollide then
				
				--portalcolliders = collidePortal(sprite)

				--if not portalcolliders[1] then
				--	goto nextsprite
				--end
				if sprite.excludeportal or not sprite.draw then
					goto nextsprite
				end

				local ox=0 
				local oy=0
				if spriteoverlap(sprite.x+sprite.vx,sprite.y+sprite.vy,8,8,getPortalrect(orangeportal)) then
					sprite.x = blueportal.x
					sprite.y = blueportal.y
				elseif spriteoverlap(sprite.x+sprite.vx,sprite.y+sprite.vy,8,8,  getPortalrect(blueportal)) then
					if orangeportal.face==1 then ox=0 oy=0
					elseif orangeportal.face==2 then ox=0 oy=0	
					elseif orangeportal.face==3 then ox=0 oy=0
					else ox=0 oy=-4 end
					sprite.x = orangeportal.x
					sprite.y = orangeportal.y
				else
					goto nextsprite
				end
				
				local tx = sprite.vx
				local ty = sprite.vy
				
				sprite.doportalcollide = false

				if blueportal.face==orangeportal.face then --same side

					if blueportal.face == 3 or blueportal.face == 1 then --horiz (1-3)
						if blueportal.face==1 then 
							if sprite.vx==0 then sprite.vx=-2 end
						else
							if sprite.vx==0 then sprite.vx=2 end
						end
						sprite.vx = invert(sprite.vx)*1.2
					else  --vert (2-4)
						
						sprite.vy = invert(sprite.vy)*1.17
						sprite.dotilecollide = {false,false,true}
						--sprite.vy = invert(sprite.vy)*1.1
					end
				
				elseif blueportal.face == 2 or orangeportal.face == 2 then --up to horiz
					if blueportal.face == 1 or orangeportal.face == 1 then --west portal
						sprite.vy = math.abs(tx)
						sprite.vx = -ty*1.1
					elseif blueportal.face == 3 or orangeportal.face == 3 then
						sprite.vy = math.abs(tx)
						sprite.vx = ty*1.1
					end

				elseif blueportal.face == 4 or orangeportal.face == 4 then --down to horiz
					if ty==0 then ty=sprite.gravity*5 end
					if blueportal.face == 1 or orangeportal.face == 1 then  --west portal
						sprite.vx = math.abs(ty*1.2)
						sprite.vy = -math.abs(tx*1.1)
					elseif blueportal.face == 3 or orangeportal.face == 3 then
						sprite.vx = -math.abs(ty*1.2)
						sprite.vy = -math.abs(tx*1.1)
					end
				end
				::nextsprite::
			else

				if sprite.portalcollidelen >= 4 then
					sprite.doportalcollide = true
					sprite.portalcollidelen = 0
				else
					sprite.doportalcollide = false
					sprite.portalcollidelen = sprite.portalcollidelen+1
				end
			end
		end
end

function getmaptiles()
	return (maplist[maplist.current][1]-1)*30, (maplist[maplist.current][2]-1)*29,30,17,0,0
end



function drawFrame()
	--sync(0,0,false)
	--loadMap()
	
	vbank(0)
	poke(0x3FF8,15)
	cls(00)
	index = 01
	r=36
	g=41
	b=55	
	poke(0x03fc0 + index * 3, r)
  	poke(0x03fc0 + index * 3 + 1, g)
 	poke(0x03fc0 + index * 3 + 2, b)
	map(0,34,34,17,-math.abs(player.x/25),1,6)
	


	map(0,17,34,17,-math.abs(player.x/15),1,6)


	vbank(1)
	map(getmaptiles())
	

	
	
	--draw outline shiz
	local a,l = getAngleDistance(player,gmouse())
	--end of outline shiz
	print(math.deg(a),1,56,2)

	print("o "..tostring(orangeportal.face),9,1,2)
	print("b "..tostring(blueportal.face),9,8,2)



	for _,val in ipairs(renderorder) do
		for _,sprite in pairs(val) do
			draw(sprite)
			if sprite.type == "turret" then
				if sprite.seen  then
					spr(98,sprite.x,sprite.y-10, 00, 1)
				end
			end
		end
		
	end

	poke4(0x08000* 2,257)
	print(mget(0,0).." tile",1,32,2)
	print(peek4(0x08000 * 2).." tile",1,40,2)

	print(t,64,2,2)
	--for _,obj in pairs(objectlist) do
	--	outline(obj)
	--	draw(obj)
	--	
	--end
	--for _,sprite in pairs(entitylist) do
	drawUI()
	UIinteractable()
	
	
end



function BDR(scnline)
	if gamestate ~= "ingame" then
		vbank(0)
		if scnline % 5 == 0 then
			r=26-scnline/6
			g=28-scnline /6
			b=44-scnline /6
		end
		index=0
		index2=15
		poke(0x03fc0 + index * 3, r)
		poke(0x03fc0 + index * 3 + 1, g)
		poke(0x03fc0 + index * 3 + 2, b)


		
		poke(0x03fc0 + index2 * 3, r+7)
		poke(0x03fc0 + index2 * 3 + 1, g+7)
		poke(0x03fc0 + index2 * 3 + 2, b+7)

		vbank(1)
	else
		if scnline < 100 then
			vbank(0)
			index=1
			index2 = 15
			if scnline % 10 == 0 then
				r=39-scnline/3
				g=46-scnline/3
				b=54-scnline/3
			end
			if r<0 then r=0 end
			if g<0 then g=0 end
			if b<0 then b=0 end
			poke(0x03fc0 + index * 3, r)
			poke(0x03fc0 + index * 3 + 1, g)
			poke(0x03fc0 + index * 3 + 2, b)
	
			if scnline % 6 == 0 then
				rr=51-scnline/3
				gg=60-scnline/3
				bb=87-scnline/2
			end
			if rr<0 then rr=0 end
			if gg<0 then gg=0 end
			if bb<0 then bb=0 end
			poke(0x03fc0 + index2 * 3, rr)
			poke(0x03fc0 + index2 * 3 + 1, gg)
			poke(0x03fc0 + index2 * 3 + 2, bb)
	
	
			vbank(1)
	end
end
end

function collision()
	if orangeportal.draw and blueportal.draw then
		portalLogic() 
	else
		for _,sprite in pairs(mapcontent.entitylist) do
			sprite.doportalcollide = true
		end
	end

	collideTile()
end

function replacepixarea(sprite, spritereplacers, repstart, repend)
	--THIS x AND Y OF SPRITE ARE CORRECT
	--Y value of sprite
	local by = sprite / 2
	--x pos
	local xm = sprite % 16

	print(xm.." "..by,36,9,2)
	for x = xm+repstart[1],xm+repend[1],1 do
		for y = by+repstart[2],by+repend[2],1 do
			print(x, 80, 9 ,2)
			--addr*2+x%8+by%8*8)
			--get mem address of pixel ^^
			local addr=0x4000+(x//8+y//8*16)*32 -- get sprite address	
			--prints pixel to top left!!!
			--pix(x,y,peek4(addr*2+x%8+by%8*8),36,8,2)
			poke4(addr*2+x%8+y%8*8,spritereplacers[y-by][x]) -- set sprite pixel
		end
	end
end
	


function mainmenu()

	

	iconanim = {-1.5,-1,-0.5,0,0.5,1,1.5}
	cls(00)
	scale = 2
	vbank(0)
	cls(00)
	map(0,17,34,17,-math.abs(t/2%240),1,6)
	map(0,17,34,17,-math.abs(t/2%240)+240,1,6)

	


	bg = {
		{176,56,2},
		{181,46,3},
		{191,26,4},
		{197,14,11},
	}
	for _,val in pairs(bg) do
	--176 to 232 (56)
		rect(val[1],0,val[2],140,val[3])
	end
	vbank(1)

	
	logomult = math.cos(math.rad((t%360)))
	menutiles.icon[331][2] = 1 + logomult
	menutiles.icon[347][2] = 2 + logomult
	menutiles.icon[363][2] = 3 + logomult
	--0.1*math.cos((t/2%60)//3.14)

	for _,tbl in pairs(menutiles) do
		if _ == "icon" then scale=3 else scale=2 end
		for pos,val in pairs(tbl) do
			spr(pos,(val[1]*(8*scale)),(val[2]*(8*scale)),00,scale)
		end
	end
	
	

		print("New Game", 16, 64, 10)
		print("Levels", 16, 72, 3)
		print("Options", 16, 80, 2)
		print("Exit :(", 16, 88, 15)

		if gamestate == "start" then
			Buttonanim(16,64, "New Game", 10,"ingame")
			music()
			return
		end
		if gamestate == "exitgame" then
			Buttonanim(16,88, "Exit :(", 15,"exit")
			return
		end
		--drawtextoutline("New Game",16,64,12)
		--print("New Game",16,64,10)
		--print("Levels",16,72,3)
		--print("Options",16,80,3)

		if Button(16,64,"New Game",10) and gmouse().left then --new game
			gamestate = "start"
			
		end

		if Button(16,72,"Levels",3) and gmouse().left then --Levels
			if useCooldown <= 0 then
				LvlMenu = not LvlMenu
				useCooldown = 5
			end

		end

		if Button(16,80,"Options",2) and gmouse().left then --new game
			print("e")
		end

		if Button(16,88,"Exit :(",15) and gmouse().left then --new game
			gamestate = "exitgame"
		end
		LevelsMenu()
		if useCooldown > 0 then
			useCooldown = useCooldown-1
		end
		
end


function Buttonanim(bx,by,text, clr, state)
	
	vbank(1)
	bh = 6
	bw = string.len(text)*5 + string.len(text)


	if not offset then offset = 1 end
	if offset > bw then
		gamestate = state
		return
	end

	print(text,bx,by,clr)
	rect(bx-6,by-2,offset,8,00)
	spr(274,bx-6+offset,by-2,00,1,1)
	spr(275,bx+bw-6,by-2,00,1,0)
	offset = offset + 3
	vbank(0)
end
function Button(bx,by,text,colour)
	bh = 6
	bw = string.len(text)*5 + string.len(text)
	aw=1
	ah=1
	ax = gmouse().x
	ay = gmouse().y

	local output = ax<bx+bw and bx<ax+aw and ay<by+bh and by<ay+ah

	if output then
		spr(274,bx-6,by-2,00,1,1)
		spr(275,bx+bw-6,by-2,00,1,0)
		drawtextoutline(text,bx,by,12)
	end
	print(text,bx,by,colour)
	
	return output
end

function LevelsMenu()

	if not LvlMenu then return end
	rect(88,48,64,80,15)
	rect(88,48,64,2,14)
	rect(90,65,60,61,14)

	print("Levels: ",92,55,12)
	for _,val in pairs(maplist) do
		if tonumber(_) then
			if Button(94,61 + (_*8),mapnames[_],4) and gmouse().left then
				maplist.current = _
				gamestate = "start"
			end
		end
	end
end

function TIC()
	--gamestate = "ingame"
	--music()
	if gamestate == "mainmenu" or gamestate == "start" then
		mainmenu()
	elseif gamestate == "ingame" then

		playerUpdate()
		gunUpdate()
		ObjectUpdate()
		TurretUpdate()

		collision()
		velocity()

		
		
		drawFrame()
	elseif gamestate == "exit" then
		exit()
	end
	
	if key(44) then
		exit()
	end
	
	t=t+1	

	
end
-- <TILES>
-- 000:ddddddddfefefeffeeeeeeeffefefeffeeeeeeefefefefefeeeeeeefffffffff
-- 001:eeeeeeeeedcdcdcdecccccccecdcdcdcecccccccedcdcdcdecccccccecdcdcdc
-- 003:cccccccecfdcddfecdcddddeccdddddecdddddeecdddeedecfdeedfeeeeeeeee
-- 004:dddddddfdeeeeeefdedeeeefddeeeeefdeeeeeffdeefefffdefeffefffffffff
-- 005:eeeeeeeeeddddddededdddeddddddddddabaa99ddbaa999ddaa999adda999aad
-- 016:1111111111111111111111111111111111111111111111111111111111111111
-- 019:cdcddcdcdccccccdccccccccdccccccddccccccdccccccccdccccccdcdcddcdc
-- 020:ffffffffff0000fff0f00f0ff00ff00ff00ff00ff0f00f0fff0000ffffffffff
-- 021:d999aabdd99aab9ddaaabaaeeaabaaaeeeeeeeeeeddddddefddddddfefeeeefe
-- 032:000000000000000000000000000000000220000002223233dcceeceedddeedff
-- 033:000000000000000000000000000000000330000003334344dcceeceedddeedff
-- 048:f9dddd9ffaccccaf000660000006600000055000000660000005500000055000
-- 049:000430000002200000edde0000edde0000edde0000edde0000ffff0000ffff00
-- 050:eeededdceeededdc0fffffff0eed00df0ffddddf0ffffffd0ffffffd0ffaabbf
-- 051:ccdedeeeccdedeeefffffff0fd00dee0fddddff0dffffff0dffffff0fbbaaff0
-- 052:dd000000dcff0000dcfe0000ab000000ab000000dc000000ab000000abfe0000
-- 053:0000000000000000000000000000000000000000aabbbbbafffeefff00000000
-- 054:bbaaaabbbb00b00baa00b00aaa00a00b9900a00baa00b00a9900b00a9900a009
-- 064:cdd00ddcdeeddeedde3ee3ed0de33ed00df22fd0de2ff2eddfeeeefdedd00dde
-- 065:000ddc04000ddc3000fdd20000fdd20000fedc300ffedc040efff000e0000e00
-- 066:0eeaabbf0eeaabbd0ffaabbd0eeaabbf0ffaabbf0ffaabbd0ffaabbd0ffaabbd
-- 067:fbbaaee0dbbaaee0dbbaaff0fbbaaee0fbbaaff0dbbaaff0dbbaaff0dbbaaff0
-- 068:0eed00df0eed00dd0ffd00dd0eed00df0ffd00df0ffd00dd0ffd00dd0fffffff
-- 069:fd00dee0dd00dee0dd00dff0fd00dee0fd00dff0dd00dff0dd00dff0fffffff0
-- 071:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 080:f9dddd9ffaccccaf0b0aa0b0000aa0b00b0bb0000b0aa0b0000bb0000b0bb0b0
-- 081:fafeefaffbffffbfedeeeededcffffcd0ceeeec00dffffd00ceeeec00dffffd0
-- 082:0eeaabbf0eeaabbd0ffaabbd0eeaabbd0ffaabbd0ffffffeeededdcceededdcc
-- 083:fbbaaee0dbbaaee0dbbaaff0dbbaaee0dbbaaff0effffff0ccddedeeccddedee
-- 096:0b0aa0b0000aa0000b0bb0b00b0aa000000aa0b00b0bb0b0000bb0000b0aa0b0
-- 097:000ddc00000ddc0000fdd20000fdd20000fedc000ffedc000efff000e0000e00
-- 098:0044440000333300000330000002200000022000000000000002200000022000
-- 112:0b0aa0b0000aa0000b0bb0b00b0aa000000aa0b00b0aa0b0faccccaff9dddd9f
-- 113:0000000000000000000000000022334000223340000000000000000000000000
-- 115:5555555555555555555555555555555555555555555555555555555555555555
-- 117:3333333333333333333333333333333333333333333333333333333333333333
-- 120:fffffffffcdcccccfdcdccccfcdccccdfdcdccccfcccccccfcccccccfccccccc
-- 121:ffffffffcccdcdcfdcccdcdfcdcccdcfdcccdcdfcccccdcfccccccdfcccccdcf
-- 128:c444444c4c4664c444c666444646666446466664443666444336633433333333
-- 136:fdcccdccfcdcdcdcfdcdcdccfdeeeeeefdd8899afdd8899afcccccccfcdddccc
-- 137:ccccdccfcccccdcfccccdcdfeeeeeedfabb55ddfabb55ddfcccccccfdddddddf
-- 152:fceeeeeefcecccccfdfc88d8fdfc99c9fdfddeeefdec99c9fdeeeeeeffffffff
-- 153:eeeeeecfcccccecf8d88cfdf9c99cfdfeeeddfdf9c99cedfeeeeeedfffffffff
-- 197:ffffffffffffffffff111111ff111111ff111111ff111111ff111111ff111111
-- 198:ffffffffffffffff111111ff111111ff111111ff111111ff111111ff111111ff
-- 199:1111111111111111111100001111100011011100110011101100011111000011
-- 200:1111111111111111000000110000001100000011000000110000001110000011
-- 201:6ffffff6fffffff6fffffff6fffffff6fffffff6fffffff6fffffff66ffffff6
-- 202:6ffffff6ffffffffffffffffffffffffffffffffffffffffffffffff6ffffff6
-- 213:ff111111ff111111ff111111ff111111ff111111ff111111ffffffffffffffff
-- 214:111111ff111111ff111111ff111111ff111111ff111111ffffffffffffffffff
-- 215:1100000111000000110000001100000011000000110000001100000011000000
-- 216:1100001111100011011100110011101100011111000011110000011100000011
-- 217:6ffffff66fffffff6fffffff6fffffff6fffffff6fffffff6fffffff66666666
-- 218:66666666ffffffffffffffffffffffffffffffffffffffffffffffff66666666
-- 219:0000000011111111100000011111111111111111100000011111111100000000
-- 220:0000000011111111111111111111111111111111111111111111111100000000
-- 221:0000000011111110100000101111101011111010100110101101101001111110
-- 227:6333333663443436634443366344443662444436622444266242442662222226
-- 228:6666666666366366633333366222222066111100666110066666006666666666
-- 229:6666666666f66f666ffffff66ffffff066ffff00666ff0066666006666666666
-- 230:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 231:ffffffffffffffffffff6666fffff666ff6fff66ff66fff6ff666fffff6666ff
-- 232:ffffffffffffffff666666ff666666ff666666ff666666ff666666fff66666ff
-- 233:66666666fffffff6fffffff6fffffff6fffffff6fffffff6fffffff66ffffff6
-- 234:666666666fffffff6fffffff6fffffff6fffffff6fffffff6fffffff6ffffff6
-- 235:0000000001111111010000010101111101011111010110010101101101111110
-- 236:0000000011111110111111101111111011111110111111101111111001111110
-- 237:0111111011011010100110101111101011111010100000101111111000000000
-- 243:6aaaaaa66abbaba66abbbaa66abbbba669bbbba6699bbb9669b9bb9669999996
-- 244:6000000660ff0f0660fff00660ffff0660ffff06600fff0660f0ff0660000006
-- 245:6666666666633366663cc3066624c30666244306662443066622200666600066
-- 246:6666666666666666666666666666666666666666666666666666666666666666
-- 247:ff66666fff666666ff666666ff666666ff666666ff666666ff666666ff666666
-- 248:ff6666fffff666ff6fff66ff66fff6ff666fffff6666ffff66666fff666666ff
-- 249:6ffffff66fffffff6fffffff6fffffff6fffffff6fffffff6fffffff6ffffff6
-- 250:6ffffff66ffffff66ffffff66ffffff66ffffff66ffffff66ffffff66ffffff6
-- 251:0111111001011010010110100101101001011010010110100101101001111110
-- 252:0111111001111110011111100111111001111110011111100111111001111110
-- </TILES>

-- <SPRITES>
-- 000:0222000002334400003c4c0000444400000dd0000043334000433340000e0e00
-- 001:000000000222000002334400003c4c00004444000043334000433340000e0e00
-- 002:0222000002334400003c4c0000444400000dd000004334000403334000e00e00
-- 003:0222000002334400003c4c0000444400000dd0000043340000043300000e00e0
-- 004:02334400023c4c0020444400000dd000004333400043334000000000000e0e00
-- 005:0000000000000000000440000043340000433400000440000000000000000000
-- 006:0000000000000000000aa00000a99a0000a99a00000aa0000000000000000000
-- 007:00000000000000000004a00000439a0000439a000004a0000000000000000000
-- 008:0000000000000000000dd00000deed0000deed00000dd0000000000000000000
-- 016:00000000000000000000000000000000000000000ddd0cc0ddee3d300deeed30
-- 017:00000000000000000000000000000000000000000ddd0cc0ddeeada00deeeda0
-- 018:0000040400000044000000030000000300000003000000020000002200000302
-- 019:00000b0b000000bb0000000a0000000a0000000a000000090000009900000a09
-- 020:00000000000000000222000002334400003c4c000044440000433340000e0e00
-- 032:00000000000000000000000000000000000000000ddd0cc0ddeefdf00deeedf0
-- 075:0000000000000000000000000000000000c0000000c0000000d0c0000ff0ef00
-- 076:abbccbbafcffffcfcf0000fcf000000f00000000000000000000000000000000
-- 080:0222000002334400003c4c0000444400000dd000004334000403334000e00e00
-- 081:0222000002334400003c4c0000444400000dd0000043340000043300000e00e0
-- 091:fdedef00fd444cf00fccccf00f44ccf000fccf000fccccf00afbbba00faffaf0
-- 107:00f00f0000000000000000000000000000000000000000000000000000000000
-- 108:00000000000000000000000000000000f000000fcf0000fcfcffffcf344cc443
-- 136:04444400044444400330033f0333333f022222ff022ffff0022f0000022f0000
-- 137:000004440000044400000003223400032234f0020ffff0030000000200000002
-- 138:44400bbb444fbbbb3fffaaff3f00aaf02f0099f03f00aaf02f0099992f000999
-- 139:b00bb000bb0bbf00aafaaf00aafaaf0099f99f00aafaaf0099f999999ff99999
-- 140:00000000000000000000000000000000000000000000000000000000f0000000
-- 141:0000000000000000000cc00000cccc0000cccc00000cc0000000000000000000
-- 152:00ff00000000000044444334444443340fffffff000000000000000000000000
-- 153:00000000000000003433332334333323ffffffff000000000000000000000000
-- 154:ff0000ff000000002229299922292999ffffffff000000000000000000000000
-- 155:ff00ffff00000000aaabaabbaaabaabbffffffff000000000000000000000000
-- 156:f000000000000000bbcbcbccbbcbcbccffffffff000000000000000000000000
-- 157:0000000000000000bbccccccbbccccccffffffff000000000000000000000000
-- 158:000000000000000000000000f0000000f0000000000000000000000000000000
-- 162:66eeeeee6effffff6fffccce66cdddde6ccdf000dcdc089bdfccf9aaffdcfbab
-- 163:eeeeee66ffffffe6ecccfff6eddddc66000fdcc6b980cdcdaa9fccfdbabfcdff
-- 164:66eeeeee6effffff6fffccce66cdddde6ccdf000dcdc0feedfccfeddffdcfbab
-- 165:eeeeee66ffffffe6ecccfff6eddddc66000fdcc6eef0cdcdddefccfdbabfcdff
-- 178:ffecfaabd0ecf9aaddde089a6ddd000066dee0006ffffeef6f00f000660f0000
-- 179:baafceffaa9fce0da980eddd0000ddd6000eed66feeffff6000f00f60000f066
-- 180:ffecfaabd0ecf9aaddde089a6ddd000066dee0006ffffeef6f00f000660f0000
-- 181:baafceffaa9fce0da980eddd0000ddd6000eed66feeffff6000f00f60000f066
-- 194:666666666eeeeeee6fffffff66cdddde6ccdf000dcdc089bdfccf9aaffdcfbab
-- 195:66666666eeeeeee6fffffff6eddddc66000fdcc6b980cdcdaa9fccfdbabfcdff
-- 196:66eeeeee6effffff6fffccce66cdddde6ccdf000dcdc0feedfccfeddffdcfbab
-- 197:eeeeee66ffffffe6ecccfff6eddddc66000fdcc6eef0cdcdddefccfdbabfcdff
-- 208:66eeeeee6effffff6fffccce66cdddde6ccdf0006cdc089b6fccf9aa6fdcfbab
-- 210:ffecfaabd0ecf9aaddde089a6ddd000066dee0006f00f0006f0f000066666666
-- 211:baafceffaa9fce0da980eddd0000ddd6000eed66000f00f60000f0f666666666
-- 212:ffecfaabd0ecfeefddde0eff6ddd000066dee0006ffffeef6f00f000660f0000
-- 213:baafcefffeefce0dffe0eddd0000ddd6000eed66feeffff6000f00f60000f066
-- 224:6fecfaab60ecf9aa6dde089a6ddd000066dee0006ffffeef6f00f000660f0000
-- 240:00000002000002240000234400023433000233cc00024c3c00234c3c0024c333
-- 241:000000080000088a000089aa00089a99000899bb0008ab9b0089ab9b008ab999
-- 242:0000000e00000eef0000efff000effff000effff000effff00efffff00efffff
-- 243:0000000003300330333333332222222202222220001111000001100000000000
-- 244:6666666660066006000000000000000060000006660000666660066666666666
-- 245:00043000044dd33004d44d304d4434e34d4334e304d44e30044ee33000043000
-- 246:6660066660066006606006060600006006000060606006066006600666600666
-- </SPRITES>

-- <MAP>
-- 000:10f0f0f0f0f0f0f0f0f0f0f0f0f01010101010101010101010f0f0f0f010102020202020202020202020202020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 001:10f0f0f0f0f0f0f0f0f0f0f0f0f0101010f0f0f0f0f0f01010f0f0f0f010102020202020202020202020202020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 002:10f0f0f0f0f0f0f0f0f0f0f0f0f01010f0f0f0f0f0f0f0f0f0f0f0f0f010102020202020202020202020202020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 003:10f0f010101010101010101010101010f0f0f0f0f010f0f0f0f0f0f0f010102020202020202020202020202020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 004:10f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f010f0f0f0f0f0f0f010102020202020202010101010101020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 005:10f0f0f0f014f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0101010f0f0f0f0f010102020202020202010202020101020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 006:1010101010101010101010101010101010f0f0f0f0f0f010f0f0f0f0f010102020202020202010202020101020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 007:104454f0f0f0f010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f010f0f0f0f0f010102020202020202010202020202020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 008:104454f08797f005f0f0f0f0f0f0f0f0f0f0f0f0f0f0f010f0f0f0f0f010102020202020202010202020202020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 009:102333f08898f006f0f0f0f0f0f0f0f0f0f0f0f0f0f0f010f0f0f0f0f010102020201010202010102020101020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 010:102434f08999f006f0f0f0f0f0f0f0f0f0f0f0f0f0f0f010f0f0f0f0f010102020201010202020202020101020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 011:102535f008f0f007f0f0f0f0f0f0f0f0f014f0f0f0f0f010f0f0f0f0f010102020201010202020202020101020202020201010102020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 012:101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 013:000000000000000000000000000000000000000000000000000000000000f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 014:000000000000000000000000000000000000000000000000000000000000f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 015:000000000000000000000000000000000000000000000000000000000000f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 016:000000000000000000000000000000000000000000000000000000000000f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 017:af6f6faf5c6c5c6caf5c6c5c6caf6f6f6f6faf6f6f6f6faf6f6f6faf6f6faf6f6faff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 018:af7e8eaf5d6d5d6daf5d6d5d6d9fadadadadacadadadad9c6f6f6faf6f6faf6f6faff0c0d0f0f0f0f0f0f0f0f0e0f0c0d0e0f0c0d0e0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 019:af7f8faf5c6c5c6caf5c6c5c6caf6f6f6f6faf6f6f6f6faf6f6f6faf6f6faf6f6faff0c1d1e1c0d0e0f0f0f0f0e1f1c1d1e1f1c1d1e1f1f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 020:af7e8eaf5d6d5d6daf5d6d5d6d9fadadadadacadadadad9c6f6f6faf6f6faf6f6faff0c2d2e2c1d1e1c0d0e0f0c0d0e0f0e2f2c2d2e2f2f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 021:af7f8faf5c6c5c6caf5c6c5c6caf6f6f6f6faf6f6f6f6faf6f6f6faf6f6faf6f6faff0c3d3c0c2d2e2c1d1e1f1c1d1e1f1e3f3c3d3e3f3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 022:af6f6faf5d6d5d6daf5d6d5d6d9fadadadadacadadadad9c6f6f6faf6f6faf6f6faff0c0d0c1c3d3e3c2d2e2f2c2d2e2f2f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 023:af6f6faf5c6c5c6caf5c6c5c6caf6f6f6f6faf6f6f6f6faf6f6f6faf6f6faf6f6faff0c1d1c2d2e2f2c3d3e3f3c3d3e3f3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 024:af6f6faf5d6d5d6daf5d6d5d6d9fadadadadacadadadad9c6f6f6faf7e8eaf6f6faff0c2d2c3d3e3f3f1d0e0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 025:af6f6faf5c6c5c6caf5c6c5c6caf6f6f6f6faf6f6f6f6faf6f6f6faf7f8faf6f6faff0c3d3c0d0c0d0e0f0d0e0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 026:af6f6faf5d6d5d6daf5d6d5d6d9fadadadadacadadadad9c6f6f6faf7e8eaf6f6faff0c0d0c1d1c1d1e1f1d1e1f1f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 027:af6f6faf5c6c5c6caf5c6c5c6caf6f6f6f6faf6f6f6f6faf6f6f6faf7f8faf6f6faff0c1d1c2d2c2d2e2f2d2e2f2c0d0e0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 028:af6f6faf5d6d5d6daf5d6d5d6d9fadadadadacadadadad9c6f6f6fafadadaf6f6faff0c2c0c3d3c3d3e3f3d3e3f3c1d1e1f1f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 029:6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6ef0c3c1d1c1d1e1f1d2e2c2d2c2d2e2f2f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 030:6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6ef0f0c2d2c2d2e2f2d3e3c0d0e0f0e3f3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 031:6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6ef0f0c3d3c3c0d0e0f0f0e0f0d0c0d0e0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 032:6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6ef0f0c2d2e2c1d1e1f1f1e1f1d1c1d1e1f1f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 033:6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6e6ef0f0c3d3e3c2d2e2f2f2e2f2d2c2d2e2f2f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 034:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f07c8c7c8c7c8c7c8cf0f0f0f0f0f0f0f0f0f0c3d3c3d3e3f3f3e3f3d3c3d3e3f3f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 035:cff0bff0f0bff0bff0f0f0f0f0f0f0f0f0f0cf7d8d7d8d7d8d7d8df0f0f0cff0bff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 036:cff0bff0f0bff0bff07c8c7c8c7c8c7c8cf0cf7c8c7c8c7c8c7c8cf0f0f0cff0bff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 037:cff0bff0f0bff0bff07d8d7d8d7d8d7d8df0cf7d8d7d8d7d8d7d8df0f0f0cff0bff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 038:bdbdbff0f0bff0bff07c8c7c8c7c8c7c8cbdcf7c8c7c8c7c8c7c8cbdbdbdbdbdbff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 039:cff0bff0f0bff0bff07d8d7d8d7d8d7d8dbdcf7d8d7d8d7d8d7d8dbdbdbdcff0bff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 040:bdbdbff0f0bff0bff07c8c7c8c7c8c7c8cbdcf7c8c7c8c7c8c7c8cbdbdbdbdbdbff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 041:cff0bff0f0bff0bff07d8d7d8d7d8d7d8df0cf7d8d7d8d7d8d7d8df0f0f0cff0bff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 042:bdbdbff0f0bff0bff07c8c7c8c7c8c7c8cbdcf7c8c7c8c7c8c7c8cbdbdbdbdbdbff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 043:cff0bfbdbddef0bff07d8d7d8d7d8d7d8df0cf7d8d7d8d7d8d7d8df0f0f0cff0bfbdf0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 044:cfbebff0f0f0f0bff07c8c7c8c7c8c7c8cbdcf7c8c7c8c7c8c7c8cf0f0f0cfbebff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 045:cfbfbff0f0f0f0bff07d8d7d8d7d8d7d8df0cf7d8d7d8d7d8d7d8df0f0f0cfbfbff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 046:cfbfbff0f0f0f0bff07c8c7c8c7c8c7c8cbecf7c8c7c8c7c8c7c8cf0f0f0cfbfbff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 047:cfbfbff0f0f0f0bff07d8d7d8d7d8d7d8dbfcf7d8d7d8d7d8d7d8df0f0f0cfbfbff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 048:cfbebff0f0f0f0bff07c8c7c8c7c8c7c8cbfcf7c8c7c8c7c8c7c8cf0f0f0cfbebff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 049:cff0bff0f0f0f0bff07d8d7d8d7d8d7d8dbfcf7d8d7d8d7d8d7d8df0f0f0cff0bff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 050:cff0bff0f0f0f0bff07c8c7c8c7c8c7c8cbfcff0f0f0f0f0f0f0f0f0f0f0cff0bff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 051:303030303030303030303030303030f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 052:303030303030303030303030303030f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 053:303030303030303030303030303030f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 054:30303030303030303030303030f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 055:30303030303030303030303030f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 056:30303030303030303030303030f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 057:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 058:f0404040404040404040f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 059:f0404040404040404040f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 060:f0404040404040404040f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 061:f0404040404040404040f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 062:f0404040404040404040f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 063:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 064:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 065:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 066:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 067:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 068:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 069:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 070:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 071:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 072:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 073:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 074:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 075:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 076:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 077:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 078:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 079:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 080:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 081:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 082:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 083:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 084:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 085:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 086:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 087:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 088:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 089:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 090:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 091:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 092:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 093:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 094:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 095:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 096:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 097:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 098:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 099:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 100:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 101:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 102:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 103:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 104:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 105:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 106:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 107:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 108:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 109:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 110:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 111:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 112:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 113:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 114:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 115:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 116:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 117:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 118:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 119:f0aff0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 120:f0aff0aff0f0aff0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 121:f0aff0aff0f0aff0f0f0aff0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 122:f0aff0aff0f0aff0f0f0aff0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 123:f0aff0aff0f0aff0f0f0aff0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 124:f0aff0aff0f0aff0f0f0aff0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 125:f0aff0aff0f0aff0f0f0aff0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 126:f0aff0aff0f0aff0f0f0aff0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 127:f0aff0aff0f0aff0f0f0aff0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 128:f0aff0aff0f0aff0f0f0aff0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 129:f0aff0aff0f0aff0f0f0aff0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 130:f0aff0aff0f0aff0f0f0aff0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 131:f0aff0aff0f0aff0f0aff0f0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 132:f0aff0aff0f0aff0f0aff0f0f0f0f0f0f0f0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 133:f0afafaff0f0aff0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 134:f0afafaff0f0aff0f0aff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 135:f0aff0aff0f0aff0f0afaff0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- </MAP>

-- <WAVES>
-- 000:38cefdcba99887777666555554444444
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 004:00fffbbbccccceeeebbb6666bbaa9988
-- 005:5555556789abcdeffedcba9876555555
-- 006:aaadddddeaaaaaaa999999aaaaa76667
-- </WAVES>

-- <SFX>
-- 000:0100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001003070000f0f0f
-- 001:010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100147000000000
-- 002:00e720d630b450a3709280719060a04c406c306cd06fd02f90109000a0000000000000000000000000000000000000000000000000000000000000003150000c0c0c
-- 003:e500b500854255f325f405f505f705f715f435f065fda52ad51af51ef50005000500050005000500050005000500050005000500050005000500050040500f0f0f0f
-- 004:f000e020c050909050c720f700f700f700f710e820b74070c039f008f0080000000000000000000000000000000000000000000000000000000000002050000f0f0f
-- 005:b66ab67ab68ca68c96768655863b463b465c469ea6a2b6b4b6e5b6d6d6e70600060006000600060006000600060006000600060006000600060006003000000f0f0f
-- </SFX>

-- <PATTERNS>
-- 000:b55118000000100000000000855118000000000000000000100000666116000000a66116000000100000000000f66114000000666116000000a66116000000100000000000d66114000000666116000000a66116000000d55116000000100000000000666116000000a66116000000100000000000d66114000000666116000000a66116000000100000000000f66114000000666116000000a66116000000d55116000000000000000000100000000000a66116000000100000000000f66114
-- 001:000000000000a55118000000100000000000000000d66114000000100000000000000000000000666116000000100000000000000000000000000000000000666116000000100000000000000000000000000000000000666116000000f66114000000a55118000000100000000000666116000000100000000000a55118000000100000000000666116000000655118000000000000000000100000000000666116000000100000000000666116000000100000000000666116000000100000
-- 002:000000000000000000000000000000000000000000a55118000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b55118000000100000000000855118000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000855118000000100000000000d66114000000100000000000000000000000000000000000000000
-- 003:000000666116000000a66116000000d55116000000100000000000866116000000b66116000000b55118000000000000000000000000000000100000000000866116000000100000000000566116000000b66116000000100000000000d66114000000566116000000b66116100000566116000000100000000000666116000000a66116000000100000000000f66114000000666116000000a66116000000100000000000d66114000000100000000000a66116000000100000000000f66114
-- 004:000000000000000000000000000000666116000000855118000000000000000000100000000000866116000000100000000000866116000000b66116000000555118000000000000000000100000000000000000000000566116000000855118000000000000000000d55116000000000000000000000000000000100000000000000000000000666116000000100000000000000000000000000000000000666116000000100000000000666116000000100000000000666116000000b55118
-- 005:000000000000000000000000000000000000000000f66114000000100000000000a55118000000100000000000f66114000000100000000000855118000000100000000000d66114000000655118000000000000000000000000000000100000000000000000000000d33118000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d66114000000a55118000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:000000666116000000a66116000000100000000000d66114000000666116000000a66116000000100000000000155100000000666116a66116000000000000100000000000155100433110100000a66116000000000000d55116000000100000000000666116a66116000000000000100000d66114000000666116000000100000000000666116000000f66114000000666116000000a66116000000000000100000d66114000000666116000000a66116000000100000000000f66114000000
-- 008:000000a55118000000100000000000666116000000a55118000000100000000000000000000000133100000000f66114000000100000000000000000000000000000000000d66114000000100000000000000000000000000000000000b55118000000100000000000855118000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000666116000000100000000000000000000000000000000000000000000000155100000000
-- 009:000000000000000000855118000000000000000000100000000000000000000000000000000000666116000000100000000000000000433110100000000000666116000000100000000000666116100000000000000000666116100000f66114100000a55118000000100000000000666116100000000000000000000000a66116000000000000100000000000000000000000000000855118000000000000100000000000000000000000000000000000000000666116000000100000433110
-- 010:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d55116000000000000000000000000100000000000000000000000000000000000000000
-- 011:666116000000a66116000000100000000000f66114000000100000000000b66116000000b55118000000000000000000000000000000100000000000866116000000100000000000566116000000b66116000000855118000000100000000000566116000000b66116000000855118000000100000000000666116000000966116000000d66116000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:000000000000133100000000666116000000155100000000866116000000a55118000000100000000000f66114000000100000000000b6611600000054411a000000000000000000000000000000100000000000566116000000100000000000d33118000000100000000000566116000000955118000000100000000000655118000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:000000000000000000000000000000000000855118000000000000000000100000000000866116000000100000000000866116000000855118000000100000000000d66114000000100000000000655118000000100000000000d66114000000d55116000000655118000000100000000000e66114000000855118000000100000000000455118000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555118000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:16610000000016610000000000000012210c188100000000d3310ab3310cb3310c000000000000100000188100000000d66106000000466106000000b2210c000000966106000000100000000000466106000000b3310c000000b5510a00000043310c000000466106000000666108000000666106000000d3310a000000966108000000866106000000966106000000b2210c00000010000000000042210a000000e5510a000000000000000000666106000000144104000000466106000000
-- 016:65510800000000000000000044410a000000e6610400000045510a000000b2210a000000155104000000966106000000b1110c000000d55106000000e55106000000188100000000d66106000000100000000000144104000000866106000000b66106000000866106000000100000000000d2210a10000042210a000000b2210a00000042210a000000188100000000d66106000000b55108000000100000000000e55108000000000000000000100000000000188100000000866106100000
-- 017:42210a000000466106000000455108000000666106000000455108000000e66104000000188100b2210c92210a000000000000000000d33108000000e44108000000d3310a000000b3310cb2210c10000043310c133106000000b55108000000955108000000100000f1110a42210a000000e3310a000000611108000000e6610400000015510400000046610600000042210a000000466106000000d55108000000e66104000000100000000000e66104000000b66106000000199100000000
-- 018:43310c00000000000000000012210c000000d2210a100000b2210c10000066610600000086610600000046610600000010000000000096610600000044410a93310c46610600000010000000000096610600000018810000000085510a00000042210a000000100000000000b2210c000000e6610400000085510800000018810000000043310c00000000000000000000000000000096610600000010000000000061110c000000b66106000000d5510800000000000000000062210c000000
-- 019:b66106000000866106000000b66106d5510ad55108000000000000833108b55108000000144104988100188100d6610600000066610600000010000044410a666106000000b66106000000e66104000000b66106000000488100d66104b66106000000d33106655104000000d22106d22108000000000000655102633108d3310463310ad44104f22108133104655106000000a3310aa33104d44104100000877102100000655102000000e44104622104188102655102466102f5510063310c
-- 020:94410a00000046610600000043310c000000199100d6610600000000000018810000000018810066610696610600000082210c96610600000010000045510896610800000000000000000000000000000063310a000000c2210810000052210a000000a66108666106000000000000e5510465510263310a000000b1110a644106666104000000f55104155100b44106b44104a3310c000000655106000000d55104000000d22104000000e11108144104666104000000f55104d11106677106
-- 021:00000061110c95510800000061110c466106000000000000100000966106466106000000d6610695510a000000000000000000488100100000d66106000000e66104000000100000000000666106000000988100855108d2210a000000000000100000b2210a000000b66106000000666104000000000000000000833108133104e44104100000499102622106633108144104a44106000000f66100000000d2210865510262210a00000052210a100000155104000000d11106622106633108
-- 022:000000000000177100000000000000966106000000000000100000644104f2210a00000042210cd2210a000000000000100000d4410a000000000000000000e2210a00000000000010000000000041110cd44104100000f2210a000000000000000000d66104000000100000f1110ad2210a144104000000d2210451110c100000199100655102a2210c15510263310c000000000000633106d3310600000082210c000000100000000000666106000000133106000000a2210c155102b66106
-- 023:b4410451110ca33104d44104100000611108000000655102000000644104a5510663310a000000f66102f5510063310a000000644106000000d33106000000655102000000d22104000000a66106000000d55106000000188100f55102b44104144106a33104000000d66104000000655102000000d22104000000a44106000000d11106000000d11106622106b5510600000013310a000000666106000000677104000000000000000000644106000000a55106000000a44104d1110661110c
-- 024:000000666106000000f5510000000082210c000000100000000000666106000000677102000000f55100622106633108b44104a66106000000f55100000000688104000000000000000000644106000000d44104000000f7710400000063310cf55102f11106000000666106000000d55104000000d11108100000633104133104666104000000f66104d11106b44104b44104a66106000000d2210600000012210800000000000000000051110aa44106666104000000d11106f55100f55100
-- 025:000000a55106000000466104100000d77104000000000000000000177104133104666104000000f22108133104b66106000000a33108000000d44104100000d3310800000064410200000063310462210462210a11110ca1110c000000f55102b22104144106000000d55102000000677104000000000000000000166104122104655102000000a55104f5510261110c100000644106000000d44104d88104000000000000000000000000633108100000177102000000f55100a55104b66106
-- 026:00000052210a100000d3310600000065510200000062210a00000052210a133104177102000000d11106a33104677106000000a66104000000677106000000d5510410000063310a000000166104133104666102000000a55106000000a55108f55104a5510600000064410a100000a55108000000644102000000644106000000177102000000f55100f55100666106000000a44104000000f66100000000655102000000655102000000144104122104655102000000122106677106b44104
-- 027:b3310451110a100000d2210600000067710400000000000000000065510613310417710212210467710600000085510800000065510600000067710600000081110c100000655102000000644106000000655102000000a44104a55104f55100000000a55106000000d33104d33104166102000000f22104100000f33102955106633106544106644106100000966104a44106b66104000000b44106f55102d66102000000000000a22108844104b55104d55100b22108833104f00102f66100
-- 028:000000a44104000000d44104d33104655102000000655102000000a33104100000666104000000f55100f55100b44104b44104a66106000000d33104d88104000000000000000000000000a33104d66104a55106000000e44104f55102b4410414410412210a000000f66100100000844104000000000000100000b44104f33106155106844106866104000000544106144102644106f3310615510214410682210400000085510486610811110aa44106d66102f2210a133104455106844106
-- 029:000000133108000000455104100000188100000000000000000000d22106133104155104000000a44104a5510415510400000011110a000000f6610011110c655102000000100000000000a4410600000066610400000062210667710611110c000000666106000000155104000000866106000000000000000000833102100000633108000000844102100000166102155104a44102c55102b66104855106555108566106000000e2210ad44100e99100833106d11106155104844106155106
-- 030:000000855108000000655106000000133106000000000000000000a55106000000655102000000d11106100000b55106000000a44104000000d5510600000067710400000000000000000012210a000000177102000000f55100d11106b55106000000a33104100000d22106000000866102000000000000000000a55108000000866102f44106177104744102155106000000f22106100000166102488100d55100100000d44100d66102b55106577106b33106488102866106633108a44104
-- 031:b77106d66106833108555106988100100000a6610800000063310a166104666104000000f66104622106b33108b4410452210a100000f66100000000e66104d66104644102000000677106000000000000000000f5510800000061110a655106855108000000622108000000a55108000000100000000000d33106000000666106000000a44104f55100b22108000000944104a33104d33106000000688104000000000000000000a44104133104122108000000f55100622106f55100000000
-- 032:64410881110c81110a555104666104000000000000d22104f22106644106c33104100000d22106d11106b4410610000052210c100000155104d33104f33106655102100000000000d33108144104a66106000000000000f55102b4410418810084410a000000655106100000d55108000000000000100000b66104100000a55106000000d22106d11106f55100000000a66106000000d44104d3310412210800000000000000000012210a11110a64410a000000f55102d11106b55106000000
-- 033:b44108455104c5510455510214410665510267710600000081110ad33104666106000000f44106a4410462210c100000a66106a33104d33106000000d33106000000100000d22104833108100000188102655102f88104d11106a55108000000f11106a33104d5510200000067710400000000000000000061110a100000177102000000f55100a55104b55104144104644106000000677106000000d66104000000d22104000000166104133104a44106000000a44106f55102a55108000000
-- 034:f22108555102577106844106d77104000000644102000000a66106000000a55106655102499102f5510262210a000000d33108644106655106000000677104000000000000000000d55106622104666104000000b55108000000b55106422108b55108000000d88104000000000000655102644102000000644106000000677102000000f55104677106b5510600000051110c100000f55100000000655102000000644102000000d55106000000655102000000d11106f55100b55104b33104
-- 035:644106000000d33104100000d66104000000655102000000d55108000000a55106000000188102f44104677106000000a4410400000065510a000000d66104000000d22104000000166104000000133104d33104144104f5510062210a100000155104000000f6610000000087710600000000000000000064410600000084410200000011110c000000966102100000855108000000877106000000d66102000000d44100000000855108000000577106844104b33106b22106155102000000
-- 036:a3310400000085510800000000000000000010000000000067710600000063310c000000a33106000000f55100000000b55108000000d44104133104677106000000000000000000d33106000000a55106000000111106a55104b44104b44104655106000000455104d33104166102000000f2210400000061110c100000f55104000000166104622106a66104155104666106155102b33108000000822104000000577106000000144100d55100d55100155106866106000000b44104877106
-- 037:b55108000000144104000000655102000000d2210400000053310a133104177102000000f66104100000b55106000000677106000000d66106000000655102000000100000000000166104000000666106000000f66104f55102655106000000a33104000000d22106000000866102000000000000000000a55108122102877106000000f7710410000011110c000000b7710400000011110a155102d55100000000144100000000155104655106644108000000d44100d4410081110c100000
-- 038:855108000000666106000000677104000000000000000000155104122104655102000000f55100f55100b44104b44104b4410a000000f6610000000012210c11110c644102000000d33104133104655102000000a44104622106f55100000000a66106000000d33104100000844104000000000000000000644108144104133104000000866102000000155102966102166102155102c55102f11106555108000000822104000000666108000000d66102000000d66104d33102844106577106
-- 039:555102000000155106144104933104000000000000000000e4410010000045510800000011110a000000144100000000144104000000d66102d6610294410451110a97710294410a433104100000966102100000f22108655108b3310a000000122108488100f3310266610866610642210ce55100d88106933104a2210a622108b2210a51110a49910096610662210a16610495510411110c85510671110c82210a100000b2210c46610652210a100000f8810062210ab77106955108b66106
-- 040:155104555104633108000000e55100000000000000000000e44102000000e4410000000015510000000011110a000000111108000000633106955104822108b2210c83310a00000083310c00000012210a000000b66104b77104f22108d22108155104488102133106b11108e55100d77106122106b2210c688106f99100155100966104988102b1110a955104f3310a477106e44108433104488100977102199100944102577106955102166104966102888106444104f2210ad55106866108
-- 041:144104c55104d55100544106e66102000000000000000000e77104000000e55102000000e44100866106e44100144100e55100000000b6610693310a52210cb2210a51110ab3310a933102544106488106000000c3310af33108455104f2210a888106000000b1110c93310ad1110884410a166106d33108e33102f1110a15510052210a52210cb2210895510253310a43310445510695510281110ad3310ab22108000000d66106433104977104000000e66106f22108f22108f22108888106
-- 042:666108000000855106000000e11108000000855108000000633106000000633106000000e7710200000011110c62210611110a11110c144104622106944102b1110882210810000047710610000097710400000061110af88100455102000000b33106100000455102544104955104499100b1110cd77104e88104d66104e44104477106b22108488102433106b2210ab66106455108d2210ad33108b2210c96610482210852210a51110c455106000000f66104c3310a85510645510265510a
-- 043:133104d2210a00000097710671110c933104d22108e44108666106955104100000466106d1110a966106966102b4410a43310ad55108555102d77102e44104100000a1110882210ce5510091110af11108b66104000000455104000000b66104000000f22108000000488106b5510a82210a82210c477106d3310885510245510615510683310a11110cd66106566104d3310851110a11110a966104a1110a933104000000b2210ca2210a166102955102d55104c2210883310412210cd55104
-- 044:000000977106455102e88104e55100b7710691110a92210ce55102e1110895510414410652210a444106000000e66106111108d33106133102666106b55104b44104e55100933108e44104a11108d55102611108f22108b3310400000042210c000000866106000000d6610881110ad7710643310ce88106866102144106e66106655102622106b1110c000000966106a11108977106455104e55100000000f2210a000000966104000000e55104000000855104544108d44104f3310a877106
-- 045:000000666102633104a3310a955104855108644108966108133106d77102e66102944106000000b11108b2210cb55108944102955104d55104e66108b1110ae44106d55102d55102f55102d5510283310c666102455102155102f3310895510800000045510200000096610295510295510211110a988106f33104d44104866104d55104644102644102000000d5510455510445510212210c71110cd22108d22108d44108944106000000855108644106d33102d33104d44100000000566106
-- 046:000000655108000000677106d2210a84410ae44100d66106933104f99100155100b22108100000955104000000988106977104133108d33106b88106e33106188100e55104f11108a11108e44100144102444104000000455102000000b44106f22108b66106b66104955104000000955104155102b6610862210c866104d4410482210a53310c944106000000411108d3310a644106644106411108100000e44100000000655106655106f2210a111108c22108855104533106122108855108
-- 047:855102955102844104b1110c10000052210a12210c52210aa2210417710251110a12210ab44104b55106a3310464410600000011110a00000012210800000000000000000052210a12210417710200000052210ab22108f5510253310aa66106000000d6610400000067710400000000000000000012210652210a633108000000f55100144104b4410414410465510800000066610600000065510200000000000010000063310a100000a55106000000d11106677106f55102a44104622108
-- 048:111108d5510654410652210a52210a65510212210a666106000000d33106000000f55100f55100f5510064410aa6610452210a51110a11110ad66104000000644102000000644106000000666102000000177104d33106d2210a133106e1110a100000d3310800000053310a000000000000000000a3310481110ad55104000000f4410611110ab44108000000655106000000d33106000000688104000000000000000000133104d44104655102100000f55102f55102144104b44106633106
-- 049:b1110c844104c22108655102677106d44104000000d2210652210a65510200000015510267710651110aa4410851110ae1110ad33104d44104655102000000d22104000000144104a33108666106d44104b22108133108111108144104666106000000466104455104d66104000000d33104000000133104d1110a17710251110a94410461110af55102f55102a33104a22104f66100100000d66104000000d22104100000144104000000d2210412210471110a000000f55104f66104f66104
-- 050:00000055510692210aa22106000000a77106000000144104133104666106000000f6610452210ad2210811110ae1110a11110a666106000000688104000000000000000000633104100000a44106000000155102f55100b55104b44106a3310452210a12210c81110a655102000000644102000000644106d33106655102000000455104a55104155102144104a6610651110a133104133104122108000000000000000000655106000000666104000000a5510a000000a66108966106a33104
-- 051:000000d66102a2210aa66108000000000000944106a55106e1110a00000000000066610600000011110a52210a52210ad1110a100000d66104000000100000666106a66106000000100000d55106000000100000666106000000a66106000000100000000000d66104000000666106000000a66106000000100000000000f66104000000666106000000a66106000000d55106000000000000000000100000000000a66106000000100000000000f66104000000666106000000a66106000000
-- 052:000000c1110874410462210400000062210400000000000052210ad22104100000f66104100000a6610600000000000051110aa22108100000000000000000000000000000000000000000000000b55108000000000000100000855108000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000666106000000100000000000000000000000000000000000000000000000155100000000000000000000000000000000
-- 053:00000052210a63310a66610600000012210a52210ad1110a000000611104100000611104100000611104100000d22104000000666106100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 054:000000d7710462210652210a12210aa2210610000052210ad2210812210a52210a51110a11110ad22104100000d22106622104a11106100000000000000000000000000000000000666106000000f66104000000a55108000000000000100000666106000000100000000000000000000000000000000000666106000000100000000000000000000000855108000000000000100000d66104000000666106000000100000000000666106000000100000000000000000000000000000000000
-- 055:666106000000f66104000000100000000000a55108000000100000000000f66104000000866106000000b66106000000100000000000d66104000000566106000000b66106000000855108000000000000000000000000000000d55106000000000000000000000000000000100000000000000000000000677106000000100000000000000000000000000000000000666106000000100000000000677106000000100000000000677106000000b55108000000677106000000b55108000000
-- 056:000000000000155100000000866106000000b66106000000b55108000000000000000000000000000000100000000000866106000000555108000000000000000000100000000000566106000000100000000000566106000000b66106100000566106000000100000000000677106000000a77106000000100000000000f77104000000666106000000a77106000000100000000000d77104000000100000000000a77106000000100000000000f77104000000a55108000000177106000000
-- 057:000000000000855108000000000000000000100000000000866106000000100000000000000000000000855108000000000000000000100000000000000000000000655108000000100000000000d66104000000100000000000d44108000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f55108000000144106000000133104000000
-- 058:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d77104000000a66108000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d55108000000866108000000
-- 059:177106100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:1803004416c18829c2c43ec3000000000000000000000000000000000000000000000000000000000000000000000000dd0000
-- 001:010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <FLAGS>
-- 000:1030000000000000000000000000000000000000000000000000000000000000404000000000000000000000000000004000101000000000000000000000000000001010101000000000000000000000c0001010000000000000000000000000c0000000000000000000000000000000c00000c00040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </FLAGS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

