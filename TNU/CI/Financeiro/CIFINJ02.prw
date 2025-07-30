#include 'protheus.ch'
#include 'parmtype.ch' 
#Include 'FILEIO.CH'
 
//--------------------------------------------------------------------------------
/*/{Protheus.doc} CIFINJ02 
Function CIFIN002 - Job responsvel pela leitura de arquivo e baixa de titulos CR - cartoes
@type       Function
@author     
@since      24/08/2024
@version    1.0
/*/
//--------------------------------------------------------------------------------

User Function CIFINJ02(xEmp,xFil)

    Local cEmp  := ""
	Local cFil  := ""
        
    cEmp   := "01"
    cFil   := "000101"
 	
	ConOut("+" + Replicate("-",80) + "+")
	ConOut("JOB - CIFINJ02")
	ConOut("+" + Replicate("-",80) + "+")
	ConOut("Empresa:" + cEmp + " Filial:" + cFil)
	
	if !empty(cFil) .and. !empty(cEmp)
	
	    RPCSetType(3) 

	    RPCSetEnv(cEmp,cFil)
  
  		ConOut( "CIFINJ02 Inicio: "+ Time() )
          
		finj2zpt()

        RpcClearEnv() 

        ConOut( "CIFINJ02 Fim   : "+ Time() )
	
    Endif            
	
	ConOut("+" + Replicate("-",80) + "+")
	
Return()

