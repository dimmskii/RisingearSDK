--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

-- Widgets
local display = fgui.getDisplay()

local container_scores = nil
local scores_table = nil

-- Fonts and styles
local scoresFont = nil
local nameColor = color.YELLOW
local plainColor = color.WHITE
local chatFont = nil
local nameStyle = nil
local plainStyle = nil

-- Logic
local clients = {}
local function updateClientList()
	local getClients = net.getClients()
	clients = {}
	for k,v in pairs(getClients) do
		table.insert(clients,v)
	end
	-- TODO: sorting and such of clients here below this comment
end

local function loadFontsAndStyles()
	scoresFont = fgui_fonts.fromAWT("Arial",fgui_fonts.AWT_STYLE_BOLD,14)
	nameStyle = fgui.newTextStyle(scoresFont, nameColor)
	plainStyle = fgui.newTextStyle(scoresFont, plainColor)
end

gui_scores = {}

gui_scores.initialize = function()
	if not ( gui_utils.widgetExists(container_scores) ) then
		loadFontsAndStyles() -- TODO should loadFontsAndStyles be called every time on chat window creation?
		container_scores = fgui.createContainer()
		container_scores:setLayoutManager(fgui.newRowLayout(false))
		container_scores:setSize(480,480)
		container_scores:setMinSize(480,480)
		container_scores:setMaxSize(480,480)
		
		local table_container = fgui.createTableContainer(container_scores)
		scores_table = table_container:getTable()
		scores_table:setModel(fgui.newTableModel({
			getColumnHeader = function(iCol, labelAppearance)
				if iCol == 0 then
					return "Name" -- TODO Stringadactyl
				elseif iCol == 1 then
					return "Score" -- TODO Stringadactyl
				else
					return "Ping" -- TODO Stringadactyl
				end
			end,
			getColumnCount = function()
				return 3
			end,
			getRowCount = function()
				return table.getn(clients)
			end,
			getItem = function(iCol, iRow, labelAppearance)
				local item
				if iCol == 0 then
					item = fgui.newItem(labelAppearance, clients[iRow+1].name)
				elseif iCol == 1 then
					item = fgui.newItem(labelAppearance, 0) -- TODO: scoring?
				else
					item = fgui.newItem(labelAppearance, clients[iRow+1].ping)
				end
				item:setData(ent)
				return item
			end
		
		}))
		scores_table:setColumnWidthPercent(0, 50)
		scores_table:setColumnWidthPercent(1, 25)
		scores_table:setColumnWidthPercent(2, 25)
		scores_table:updateFromModel()
		
		container_scores:layout()
		gui_scores.hide()
		
		return true
	end
	
	return false
end

gui_scores.destroy = function()
	container_scores = nil
end

gui_scores.show = function( msgMode )
	gui_scores.update()
	-- Move container to middle of screen
	container_scores:setXY(display:getWidth()/ 2 - container_scores:getWidth()/2, display:getHeight()/ 2 - container_scores:getHeight()/2)
	
	-- Set visible true
	container_scores:setClickable(false) -- Scores don't interfere with game
	container_scores:setVisible(true)
end

gui_scores.hide = function()
	container_scores:setClickable(false)
	container_scores:setVisible(false)
end

gui_scores.update = function()
	if not container_scores:isVisible() then return end
	updateClientList()
	
	scores_table:updateFromModel()
	
	-- Set selection to local client if there
	for k,v in ipairs(clients) do
		if v.id==localClient().id then
			scores_table:setSelected(k-1,true)
			break;
		end
	end
	
	container_scores:layout()
end
timer.create(0.5,-1,gui_scores.update,true,true)
--hook.add("update", "gui_scores_update", gui_scores.update)