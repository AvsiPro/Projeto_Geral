#INCLUDE "PROTHEUS.CH"
#INCLUDE "fileio.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function ROBCOM01

Local aArea		:=	GetArea() 
Private nHandle 
Private aPergs	:=	{}
Private aRet	:=	{}
Private cCodFor	:=	space(9)
Private cLojFor	:=	space(4)
Private nTaxCnv	:=	0
Private aAux	:=	{}  
Private aItens	:=	{}       
Private cPedido	:=	''

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0103")
ENDIF
      
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0104" MODULO "EST" TABLES "SA2/SC7"
//aOpcoes := { "Pedido Total", "Pedido Parcial" }//{ "Pedido Total", "Pedido Parcial", "Sem Pedido" }
//aAdd(aPergs ,{2,"Tipo de Importação"	,"Pedido Parcial",aOpcoes,50,".T.",.T.})	// Tipo de Importação
aAdd(aPergs ,{1,"Fornecedor"		,cCodFor  ,'',"","SA2","",50,.T.})
aAdd(aPergs ,{1,"Loja"				,cLojFor  ,'',"","","",20,.T.})    
aAdd(aPergs ,{1,"Taxa Conversão"	,nTaxCnv  ,'@E 9,999.9999999',"","","",70,.T.})
//aAdd(aPergs,{6,"Arquivo",padr('',090),"","FILE(mv_par02)","", 90 ,.T.,"Arquivo .CSV |*.CSV",'',GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
aAdd(aPergs,{6,"Arquivo",padr('',090),"","","", 90 ,.T.,"Arquivo .CSV |*.CSV",'',GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})

If !ParamBox(aPergs ,"Tipo de Importação",aRet)
	Return
else
	cCodFor := aRet[1]
	cLojFor := aRet[2]
EndIf

If validaarq(1)
	Processa( { ||Importa(),"Aguarde"})
EndIf

RestArea(aArea)

Return              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROBCOM01  ºAutor  ³Microsiga           º Data ³  06/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function validaarq(nOp)
   
//Validando o arquivo
nHandle := FT_FUse(AllTrim(aRet[if(nOp==1,4,5)])) 
FT_FGOTOP()
nPos := 0

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	nPos++
	//If nPos > 1
		//aAux    := StrTokArr(cLine,";")   
		aAux    := Separa(cLine,";")   
		If len(aAux) < 6
			MsgAlert("Arquivo inválido na linha "+cvaltochar(nPos))
			Return(.f.)
		EndIF     
		Aadd(aItens,aAux)
		DbSelectArea("SB1")
		DbSetOrder(1)
		If !Dbseek(xFilial("SB1")+Avkey(Alltrim(aAux[1]),"B1_COD"))
			MsgAlert("Produto informado na linha "+cvaltochar(nPos)+" inválido")
			Return(.f.)
		EndIf
	//EndIf
	
	FT_FSKIP()
End   

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROBCOM01  ºAutor  ³Microsiga           º Data ³  06/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Importa()

Local aCabec	:=	{}
Local aLinha	:=	{}
Local aItemPC	:=	{}   
Local aCabecNf 	:= 	{}		
Local aIteNF 	:= 	{}		
Local nX 
//Local cDoc		:=	GetSXEnum("S7","C7_NUM")

Private lMsErroAuto	:=	.F.
                  
For nX := 1 to len(aItens)
	aItens[nX,03] := strtran(aItens[nX,03],",",".")
	aItens[nX,04] := strtran(aItens[nX,04],",",".")
	aItens[nX,05] := strtran(aItens[nX,05],",",".")
Next nX      

//Pedido de Compra
aadd(aCabec,{"C7_EMISSAO" 	,dDataBase	})
aadd(aCabec,{"C7_FORNECE" 	,aRet[1]	})
aadd(aCabec,{"C7_LOJA" 		,aRet[2]	})
aadd(aCabec,{"C7_COND" 		,"001"		})
aadd(aCabec,{"C7_CONTATO"	,"AUTO"		})
aadd(aCabec,{"C7_FILENT"	,cFilAnt	})
                          
//Nota de Entrada
cDoc := ultnota() //GetSXenum("SF1","F1_DOC")
	
