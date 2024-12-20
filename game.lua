--author:  game developer, email, etc.
--desc:    short description
--site:    website link
--license: MIT License (change this to your license of choice)
--version: 0.1
--script:  lua

--Music track 1: MonsterWaill - Still Alive 8bit cover
--Music track 2: MonsterWaill - Reconstructing Science 8bit cover


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

	--newInteractable(name,objtype,xx,yy,rect,scale,functions)

	tiletypes = {
		[64] = {"cube","cube","x","y",{0,0,8,8},1,{"canmove","dogravity","tilecollide","spritecollide","grabbable","moveable"},{"interactablelist","entitylist"}},
		[32] = {"button","largebutton","x","y",{1,6,14,2},1,{"activator"},{"interactablelist","objectlist"}},
		[49] = {"button","smallbutton","x","y",{0,0,8,8},1,{"clickable"},{"interactablelist","objectlist"}},
		[65] = {"turret","x","y",{"turretlist","interactablelist","entitylist"}}
	}
	entitycounts = {
		["button"] = 0,
		["cube"] = 0,
		["turret"] = 0,
		["prop"] = 0,
	}


	tiletypesfuncs = {
		["cube"] = {64, {["true"]=64,["false"]=64}},
		["turret"] = {64, {["true"]=97,["false"]=65}},
		["smallbutton"] = {49, {["true"]=49,["false"]=49}},
		["largebutton"] = {32, {["true"]=32,["false"]=33}},
	}
	orangeportal = newPortal("orangeportal")
	blueportal = newPortal("blueportal")

	UIlist, UIelems, wheatleyface = getUI()
	t=1
	pcollidetime = 6
	portalcooldown = 0
	useCooldown = 0
	loadMap()

	music(1,0,0,true,true)
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
			trace(tile)
			if tiletypes[tile][#tiletypes[tile]][1] == "interactablelist" then --if first entry of types has interactable then assign it to be interactable
				object = newInteractable(loadSprite(tile,x,y))
			end
			if tiletypes[tile][#tiletypes[tile]][1] == "turretlist" then
				object = newTurret(loadSprite(tile,x,y))
			end

			for _,tble in pairs(tiletypes[tile][#tiletypes[tile]]) do
				if tble=="entitylist" then
					--table.insert(mapcontent.entitylist,object[1],object)
					mapcontent.entitylist[object.name] = object
				end
				if tble=="interactablelist" then
					--table.insert(mapcontent.interactablelist,object[1],object)
					mapcontent.interactablelist[object.name] = object
					table.insert(mapcontent.interactablelist,object)
				end
				if tble=="objectlist" then
					--table.insert(mapcontent.objectlist,object[1],object)
					mapcontent.objectlist[object.name] = object
				end
				if tble=="turretlist" then
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
	player.type = "player"
	player.gravity = gravity
	player.dogravity = true
	player.ax = accelx
	player.ay = jump
	player.dx = decelx
	player.maxax = maxaccel
	player.vx = 0
	player.vy = 0
	player.rect = {0,0,8,8}

	player.state = "idle"
	player.draw = true
	player.dotilecollide = true
	player.doportalcollide = true
	player.excludeportal = false
	player.portalcollidelen = 0
	player.isHolding = nil
	player.outline = {false,12}
	player.canmove = true

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
	gun.dotilecollide = true
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
	portal.dotilecollide = true
	portal.rect = {0,0,0,0}

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
	portal.type="portal"
	portal.ignore = true

	portal.outline = {false,12}
	portal.excludeportal = true

	mapcontent.entitylist[portal.name] = portal
	return portal
end

function newTurret(name,xx,yy)
	local entity = {}
	entity.type = "turret"
	entity.name = name
	entity.spval = 65
	entity.splist = {["true"]=97,["false"]=65}
	entity.nodraw = 00
	entity.x = xx
	entity.y = yy
	entity.cangrab = true
	entity.moveable = true


	entity.gravity = gravity
	entity.dogravity = true
	entity.ax = accelx
	entity.ay = jump
	entity.dx = decelx
	entity.maxax = maxaccel
	entity.vx = 0
	entity.vy = 0
	entity.state = false


	entity.firetimer = 0
	entity.scale = 1
	entity.rect = {0,0,8,8}
	entity.draw = true
	entity.flip = false
	entity.rotate = 0
	entity.outline = {false,12}
	entity.grabbable = true
	entity.portalcollidelen = 0
	entity.canmove = true
	entity.dotilecollide = true

	return entity
end

function newBullet(xx,yy,side)
	entity = {}

	entity.type = "bullet"
	entity.name = "bullet"
	entity.spval = 113
	entity.splist = {["true"]=113,["false"]=113}
	entity.nodraw = 00
	entity.x = xx
	entity.y = yy


	entity.gravity = 0
	entity.dogravity = false
	entity.ax = 20
	entity.ay = jump
	entity.dx = 1
	entity.maxax = 5
	
	if side then
		entity.vx = -5
	else
		entity.vx = 5
	end
	entity.vy = 0.1
	

	entity.scale = 1
	entity.rect = {4,2,4,4}
	entity.draw = true
	entity.flip = false
	entity.outline = {false,12}
	entity.grabbable = false
	entity.portalcollidelen = 0
	entity.canmove = true
	entity.dotilecollide = true
	entity.tilecolliding = {false,false,false,false}

	return entity

end

function newInteractable(name,objtype,xx,yy,rect,scale,functions)
	entity = {}

	entity.name = name
	entity.type = objtype
	entity.x = xx
	entity.y = yy
	trace(name)
	trace(objtype)
	trace(tiletypesfuncs[objtype])
	entity.spval = tiletypesfuncs[objtype][1]
	entity.splist = tiletypesfuncs[objtype][2]
	entity.nodraw = 00
	entity.scale = 1
	entity.rotate = 0
	entity.flip = false
	entity.outline = {false,12}
	entity.rect = rect
	entity.state = false
	entity.draw = true
	
	for _,val in pairs(functions) do
		if val=="canmove" then
			entity.canmove = true
			entity.ax = accelx
			entity.ay = jump
			entity.dx = decelx
			entity.maxax = maxaccel
			entity.vx = 0
			entity.vy = 0
			entity.doportalcollide = true
			entity.portalcollidelen = 0
		end
		if val=="dogravity" then
			entity.dogravity = true
			entity.gravity = 0.2
		end
		if val=="tilecollide" then
			entity.dotilecollide = true
			entity.tilecolliding = {true,true,true,true}
		end
		if val=="spritecollide" then
			entity.dospritecollide = true
			entity.spritecolliding = {false,false,false}
		end

		if val=="moveable" then
			entity.moveable = true
		end

		if val=="grabbable" then
			entity.grabbable = true
		elseif val=="clickable" then
			entity.clickable = true
			entity.timer = 0
		elseif val=="activator" then
			entity.activator = true
		end
	end


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
--[[function newInteractable(name,objtype,grabbable,multi,spval,splist,flip,ndraw,xx,yy,scale,rect,clickable,linkname)
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
end]]--


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
	trace(table.concat(sprite.rect))
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
	for x=1,math.ceil(player.hearts) do spr(UIelems.heart, 45+((x-1) *9 ), 111, 00) end
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
	for _,table in pairs(mapcontent) do
		for _,sprite in pairs(table) do
			if sprite.canmove then
				if math.abs(sprite.vy) > 4.5 then
					if sprite.vy < 0 then sprite.vy = -4.5 else sprite.vy = 4.5 end
				end

				sprite.x = sprite.x + sprite.vx
				sprite.y = sprite.y + sprite.vy



				sprite.vx = sprite.vx*sprite.dx
				if math.abs(sprite.vx) < 0.05 then sprite.vx = 0 end
			end
		end
	end
end

function collideTile()
	for _,sp in pairs(mapcontent.entitylist) do
		if sp.dotilecollide then

			sp.tilecolliding = {false,false,false,false}

			floor={nil}
			roof={nil}
			side={nil}
			side2={nil}

			trace(sp.name)
			trace(table.concat(sp.rect))
			local spx,spy,spw,sph = getInteractrect(sp)
			spw = spx+spw
			sph = spy+sph
			floor = {solid(spx, sph+sp.vy), solid(spw, sph+sp.vy)} 
			roof = {solid(spx, sp.y+sp.vy), solid(spw, spy+sp.vy)}

				sideleft = {solid(spx+sp.vx, sp.y+2), solid(spx+sp.vx, sp.y+6)}
				sideright = {solid(spw + sp.vx, sp.y+2), solid(spw + sp.vx, sp.y+6)}

			
			--floor collision
			if floor[1] or floor[2] then
				
				sp.vy = 0
				if (solid(sp.x+2,sp.y+8) and solid(sp.x+6,sp.y+8)) and (sp.y+sp.vy+8) % 8 ~= 0 then
					sp.y = sp.y - (sp.y+sp.vy+8) % 8
				end
				sp.tilecolliding[1] = true
			else --apply gravity
				if sp.dogravity then
					sp.vy = sp.vy+sp.gravity
					sp.tilecolliding[1] = false
				end
				
			end
			--roof collision
			if roof[1] or roof[2] then
				sp.vy = math.abs(sp.vy)
				sp.tilecolliding[2] = true
			else
				sp.tilecolliding[2] = false
			end
			--side collision
			if sideleft[1] or sideleft[2] and sp.vx < 0 then
				sp.vx = 0
				sp.tilecolliding[3] = true
			else
				sp.tilecolliding[3] = false
			end
			if sideright[1] or sideright[2] and sp.vx > 0 then
				sp.vx = 0
				sp.tilecolliding[4] = true
			else
				sp.tilecolliding[4] = false
			end

		
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
						if not spr.tilecolliding[1] then
							spr.tilecolliding[1] = true
						end
						if spr.vy > 0 then
							spr.vy=0
						end
					end
					
				end
				if sides then
					spr.tilecolliding[3] = true
					obj.tilecolliding[3] = true
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
			if obj.draw and obj.canmove and obj.moveable and obj.name ~= spr.name then
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
						spr.tilecolliding[1] = true
						if spr.vy > 0 then
							spr.vy=0
						end
					--end
				end
				if floor and not roof then
					obj.tilecolliding[1] = true
					if spr.vy > 0 then
						spr.vy=0
					end
					if obj.vy > 0 then
						obj.vy=0
					end
				end
				if sides then
					if not obj.tilecolliding[3] then
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

				if (inblock or roof or floor or sides) and obj.type == "bullet" then
					obj.draw = nil
					obj = nil

					if spr.type == "player" then
						player.hearts = player.hearts - 0.25
					end
				end
			end
			
		end
end

function holdobject(sprite)
	object = sprite.isHolding
	local m = gmouse()	
	local angle, l = getAngleDistance(sprite,gmouse())
	

	if not grablength then grablength = l end
	if grablength > 12 then grablength = 12 end
	if sprite.vy == 0 then
		if (math.deg(angle) > 15 and math.deg(angle) < 90) then
			angle = math.rad(25)
		elseif (math.deg(angle) > 90 and math.deg(angle) < 181) then
			angle = math.rad(165)
		end
	end

	local tx = (grablength * math.cos(angle) + sprite.x)
	local ty = (grablength * math.sin(angle) + sprite.y)

	if grablength < 2 or not object.doportalcollide then
		dropobject(sprite)
	end

	local sx,sy,sw,sh = getInteractrect(sprite)

	if solid(sx + sprite.vx,sy+4+sprite.vy) or 
		solid(sx+sprite.vx,ty+4+sprite.vy) or 
		solid(sx+4+sprite.vx,sh) 
		 then --or solid(tx+10+sprite.vx,ty+4+sprite.vy) or solid(tx+4+sprite.vx,ty+7+sprite.vy) then
		grablength = grablength - 1
		tx = (grablength * math.cos(angle) + sprite.x)
		ty = (grablength * math.sin(angle) + sprite.y)
		
		--length = getAngleDistance({x=tx+8+sprite.vx, y=ty+4+sprite.vy},object)
	else
		if grablength < 12 then
			grablength = grablength+1
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

	if maxl > 46 then
		return
	end
	local length = 2
	while length < maxl do
		ax = length * math.cos(angle) + sprite.x+4
		ay = length * math.sin(angle) + sprite.y+4

		pix(ax,ay,2)
		for _,obj in pairs(mapcontent.interactablelist) do
			if obj.grabbable and obj.draw then
				if solid(ax,ay) then
					return
				end

				if spriteoverlap(ax,ay,2,2, obj.x,obj.y,8,8) then
					player.isHolding = obj
					player.isHolding.dogravity = false
					grablength = length
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
		


		if object.type == "bullet" then
			if object.tilecolliding[1] or object.tilecolliding[2] or object.tilecolliding[3] then
				object.draw = nil
				object = nil
			end
		end
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
	if (btn(0) or key(48)) and player.tilecolliding[1] then
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
					local bullet = newBullet(obj.x+4,obj.y,obj.flip)
					table.insert(mapcontent.objectlist,bullet)
					table.insert(mapcontent.entitylist,bullet)
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

		if player.hearts <= 0 then
			gamestate = "exit"
		end
		



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
-- 113:0000000000000000000000000000022400000223000000000000000000000000
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
-- 000:0222000002334400003c4c000044440000044000004333400043334000090900
-- 001:000000000222000002334400003c4c0000444400004333400043334000090900
-- 002:0222000002334400003c4c000044440000044000004334000403334000900900
-- 003:0222000002334400003c4c000044440000044000004334000004330000090090
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
-- 064:00000000000999990009999900099999000999990009999900099999000999ff
-- 065:0000000099999000999990009999900099999000999990009999900099999000
-- 075:0000000000000000000000000000000000c0000000c0000000d0c0000ff0ef00
-- 076:abbccbbafcffffcfcf0000fcf000000f00000000000000000000000000000000
-- 080:00099eff00099eed00099eed00000eed00000eed000000ed000000ed000000ee
-- 081:99999000d9999000d9999000d0000000d0000000d0000000dee00000eee00000
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
-- 009:102333f08898f006f0f0f0f0f0f004f0f0f0f0f0f0f0f010f0f0f0f0f010102020201010202010102020101020202020202020202020202020202010f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
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
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 004:00fffbbbccccceeeebbb6666bbaa9988
-- 005:5555556789abcdeffedcba9876555555
-- 006:aaadddddeaaaaaaa999999aaaaa76667
-- </WAVES>

-- <SFX>
-- 000:020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200387000000000
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
-- 015:944102100000444106433106000000100000b44104c44104c44104100000000000000000444106433106000000100000b44104e55104000000000000100000000000444106444106000000a44104b55104c44104c44104e55104000000000000c44104c44104100000000000b44104c44104944102944106000000955104100000433106000000a44104b44104c44104c44104100000000000000000444106433106100000a33104b44104e55104000000100000000000000000444106433106
-- 016:966104000000100000000000b44104000000100000000000000000955104000000000000100000000000b44104000000100000000000000000955104000000000000100000000000b44104100000000000000000000000000000000000000000000000000000b44104000000100000144104144104855102144102122102444106100000b44104100000000000000000000000955104000000000000100000000000b44104100000000000000000944102944102100000000000000000000000
-- 017:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000166100000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000944104966104000000000000100000000000
-- 018:000000a33104b44104c44104c44104e55104000000000000c44104c44104100000000000b44104c55104100000933102100000933102955104944106100000000000933102933102944104c44106000000100000955104c44106e44106000000100000944102944104100000f44102444104444106b44106c44106000000100000444104c44106100000b33104000000b44102944106c44104100000c55102c33102844106955106000000100000544102544104444108000000100000544102
-- 019:b44104100000000000000000000000000000000000000000000000000000b44104100000000000144104944102944106000000100000933102944102444108000000100000000000444108100000000000955102933102933102955104000000000000000000e44106444104100000444106444104455106000000444106000000444106000000b33102100000b33102100000b33104844106000000100000000000c44102544102544102000000100000944106100000544102100000000000
-- 020:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000955104000000000000100000944104955104000000000000000000944102955102100000000000000000944104944102100000944102100000944102444106100000000000000000444104433104100000444104100000444104b44104100000000000144102b44102c44102100000c55104000000100000544104100000000000000000533102544102100000000000000000
-- 021:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000955102100000000000000000000000955104000000000000100000000000000000000000000000000000155102b44106000000100000000000000000000000000000000000000000000000944106000000100000000000000000000000b55102100000000000000000000000000000000000000000000000000000000000000000000000
-- 022:144102544104544102000000544102c44106e44106000000100000533102144102744102744102100000755104544108100000744102000000744102b44106100000144102944102100000144102144102133104944102100000144102944102944102100000944102944104444108000000100000944102444108944102933102100000933102944104955104000000000000000000e44106444104455106000000000000000000000000444104100000444106c44106944106100000a44102
-- 023:444108533102100000000000000000544102144102144104144102533104e44106744104755104000000744102144104744104755104100000755104744102844104844102100000844102e44106100000744102100000844102844106955106000000100000000000944102955104000000100000955104955104c44106100000000000000000c44106e44106000000100000933102944104100000444104100000433104b44106c44106100000f44102444104444106100000b33104100000
-- 024:544102c44106000000100000000000000000544102544104100000000000544102133104144104655102100000744102744102100000655104100000744104e44106100000000000000000855102844106000000100000000000855102100000955104000000000000944106100000933102100000000000944102955104000000000000000000944102955102000000100000000000933102444106100000000000000000433104444104444106100000000000433104b33102b44102100000
-- 025:000000133102000000000000000000000000000000000000000000000000000000544108000000100000000000000000b44106000000100000000000000000833102100000000000000000000000844102833104100000000000000000000000000000000000000000155102944102100000000000000000000000144104000000000000000000000000000000000000000000000000000000b44106100000000000000000000000000000000000000000000000000000b44104100000000000
-- 026:b44102944106c33102144104b55102c55102844106955106100000e44100533102144102444108100000544102000000533102144102544102100000544102c44106544104544102544102000000144102733102744104755102100000544108100000744102000000000000744104e44106100000144102000000144102833102144102144102944102100000955104000000955104944106000000944102955102933102000000944104c44106100000955104000000c44106944102955102
-- 027:b44104b33104c44104c55102100000000000c44102544102544104100000533104944106100000544102100000000000444108100000000000000000000000544102533102144102000000000000e44106100000733102755104000000744102744102755104100000000000b44106100000144102844102000000e44106833104844102844102100000844106933102933102933102844104944104444108100000000000000000444108955102955102933102000000944104e44108100000
-- 028:000000b44102844106100000000000000000000000000000544102100000000000544102544102100000000000000000133102c44106100000000000000000000000e4410610000000000000000054410254410810000015510264410210000074410410000014410400000073310284410284410210000000000085510284410610000000000000000084410294410810000000000000000094410244410a10000000000000000044410a100000000000000000000000144104955104000000
-- 029:000000000000133106000000000000000000000000000000000000000000000000000000000000000000000000000000544104544102100000000000000000000000133102000000000000000000000000744104100000000000000000000000b44106100000000000000000000000144102000000000000000000000000133102000000000000000000000000144102000000000000000000000000955104000000000000000000944102955104000000100000000000944102e44106100000
-- 030:955102844104944104100000444104433104b44106000000c44106100000444104c44106000000944108100000a44102c44102100000844108c55102c55102b44104c44104100000544102544102944106000000100000544102544102000000544102533102544102544102633104100000e44106100000544102644102100000544108100000755102544108000000b44108100000755104555102744102855102833102144102e44106000000844106833102144102144102000000944102
-- 031:000000e44106000000b44106100000000000000000433104c44108100000000000000000444104b33102b44102b44104944106000000c33104100000144102844108000000544102100000000000000000544104133104000000555104000000000000c44106100000000000c44106000000533102544102100000e4410600000074410275510475510454410a000000744102755102744102b44106000000e44108100000844102e44108000000855102133104844102944104100000955104
-- 032:000000e44108000000444104455106000000000000000000000000444104100000000000000000b44104100000000000944108000000c44102100000000000000000844106944108100000000000000000533102444108100000000000444108000000100000000000000000000000544102e44108100000000000e44108000000744104744102100000144102744102144102755104100000644104100000e44106100000000000855102000000144102144102000000844106000000944108
-- 033:000000000000944102444106100000000000000000000000433104455106000000000000000000944106100000000000000000b44102844106100000000000000000c3310294410610000000000000000000000055510210000000000000000000000053310410000000000000000000000054410410000000000000000054410254410a100000000000000000744104b44106100000000000b44108000000100000833104100000000000000000144104833104100000855102000000100000
-- 034:955102955102844104944104444108100000000000844104944104c44106100000944102100000944102955104000000955104e44106000000b44106100000444106444104000000c44108100000444104444106000000944108100000b44102944108000000c33102144104c55102844106944106000000100000544102144102000000444108100000544102133104000000c44106100000544102133104e44108000000533102544102144102744102000000744104755102544108b44106
-- 035:000000000000944106000000944102955102000000444108000000944102955104000000c44106000000944102944102944102e44108000000444104444106444104455106000000000000444104444106c44106000000944106100000b44104944106000000c33104c55102100000b44102c44102544102544102100000944106000000100000544102100000444108000000544104544102100000c44106000000544102533104100000e4410654410a00000010000075510454410ab44108
-- 036:00000000000094410200000095510400000000000044410a000000100000944102100000844104100000e44108100000000000855102144102444106444104100000144104000000c44106100000000000444104000000b33102b33104100000a44102133102844108100000000000c3310400000010000000000000000054410210000044410a10000000000044410a000000533102100000000000555102000000e44106100000000000e44108000000744104733102100000744102000000
-- 037:00000000000000000000000044410a100000000000000000944102944104100000000000855102100000e44106100000000000944104000000100000144102000000b44106000000433104444106100000000000000000b44104b44102100000b33104000000844106100000000000000000633104100000000000000000000000000000533102100000000000544102100000c44108100000000000555104000000000000144102000000544102544108000000100000000000000000644104
-- 038:000000000000755104b44106e44108000000100000833102e44106000000855102144102844102144104944102000000100000444108000000000000444104100000c55108000000944106000000933106100000c44104000000e44104100000e44106e44102b44104000000100000444108000000000000100000000000c55108000000955102000000100000c44106c44106100000833104100000c44106844104955108000000000000100000944102b55106000000000000c44106444104
-- 039:000000000000744102744102e44106000000100000144102e44108000000100000844102144102844106955108000000000000100000944104000000100000000000c44106c33106000000c44102100000444108000000000000100000000000e55108000000955108000000000000100000b44104b44106000000000000c44106c44102944104000000100000c55108000000855102833102100000c55108000000944106000000100000444108000000000000100000000000c55108000000
-- 040:744102755102100000144104644102844102144102844104100000944102100000000000833104733102100000944106100000000000944102444106000000100000000000444106955108000000000000100000c44102b44106000000000000100000e44104100000b44102100000000000b44102100000c33102100000000000c44104e55106000000000000100000944104733104100000000000000000844102944102000000100000000000944104000000100000000000000000444106
-- 041:000000144104000000b44108000000100000844102100000855102844106000000100000000000844104100000000000000000000000000000b44106000000000000100000444104c44104000000100000000000000000000000e44102100000000000144102944106000000933106100000000000000000c44104100000000000000000e44108000000000000100000944102b55106000000000000100000c33106000000100000000000000000000000444104000000100000000000c33106
-- 042:c44104000000100000444108000000000000100000000000e44106e4410254410600000010000044410a000000b44106000000000000c55106000000000000e44102100000c44106e44102b44108000000100000c44106c33106000000100000000000000000000000000000000000000000000000944104944104000000100000000000000000000000000000000000000000944104933108000000100000000000000000000000000000000000000000000000000000000000000000000000
-- 043:944106000000944106100000c44104e44104000000100000e55108000000955108000000000000100000544104b44104000000100000000000b44104e44104000000100000c55108000000844104000000100000c55108000000944108000000100000000000000000000000000000000000000000955108000000000000100000000000000000000000000000000000000000944106933106000000100000000000000000000000000000000000000000000000000000000000000000000000
-- 044:955108000000000000100000c44102b44106000000000000100000e44104100000533104100000455108000000a44102b33102100000000000b33102e44108000000000000100000e44104844102000000100000000000844102944102000000100000000000000000000000000000000000000000944102944102000000100000000000000000000000000000000000000000944102944102000000100000000000000000000000000000000000000000000000000000000000000000000000
-- 045:000000c44102100000000000000000000000e44102100000000000000000944106000000933106100000544106000000100000000000000000000000e44106000000000000100000c33106b44106000000000000100000000000944106000000100000000000000000000000000000000000000000000000144104000000000000000000000000000000000000000000000000000000133104000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 046:000000000000000000000000000000144104000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 047:000000000000000000000000000000144106000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 048:000000000000000000000000000000144106000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- 001:054210315595716996b17d97f181a83295a972a9aab2bdab0000000000000000000000000000000000000000000000002e0000
-- </TRACKS>

-- <FLAGS>
-- 000:1030000000000000000000000000000000000000000000000000000000000000404000000000000000000000000000004000101000000000000000000000000000001010101000000000000000000000c0001010000000000000000000000000c0000000000000000000000000000000c00000c00040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </FLAGS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

