# schleifen-ausführer

An interpreter for [loop programs][loop wikipedia] in [chicken scheme][call-cc].

# Status

Just a toy program for playing around with chicken scheme.

# Usage

	$ csc interpreter.scm
	$ ./interpreter < examples/copy.loop

# Syntax

The following EBNF describes valid input:

	variable_start = letter | "_";
	variable = variable_start, { variable_start },
	           { variable_start | digit };

	literal = digit;
	operator = "+" | "-";
	expression = value, operator, value;
	value = expression | variable | literal;

	command = variable, ":=", value, operator
	        | "LOOP", value, "DO" commands, "DONE";
	commands = command, ";", { command, ";" };

[loop wikipedia]: https://en.wikipedia.org/wiki/LOOP_(programming_language)
[call-cc]: https://call-cc.org/
[wikipedia syntax]: https://en.wikipedia.org/wiki/LOOP_(programming_language)#Syntax
