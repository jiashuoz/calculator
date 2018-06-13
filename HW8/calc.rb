# CSE 413 16au Assignment 8 Calculator
# Jiashuo Zhang 1365330
# 11/29/2016

require_relative "scan.rb"

# A Calculator program with a specific grammar
class Calculator
	
	# Initialize a calculator
	def initialize
		userManual
		# Create a scanner
		@input = Scanner.new
		@ids = {}
		@ids["PI"] = Math::PI
		@token = nil
		program
	end

	# Check if there is the next token
	def has_next_token
		@input.has_next
	end

	# Move to next token
	def next_token
		@token = @input.next_token
	end

	# Peek next token
	def peek_token
		@input.peek_token
	end

	# Constantly runs statements
	def program
		@input.scan(gets)
		# Read multiple statements in one single line
		while peek_token.kind != "EOL"
			stmt = statement
			puts stmt
			next_token
			# End of line, jump out of loop
			if peek_token.nil?
				break
			end
		end
		puts
		program
	end

	def statement
		next_token
		if @token.kind == "exit" || @token.kind == "quit"
			puts "Calculator quits."
			exit
		elsif @token.kind == "list"
			@ids.each do |id, value|
				print id, " = ", value, $/
			end
			return nil
		elsif @token.kind == "clear"
			if peek_token.kind != "ID"
				return "Syntax error."
			end
			next_token
			value = @ids[@token.value]
			if @ids.delete(@token.value).nil?
				return "The variable hasn't been assigned a value."
			else
				return "Successfully deleted: " + @token.value + " = " + value.to_s + $/
			end
		# ID or ID assignment
		elsif @token.kind == "ID" && (peek_token.kind == "EOL" || peek_token.kind == "=")
			# Save the actual id: x, y, z, etc..
			id = @token.value
			if peek_token.kind == "EOL"
				return exp
			elsif peek_token.kind == "="
				next_token # Points to =
				next_token
				temp = exp
				if temp.is_a? Numeric
					# Bound the expression to variable, store it in the hash table
					@ids[id] = temp
					return "Variable Assignment: " + id + " = " + temp.to_s + $/
				else
					return "Syntax error."
				end
			end
		else
			return exp
		end
	end

	def exp
		# Unary minus operator
		if @token.kind == "-"
			next_token
			value = term
			if value.is_a? Numeric
				exp_value = -value
			else
				return term
			end
		else
			exp_value = term
		end
		if exp_value.is_a? Numeric
			# Continue until reach the last term
			while peek_token.kind == "+" || peek_token.kind == "-"
				next_token
				# exp + term
				if @token.kind == "+"
					# Points to next "+"
					next_token
					value = term
					if value.is_a? Numeric
						exp_value = exp_value + value
					else
						return value
					end
				# exp - term
				else
					# Points to next "-"
					next_token
					value = term
					if value.is_a? Numeric
						exp_value -= value
					else
						return value
					end
				end
			end
		else
			return term
		end
		return exp_value
	end

	def term
		term_value = power
		# Continue until the last power
		while peek_token.kind == "*" || peek_token.kind == "/"
			next_token
			if @token.kind == "*"
				next_token
				term_value *= power
			else
				next_token
				term_value /= power
			end
		end
		return term_value
	end

	def power
		power_value = factor
		# Continue until the last factor
		while peek_token.kind == "**"
			# Points to "**"
			next_token
			next_token
			power_value = power_value ** power
		end
		return power_value
	end

	def factor
		factor_value = nil
		# Different cases for factors
		case @token.kind
		when "ID"
			if @ids[@token.value].nil?
				return "No such variable exists: " + @token.value
			else
				return factor_value = @ids[@token.value]
			end
		when "Number"
			return @token.value
		when "("
			next_token  # Points to "exp"
			factor_value = exp
			if !next_token.kind == ")"
				puts "Missing right parenthesis."
			end
			return factor_value
		when "sqrt"
			if peek_token.kind == "("
				next_token  # Points to "("
				next_token  # Points to "exp"
				value = exp
				if value.is_a? Numeric
					factor_value = Math.sqrt(value)
				else
					return
				end
				if !next_token.kind == ")"
					return "Missing right parenthesis."
				end
			else
				return "sqrt syntax error."
			end
			return factor_value
		# Natural log
		when "log"
			if peek_token.kind == "("
				next_token
				next_token
				value = exp
				if value.is_a? Numeric
					factor_value = Math.log(value)
				else
					return
				end
				if !next_token.kind == ")"
					return "Missing right parenthesis."
				end
			else
				return "log syntax error."
			end
			return factor_value
		when "Invalid Token"
			print "Syntax error: ", @token.kind, $/
			return factor_value
		end
	end

	def userManual
		puts "Hello! This is my Calculator program."
		puts
		puts "Note: this program takes care of only some of the syntax error."
		puts
		puts "For example, you could have extra parenthesis at the end of your statement and the program would not care about and simply give the result. If you input some invalid tokens, for example 1.2e++ or 1...2, program would dump it and ask for next statement."
		puts "If you don't follow the following syntax, the program might exit!"
		puts "Have fun!"
		puts
		puts "The following is the basic syntax."
		puts 	  "*=======================================================================================*"
		puts "|" + "Basic Operations: 				 					|"
		puts "|" + "		Add:    			16 + 4					|"
		puts "|" + "		Sub:    			16 - 4					|"
		puts "|" + "		Multiply			16 * 4					|"
		puts "|" + "		Divide				16 / 4					|"
		puts "|" + "		Power 				2 ** 4					|"
		puts "|" + "		Square root			sqrt(16)				|"
		puts "|" + "		Natural log			log(10)					|"
		puts "|" + "		Unary minus op 			-2 or -(2*3)				|"
		puts "|											|"
		puts "|" + "A bit more complex:									|"
		puts "|" + "		Complex computation		-(2*3**sqrt(x-4/2))			|"
		puts "|" + "		Multiple statements		(1 + 2) * 4 / 2; sqrt(log(1000))	|"
		puts "|" + "		Assignment			x = 2					|"
		puts "|" + "		Clear Assignment		clear x					|"
		puts "|" + "		List Assignments		list					|"
		puts "|" + "		Get variable value 		x					|"
		puts "|											|"
		puts "|" + "Interface: 										|"
		puts "|" + "		Exit 					quit or exit 			|"
		puts 	  "*=======================================================================================*"
	end
	private :userManual
end

calculator = Calculator.new()