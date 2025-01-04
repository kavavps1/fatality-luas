--Hide Head
--By Kava LUA GOD dc: ufohook
local hide_head_cb = gui.checkbox(gui.control_id('hide_head'))
local row = gui.make_control('Hide head', hide_head_cb)
local group = gui.ctx:find('lua>elements a')
group:add(row);

local function on_present_queue()
    if hide_head_cb:get_value():get() then
        local local_player = entities.get_local_pawn()
        local on_ground = bit.band(local_player.m_fFlags:get(), bit.lshift(1, 0))
        local wep = local_player:get_active_weapon();
        if wep == null then return end
        local type = wep:get_type();
        if type ~= 0 then return end
        if on_ground == 0 then
            game.engine:client_cmd("switchhands")
        end
    end      
end

events.present_queue:add(on_present_queue);
