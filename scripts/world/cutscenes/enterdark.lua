return {

    main = function(cutscene)
        local kris = cutscene:getCharacter(Game.party[1].id)
        local susie = cutscene:getCharacter(Game.party[2].id)

        cutscene:detachCamera()
        cutscene:detachFollowers()

        cutscene:slideTo(kris, 620 - 30, 280, 0.25)
        cutscene:slideTo(susie, 620 + 30, 280, 0.25)
        cutscene:panTo(620, 245, 0.25)
        cutscene:wait(0.25)

        kris.visible = false
        if susie then
            susie.visible = false
        end

        local kris_x, kris_y = kris:localToScreenPos(0, 0)
        if susie then
            local susie_x, susie_y = susie:localToScreenPos(0, 0)
        end

        local krisonly = true

        if susie then
            krisonly = false
        end

        local transition       = DarkTransition(280, { skiprunback = false, kris_only = krisonly })
        transition.layer       = 99999
        transition.quick_mode  = false

        transition.kris_x      = kris_x / 2
        transition.kris_y      = kris_y / 2
        if susie then
            transition.susie_x = susie_x / 2
            transition.susie_y = susie_y / 2
        end

        Game.world:addChild(transition)

        local waiting = true
        transition.end_callback = function()
            Game:addPartyMember("ralsei")

            waiting = false
        end

        transition.loading_callback = function()
            cutscene:loadMap("lighttrans")
            Game.world.map:getEvent("dwexit"):remove()
            Game.world.music:stop()
            Kristal.hideBorder(0)

            local susie = cutscene:getCharacter(Game.party[2].id)
            Game.world.player.visible = false
            if susie then
                susie.visible = false
            end
        end

        local wait_func = function() return not waiting end
        cutscene:wait(wait_func)

        local kx, ky = transition.kris_sprite:localToScreenPos(transition.kris_width / 2, 0)
         Hardcoded offsets for now...
        Game.world.player:setScreenPos(kx - 2, transition.final_y - 2)
        Game.world.player.visible = true
        Game.world.player:setFacing("down")

        if not transition.kris_only and Game.world.followers[1] then
            local sx, sy = transition.susie_sprite:localToScreenPos(transition.susie_width / 2, 0)
            Game.world.followers[1]:setScreenPos(sx + 6, transition.final_y - 6)
            Game.world.followers[1].visible = true
            Game.world.followers[1]:interpolateHistory()
            Game.world.followers[1]:setFacing("down")
        end

    [[
        local flag = Game:getFlag("hasViewedRibbitDarkWorld", default)

        if flag == false or flag == default then
            cutscene:wait(1)

            cutscene:setSpeaker(susie)
            cutscene:showNametag("Susie")
            cutscene:text("* Well,[wait:3] that's that.", "nervous_side")
            cutscene:text("* Hey, didn't know you guys had a castle town here too.", "closed_grin")
            cutscene:text("* Maybe I can find a way home from here.", "smile")
            cutscene:hideNametag()

            Game:setFlag("hasViewedRibbitDarkWorld", true)

            cutscene:endCutscene()
        end
    ]]

        cutscene:attachCamera()
        cutscene:attachFollowers()
        Game.world.followers[1]:setFacing("down")
        Kristal.showBorder(1)

        Gamestate.switch(Kristal.States["DarkTransition"], "map", {
            kris_x  = kris_x/2,
            kris_y  = kris_y/2,
            susie_x = susie_x/2,
            susie_y = susie_y/2
        })
    end,

}
