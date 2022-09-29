#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TTCOMC08   �Autor  �Jackson E. de Deus�   Data �  15/05/13 ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera��o Confer�ncia Cega Mobile							  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �15/05/13�01.00 |Criacao                                 ���
���Jackson       �24/11/14�01.01 |Melhorias no codigo					  ���
���								alteracao no esquema de cancelamento da OS���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

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
	MsgAlert("Esta empresa n�o est� parametrizada para o uso da integra��o com o sistema Mobile.", "TTCOMC08")
	Return
EndIf

dbSelectArea("SF1")

If FieldPos("F1_XWSOSF") == 0
	Aviso("TTCOMC08","Campo: F1_XWSOSF" + CRLF + "N�o encontrado no dicion�rio de dados." +CRLF +"O programa n�o continuar�.", {"Ok"})
	Return
EndIf

If FieldPos("F1_XWSOSR") == 0
	Aviso("TTCOMC08","Campo: F1_XWSOSR" + CRLF + "N�o encontrado no dicion�rio de dados." +CRLF +"O programa n�o continuar�.", {"Ok"})
	Return
EndIf
	
oDlg2 := MsDialog():New(000,000,210,318,"Gera��o de confer�ncia cega",,,,,CLR_BLACK,CLR_HGRAY,,,.T.)
 			
	@ 05,60 Say "Filtro de Notas" Pixel  Of oDlg2	 		
	@ 02, 05  To 090, 156 LABEL "" Pixel Of oDlg2
	@ 030, 25 Say "Dt Digita��o De ?"  	  Pixel Of oDlg2
	@ 030, 95 MsGet  dDtInicio	Picture "99/99/99" Size 40,0.5 Pixel Of oDlg2
	@ 045, 25 Say "Dt Digita��o Ate ?"  	  Pixel Of oDlg2
	@ 045, 95 MsGet  dDtFinal	Picture "99/99/99" Size 40,0.5 Pixel Of oDlg2
				
	opButton1 := tButton():New(065,010,"&Confirmar" 	,oDlg2,{ || TelaSF1() },70,20,,,,.T.)
	opButton2 := tButton():New(065,080,"&Sair" 			,oDlg2,{ || oDlg2:End() },70,20,,,,.T.)

oDlg2:Activate(,,,.T.,,,)                                                                       


Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TelaSF1  �Autor  �Jackson E. de Deus     � Data �  15/05/13 ���
�������������������������������������������������������������������������͹��
���Desc.     � Browse para visualiza��o das Notas e Gera��o do Pedido.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
 			             
Private aCores 	:= { {"F1_XWSOSF <> 'S'"	,"BR_VERDE"		} ,;				// Conferencia cega n�o gerada
					{"F1_XWSOSF == 'S'"		,"BR_PINK"		}} 					// Conferencia cega gerada						 
				
cFiltra := "(F1_DTDIGIT >= dDtInicio .AND. F1_DTDIGIT <= dDtFinal) .AND. Empty(F1_STATUS) "

bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSF1,@cFiltra) }  	
Eval(bFiltraBrw)	
		            
dbSelectArea(cAlias)                      
mBrowse( 6,1,22,75,cAlias,,,,,3,aCores)
EndFilBrw(cAlias,aIndexSF1)
                                                                                                                               		 
Return Nil
          


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TTLEG001 �Autor  �Jackson E. de Deus  � Data �  15/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Legenda da Tela.                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTLEG001()
	BrwLegenda(cCadastro,"Status",{{"BR_VERDE","Confer�ncia cega n�o gerada"},;
	                               {"BR_PINK","Confer�ncia cega gerada"}})
							
Return .T.



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTCOMC09  �Autor  �Jackson E. de Deus  � Data �  15/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera/Exclui conferencia cega.				              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	Aviso("TTCOMC09","O uso da integra��o com o sistema Mobile est� desativado." +CRLF +"A confer�ncia cega n�o ser� gerada.",{"Ok"})
	Return
EndIf

If !Empty(nAgente)
	nAgente := val(nAgente)
EndIf
              
cEmpRegra	:= SuperGetMV("MV_XWSK011",.T.,"01#11") 

If !cEmpAnt $ cEmpRegra
	Aviso("TTCOMC09","Empresa n�o autorizada a utilizar esse recurso!",{"Ok"})
	Return        
EndIf

If nOpc == 3
	MsAguarde({ || GeraConf() },"Iniciando...")
ElseIf nOpc == 5
	MsAguarde({ || Cancela() },"Iniciando...")
EndIf

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GeraConf �Autor  �Jackson E. de Deus  � Data �  15/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera a conferencia cega.                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GeraConf()

Local aDadosOS		:= {}
Local cTecnico		:= AllTrim(GetMV("MV_XTECCOM"))//"212411"	// GIL - Altera��o realizada por Ronaldo Gomes (21/03/2018)
Local cNomeAtend	:= ""
Local cDescCf		:= AllTrim( Posicione( "SA2",1,xFilial("SA2")+AvKey(cCodFor,"A2_COD") +AvKey(cLjFor,"A2_LOJA"),"A2_NOME" ) )
Local cEndereco		:= ""
Local cTime			:= inttoHora(SomaHoras(Time(),"00:30:00")) +":00"
Local cTpDoc		:= "1"	// nota de entrada
Local cMsgOS		:= ""
                    
If SF1->F1_XWSOSF == "S" .And. !Empty(SF1->F1_XWSOSR)
	Aviso("TTCOMC09","J� existe Confer�ncia cega para essa Nota Fiscal." +CRLF +"N�mero: " +SF1->F1_XWSOSR,{"Ok"},2)
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
				"TOK TAKE - EXPEDI��O",;
				""/*contato*/,;
				cMsgOS,;
				"",;
				"EXPEDI��O",;
				AllTrim(SF1->F1_DOC),;
				AllTrim(SF1->F1_SERIE),;
				cTpDoc,;
				cCodFor,;
				cLjFor} 
				
				
MsProcTxt("Salvando confer�ncia cega no Mobile..") 
cNumOS := U_MOBILE(aDadosOS) //U_WSKPF009(nTpServ,cCodFor,cLjFor,aDoc,nAgente)	// para qual agente??					

If !Empty(cNumOS)
	If Val(cNumOS) > 0
		If IsInCallStack("U_IMPXMLNFE")
	 		MsgInfo("Foi gerada a confer�ncia cega no sistema Mobile" +CRLF +"Numero: " +cNumOS, "TTCOMC09")
	   	Else
	    	Aviso("TTCOMC09","Foi gerada a confer�ncia cega no sistema Mobile" +CRLF +"Numero: " +cNumOS,{"Ok"})	
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Cancela  �Autor  �Jackson E. de Deus   � Data �  24/11/14  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cancela a conferencia cega da nota fiscal posicionada.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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