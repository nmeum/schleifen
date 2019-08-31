# schleifen

An interpreter for [LOOP programs][loop wikipedia] in [chicken scheme][call-cc].

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

# License

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along
with this program. If not, see <https://www.gnu.org/licenses/>.

[loop wikipedia]: https://en.wikipedia.org/wiki/LOOP_(programming_language)
[call-cc]: https://call-cc.org/
[wikipedia syntax]: https://en.wikipedia.org/wiki/LOOP_(programming_language)#Syntax
