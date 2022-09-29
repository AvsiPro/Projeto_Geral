#INCLUDE "Rwmake.CH" 
#INCLUDE "TopConn.ch"
    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRMANACP   บAutor  ณ  Tootvs            บ Data ณ  Dez/2009   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImportacao de CTD                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RMANCTD()
Local nOpca     	:= 0
Local aSays     	:= {}
Local aButtons  	:= {}
Local cCadastro  	:= OemToAnsi("Importacao dos Itens Contabil")
Local aArea			:= GetArea()
                        

AADD(aSays,OemToAnsi("Este programa efetuara a importacao dos Itens Contabil."	))
AADD(aSays,OemToAnsi("conforme arquivo selecionado."						  		))
AADD(aSays,OemToAnsi("Clique no botao parametros para selecionar o arquivo."  		))
AADD(aButtons, { 1,.T.						,{|o| (ImpArq(),o:oWnd:End())   		}})//Chama rotina para importar o arquivo
AADD(aButtons, { 2,.T.						,{|o| o:oWnd:End()						}})
FormBatch( cCadastro, aSays, aButtons )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura a area dos arquivos                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aArea)

Return()

Static Function ImpArq()

Processa({|| Valida() },"Validando arquivo...")

Return


Static Function Valida()
                               


cQry	:= "SELECT ZZ3_CODCLI,ZZ3_LOJA,ZZ1_SITE,ZZ1_COD,ZZ1_DESCRI " 
cQry	+= " FROM "+RetSqlName("ZZ1")+" ZZ1, "+RetSqlName("ZZ3")+" ZZ3 "
cQry	+= " WHERE ZZ1.D_E_L_E_T_<> '*' AND ZZ3.D_E_L_E_T_<> '*' "
cQry	+= " AND ZZ1_COD LIKE 'P%'"
//cQry	+= " AND ZZ1_FILIAL = '"+xFilial("ZZ1")+"' "
//cQry	+= " AND ZZ3_FILIAL = '"+xFilial("ZZ3")+"' "
cQry	+= " AND ZZ1_FILIAL = ZZ3_FILIAL  "
cQry	+= " AND ZZ1_SITE = ZZ3_CODIGO "
//cQry	+= " AND ZZ1_SITE = '0001' 

If Select("TM1") > 0
	dbSelectArea("TM1")
	dbCloseArea()
EndIf
TCQUERY cQry NEW ALIAS "TM1"
dbSelectArea("TM1")
dbGoTop()

while !eof()
     
	c1      := TM1->ZZ3_CODCLI
	c2      := TM1->ZZ3_LOJA
	c3      := TM1->ZZ1_SITE
	c4      := TM1->ZZ1_COD
	c5      := TM1->ZZ1_DESCRI
	ct      := c1+c2+c3+c4
	
	cQry1	:= "SELECT * " 
	cQry1	+= " FROM "+RetSqlName("CTD")+"  "
	cQry1	+= " WHERE CTD_ITEM   = '"+ct+"' " 
	cQry1	+= " AND   CTD_FILIAL = '"+xFilial("CTD")+"' "
	
	If Select("TM2") > 0
		dbSelectArea("TM2")
		dbCloseArea()
	EndIf
	TCQUERY cQry1 NEW ALIAS "TM2"
	dbSelectArea("TM2")
	dbGoTop()    
	if eof()
	   ccc := ct+" nao encontrou no CTD"
	   alert(ccc)                               
	   
       dbSelectArea("CTD")
	   Reclock("CTD",.t.)     
	   CTD->CTD_FILIAL 	:= xFilial("CTD")
	   CTD->CTD_ITEM    := ct
	   CTD->CTD_CLASSE  := "2"
	   CTD->CTD_DESC01  := c5
       MsUnLock()
	   dbSelectArea("TM2")
	   
	endif
	dbSelectArea("TM2")
	dbCloseArea()
	dbSelectArea("TM1")
	dbskip()
enddo
 
dbSelectArea("TM1")
dbCloseArea()

Return()

