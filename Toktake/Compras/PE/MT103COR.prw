#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103COR  �Autor  �Alexandre Venancio  � Data �  01/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Todas as rotinas que estao neste fonte estao relacionadas ���
���          �com o bloqueio de notas de entrada na luxor                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103COR()


Local aArea		:=	GetArea()                           
Local aCores	:= 	ParamIxb[1]
Local aColors	:=	{} 

//If SM0->M0_CODIGO == "02"
//	aAdd( aColors , { "F1_XAPROVE='1'" , "BR_CANCEL" } )
 //	aEval( aCores , { |aElem,nIndex| aAdd( aColors , aCores[ nIndex ] ) } )
//EndIF
	
RestArea(aArea)

Return(If(SM0->M0_CODIGO == "02",aColors,Paramixb[1]))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103COR  �Autor  �Alexandre Venancio  � Data �  01/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103LEG()

Local aLegend := ParamIxb[1] 	   

If !( ValType( aLegend ) == "A" ) 	   
	aLegend := {} 
EndIf 	 	
                        
//If SM0->M0_CODIGO == "02"
//	aAdd( aLegend , { "BR_CANCEL"	, OemToAnsi( "Aguardando aprova��o"  ) } ) 	   
//EndIf

Return( aLegend )                                          

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103COR  �Autor  �Alexandre Venancio  � Data �  01/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103PN()

Local aArea			:=	GetArea()
Local lRet			:=	.T.
Local cEmpRegra		:= ""
Local cAuthCode		:= ""
Local cClientCod	:= ""
Local cConfWS		:= .F.
Local aDados		:= {}
Local cResWS		:= ""
Local aDadosWS		:= {}
Local cNumItem		:= ""
Local nQtdFis		:= 0
Local n_D1_ITEM		:= aScan( aHeader, {|x| AllTrim(x[2]) == "D1_ITEM"	    } )
Local n_D1_QTDF		:= If(cEmpAnt == "01",aScan( aHeader, {|x| AllTrim(x[2]) == "D1_XCLASPN"   } ),0)
Local nX
Local nY
Local lAtivaOS		:= If(cEmpAnt == "01",SuperGetMV("MV_XWSK018",.T.,.F.),"")

                       
//If SM0->M0_CODIGO == "02"
//	IF SF1->F1_XAPROVE == "1"
//		MsgAlert("Esta nota fiscal ainda n�o foi aprovada para classifica��o, aguarde!!!","MT103PN")
//		lRet	:=	.F.
//	EndIf              
//EndIf


RestArea(aArea)