/*/{Protheus.doc} finj2zpt
	Ler os arquivos e gravar na tabela ZPT
	@type  Static Function
	@author user
	@since 15/07/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function finj2zpt()
	Local nHdl      := 0 
    Local aDados    := {}
    Local cLinha    := ""
    Local cDelim    := ','
    Local aFiles    := {} 
    Local aSizes    := {} 
    Local x         := 0
    Local cPastOrig := SuperGetMv("CI_PSORIG",.F.,"C:\Users\usuario\Downloads\Estudo\Processar\")
    Local cPastDest := SuperGetMv("CI_PSDEST",.F.,"C:\Users\usuario\Downloads\Estudo\Processado\")
    Local cCamOrig  := " "
    Local cCamDest  := " "
    Local lRet      := .F.
   
    //Verifico todos os arquivo dentro da pasta
    ADir(cPastOrig+"*.*", aFiles, aSizes,,,,.F.)
  
    If Len(aFiles) > 0
        For x := 1 to Len(aFiles)
       
            cCamOrig := cPastOrig + aFiles[x] 
            cCamDest := cPastDest + aFiles[x]

            CONOUT("[CIFINP02]  - Job Processamento - Inicio: "+Time()+" "+DTOC(Date())+" Arquivo: "+Alltrim(cCamOrig))

            //Abro o arquivo 0 - Aberto para leitura (padrão) e 64 - Acesso compartilhado. Permite a leitura e gravação por outros processos ao arquivo
            nHdl := fOpen(cCamOrig, FO_READ + FO_SHARED)

            //Se localizou o arquivo
            If nHdl == -1
                CONOUT("[CIFINP02]  - Job Processamento - ERRO na leitura do arquivo : "+Time()+" "+DTOC(Date())+" Erro: " + Str(Ferror()))
            Else
                CONOUT("[CIFINP02]  - Job Processamento - Relizando a leitura do arquivo: "+Time()+" "+DTOC(Date())+" Arquivo: "+Alltrim(cCamOrig))
                aDados := {}

                //Inicia a leitura do arquivo
                FT_FUse(cCamOrig)
                FT_FGoTop() 
                While !FT_FEOF()
                    cLinha := FT_FReadLn() 
                    aAdd(aDados,TXTToArr(cLinha,cDelim))
                    FT_FSkip()
                End
                FT_FUSE() 
                fclose(nHdl)
                CONOUT("[CIFINP02]  - Job Processamento - Relizando a leitura do arquivo: "+Time()+" "+DTOC(Date())+" Quantidade localizada: "+Alltrim(sTr(Len(aDados))))
                //Inicia o processo de baixa
                If Len(aDados) > 0 
					Processa( {|| procZPT(aDados,cCamDest)},'Processando os arquivos...')
                EndIf
            EndIf

            //Realizo a transferencia do arquivo de processar para processado depois relalizo a exclusão.
            lRet := __CopyFile(cCamOrig,cCamDest+Dtos(MSDate())+StrTran(Time(),":",""))

            //Apos processamento excluir o arquivo
            If lRet 
                If FErase(cCamOrig) = 0
                    CONOUT("[CIFINP02]  - Job Processamento - Sucesso - Realizando a exclusão do arquivo: "+Time()+" "+DTOC(Date())+" Arquivo: "+Alltrim(cCamOrig))
                Else
                    CONOUT("[CIFINP02]  - Job Processamento - Erro - Realizando a exclusão do arquivo: "+Time()+" "+DTOC(Date())+" Arquivo: "+Alltrim(cCamOrig) +"Erro: "+ cValToChar(FError()))
                EndIf
            Else
                CONOUT("[CIFINP02]  - Job Processamento - Erro - Copia do arquivo: "+Time()+" "+DTOC(Date())+" , Arquivo: "+Alltrim(cCamOrig))
            EndIf
        Next x
        CONOUT("[CIFINP02]  - Job Processamento - Arquivo não localizao: "+Time()+" "+DTOC(Date())+" , Arquivo: "+Alltrim(cCamOrig))
    EndIf

    CONOUT("[CIFINP02]  - Job Processamento - FIM do processamento: "+Time()+" "+DTOC(Date())+" , Arquivo: "+Alltrim(cCamOrig))

Return


//--------------------------------------------------------------------------------
/*/{Protheus.doc} TXTToArr 
TXTToArr - Static Function TXTToArr
@type       Function
@author     
@since      28/08/2024
@version    1.0
/*/
//--------------------------------------------------------------------------------
Static Function TXTToArr( cTexto, cDelim )

	Local aRet := {}
	Local cFinal := ''
	Local nPosIni := 1
	Local nTamTxt := Len(cTexto)
	
	While .T.
		nCol := At(cDelim , SubStr(cTexto, nPosIni, nTamTxt))
		If (nCol == 0)
			cFinal := Upper(SubStr(cTexto, nPosIni, nTamTxt))
			If Empty(cFinal)
				Exit
			EndIf
		EndIf
		nPosFim := IIf(Empty(cFinal), (nCol - 1), Len(cFinal))
		aAdd(aRet , Upper(SubStr(cTexto, nPosIni, nPosFim)))
		nPosIni += IIf(Empty(cFinal), nCol, Len(cFinal))
	End
	
Return( aRet )

//--------------------------------------------------------------------------------
/*/{Protheus.doc} TipoVen 
TXTToArr - Static Function TipoVen
@type       Function
@author     
@since      28/08/2024
@version    1.0
/*/
//--------------------------------------------------------------------------------

Static Function TipoVen(cTipo,cTipoVen)

    cTipo := Upper(Alltrim(cTipo))

    if "P" $ cTipo	
        cTipoVen := "CC"
    Elseif "R" $ cTipo	
        cTipoVen := "CC"
    Elseif "D" $ cTipo	
        cTipoVen := "CD"
    Elseif "T" $ cTipo	
        cTipoVen := "CD"
    Elseif "U" $ cTipo	
        cTipoVen := "CD"
    Elseif "E" $ cTipo	
        cTipoVen := "CD"
    Elseif "H" $ cTipo	
        cTipoVen := "CD"
    Elseif "1" $ cTipo	
        cTipoVen := "CD"
    Elseif "6" $ cTipo	
        cTipoVen := "CC"
    Elseif "2" $ cTipo	
        cTipoVen := "CC"
    Elseif "3" $ cTipo	
        cTipoVen := "CC"
    Elseif "5" $ cTipo	
        cTipoVen := "CD"
    Endif
Return()


/*/{Protheus.doc} procZPT
	Processa o array com os dados lidos do arquivo e grava na tabela ZPT
	@type  Static Function
	@author user
	@since 15/07/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function procZPT(aDados,cFile)

	Local aArea := GetArea()
	Local cMsg      := " "
    Local _nValPgto := 0
    Local _nvLrTar  := 0
    Local n1        := 0
    Local cFilTIT   := ''
    Local aTit      := {}
    Local _aMsg     := {}
    Local cCodBco   := ''
    Local cAgencia  := ''
    Local cAgeOrig  := ''
    Local cContaBco := ''
    Local cCNPJ     := ''
    Local dDataBx   := dDataBase
    Local cPrefixo  := ''
    Local cNumTit   := ''
    Local cParcel   := ''
    Local cTipo     := ''
    Local cTipoVen  := ""
    Local cCod      := ''
    Local cNSU      := ''
    Local cAutori   := ""

	If (Len(aDados) > 0 )

        For n1 := 2 To Len(aDados)

            If Alltrim(aDados[n1,1]) == '11'
            
                cnumtit := ''
                
                CONOUT("[CIFINP02] - INICIO LINHA: " + cValToChar(N1))

                cCNPJ := AllTrim( aDados[n1,3] )
                BEGINSQL alias 'TMPSM0'
                    SELECT * FROM SYS_COMPANY SM0 WHERE SM0.%Notdel% AND M0_CGC = %Exp:cCNPJ% 
                EndSql
                
                If TMPSM0->(!EoF())
                    cFilTIT := AllTrim(TMPSM0->(M0_CODFIL))
                    cCod := AllTrim(TMPSM0->(M0_CODIGO))
                Else
                    CONOUT ("[CIFINP02] - Não foi possivel encontrar a EMPRESA/FILIAL: "+cCNPJ)
                    cMsg := 'Não foi possivel encontrar a EMPRESA/FILIAL: ' +cCNPJ + Chr( 13 ) + Chr( 10 )
					Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",AllTrim( aDados[n1,3]),cMsg})
                    TMPSM0->(DbCloseArea())
                    Loop
                EndIf

                TMPSM0->(DbCloseArea())

                cPrefixo := 'ECU' 
                cParcel  := Padl(Alltrim(aDados[n1,12]),2,"0")
                cNSU     := Padl(Alltrim(aDados[n1,6]),6,"0")
                cAutori  := Padl(Alltrim(aDados[n1,7]),6,"0")

                If Empty(aDados[n1,7])
                    cMsg := '[CIFINP02] -Codigo de Autorizacao em branco no arquivo Linha: '+ Alltrim(cValtoChar(n1)) + Chr( 13 ) + Chr( 10 )
					Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",AllTrim(aDados[n1, 7]),cMsg})
                    loop 
                EndIf

                TipoVen(aDados[n1,16],@cTipoVen)
                cTipo := cTipoVen

                If Empty(cTipo)
                    cMsg := '[CIFINP02] - Erro no Tipo de Venda: '+cTipo + Chr( 13 ) + Chr( 10 )
					Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",AllTrim(cTipo),cMsg})
                    Loop
                EndIf

                cAgeOrig := SUBSTRING(Alltrim(aDados[n1,9]),3,4)

                IF cAgeOrig  = '7793'
                    cAgencia := '2622'
                Else
                    cAgencia := SUBSTRING(Alltrim(aDados[n1,9]),3,4)
                Endif
                
                cCodBco   := '237'

                DbSelectArea("SA6")
                SA6->( dbSetOrder(1) )
                IF (SA6->(dbSeek(cFilTIT+cCodBco+cAgencia)))
                    cContaBco := SA6->A6_NUMCON
                ELSE   
                    cMsg := 'Banco: 237, Agencia: ' +  cAgencia +  ' nao cadastrado para Filial: ' +cFilTIT + Chr( 13 ) + Chr( 10 )
					Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",AllTrim( aDados[n1,3]),cMsg})
                    Loop
                EndIF    
 
                // Pesquisa Numero do Documento
                cQuery := "SELECT E1_NUM " 
	            cQuery += " FROM " + RetSQLName("SE1")     
	            cQuery += " WHERE E1_FILIAL = '"  +cFilTIT  + "'"   
	            cQuery += "	 AND E1_NSUTEF  = '"  +cNSU     + "'"   
	            cQuery += "	 AND E1_CARTAUT = '"  +cAutori  + "'"   
                cQuery += "  AND E1_PARCELA = '"  +cParcel  + "'"   
            	cQuery += "  AND E1_PREFIXO = '"  +cPrefixo + "'"            
        		cQuery += "  AND E1_TIPO    = '"  +cTipo    + "'"   
                cQuery += "  AND D_E_L_E_T_ = '' "  

                cTab := MPSysOpenQuery(cQuery)
            	DbSelectArea((cTab))
            	(cTab)->(DbGoTop())

                cNumTit := (cTab)->E1_NUM

                (cTab)->(DbCloseArea())

                CONOUT("[CIFINP02] - DEPOIS DO SELECT SE1: " + cValToChar(N1))

                IF Empty(cNumTit) 
                    cMsg := 'Filial: ' +cFilTIT +' Prefixo: ECU ' + ' NSU: ' + cNSU +' Autoriz: '+cAutori+ ' Parcela: ' + cParcel + ' Tipo: ' + cTipo+' Titulo: '+cnumtit +' -> Título nao encontrado para baixa'+ Chr( 13 ) + Chr( 10 )
					Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",cFilTIT, cMsg})
                    Loop
                ENDIF
                
                CONOUT("[CIFINP02] - ANTES DBSEEK SE1 LINHA: " + cValToChar(N1))
                
                DbSelectArea( 'SE1' )
                SE1->( dbSetOrder(1) )
                SE1->(DbSeek(cFilTIT + cPrefixo + cNumTit +cParcel + cTipo ))

                If !Empty(SE1->E1_NUM )

                    CONOUT("[CIFINP02] - DEPOIS !empty SE1 LINHA: " + cValToChar(N1))

                    IF SE1->E1_SALDO = 0
                        cMsg := 'Filial: ' +cFilTIT + ' Prefixo: ECU ' + ' NSU: ' + cNSU +' Autoriz: '+cAutori+ ' Parcela: ' + cParcel + ' Tipo: ' + cTipo +'Docto: '+cNumTit+ ' -> Título ja esta baixado ' + Chr( 13 ) + Chr( 10 )
						Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",cFilTIT, cMsg})
                        Loop
                    Endif
               
                    CONOUT("[CIFINP02] - DEPOIS (SALDO > 0) LINHA: " + cValToChar(N1))

                    _nValPgto := Val(Left(StrZero(Val(aDados[n1,14]),15),13)+'.'+Right(StrZero(Val(aDados[n1,14]),15),2))

                    _nvLrTar  := (SE1->E1_VALOR - _nValPgto)

                    dDataBx := IIF(!Empty(aDados[n1,15]),CtoD(Substr(aDados[n1,15],1,2)+'/'+Substr(aDados[n1,15],3,2)+'/'+Substr(aDados[n1,15],5,2)),dDataBase)
                    dDataBase := dDataBx

                    IF (_nValPgto + _nvLrTar) > SE1->E1_VALOR
                        cMsg := 'Filial: ' +cFilTIT + ' Prefixo: ECU ' + ' NSU: ' + cNSU +' Autoriz: '+cAutori+ ' Parcela: ' + cParcel + ' Tipo: ' + cTipo +'Docto: '+cNumTit+ ' -> Valor da Baixa Maior que valor do Titulo ' + Chr( 13 ) + Chr( 10 )
						Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",cFilTIT, cMsg})
                        Loop
                    Endif
 
                    DbSelectArea("ZPT")
					Reclock("ZPT", .T.)
					ZPT->ZPT_FILIAL	:=	SE1->E1_FILIAL
					ZPT->ZPT_ANSU  	:=	cNSU
					ZPT->ZPT_AAUT  	:=	cAutori
					ZPT->ZPT_APARC 	:=	cParcel
					ZPT->ZPT_AVALOR	:=	_nValPgto
					ZPT->ZPT_ATIPO 	:=	cTipo
					ZPT->ZPT_DTBX  	:=	dDataBase
					ZPT->ZPT_ALIVRE	:=	''  //De onde vem?
					ZPT->ZPT_BANCO 	:=	cCodBco
					ZPT->ZPT_AGENCI :=	cAgencia
					ZPT->ZPT_NUMCON	:= 	cContaBco
					ZPT->ZPT_CLIENT	:=	SE1->E1_CLIENTE
					ZPT->ZPT_NUM   	:=	SE1->E1_NUM
					ZPT->ZPT_HISTOR	:=	SE1->E1_HIST
					ZPT->ZPT_E1VAL 	:=	SE1->E1_VALOR
					ZPT->ZPT_STATUS	:=	''
					ZPT->ZPT_E1EMIS	:=	SE1->E1_EMISSAO
					ZPT->ZPT_E1VREA	:=	SE1->E1_VENCREA
					ZPT->ZPT_ARQUIV	:=	cFile 
					ZPT->(MsUnLock())
                    
                    aTit := { }
                ELSE
                    CONOUT("[CIFINP02] - SE1 NAO ENCONTRADO LINHA: " + cValToChar(N1))
                    cMsg := 'Filial: ' +cFilTIT + ' Prefixo: ECU ' + ' NSU: ' + cNSU + ' Autoriz: '+cAutori+ ' Parcela: ' + cParcel + ' Tipo: ' + cTipo +'Docto: '+cNumTit+ ' -> Título nao Encontrado!!! ' + Chr( 13 ) + Chr( 10 )
				    Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",cFilTIT, cMsg})
                EndIf
            EndIf 
        Next
    EndIf

	RestArea(aArea)
	
Return
