%option noyywrap
%{
    #include <stdio.h>
    #include "calc.tab.h"
    #include "functions.h"
    extern int yylex();
%}
%%
[ \t]                                                       ;
\n		                                                    {return NEWLINE;}
M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})		{yylval = roman_to_decimal(yytext); return NUM;}
"+"		                                                    {return PLUS;}
"-"		                                                    {return MINUS;}
"*"		                                                    {return MULTIPLY;}
"/"                                                         {return DIVIDE;}
"("		                                                    {return LEFT;}
")"		                                                    {return RIGHT;}
.                                                           {return INVALID_TOKEN;}
%%