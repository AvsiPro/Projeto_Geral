#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCNTA10  บAutor  ณJackson E. de Deus  บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAlerta de contratos vencendo/vencidos.                      บฑฑ
ฑฑบ          ณMostra os contratos e da opcao para renovacao.              บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ04/11/13ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTCNTA10(cEmp, cFil)

Local dDtAtual	:= Date()
Local cHora		:= ""
Local cpCliente := ""
Local cpLoja	:= ""
Local cNomeCli	:= ""
Local dDtIni
Local dDtFim
Local dData   
Private aContr		:= {}
Private aContrBKP	:= {}
Private lJob		:= .F.	//controla execucao do programa - via tela ou via job
Private aContratos	:= {}
Private oExcel
Private cDirServer	:= ""
Private cDirLocal	:= ""
Private cUsrMail	:= ""
Private cPlanilha	:= ""
Private cDia		:= ""
Private cMes		:= ""
Private cAno		:= ""

Default cEmp	:= "01"
Default cFil	:= "01"
  
If cEmpAnt == "01"
	           
	If AllTrim(FunName()) == ""
		lJob := .T.
	EndIf
	
	If lJob
		If Day( Date() ) != 1
			Return
		EndIf
		
		cHora := Time()
		If cHora < "08:00:00" .Or. cHora > "18:00:00"
			Return
		EndIf
		
		If !FindFunction("U_TTMAILN")
			ConOut("TTTMKA08 ,Funcao U_TTMAILN nao compilada no repositorio. Nao sera possivel continuar.")
			Return
		EndIf
		
		ConOut("## Iniciando rotina de verificacao do vencimento de contratos.. ##")
		ConOut("Iniciando empresa "+cEmp +" Filial " +cFil)
		RpcSetType(3)
		RpcSetEnv(cEmp,cFil)
	EndIf
	
	If !lJob
		MsAguarde({ || Dados()},"Verificando contratos, aguarde..")
	Else                
		ConOut("## Verificando contratos, aguarde.. ##")
		Dados()	
	EndIf
	
	
	If Len(aContr) > 0
		aContrBKP := aClone(aContr)	
		cDirServer	:= SuperGetMV("MV_XGCT004",.T.,"\system\contratos\",)	//diretorio no servidor onde as planilhas serao guardadas
		cDirLocal	:= SuperGetMV("MV_XGCT005",.T.,"C:\TEMP\",)			//diretorio no cliente onde as planilhas serao guardadas
		cUsrMail	:= SuperGetMV("MV_XGCT006",.T.,"",)
		If lJob                                                     
			Planilha()      
			Email()
			Renova()			
			RpcClearEnv()
		Else
			TELA()
		EndIf
	EndIf	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTela บAutor ณJackson E. de Deus        บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra a tela principal                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Tela()

Local oDlg1
Local cTitulo		:= "Renova็ใo de Contratos"
Local oLayer		:= FWLayer():new()
Local aArea			:= GetArea()
Local aDimension	:= MsAdvSize()
Local aObjSize		:= Array(0) 
Local aInfo 		:= Array(0)
Local aObjects		:= Array(0)             
Local aPosObj		:= Array(0)
Local bSavKeyF4		:= SetKey(VK_F4,Nil)
Local aHead			:= {" "," ", "Contrato", "Cliente", "Loja", "Nome", "Tipo de Contrato","Data Assinatura","Periodo inicial","Periodo final","Vig๊ncia","Indice","Data final para reajuste","Data ultimo reajuste","Ultimo indice aplicado","Gestor"}
Local aTam			:= {10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10}
Private oOK			:= LoadBitMap(GetResources(), "BR_VERDE")
Private oVencido	:= LoadBitMap(GetResources(), "BR_VERMELHO")
Private oVencendo	:= LoadBitMap(GetResources(), "BR_AMARELO")
Private oChk		:= LoadBitMap(GetResources(), "LBTIK")
Private oUnChk		:= LoadBitMap(GetResources(), "LBNO")
Private cUsrPerm	:= SuperGetMV("MV_XGCT003",.T.,"ADMIN")
Private aBrowse		:= {}
Private oFont		:= TFont():New('Arial',,-12,.T.,.T.)
Private oList
Private oList2
Private nPosRecno	:= 12	// posicao do recno no array dos contratos
Private oCBox1
Private cValor		:= Space(TamSX3("A1_NOME")[1])
Private aItems		:= {"Contrato", "Cod. Cliente", "Nome"}
Private cCombo		:= aItems[1]

SetKey(VK_F4, { || U_TTCNTA12() })
SetKey(VK_F5, { || Filtro() })

//aAdd(aObjects,{000, 020, .T., .F. })	
aAdd(aObjects,{000, 000, .T., .T. })

aInfo := {aDimension[1],aDimension[2],aDimension[3],aDimension[4], 3 /*distancia horizontal*/, 3 /*distancia vertical*/}
aPosObj := MsObjSize(aInfo,aObjects)
// Monta a janela
oDlg1	:= MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],cTitulo,,,.F.,,,,,,.T.,,,.T. )
	oDlg1:lMaximized := .T.
	oLayer:init(oDlg1,.T.)
	oLayer:addLine("LN_ENCH",100,.F.)
	oLayer:addCollumn("COL_ENCH",100,.f.,"LN_ENCH")
	oLayer:addWindow("COL_ENCH","WIN_ENCH","Contratos",100,.t.,.F.,{||},"LN_ENCH")
	oPnlMaster := oLayer:GetWinPanel("COL_ENCH","WIN_ENCH","LN_ENCH")
	oPnlMaster:FreeChildren()
	                                                                                                                                                                                                                              
	oList := TCBrowse():New(aPosObj[1][1]+2,aPosObj[1][2]+2,aPosObj[1][4]-15,aPosObj[1][3]-55,,aHead,aTam,oPnlMaster,,,,/*bchange*/,{|| Marca() },,,,,,,.F.,,.T.,{ || Len(aContr) > 0},.F.,,.T.,.T.,)

	Filtro()
				
	// Painel
	oPanel:= tPanel():New(aPosObj[1][3]-15,04,"",oDlg1,,,,,,100,030)
	oPanel:align:= CONTROL_ALIGN_BOTTOM
	
	oGroup	:= TGroup():New(002,002,030,160,"Filtro",oPanel,CLR_BLACK,CLR_WHITE,.T.,.F.)
	oCBox1	:= TComboBox():New( 012,004,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItems,048,010,oPanel,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo)
	@ 012,054 MSGET cValor	PICTURE "@!"		OF oPanel SIZE 060,010 PIXEL
	oSBtn5 := TButton():New( 012,115,"Pesquisar",oPanel,{|| Filtro(cValor)},40,12,,,,.T. )
	
	// Botoes				                                                                                                                                                                                                         
	oBtn4	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-170, 40, 40, 'S4SB014N' , , , ,{|| Renova() } , oDlg1, "Renovar" , ,)
	oBtn3	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-130, 40, 40, 'PMSEXCEL' , , , ,{|| If(MsgYesNO('Deseja exportar para planilha?'),Planilha(),) } , oDlg1, "Exportar" , ,)
    oBtn1	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-90, 40, 40, 'VERNOTA' , , , ,{|| Visual() } , oDlg1, "Visualizar" , ,)
	oBtn2	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-50, 40, 40, 'CANCEL' , , , ,{|| oDlg1:End() } , oDlg1, "Sair" , ,)
	
	If !cUserName $ cUsrPerm
		oBtn4:lReadOnly := .T.
	EndIf
