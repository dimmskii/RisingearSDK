--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


skeleton_factory = {}
local skel_list = {}

skeleton_factory.define = function(name, func)
	skel_list[name] = func
end

skeleton_factory.create = function(name)
	return skel_list[name]()
end


skeleton_anims = {}
local anim_list = {}

skeleton_anims.add = function(name, skelAnim)
	anim_list[name] = skelAnim
	return skelAnim
end

skeleton_anims.get = function(name)
	return anim_list[name]
end

include("defaults.lua")