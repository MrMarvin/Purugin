class BouncerPlugin
  include Purugin::Plugin
  description 'Bouncer', 0.2

  class FlightInfo
    INCREMENT = 0.1
    MAX_HEIGHT = 2.0

    attr_accessor :height, :falling

    def initialize
      @height, @falling = 0.0, false
    end

    def higher!
      @height += INCREMENT if @height < MAX_HEIGHT
      @falling = true
      @height
    end
  end

  def on_enable
    players = {}

    event(:entity_damage) do |e| # Done falling: don't take damage
      e.cancelled = true if players[e.entity] && players[e.entity].falling
    end

    event(:player_move) do |e|
      me = e.player
      block = me.world.block_at(e.to).block_at(:down)      
      
      if block.is? :stone # Take off
        (players[me] ||= FlightInfo.new).higher!
        me.velocity = me.location.direction.multiply(0.2).tap do |dir|
          dir.y = players[me].height
        end
        me.fall_distance = 0
      elsif players[me] && players[me].falling
        if !block.is?(:air, :stone)  # not a bouncy thing. stop.
          players.delete(me)
          me.fall_distance = 0
        end
      end
    end
  end
end
