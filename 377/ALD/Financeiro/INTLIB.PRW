#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "APWEBSRV.CH"                                                                                                                                                   

//****************************************************************************
// USER FUNCTION PARA COPIA DE TES
//****************************************************************************
User Function fCopiaSF4()
Local nI		:= 0
Local cQuery	:= ""
Local aStruct	:= {} 
Local cCod 		:= SF4->F4_CODIGO
Local cCodNew, cFilNew
local nRecno:=SF4->(RecNo())

	If xFilial("SF4") # SF4->F4_FILIAL .or. (SF4->(EOF()) .and. SF4->(BOF()))
		HELP(" ",1,"ARQVAZIO")
		Return(.F.)
	Endif
	
	ValidPerg('COPYTES')
	Pergunte("COPYTES",.T.)
	cCodNew:=PadR(MV_PAR01,(TamSX3("F4_CODIGO")[1]))
	cFilNew:=PadR(MV_PAR02,(TamSX3("F4_FILIAL")[1]))
	
	if Alltrim(cCodNew) ==''
		Aviso("Finalizado","Processo finalizado sem alterações" ,{'Ok'})
		Return(.f.)
	endif
	
	nRecno:=SF4->(RecNo())
	
	dbSelectArea("SF4")
	SF4->( DbSetOrder(1) )
	If (MsSeek(cFilNew+cCodNew ))
		Aviso("Atenção...","Código de TES (" + cCodNew + ") ja existente para a filial " + cFilNew ,{'Ok'})
		Return(.f.)
	endif
	
	SF4->(dbgoto(nRecno))
	
	If (SF4->F4_TIPO == 'E' .and. cCodNew > '500') .or. (SF4->F4_TIPO == 'S' .and. cCodNew <= '500')
		HELP(" ",1,"F4_TIPO")
		Return(.F.)
	Endif
	
	SF4->( DbSetOrder(1) )
	If SF4->( MsSeek( xFilial("SF4")+cCod ) )
		aStruct	:= SF4->( DbStruct() )
		cQuery :=	" SELECT * " +;
					" FROM " + RetSqlName("SF4")+;
					" WHERE F4_FILIAL = '" + xFilial("SF4") + "' AND " +;
					"       F4_CODIGO = '" + cCod + "' AND " +;
					"       D_E_L_E_T_ = ' ' "
		PLSQuery( cQuery, "SF4TMP" )
		If SF4TMP->( !Eof() )
			SF4->( RecLock("SF4", .T.) )
			For nI := 1 To Len(aStruct)
				If SF4->(FieldPos(aStruct[nI,1])) > 0 .AND. SF4TMP->(FieldPos(aStruct[nI,1])) > 0
					&("SF4->"+aStruct[nI][1]) := &("SF4TMP->"+aStruct[nI][1])
				Endif
			Next nI
			SF4->F4_FILIAL := cFilNew
			SF4->F4_CODIGO := cCodNew
			SF4->( MsUnLock() )
		Else
			Return(.F.)
		Endif
		SF4TMP->( DbCloseArea() )
	Endif
	Aviso("Finalizado","Processo finalizado" ,{'Ok'})
Return(.T.)

