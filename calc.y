%{
    #include <stdio.h>
    #include <stdlib.h>
	#include <string.h>
	#include "functions.h"
    extern int yylex();
    extern int yyparse();
	extern FILE *yyin;
    void yyerror(const char* s);
	static int count_line=0;
%}
%token NUM NEWLINE PLUS DIVIDE MINUS LEFT RIGHT MULTIPLY INVALID_TOKEN

%type line exp term factor s_start
%start s_start

%%
s_start	:	/* empty */
		|	s_start line		
		;
line    :   exp NEWLINE             {   printf("[%d] = ",++count_line);
                                        decimal_to_roman($1);
                                        printf(" %d\n",$1);
                                    }
		|	error NEWLINE			
		;
exp     :   exp PLUS term           { $$ = $1 + $3; }
		| 	exp MINUS term          { $$ = $1 - $3; }
        |   term                    { $$ = $1; }
        ;
term    :   term MULTIPLY factor    { $$ = $1 * $3; }
		|	term DIVIDE factor    	{ $$ = $1 / $3; }
        |   factor                  { $$ = $1; }
        ;
factor  :   LEFT exp RIGHT          { $$ = $2; }
        |   NUM                     { $$ = $1; }
        ;               
%%

int value(char r) 
{ 
    if (r == 'I') 
        return 1; 
    if (r == 'V') 
        return 5; 
    if (r == 'X') 
        return 10; 
    if (r == 'L') 
        return 50; 
    if (r == 'C') 
        return 100; 
    if (r == 'D') 
        return 500; 
    if (r == 'M') 
        return 1000; 
    return -1; 
} 

/*https://www.geeksforgeeks.org/converting-roman-numerals-decimal-lying-1-3999/*/
int roman_to_decimal(char* str) 
{ 
    int res = 0; 
    for (int i=0; i < strlen(str); i++) 
    { 
        int s1 = value(str[i]); 
        if (i+1 < strlen(str)) 
        { 
            int s2 = value(str[i+1]);
            if (s1 >= s2) 
            { 
                res = res + s1; 
            } 
            else
            { 
                res = res + s2 - s1; 
                i++; 
            } 
        } 
        else
        { 
            res = res + s1;  
        } 
    } 
    return res; 
} 

/*https://www.thecrazyprogrammer.com/2017/09/convert-decimal-number-roman-numeral-c-c.html*/
void decimal_to_roman(int num){
    int decimal[] = {1000,900,500,400,100,90,50,40,10,9,5,4,1}; //base values
    char *symbol[] = {"M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"};  //roman symbols
    int i = 0;
    while(num){ //repeat process until num is not 0
        while(num/decimal[i]){  //first base value that divides num is largest base value
            printf("%s",symbol[i]);    //print roman symbol equivalent to largest base value
            num -= decimal[i];  //subtract largest base value from num
        }
        i++;    //move to next base value to divide num
    }
}


int main(void) {
	FILE *myfile = fopen("input", "r");
	if (!myfile) {
		printf("Error al abrir archivo\n");
		exit(1);
	}
	yyin = myfile;
	yyparse();
}

void yyerror(const char* s) {
	fprintf(stderr, "[%d] Error de sintaxis\n", ++count_line);
}
