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
	RSVD = /^list|clear|quit|exit|sqrt$/
	EOL = /^;$/

	attr_reader :kind, :value
	def initialize(kind, value=nil)
		@kind = kind
		@value = value
	end

	def to_s
		if @value != nil
			print @kind, "(", @value, ")", $/
		end
	end
end

class Scanner
	def initialize(input)
		scan(input)
	end

	def scan(input)
		@input = input.gsub(/\s+/, "") << ';'
		@index = -1
		@tokens = []

		while has_next_char
			char = next_char
			char = to_token(char)
			@tokens.push(char)
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
		return @tokens.any?
	end

	def to_token(char)
		while (1)
			if char.match Token::OP
				# check **
				if char == '*' && peek_char == '*'
					char = char + next_char
				end
				return Token.new(char)

			elsif char.match Token::NM
				char_backup = String.new(char)
				if peek_char == ';'
					return Token.new("Number", char.to_f)
				end
				
				if (peek_char).match(Token::NM)
					if (char_backup << next_char).match(Token::NM)
						char = char_backup
					else
						return Token.new("Number", char.to_f)
					end
				elsif peek_char == '.'
					if (char_backup << next_char << next_char).match(Token::NM)
						char = char_backup
						puts char
					else
						return Token.new("Number", char.to_f)
					end
				elsif peek_char == 'e' || peek_char == 'E'
					if (char_backup << next_char << next_char << next_char).match(Token::NM)
						char = char_backup
					else
						return Token.new("Number", char.to_f)
					end
				else
					return Token.new("Number", char.to_f)
				end

			elsif char.match Token::ID
				while (char + peek_char).match(Token::ID)
					char << next_char
				end
				if char.match(Token::RSVD)
					return Token.new(char)
				else
					return Token.new("ID", char)
			end

			elsif char.match Token::EOL
				return Token.new("EOL")

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

	def peek_char
		return @input[@index + 1]
	end
end