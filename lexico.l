%{
#include <stdio.h>
#include <stdlib.h>
int linha_atual = 1;
int erros = 0;
%}
    //=======DEFINIÇÕES=======//

digit                   [0-9]
id                      [a-zA-Z][a-zA-Z0-9]*
operator                ("+"|"-"|"*"|"/"|"=="|">"|"<"|">="|"<="|"|"|"("|")"|"["|"]"|"{"|"}")
end                     ";"
atrib                   "="
coment                  "??"

%%

    //=======REGRAS=======//

[ \t]                   ;                   //ignora espaços em branco
\n                      {linha_atual++;}    //conta o número de linhas do programa

{digit}+                {printf("%s -> NUMERO INTEIRO\n", yytext);}
{digit}+"."{digit}+     {printf("%s -> NUMERO REAL\n", yytext);}
{id}+                   {printf("%s -> IDENTIFICADOR\n", yytext);}
{operator}              {printf("%s -> OPERADOR\n", yytext);}
{atrib}                 {printf("%s -> COMANDO DE ATRIBUIÇÃO\n", yytext);}
{coment}[^\n]*          {printf("%s -> COMENTARIO\n", yytext);}
{end}                   {printf("%s -> FIM DE COMANDO\n", yytext);}

{operator}+{id}+        {printf("%s -> ERRO (identificadores não podem começar com operadores,", yytext);
                        erros++;
                        printf(" Linha %d)\n", linha_atual);}

{digit}+{id}+           {printf("%s -> ERRO (identificadores não podem começar com dígitos,", yytext);
                        erros++;
                        printf(" Linha %d)\n", linha_atual);}

{atrib}+{id}+           {printf("%s -> ERRO (identificadores não podem começar com atribuidor,", yytext);
                        erros++;
                        printf(" Linha %d)\n", linha_atual);}

{end}+{id}+             {printf("%s -> ERRO (identificadores não podem começar com ;,", yytext);
                        erros++;
                        printf(" Linha %d)\n", linha_atual);}

.                       {printf("%s -> ERRO (token desconhecido,", yytext);
                        erros++;
                        printf(" Linha %d)\n", linha_atual);}

%%

    //=======CÓDIGO=======//

int main(int argc, char** argv) {

    //verifica o número de argumentos passados na execução
    if (argc != 2) {
        printf("Uso: %s arquivo_de_entrada.txt\n", argv[0]);
        return 1;
    }

    //abertura do arquivo
    FILE* file = fopen(argv[1], "r");

    //verifica se arquivo foi aberto com sucesso
    if (!file) {
        perror("Erro ao abrir o arquivo");
        return 1;
    }

    yyin = file;
    yylex();

    if(erros==0){
        printf("\nNENHUM ERRO ENCONTRADO! :)\n");
    }
    else if(erros ==1){
        printf("\n1 ERRO ENCONTRADO! :/\n");
    }
    else{
        printf("\n%d ERROS ENCONTRADOS! :(\n", erros);
    }

    fclose(file);
    return 0;
}