If cEmpAnt == "01"
	/*
	----------------------------------------------------------------------------------------------
	Integra��o Mobile					
	Jackson E. de Deus 02/05/2013								
	----------------------------------------------------------------------------------------------
	*/
	If lAtivaOS
		cEmpRegra	:= SuperGetMV("MV_XWSK011",.T.,"") 
		If cEmpAnt $ cEmpRegra
			Begin Sequence
				dbSelectArea("SF1")
				If FieldPos("F1_XWSOSF") == 0
					Aviso("MT103PN","Campo: F1_XWSOSF" +CRLF +"N�o encontrado no dicion�rio de dados." +CRLF +"N�o ser� poss�vel a integra��o com o sistema Equipe Remota.", {"Ok"})
					Break
				EndIf
						
				If FieldPos("F1_XWSOSR") == 0
					Aviso("MT103PN","Campo: F1_XWSOSR" +CRLF +"N�o encontrado no dicion�rio de dados." +CRLF +"N�o ser� poss�vel a integra��o com o sistema Equipe Remota.", {"Ok"})
					Break
				EndIf
			
				// Se for classificacao de Nota e existir a OS para essa NF
				If l103Class .And. !Empty(SF1->F1_XWSOSR)
					/*
					If !FindFunction("U_WSKPC006")
						Aviso( "MT103PN" , "Fun��o: U_WSKPC006" + CRLF + "N�o encontrada no RPO." +CRLF +"N�o ser� poss�vel a integra��o com o sistema Equipe Remota." , {"Ok"} )
						Break
					EndIf
					If !FindFunction("U_WSKPF001")
						Aviso( "MT103PN" , "Fun��o: U_WSKPF001" + CRLF + "N�o encontrada no RPO." +CRLF +"N�o ser� poss�vel a integra��o com o sistema Equipe Remota." , {"Ok"} )
						Break
					EndIf    
					If !FindFunction("U_WSKPF005")
						Aviso( "MT103PN" , "Fun��o: U_WSKPF005" + CRLF + "N�o encontrada no RPO." +CRLF +"N�o ser� poss�vel a integra��o com o sistema Equipe Remota." , {"Ok"} )
						Break
					EndIf
				    */
					dbSelectArea("SZG")
					dbSetOrder(1)
					If !MSSeek( xFilial("SZG") +AvKey(SF1->F1_XWSOSR,"ZG_NUMOS") )
						Break
					EndIf
					
					If AllTrim(SZG->ZG_STATUS) <> "FIOK"
						Aviso("MT103PN","A Ordem de servi�o ainda n�o foi finalizada.",{"Ok"})
						Break
					EndIf
						 
					
					cResWS := AllTrim(SZG->ZG_RESPOST)
					/*
					aDadosWS := U_WSKPF005(cResWS)
					If aDadosWS == NIL .And. Len(aDadosWS) == 0
						Aviso("MT103PN","Houve erro ao processar as respostas da Confer�ncia cega.",{"Ok"})						
						lRet := .F.	
						Break
					EndIf
					For nX := 1 To Len(aCols)
						cNumItem := PaDL( Val(aCols[nX][n_D1_ITEM]),TamSX3("D1_ITEM")[1],"0")	// Item
						nQtdFis := aCols[nX][n_D1_QTDF]											// Qtd Fisica
						For nY := 1 To Len(aDadosWS[9][2])
							If cNumItem == aDadosWS[9][2][nY][1]
								ACols[nX][n_D1_QTDF] := aDadosWS[9][2][nY][2]
							EndIf
						Next nY
					Next nX
					*/
					aDadosOS := U_MXML000(cResWS)
					For nI := 1 To Len( aDadosOS )
						If aDadosOS[nI][1] == "CONFERENCIA"
							aConf := Aclone( aDadosOS[nI] )
							Exit
						EndIf
					Next nI
									
					For nX := 1 To Len(aCols)
						cNumItem := PaDL( Val(aCols[nX][n_D1_ITEM]),TamSX3("D1_ITEM")[1],"0")	// Item
						nQtdFis := aCols[nX][n_D1_QTDF]											// Qtd Fisica
						For nY := 2 To Len( aConf )
							aItem := aClone( aConf[nY] )					          
							For nZ := 1 To Len( aItem )
								If aItem[2][2] == cNumItem
									ACols[nX][n_D1_QTDF] := Val(aItem[4][2])
									Exit
								EndIf
							Next nZ
						Next nY
					Next nX				
				EndIf
			End Sequence
		EndIf
	EndIf
EndIF

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103COR  �Autor  �Alexandre Venancio  � Data �  01/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MT140SAI()

Local aArea			:=	GetArea()
Local lAtivaOS		:= SuperGetMV("MV_XWSKP018",.T.,.T.)	// Se esta ativo o uso do WS
Local cEmpRegra		:= ""
     
//If SM0->M0_CODIGO == "02"
//	If ParamIxb[1] == 3
//		Reclock("SF1",.F.)
//		SF1->F1_XAPROVE := "1"
//		SF1->(Msunlock())
//	EndIf
//EndIf


// Verifica se a NF possui OS gerada no Equipe Remota
If lAtivaOS .And. PARAMIXB[1] == 5
	cEmpRegra := SuperGetMV("MV_XWSK011",.T.,"") 
	If cEmpAnt $ cEmpRegra
		dbSelectArea("SF1")
		If FieldPos("F1_XWSOSF") > 0 .And. FieldPos("F1_XWSOSR") > 0
			If SF1->F1_XWSOSF <> "S" .And. Empty(SF1->F1_XWSOSR)
				Return	            
			Else
				dbSelectArea("SZG")
				dbSetOrder(1)
				If dbSeek( xFilial("SZG") +AvKey(SF1->F1_XWSOSR,"ZG_NUMOS") )
					StaticCall(TTPROC30,Cancelar)
				EndIf	
			EndIf                   
		EndIf
	EndIf
EndIf
RestArea(aArea)

Return( NIL )                                                                                                                             

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103COR  �Autor  �Microsiga           � Data �  01/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTCOMC06()

Local aArea		:=	GetArea()
                                   
//If SM0->M0_CODIGO == "02"
//	If SF1->F1_XAPROVE == "1"
//		Reclock("SF1")
//		SF1->F1_XAPROVE	:=	"2"
//		SF1->(Msunlock())
		
//		MsgAlert("Nota Fiscal liberada para classifica��o de entrada","TTCOMC06 - MT103COR")
//	Else
//		MsgAlert("Esta Nota Fiscal n�o encontra-se bloqueada ou j� foi liberada","TTCOMC06 - MT103COR")
//	EndIf
//EndIf
	      
RestArea(aArea)

Return
