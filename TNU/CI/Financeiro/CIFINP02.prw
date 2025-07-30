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
@since      15/07/2025
@version    1.0
/*/
//--------------------------------------------------------------------------------

User function CIFINP02()

Local cEmp  := ""
Local cFil  := ""
Local cQuery 
Local n2
Local n1    :=  0
Local _aMsg :=  {}

Private lMsErroAuto := .F.
Private lMsHelpAuto := .F.

    cEmp   := "01"
    cFil   := "000101"

    if !empty(cFil) .and. !empty(cEmp)
	
	    RPCSetType(3) 

	    RPCSetEnv(cEmp,cFil)
        
        cQuery := "SELECT ZPT.R_E_C_N_O_ AS RECNZPT,ZPT.* FROM "+RetSQLName("ZPT")+" ZPT"
        cQuery += " WHERE ZPT_FILIAL BETWEEN ' ' AND 'ZZZ' "
        cQuery += "  AND D_E_L_E_T_ = '' "  

        cTab := MPSysOpenQuery(cQuery)
        DbSelectArea((cTab))
        (cTab)->(DbGoTop())

        cPrefixo := 'ECU'
        
        While !EOF()
            n1++
            cFilTIT := (cTab)->ZPT_FILIAL
            cNumTit := (cTab)->ZPT_NUM
            cParcel := (cTab)->ZPT_APARC
            cTipo   := (cTab)->ZPT_ATIPO
            cNSU    := (cTab)->ZPT_ANSU
            cAutori := (cTab)->ZPT_AAUT

            DbSelectArea( 'SE1' )
            SE1->( dbSetOrder(1) )
            If SE1->(DbSeek(cFilTIT + cPrefixo + cNumTit +cParcel + cTipo ))
                IF SE1->E1_SALDO = 0
                    cMsg := 'Filial: ' +cFilTIT + ' Prefixo: ECU ' + ' NSU: ' + cNSU +' Autoriz: '+cAutori+ ' Parcela: ' + cParcel + ' Tipo: ' + cTipo +'Docto: '+cNumTit+ ' -> Título ja esta baixado ' + Chr( 13 ) + Chr( 10 )
                    Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",cFilTIT, cMsg})
                    
                    DbSelectArea("ZPT")
                    DbGoto((cTab)->RECNZPT)
                    Reclock("ZPT",.F.)
                    ZPT->ZPT_STATUS := 'B'
                    ZPT->(MsUnLock())
                    
                    DbSelectArea((cTab))
                    (cTab)->(DbSkip())
                    loop
                Endif

                _nValPgto := (cTab)->ZPT_AVALOR
                _nvLrTar  := (SE1->E1_VALOR - (cTab)->ZPT_AVALOR)
                dDataBase := stod((cTab)->ZPT_DTBX)

                IF (_nValPgto + _nvLrTar) > SE1->E1_VALOR
                    cMsg := 'Filial: ' +cFilTIT + ' Prefixo: ECU ' + ' NSU: ' + cNSU +' Autoriz: '+cAutori+ ' Parcela: ' + cParcel + ' Tipo: ' + cTipo +'Docto: '+cNumTit+ ' -> Valor da Baixa Maior que valor do Titulo ' + Chr( 13 ) + Chr( 10 )
                    Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",cFilTIT, cMsg})
                    exit
                Endif

                aBaixa := {}
                aAdd(aBaixa,{"E1_PREFIXO"  ,SE1->E1_PREFIXO         ,Nil    })
                aAdd(aBaixa,{"E1_NUM"      ,SE1->E1_NUM             ,Nil    })
                aAdd(aBaixa,{"E1_PARCELA"  ,SE1->E1_PARCELA         ,Nil    })
                aAdd(aBaixa,{"E1_TIPO"     ,SE1->E1_TIPO            ,Nil    })
                aAdd(aBaixa,{"AUTMOTBX"    ,"NOR"                   ,Nil    })
                aAdd(aBaixa,{"AUTBANCO"    ,(cTab)->ZPT_BANCO       ,Nil    })
                aAdd(aBaixa,{"AUTAGENCIA"  ,(cTab)->ZPT_AGENCI      ,Nil    })
                aAdd(aBaixa,{"AUTCONTA"    ,(cTab)->ZPT_NUMCON      ,Nil    })
                aAdd(aBaixa,{"AUTDTBAIXA"  ,dDataBase               ,Nil    })
                aAdd(aBaixa,{"AUTDTCREDITO",dDataBase               ,Nil    })
                aAdd(aBaixa,{"AUTHIST"     ,'Baixa Aut. CIFINAP02'  ,Nil    })
                aAdd(aBaixa,{"AUTVALREC"   ,_nValPgto               ,Nil    })
                aAdd(aBaixa,{"AUTDESCONT"  ,_nvLrTar                ,Nil    })

                SM0->( DbSetOrder( 1 ) )
                If SM0->( DbSeek( cEmpAnt + SE1->E1_FILIAL ) )
                    cFilBKP := cFilAnt
                    cFilAnt := AllTrim( SM0->M0_CODFIL )
                EndIf
                
                lMsErroAuto := .F.

                MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)

                If lMsErroAuto
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
                    
                    DbSelectArea("ZPT")
                    DbGoto((cTab)->RECNZPT)
                    Reclock("ZPT",.F.)
                    ZPT->ZPT_STATUS := 'B'
                    ZPT->(MsUnLock())
                EndIf
                aTit := { }
            ELSE
                CONOUT("[CIFINP02] - SE1 NAO ENCONTRADO LINHA: " + cValToChar(N1))
                cMsg := 'Filial: ' +cFilTIT + ' Prefixo: ECU ' + ' NSU: ' + cNSU + ' Autoriz: '+cAutori+ ' Parcela: ' + cParcel + ' Tipo: ' + cTipo +'Docto: '+cNumTit+ ' -> Título nao Encontrado!!! ' + Chr( 13 ) + Chr( 10 )
                Aadd(_aMsg,{Alltrim(Str(n1)),"SE1",cFilTIT, cMsg})
            EndIf 

            DbSelectArea((cTab))
            (cTab)->(DbSkip())
        EndDo 

        (cTab)->(DbCloseArea())

        If Len(_aMsg) > 0
            FGERALOG(_aMsg,cPath,"Baixa")
        EndIf

    endif 

Return

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

	If !Empty(cFileNom)
		If !ExistDir(cDirArq)
			MakeDir(cDirArq)
		EndIf

		nHdl := FCreate(cDirArq+cFileNom, FC_NORMAL)

		if nHdl = -1
			CONOUT ("Erro ao criar arquivo de log " + Str(Ferror()))
		Else
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
