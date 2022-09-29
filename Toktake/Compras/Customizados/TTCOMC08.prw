#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TTCOMC08   บAutor  ณJackson E. de Deusบ   Data ณ  15/05/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera็ใo Confer๊ncia Cega Mobile							  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ15/05/13ณ01.00 |Criacao                                 ณฑฑ
ฑฑณJackson       ณ24/11/14ณ01.01 |Melhorias no codigo					  ณฑฑ
ฑฑณ								alteracao no esquema de cancelamento da OSณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTCOMC08() 

Local cEmpRegra		:= SuperGetMV("MV_XWSK011",.T.,"") 
Local aDimension	:= MsAdvSize()
Local oDlg
Local oLayer		:= FWLayer():New()
Local nTamanho		:= 0.5
Private opButton1
Private opButton2
Private oDlg2
Private dDtInicio	:= Ctod(DtoC(dDatabase))
Private dDtFinal	:= Ctod(DtoC(dDatabase))


If !cEmpAnt $ cEmpRegra
	MsgAlert("Esta empresa nใo estแ parametrizada para o uso da integra็ใo com o sistema Mobile.", "TTCOMC08")
	Return
EndIf

dbSelectArea("SF1")

If FieldPos("F1_XWSOSF") == 0
	Aviso("TTCOMC08","Campo: F1_XWSOSF" + CRLF + "Nใo encontrado no dicionแrio de dados." +CRLF +"O programa nใo continuarแ.", {"Ok"})
	Return
EndIf

If FieldPos("F1_XWSOSR") == 0
	Aviso("TTCOMC08","Campo: F1_XWSOSR" + CRLF + "Nใo encontrado no dicionแrio de dados." +CRLF +"O programa nใo continuarแ.", {"Ok"})
	Return
EndIf
	
oDlg2 := MsDialog():New(000,000,210,318,"Gera็ใo de confer๊ncia cega",,,,,CLR_BLACK,CLR_HGRAY,,,.T.)
 			
	@ 05,60 Say "Filtro de Notas" Pixel  Of oDlg2	 		
	@ 02, 05  To 090, 156 LABEL "" Pixel Of oDlg2
	@ 030, 25 Say "Dt Digita็ใo De ?"  	  Pixel Of oDlg2
	@ 030, 95 MsGet  dDtInicio	Picture "99/99/99" Size 40,0.5 Pixel Of oDlg2
	@ 045, 25 Say "Dt Digita็ใo Ate ?"  	  Pixel Of oDlg2
	@ 045, 95 MsGet  dDtFinal	Picture "99/99/99" Size 40,0.5 Pixel Of oDlg2
				
	opButton1 := tButton():New(065,010,"&Confirmar" 	,oDlg2,{ || TelaSF1() },70,20,,,,.T.)
	opButton2 := tButton():New(065,080,"&Sair" 			,oDlg2,{ || oDlg2:End() },70,20,,,,.T.)

oDlg2:Activate(,,,.T.,,,)                                                                       


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaSF1  บAutor  ณJackson E. de Deus     บ Data ณ  15/05/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Browse para visualiza็ใo das Notas e Gera็ใo do Pedido.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TelaSF1()

Local cFiltra
Private aIndexSF1	:= {} 
Private bFiltraBrw
Private cAlias		:= "SF1"
Private cCadastro	:= "Notas Fiscais de Entrada"
Private aRotina		:= {}

AADD(aRotina,{"Pesquisar"			,"AxPesqui"							,0,1})	// Pesquisar
AADD(aRotina,{"Visualizar"			,"A103NFiscal(cAlias,Recno(),2)"	,0,2})	// Visualizar
AADD(aRotina,{"Gerar OS"			,"U_TTCOMC09"						,0,3})	// Gera a Conferencia cega via WS
AADD(aRotina,{"Cancelar"			,"U_TTCOMC09"						,0,5})	// Cancela a Conferencia cega via WS
AADD(aRotina,{"Legenda"				,"U_TTLEG001"						,0,6})	// Legenda
 			             
Private aCores 	:= { {"F1_XWSOSF <> 'S'"	,"BR_VERDE"		} ,;				// Conferencia cega nใo gerada
					{"F1_XWSOSF == 'S'"		,"BR_PINK"		}} 					// Conferencia cega gerada						 
				
cFiltra := "(F1_DTDIGIT >= dDtInicio .AND. F1_DTDIGIT <= dDtFinal) .AND. Empty(F1_STATUS) "

bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSF1,@cFiltra) }  	
Eval(bFiltraBrw)	
		            
dbSelectArea(cAlias)                      
mBrowse( 6,1,22,75,cAlias,,,,,3,aCores)
EndFilBrw(cAlias,aIndexSF1)
                                                                                                                               		 
Return Nil
          


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TTLEG001 บAutor  ณJackson E. de Deus  บ Data ณ  15/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Legenda da Tela.                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTLEG001()
	BrwLegenda(cCadastro,"Status",{{"BR_VERDE","Confer๊ncia cega nใo gerada"},;
	                               {"BR_PINK","Confer๊ncia cega gerada"}})
							
Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC09  บAutor  ณJackson E. de Deus  บ Data ณ  15/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera/Exclui conferencia cega.				              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCOMC09(cAlias,nReg,nOpc)