//****************************************************************************
// PERGUNTAS PARA COPIA DE TES
//****************************************************************************
Static Function ValidPerg(cPerg)
Local _sAlias,i,j
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	aRegs:={}                                                  
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/f3
	AADD(aRegs,{cPerg,"01","Nova TES","","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Filial  ","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		EndIf
	Next
	dbSelectArea(_sAlias)
Return

//************************************************************************
// ROTINA PARA CRIAÇÃO DOS ITENS CONTABEIS COM BASE NO CLIENTES EXISTENTES
//************************************************************************
User Function IMPITCLI
Local aArea  := GetArea()
Local lRet   := .T.
	dbSelectarea("SA1")
	set filter to A1_FILIAL == xFilial('SA1')
	dbSetOrder(1)
	While !Eof()
		dbSelectarea("CTD")
		dbSetOrder(1)
		If !dbSeek(xFilial("CTD")+'C'+SA1->A1_COD+SA1->A1_LOJA)             
			RecLock("CTD",.T.)
			CTD->CTD_FILIAL := XFILIAL("CTD")
			CTD->CTD_ITEM  := 'C'+SA1->A1_COD+SA1->A1_LOJA
			CTD->CTD_DESC01 := SA1->A1_NOME
			CTD->CTD_CLASSE := "2"
			CTD->CTD_NORMAL := "0"
			CTD->CTD_BLOQ   := "2"
			CTD->CTD_DTEXIS := CTOD("01/01/2000")
			CTD->CTD_ITLP   := 'C'+SA1->A1_COD+SA1->A1_LOJA
			CTD->CTD_CLOBRG := "2"
			CTD->CTD_ACCLVL := "1"
			MsUnLock()
		End if
		dbSelectarea("SA1")
		dbSkip()
	end
	RestArea(aArea)       
	U_IMPITFOR()
Return ( lRet )

//****************************************************************************
// ROTINA PARA CRIAÇÃO DOS ITENS CONTABEIS COM BASE NO FORNECEDORES EXISTENTES
//****************************************************************************
User Function IMPITFOR
Local aArea  := GetArea()
Local lRet   := .t.
	dbSelectarea("SA2")
	set filter to A2_FILIAL == xFilial('SA2')
	dbSetOrder(1)
	While !Eof()
		dbSelectarea("CTD")
		dbSetOrder(1)
		If !dbSeek(xFilial("CTD")+'F'+SA2->A2_COD+SA2->A2_LOJA)
			RecLock("CTD",.T.)
			CTD->CTD_FILIAL := XFILIAL("CTD")
			CTD->CTD_ITEM  := 'F'+SA2->A2_COD+SA2->A2_LOJA
			CTD->CTD_DESC01 := SA2->A2_NOME
			CTD->CTD_CLASSE := "2"
			CTD->CTD_NORMAL := "0"
			CTD->CTD_BLOQ   := "2"
			CTD->CTD_DTEXIS := CTOD("01/01/2000")
			CTD->CTD_ITLP   := 'F'+SA2->A2_COD+SA2->A2_LOJA
			CTD->CTD_CLOBRG := "2"
			CTD->CTD_ACCLVL := "1"
			MsUnLock()
		End if
		dbSelectarea("SA2")
		dbSkip()
	end
	RestArea(aArea)
	Msginfo("Importação Item Contábil Executado com Sucesso!!!!")
Return ( lRet )                   

//***********************************************************************************************************
// ROTINA PARA INICIALIZADOR DO CAMPO DESCRICAO FORNECEDOR/CLIENTE NO BROWSE DOS DOCUMENTOS DE ENTRADA
//***********************************************************************************************************       
User Function INICDEV()
Local cResult	       

	cResult := IIF(SF1->F1_TIPO<>"D",;
		POSICIONE("SA2",1,XFILIAL("SA2")+SF1->(F1_FORNECE+F1_LOJA),"A2_NOME"),;
		POSICIONE("SA1",1,XFILIAL("SA1")+SF1->(F1_FORNECE+F1_LOJA),"A1_NOME")) 
	
Return cResult

//***********************************************************************************************************
// COMPLETA O NUMERO DA NOTA FISCAL DE ENTRADA COM ZEROS A ESQUERDA
//***********************************************************************************************************
USER FUNCTION SF1DOC()   
	If !Empty(M->F1_DOC) .Or. !Empty(cNFISCAL)
	   M->F1_DOC := StrZero(Val(M->F1_DOC),9)
	   CNFISCAL := M->F1_DOC
	Endif   
Return(.T.)

//***********************************************************************************************************
// FUNÇÃO UTILIZADA NO INICIALIZADOR PADRÃO DO CAMPO D1_X_DESCP
//***********************************************************************************************************
User Function DESCVIS(nOp)

	dbSelectArea("SB1")
	dbSetOrder(1)	
	dbGoTop()
	If nOp == 1
		dbSeek(xFilial("SB1")+SD1->D1_COD)
	Else
		dbSeek(xFilial("SB1")+M->D1_COD)
	EndIf
	Iret := SB1->B1_DESC
	
Return Iret   


//*******************************************************************************
//CONTROLA A QUANTIDADE DE CARACTERES PERMITIDA NO HISTORICO DAS REGRAS CONTABEIS
//*******************************************************************************
User Function Hi(cHistorico)
Local nQtd := GetMv("MV_X_HISTO") 

	cHistorico:=SubStr(AllTrim(cHistorico),1,nQtd)
	
Return(cHistorico) 

//*******************************************************************************
//HISTORICO DA REGRA 530-001
//*******************************************************************************
User Function Hist530001()
Local cHistorico := ""
    
	If AllTrim(SED->ED_CODIGO)="209012"
		cHistorico:=U_HI("VL PAG " + ALLTRIM(SE5->E5_MOTBX)+" "+ALLTRIM(SE2->E2_TIPO)+" "+ALLTRIM(STR(VAL(SE2->E2_NUM))+'-'+ALLTRIM(SE2->E2_PREFIXO)+'/'+ALLTRIM(SE2->E2_PARCELA))+', '+SED->ED_DESCRIC)                       
	Else
		cHistorico:=U_HI("VL PAG " + ALLTRIM(SE5->E5_MOTBX)+" "+ALLTRIM(SE2->E2_TIPO)+" "+ALLTRIM(STR(VAL(SE2->E2_NUM))+'-'+ALLTRIM(SE2->E2_PREFIXO)+'/'+ALLTRIM(SE2->E2_PARCELA))+', '+SA2->A2_NOME)                       
	EndIf
	
Return(cHistorico) 

//***************************************************
//ROTINA PARA LIMPAR OS FLAGS DE CONTABILIZAÇÃO
//***************************************************
User Function LimpaCtb()
Local cPerg:="PERGCTB000"
Local _sAlias := Alias()
Local aRegs:={}
Local j:=0, i:=0, ix:=0

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	AADD(aRegs,{cPerg,"01","Modulo       :","Espanhol","Ingles","mv_ch1","N",1,0,0,"C","","mv_par01","Compras  ","","","","","Faturamento  ","","","","","Financeiro","","","","",""})
	AADD(aRegs,{cPerg,"02","Data de      :","Espanhol","Ingles","mv_ch2","D",8,0,0,"G","","mv_par02","","","","'"+DTOC(dDataBase)+"'","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Data ate     :","Espanhol","Ingles","mv_ch3","D",8,0,0,"G","","mv_par03","","","","'"+DTOC(dDataBase)+"'","","","","","","","","","","","","","","","","","","","","","",""})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
		Else
			RecLock("SX1",.F.)
		EndIf
		
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
		dbCommit()
	Next
	dbSelectArea(_sAlias)
	
	If Pergunte(cPerg,.t.)
		aFrase := {}
		aErros := {}
		cApaga := ""
		Do Case
			Case mv_par01 == 1
				// COMPRAS
				
				AADD(aFrase,"UPDATE "+RetSqlName("SF1")+" SET F1_DTLANC = '' WHERE F1_DTDIGIT BETWEEN '" +Dtos(mv_par02)+ "' AND '"+Dtos(mv_par03)+"' AND F1_FILIAL = '" + xFilial("SF1") + "'")
				cApaga := "UPDATE "+RetSqlName("CT2")+" SET D_E_L_E_T_ = '*' WHERE CT2_DATA BETWEEN '"+Dtos(mv_par02)+"' AND '"+Dtos(mv_par03)+"' AND CT2_FILIAL = '" + xFilial("CT2") + "' AND CT2_LOTE = '008810' "
				
			Case mv_par01 == 2
				// FATURAMENTO
				AADD(aFrase,"UPDATE "+RetSqlName("SF2")+" SET F2_DTLANC = '' WHERE F2_EMISSAO BETWEEN '" +Dtos(mv_par02)+ "' AND '"+Dtos(mv_par03)+"' AND F2_FILIAL = '" + xFilial("SF2") + "'")
				cApaga := "UPDATE "+RetSqlName("CT2")+" SET D_E_L_E_T_ = '*' WHERE CT2_DATA BETWEEN '"+Dtos(mv_par02)+"' AND '"+Dtos(mv_par03)+"' AND CT2_FILIAL = '" + xFilial("CT2") + "' AND CT2_LOTE = '008820' "
				
			Case mv_par01 == 3
				// FINANCEIRO            
				AADD(aFrase,"UPDATE "+RetSqlName("SE1")+" SET E1_LA = '' WHERE E1_EMISSAO BETWEEN '"+Dtos(mv_par02)+"' AND '"+Dtos(mv_par03)+"' AND E1_FILIAL = '" + xFilial("SE1") + "' AND SUBSTRING(E1_ORIGEM,1,3)='FIN' ")
				AADD(aFrase,"UPDATE "+RetSqlName("SE2")+" SET E2_LA = '' WHERE E2_EMIS1 BETWEEN '"+Dtos(mv_par02)+"' AND '"+Dtos(mv_par03)+"' AND E2_FILIAL = '" + xFilial("SE2") + "' AND SUBSTRING(E2_ORIGEM,1,3)='FIN'")
				AADD(aFrase,"UPDATE "+RetSqlName("SE5")+" SET E5_LA = '', E5_LOTE='' WHERE E5_DATA  BETWEEN '"+Dtos(mv_par02)+"' AND '"+Dtos(mv_par03)+"' AND E5_FILIAL = '" + xFilial("SE5") + "' ")
				AADD(aFrase,"UPDATE "+RetSqlName("SEF")+" SET EF_LA = '' WHERE EF_DATA BETWEEN '"+Dtos(mv_par02)+"' AND '"+Dtos(mv_par03)+"' AND EF_FILIAL = '" + xFilial("SEF") + "'")
				cApaga := "UPDATE "+RetSqlName("CT2")+" SET D_E_L_E_T_ = '*' WHERE CT2_DATA BETWEEN '"+Dtos(mv_par02)+"' AND '"+Dtos(mv_par03)+"' AND CT2_FILIAL = '" + xFilial("CT2") + "' AND CT2_LOTE = '008850' "
		EndCase
	
		// PARA O AJUSTE SQL
		For i := 1 To len(aFrase)
			nResult := TCSQLEXEC(aFrase[i])
			If nResult <> 0
				cErro   := " Erro:"+TCSqlError()
				AADD(aErros,cErro)
			Else
				cErro := ""
			EndIf
		Next
		
		nResult := TCSQLEXEC(cApaga)
		If nResult <> 0
			cErro   := " Erro:"+TCSqlError()
			AADD(aErros,cErro)
		Else
			cErro := ""
		EndIf
		
		If nResult == 0
			MsgInfo("Comando Executado com Sucesso! Executar Reprocessamento! ")
		Else
			If Len(aErros)>0
				cLog := ""
				For ix := 1 to Len(aErros)
					cLog += (aErros[ix]+chr(10)+chr(13))
				Next
				@ 116,090 To 416,707 Dialog oDlgMemo Title "Ocorrencias"
				@ 001,005 Get cLog   Size 300,120  MEMO                 Object  oMemo
				@ 137,10+5*50 Button OemToAnsi("_Fechar")   Size 35,14 Action Close(oDlgMemo)
				Activate Dialog oDlgMemo
			EndIf
		
			MsgInfo("Falha no Comando! Retorno "+Str(nResult)+cErro)
		EndIf
	EndIf
Return nil    

//**********************************************************************************************************************************
// LAYOUT CNAB HSBC
//**********************************************************************************************************************************
User Function CNABHSBC()
Local cRet := ""
	                
   //	cRet := SUBS(SEE->EE_AGENCIA,1,4)+SUBS(SEE->EE_CONTA,1,7)+SEE->EE_DVCTA
	cRet := AllTrim(SEE->EE_AGENCIA)+AllTrim(SEE->EE_CONTA)+AllTrim(SEE->EE_DVCTA)+"0"

Return cRet       

//*******************************************************************************
//TRATA AS ESCOLHAS DE CONTA CONTABIL CASO A PRIMEIRA NÃO EXISTA - DEBITO
//*******************************************************************************
User Function VerDCtb(cConta1,cConta2,cConta3,cConta4,cConta5)
Local cConta:=""

	cConta1:=If(cConta1=Nil,"",cConta1)
	cConta2:=If(cConta2=Nil,"",cConta2)
	cConta3:=If(cConta3=Nil,"",cConta3)
	cConta4:=If(cConta4=Nil,"",cConta4)
	cConta5:=If(cConta5=Nil,"",cConta5)
	If Empty(cConta1)
		If Empty(cConta2)
			If Empty(cConta3)
				If Empty(cConta4)
					If !Empty(cConta5)
						cConta:=cConta5
					EndIf
				Else
					cConta:=cConta4
				EndIf
			Else
				cConta:=cConta3
			EndIf
		Else
			If Alltrim(cConta2) == "ED_COM"
				DbSelectArea("SE2")
				DbSetOrder(6)
				If Dbseek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
					cConta2 := Posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"ED_CONTA")
				EndIf
			EndIf
			cConta:=cConta2                            
		EndIf
	Else
		cConta:=cConta1
	EndIf
	
	//SE NÃO EXISTIR NENHUMA DAS CONTAS, INFORMA UMA CONTA DEBITO A CLASSIFICAR
	If AllTrim(cConta)==""
		cConta:="310100200004"		
	EndIF
	
Return(cConta)

//*******************************************************************************
//TRATA AS ESCOLHAS DE CONTA CONTABIL CASO A PRIMEIRA NÃO EXISTA - CREDITO
//*******************************************************************************
User Function VerCCtb(cConta1,cConta2,cConta3,cConta4,cConta5)
Local cConta:=""

	cConta1:=If(cConta1=Nil,"",cConta1)
	cConta2:=If(cConta2=Nil,"",cConta2)
	cConta3:=If(cConta3=Nil,"",cConta3)
	cConta4:=If(cConta4=Nil,"",cConta4)
	cConta5:=If(cConta5=Nil,"",cConta5)
	If Empty(cConta1)
		If Empty(cConta2)
			If Empty(cConta3)
				If Empty(cConta4)
					If !Empty(cConta5)
						cConta:=cConta5
					EndIf
				Else
					cConta:=cConta4
				EndIf
			Else
				cConta:=cConta3
			EndIf
		Else
			cConta:=cConta2                            
		EndIf
	Else
		cConta:=cConta1
	EndIf
	
	//SE NÃO EXISTIR CONTA CREDITO, INFORMA UMA CONTA A CLASSIFICAR
	If AllTrim(cConta)==""
		cConta:="310100100009"		
	EndIF	
	
Return(cConta) 

//******************                 
//ENDEREÇO DO SACADO
//******************                 
User Function xEndSac(nTam)
Local xRetorno:=""
	
	xRetorno:=SubStr(If(AllTrim(SA1->A1_ENDCOB)<>"",AllTrim(SA1->A1_ENDCOB),AllTrim(SA1->A1_END)),1,nTam)
	
Return(xRetorno)       

//******************                 
//BAIRRO DO SACADO
//******************                 
User Function xBaiSac(nTam)
Local xRetorno:=""
	
	xRetorno:=SubStr(If(AllTrim(SA1->A1_BAIRROC)<>"",AllTrim(SA1->A1_BAIRROC),AllTrim(SA1->A1_BAIRRO)),1,nTam)
	
Return(xRetorno)                                                              

//******************                 
//CEP DO SACADO
//******************                 
User Function xCepSac(nTam)
Local xRetorno:=""
	
	xRetorno:=SubStr(If(AllTrim(SA1->A1_CEPC)<>"",AllTrim(SA1->A1_CEPC),AllTrim(SA1->A1_CEP)),1,nTam)
	
Return(xRetorno)                                                              


//******************                 
//MUNICIPIO DO SACADO
//******************                 
User Function xMunSac(nTam)
Local xRetorno:=""
	
	xRetorno:=SubStr(If(AllTrim(SA1->A1_MUNC)<>"",AllTrim(SA1->A1_MUNC),AllTrim(SA1->A1_MUN)),1,nTam)
	
Return(xRetorno)                                                                                


//******************                 
//ESTADO DO SACADO
//******************                 
User Function xUFSac(nTam)
Local xRetorno:=""
	
	xRetorno:=SubStr(If(AllTrim(SA1->A1_ESTC)<>"",AllTrim(SA1->A1_ESTC),AllTrim(SA1->A1_EST)),1,nTam)
	
Return(xRetorno)            

//***********************************************
// Numero do documento
//***********************************************   
User Function Nrodoc()
local xResult := ''

	If SE1->E1_PORTADO == "777"
		xResult := cvaltochar(val(SE1->E1_NUM))
		If !Empty(SE1->E1_PARCELA)
			xResult += "-"+cvaltochar(val(SE1->E1_PARCELA))
		EndIf 
	Else 
		xResult := IF(Alltrim(SE1->E1_NUMNOTA)<>"",Alltrim(SE1->E1_NUMNOTA)+'/'+Subs(SE1->E1_PARCELA,3,1),SE1->E1_NUM+substr(SE1->E1_PARCELA,3,1))
	EndIf 

Return xResult

//***********************************************
// Numero do documento Completo
//***********************************************   
User Function NroComp(nTam)
local xResult := ''
    
	xResult := Alltrim(SE1->E1_IDCNAB) + " "
	xResult += "DOC."+Alltrim(SE1->E1_NUM) + " "
	If !Empty(SE1->E1_PARCELA)
		xResult += "-"+Alltrim(SE1->E1_PARCELA)
	EndIf
	xResult:=Subs(xResult,1,nTam)
	
Return xResult

//Usado para compor o campo numero do documento e nosso numero do uniprime.
User Function NDocSeq(cTam)
local xResult 	:= ''
Local nLen		:= 0
    
	xResult := AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)
	nLen	:=Len(xResult)+1
	If nLen > cTam
		xResult := SubStr(xResult,nLen-cTam,cTam)
	EndIf
	
	xResult:=StrZero(Val(xResult),cTam)