oDlg1:Activate(,,,.T.)

SetKey(VK_F4,bSavKeyF4) 
 
Return

// Filtro de contratos
Static Function Filtro(cValor)

Local nPos
Local nI 

IIF(oCBOX1 <> NIL .Or. oCBOX1 == 0,nPos := oCBOX1:NAT,1)

// Filtro por contrato
If nPos == 1
	cValor := StrZero( Val(cValor), TamSx3("CN9_NUMERO")[1],0 )
	// Zera Array aContr
	aContr := {}                         
	// Varre Array aDados
	For nI := 1 To Len(aContrBKP)
		If aContrBKP[nI][1] <> cValor
			Loop
		Else	
			AADD(aContr,aContrBKP[nI] )
		EndIf                    
	Next nI	            
// Filtro por cliente	
ElseIf nPos == 2
	// Zera Array aContr
	aContr := {}                         
	// Varre Array aDados
	For nI := 1 To Len(aContrBKP)
		If aContrBKP[nI][4] <> AllTrim(cValor)
			Loop
		Else	
			AADD(aContr,aContrBKP[nI] )
		EndIf                    
	Next nI
// Filtro por Nome de cliente
ElseIf nPos == 3
	// Zera Array aContr
	aContr := {}                         
	// Varre Array aDados
	For nI := 1 To Len(aContrBKP)
		If !AllTrim(cValor) $ aContrBKP[nI][6]
			Loop
		Else	
			AADD(aContr,aContrBKP[nI] )
		EndIf                    
	Next nI	
