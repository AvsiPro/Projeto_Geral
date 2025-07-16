#Include "PROTHEUS.CH"
#Include 'FILEIO.CH'
#Include 'TOPCONN.CH'
#INCLUDE "TOTVS.CH"
#include "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

//--------------------------------------------------------------------------------
/*/{Protheus.doc} CIFINP02 
CIFINP02 - Funcao Baixa Automatica de Titulo Cartoes - Nexxera
@type       Function
@author     
@since      28/08/2024
@version    1.0
/*/
//--------------------------------------------------------------------------------

/*
+------------------------------------------------------------+
|           Manutenção                                       |
|05-03-2025: Inclusão da tag de desconto                     |
|02-04-2025: Fonte validado                                  |
|08/05/2025: Inclusão D_E_L_E_T_ = ''                        |
+------------------------------------------------------------+

*/

User function CIFINP02()

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
                     Processa( {|| ProcBaixa(aDados)},'Processando as baixas...')
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
             
Return()

//--------------------------------------------------------------------------------
/*/{Protheus.doc} ProcBaixa 
[CIFINP02]  - Funcao de processamento da inclusao do contas a receber
@type       Function
@author     
@since      28/08/2024
@version    1.0
/*/
//--------------------------------------------------------------------------------
Static Function ProcBaixa(aDados)

    Local cMsg      := " "
    Local aAreaSM0  := SM0->(GetArea())
    Local _nValPgto := 0
    Local _nvLrTar  := 0
    Local n1        := 0
    Local n2        := 0
    Local cFilTIT   := ''
    Local aTit      := {}
    Local cFilBKP   := cFilAnt
    Local _aMsg     := {}
    Local aLogAuto  := {}
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
    //Local cQuery    := ""
    //Local cTab      := ""
    Local cPath     := "\nexxera\download\BAIXA_REC_LOG"
    Local cAutori   := ""
    //Local nRecno   := 0

    Private lMsHelpAuto     := .T.
    Private lMsErroAuto     := .F.
    Private lAutoErrNoFile  := .T.

    If (Len(aDados) > 0 )

        For n1 := 1 To Len(aDados)

            If (n1 > 1) .AND. Alltrim(aDados[n1,1]) == '11'
            
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

                 //cAgencia  := '2622'
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
                   // _nvLrTar  := Val(Left(StrZero(Val(aDados[n1,29]),15),13)+'.'+Right(StrZero(Val(aDados[n1,29]),15),2))

                    _nvLrTar  := (SE1->E1_VALOR - _nValPgto)

                    dDataBx := IIF(!Empty(aDados[n1,15]),CtoD(Substr(aDados[n1,15],1,2)+'/'+Substr(aDados[n1,15],3,2)+'/'+Substr(aDados[n1,15],5,2)),dDataBase)
                    dDataBase := dDataBx

                    IF (_nValPgto + _nvLrTar) > SE1->E1_VALOR
                        cMsg := 'Filial: ' +cFilTIT + ' Prefixo: ECU ' + ' NSU: ' + cNSU +' Autoriz: '+cAutori+ ' Parcela: ' + cParcel + ' Tipo: ' + cTipo +'Docto: '+cNumTit+ ' -> Valor da Baixa Maior que valor do Titulo ' + Chr( 13 ) + Chr( 10 )
						Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",cFilTIT, cMsg})
                        Loop
                    Endif
 
                    aBaixa := {}
                    aAdd(aBaixa,{"E1_PREFIXO"  ,SE1->E1_PREFIXO    ,Nil    })
                    aAdd(aBaixa,{"E1_NUM"      ,SE1->E1_NUM        ,Nil    })
                    aAdd(aBaixa,{"E1_PARCELA"  ,SE1->E1_PARCELA    ,Nil    })
                    aAdd(aBaixa,{"E1_TIPO"     ,SE1->E1_TIPO       ,Nil    })
                    aAdd(aBaixa,{"AUTMOTBX"    ,"NOR"              ,Nil    })
                    aAdd(aBaixa,{"AUTBANCO"    ,cCodBco            ,Nil    })
                    aAdd(aBaixa,{"AUTAGENCIA"  ,cAgencia           ,Nil    })
                    aAdd(aBaixa,{"AUTCONTA"    ,cContaBco          ,Nil    })
                    aAdd(aBaixa,{"AUTDTBAIXA"  ,dDataBx            ,Nil    })
                    aAdd(aBaixa,{"AUTDTCREDITO",dDataBx            ,Nil    })
                    aAdd(aBaixa,{"AUTHIST"     ,'Baixa Aut. CIFINAP02' ,Nil })
                    // aAdd(aBaixa,{"AUTJUROS"    ,0                  ,Nil,.T.})
                    aAdd(aBaixa,{"AUTVALREC"   ,_nValPgto          ,Nil    })
                    aAdd(aBaixa,{"AUTDESCONT"  ,_nvLrTar          ,Nil    })

                   SM0->( DbSetOrder( 1 ) )
                    If SM0->( DbSeek( cEmpAnt + SE1->E1_FILIAL ) )
                       cFilBKP := cFilAnt
                        cFilAnt := AllTrim( SM0->M0_CODFIL )
                    EndIf

                    MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)

                    If lMsErroAuto
                            //MostraErro( )
                        aLogAuto := GetAutoGRLog()
                        For n2 := 1 To Len(aLogAuto)
                            cMsg += Alltrim(aLogAuto[n2])+CRLF
                        Next nAux
                        Aadd(_aMsg,{Alltrim(Str(n1)),"",SE1->E1_FILIAL,cMsg})
                        lMsHelpAuto := .T.
                        lMsErroAuto := .F.
                    Else
                        cMsg := 'Filial: ' +cFilTIT +' Prefixo: ECU ' + ' NSU: ' + cNSU +' Autoriz: '+cAutori+ ' Parcela: ' + cParcel + ' Tipo: ' + cTipo +'Docto: '+cNumTit+' -> Título baixado com Sucesso!' + Chr( 13 ) + Chr( 10 )
						Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",cFilTIT, cMsg})
                        lMsHelpAuto := .T.
                        lMsErroAuto := .F.
                        //cMsg := ""
                    EndIf
                    aTit := { }
                ELSE
                    CONOUT("[CIFINP02] - SE1 NAO ENCONTRADO LINHA: " + cValToChar(N1))
                    cMsg := 'Filial: ' +cFilTIT + ' Prefixo: ECU ' + ' NSU: ' + cNSU + ' Autoriz: '+cAutori+ ' Parcela: ' + cParcel + ' Tipo: ' + cTipo +'Docto: '+cNumTit+ ' -> Título nao Encontrado!!! ' + Chr( 13 ) + Chr( 10 )
				    Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",cFilTIT, cMsg})
                EndIf
            EndIf // if = 11
        Next
    EndIf // Len(aDados) > 0
    SM0->( DbSetOrder( 1 ) )
    If SM0->( DbSeek( cEmpAnt + cFilBKP ) )
        cFilAnt := AllTrim( SM0->M0_CODFIL )
    EndIf

    RestArea( aAreaSM0 )
   
    If Len(_aMsg) > 0
      FGERALOG(_aMsg,cPath,"Baixa")
	EndIf


