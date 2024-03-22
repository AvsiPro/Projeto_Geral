#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#Include 'rwmake.ch'
#INCLUDE 'FWMVCDEF.CH'

/*
+----------------------------------------------------------------------------+
!Descricao         ! Programas Listagem De Importacao de ABASTECIMENTO       !
+------------------+---------------------------------------------------------+
!Programa          ! ROT006                                                  !
+------------------+---------------------------------------------------------+
!Autor             ! Marcio Da Silva                                         !
+------------------+---------------------------------------------------------+
!Empresa           ! TOTVS                                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 21/11/2022                                              !
+------------------+---------------------------------------------------------+
*/

User Function ROT006()        // incluido pelo assistente de conversao do AP5 IDE em 02/05/01
	Private oMark
	Private aRotina := MenuDef()
	SetKey( VK_F12, { || u_ROT006G() } )
	oMark := FWMarkBrowse():New()
	oMark:SetAlias('Z01')
	oMark:SetSemaphore(.T.)
	oMark:SetDescription('Seleção do Controle de Importacao de Abastecimento')
	oMark:SetFieldMark( 'Z01_OK' )
	oMark:SetAllMark( { || oMark:AllMark() } )
	oMark:AddLegend( "Empty(Z01_OBS)"  , "GREEN", "Autor" )
	oMark:AddLegend( "!Empty(Z01_OBS)"  , "RED"  , "Interprete" )

	oMark:Activate()
	SetKey( VK_F12, nil )

Return NIL
//    oMark:SetMenuDef("ROT006X")


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria  o do menu MVC                                          |
 *---------------------------------------------------------------------*/
Static Function MenuDef()
    Local aRotina := {}
    ADD OPTION aRotina TITLE 'Importar'              		ACTION 'u_ROT006A()'          OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Processar'             		ACTION 'u_ROT006D()'          OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Validar Registros'     		ACTION 'u_ROT006H()'          OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar Fornecedor'    		ACTION 'u_ROT006I()'          OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Controle de Postos'    		ACTION 'u_ROT006J()'          OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Controle de Veiculos'    		ACTION 'u_ROT006L()'          OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Controle de Motorista' 		ACTION 'u_ROT006K()'          OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Marcar Todos'          		ACTION "u_ROT006F('1')"       OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Desmarcar Todos'       		ACTION "u_ROT006F('2')"       OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE 'Legenda Importacao Registro'  ACTION "u_ROT006G()"         OPERATION 6 ACCESS 0


Return aRotina
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria  o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
  