Return(xResult)  
  

User Function Nrkobold()
local xResult := ''
    
	xResult := substr(Alltrim(SE1->E1_NUM),3,7)+Alltrim(SE1->E1_PARCELA)
	
Return xResult 

//***********************************************
// Sequencial do Codigo de Fornecedor
//***********************************************
User Function ProxSA2()
 
local cArea:=alias()
local cQuery
local cProx:=''
 
	if select("QryTGH") > 0
 		QryTGH->(dbCloseArea())
	endif
               
	cQuery := "SELECT MAX(A2_COD) AS IDENT FROM "+RetSqlName("SA2")
	cQuery += "  WHERE D_E_L_E_T_<>'*'                   AND "
	cQuery += "  A2_COD    BETWEEN '000000' AND '999999' AND "
	cQuery += "  A2_FILIAL = '"+XFILIAL("SA2")+"'"
 
	TcQuery cQuery new alias "QryTGH"
 
	if QryTGH->IDENT == nil
 		cProx := '000001'
	else
 		cProx := strzero(val(QryTGH->IDENT)+1,6)
	endif                    
 
	QryTGH->(DbCloseArea())
 
	dbSelectArea(cArea)

return cProx 
             
//**********************************************************
//CHAMA A TELA DE CADASTRO DO PLANO DE CATEGORIA DO PRODUTO
//**********************************************************
User Function xPlanoCat()
PRIVATE cCadastro  := "Plano de Categoria do Produto"

	AxCadastro("SZ1", OemToAnsi(cCadastro))
 
