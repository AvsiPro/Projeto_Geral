#include "topconn.ch"
#include "tbiconn.ch"   

User Function AtuPatri()

Local cArquivo := ""

                           
prepare environment empresa "02" filial "01"


// Faz o backup das tabelas SN1 e SN3
SET DELETED OFF	// pega tambem os deletados
cArquivo := "\SYSTEM\SA1LUXOR_BKP20131107.DBF"
dbSelectArea("SA1") // tabela que sera copiada
//IF FILE(cArquivo)
   //DELETE FILE(cArquivo) 
//ENDIF                           

COPY TO &cArquivo VIA "DBFCDXADS"	// copia para o dbf


Return