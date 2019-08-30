# schleifen

An interpreter for [loop programs][loop wikipedia] in [chicken scheme][call-cc].

# Status

Just a toy program for playing around with chicken scheme.

# Usage

	$ chicken-install -n
	$ ./schleifen op1=40 op2=2 < examples/addition.loop

# Syntax

The following EBNF describes valid input:

	variable_start = letter | "_";
	variable = variable_start, { variable_start | digit };

	literal = digit;
	primitive_value = literal | variable;
	expression = primitive_value, ( "+" | "-" ), primitive_value;
	value = primitive_value | expression;

	command = variable, ":=", value, operator
	        | "LOOP", value, "DO" commands, "DONE";
	commands = command, ";", { command, ";" };

[loop wikipedia]: https://en.wikipedia.org/wiki/LOOP_(programming_language)
[call-cc]: https://call-cc.org/
[wikipedia syntax]: https://en.wikipedia.org/wiki/LOOP_(programming_language)#Syntax