aadd(aCabecNf,{"F1_TIPO"   		,"N"})		
aadd(aCabecNf,{"F1_FORMUL" 		,"S"})		
aadd(aCabecNf,{"F1_DOC"    		,cDoc})		
aadd(aCabecNf,{"F1_SERIE"  		,"005"})		
aadd(aCabecNf,{"F1_EMISSAO"		,dDataBase})		
aadd(aCabecNf,{"F1_FORNECE"		,cCodFor})		
aadd(aCabecNf,{"F1_LOJA"   		,cLojFor})		
aadd(aCabecNf,{"F1_ESPECIE"		,"SPED"})		
aadd(aCabecNf,{"F1_COND"		,"001"})		
aadd(aCabecNf,{"F1_DESPESA"   	,0})				
aadd(aCabecNf,{"E2_NATUREZ"		,"21010001"})


//Itens Pedido de Compra
For nX := 1 To len(aItens)
	aLinha := {} 
	aadd(aLinha,{"C7_ITEM"		,STRZERO(NX,4)										,Nil})
	aadd(aLinha,{"C7_PRODUTO"	,aItens[nX,01]										,Nil})
	aadd(aLinha,{"C7_QUANT" 	,val(aItens[nX,02])									,Nil})
	aadd(aLinha,{"C7_X_VLEXT" 	,val(aItens[nX,03])									,Nil})
	aadd(aLinha,{"C7_X_FATOR" 	,aRet[3]											,Nil})
	aadd(aLinha,{"C7_PRECO" 	,val(aItens[nX,03])*aRet[3]							,Nil})
	aadd(aLinha,{"C7_TOTAL" 	,(val(aItens[nX,03])*aRet[3]) * val(aItens[nX,02]) 	,Nil})
	aadd(aLinha,{"C7_TES" 		,aItens[nX,07]										,Nil})
	aadd(aLinha,{"C7_X_ADIC"	,1													,Nil})
	aadd(aLinha,{"C7_X_SEQ"		,nX													,Nil})	
	aadd(aItemPC,aLinha)
Next nX 


aBkpIt := aClone(aItens)

MATA120(1,aCabec,aItemPC,3)

If !lMsErroAuto  
	cPedido := SC7->C7_NUM
	cmsgfinal := "Pedido de Compra incluído com sucesso! "+SC7->C7_NUM 
	
	aItens := aClone(aBkpIt)
	//Itens da Nota de Entrada
	For nX := 1 To len(aItens)
		aLinha := {}			
		aadd(aLinha,{"D1_DOC"  	,cDoc    									,Nil})
		aadd(aLinha,{"D1_ITEM"  ,STRZERO(Nx,4) 								,NIL})
		aadd(aLinha,{"D1_COD"  	,aItens[nX,01]								,Nil})			
		aadd(aLinha,{"D1_QUANT"	,val(aItens[nX,02])							,Nil})			
		aadd(aLinha,{"D1_VUNIT"	,val(aItens[nX,04])							,Nil})			
		aadd(aLinha,{"D1_TOTAL"	,val(aItens[nX,02]) * val(aItens[nX,04])	,Nil})			
		aadd(aLinha,{"D1_II"	,val(aItens[nX,05])							,Nil})			
		aadd(aLinha,{"D1_TES"	,aItens[nX,07]										,Nil})   
		aadd(aLinha,{"D1_ALIQII",val(aItens[nX,06])*100							,Nil})   
		//aadd(aLinha,{"D1_PEDIDO",cPedido									,Nil})
		//aadd(aLinha,{"D1_ITEMPC",strzero(nX,4)								,Nil})
		aadd(aIteNF,aLinha)		
	Next nX	   
	
	//Mat103(SC7->C7_NUM)              
	//U_Mat103(aRet[1],aRet[2],aRet[3]) 
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| mata140(x,y,z)},aCabecNf,aIteNF,3)		

	If !lMsErroAuto
		cMsgFinal += chr(13)+chr(10)+ "Nota de entrada gerada "+SF1->F1_DOC
		MsgAlert(cMsgFinal)
	Else
		MsgAlert("Erro na inclusao da nota de entrada!") 
		MOSTRAERRO()	
	EndIf	
	
