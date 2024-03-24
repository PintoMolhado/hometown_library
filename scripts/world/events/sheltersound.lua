local ShelterSound, super = Class(Event)

function ShelterSound:init(data)
    super:init(self, data)

end

function ShelterSound:update()
    local player = Game.world.player
    local event = self
    local distance = Utils.dist(player.x, player.y, event.x, event.y)
    local volume = Utils.clampMap(distance, 400, 750, 1, 0)
    self.sound:setVolume(volume)
end

function ShelterSound:onAddToStage()
    self.sound = Assets.playSound("smile", 0, 0.15)
    self.sound:setLooping(true)
end

function ShelterSound:onRemoveFromStage()
    Assets.stopSound("smile")
end

return ShelterSound