Return            

//*****************************************************************************
//CHAMA A TELA DE CADASTRO DO PLANO DE PACOTES - PARA AMARRAR COM A TABELA CT1
//*****************************************************************************
User Function xPlanoPac()
PRIVATE cCadastro  := "Plano de Pacotes"

	AxCadastro("SZ0", OemToAnsi(cCadastro))
 
Return            

//**********************************************************
// PREENCHE INFORMACOES DE LAYOUTS DE CNAB
//**********************************************************
User function RVFILECNAB() 
 
Local aArea := getarea()
Local cFunc := FunName()          
                 
dbSelectArea('SEE')
dbSetOrder(1)
 
Do Case
	Case cFunc == "FINR650" //Relatório de retorno de cnab 
 		If !dbSeek(xFilial('SEE') + PADR(MV_PAR03,TAMSX3('EE_CODIGO')[1]) + PADR(MV_PAR04,TAMSX3('EE_AGENCIA')[1]) + PADR(MV_PAR05,TAMSX3('EE_CONTA')[1]) + PADR(MV_PAR06,TAMSX3('EE_SUBCTA')[1]))
   			msgInfo('Parametro de banco não encontrado. Tabela SEE.')
      	Else       
      		//MV_PAR01 := EE_X_ARQENT //ARQUIVO DE ENTRADA
        	MV_PAR02 := EE_X_RET //CONFIGURAÇÃO ENTRADA
         	//MV_PAR07 := val(EE_X_CARTEI) //PAGAR/RECEBER
          	MV_PAR08 := val(EE_X_MODEL) //MODELO1/MODELO2                                                      
        Endif    
                                              
	case cFunc == "FINA200" //Retorno de cnab de cobrança
 		If !dbSeek(xFilial('SEE') + PADR(MV_PAR06,TAMSX3('EE_CODIGO')[1]) + PADR(MV_PAR07,TAMSX3('EE_AGENCIA')[1]) + PADR(MV_PAR08,TAMSX3('EE_CONTA')[1]) + PADR(MV_PAR09,TAMSX3('EE_SUBCTA')[1]))
   			msgInfo('Parametro de banco não encontrado. Tabela SEE.')
      	Else       
      		//MV_PAR04 := EE_X_ARQENT //ARQUIVO DE ENTRADA
       		MV_PAR05 := EE_X_RET //CONFIGURAÇÃO ENTRADA
         	MV_PAR12 := val(EE_X_MODEL) //MODELO1/MODELO2                                                      
        Endif
                                              
   	case cFunc == "FINA150" //Remessa de cnab de cobrança
 		If !dbSeek(xFilial('SEE') + PADR(MV_PAR05,TAMSX3('EE_CODIGO')[1]) + PADR(MV_PAR06,TAMSX3('EE_AGENCIA')[1]) + PADR(MV_PAR07,TAMSX3('EE_CONTA')[1]) + PADR(MV_PAR08,TAMSX3('EE_SUBCTA')[1]))
   			msgInfo('Parametro de banco não encontrado. Tabela SEE.')
      	Else       
       		MV_PAR03 := EE_X_REM //CONFIGURAÇÃO SAIDA
         	//MV_PAR04 := EE_X_ARQSAI //ARQUIVO SAIDA
          	MV_PAR09 := val(EE_X_MODEL) //MODELO1/MODELO2                                                      
 		Endif                                    