EndIf	
		
// Se nใo encontrou nada, clona novamente o Array aContrBKP em aContr
If Len(aContr) == 0
	aContr := AClone(aContrBKP)   
EndIf

// Atualiza Array do objeto do TcBrowse
oList:SetArray(aContr)

// Monta a linha a ser exibina no Browse
oList:bLine := {||{ 	IIF( aContr[oList:nAt,15]=="OK",oOK, IIF(aContr[oList:nAt,15]=="VENCENDO",oVencendo,oVencido)  ),;	// processado
						IIF(aContr[oList:nAt,16],oChk,oUnChk),;																// marcado?
						aContr[oList:nAt,01],;																				// Contrato
						aContr[oList:nAt,04],;																				// Cod cliente
						aContr[oList:nAt,05],;																				// loja cliente
						aContr[oList:nAt,06],;																				// nome cliente
						aContr[oList:nAt,08],;																				// tipo de contrato
						DtoC(aContr[oList:nAt,07]),;																		// data assinatura
						DtoC(aContr[oList:nAt,02]),;																		// periodo inicial
						DtoC(aContr[oList:nAt,03]),;																		// periodo final
						CvalToChar(aContr[oList:nAt,09]) +" meses",;																				// vigencia
						aContr[oList:nAt,10],;																				// indice
						DtoC(aContr[oList:nAt,03]),;																		// data reajuste (data fim)
						DtoC(aContr[oList:nAt,13]),;																		// data ultimo reajuste
						Transform(aContr[oList:nAt,14],PesqPict("CN9","CN9_XINDIC") ),;										// ultimo indice aplicado
						aContr[oList:nAt,11]}}																				// gestor                      

oList:nScrollType := 1 //SCROLL VRC
oList:GoTop()
oList:Refresh(.t.)		
oList:SetFocus()

Return



// Marca/Desmarca o contrato
Static Function Marca()

If !cUserName $ cUsrPerm
	Return    
EndIf
              
If aContr[oList:nAt][16]
	aContr[oList:nAt][16] := .F.
Else
	If aContr[oList:nAt][15] <> "OK"          
		aContr[oList:nAt][16] := .T.   
	EndIf
EndIf


