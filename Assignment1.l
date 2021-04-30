%{
#include <stdlib.h>
#include "y.tab.h"
void yyerror(char *); 
int x=0;
%}

num   [0-9]+
alpha [A-Za-z]+

%%
"int" {x++;return INT;}
"float" {x++;return FLOAT;}
"char" {x++; return CHAR;}
"double" {x++;return DOUBLE;}
"main"  ;
"while" ;
"for"   ;
"struct" {x++;return STRUCT;}
"{" return I;
"}" return D;
{alpha}\[{num}\] {yylval.iName = yytext;if(x>0) {return ARR;} return 0;}
{alpha} {yylval.iName = yytext;if(x>0) {return VAR;} return 0;} 
"," return CM;
";" {x--;return SE;}
[ \t\n]+ ;
.   {}
%%

int yywrap(void)    
{
 return 1;
} 