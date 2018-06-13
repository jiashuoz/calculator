# CSE 413 16au Assignment 7 Scanner
# Jiashuo Zhang 1365330
# 11/29/2016

# readline provides nice command-line editing for text input
require 'readline'

class Token
	# lexical classes
	OP = /^[\+\-\*\/\=\(\)]$/
	NM = /^[0-9]+(\.[0-9]+)?([eE][\+\-]?[0-9]+)?$/
	ID = /^[a-zA-Z][a-zA-Z0-9_]*$/
	RSVD = /^list$|^quit$|^exit$|^clear$|^sqrt$/
	EOL = /^;$/
	SPACE = /^\s/

	attr_reader :kind, :value
	def initialize(kind, value=nil)
		@kind = kind
		@value = value
	end

	def to_s
		if @value != nil
			print @kind, "(", @value, ")", $/
		else 
			puts @kind
		end
	end
end

class Scanner

	def scan(input)
		@input = input.gsub(/\n/, "") << ';'
		@index = -1
		@tokens = []

		while has_next_char
			char = next_char
			char = to_token(char)
			if !char.nil? 
				@tokens.push(char)
			end
		end
	end

	def next_token
		if has_next
			@tokens.shift
		else
			puts "No token left."
		end
	end

	def has_next
		if !@tokens.nil?
			return @tokens.any?
		end
	end

	# convert chars into tokens
	def to_token(char)
		# keep reading until return
		while (1)
			# Operators
			if char.match Token::OP
				# check **
				if char == '*' && peek1 == '*'
					char = char + next_char
				end
				return Token.new(char)
			# Numbers
			elsif char.match Token::NM
				char_backup = String.new(char)
				# Sees end of line
				if peek1 == ';'
					return Token.new("Number", char.to_f)
				end
				
				# Next char is a number, simply add it
				if (peek1).match(Token::NM)
						char = char_backup << next_char
				# Next char is '.', need numbers after '.'
				elsif peek1 == '.' 
					if (char_backup + peek1 + @input[@index + 2]).match(Token::NM)
						char = char_backup << next_char << next_char
					else
						char = char_backup << next_char
						return Token.new("Invalid Token", char)
					end
				# Next char is 'e', need numbers or '+' or '-'
				elsif (peek1 == 'e' || peek1 == 'E') && !((char_backup.include? 'e') || (char_backup.include? 'E'))
					peek2 = @input[@index + 2]
					peek3 = @input[@index + 3]
					if peek2.nil?
						return Token.new("Number", char.to_f)
					# If '+' or '-', need numbers after it
					elsif (peek2 == '+' || peek2 == '-')
						if peek3.match(Token::NM)
							char = char_backup << next_char << next_char << next_char
						else
							char = char_backup << next_char << next_char
							return Token.new("Invalid Token", char)
						end
					# If numbers, simply add it
					elsif peek2.match(Token::NM)
						char = char_backup << next_char << next_char
					else
						char = char_backup << next_char
						return Token.new("Invalid Token", char)
					end
				else
					return Token.new("Number", char.to_f)
				end
			# IDs
			elsif char.match Token::ID
				while (char + peek1).match(Token::ID)
					char << next_char
				end
				if char.match(Token::RSVD)
					return Token.new(char)
				else
					return Token.new("ID", char)
			end
			# End of line
			elsif char.match(Token::EOL)
				return Token.new("EOL")
			# Spaces
			elsif char.match(Token::SPACE)
				return nil
			else
				return Token.new("Invalid Token", char)
			end
		end
	end

	def has_next_char
		return (@index + 1) != @input.length
	end

	def next_char
		@index = @index + 1
		return @input[@index]
	end

	def peek1
		if has_next_char
			return @input[@index + 1]
		else
			return nil
		end
	end
end