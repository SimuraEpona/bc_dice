Definitions.

Number          = [0-9]+
BasicOperator   = [\+\-]
ComplexOperator = [\*\/%]
CompareOperator = [<|>]?\=|<>|<|>
ExponOperator   = \^
Roll            = D
BaraBaraRoll    = B
Choice          = CHOICE\[.+,.+\]
Space           = [\s\t\n\r]+
LeftParen       = \(
RightParen      = \)
Separator       = ,

Rules.

{Space}             : skip_token.
{ExponOperator}     : {token, {exp_operator, TokenLine, TokenChars}}.
{BasicOperator}     : {token, {basic_operator, TokenLine, TokenChars}}.
{ComplexOperator}   : {token, {complex_operator, TokenLine, TokenChars}}.
{CompareOperator}   : {token, {compare_operator, TokenLine, TokenChars}}.
{Roll}              : {token, {roll, TokenLine, TokenChars}}.
{BaraBaraRoll}      : {token, {bara_roll, TokenLine, TokenChars}}.
{Choice}            : {token, {choice, TokenLine, replace_choice(TokenChars)}}.
{LeftParen}         : {token, {'(', TokenLine, TokenChars}}.
{RightParen}        : {token, {')', TokenLine, TokenChars}}.
{Number}            : {token, {int, TokenLine, TokenChars}}.
{Separator}         : {token, {',', TokenLine, TokenChars}}.

Erlang code.


replace_choice(S) -> re:replace(S, "CHOICE\\[(.*)\\]", "\\g{1}", [{return, list}]).

