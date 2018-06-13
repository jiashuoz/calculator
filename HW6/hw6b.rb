# CSE 413 16au Assignment 6 Part 2
# Jiashuo Zhang 1365330
# 11/13/2016

# Provides game.rb
require_relative "game.rb"
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
        found = false
        # Loop through to see if there's a lit lantern
		Game.player.inventory.each do |item|
			if item.is_a? Lantern
				# Found
				if item.lit
					found = true
				end
			end
		end
		if found
			Game.pretty_print(paragraphs, @name)
			return self
		else
			Game.pretty_print(["It's too dark to see anything! You need to turn on a lantern."], @name)
			return self
		end
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

# LOCATION: BlackSmithShop
# A location used in combination with wallet.
# This location has a sword when initialized
class BlackSmithShop < Location
	def initialize()
		super("TheBlackSmith", "This is Black Smith's shop. You can buy your weapon here!")
		sword = RulerSword.new("sword", 8)
		@things["sword"] = sword
	end
end

# LOCATION: Fountain
# A special location where there's always a monster when you enter.
# If you beat the monster, you will be given a fountain potion when you exit this location.
class Fountain < Location
	def initialize()
		super("TheFountain", "We produce a lot of apple potion here. Come and get it! BUT you have to kill the monster here first. After you beat the monster and if you exit the fountain, you will find that you have something in your pocket. Good luck.")
		@p = nil
	end

	def follow_door(name)
		# Check if the monster still exists
		# If not, give the potion to the player
		if (not @things.has_key?("jack"))
			Game.player.inventory.push(@p)
		end
		ret = nil
        if (@doors[name].is_a? String)
            puts @doors[name]
            ret = self
        else
            ret = @doors[name]
            ret.pretty_print
        end
        return ret
	end

	def pretty_print
		# When player enters, create a new monster
		monster = Monster.new("jack", "monster name: jack", { "hp" => 10 })
		@things["jack"] = monster
		# Create a new fountain potion
		potion = ApplePotion.new("fountainPotion", 10)
		@p = potion
		@things["potion"] = potion
		things = []
        paragraphs = [@desc]
        @things.each do |key, thing|
            if (not things.include? thing)
                paragraphs += [thing.describe(:world)]
                things += [thing]
            end
        end
        Game.pretty_print(paragraphs, @name)
        return self
    end
end

# ITEM: RulerSword
# Player can buy sword in BlackSmithShop.
# Player can use it to enhance attack points
class RulerSword < Item
	attr_reader :name, :ap 
	def initialize(name, ap)
		super(name, "sword", name, "Greatsword of Vendrick, king of Drangleic. The strength of this sword is relative to the number of souls possessed by its wielder.")
		@name = name
		@ap = ap
		@in_use = false
	end
	
	def use(args = [])
		@in_use = (not @in_use)
		attri = Game.player.attributes
		# Equip the sword
		if @in_use
			# If player does not have "ap", create one
			if attri.has_key? "ap"
				attri["ap"] += @ap
			else
				attri["ap"] = @ap + 1
			end
			Game.pretty_print "The Sword is equipped! Your attack points now is " + attri["ap"].to_s
		# Unequip the sword
		else
			if attri.has_key? "ap"
				attri["ap"] -= @ap
			end
			Game.pretty_print "The Sword is un-equipped! Your attack points is " + attri["ap"].to_s
		end
	end
end

# ITEM: Wallet
# Can only be used in BlackSmithShop to buy sword
class Wallet < Item
	attr_accessor :coins
	def initialize(coins)
		super("wallet", "wallet", "Something shiny shiny shiny in there!", "Money in this wallet can be used in the BlackSmith's shop.")
		# coins has not been developped yet, but a good idea
		@coins = coins
	end
	def use(arg)
		if Game.location.name == "TheBlackSmith"
			puts "These are what we sell:"
			# Print out things they sell
			puts Game.location.things.keys.to_s
			puts "What do you want to buy?"
			# ask player what to buy
			inp = Game.prompt
			inp = inp.downcase
			# Loop through location's things
			Game.location.things.each do |key, value|
				if (key == inp) and (value.is_a? RulerSword)
					if Game.player.inventory.include? value
						puts "You alread have it in your inventory. Purchase failed."
						return
					else	
						Game.player.inventory.push(value)
						print "Now you have ", key, " in your inventory.", $/
						return
					end
				else
					print "We do not sell ", inp, ".", $/
					return
				end
			end
		else
			puts "You are not at the weapon store. You cannot use wallet."
		end
	end
end