Private cNumNF		:= SF1->F1_DOC
Private cSerie		:= SF1->F1_SERIE
Private cCodFor		:= SF1->F1_FORNECE
Private cLjFor		:= SF1->F1_LOJA
Private	aDoc		:= {SF1->F1_DOC,SF1->F1_SERIE,1} 
Private cNumOS		:= ""
Private cEmpRegra	:= ""
Private lAtivaOS	:= SuperGetMV("MV_XWSK018",.T.,.T.)	// Uso do WS esta ativo?
Private nAgente		:= SuperGetMV("MV_XWSK019",.T.,"")	// Uso do WS esta ativo?
Private nTpServ		:= 1 // tipo do formulario - conferencia cega
Default cAlias		:= "SF1"
Default nReg		:= 0
Default nOpc		:= 3	// inclusao

If !lAtivaOS
	Aviso("TTCOMC09","O uso da integra็ใo com o sistema Mobile estแ desativado." +CRLF +"A confer๊ncia cega nใo serแ gerada.",{"Ok"})
	Return
EndIf

If !Empty(nAgente)
	nAgente := val(nAgente)
EndIf
              
cEmpRegra	:= SuperGetMV("MV_XWSK011",.T.,"01#11") 

If !cEmpAnt $ cEmpRegra
	Aviso("TTCOMC09","Empresa nใo autorizada a utilizar esse recurso!",{"Ok"})
	Return        
EndIf

If nOpc == 3
	MsAguarde({ || GeraConf() },"Iniciando...")
ElseIf nOpc == 5
	MsAguarde({ || Cancela() },"Iniciando...")
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraConf บAutor  ณJackson E. de Deus  บ Data ณ  15/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera a conferencia cega.                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraConf()

Local aDadosOS		:= {}
Local cTecnico		:= AllTrim(GetMV("MV_XTECCOM"))//"212411"	// GIL - Altera็ใo realizada por Ronaldo Gomes (21/03/2018)
Local cNomeAtend	:= ""
Local cDescCf		:= AllTrim( Posicione( "SA2",1,xFilial("SA2")+AvKey(cCodFor,"A2_COD") +AvKey(cLjFor,"A2_LOJA"),"A2_NOME" ) )
Local cEndereco		:= ""
Local cTime			:= inttoHora(SomaHoras(Time(),"00:30:00")) +":00"
Local cTpDoc		:= "1"	// nota de entrada
Local cMsgOS		:= ""
                    
If SF1->F1_XWSOSF == "S" .And. !Empty(SF1->F1_XWSOSR)
	Aviso("TTCOMC09","Jแ existe Confer๊ncia cega para essa Nota Fiscal." +CRLF +"N๚mero: " +SF1->F1_XWSOSR,{"Ok"},2)
	Return
EndIf                               

cMsgOS := "Fornecedor: " +cDescCf +CRLF
cMsgOS += "NF: " +AllTrim(SF1->F1_DOC) +"/" +AllTrim(SF1->F1_SERIE)
                                                  
aDadosOS := { "01",;
				"CONFERENCIA CEGA",;
				AllTrim(cTecnico),;
				AllTrim(cNomeAtend),;
				"",;
				"",;
				"",;
				"",;
				dDatabase,;
				cTime,;
				cDescCf,;
				"TOK TAKE - EXPEDIวรO",;
				""/*contato*/,;
				cMsgOS,;
				"",;
				"EXPEDIวรO",;
				AllTrim(SF1->F1_DOC),;
				AllTrim(SF1->F1_SERIE),;
				cTpDoc,;
				cCodFor,;
				cLjFor} 
				
				
MsProcTxt("Salvando confer๊ncia cega no Mobile..") 
cNumOS := U_MOBILE(aDadosOS) //U_WSKPF009(nTpServ,cCodFor,cLjFor,aDoc,nAgente)	// para qual agente??					

If !Empty(cNumOS)
	If Val(cNumOS) > 0
		If IsInCallStack("U_IMPXMLNFE")
	 		MsgInfo("Foi gerada a confer๊ncia cega no sistema Mobile" +CRLF +"Numero: " +cNumOS, "TTCOMC09")
	   	Else
	    	Aviso("TTCOMC09","Foi gerada a confer๊ncia cega no sistema Mobile" +CRLF +"Numero: " +cNumOS,{"Ok"})	
		EndIf
		dbSelectArea("SF1")
		If RecLock("SF1",.F.)
		    SF1->F1_XWSOSF := "S"
		    SF1->F1_XWSOSR := cNumOS
			MsUnLock()
		EndIf
	Else
		MsgAlert(cNumOS)	
	EndIf
EndIf		                 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Cancela  บAutor  ณJackson E. de Deus   บ Data ณ  24/11/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cancela a conferencia cega da nota fiscal posicionada.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cancela()

Local aArea := GetArea()
Local cStatus := ""
Local nTpCanc := 1	// cancelado pelo atendente
Local nCanc := 0

nCanc := ProcCanc(SF1->F1_XWSOSR,SF1->F1_XWSOSR,"","",dDatabase,dDatabase,nTpCanc)

If nCanc > 0
	If RecLock("SF1",.F.)
		SF1->F1_XWSOSF := ""
		SF1->F1_XWSOSR := ""				
		MsUnlock()	
	EndIf	
EndIf

RestArea(aArea)

Return