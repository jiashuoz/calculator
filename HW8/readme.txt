CSE 413 Assignment 8 Calculator
Jiashuo Zhang 1365330

The calculator has all the basic functions specified in the assignment specification.
Basic operations: Addition, subtraction, multiplication, division, power, sqrt, parenthesis, variable assignment, clear variable assignment, list, and quit/exit

Extra features:
	1. Print useful messages after assignment and clear, especially for the clear. If the next token after clear is not ID, then syntax error; if it is an ID but not in our list, then print a message saying variable is not assigned. If user only inputs an ID, print the value for the ID; if the ID has not been assigend a value, print warning.

	2. Allowing empty lines, multiple statements separated by ";", and minus unary operators.
		Here's some examples:
		My calculator can do the following(assume x = 2):
			-x + 1; -x - 1; -x * x; -x / 4; -x**x; -sqrt(16);

	3. Error handling:
		a. When x is not assigned, if we do x + 2 + 3, it will print out warning(even though x is a valid token, but it's not assigned.) and the result of 2 + 3, skip to the next input argument, and then resume reading new inputs. If we do x + y, where both x and y are unassigned variables, once we see x the system simply gives warning about it, skips the rest tokens, and then jump to next input statement.

		b. If we see an Invalid Token, simply dump the junk input, and skip to the next statement. The program would print Syntax error: Invalid Token twice because of some return statements. To keep sure other stuff work properly and this is only for extra credit, I just leave it that way.

		c. There are some errors we don't need to worry about. For example, if we have extra parenthesis at the end of a statement. x = (1 + 2)))

		d. For some other error, I didn't bother to fix them. For example, log(((x), if we see something like this, the system will crash.

	4. Added natural log(ie. ln) operation(Math.log in ruby).