Else
	MsgAlert("Erro na inclusao do pedido de Compra!")
	MostraErro()
EndIf

Return        


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROBCOM01  ºAutor  ³Microsiga           º Data ³  06/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Mat103(cForn,cLj,nFatr)  

Local aCabec := {}
Local aIteNF := {}
Local aLinha := {}
Local nX     := 0
//Local nY     := 0
Local cDoc   := ""
//Local lOk    := .T.   
//Private cDoc	:=	''
Private aPergs	:=	{}
Private aRet	:=	{}
Private cCodFor	:=	space(6)
Private cLojFor	:=	space(2)
Private nTaxCnv	:=	0
Private cPedido	:=	SPACE(6)
Private aAux	:=	{}  
Private aItens	:=	{}
Private lMsHelpAuto := .T.
lMsErroAuto := .F.
                            
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0104" MODULO "EST" TABLES "SA2/SC7"
If Empty(cPedido)
	aAdd(aPergs ,{1,"Fornecedor"		,cCodFor  ,'',"","SA2","",50,.T.})
	aAdd(aPergs ,{1,"Loja"				,cLojFor  ,'',"","","",20,.T.})    
	aAdd(aPergs ,{1,"Pedido"			,cPedido  ,'',"","","",20,.T.})    
	aAdd(aPergs ,{1,"Taxa Conversão"	,nTaxCnv  ,'@E 9,999.9999999',"","","",70,.T.})
	//aAdd(aPergs,{6,"Arquivo",padr('',090),"","FILE(mv_par02)","", 90 ,.T.,"Arquivo .CSV |*.CSV",'',GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
	aAdd(aPergs,{6,"Arquivo",padr('',090),"","","", 90 ,.T.,"Arquivo .CSV |*.CSV",'',GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
	
	If !ParamBox(aPergs ,"Tipo de Importação",aRet)
		Return
	else
		cCodFor := aRet[1]
		cLojFor := aRet[2]
		cPedido := aRet[3]
	EndIf 
	
	validaarq(2)

EndIf


aCabec := {}		
aIteNF := {}		

//cDoc := GetSXenum("SF1","F1_DOC")
cDoc := ultnota() //GetSXenum("SF1","F1_DOC")
	
aadd(aCabec,{"F1_TIPO"   		,"N"})		
aadd(aCabec,{"F1_FORMUL" 		,"S"})		
aadd(aCabec,{"F1_DOC"    		,cDoc})		
aadd(aCabec,{"F1_SERIE"  		,"005"})		
aadd(aCabec,{"F1_EMISSAO"		,dDataBase})		
aadd(aCabec,{"F1_FORNECE"		,cCodFor})		
aadd(aCabec,{"F1_LOJA"   		,cLojFor})		
aadd(aCabec,{"F1_ESPECIE"		,"SPED"})		
aadd(aCabec,{"F1_COND"			,"001"})		
aadd(aCabec,{"F1_DESPESA"   	,0})				
aadd(aCabec,{"E2_NATUREZ"		,"2.001.0006"})		
 
For nX := 1 to len(aItens)
	aItens[nX,03] := strtran(aItens[nX,03],",",".")
	aItens[nX,04] := strtran(aItens[nX,04],",",".")
	aItens[nX,05] := strtran(aItens[nX,05],",",".")
Next nX
	
For nX := 1 To len(aItens)
	aLinha := {}			
	aadd(aLinha,{"D1_DOC"  	,cDoc    									,Nil})
	aadd(aLinha,{"D1_ITEM"  ,STRZERO(Nx,4) 								,NIL})
	aadd(aLinha,{"D1_COD"  	,aItens[nX,01]								,Nil})			
	aadd(aLinha,{"D1_QUANT"	,val(aItens[nX,02])							,Nil})			
	aadd(aLinha,{"D1_VUNIT"	,val(aItens[nX,04])							,Nil})			
	aadd(aLinha,{"D1_TOTAL"	,val(aItens[nX,02]) * val(aItens[nX,04])	,Nil})			
	aadd(aLinha,{"D1_II"	,val(aItens[nX,05])							,Nil})			
	aadd(aLinha,{"D1_TES"	,"159"										,Nil})   
	aadd(aLinha,{"D1_ALIQII",val(aItens[nX,05])							,Nil})   
	//aadd(aLinha,{"D1_PEDIDO",cPedido									,Nil})
	//aadd(aLinha,{"D1_ITEMPC",strzero(nX,4)								,Nil})
	aadd(aIteNF,aLinha)		
Next nX	   

MSExecAuto({|x,y,z| mata140(x,y,z)},aCabec,aIteNF,3)		

If !lMsErroAuto
	Msgalert("Nota Gerada "+SF1->F1_DOC)		
Else
	ConOut(OemToAnsi("Erro na inclusao!"))	 
	MOSTRAERRO()	
EndIf	



Return(.T.)                        
            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROBCOM01  ºAutor  ³Microsiga           º Data ³  06/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ajutstenf()  

/*Local aCabec := {}
Local aIteNF := {}
Local aLinha := {}*/
Local nX     := 0
//Local nY     := 0
//Local cDoc   := ""
//Local lOk    := .T.   
//Private cDoc	:=	''
Private aPergs	:=	{}
Private aRet	:=	{}
Private cCodFor	:=	space(6)
Private cLojFor	:=	space(2)
Private nTaxCnv	:=	0
Private cPedido	:=	SPACE(9)
Private aAux	:=	{}  
Private aItens	:=	{}
Private lMsHelpAuto := .T.
lMsErroAuto := .F.
                            
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0104" MODULO "EST" TABLES "SA2/SC7"

aAdd(aPergs ,{1,"Fornecedor"		,cCodFor  ,'',"","SA2","",50,.T.})
aAdd(aPergs ,{1,"Loja"				,cLojFor  ,'',"","","",20,.T.})    
aAdd(aPergs ,{1,"Nota"			,cPedido  ,'',"","","",20,.T.})    
aAdd(aPergs ,{1,"Taxa Conversão"	,nTaxCnv  ,'@E 9,999.9999999',"","","",70,.T.})
//aAdd(aPergs,{6,"Arquivo",padr('',090),"","FILE(mv_par02)","", 90 ,.T.,"Arquivo .CSV |*.CSV",'',GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
aAdd(aPergs,{6,"Arquivo",padr('',090),"","","", 90 ,.T.,"Arquivo .CSV |*.CSV",'',GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})

If !ParamBox(aPergs ,"Tipo de Importação",aRet)
	Return
else
	cCodFor := aRet[1]
	cLojFor := aRet[2]
	cPedido := aRet[3]
EndIf
validaarq()

For nX := 1 to len(aItens)
	aItens[nX,03] := strtran(aItens[nX,03],",",".")
	aItens[nX,04] := strtran(aItens[nX,04],",",".")
	aItens[nX,05] := strtran(aItens[nX,05],",",".")
Next nX     

DbSelectArea("SD1")
DbSetOrder(22)
                                
For nX := 1 to len(aItens)
	If DbSeek(xFilial("SD1")+'131438'+strzero(nX,4))
    	Reclock("SD1",.F.)
    	SD1->D1_II := val(aItens[nX,05])
    	SD1->(Msunlock())
 	EndIf
Next nX

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROBCOM01  ºAutor  ³Microsiga           º Data ³  06/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ultnota

Local cQuery
Local cRet		:=	''
Local aAux		:=	{}

cQuery := "SELECT MAX(D2_DOC) AS SAIDA,'S' AS TIPO"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " WHERE D2_FILIAL='"+xFilial("SD2")+"' AND D2_SERIE='005' AND D2.D_E_L_E_T_=''"
cQuery += " UNION"
cQuery += " SELECT MAX(D1_DOC) AS SAIDA,'E' AS TIPO"
cQuery += " FROM "+RetSQLName("SD1")+" D1"
cQuery += " WHERE D1_FILIAL='"+xFilial("SD1")+"' AND D1_SERIE='005' AND D1.D_E_L_E_T_='' AND D1_DOC LIKE '0%' AND D1_FORMUL='S'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf       

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

While !Eof()
	Aadd(aAux,{TRB->SAIDA,TRB->TIPO})
	DbSkip()
EndDo

Asort(aAux,,,{|x,y| x[1]>y[1]})
                               
cRet := strzero(val(aAux[1,1])+1,9)

Return(cRet)