Static Function ModelDef()
    Local oModel := Nil
    Local oStZ01 := FWFormStruct(1, "Z01")

    oStZ01:SetProperty('Z01_IDTRAN',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi  o
    oModel := MPFormModel():New("ROT006X",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
    oModel:AddFields("FORMZ01",/*cOwner*/,oStZ01)
    oModel:SetPrimaryKey({'Z01_FILIAL','Z01_IDTRAN'})
    oModel:SetDescription("Importacao De Orcamento")
    oModel:GetModel("FORMZ01"):SetDescription("Importacao De Orcamento")
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: MArcio Da Silva                                              |
 | Data:  18/10/2022                                                   |
 | Desc:  Cria  o do menu MVC                                          |
 *---------------------------------------------------------------------*/
Static Function ViewDef()
    Local oModel := FWLoadModel("ROT006X")
    Local oStZ01 := FWFormStruct(2, "Z01")  //pode se usar um terceiro par metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
    Local oView := Nil
 
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    oView:AddField("VIEW_Z01", oStZ01, "FORMZ01")
    oView:CreateHorizontalBox("TELA",100)
     
    oView:EnableTitleView('VIEW_Z01', "Importacao De Orcamento" )  
    oView:SetCloseOnOk({||.T.})
    oView:SetOwnerView("VIEW_Z01","TELA")
Return oView
 
/*/{Protheus.doc} zMarkProc
Rotina para processamento e verifica  o de quantos registros est o marcados
@author Atilio
@since 03/09/2016
@version 1.0
/*/


*************************
User Function ROT006A() //Atualiza API AGROTIS
***************
//Local cPerg := "ROT006"
//AjustaSX1(cPerg)	

//If Pergunte(cPerg,.T.)	          
    If MsgYesNo("Continua Importação Abastecimento?", "Confirma?")
        Processa({|| fROT006B()}) // Atualizar Produto Embalagem SANIAGRO
    EndIf 
//EndIf 
Return()    

*************************
Static Function fROT006B() //Atualiza API AGROTIS
***************
//Local cLocalArq := "C:/TEMP/"
//Local cNomeArq  := "Resultado.csv"
Local nI        := 1 
Local cServidor := GETMV("MV_XSERABA")//'integracao.embratec.com.br'
Local cLogin    := GETMV("MV_XLOGABA")//'sftp.C190894'
Local sSenha    := GETMV("MV_XSENABA")//'jSTambFlQtjUW0L'
Local cOrigem   := GETMV("MV_XORIABA")//'/sftp.C190894/SAIDA/Backup'
Local cDestino  := GETMV("MV_XLOCABA") ///arq_abastecimento/ 
local cErrorMsg := ''
Local aMsgSch	:= {}
Local nStatus	:= 0 

	aFiles := SFTPDirLS(cServidor, cOrigem,cLogin, sSenha, @cErrorMsg)
	if ( valtype(aFiles) == 'A' )
		While nI <= Len(aFiles) .And. nStatus == 0 
			If Subs(Alltrim(aFiles[nI]),AT('_',Alltrim(aFiles[nI]))+1,8) > dtos(dDataBase - 10) .And. ".txt" $ Alltrim(aFiles[nI])
				DbSelectArea("Z02")
				DbSetOrder(1)
				If !(DbSeek(xFilial("Z02")+Alltrim(aFiles[nI])))
					nStatus := SFTPDwld1( cDestino+Alltrim(aFiles[nI]), cOrigem+'/'+Alltrim(aFiles[nI]), cServidor, cLogin, sSenha , [ @cErrorMsg] )
					If !nStatus == 0 
						AADD(aMsgSch,"Erro cópia Arquivo "+Alltrim(aFiles[nI]))
					Else	
						RECLOCK("Z02", .T. )
							Z02->Z02_FILIAL := xFilial("Z02")
							Z02->Z02_ARQUIV := Alltrim(aFiles[nI])
							Z02->Z02_DATA   := dDataBase
						MsUnlock("Z02")
					EndIf
				EndIf
			EndIf
			nI += 1
		EndDo
	Else 
		cErrorMsg := "Falha na Conexcao com FTP : Erro "+cErrorMsg 
		AADD(aMsgSch,cErrorMsg)
	EndIf


    sEE_EXTRET := 'TXT' 
    aArq := Directory(cDestino + "*." + AllTrim(sEE_EXTRET) + "*")

    For nI := 1 to Len(aArq)
        // Armazena o nome do arquivo nos parâmetros.
        cArquivo := aArq[nI, 1]
        aMsgSch := {}
        fROT006B1(cDestino+cArquivo)
//          Envia e-mail (FINA205) das mensagens de erro
//			FA205MAIL("Retorno Bancario Automatico (Pagar)", cDirArq + cArquivo, aMsgSch) // 
		cPathArq := cDestino + cArquivo
		If FErase(cPathArq) < 0
			ConOut("Não foi possível excluir o arquivo " + cPathArq) // "Não foi possível excluir o arquivo "
		EndIf
    Next nI
Return Nil


*************************
Static Function fROT006B1(cNomeArq) //Atualiza API AGROTIS
***************
Local aErro := {}
    //cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diret rio que est  o arquivo"), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)
    If !File(cNomeArq)
        MsgStop("O arquivo " +cLocalArq+cNomeArq + " n o foi encontrado. A importa  o ser  abortada, VERIFIQUE se o arquivo esta na pasta mapeada CORRETAMENTE.","ATENCAO")
        Return
    EndIf
    FT_FUSE(cNomeArq)
	If Len(cUsuario)> 200
	    Procregua(FT_FLASTREC())    
	EndIf	
    FT_FGOTOP()
    While !FT_FEOF()

        cLinha    := FT_FREADLN()
        aDados := {}
        AADD(aDados,Separa(cLinha,";",.T.))
		If Len(cUsuario)> 200
	        IncProc("Processando Importacao...")
		EndIf	
        If Len(aDados) > 0  //.And. val(aDados[1][1]) > 0
			aErro := {}

			DbSelectArea("Z01") 
			DbSetOrder(1)
			If !DbSeek(xFilial("Z01")+Alltrim(aDados[1][18]))
				DbSelectArea("TQN") 
				DbSetOrder(17)
				If !DbSeek(xFilial("TQN")+Alltrim(aDados[1][18]))
					sZ01_IDTRAN     := Alltrim(aDados[1][18])   
					sZ01_TIPOCB     := Alltrim(aDados[1][7])			
					sZ01_MATCOL     := Strzero(val(aDados[1][17]),TamSX3( "DA4_COD" )[1])
					sZ01_CGCPOS     := Alltrim(aDados[1][12])
					sZ01_PLACA      := Alltrim(aDados[1][10])

					dZ01_DTTRAN     := Ctod(Left(aDados[1][3],10))
					sZ01_HRTRAN     := Subs(aDados[1][3],12,5)

					aErro 			:= fROT006B3(sZ01_PLACA, sZ01_TIPOCB,sZ01_MATCOL,sZ01_CGCPOS,dZ01_DTTRAN, sZ01_HRTRAN ) // Cadastra Fornecedor
					DbSelectArea("Z01") 
					RECLOCK("Z01", .T. )
					Z01->Z01_OK         := ''
					Z01->Z01_IDTRAN     := Alltrim(aDados[1][18])    
					Z01->Z01_CGCPOS     := Alltrim(aDados[1][12])
					Z01->Z01_NR_ID      := Alltrim(aDados[1][1])
					Z01->Z01_REG        := Alltrim(aDados[1][2])
					Z01->Z01_DTTRAN     := Ctod(Left(aDados[1][3],10))
					Z01->Z01_HRTRAN     := Subs(aDados[1][3],12,5)
					Z01->Z01_TOTABA     := Val(aDados[1][4])
					Z01->Z01_CDCART     := Alltrim(aDados[1][5])
					Z01->Z01_TOTLT      := Val(aDados[1][6])
					Z01->Z01_TIPOCB     := Alltrim(aDados[1][7])
					Z01->Z01_TPSRV      := '1'
					Z01->Z01_NINDET     := Alltrim(aDados[1][9])
					Z01->Z01_PLACA      := Alltrim(aDados[1][10])
					Z01->Z01_KMATUA     := Alltrim(aDados[1][11])
					Z01->Z01_NMPOST     := SA2->A2_NOME
					Z01->Z01_MATCOL     := Strzero(val(aDados[1][17]),TamSX3( "DA4_COD" )[1])
					Z01->Z01_OBS        := aErro[1]
					Z01->Z01_TPERRO		:= aErro[2]
					MsUnlock("Z01")
		        EndIf
	        EndIf
        EndIf
        FT_FSKIP()
    Enddo     
    DbSelectArea("Z01"); DbSetOrder(1)
    DbGotop()
	FT_FUse()	
Return Nil

*******************************
Static Function fROT006B2(sCGC) // Cadastra Fornecedor Pelo CGC
***************
Local sErro, sA2_COD, sA2_LOJA := ''
Local nI    := 0 
Local aFornecedor,aRet := {}

    DbSelectArea('SA2')
    DbSetOrder(3)
    DbSeek(xFilial('SA2')+Left(sCGC,8),.T.)
    While !Eof() .And. SA2->A2_FILIAL+left(SA2->A2_CGC,8) == xFilial('SA2')+Left(sCGC,8)
        sA2_COD := IIF(Empty(sA2_COD),SA2->A2_COD,sA2_COD)
        sA2_LOJA := StrZero(Val(SA2->A2_LOJA),2)
        DbSkip()
    EndDo 
    If Empty(sA2_COD)
        sA2_COD     := GetSx8Num("SA2","A2_COD")    
        sA2_LOJA    := '01'                                                            
        tNovoSA2    := .t.
        While tNovoSA2
            dbSelectarea("SA2")
            DbSetOrder(1)
            DbSeek(xFilial("SA2")+sA2_COD,.T.)
            iF xFilial("SA2")+Alltrim(sA2_COD) == SA2->A2_FILIAL+Alltrim(SA2->A2_COD)
                sA2_COD := soma1(sA2_COD)
			Else 
                tNovoSA2 := .F.
            EndIf
        EndDo
    EndIf
    aFornecedor := u_ROTMIS01(sCGC)
    If Len(aFornecedor) < 1
        sErro := 'Dados De Fornecedor Nao Encontrado!'
    Else     
        lDeuCerto := .F.
        oModel  := FwLoadModel ("MATA020M")
        oModel:SetOperation(3)
        oModel:Activate()
        oSA2Mod:= oModel:getModel("SA2MASTER")
        oSA2Mod:setValue("A2_COD"		,sA2_COD                    ) 
        oSA2Mod:setValue("A2_LOJA"		,sA2_LOJA                   ) 
        oSA2Mod:setValue("A2_CGC"		,sCGC                       ) 
        For nI  := 1 to Len(aFornecedor)
            oSA2Mod:setValue(aFornecedor[nI,1]	,aFornecedor[nI,2]  	)
        Next nI  
        oSA2Mod:setValue("A2_MSBLQL"	,'1'   	)               

        If oModel:VldData()
            If oModel:CommitData()
                lDeuCerto := .T.
            Else
                lDeuCerto := .F.
            EndIf
        Else
            lDeuCerto := .F.
        EndIf
        If ! lDeuCerto
            aErro := oModel:GetErrorMessage()
/*
            AutoGrLog("Id do formul rio de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
            AutoGrLog("Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
            AutoGrLog("Id do formul rio de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
            AutoGrLog("Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
            AutoGrLog("Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
            AutoGrLog("Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
            AutoGrLog("Mensagem da solu  o: "        + ' [' + AllToChar(aErro[07]) + ']')
            AutoGrLog("Valor atribu do: "            + ' [' + AllToChar(aErro[08]) + ']')
            AutoGrLog("Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')
            nI := 0
            FOR nI := 1 TO 20
                AutoGrLog("Valor Campo: "             + ' [' + AllToChar(aCampo [nI,1] ) + ']')
            Next nI
            MostraErro()
            aAdd(aErroLog, {aCampo [16,1],AllToChar(aErro[04])	, AllToChar(aErro[06])		, nil})

*/
			sErro       := AllToChar(aErro[06])
			sA2_COD     := ''
			sA2_LOJA    := ''
		EndIf
		oModel:DeActivate()
		FreeUsedCode()
	EndIf

	AADD(aRet,sA2_COD)
	AADD(aRet,sA2_LOJA)
	AADD(aRet,sErro)
Return(aRet)


*************************
User Function ROT006D() // Processa Registro Importados
***************
	If MsgYesNo("Continua Processamento", "Confirma?")
		Processa({|| fROT006E()}) // Atualizar Produto Embalagem SANIAGRO
	EndIf
Return()

*************************
Static Function fROT006E() //Atualiza API AGROTIS
***************
Local aAbast 			:= {}
Local aErro  			:= {}
Private lMsErroAuto 	:= .F.
Private lAutoErrNoFile 	:= .T.

	cQuery := " SELECT Z01.R_E_C_N_O_ Z01REG  "
	cQuery += " FROM " + RetSqlName("Z01") + " Z01"
	cQuery += " WHERE LEN(Z01_OBS) < 2 "
	cQuery += " AND Z01.D_E_L_E_T_ = ' ' "
	If Select("TRBZ01") > 0
		dbSelectArea("TRBZ01")
		dbCloseArea()
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBZ01",.T.,.T.)
	dbSelectArea("TRBZ01")
	If Len(cUsuario)>200
		Procregua(100)
	EndIf	
	DbGoTop()
	While !Eof()
		DbSelectArea("Z01")
		DbGoto(TRBZ01->Z01REG)
		//Caso esteja marcado, aumenta o contador
		If Len(cUsuario)>200
			IncProc("Importando O.S - " + Z01->Z01_IDTRAN )
		EndIf
		DbSelectArea("TQN") 
		DbSetOrder(17)
		aErro  := {}
		aAbast := {}
		lMsErroAuto 	:= .F.
		lAutoErrNoFile 	:= .T.
		tGerouReg       := .F.
		If !DbSeek(xFilial("TQN")+Alltrim(Z01->Z01_IDTRAN))
			sTQN_CODCOM := ''
			aErro 			:= fROT006B3(Z01->Z01_PLACA, Z01->Z01_TIPOCB, Z01->Z01_MATCOL, Z01->Z01_CGCPOS, Z01->Z01_DTTRAN, Z01->Z01_HRTRAN) // Cadastra Fornecedor
			DbSelectArea("DA4") 
			DbSetOrder(1)
			DbSelectArea("TQM") 
			DbSetOrder(1)

			If aErro[2] == '00' 
			
				aAbast := { {'TQN_PLACA' , PadR( Alltrim(Z01->Z01_PLACA)   , TAMSX3("TQN_PLACA")[1] ) , Nil },;
							{'TQN_FROTA' , PadR( Alltrim(ST9->T9_CODBEM)   , TAMSX3("TQN_FROTA")[1] ) , Nil },;
							{'TQN_CNPJ'  , PadR( Alltrim(Z01->Z01_CGCPOS)  , TAMSX3("TQN_CNPJ")[1] )  , Nil },;
							{'TQN_CODCOM', TQM->TQM_CODCOM											  , Nil },;
							{'TQN_DTABAS', Z01->Z01_DTTRAN			  								  , Nil },;
							{'TQN_HRABAS', Z01->Z01_HRTRAN                         					  , Nil },;
							{'TQN_TANQUE', PadR( ''             , TAMSX3("TQN_TANQUE")[1] )  		  , Nil },;
							{'TQN_BOMBA' , PadR( ''             , TAMSX3("TQN_BOMBA")[1] )   		  , Nil },;
							{'TQN_QUANT' , Z01->Z01_TOTLT 		                                      , Nil },;
							{'TQN_VALUNI', (Z01->Z01_TOTABA/Z01->Z01_TOTLT)    		                  , Nil },;
							{'TQN_VALTOT', Z01->Z01_TOTABA 						                      , Nil },;
							{'TQN_HODOM' , Val(Z01->Z01_KMATUA)                     			      , Nil },;
							{'TQN_CODMOT', DA4->DA4_COD  											  , Nil },;
							{'TQN_POSTO' , PadR( TQF->TQF_CODIGO  		  , TAMSX3("TQN_POSTO")[1] )  , Nil },;
							{'TQN_LOJA'  , PadR( TQF->TQF_LOJA    		  , TAMSX3("TQN_LOJA")[1] )   , Nil },;
							{'TQN_NOTFIS', PadR( Alltrim(Z01->Z01_IDTRAN) , TAMSX3("TQN_NOTFIS")[1] ) , Nil }}
//TQN_CODMOT - VALIDACAO - If(!Empty(M->TQN_CODMOT),EXISTCPO('DA4',M->TQN_CODMOT) .AND. MNA655MO(),.t.)                                                    
// TQN_NOMMOT - RELACAO - MNT655IMOT()     INIBRW - IF(DA4->(DBSEEK(xFILIAL('DA4')+TQN->TQN_CODMOT)),DA4->DA4_NOME,'')              

				MSExecAuto( { | v, x, y | MNTA655( v, x, y ) }, , aAbast, 3 )
				If lMsErroAuto
					AADD(aErro,'')
					AADD(aErro,'01')
					aLogErro := GetAutoGRLog()
					AEval(aLogErro, {|x| aErro[1] += x + CRLF})		
				Else
					tGerouReg       := .T.
				EndIf
			EndIf
		EndIf
		DbSelectArea("Z01")
		RECLOCK("Z01", .F. )
		If tGerouReg
			DbDelete()
		Else
			Z01->Z01_OBS        := aErro[1] 
			Z01->Z01_TPERRO		:= aErro[2]
		EndIf
		MsUnlock("Z01")
		DbSelectArea("TRBZ01")
		DbSkip()
	EndDo
	DbSelectArea("Z01")
	DbGoTop()
Return NIL

*************************
User Function ROT006F(sStatus) // Processa Registro Importados
***************
	Processa({|| fROT006F1(sStatus)}) // Atualizar Produto Embalagem SANIAGRO
Return()



*************************
Static Function fROT006F1(sStatus) //Atualiza API AGROTIS
***************
	//Percorrendo os registros da ZZ1
	DbSelectArea("Z01")
	Procregua(reccount())
	DbSetOrder(1)
	DbGoTop()
	While !EoF()
		//Caso esteja marcado, aumenta o contador
		IncProc("Importando O.S - " + Z01->Z01_IDTRAN)
		RecLock("Z01",.F.)
		Z01->Z01_OK     := IIF(sStatus == '1',oMark:Mark(),'')
		MsUnLock("Z01")
		DbSkip()
	EndDo
	DbSelectArea("Z01")
	DbGoTop()
Return NIL

	*************************
Static Function fROT006C(sZ02_CDOS,sZ02_ESCOPO) //Atualiza API AGROTIS
	***************
	//Percorrendo os registros da ZZ1
	sZ03_CODESC := Left(sZ02_ESCOPO,4)
	sZ03_DESCR  := Alltrim(Subs(sZ02_ESCOPO,7,LEN(Alltrim(sZ02_ESCOPO)) - 6))
	DbSelectArea("Z03")
	DbSetOrder(1)
	If !DbSeek(xFilial("Z03")+sZ03_CODESC)
		RecLock("Z03",.T.)
		Z03->Z03_FILIAL  := xFilial("Z03")
		Z03->Z03_CODESC  := sZ03_CODESC
		Z03->Z03_DESCR   := sZ03_DESCR
		MsUnLock("Z03")
	EndIf
	DbSelectArea("Z02")
	DbSetOrder(1)
	DbSeek(xFilial("Z02")+sZ02_CDOS+sZ03_CODESC,.T.)
	If !xFilial("Z02")+sZ02_CDOS+sZ03_CODESC == Z02->Z02_FILIAL + Z02->Z02_CDOS + Z02->Z02_CD_Z03
		RecLock("Z02",.T.)
		Z02->Z02_FILIAL     := xFilial("Z02")
		Z02->Z02_CDOS       := sZ02_CDOS
		Z02->Z02_CD_Z03     := sZ03_CODESC
		MsUnLock("Z02")
	EndIf
Return NIL



	********************************
Static Function ajustaSx1(cPerg)
	***************
	//Aqui utilizo a fun  o putSx1, ela cria a pergunta na tabela de perguntas
	oPerg := TPergunta():New(cPerg)
	oPerg:AddGet  ("Local      ?",            "C", 50, 0, Nil, "", "")
	oPerg:AddGet  ("Arquivo    ?",            "C", 30, 0, Nil, "", "")
	oPerg:Update()
	oPerg:Execute(.F.)
return


/*/{Protheus.doc} ROT006G
    (Mostra Na Tela MSg Com Os problemas na importacao dos Abastecimentos)
    @type  Static Function
    @author Marcio Da Silva
    @since 22/11/2023
    @version version
    @param sMsg, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function ROT006G()
    Local aMsg := {}
	Local sMsg := ''
	Local nI   := 0 
    AADD(aMsg,Separa(Z01->Z01_OBS,";",.T.))
	For nI := 1 to Len(aMsg[len(aMsg)])		
		If !Empty(aMsg[len(aMsg),nI])
			sMsg += '<b>'+Alltrim(Str(nI))+'-'+Alltrim(aMsg[len(aMsg),nI])+'</b><br>'
		EndIf
	Next nI 
	If !Empty(sMsg)
		MSGALERT(sMsg, "Problemas Na Importacao Do Abastecimento!" )
	EndIf
Return NIL


/*/{Protheus.doc} ROT006I
    (Atualiza cadastro de Fornecedore)
    @type  Static Function
    @author Marcio Da Silva
    @since 22/11/2023
    @version version
    @param sMsg, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
***********************
User Function ROT006I()
*************
    Local nOper     := MODEL_OPERATION_VIEW
    Local aButtons  := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}, {.T., "OK"}, {.T., "Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
    Local aOldArea  := SA2->(GetArea())
    Local aRotOld   := Iif(Type('aRotina') == 'U', {}, aRotina) 

    Private aRotina := FwLoadMenuDef("MATA020")

	DbSelectArea("SA2") 
	DbSetOrder(3)
    DbSeek(xFilial("SA2")+Alltrim(Z01->Z01_CGCPOS),.t.)
	If DbSeek(xFilial("SA2")+Z01->Z01_CGCPOS)
		nOper  := 4
		FWExecView('Fornecedor', 'MATA020' /*cPrograma*/, nOper /*nOperation*/, /*oDlg*/, { || .t. } /*bCloseOnOK*/, { || .t. } /*bOk*/, /*nPercReducao*/ , aButtons /*aEnableButtons*/, /*bCancel*/, /*cOperatId*/, /*cToolBar*/, /*oModelAct*/)
	Else  
		MSGALERT("<b> Fornecedor Nao Cadastrado!</b>", "Verificar Cadastro De Fornecedor!" )
	EndIf 
    RestArea(aOldArea)
    aRotina := aRotOld

Return .T.



/*/{Protheus.doc} ROT006J
    (cadastro de Postos)
    @type  Static Function
    @author Marcio Da Silva
    @since 22/11/2023
    @version version
    @param sMsg, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
***********************
User Function ROT006J()
*************
Local aOldZ01   := Z01->(GetArea())
Local aR006J    := Iif(Type('aRotina') == 'U', {}, aRotina) 
Private aRotina := FwLoadMenuDef("MNTA613")
Private pTQF_CODIGO := ''
Private pTQF_LOJA := ''
	DbSelectArea("SA2") 
	DbSetOrder(3)
	DbSeek(xFilial("SA2")+Z01->Z01_CGCPOS,.T.)
	iF xFilial("SA2")+Z01->Z01_CGCPOS == SA2->A2_FILIAL+Alltrim(SA2->A2_CGC)
		pTQF_CODIGO := SA2->A2_COD
		pTQF_LOJA 	:= SA2->A2_LOJA
		DbSelectArea("TQF") 
		DbSetOrder(2)
		DbSeek(xFilial("TQF")+Z01->Z01_CGCPOS,.T.)
		iF xFilial("TQF")+Z01->Z01_CGCPOS == TQF->TQF_FILIAL+TQF->TQF_CNPJ 
			pTQF_CODIGO := ''
			pTQF_LOJA	:= ''
		EndIf			
	EndIf	
	AROTINA[6][2] := "u_ROT006N"			 
	AROTINA[7][2] := "u_ROT006O"			 
	Processa({|| MNTA613()}, 'Integrando...')
	sTQF_CODIGO := ''
	RestArea(aOldZ01)
	aRotina := aR006J
Return Nil




/*/{Protheus.doc} ROT006L
    (cadastro de Veiculos)
    @type  Static Function
    @author Marcio Da Silva
    @since 22/11/2023
    @version version
    @param sMsg, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
***********************
User Function ROT006L()
*************
Local aOldArea  := Z01->(GetArea())
Local aRotOld   := Iif(Type('aRotina') == 'U', {}, aRotina) 
Private aRotina := FwLoadMenuDef("MNTA084")
Private pT9_PLACA := ''
	DbSelectArea("ST9") 
	DbSetOrder(14)
	DbSeek(Alltrim(Z01->Z01_PLACA),.T.)
	iF !Alltrim(Z01->Z01_PLACA) == Alltrim(ST9->T9_PLACA)
		pT9_PLACA := Z01->Z01_PLACA
	EndIf			
	Processa({|| MNTA084()}, 'Integrando...')
	pT9_PLACA := ''

//IIF(INCLUI .And. Type("pT9_PLACA") != "U", pT9_PLACA, '')                                                                    

	RestArea(aOldArea)
	aRotina := aRotOld
Return Nil





/*/{Protheus.doc} ROT006K
    (cadastro de Motorista)
    @type  Static Function
    @author Marcio Da Silva
    @since 22/11/2023
    @version version
    @example
    (examples)
    @see (links_or_references)
/*/
***********************
User Function ROT006K()
*************
Local aOldArea  	:= SA2->(GetArea())
Local aRotOld   	:= Iif(Type('aRotina') == 'U', {}, aRotina) 
Private sZ01_MATCOL  := Z01->Z01_MATCOL
Private aRotina 	:= FwLoadMenuDef("OMSA040")

	Processa({|| OMSA040()}, 'Integrando...')
	sZ01_MATCOL  := ''

RestArea(aOldArea)
aRotina := aRotOld
Return Nil



/*/{Protheus.doc} fROT006B3
    (Validacao De Dados No Cadastro Z01)
    @type  Static Function
    @author Marcio Da Silva
    @since 22/11/2023
    @version version
    @example
    (examples)
    @see (links_or_references)
/*/
***********************
Static Function fROT006B3(sZ01_PLACA, sZ01_TIPOCB,sZ01_MATCOL,sZ01_CGCPOS, dZ01_DTTRAN, sZ01_HRTRAN)
*************
Local sErro := ''
Local nQtd_erro := 0 
Local aErro := {}
	DbSelectArea("TQM") 
	DbSetOrder(3)
	DbSeek(xFilial("TQM")+sZ01_TIPOCB,.T.)
	iF !xFilial("TQM")+sZ01_TIPOCB == TQM->TQM_FILIAL+TQM->TQM_XTPCOM
		nQtd_erro += 1 	
		sErro += "Tipo De Combustivel:"+ sZ01_TIPOCB+", Nao Cadastrado Em Tabela de Tipo De Combustivel;"
	EndIf  
	DbSelectArea("DA4") 
	DbSetOrder(4)
	DbSeek(xFilial("DA4")+sZ01_MATCOL,.T.)
	iF !xFilial("DA4")+sZ01_MATCOL == DA4->DA4_FILIAL+DA4->DA4_XCDABA
		nQtd_erro += 1 	
		sErro += "Motorista Codigo:"+ sZ01_MATCOL+", Nao Cadastrado!;"
	EndIf  

	DbSelectArea("ST9") 
	DbSetOrder(14)
	DbSeek(Alltrim(sZ01_PLACA),.T.)
	iF !Alltrim(sZ01_PLACA) == Alltrim(ST9->T9_PLACA)
		nQtd_erro += 1 	
		sErro += "Veiculo PLaca:"+ sZ01_PLACA+", Nao Cadastrado!;"
	EndIf			

	DbSelectArea("SA2") 
	DbSetOrder(3)
	DbSeek(xFilial("SA2")+sZ01_CGCPOS,.T.)
	iF xFilial("SA2")+sZ01_CGCPOS == SA2->A2_FILIAL+Alltrim(SA2->A2_CGC)
		If SA2->A2_MSBLQL == '1'
			nQtd_erro += 1 	
			sErro += "Fornecedor CNPJ:"+ SA2->A2_CGC+", Nao Validado!;"
		EndIf 
	Else  
		aRet := fROT006B2(sZ01_CGCPOS) // Cadastra Fornecedor
		If !Empty(ARET[3])
			nQtd_erro += 1 	
			sErro += 'Cadastro De Fornecedor (Automaticamente) : ' +Alltrim(ARET[3]) +';'
		Else 
			nQtd_erro += 1 	
			sErro += "Fornecedor Incluido CNPJ:"+ SA2->A2_CGC+", Nao Validado!;"
		EndIf
	EndIf 
	DbSelectArea("TQF") 
	DbSetOrder(2)
	DbSeek(xFilial("TQF")+sZ01_CGCPOS,.T.)
	iF !xFilial("TQF")+sZ01_CGCPOS == TQF->TQF_FILIAL+TQF->TQF_CNPJ 
		nQtd_erro += 1 	
		sErro += "Posto De Combustivel CNPJ:"+ sZ01_CGCPOS+", Nao Cadastrado!;"
	ElseIf xFilial("TQF")+sZ01_CGCPOS == TQF->TQF_FILIAL+TQF->TQF_CNPJ .And. !TQF->TQF_ATIVO == '1'
		nQtd_erro += 1 	
		sErro += "Posto De Combustivel CNPJ:"+ sZ01_CGCPOS+", Inativo!;"
	Else 
		If AllTrim( SuperGetMV( 'MV_NGCONEG', .F., 'S' ) ) == 'S' 
			DbSelectArea("TQG") 
			DbSetOrder(1)
			DbSeek(xFilial("TQG")+TQF->TQF_CODIGO + TQF->TQF_LOJA,.T.)
			iF !xFilial("TQG")+TQF->TQF_CODIGO + TQF->TQF_LOJA == TQG->TQG_FILIAL + TQG->TQG_CODPOS + TQG->TQG_LOJA
				nQtd_erro += 1 	
				sErro += "Negociacao Com Posto CGC:"+ sZ01_CGCPOS+", Nao Incluida!;"
			ElseIF DTOS(TQG->TQG_DTNEG)+TQG->TQG_HRNEG > DTOS(dZ01_DTTRAN) + sZ01_HRTRAN 
				nQtd_erro += 1 	
				sErro += "Data De Abastecimento Anterior a Negociacao;"
			EndIf		 

			DbSelectArea("TQH") 
			DbSetOrder(1)
			DbSeek(xFilial("TQH")+TQF->TQF_CODIGO + TQF->TQF_LOJA,.T.)
			iF !xFilial("TQH")+TQF->TQF_CODIGO + TQF->TQF_LOJA == TQH->TQH_FILIAL + TQH->TQH_CODPOS + TQH->TQH_LOJA
				nQtd_erro += 1 	
				sErro += "Precos No Posto CGC:"+ sZ01_CGCPOS+", Nao Incluido!;"
			ElseIF DTOS(TQH->TQH_DTNEG)+TQH->TQH_HRNEG >  DTOS(dZ01_DTTRAN) + sZ01_HRTRAN 
				nQtd_erro += 1 	
				sErro += "Preco De Abastecimento Anterior a Negociacao;"
			EndIf		 
		EndIf		 
	EndIf  
	If !Empty(sErro)
		sErro := Left(Alltrim(sErro),Len(Alltrim(sErro))-1)
	EndIf
	AADD(aErro,sErro)
	AADD(aErro,StrZero(nQtd_erro,2))

Return(aErro)



*************************
User Function ROT006H() //Atualiza API AGROTIS
***************
    If MsgYesNo("Continua Validacao Abastecimento?", "Confirma?")
        Processa({|| fROT006H()}) // Atualizar Produto Embalagem SANIAGRO
    EndIf 
Return()    

*************************
Static Function fROT006H() //Atualiza API AGROTIS
***************
Local cMarca    := oMark:Mark()		
Local aErro     := {}

DBSelectArea("Z01")
DbSetOrder(1)
DbGoTop()
Procregua(FT_FLASTREC())    
While !Eof()
	IncProc("Processando Validacao...")
	If oMark:IsMark(cMarca)
		aErro 			:= fROT006B3(Z01->Z01_PLACA,Z01->Z01_TIPOCB,Z01->Z01_MATCOL,Z01->Z01_CGCPOS,  Z01->Z01_DTTRAN, Z01->Z01_HRTRAN) // Cadastra Fornecedor
		DBSelectArea("Z01")
		
			RecLock("Z01",.F.)
			Z01->Z01_OBS        := aErro[1]
			Z01->Z01_TPERRO		:= aErro[2]
			MsUnlock("Z01")
	EndIf
	DbSkip()
EndDo 
Return Nil



/*/{Protheus.doc} fROT006BM
    (IMPORTA ARQUIVO DE ABASTECIMENTO AUTOMATICAMENTE)
    @type  Static Function
    @author Marcio Da Silva
    @since 22/11/2023
    @version version
    @example
    (examples)
    @see (links_or_references)
/*/
***********************
USer Function ROT006M()
*************
Private lExecJob := .T.
Private aMsgSch  := {}
Private aFA205R  := {}
//Local aEmpresa  := {}
//Local nEmpresa  := 0 

//aAdd(aEmpresa,{"01","02","03","04","05","06","07","08","09","10","11","12","13","30","40","60","98"})

//For nEmpresa := 1 to Len(aEmpresa)
	lExecJob := .T.
	aMsgSch  := {}
	aFA205R  := {}
	RpcSetEnv('01', '0101', Nil, Nil, Nil, "GFR")
		fROT006B() //Importa Registro
		fROT006E() //Processa Abastecimento Importado
	RpcClearEnv()
//Next nEmpresa
Return



/*/{Protheus.doc} ROT006N
    (chama rotina de negociacao com menu correto)
    @type  Static Function
    @author Marcio Da Silva
    @since 22/11/2023
    @version version
    @param sMsg, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
***********************
User Function ROT006N()
*************
Local aOldATQF  := TQF->(GetArea())
Local aRMNT613   := Iif(Type('aRotina') == 'U', {}, aRotina) 
Private aRotina := FwLoadMenuDef("MNTA611")
Private pTQF_CODIGO := ''
Private pTQF_LOJA := ''
	Processa({|| MNTA611()}, 'Integrando...')
	sTQF_CODIGO := ''
	RestArea(aOldATQF)
	aRotina := aRMNT613
Return Nil

/*/{Protheus.doc} ROT006O
    (chama rotina de PRECO com menu correto)
    @type  Static Function
    @author Marcio Da Silva
    @since 22/11/2023
    @version version
    @param sMsg, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
***********************
User Function ROT006O()
*************
Local aOldATQF  := TQF->(GetArea())
Local aRMNT612   := Iif(Type('aRotina') == 'U', {}, aRotina) 
Private aRotina := FwLoadMenuDef("MNTA612")
Private pTQF_CODIGO := ''
Private pTQF_LOJA := ''
	Processa({|| MNTA612()}, 'Integrando...')
	sTQF_CODIGO := ''
	RestArea(aOldATQF)
	aRotina := aRMNT612
Return Nil