EndCase            
               
RestArea(aArea)            
 
Return(.t.)
               
//********************************************************************
// (TESTE) DATA DE SAIDA NA DANFE DIFERENTE DA DATA DE EMISSAO
//********************************************************************   
User Function DTSAIDA()

Private oDlg
Private oButton1
Private oGet1
Private cGet1 := Date()
Private oGroup1
Private oSay1
Private oSay2
Private bStatus	:= .T.

	While bStatus

		DEFINE MSDIALOG oDlg TITLE "Data de saida" FROM 000, 000 TO 160, 350 COLORS 0, 16777215 PIXEL

		@ 004, 003 GROUP oGroup1 TO 052, 168 PROMPT " Data de saida da NF " OF oDlg COLOR 0, 16777215 PIXEL
		@ 016, 009 SAY oSay1 PROMPT "Informe no campo abaixo a data de saida da nota fiscal de numero " SIZE 153, 020 OF oDlg COLORS 0, 16777215 PIXEL
		@ 035, 009 SAY oSay2 PROMPT "Data de saida" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 033, 045 MSGET oGet1 VAR cGet1 SIZE 113, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 059, 130 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oDlg PIXEL Action(Confirmar())

		ACTIVATE MSDIALOG oDlg CENTERED

		If bStatus
			Alert("Operação não permitida...")

		Endif

	Enddo

