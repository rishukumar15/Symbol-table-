%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int err_no=0,fl=0,pt=0,i=0,j=0,lvl=0,type[100],level[100],part[100],done[100];
char symbol[100][100],temp[100];
extern FILE *yyin;
void yyerror(char *);
int yylex(void);
void insert(int,int);
void lookup(); 
%} 

%union {
    int iValue;     /* integer value */
    char* iName;    /* identifier name */
}

%token <iValue> INT;
%token <iValue> FLOAT;
%token <iValue> CHAR;
%token <iValue> DOUBLE;
%token <iValue> CM;
%token <iValue> SE;
%token <iValue> I;
%token <iValue> D;
%token <ivalue> STRUCT;
%token <iName> VAR;
%token <iName> ARR;

%%
program:
    program S1 '\n'
    |
    ;
S1:
    S S1 | S;
S: 
    INT L1 E
    | FLOAT L2 E
    | CHAR L3 E
    | DOUBLE L4 E
    | STRUCT L5 F
    | STRUCT VAR L6 E
    | I { lvl++; }
    | D {lookup(); lvl--;}
    ;
F:
    I B1 D E
    ;
B1:
    B1 B
    | B
    ;    
B:
    INT L1 E
    | FLOAT L2 E
    | CHAR L3 E
    | DOUBLE L4 E
    ;          
L1:
    L1 CM VAR {strcpy(temp,(char*)$3); insert(0,lvl);}
    | VAR    {strcpy(temp,(char*)$1); insert(0,lvl);}
    | L1 CM ARR  {strcpy(temp,(char*)$3); insert(4,lvl);}
    | ARR   {strcpy(temp,(char*)$1); insert(4,lvl);}
    ;
L2:
    L2 CM VAR {strcpy(temp,(char*)$3); insert(1,lvl);}
    | VAR    {strcpy(temp,(char*)$1); insert(1,lvl);}
    | L2 CM ARR  {strcpy(temp,(char*)$3); insert(5,lvl);}
    | ARR   {strcpy(temp,(char*)$1); insert(5,lvl);}
    ;
L3:
    L3 CM VAR {strcpy(temp,(char*)$3); insert(2,lvl);}
    | VAR    {strcpy(temp,(char*)$1); insert(2,lvl);}
    | L3 CM ARR  {strcpy(temp,(char*)$3); insert(6,lvl);}
    | ARR   {strcpy(temp,(char*)$1); insert(6,lvl);}
    ;
L4:
    L4 CM VAR {strcpy(temp,(char*)$3); insert(3,lvl);}
    | VAR    {strcpy(temp,(char*)$1); insert(3,lvl);}
    | L4 CM ARR  {strcpy(temp,(char*)$3); insert(7,lvl);}
    | ARR   {strcpy(temp,(char*)$1); insert(7,lvl);}
    ;
L5:
    VAR  {strcpy(temp,(char*)$1); insert(8,lvl);}
    ;
L6:
    L6 CM VAR {strcpy(temp,(char*)$3); insert(9,lvl);}
    | VAR    {strcpy(temp,(char*)$1); insert(9,lvl);}
    ;
E:
    SE;

%%

void yyerror(char *s)
{
}


void lookup()
{
    if(lvl > 1)
    {
        done[lvl]++;
    }
}

void insert(int type1, int lv)
{
    fl=0;
    for(j=0;j<i;j++)
    {
        if(strcmp(temp,symbol[j])==0)
        {
            if(level[j] < lv)
            {
                if(type[j]==type1)
                {
                    printf("Error : Redeclaration of variable! \n");
                    err_no=1;
                }
                else
                {
                    printf("Error : Multiple Declaration of Variable! \n");
                    err_no=1;
                }
                fl = 1;
            }
            else if(level[j] == lv && part[j] == done[lv])
            {
                if(type[j]==type1)
                {
                    printf("Error : Redeclaration of variable! \n");
                    err_no=1;
                }
                else
                {
                    printf("Error : Multiple Declaration of Variable! \n");
                    err_no=1;
                }
                fl = 1;
            }
        }
    }
    if(fl==0)
    {
        type[i]=type1;
        level[i]=lv;
        part[i] = done[lv];
        strcpy(symbol[i],temp);
        i++;
    }
} 

int main()
{
 
    char filename[50]; 
    printf("Enter the filename: \n"); 
    scanf("%s",filename); 
    yyin = fopen(filename,"r"); 
    if(yyin==NULL)
    {
        printf("Error in opening file ! \n");
        err_no = 1;
    }
    else 
    {
        int a;
        for(a=0;a<100;a++)
        {
            done[a] = 0;
            part[a] = 0;
        }
        yyparse();
    }
    

    if(err_no==0)
    {   
        printf("\n       Symbol Table : \n");
        printf("\n");
        printf("Type \t\t\t");
        printf("Name \t\t");
        printf("Level \t\t");
        printf("\n");
        printf("------------------------------------------------- \n");
        for(j=0;j<i;j++)
        {
            if(type[j]==0) printf("INT Variable -- ");
            if(type[j]==1) printf("FLOAT Variable -- ");
            if(type[j]==2) printf("CHAR Variable -- ");
            if(type[j]==3) printf("DOUBLE Variable -- ");
            if(type[j]==4) printf("INT Array -- \t");
            if(type[j]==5) printf("FLOAT Array -- \t");
            if(type[j]==6) printf("CHAR Array -- \t");
            if(type[j]==7) printf("DOUBLE Array --\t");
            if(type[j]==8) printf("STRUCT DataType -- ");
            if(type[j]==9) printf("STRUCT Variable -- ");
            printf("\t");
            
            if(type[j]==8)
            {
                int n = strlen(symbol[j]);
                int k;
                for(k=0;k<(n-2);k++)
                {
                    printf("%c",symbol[j][k]);
                }

            }
            else
            {
                printf("%s \tLEVEL --",symbol[j]);
                printf(" %d",level[j]);
                 if(level[j]>1 && done[level[j]]>1)
                {
                    char ch;
                    ch = part[j] + 'A';
                    printf("%c ",ch);
                }
            }
            printf("\n");
        }
    }
    return 0;
}