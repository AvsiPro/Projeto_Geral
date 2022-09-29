#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TTCOMC07  �Autor  �Jackson E. de Deus  � Data �  02/05/13  ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para Importa��o de XMLs.                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Compras                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTCOMC07()             

Private cPath		:= SuperGetMV("MV_XXMLPL",.T.,"")
Private cPathLoc	:= ""
Private cPathServ	:= SuperGetMV("MV_XXMLPR",.T.,"")
Private cFilOrig	:= ""
Private aDados		:= {}

MsAguarde({ || BuscaXML()},"Efetuando leitura dos arquivos XML, por favor aguarde...")

// Se Array possui valores mostra tela para escolha do XML
If Len(aDados) > 0
     Tela()
EndIf

Return


       
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BuscaXML �Autor  �Jackson E. de Deus  � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca os arquivos XML no diret�rio parametrizado.	      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TTCOMC07()                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function BuscaXML()       
                  
Local cFile
Local _aArqs	:= {}                                   
Local oXml		:= NIL
Local cError	:= ""
Local cWarning	:= ""
Local _cCNPJATU := ""
Local cCNPJ_DES := ""
Local cCNPJ_FOR := ""
Local cSerie	:= ""
Local cNum		:= ""
Local cFornec	:= ""
Local cLjFornec := ""
Local cNomeFor	:= ""

// Atribui ao final do path
If cEmpAnt == "01"
	cPath += "TT\"
EndIf

cPathLoc := cPath
                                   
_aArqs := Directory(RTrim(cPathLoc)+"*.xml")

If Len(_aArqs) == 0                                                          
	MsgBox("Caminho informado <"+RTrim(cPathLoc)+;                              
	"> est� incorreto ou n�o h� arquivos a serem "+;                    
	"importados.","Problema","Stop")
	Return                             
EndIf	

