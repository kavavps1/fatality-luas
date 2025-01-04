--UFOHOOK Trashtalk
--by Kava LUA GOD | discord: ufohook
local trashtalk = gui.checkbox(gui.control_id('trashtalk'));
local row = gui.make_control('[UFOHOOK] Trashtalk', trashtalk);
local group = gui.ctx:find('lua>elements b');
group:add(row);
local trashtalk_cowboy = gui.checkbox(gui.control_id('trashtalk_cowboy'));
local row = gui.make_control('[UFOHOOK] Trashtalk - Cowboy', trashtalk_cowboy);
local group = gui.ctx:find('lua>elements b');
group:add(row);
local trashtalk_ufohook = gui.checkbox(gui.control_id('trashtalk_ufohook'));
local row = gui.make_control('[UFOHOOK] Trashtalk - Basic', trashtalk_ufohook);
local group = gui.ctx:find('lua>elements b');
group:add(row)
group:reset()


local cowboy_phrases = {
    "Yeehaw! That's how cowboys ride!",
    "Saddle up, it's time for adventure!",
    "Boots on, let's hit the open range!",
    "Grit and glory, that's the cowboy way!",
    "Ride hard, live free — just like a cowboy!",
    "Lasso the dreams, cowboys never quit!",
    "From dusk till dawn, the cowboy rides on!",
    "A cowboy's heart is wild and untamed!",
    "When the sun sets, we ride into the night!",
    "Keep your hat on faggot, it's a cowboy's world!",
    "Taste the dust of my quickdraw nn!",
    "A lone cowboy meets his fate in one unlucky chamber.",
    "Horses > newgens from tiktok",
    "Get owned by texashook! Yeeehaw!",
    "Get out of my ranch u dipshit",
    "We always protect our home... My ranch - My rules!"
}

local ufohook_phrases = {
    "ask jey jey",
    "owned by interek",
    "are u old? 16...",
    "me 34",
    "look what's under the desk... daddy's cock! ^.^",
    "haram bruda $$",
    "uff 1tab d0g",
    "1 on my screen",
    "She say, Do you love me? I tell her, Only partly",
    "Killed by the AFK XDD",
    "Killed by clean XDD",
    "lmao und kekw rofl",
    "benchpressed XD",
    "neverlose.cc/refund.php",
    "clapped",
    "yalla habibi",
    "flip-flop FL6"
}

    
events.event:add(function(event)
    if trashtalk:get_value():get() then
        if (event:get_name() == "player_death") then 
            if event:get_pawn_from_id("attacker") == entities.get_local_pawn() then
                if trashtalk_cowboy:get_value():get() or trashtalk_ufohook:get_value():get() then
                    local phrase
                    if trashtalk_cowboy:get_value():get() and trashtalk_ufohook:get_value():get() then
                        local choice = math.random(1, 2)
                        if choice == 1 then
                            phrase = cowboy_phrases[math.random(1, #cowboy_phrases)]
                        else
                            phrase = ufohook_phrases[math.random(1, #ufohook_phrases)]
                        end
                    elseif trashtalk_cowboy:get_value():get() then
                        phrase = cowboy_phrases[math.random(1, #cowboy_phrases)]
                    elseif trashtalk_ufohook:get_value():get() then
                        phrase = ufohook_phrases[math.random(1, #ufohook_phrases)]
                    end
                
                    if phrase then
                        game.engine:client_cmd("say " .. phrase)
                    end
                end
            end            
        end
    end
end)

mods.events:add_listener("player_death")