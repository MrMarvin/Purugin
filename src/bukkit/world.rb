require 'java'

module org::bukkit::World
  # Get the block at the given coordinates
  # === Parameters
  # * x,y,z - Give three coord. location
  # * location - Provide a location object
  # === Example
  # e.player.world.block_at(20, 20, 20) #=> Block instance
  # e.player.world.block_at(Location.new(20, 20, 20)) #=> ditto
  #
  def block_at(*r)
    getBlockAt *r
  end
  
  # Spawn a creature ("chicken", "creeper") at a specified location.
  # === Parameters
  # * mob_name is the creature to spawn (@see CreatureType)
  # * location is where to put the spawned creature [note: to_loc coercion possible]
  #
  def spawn_mob(creature_name, location)
    creature_type = org.bukkit.entity.CreatureType.from_name(creature_name.to_s.capitalize)
    
    raise TypeError.new "unknown mob type #{creature_name}" unless creature_type
    
    location = location.respond_to?(:to_loc) ? location.to_loc : location
    spawnCreature location, creature_type
  end
  
  # Is the world experiencing a storm currently
  def storming?
    has_storm
  end
  
  # Is this world the type you think it is?
  # === Parameters
  # * environment_name is a str or symbol mapping to world you are checking against.
  # === Example
  # me.world.is? :nether
  # === Notes
  # Consider also using the direct env methods if you know for sure that a world environment
  # exists on your server:
  # me.world.nether?
  def is?(environment_name)
    environment_name.to_s.upcase == environment.name
  end

  # Define one method for each environment (e.g. nether?, normal? skylands?)
  org.bukkit.World::Environment.values.each do |environment|
    define_method(environment.name.downcase + "?") do
      self.environment == environment
    end
  end
end
