# CSE 413 16au Assignment 6 Part 1
# Jiashuo Zhang 1365330
# 11/13/2016

# Provides game.rb
require_relative "game.rb"

# MONSTER: FriendlyMonster
# A Monster that does not attack
class FriendlyMonster < Monster
	def attack(other)
		puts "I'm friendly and I don't attack you."
	end

	def print_portrait()
		puts "        _     _"       
		puts "       (o\\---/o)"
		puts "        < . . >"
		puts "       _( (x) )_"
		puts "      / /     \\ \\ "
		puts "     / /       \\ \\ "
		puts "     \\_)       (_/ "
		puts "       \\   _   / 	 "
		puts "       _)  |  (_   "
		puts "      (___,'.___)  "
	end
end

# ITEM: Lantern
# User can 'use' lantern to turn it on and off
class Lantern < Item
	attr_reader :lit
	def initialize(name, brief_text)
		super(name, brief_text, "A small lantern is sitting on the ground",  "The lantern is currently turned OFF!")
		@lit = false;
	end
	
	def use(args = [])
		# Toggle the lantern
		@lit = (not @lit)
		# lantern on
		if @lit
			@detail_text = "The lantern is currently turned ON!"
			Game.pretty_print "You turned the lantern ON!"
		# lantern off
		else
			@detail_text = "The lantern is currently turned OFF!"
			Game.pretty_print "You turned the lantern OFF!"
		end
	end
end

# LOCATION: DarkLocation
# Only shows the real description when player has a lit lantern in inventory
class DarkLocation < Location
	def initialize(name, desc)
		super(name, desc)
	end

	def pretty_print
		things = []
        paragraphs = [@desc]
        @things.each do |key, thing|
            if (not things.include? thing)
                paragraphs += [thing.describe(:world)]
                things += [thing]
            end
        end
        # Loop through to see if there's a lit lantern
		Game.player.inventory.each do |item|
			if item.is_a? Lantern
				# Found
				if item.lit
					Game.pretty_print(paragraphs, @name)
					return self
				# Not Found
				else
					Game.pretty_print(["It's too dark to see anything! You need to turn on a lantern."], @name)
					return self
				end
			end
		end
	end
end

# Make a friendly monster
friendMonster = FriendlyMonster.new("GM", "GM, a very friendly monster that does not attack people, is standing on the ground.", { "hp" => 10})

# Make a lantern
lantern = Lantern.new("lantern", "lantern")

# Make two locations
dark = DarkLocation.new("DarkLocation", "This is the Odegaard undergraduation library")
redSquare = Location.new("Red Square", "A large open square on the campus of the University of Washington.")

# Add more links so that we can more easily refer to the monster
redSquare.things["GM"] = friendMonster
redSquare.things["FriendlyMonster"] = friendMonster
redSquare.things["GentleMonster"] = friendMonster
redSquare.things["gentlemonster"] = friendMonster
redSquare.things["friendlymonster"] = friendMonster
redSquare.things["gm"] = friendMonster

# Locations connection
redSquare.doors["west"] = dark
dark.doors["east"] = redSquare

newGame = Game.new(redSquare, inventory: [lantern])