Return cGet1

Static Function Confirmar

	oDlg:End()
	bStatus:=.F.

Return        
                                              
//****************************************************************
// Data limite para desconto financeiro nos layouts CNAB Modelo 1
//****************************************************************
User Function DtDesc()
local xResult, xData, xAno
    
	xData := dToS(SE1->E1_VENCREA)
	xAno := Substr(xData,3,2)
	xResult := SE1->(STRZERO(DAY(E1_VENCREA),2)+STRZERO(MONTH(E1_VENCREA),2)+Alltrim(xAno))

Return xResult 
                                                           
//**********************************************************
// CALCULA O VALOR LIQUIDO DE UM TITULO
//**********************************************************
User Function xVlLiq()
Local nValor:=0

	If SE1->E1_VALOR <> SE1->E1_SALDO  
		//SE O VALOR DO SALDO É DIFERENTE DO VALOR ORIGINAL, É PORQUE ELE JÁ SOFREU UMA BAIXA PARCIAL, E NESTA BAIXA PARCIAL O DESCONTO JÁ FOI APLICADO
		//POR ESTE MOTIVO ENVIA SOMENTE O VALOR DO SALDO PRESUMINDO QUE O DESCONTO JÁ OCORREU NA PRIMEIRA BAIXA.
		nValor:=SE1->E1_SALDO	
	Else                     
		If SE1->E1_DESCFIN == 0
			//SE NÃO TEM DESCONTO FINANCEIRO, ENVIA SOMENTE O VALOR DO SALDO 
			nValor:=SE1->E1_SALDO
		Else                                                                
			//SE TEM DESCONTO FINANCEIRO, EFETUA O CALCULO DO DESCONTO E ENVIA APENAS O VALOR LIQUIDO
			nValor:=SE1->E1_SALDO - ((SE1->E1_SALDO * SE1->E1_DESCFIN) / 100)
		EndIf
	EndIF
	
	IF SE1->E1_ACRESC > 0
		nValor+=SE1->E1_ACRESC
	EndIf

Return(nValor)                                        

//************************************************************
//CHAMA A TELA DE CADASTRO DE NUMERO DE SERIE PRODUTO ROUBADO
//************************************************************
User Function xProdRb()
PRIVATE cCadastro  := "Produtos Roubados"

	AxCadastro("SZ5", OemToAnsi(cCadastro))
 
Return   

 
//***************************************************************
// Verifica se o Nro. de Serie esta cadastrado como roubado (SZ5)
//***************************************************************
User FUNCTION VerNro(cNro)

LOCAL lRet := .T.

	IF ExistCpo("SZ5", cNro)
		MsgAlert("Número de Série cadastrado como produto roubado")
		lRet := .F. 
	ENDIF

RETURN lRet     

                                            
//***************************************************************
// Ponto de Entrada Validação TudoOk Orcamento Tecnico (AB2)
//***************************************************************
/*User Function AT400TOK()

	/*LOCAL lRet := .T.
    
  	IF ExistCpo("SZ5",aCols[n][4])
		MsgAlert("Número de Série cadastrado como produto roubado")
		lRet := .F. 
	ENDIF
	
	    
Return lRet
*/ 	