oList:Refresh(.t.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVisual  บAutor  ณJackson E. de Deus    บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVisualiza o contrato posicionado.                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Visual()

Local aArea := GetArea()
Local nRecno := aContr[oList:nAt][nPosRecno]
Private cCadastro := "Contratos"

If nRecno == 0
	Return
EndIf

dbSelectArea("CN9")
dbGoto(nRecno)
AxVisual("CN9",nRecno,2)

RestArea(aArea)

Return
 
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRenova    บAutor  ณJackson E. de Deus  บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz a renovacao dos contratos selecionados.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Renova()

Local nPos, nPos2 := 0
               
// renova os contratos selecionados - U_TTCNTA11()
For nI := 1 To Len(aContr)
	If aContr[nI][16] .And. aContr[nI][15] <> "OK" 
		AADD(aContratos, aContr[nI])
	EndIf
Next nI

If Len(aContratos) == 0
	If !lJob
		Aviso("TTCNTA10","Nenhum contrato foi selecionado.",{"Ok"})	 
	EndIf
	Return
EndIf     

If !FindFunction("U_TTCNTA11")
	If !lJob
		Aviso("TTCNTA10","Fun็ใo U_TTCNTA11 nใo compilada no reposit๓rio.",{"Ok"})
	Else
		ConOut("Fun็ใo U_TTCNTA11 nใo compilada no reposit๓rio.")
	EndIf
	Return
EndIf
	
U_TTCNTA11(aContratos,lJob)

For nI := 1 To Len(aContratos)
	If aContratos[nI][15] == "OK"
		nPos := AScan(aContr, { |x| x[1] == aContratos[nI][1]  } )
		If nPos > 0
			aContr[nPos][15] := "OK"
			aContr[nPos][16] := .F.
			AADD(aContr[nPos], aContratos[nI][17]) 
		EndIf
		
		nPos2 := AScan(aContrBKP, { |x| x[1] == aContratos[nI][1]  } )
		If nPos2 > 0
			aContrBKP[nPos][15] := "OK"
			aContrBKP[nPos][16] := .F.
			AADD(aContrBKP[nPos], aContratos[nI][17]) 
		EndIf                      
	EndIf
Next nI
		
Planilha(.T.)

aContratos := {}

oList:refresh(.t.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPlanilha  บAutor  ณJackson E. de Deus  บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera a planilha em excel                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Planilha(lAtualizou)
                          
Default lAtualizou := .F.

oExcel := FWMSEXCEL():New()

// Primeira aba - alerta dos contratos vencendo/vencidos
oExcel:AddworkSheet("Renovacao")
oExcel:AddTable ("Renovacao","Renovacao")

oExcel:AddColumn("Renovacao","Renovacao","Contrato",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Cliente",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Loja",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Nome",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Tipo de contrato",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Data assinatura",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Periodo inicial",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Periodo final",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Vigencia",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Indice",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Data final para reajuste",1,1) 
oExcel:AddColumn("Renovacao","Renovacao","Ultimo reajuste",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Ultimo indice",1,1)
oExcel:AddColumn("Renovacao","Renovacao","Gestor",1,1)

                        
For nI := 1 To Len(aContr)
	If lAtualizou
		If aContr[nI][15] == "OK"
			oExcel:AddRow("Renovacao","Renovacao",{aContr[nI][1],;
										aContr[nI][4],;
										aContr[nI][5],;
										aContr[nI][6],;
										aContr[nI][8],;
										DTOC(aContr[nI][7]),;
										DTOC(aContr[nI][2]),;
										DTOC(aContr[nI][3]),;
										aContr[nI][9],;
										aContr[nI][10],;
										DTOC(aContr[nI][3]),;
										DTOC(aContr[nI][13]),;
										aContr[nI][14],;
										aContr[nI][11]})
		EndIf
	Else	
		oExcel:AddRow("Renovacao","Renovacao",{aContr[nI][1],;
											aContr[nI][4],;
											aContr[nI][5],;
											aContr[nI][6],;
											aContr[nI][8],;
											DTOC(aContr[nI][7]),;
											DTOC(aContr[nI][2]),;
											DTOC(aContr[nI][3]),;
											aContr[nI][9],;
											aContr[nI][10],;
											DTOC(aContr[nI][3]),;
											DTOC(aContr[nI][13]),;
											aContr[nI][14],;
											aContr[nI][11]})
	
	EndIf													
Next nI


// Segunda aba - contratos atualizados
If lAtualizou
	oExcel:AddworkSheet("Log")
	oExcel:AddTable ("Log","Log")
	
	oExcel:AddColumn("Log","Log","Contrato",1,1)
	oExcel:AddColumn("Log","Log","Atualizou vigencia",1,1)
	oExcel:AddColumn("Log","Log","Atualizou cronograma financeiro",1,1)
	oExcel:AddColumn("Log","Log","Atualizou cronograma fisico",1,1)
	oExcel:AddColumn("Log","Log","Atualizou titulos a receber",1,1)
	
	For nI := 1 To Len(aContr)
		If aContr[nI][15] == "OK"
			oExcel:AddRow("Log","Log",{aContr[nI][1],;
														IIF(aContr[nI][17][1],"SIM","NAO"),;
														IIF(aContr[nI][17][2],"SIM","NAO"),;
														IIF(aContr[nI][17][3],"SIM","NAO"),;
														IIF(aContr[nI][17][4],"SIM","NAO")})
		EndIf													
	Next nI
EndIf

															

oExcel:Activate()

If !lJob
	// verifica existencia do local padrao para gravacao - C:\TEMP\
	If !ExistDir(cDirLocal)
		MakeDir(cDirLocal)
	EndIf
	
	If !ExistDir(cDirLocal)
		Aviso("TTCNTA10","O diret๓rio padrใo para grava็ใo da planilha ้ C:\TEMP."+CRLF +"Houve problemas para gravar nesse local, por favor selecione outro caminho.",{"Ok"})
		cDirLocal := ""
		While AllTrim(cDirLocal) == ""                                                                                                                                   
			cDirLocal := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
		End 
	EndIf
	
	oExcel:GetXMLFile(cDirLocal+"alerta_renovacao.xml")

	If File(cDirLocal +"alerta_renovacao.xml")
		Aviso("TTCNTA10","A planilha foi gerada em " +cDirLocal, {"Ok"})
		If !ApOleClient( 'MsExcel' )
			Aviso("TTCNTA10", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDirLocal,{"Ok"} )
		Else
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(cDirLocal+"alerta_renovacao.xml")
			oExcelApp:SetVisible(.T.)         
			oExcelApp:Destroy()
		EndIf
	EndIf
Else
	If !ExistDir(cDirServer)
		ConOut("## O diretorio " +cDirServer +"nao existe. O diretorio sera criado. ##")
		MakeDir(cDirServer)
	EndIf
	
	If ExistDir(cDirServer)                                                             
		cDia := SubStr(DToC(Date()),1,2)
		cMes := SubStr(DToC(Date()),4,2)
		cAno := CValToChar(Year(Date()))
		cPlanilha := "renovacao_" +cAno +cMes +cDia +"_" +SubStr(Time(),1,2) +SubStr(Time(),4,2) +SubStr(Time(),7,2) +".xml"
		oExcel:GetXMLFile(cDirServer +cPlanilha)
	EndIf
	
	If !File(cDirServer +cPlanilha)
		Conout("## Houve erro ao gerar a planilha de alerta de renovacao no diretorio " +cDirServer +"##")
	Else
		Conout("## Planilha de alerta de renovacao gerada com sucesso no diretorio " +cDirServer +"##")
		If AllTrim(cUsrMail) == ""
			ConOut("## Atencao - Email do destinatario invalido. ##")
		Else	
			U_TTMailN("microsiga",cUsrMail,"renovacao","",{ { cDirServer+cPlanilha ,'Content-ID: <ID_renovacao.xml>'} },.F.)
		EndIf
	EndIf	  	
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEmail  บAutor  ณJackson E. de Deus     บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Email()

Local cRemete	:= SuperGetMV("MV_RELACNT",.T.,"microsiga",) 
Local cSubject	:= "Vencimento de contratos"
Local cTarget	:= "jdeus@toktake.com.br" //".contratos"
Local cbody		:= ""
Local aAttach	:= {}

// Gera o html para enviar por email 
cbody := "<html>"
cbody += "<head>"
cbody += "<title>Renova็ใo de contratos</title>"

// Estilos
cbody += "<style type='text/css'>"
cbody += "	table.bordasimples {border-collapse: collapse;}"
cbody += "	table.bordasimples tr td {border:1px solid #BC8F8F;}"
cbody += "	body { background-color: #FFFFFF;"
cbody += "	color: #5D665B; "
cbody += "	margin: 50px;"
cbody += "	font-family: Georgia, 'Times New Roman', Times, serif;"
cbody += "	font-size: small;"
cbody += " 	}"
cbody += "</style>"
cbody += "</head>"

// Corpo	
cbody += "<body>"
cbody += "<p><strong>E-mail informativo referente aos contratos que estใo vencendo. </strong></p>"
cbody += "<p>&nbsp;</p>"

// Tabela com os dados
cbody += "<p><strong>Contratos vencendo/vencidos:</strong></p>"
cbody += "<table class='bordasimples'>"          
cbody += "<tr>"	
cbody += 	"<th>Contrato</th>"
cbody += 	"<th>Cliente</th>"
cbody += 	"<th>Loja</th>"
cbody += 	"<th>Nome</th>"
cbody += 	"<th>Tipo de contrato</th>"
cbody += 	"<th>Data de Assinatura</th>"
cbody += 	"<th>Perํodo inicial</th>"
cbody += 	"<th>Perํodo final</th>"
cbody += 	"<th>Vig๊ncia</th>"
cbody += 	"<th>Indice</th>"
cbody += 	"<th>Data final para reajuste</th>"
cbody += 	"<th>Ultimo reajuste</th>"
cbody += 	"<th>Ultimo indice</th>"
cbody += 	"<th>Gestor</th>"
cbody += "</tr>"
			
For nI := 1 To Len(aContr)
	cbody += "<tr>"							
	cbody += 	"<td>" +aContr[nI][1] +"</td>"	
	cbody += 	"<td>" +aContr[nI][1] +"</td>"	
	cbody += 	"<td>" +aContr[nI][5] +"</td>"	
	cbody += 	"<td>" +aContr[nI][6] +"</td>"	
	cbody += 	"<td>" +aContr[nI][8] +"</td>"	
	cbody += 	"<td>" +dtoc(aContr[nI][7]) +"</td>"
	cbody += 	"<td>" +dtoc(aContr[nI][2]) +"</td>"	
	cbody += 	"<td>" +dtoc(aContr[nI][3]) +"</td>"	
	cbody += 	"<td>" +cvaltochar(aContr[nI][9]) +"</td>"	
	cbody += 	"<td>" +aContr[nI][10] +"</td>"	
	cbody += 	"<td>" +dtoc(aContr[nI][3]) +"</td>" 
	cbody += 	"<td>"+dtoc(aContr[nI][13])+"</td>"	
	cbody += 	"<td>"+CVALTOCHAR(aContr[nI][14])+"</td>"	
	cbody += 	"<td>" +aContr[nI][11] +"</td>"	
	cbody += "</tr>"
Next nI

cbody += "</table>"
cbody += "<p>&nbsp;</p>"
cbody += "<p>E-mail automแtico enviado via protheus.</p>"
cbody += "<p>Favor nใo responder.</p>"
cbody += "</body>"
cbody += "</html>
	                 
U_TTMailN(cRemete,cTarget,cSubject,cbody,aAttach,.F.)


Return

       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDados บAutor ณJackson E. de Deus    	 บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca os dados dos contratos.								  บฑฑ
ฑฑบ          ณ        													  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Dados() 

Local cQuery := ""
Local cTipoCont := ""
Local dDescCont := ""
Local cNome := ""
Local cFlag := ""


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ           	
//ณBusca os contratosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
cQuery := "SELECT DISTINCT CN9.R_E_C_N_O_ CN9REC, CN9_NUMERO, CN9_DTINIC, CN9_DTFIM, CN9_CLIENT, CN9_LOJACL, CN9_DTASSI, CN9_XTPCNT, CN9_XANLAT, CN9_VIGE, CN7_DESCRI, CN9_DESCRI, A3_NOME, CN9_XREAJU, CN9_XINDIC "
cQuery += "FROM " +RetSqlName("CN9") + " CN9 "

// Indices
cQuery += "LEFT JOIN " +RetSqlName("CN7") + " CN7 ON "
cQuery += "CN9_INDICE = CN7_CODIGO "
cQuery += "AND CN7.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " +RetSqlName("SA1") + " SA1 ON "
cQuery += "SA1.A1_COD = CN9.CN9_CLIENT "
cQuery += "AND SA1.A1_LOJA = CN9.CN9_LOJACL "
cQuery += "AND SA1.D_E_L_E_T_ = '' "

cQuery += "LEFT JOIN " +RetSqlName("SA3") + " SA3 ON "
cQuery += "A3_COD = A1_VEND "
cQuery += "AND SA3.D_E_L_E_T_ = '' "

cQuery += "WHERE "
cQuery += "CN9.D_E_L_E_T_  = '' "

//Se for execucao via Job, considerar somente contratos com Renovacao automatica
If lJob
	cQuery += "AND CN9.CN9_XAUTRJ = 'S' "	
EndIf

//cQuery += "AND CN9.CN9_DTFIM <= '"+DTOS(date()+120)+"' "

cQuery += "ORDER BY CN9.CN9_DTFIM DESC "

If Select("TRBCN9") > 0
	TRBCN9->(dbCloseArea())
EndIF
                           
tcquery cquery new alias "TRBCN9"

dbSelectArea("TRBCN9")
dbGoTop()
While !EOF()
	// pega o tipo de contrato
	cTipoCont := ""
	dDescCont := ""
	cTipoCont := GetAdvFVal("CN9","CN9_TPCTO",xFilial("CN9")+TRBCN9->CN9_NUMERO,1)
	dDescCont := GetAdvFVal("CN1","CN1_DESCRI",xFilial("CN1")+cTipoCont,1)
	
	// Verifica se ja venceu
	If StoD(TRBCN9->CN9_DTFIM) < Date()
		cFlag := "VENCIDO"
	Else
		cFlag := "VENCENDO"	
	EndIf
	
	If AllTrim(TRBCN9->CN9_DESCRI) == ""
		cNome := GetAdvFVal("SA1","A1_NREDUZ",xFilial("SA1")+TRBCN9->CN9_CLIENT+TRBCN9->CN9_LOJACL,1)
	Else
		cNome := TRBCN9->CN9_DESCRI
	EndIf	
	                                               
	AADD(aContr, {	TRBCN9->CN9_NUMERO,;				//[1] Numero
					StoD(TRBCN9->CN9_DTINIC),;			//[2] Data Inicio
					StoD(TRBCN9->CN9_DTFIM),;			//[3] Data Fim
					TRBCN9->CN9_CLIENT,;				//[4] Cliente
					TRBCN9->CN9_LOJACL,;				//[5] Loja
					cNome,;								//[6] Nome Cliente
					StoD(TRBCN9->CN9_DTASSI),;			//[7] Data de assinatura
					dDescCont,;							//[8] Tipo de contrato
					TRBCN9->CN9_VIGE,;					//[9] Periodo de vigencia
					TRBCN9->CN7_DESCRI,;				//[10] Indice do contrato
					UPPER(TRBCN9->A3_NOME),;			//[11] VENDEDOR
					TRBCN9->CN9REC,;					//[12] Recno do contrato
					StoD(TRBCN9->CN9_XREAJU),;			//[13] Ultimo reajuste
					TRBCN9->CN9_XINDIC,;				//[14] Ultimo indice
					cFlag,;								//[15] Processado
					.F.})								//[16] Flag marcacao
	dbSkip()
End
dbCloseArea()                          

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCNTA12  บAutor  ณJackson E. de Deus  บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLegenda                                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCNTA12()

BrwLegenda("Renova็ใo","Status",{{"BR_VERDE","Contrato atualizado"},;
                               {"BR_AMARELO","Contrato vencendo"},;
                               {"BR_VERMELHO","Contrato vencido"}})
							
Return .T.