MsProcTxt("Lendo os arquivos..")
// Efetua leitura de todos os xmls do diret�rio
For nX := 1 To Len(_aArqs)
	//MsProcTxt("XML: "+_aArqs[nX])

    cPathLoc := cPath
    cFile := ""
    
	cFile := cPathLoc+_aArqs[nX][1]
	cFile := Lower(cFile)
	
	// se houver cte no nome do arquivo, pula para o proximo
	If "cte" $ cFile
		Loop
	EndIf
			
	If File(cFile,2)
		CpyT2S(cFile,cPathServ)
	Else
		MsgAlert(OemToAnsi("O arquivo '") + cFile + OemToAnsi("' n�o foi encontrado. O arquivo ficar� fora da importa��o."))
		//Return
		Loop
	EndIf
	
	// Nome do arquivo
	cNomArq := xGetFile(cFile, @cPathLoc)
	
	// Gera o objeto com dados do XML
	oXml := XmlParserFile( cPathServ+cNomArq, "_", @cError, @cWarning )
	If ValType(oXml) != "O"
	     Alert(cNomArq+" - "+cError)
	     Return()
	Endif
    
    // Verifica Tag inicial do arquivo XML
	If XmlChildEx( oXml, "_NFEPROC" ) == Nil
		Loop
	EndIf

	If XmlChildEx( oXml:_NFEPROC:_NFE, "_INFNFE" ) == Nil
		Loop
	EndIf

	cCNPJ_FOR := oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
	dbSelectArea("SA2")
	dbSetOrder(3)
	If DbSeek(xFilial("SA2")+cCNPJ_FOR)
		cFornec		:= SA2->A2_COD
		cLjFornec	:= SA2->A2_LOJA
		cNomeFor	:= SA2->A2_NOME
	EndIf	
		
	cNum	:= PadL(Alltrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0")
	cSerie	:= PadR(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text,3," ")

	cCNPJ_DES := oXml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
	
	// Verifica empresa ativa - COMENTADO POIS ESSA VERIFICACAO JA ACONTECE NO IMPXMLNFE - GANHO DE PERFORMANCE
	/*
	OpenSm0()
	SM0->(dbGoTop())
	While !SM0->(Eof())
	     If cEmpAnt == SM0->M0_CODIGO
			_cCNPJATU := SM0->M0_CGC
	     Endif             
	     
	     If cCNPJ_DES == SM0->M0_CGC
	          cFilOrig := SM0->M0_CODFIL
	          Exit
	     Endif
	     SM0->(dbskip())
	EndDo
	*/ 
	
	// Compara CNPJ do destinat�rio da NF para saber se o arquivo xml � para a empresa correta
	//If cCNPJ_DES == _cCNPJATU
	MsProcTxt("Montando dados para tela..")
	
	AADD(aDados, {.F.,;				// aDados[1]  -> Flag de controle de processamento do XML
					.F.,;			// aDados[2]  -> Flag de controle de marca��o - escolha
					cCNPJ_FOR,;		// aDados[3]  -> CNPJ do Fornecedor
					cFornec,;		// aDados[4]  -> Cod. do Fornecedor
					cLjFornec,;		// aDados[5]  -> Loja do Fornecedor
					cNomeFor,;		// aDados[6]  -> Nome do Fornecedor
					cNum,;			// aDados[7]  -> Numero da Nota
					cSerie,;		// aDados[8]  -> Serie
					.T.,;			// aDados[9]  -> Flag de controle de marca��o - Gera��o de confer�ncia cega - via Web Services
					cFile;			// aDados[10] -> Nome do arquivo xml
					})	
	//EndIf  
	

Next nX

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Tela �Autor  �Jackson E. de Deus      � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para importa��o dos arquivos XML de Nfe				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TTCOMC07()                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Tela()

Local aRetParam	:= {}
Local aSize		:= MsAdvSize()
Private oOk		:= LoadBitMap(GetResources(), "BR_PINK")
Private oNo		:= LoadBitMap(GetResources(), "BR_PRETO")
Private oSim	:= LoadBitMap(GetResources(), "LBOK")
Private oNao	:= LoadBitMap(GetResources(), "LBNO")
Private oTcBrowse	     
Private oDlgX 
Private aBrowse
Private aHeaders := {"","", "CNPJ","C�digo", "Loja", "Nome", "Nota Fiscal", "S�rie", "Conf. Cega"}
Private oGroup
Private oGroup2
Private oGroup3
Private oBtn1
Private oGet1
Private oCBox1
Private oBut
Private oBut2
Private oBut3
Private cGetFil := space(14)
Private aItems := {"CNPJ", "Nota Fiscal"}
Private cCombo := aItems[1]
Private oMGet1
Private oMemo
Private cMemo:= ""//space(1)
Private lMudaTela := .F.

aBrowse := aCLone(aDados)

oDlgX := MSDialog():New(110,234,500,985,"Importa��o de Nota Fiscal Eletr�nica",,,.F.,,,,,,.T.,,,.T. ) 
	
	// Grupo 1
	oGroup	:= TGroup():New(004,006,152,372,"Arquivos XML em " +cPath,oDlgX,CLR_BLACK,CLR_WHITE,.T.,.F.)
	oTcBrowse := TCBrowse():New(15,10,358,132,,aHeaders,{5,5,20,20,10,70,30,10,10},oGroup,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.F.,)
	
	oTcBrowse:SetArray(aBrowse)
	
	oTcBrowse:AddColumn(TCColumn():New(' '			,{||If(aBrowse[oTcBrowse:nAt,01],oOk,oNo)},"@BMP",,,,,.T.,.F.,,,,.F., ) )		// Processados
	oTcBrowse:AddColumn(TCColumn():New(' '			,{||If(aBrowse[oTcBrowse:nAt,02],oSim,oNao)},"@BMP",,,,,.T.,.F.,,,,.F.,))		// Escolhidos
	oTcBrowse:AddColumn(TCColumn():New('Cnpj'		,{||aBrowse[oTcBrowse:nAt,03]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('C�digo'		,{||aBrowse[oTcBrowse:nAt,04]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Loja'		,{||aBrowse[oTcBrowse:nAt,05]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Nome'		,{||aBrowse[oTcBrowse:nAt,06]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Nota Fiscal',{||aBrowse[oTcBrowse:nAt,07]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('S�rie'		,{||aBrowse[oTcBrowse:nAt,08]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	//oTcBrowse:AddColumn(TCColumn():New('Conf. Cega'	,{||If(aBrowse[oTcBrowse:nAt,09],oSim,oNao)},"@BMP",,,'LEFT',,.T.,.F.,,,,.F.,))	// Gera conferencia cega?
	
	oTcBrowse:SetArray(aBrowse)
	oTcBrowse:bWhen        := { || Len(aBrowse) > 0 }     
	
	oTcBrowse:lUseDefaultColors := .F.
	
	// Busca os itens para mostrar na tela
	FiltraXML()
	
	oTcBrowse:bLDblClick := {|| DblClk(),oTcBrowse:DrawSelect()}  
	
	// Grupo 2
	oGroup2	:= TGroup():New( 156,006,192,212,"Pesquisa",oDlgX,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet1	:= TGet():New( 170,010,{|u| If(PCount()>0, {cGetFil := "", cGetFil += u}, cGetFil)},oGroup2,100,008,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cGetFil,,,, )
	oCBox1	:= TComboBox():New( 170,112,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItems,048,010,oGroup2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo)
	oBtn1	:= TButton():New( 168,164,"Filtrar",oGroup2,{|| FiltraXML() },041,016,,,,.T.,,"",,,,.F. )
	
	// Grupo 3
	oGroup3	:= TGroup():New( 156,216,192,372,"A��es",oDlgX,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBut 	:= TButton():New( 168, 274, "Importar",oDlgX,{|| Importa() },037,016,,,.F.,.T.,.F.,,.F.,,,.F. )  
	oBut2 	:= TButton():New( 168, 324, "Sair",oDlgX,{|| oDlgX:End() },037,016,,,.F.,.T.,.F.,,.F.,,,.F. )
	oBut3 	:= TButton():New( 168, 225, "Inverte"  ,oDlgX,{|| SelAll() },037,016,,,.F.,.T.,.F.,,.F.,,,.F. ) 
	
	// Grupo 4 - Log de opera��o
	oGroup4 := TGroup():New( 196,006,240,372,"Log de opera��o",oDlgX,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oMGet1  := TMultiGet():New( 204,008,{|u| if(pCount() > 0, cMemo := u, cMemo)},oGroup4,360,034,,.T.,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,.T.)
	
	
	oDlgX:Refresh()

oDlgX:Activate(,,,.T.)                                                                                                                                                                   



Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FiltraXML   �Autor  �Jackson E. de Deus� Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtra os arquivos XML por CNPJ ou por N�mero de Nota.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Tela()                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FiltraXML()

Local lRet := .F.
Local nPos 

IIF(oCBOX1 <> NIL .Or. oCBOX1 == 0,nPos := oCBOX1:NAT,1)

// Se o filtro � por CNPJ - posicao 9 no Array
If nPos == 1                 	
	If !Empty(cGetFil) .And. !CGC(AllTrim(cGetFil))
		Return
	EndIf
	
	// Zera Array aBrowse
	aBrowse := {}                         
	// Varre Array aDados
	For nX := 1 To Len(aDados)
		If aDados[nX][3] <> AllTrim(cGetFil)
			Loop
		Else	
			AADD(aBrowse, ;
				{aDados[nX][1],;
				aDados[nX][2],;
				aDados[nX][3],;
				aDados[nX][4],;
				aDados[nX][5],;
				aDados[nX][6],;
				aDados[nX][7],;
				aDados[nX][8],;
				aDados[nX][9],;
				aDados[nX][10]} )
		EndIf                    
	Next nX
		
// Se filtro � por N�mero de Nota - posicao 7 no Array
ElseIf nPos == 2
	If Len(Alltrim(cGetFil)) > 9
		MsgAlert("A quantidade de caracteres informada n�o � v�lida!" +CRLF +"Tamanho m�ximo: 9 caracteres." )
		Return
	EndIf	                                                                                                  
	
	// Zera Array aBrowse
	aBrowse := {}                         
	// Varre Array aDados
	For nX := 1 To Len(aDados)
		If aDados[nX][7] <> AllTrim(cGetFil)
			Loop
		Else	
			AADD(aBrowse, ;
				{aDados[nX][1],;
				aDados[nX][2],;
				aDados[nX][3],;
				aDados[nX][4],;
				aDados[nX][5],;
				aDados[nX][6],;
				aDados[nX][7],;
				aDados[nX][8],;
				aDados[nX][9],;
				aDados[nX][10]} )
		EndIf                    
	Next nX	
EndIf

// Se n�o encontrou nada, clona novamente o Array aDados em aBrowse
If Len(aBrowse) == 0
	aBrowse := AClone(aDados)   
EndIf

// Atualiza Array do objeto oTcBrowse
oTcBrowse:SetArray(aBrowse)

oTcBrowse:GoTop()
oTcBrowse:Refresh(.t.)		
oTcBrowse:SetFocus()

Return

            
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Importa    �Autor  �Jackson E. de Deus � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Faz a importa��o dos arquivos XMLs selecionados.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Tela()                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Importa()

Local aD 		:= {} 
Local lExe  	:= .F.
Local cMsgFim	:= ""
Local lGeraOS	:= .F.
Local cPathProc	:= ""
Local cDirCnpj	:= ""
Private lVldImp	:= .F.

// Verifica selecao dos arquivos
For nX := 1 To Len(oTcBrowse:AArray)
	If oTcBrowse:AArray[nX][2]
   		lExe := .T.
   		Exit
	EndIf
Next nX

If !lExe
	MsgAlert("Selecione os arquivos para importa��o.")
	Return
EndIf 


For nX := 1 To Len(oTcBrowse:AArray)    
    // Se ja foi importado
	If oTcBrowse:AArray[nX][1]
		MsgAlert("Xml j� importado! NF: "+oTcBrowse:AArray[nX][7] +"/" +oTcBrowse:AArray[nX][8])
		cMemo += "ERRO -> " +"Xml j� importado! NF: "+oTcBrowse:AArray[nX][7] +"/" +oTcBrowse:AArray[nX][8] +CRLF
		Loop
	EndIf
	
	// Se nao foi importado e esta marcado                                 
	If !oTcBrowse:AArray[nX][1] .And. oTcBrowse:AArray[nX][2]
		// Volta o estado da vari�vel de controle para FALSO
		lVldImp := .F.
		cArqXML := oTcBrowse:AArray[nX][10]			// arquivo atual
        cDirCnpj := oTcBrowse:AArray[nX][3]			// cnpj

		// Se deve gerar Conferencia cega, altera variavel lGeraOS que deve ser passada como parametro
		//IIf(oTcBrowse:AArray[nX][9],lGeraOS := .T.,.F.)			
		
		// Verifica no RPO se a funcao esta compilada
		If !FindFunction("U_ImpXmlNfe")
			Aviso( "IMPORTA" , "Fun��o: U_ImpXmlNfe" + CRLF + "N�o encontrada no RPO." +CRLF +"O programa n�o continuar�." , {"Ok"} )
			Exit
		EndIf
		
		// Importa o XML
		lVldImp := U_ImpXmlNfe(cArqXML)
		If lVldImp
			cMemo += "OK -> " +"Nota Fiscal importada com sucesso: " +oTcBrowse:AArray[nX][7] +"/" +oTcBrowse:AArray[nX][8] +CRLF
			oTcBrowse:AArray[nX][1] := .T.	// Atualiza status para Xml j� importado
			
			// Atualiza status para Xml j� importado
			For nY := 1 To Len(aDados)
				If aDados[nY][10] == cArqXML
					aDados[nY][1] := .T.
				EndIf
			Next nY
			
			
			FErase(cPath+cArqXML)
		
			
			
			/*
			// Move o arquivo xml para o diret�rio de arquivos processados
			cArqXML := xGetFile(cArqXML, cPath)
			
			// Altera o nome do diretorio de destino para Path + Filial + CNPJ do Fornecedor
			cPathProc += cPath +cFilOrig +"\" +cDirCnpj +"\"   
            
			// Se nao existir o diretorio da filial, cria
			If !ExistDir(cPath+cFilOrig)
				MakeDir(cPath +cFilOrig)
			EndIf
			
			// Se nao existir o diretorio do fornecedor (cnpj), cria
			If !ExistDir(cPathProc)
				MakeDir(cPath +cFilOrig +"\" +cDirCnpj)
				FRename(cPath+cArqXML, cPathProc+cArqXML)
			Else
				FRename(cPath+cArqXML, cPathProc+cArqXML)					
			EndIf
			*/
		Else
			// Erro na importa��o	
			cMemo += "ERRO -> " +"Nota Fiscal n�o importada: " +oTcBrowse:AArray[nX][7] +"/" +oTcBrowse:AArray[nX][8] +CRLF
		EndIf	
	EndIf			
Next nX

// Altera o tamanho da tela para mostrar o GroupBox do Log de Opera��es
If !lMudaTela
	oDlgX:nHeight+=95
	lMudaTela := .T.
EndIf

oTcBrowse:Refresh(.t.)		
oTcBrowse:SetFocus()	 


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DblClk  �Autor  �Jackson E. de Deus  	 � Data �  05/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o executada no duplo clique da linha, marca a linha   ���
���          � como selecionada ou n�o-selecionada.                       ���
���          � Marca tamb�m a coluna de confer�ncia cega, caso o clique	  ���
���          � seja nela.												  ���
�������������������������������������������������������������������������͹��
���Uso       � Tela()                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DblClk()


// Verifica Flag de marca��o para gera��o de confer�ncia cega
If oTcBrowse:colpos == 9 
	If aBrowse[oTcBrowse:nAt][oTcBrowse:colpos] 
		aBrowse[oTcBrowse:nAt][oTcBrowse:colpos]  := .F.
	Else
		aBrowse[oTcBrowse:nAt][oTcBrowse:colpos]  := .T.	
	EndIf
	Return		
EndIf

// Verifica Flag de marca��o para importa��o
If aBrowse[oTcBrowse:nAt][2]         
       aBrowse[oTcBrowse:nAt][2] := .F.		
Else
	aBrowse[oTcBrowse:nAt][2] := .T.                                   
EndIf


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SelAll  �Autor  �Jackson E. de Deus  	 � Data �  05/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Marca ou desmarca todos as linhas da TCBrowse.             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Tela()                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function SelAll()

For nX := 1 To Len(oTcBrowse:AArray)
	If oTcBrowse:AArray[nX][2]
		oTcBrowse:AArray[nX][2] := .F.
	Else
		oTcBrowse:AArray[nX][2] := .T.	
    EndIf
Next nX

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xGetFile �Autor  �Jackson E. de Deus   � Data �  05/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Separa nome do Arquivo do Path                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BuscaXML(), Importa()                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xGetFile(cArq, cPath)

Local cBarra  := "\"
Local nPos    := AT(cBarra,cArq)
DEFAULT cPath := "" 

While nPos > 0                     
	cPath += SubStr(cArq, 1, nPos)
	cArq  := SubStr(cArq, nPos + 1)
	nPos := AT(cBarra, cArq)
Enddo

Return cArq