# ITEM: ApplePotion
# Player can use this to increase hp
class ApplePotion < Item
	def initialize(name, health)
		super(name, name, name, "Drink this potion and you can increase your HP by " + health.to_s)
		@health = health
	end

	def use(arg = [])
		Game.player.attributes['hp'] += @health
		Game.player.inventory.each do |item|
			if item.name == @name
				Game.player.inventory.delete(item)
				Game.pretty_print "Now your hp is " + Game.player.attributes['hp'].to_s
			end
		end
	end
end

# ACTION: Tame
# If a monster's ap is < 3, there's a chance that player can tame it.
# After successfully taming it, player will see the monster in inventory.
class Tame < Action
	def initialize() 
		@desc = "If the monster's ap is lower than 3, you can possibly tame it as your pet and put it in your inventory."
	end

	def do(args = [])
		if (args.length < 1) then
			puts "Tame what?"
		elsif Game.location.things.has_key?(args[0])
			thing = Game.location.things[args[0]]
			if thing.is_a? Monster
				if thing.attributes["ap"] < 3
					# Use a random number to model possibility
					r = Random.new
					if r.rand(1..5) == 1
						Game.player.inventory.push(thing)
						Game.location.things.delete(args[0])
					else
						puts "Failed to tame. Try it again."
					end
				end
			else
				puts "You can't tame that."
			end
		else
			puts "I don't see it around."
		end
	end 
end

# ACTION: Dispose
# Player can dispose anything in their inventory
class Dispose < Action
	def initialize()
		@desc = "You can dispose anything in your inventory."
	end

	def do(args = [])
		if (args.length < 1) then
			puts "Dispose what?"
		else
			found = false
			Game.player.inventory.each do |item|
				if item.name == args[0]
					Game.player.inventory.delete(item)
					found = true
				end
			end
			if found
				puts "Successfully disposed."
			else
				puts "Not found in inventory."
			end
		end
	end
end

class PickUp < Action
	def initialize()
		@desc = "You can pick up things at current location."
	end

	def do(args = [])
		if (args.length < 1) then
			puts "Pick up what?"
		else
			picked = false
			Game.location.things.each do |key, thing|
				# RulerSword can only be purchased
				if (key == args[0]) and  (not thing.is_a? Monster) and (not thing.is_a? RulerSword)
					Game.player.inventory.push(thing)
					Game.location.things.delete(key)
					picked = true
				end
			end
			if picked
				puts "Successfully picked up."
			else
				puts "You cannot pick it up."
			end
		end
	end
end

class Drop < Action
	def initialize()
		@desc = "You can drop things here."
	end

	def do(args = [])
		if (args.length < 1) then
			puts "Drop what?"
		else
			dropped = false
			Game.player.inventory.each do |item|
				if (item.name == args[0])
					Game.player.inventory.delete(item)
					Game.location.things[item.name] = item
					dropped = true
				end
			end
			if dropped
				puts "Successfully dropped."
			else
				puts "You don't have it."
			end
		end
	end
end
# Create new locations
redSquare = Location.new("Red Square", "A large open square on the campus of the University of Washington.")
blackSmith = BlackSmithShop.new()
fountain = Fountain.new()
dark = DarkLocation.new("DarkLocation", "This is the Odegaard undergraduation library")
ima = Location.new("IMA", "A large GYM.")
paccar = Location.new("Paccar Hall", "Foster School of Business.")
eeb = Location.new("EEB", "School of Electrical Engineering.")
cse = Location.new("Pual Allan Center", "School of CSE.")

# Create items
potion0 = ApplePotion.new("potion0", 5)
potion1 = ApplePotion.new("potion1", 10)
lantern = Lantern.new("lantern", "lantern")
wallet = Wallet.new(10)

# Location connections
redSquare.doors = { "west" => blackSmith, "south" => fountain, "north" => dark }
dark.doors = { "south" => redSquare , "north" => paccar }
paccar.doors = { "south" => dark }
blackSmith.doors = { "east" => redSquare }
fountain.doors = { "north" => redSquare, "east" => eeb }
eeb.doors = { "west" => fountain, "east" => cse }
cse.doors = { "west" => eeb, "east" => ima }
ima.doors = { "west" => cse }



m0 = Monster.new("m0", "monster name: m0", { "hp" => 10 , "ap" => 0 })
m1 = Monster.new("m1", "monster name: m1", { "hp" => 10 , "ap" => 1 })
m2 = Monster.new("m2", "monster name: m2", { "hp" => 10 , "ap" => 2 })
m3 = Monster.new("m3", "monster name: m3", { "hp" => 10 , "ap" => 3 })

# Add things to locations
redSquare.things[m0.name] = m0
dark.things[m1.name] = m1
dark.things[m2.name] = m2
blackSmith.things[m3.name] = m3

# Run game
newGame = Game.new(redSquare, actions: {"tame" => Tame.new, "dispose" => Dispose.new, "pick" => PickUp.new, "drop" => Drop.new} , inventory: [wallet, potion0, potion1])