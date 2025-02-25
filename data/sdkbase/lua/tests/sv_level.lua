--floor
local floor = ents.create("phys_polywall", false)
local poly = geom.polygon(geom.vec2(-25,4),geom.vec2(-23,4),geom.vec2(-22,6),geom.vec2(22,6),geom.vec2(23,4),geom.vec2(25,4),geom.vec2(25,8),geom.vec2(-25,8))
floor.polygon = poly
floor.texture = "city/brick01.png"
ents.initialize(floor)


--backgrounds
local bg1 = ents.create("background", false)
bg1.texture = "common/white.png"
bg1.width = 100
bg1.height = 100
bg1.textureWidth = 100
bg1.textureHeight = 100
bg1.color = color.fromRGBf(0.3, 0.3, 1)
bg1.tileX = true
bg1.tileY = true
ents.initialize(bg1)

local bgClouds1 = ents.create("background", false)
bgClouds1.texture = "nature/clouds1.png"
bgClouds1.width = 100
bgClouds1.height = 100
bgClouds1.textureWidth = 30
bgClouds1.textureHeight = 30
bgClouds1.color = color.fromRGBAf(1, 1, 1, 0.5)
bgClouds1.distance = geom.vec2(0.9, 0.9)
bgClouds1.conveyor = geom.vec2(0.08, 0)
bgClouds1.tileX = true
bgClouds1.tileY = true
ents.initialize(bgClouds1)

local bgClouds2 = ents.create("background", false)
bgClouds2.texture = "nature/clouds1.png"
bgClouds2.width = 100
bgClouds2.height = 100
bgClouds2.textureWidth = 40
bgClouds2.textureHeight = 40
bgClouds2.color = color.fromRGBAf(1, 1, 1, 0.4)
bgClouds2.distance = geom.vec2(0.4, 0.4)
bgClouds2.conveyor = geom.vec2(0.35, 0)
bgClouds2.tileX = true
bgClouds2.tileY = true
ents.initialize(bgClouds2)

local fgClouds1 = ents.create("background", false)
fgClouds1.texture = "nature/clouds1.png"
fgClouds1.width = 100
fgClouds1.height = 100
fgClouds1.textureWidth = 65
fgClouds1.textureHeight = 65
fgClouds1.color = color.fromRGBAf(1, 1, 1, 0.2)
fgClouds1.distance = geom.vec2(0, 0)
fgClouds1.conveyor = geom.vec2(1.2, 0)
fgClouds1.foreground = true
fgClouds1.tileX = true
fgClouds1.tileY = true
ents.initialize(fgClouds1)

local playerStart1 = ents.create("info_player_start", false)
playerStart1.position = geom.vec2(-1,0)
ents.initialize(playerStart1)