Return()

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

/*{Protheus.doc} FGERALOG
Log de Erros arquivo csv
@type function
@version  12.1.2210
*/

Static Function FGERALOG(_aMsg,cArquivo,cTitulo)
    
    Local cFileNom :='Log_'+cTitulo+"_"+dToS(Date())+StrTran(Time(),":")+".txt"
	Local cQuebra  := CRLF + "+=======================================================================+" + CRLF
	Local cTexto   := ""
	Local nX := 0
	Local cDirArq := ""
	Local nHdl := 0

	//Pegando o caminho do arquivo
	cDirArq := "\nexxera\download\BAIXA_REC_LOG\" 

	//Se o nome n o estiver em branco
	If !Empty(cFileNom)
		//Teste de exist ncia do diret rio
		If !ExistDir(cDirArq)
			MakeDir(cDirArq)
		EndIf

		nHdl := FCreate(cDirArq+cFileNom, FC_NORMAL)

		if nHdl = -1
			CONOUT ("Erro ao criar arquivo de log " + Str(Ferror()))
		Else
			//Montando a mensagem
			FWrite(nHdl,cQuebra)

			cTexto += " Data - "+ dToC(dDataBase)
            cTexto += " Hora - "+ Time()+cQuebra

			For nX := 1 To Len(_aMsg)
                cTexto += " Linha: "+ _aMsg[nX] [1] + " Status: "+_aMsg[nX] [4]
                FWrite(nHdl,cTexto)
				cTexto := ""
			Next nX
			FClose(nHdl)
        EndIf
    EndIf
Return