//***********************************************************************
//IMPRIMIR A RAZAO SOCIAL NO CADASTRO CONFORME A TABELA INFORMADA
//***********************************************************************
User Function xRazao(cxTabela)
Local sxRazao:=""                 
                      
	If cxTabela=="SF1"
		If AllTrim(SF1->F1_TIPO) $ "DB"
			sxRazao:=POSICIONE("SA1",1,SUBSTR(SF1->F1_FILIAL,1,2)+SPACE(2)+SF1->(F1_FORNECE+F1_LOJA),"A1_NOME")
		Else
			sxRazao:=POSICIONE("SA2",1,SUBSTR(SF1->F1_FILIAL,1,2)+SPACE(2)+SF1->(F1_FORNECE+F1_LOJA),"A2_NOME")                                                           						                                                           
		EndIf                                                                      

	ElseIf cxTabela=="SF2"
		If AllTrim(SF2->F2_TIPO) $ "DB"
			sxRazao:=POSICIONE("SA2",1,SUBSTR(SF2->F2_FILIAL,1,2)+SPACE(2)+SF2->(F2_CLIENTE+F2_LOJA),"A2_NOME")                                                           			
		Else
			sxRazao:=POSICIONE("SA1",1,SUBSTR(SF2->F2_FILIAL,1,2)+SPACE(2)+SF2->(F2_CLIENTE+F2_LOJA),"A1_NOME")                                                           
		EndIf                                                                      
	ElseIf cxTabela=="SC5"
		If AllTrim(SC5->C5_TIPO) $ "DB"
			sxRazao:=POSICIONE("SA2",1,SUBSTR(SC5->C5_FILIAL,1,2)+SPACE(2)+SC5->(C5_CLIENTE+C5_LOJACLI),"A2_NOME")                                                           			
		Else
			sxRazao:=POSICIONE("SA1",1,SUBSTR(SC5->C5_FILIAL,1,2)+SPACE(2)+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME")                                                           
		EndIf	 
    EndIf

Return(sxRazao)       
    
//*********************************************
//GERA LOTE PARA PRODUTOS COM CONTROLE DE LOTE
//********************************************* 
//CHAMADA POR GATILHO NO CAMPO D3_COD
User Function GeraLote()
Local strLote:=""                              
Local strAno:=YEAR(M->D3_EMISSAO)
Local nDiasAno:=0 
Local nDia:=0
//Local strHora:=TIME()
//Local strControla:=POSICIONE("SB1",1,SUBSTR(CFILANT,1,2)+SPACE(2)+M->D3_COD,"B1_RASTRO")
	
	If cFilAnt == "0107" .AND. M->D3_TM=="100"
		nDiasAno:=DateDiffDay(Ctod("01/01/"+Str(strAno)),Ctod("31/12/"+Str(strAno)))
		nDia:= 1 + nDiasAno - DateDiffDay(M->D3_EMISSAO,Ctod("31/12/"+Str(strAno)))
		strLote:=Alltrim(StrZero(nDia,4))		
		//strLote:="LT"+Alltrim(StrZero(nDia,3))+alltrim(str(strAno))+Replace(strHora,":","")
	EndIf	                                          

Return(strLote)   

//***********************************************************************
//IMPRIMIR A UF NO CADASTRO CONFORME A TABELA INFORMADA
//***********************************************************************
User Function xUF(cxTabela) 
Local sxUF:=""                 
                      
	If cxTabela=="SF1"
		If AllTrim(SF1->F1_TIPO) $ "DB"
			sxUF:=POSICIONE("SA1",1,SUBSTR(SF1->F1_FILIAL,1,2)+SPACE(2)+SF1->(F1_FORNECE+F1_LOJA),"A1_EST")
		Else
			sxUF:=POSICIONE("SA2",1,SUBSTR(SF1->F1_FILIAL,1,2)+SPACE(2)+SF1->(F1_FORNECE+F1_LOJA),"A2_EST")                                                           						                                                           
		EndIf                                                                      

	ElseIf cxTabela=="SF2"
		If AllTrim(SF2->F2_TIPO) $ "DB"
			sxUF:=POSICIONE("SA2",1,SUBSTR(SF2->F2_FILIAL,1,2)+SPACE(2)+SF2->(F2_CLIENTE+F2_LOJA),"A2_EST")                                                           			
		Else
			sxUF:=POSICIONE("SA1",1,SUBSTR(SF2->F2_FILIAL,1,2)+SPACE(2)+SF2->(F2_CLIENTE+F2_LOJA),"A1_EST")                                                           
		EndIf                                                                      
	ElseIf cxTabela=="SC5"
		If AllTrim(SC5->C5_TIPO) $ "DB"
			sxUF:=POSICIONE("SA2",1,SUBSTR(SC5->C5_FILIAL,1,2)+SPACE(2)+SC5->(C5_CLIENTE+C5_LOJACLI),"A2_EST")                                                           			
		Else
			sxUF:=POSICIONE("SA1",1,SUBSTR(SC5->C5_FILIAL,1,2)+SPACE(2)+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_EST")                                                           
		EndIf
	ElseIf cxTabela=="SC5M"
		If AllTrim(M->C5_TIPO) $ "DB"
			sxUF:=POSICIONE("SA2",1,XFILIAL("SA2")+M->(C5_CLIENTE+C5_LOJACLI),"A2_EST")                                                           			
		Else
			sxUF:=POSICIONE("SA1",1,XFILIAL("SA1")+M->(C5_CLIENTE+C5_LOJACLI),"A1_EST")
		EndIf		
			 
    EndIf

Return(sxUF)

//*******************************************************************************
//HISTORICO DA REGRA 560-001
//*******************************************************************************
User Function CtaDeb560()
Local strSQL := ""
Local strCta := ""

	strSQL:="SELECT A6_CONTA FROM "+RetSqlName("SA6")+" "
	strSQL+="WHERE D_E_L_E_T_ <> '*' "
	strSQL+="AND A6_COD + A6_AGENCIA + A6_NUMCON "
	strSQL+="IN " 
	strSQL+="( "
	strSQL+="SELECT E5_BANCO + E5_AGENCIA + E5_CONTA FROM "+RetSqlName("SE5")+" "  
	strSQL+="WHERE E5_PROCTRA = '"+SE5->E5_PROCTRA+"' "
	strSQL+="AND E5_RECPAG = 'R' "
	strSQL+="AND D_E_L_E_T_ <> '*' "
	strSQL+="AND E5_DATA = '"+DTOS(SE5->E5_DATA)+"' "
	strSQL+="AND E5_VALOR = "+AllTrim(Str(SE5->E5_VALOR))+ " "
	strSQL+=") "
	
	if select("ORS") > 0
 		ORS->(dbCloseArea())
	endif
                
	TcQuery strSQL new alias "ORS"
	
	IF !ORS->(EOF())
		strCta:=ORS->A6_CONTA
	EndIF
	    
	
Return(strCta) 

//**************************************************
//CALCULO DO VALOR TOTAL PARA NOTA FISCAL DE ENTRADA
//**************************************************
User Function xV650001()
Local nxValor := 0

	If SD1->D1_ICMSRET > 0 .AND. SF4->F4_CREDST=="4"                                                                                                                                        
		nxValor :=IF(SF4->F4_X_CTB=="S" .AND. !SD1->D1_TIPO$"DB" .AND. SD1->D1_RATEIO<>'1', SD1->(D1_TOTAL+D1_VALIPI+D1_VALFRE+D1_DESPESA+D1_SEGURO-D1_VALDESC+D1_ICMSRET),0)
	Else
		nxValor :=IF(SF4->F4_X_CTB=="S" .AND. !SD1->D1_TIPO$"DB" .AND. SD1->D1_RATEIO<>'1', SD1->(D1_TOTAL+D1_VALIPI+D1_VALFRE+D1_DESPESA+D1_SEGURO-D1_VALDESC),0)
	EndIf                                                       

Return(nxValor)

//***********************************************************
//MONTA O ITEM CONTABIL QUANDO HOUVE NECESSIDADE - FORNECEDOR
//***********************************************************
User Function xItemF(cxConta)
Local cxItem:=IF(SD1->D1_TIPO$"DB","C","F")+SD1->(D1_FORNECE+D1_LOJA)
Local cxAItem:=POSICIONE("CT1",1,XFILIAL("CT1")+cxConta,"CT1_ACITEM")                                                                                                                                                              

	If cxAItem=="2"
		cxItem:=""
	EndIf

Return(cxItem)

//***********************************************************
//MONTA O ITEM CONTABIL QUANDO HOUVE NECESSIDADE - CLIENTE
//***********************************************************
User Function xItemC(cxConta)
Local cxItem:=IF(SD2->D2_TIPO$"DB","F","C")+SD2->D2_CLIENTE+SD2->D2_LOJA              
Local cxAItem:=POSICIONE("CT1",1,XFILIAL("CT1")+cxConta,"CT1_ACITEM")                                                                                                                                                              

	If cxAItem=="2"
		cxItem:=""
	EndIf

Return(cxItem)

//***********************************************************
//MONTA O ITEM CONTABIL QUANDO HOUVE NECESSIDADE - PAGAR
//***********************************************************
User Function xItemP(cxConta)
Local cxItem:="F"+SE2->E2_FORNECE+SE2->E2_LOJA                
Local cxAItem:=POSICIONE("CT1",1,XFILIAL("CT1")+cxConta,"CT1_ACITEM")                                                                                                                                                              

	If cxAItem=="2"
		cxItem:=""
	EndIf

Return(cxItem)

//***********************************************************
//MONTA O ITEM CONTABIL QUANDO HOUVE NECESSIDADE - RECEBER
//***********************************************************
User Function xItemR(cxConta)
Local cxItem:="C"+SE1->E1_CLIENTE+SE1->E1_LOJA                
Local cxAItem:=POSICIONE("CT1",1,XFILIAL("CT1")+cxConta,"CT1_ACITEM")                                                                                                                                                              

	If cxAItem=="2"
		cxItem:=""
	EndIf

Return(cxItem)

//**************************************
//VALOR TOTAL DA REGRA CONTABIL 610-001 -- IF(SF4->F4_X_CTB=="S".AND. !SD2->D2_TIPO$"DB" .AND. SF2->F2_FIMP<>"D",SD2->D2_TOTAL+SD2->D2_ICMSRET+SD2->D2_VALIPI+SD2->D2_VALFRE+SD2->D2_DESPESA+SD2->D2_SEGURO,0)                                     
//**************************************
User Function nVl610001()
Local nxValor:=0

	IF SF4->F4_X_CTB=="S" .AND. !SD2->D2_TIPO$"DB" .AND. SF2->F2_FIMP<>"D"
		If SD2->D2_TIPO=="P" //SE FOR COMPLEMENTO DE IMPOSTO
			nxValor:=SD2->D2_TOTAL		
		Else
			nxValor:=SD2->D2_TOTAL+SD2->D2_ICMSRET+SD2->D2_VALIPI+SD2->D2_VALFRE+SD2->D2_DESPESA+SD2->D2_SEGURO
		EndIf                                     
	EndIf

Return(nxValor)


User Function 650101CD()
Local xCC		:=AllTrim(SD1->D1_CC)
Local xCodPro	:=AllTrim(POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD,"B1_X_CI"))
Local strCta	:=""

	strSQL:="SELECT CT1_CONTA FROM "+RetSqlName("CT1")+" "
	strSQL+="WHERE D_E_L_E_T_ <> '*' "
	strSQL+="AND CT1_X_CI = '"+xCC+xCodPro+"'
	
	if select("ORS") > 0
 		ORS->(dbCloseArea())
	endif
                
	TcQuery strSQL new alias "ORS"
	
	IF !ORS->(EOF())
		strCta:=ORS->CT1_CONTA
	EndIF

Return(strCta)

//****************************************
//USADO PARA BUSCAR A CHAVE DA NOTA FISCAL
//****************************************
User Function BuscaChave()
Local strChave:=""
Local strSQL:=""

	strSQL:="SELECT F2_CHVNFE FROM "+RetSqlName("SF2")+" WITH (NOLOCK) "
	strSQL+="WHERE F2_FILIAL = '"+cFilAnt+"' "
	strSQL+="AND F2_DOC = '"+SE1->E1_NUM+"' "
	strSQL+="AND F2_SERIE = '"+SE1->E1_PREFIXO+"' "
	strSQL+="AND D_E_L_E_T_ <> '*' "
	
	if select("ORS") > 0
 		ORS->(dbCloseArea())
	endif
                
	TcQuery strSQL new alias "ORS"
	
	IF !ORS->(EOF())
		strChave:=ORS->F2_CHVNFE
	EndIF	

Return(strChave)

User Function NrAthena()
local xResult := ''
    
	xResult := substr(Alltrim(SE1->E1_NUM),3,7)+Alltrim(SE1->E1_PARCELA)
	
Return xResult 

//Usado para compor o campo numero do documento e nosso numero do uniprime.
User Function NnUnipr(cTam)
local xResult 	:= ''
Local nLen		:= 0
Local cDigito	:= ""

	xResult := AllTrim(SE1->E1_X_NOSSO)
	If !Empty(xResult)
		xResult:=StrZero(Val(xResult),cTam)
		cDigito:=u_modulo11(StrZero(Val(SEE->EE_CODCART),2)+xResult,"237")
		xResult:=cvaltochar(xResult)+cvaltochar(cDigito)
	Else    
		xResult := AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)
		nLen	:=Len(xResult)+1
		If nLen > cTam
			xResult := SubStr(xResult,nLen-cTam,cTam)
		EndIf
		xResult:=StrZero(Val(xResult),cTam)+"0"
	EndIf
	

Return(xResult)  
