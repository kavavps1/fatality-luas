--UFOHOOK Nospread Counter
--By Kava LUA GOD | dc: ufohook
local w, h = game.engine:get_screen_size()

local ufonscounter = gui.checkbox(gui.control_id('ufonscounter'))
local row = gui.make_control('[UFOHOOK] NoSpread Counter', ufonscounter)
local group = gui.ctx:find('lua>elements a')
group:add(row)
local ufonscounterreset = gui.checkbox(gui.control_id('ufonscounterreset'))
local row2 = gui.make_control('[UFOHOOK] Reset Counter', ufonscounterreset)
group:add(row2)
group:reset()

local nospread_attackers = {}

events.event:add(function(event)
    if ufonscounter:get_value():get() then
        local local_player = entities.get_local_pawn()
        if local_player == null then return end
        local nospreader = event:get_bool("attackerinair")
        local attacker_pawn = event:get_pawn_from_id("attacker")

        if not attacker_pawn then
            return  
        end

        local attacker_name = attacker_pawn:get_name()

        if nospreader == true then
            if nospread_attackers[attacker_name] then
                nospread_attackers[attacker_name] = nospread_attackers[attacker_name] + 1
            else
                nospread_attackers[attacker_name] = 1
            end
        end
    end
end)

mods.events:add_listener("player_death")

local function on_present_queue()
    if ufonscounter:get_value():get() then
        local local_player = entities.get_local_pawn()
        if local_player == null then nospread_attackers = {} return end
        local local_player_name = local_player:get_name()
        local d = draw.surface
        d.font = draw.fonts['gui_main']

        local x_position = w * 0.05 
        local y_position = h * 0.70 

        d:add_text(draw.vec2(x_position, y_position), '[UFOHOOK] Nospread Counter', draw.color.white())

        local y_offset = y_position + 20 
        for name, count in pairs(nospread_attackers) do
            local color

            if count >= 10 then
                color = draw.color(255, 0, 0, 255)    
            elseif count >= 8 then
                color = draw.color(255, 128, 0, 255)    
            elseif count >= 6 then
                color = draw.color(255, 255, 0, 255)    
            elseif count >= 4 then
                color = draw.color(128, 255, 0, 255)    
            elseif count >= 2 then
                color = draw.color(0, 255, 128, 255)     
            else
                color = draw.color(255, 255, 255, 255)  
            end

            local display_text = name .. " (" .. count .. ")"

            if name == local_player_name then
                display_text = display_text .. " (You)"
            end
            
            if count >= 10 then
                display_text = display_text .. " [X]"
            end

            d:add_text(draw.vec2(x_position, y_offset), display_text, color)
            y_offset = y_offset + 20  
        end
    end

    if ufonscounterreset:get_value():get() then
        nospread_attackers = {}
        ufonscounterreset:set_value(false)
    end
end

events.present_queue:add(on_present_queue)
