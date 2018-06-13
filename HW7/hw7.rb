# CSE 413 16au Assignment 7 Scanner
# Jiashuo Zhang 1365330
# 11/29/2016

require_relative "scan.rb"

input = Scanner.new()

while 1
	input.scan(gets)
	while input.has_next
		token = input.next_token
		puts token.to_s
		if token.kind == "EOL"
			input.scan(gets)
		elsif token.kind == 'quit' || token.kind == 'exit'
			puts "Quitting..."
			exit
		end
	end
end