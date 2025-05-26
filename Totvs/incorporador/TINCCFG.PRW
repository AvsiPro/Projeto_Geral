#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TINCCFG ³ Autor ³ Alexandre Venancio    ³ Data ³ 04/11/2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TINCCFG(lWH)

Local nOpc      := GD_INSERT+GD_DELETE+GD_UPDATE
Local nOk       := 0
Local cPathGCT  := ""
Local aRet      := {}
Local lOk       := .F.
Local nCont     := 0
Local lDp       := .T.
Local cFileLog  := ""
Local cFileLog123 := "_Evidencia criacao de parametros ZX5_SX5_SX6 " + DTOS(dDataBase) + "_" + StrTran(Time(),":","") + ".log"
Private aCoBrw1 := {}
Private aCoBrw2 := {}
Private aCoBrw3 := {}
Private aHoBrw1 := {}
Private aHoBrw2 := {}
Private aHoBrw3 := {}
Private aHoBrwZX5 := {}    // aHeader do WH
Private aHoBrwSX5 := {}
Private aHoBrwSX6 := {}
Private aBrwZX5 := {}      // aCols do WH
Private aBrwSX5 := {}
Private aBrwSX6 := {}
Private noBrw1  := 0
Private noBrw2  := 0
Private noBrw3  := 0

Private oDlg1
Private oGrp1
Private oSay1
Private oSay2
Private oGet1
Private oGet2
Private oGrp2
Private oBrw1
Private oGrp3
Private oBrw2
Private oGrp4
Private oBrw3
Private oBtn2
Private oProcess
Private cGet1
Private cGet2
Private cGet3
Private cGet4
Private cEmp1
Private cEmp2
Private INCLUI := .T.
Private ALTERA := .T.
Private aSM0Data2 := {} //issue TIPDBP-1125

Default lWH := .F.

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("00","00001003300")
EndIf

/*
AAdd(aPar,{1,"Grupo Origem" ,Space(2),"","","SM0TIN","", 50, .T. } )
AAdd(aPar,{1,"Filial Origem" ,Space(11),"","","SM0","", 50, .T. } )
AAdd(aPar,{1,"Grupo Destino" ,Space(2),"","","SM0TIN","", 50, .T. } )
AAdd(aPar,{1,"Filial Destino",Space(11),"","","SM0","", 50, .T. } )

*/
If !lWH
   aRet := fgrupos()
Else
   If FWAlertYesNo("Filial a migrar parâmetros: " + cEmpAnt + " - " + cFilDest)
      cPathGCT := cGetFile("Arquivos CSV|*.CSV", OemToAnsi("Selecione o dir. dos Arqs. de parâmetros"),0,"SERVIDOR\",.T.,GETF_LOCALHARD + GETF_NETWORKDRIVE+ GETF_RETDIRECTORY)         
      oProcess := MsNewProcess():New({|| aRet := fLoadCsv(@aBrwZX5,@aBrwSX5,@aBrwSX6,cPathGCT,oProcess)}, "Carregando arquivos a importar...", "Aguarde...", .T.)
      oProcess:Activate()
      If !Empty(aRet)
      cGet3 := aRet[1]
      cGet4 := aRet[3]
      cGet1 := aRet[2]
      cGet2 := aRet[4]
      cFileLog := cPathGCT + cFileLog123
      Else
         Return Nil
      Endif
   Endif      
Endif

If len(aRet) > 0 //ParamBox(aPar,"Parâmetros",aRet)
   
   cGet3 := aRet[1]
   cGet4 := aRet[3]
   cGet1 := aRet[2]
   cGet2 := aRet[4]

   aFilRet := FWSM0Util():GetSM0Data( aRet[1] , aRet[2] , { "M0_FILIAL" } )
   cEmp1   := aFilRet[1,2]
   aFilRet := FWSM0Util():GetSM0Data( aRet[3] , aRet[4] , { "M0_FILIAL" } )
   cEmp2   := aFilRet[1,2]

   If Empty(cEmp1) .Or. Empty(cEmp2)
      FWAlertError("Filial inexistente")
      lOk := .T.
   ENDIF

   While !lOk
      oDlg1      := MSDialog():New( 092,232,854,1775,"Parâmetros " + IIF(lWH,"WH Integra+","Incorporador"),,,.F.,,,,,,.T.,,,.T. )

      oGrp1      := TGroup():New( 004,242,064,518,IIF(!lWH,"Filiais",""),oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
      If !lWH
         oSay1      := TSay():New( 020,270,{||"Filial Origem"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
         oSay3      := TSay():New( 020,314,{||cGet1+" / "+cEmp1},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,152,008)
         
         oSay2      := TSay():New( 040,270,{||"Filial Destino"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
         oSay4      := TSay():New( 040,314,{||cGet2+" / "+cEmp2},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,152,008)
      Else
         oSay2      := TSay():New( 020,270,{||"Filial Destino"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
         oSay4      := TSay():New( 020,314,{||cGet2+" / "+cEmp2},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,152,008)
      Endif

      oGrp2      := TGroup():New( 068,012,182,352,"ZX5",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

      If lDp
         If lWH
            Processa({|| MHoBrwZX5()},"Aguarde")
            Processa({|| MCoBrwZX5()},"Aguarde")
            oBrw1      := MsNewGetDados():New(076,016,178,348,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp2,aHoBrwZX5,aBrwZX5 )
         Else
            Processa({|| MHoBrw1()},"Aguarde")            
            Processa({|| MCoBrw1()},"Aguarde")
            oBrw1      := MsNewGetDados():New(076,016,178,348,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp2,aHoBrw1,aCoBrw1 )
         Endif
      ENDIF

      oGrp3      := TGroup():New( 186,012,344,352,"SX5",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

      If lDp
         If lWH
            Processa({|| MHoBrwSX5()},"Aguarde")
            Processa({|| MCoBrwSX5()},"Aguarde")
            oBrw2      := MsNewGetDados():New(194,016,336,348,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp3,aHoBrwSX5,aBrwSX5 )
         Else
            Processa({|| MHoBrw2()},"Aguarde")
            Processa({|| MCoBrw2()},"Aguarde")
            oBrw2      := MsNewGetDados():New(194,016,336,348,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp3,aHoBrw2,aCoBrw2 )               
         Endif
      EndIf

      oGrp4      := TGroup():New( 068,362,344,753,"SX6",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

      If lDp
         If lWH
            Processa({|| MHoBrwSX6()},"Aguarde")
            Processa({|| MCoBrwSX6()},"Aguarde")
            oBrw3      := MsNewGetDados():New(078,364,336,748,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp4,aHoBrwSX6,aBrwSX6 )
         Else
            Processa({|| MHoBrw3()},"Aguarde")
            Processa({|| MCoBrw3()},"Aguarde")
            oBrw3      := MsNewGetDados():New(078,364,336,748,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp4,aHoBrw3,aCoBrw3 )               
         Endif
      ENDIF

      oBtn1      := TButton():New( 352,280,"Salvar",oDlg1,{||oDlg1:end(nOk:=1)},037,012,,,,.T.,,"",,,,.F. )
      oBtn2      := TButton():New( 352,380,"Cancelar",oDlg1,{||oDlg1:end(nOk:=0)},037,012,,,,.T.,,"",,,,.F. )

      oDlg1:Activate(,,,.T.)

      If nOk == 1
         If !lWH
            lOk := .F.
            lDp := .F.         
            For nCont := 1 to len(oBrw1:aCols)
               If !oBrw1:aCols[nCont,len(oBrw1:aHeader)+1]
                  If Alltrim(oBrw1:aCols[nCont,02]) == "_INCDP"
                     If Alltrim(oBrw1:aCols[nCont,03]) <> Alltrim(oBrw1:aCols[nCont,04]) .And. !Empty(oBrw1:aCols[nCont,04])  
                        lDp := .T.
                        lOk := .T.
                     Else
                        lDp := .F.
                        lOk := .F.
                        FWAlertError("Não encontrado De/Para")
                        exit
                     EndIf
                  EndIf
               EndIf
            Next nCont
         Endif
         If !lDp
            FWAlertError("Não encontrado De/Para")
         else
            If !lWH
               nPosFil := Ascan(aHoBrw1,{|x| Alltrim(x[2]) == "ZX5_FILIAL"})
               nPosTab := Ascan(aHoBrw1,{|x| Alltrim(x[2]) == "ZX5_TABELA"})
               nPosCh1 := Ascan(aHoBrw1,{|x| Alltrim(x[2]) == "ZX5_CHAVE"})
               nPosCh2 := Ascan(aHoBrw1,{|x| Alltrim(x[2]) == "ZX5_CHAVE2"})
               nPosDes := Ascan(aHoBrw1,{|x| Alltrim(x[2]) == "ZX5_DESCRI"})
            Else
               nPosFil := Ascan(aHoBrwZX5,{|x| Alltrim(x[2]) == "ZX5_FILIAL"})
               nPosTab := Ascan(aHoBrwZX5,{|x| Alltrim(x[2]) == "ZX5_TABELA"})
               nPosCh1 := Ascan(aHoBrwZX5,{|x| Alltrim(x[2]) == "ZX5_CHAVE"})
               nPosCh2 := Ascan(aHoBrwZX5,{|x| Alltrim(x[2]) == "ZX5_CHAVE2"})
               nPosDes := Ascan(aHoBrwZX5,{|x| Alltrim(x[2]) == "ZX5_DESCRI"})
               GrvArq(cFileLog, "Criação de parâmetros   ########## Inicio: ########## " + Time())
               GrvArq(cFileLog, "")
               GrvArq(cFileLog, "Tabela ZX5 --")
               GrvArq(cFileLog, "ZX5_FILIAL;ZX5_TABELA;ZX5_CHAVE;ZX5_CHAVE2;ZX5_DESCRI" )
            Endif
            
            If cGet3 <> cGet4
               RpcClearEnv()
               RpcSetType(3)
               RPCSetEnv(cGet4,cGet2)
            EndIf
            
            DbSelectArea("ZX5")
            DbSetOrder(1)
            For nCont := 1 to len(oBrw1:aCols)
               If !oBrw1:aCols[nCont,len(oBrw1:aHeader)+1]

                  If !Dbseek(AVKEY(oBrw1:aCols[nCont,nPosFil],"ZX5_FILIAL")+AVKEY(oBrw1:aCols[nCont,nPosTab],"ZX5_TABELA")+AVKEY(oBrw1:aCols[nCont,nPosCh1],"ZX5_CHAVE")+AVKEY(oBrw1:aCols[nCont,nPosCh2],"ZX5_CHAVE2"))
                     RecLock("ZX5", .T.)
                  Else
                     RecLock("ZX5", .F.)
                  EndIf

                  ZX5->ZX5_FILIAL := oBrw1:aCols[nCont,nPosFil]                  
                  ZX5->ZX5_TABELA := oBrw1:aCols[nCont,nPosTab]
                  ZX5->ZX5_CHAVE  := oBrw1:aCols[nCont,nPosCh1]
                  ZX5->ZX5_CHAVE2 := oBrw1:aCols[nCont,nPosCh2]
                  ZX5->ZX5_DESCRI := oBrw1:aCols[nCont,nPosDes]
                  If ZX5->(MsUnlock()) .and. lWH
                     GrvArq(cFileLog,oBrw1:aCols[nCont,nPosFil]+";"+oBrw1:aCols[nCont,nPosTab]+";"+oBrw1:aCols[nCont,nPosCH1]+";"+oBrw1:aCols[nCont,nPosCH2]+";"+oBrw1:aCols[nCont,nPosDes])
                  Endif

               Else
                  If Dbseek(AVKEY(oBrw1:aCols[nCont,nPosFil],"ZX5_FILIAL")+AVKEY(oBrw1:aCols[nCont,nPosTab],"ZX5_TABELA")+AVKEY(oBrw1:aCols[nCont,nPosCh1],"ZX5_CHAVE")+AVKEY(oBrw1:aCols[nCont,nPosCh2],"ZX5_CHAVE2"))
                     RecLock("ZX5", .F.)
                     DbDelete()
                     ZX5->(MsUnlock())
                  EndIf
               EndIf
            Next nCont
            
            If !lWH
               nPosFil := Ascan(aHoBrw2,{|x| Alltrim(x[2]) == "X5_FILIAL"})
               nPosTab := Ascan(aHoBrw2,{|x| Alltrim(x[2]) == "X5_TABELA"})
               nPosCh1 := Ascan(aHoBrw2,{|x| Alltrim(x[2]) == "X5_CHAVE"})
               nPosDes := Ascan(aHoBrw2,{|x| Alltrim(x[2]) == "X5_DESCRI"})
            Else 
               nPosFil := Ascan(aHoBrwSX5,{|x| Alltrim(x[2]) == "X5_FILIAL"})
               nPosTab := Ascan(aHoBrwSX5,{|x| Alltrim(x[2]) == "X5_TABELA"})
               nPosCh1 := Ascan(aHoBrwSX5,{|x| Alltrim(x[2]) == "X5_CHAVE"})
               nPosDes := Ascan(aHoBrwSX5,{|x| Alltrim(x[2]) == "X5_DESCRI"})   
               GrvArq(cFileLog,"")  
               GrvArq(cFileLog,"Tabela SX5 --")
               GrvArq(cFileLog,"X5_FILIAL;X5_TABELA;X5_CHAVE;X5_DESCRI;X5_DESCSPA;X5_DESCENG" )       
            Endif
            cAlias := "SX5"
            DbSelectArea(cAlias)
            DbSetOrder(1)
            For nCont := 1 to len(oBrw2:aCols)
               If !oBrw2:aCols[nCont,len(oBrw2:aHeader)+1]

                  If !Dbseek(Avkey(oBrw2:aCols[nCont,nPosFil],"X5_FILIAL")+Avkey(oBrw2:aCols[nCont,nPosTab],"X5_TABELA")+Avkey(oBrw2:aCols[nCont,nPosCh1],"X5_CHAVE"))
                     RecLock(cAlias, .T.)
                  Else
                     RecLock(cAlias, .F.)
                  EndIf
                  If !lWH
                     &(cAlias+"->"+Alltrim(aHoBrw2[nPosFil,2])) := oBrw2:aCols[nCont,nPosFil]
                     &(cAlias+"->"+Alltrim(aHoBrw2[nPosTab,2])) := oBrw2:aCols[nCont,nPosTab]
                     &(cAlias+"->"+Alltrim(aHoBrw2[nPosCh1,2])) := oBrw2:aCols[nCont,nPosCh1]
                     &(cAlias+"->"+Alltrim(aHoBrw2[nPosDes,2])) := oBrw2:aCols[nCont,nPosDes]
                  Else
                     &(cAlias+"->"+Alltrim(aHoBrwSX5[nPosFil,2])) := IIF(Empty(oBrw2:aCols[nCont,nPosFil]),Space(11),oBrw2:aCols[nCont,nPosFil])
                     &(cAlias+"->"+Alltrim(aHoBrwSX5[nPosTab,2])) := oBrw2:aCols[nCont,nPosTab]
                     &(cAlias+"->"+Alltrim(aHoBrwSX5[nPosCh1,2])) := oBrw2:aCols[nCont,nPosCh1]
                     &(cAlias+"->"+Alltrim(aHoBrwSX5[nPosDes,2])) := oBrw2:aCols[nCont,nPosDes]                
                  Endif
                  &(cAlias)->(MsUnlock())
                  If lWH
                     GrvArq(cFileLog,oBrw2:aCols[nCont,nPosFil]+";"+oBrw2:aCols[nCont,nPosTab]+";"+oBrw2:aCols[nCont,nPosCH1]+";"+oBrw2:aCols[nCont,nPosDes])
                  Endif
               Else
                  If Dbseek(Avkey(oBrw2:aCols[nCont,nPosFil],"X5_FILIAL")+Avkey(oBrw2:aCols[nCont,nPosTab],"X5_TABELA")+Avkey(oBrw2:aCols[nCont,nPosCh1],"X5_CHAVE"))
                     RecLock(cAlias, .F.)
                     DbDelete()
                     &(cAlias)->(MsUnlock())
                  EndIf
               EndIf
            Next nCont
            If !lWH
               nPosFil := Ascan(aHoBrw3,{|x| Alltrim(x[2]) == "X6_FIL"})
               nPosTab := Ascan(aHoBrw3,{|x| Alltrim(x[2]) == "X6_VAR"})
               nPosCh1 := Ascan(aHoBrw3,{|x| Alltrim(x[2]) == "X6_TIPO"})
               nPosDes := Ascan(aHoBrw3,{|x| Alltrim(x[2]) == "X6_DESCRIC"})
               nPosCnt := Ascan(aHoBrw3,{|x| Alltrim(x[2]) == "X6_CONTEUD"})
            Else
               nPosFil := Ascan(aHoBrwSX6,{|x| Alltrim(x[2]) == "X6_FIL"})
               nPosTab := Ascan(aHoBrwSX6,{|x| Alltrim(x[2]) == "X6_VAR"})
               nPosCh1 := Ascan(aHoBrwSX6,{|x| Alltrim(x[2]) == "X6_TIPO"})
               nPosDes := Ascan(aHoBrwSX6,{|x| Alltrim(x[2]) == "X6_DESCRIC"})
               nPosCnt := Ascan(aHoBrwSX6,{|x| Alltrim(x[2]) == "X6_CONTEUD"})
               GrvArq(cFileLog,"")  
               GrvArq(cFileLog,"Tabela SX6 --")
               GrvArq(cFileLog,"X6_FIL;X6_VAR;X6_TIPO;X6_DESCRIC;X6_CONTEUD" )                 
            Endif
            cAlias := "SX6"
            DbSelectArea(cAlias)
            DbSetOrder(1)
            For nCont := 1 to len(oBrw3:aCols)
               If !oBrw3:aCols[nCont,len(oBrw3:aHeader)+1]
                  
                  If !Dbseek(oBrw3:aCols[nCont,nPosFil]+oBrw3:aCols[nCont,nPosTab])
                     RecLock(cAlias, .T.)
                  Else
                     RecLock(cAlias, .F.)
                  EndIf
                  If !lWH
                     &(cAlias+"->"+Alltrim(aHoBrw3[nPosFil,2])) := oBrw3:aCols[nCont,nPosFil]
                     &(cAlias+"->"+Alltrim(aHoBrw3[nPosTab,2])) := oBrw3:aCols[nCont,nPosTab]
                     &(cAlias+"->"+Alltrim(aHoBrw3[nPosCh1,2])) := oBrw3:aCols[nCont,nPosCh1]
                     &(cAlias+"->"+Alltrim(aHoBrw3[nPosDes,2])) := oBrw3:aCols[nCont,nPosDes]
                     &(cAlias+"->"+Alltrim(aHoBrw3[nPosCnt,2])) := oBrw3:aCols[nCont,nPosCnt]
                  Else 
                     If !empty(oBrw3:aCols[nCont,nPosFil]) // Filial não pode estar vazia!
                     &(cAlias+"->"+Alltrim(aHoBrwSX6[nPosFil,2])) := oBrw3:aCols[nCont,nPosFil]
                     &(cAlias+"->"+Alltrim(aHoBrwSX6[nPosTab,2])) := oBrw3:aCols[nCont,nPosTab]
                     &(cAlias+"->"+Alltrim(aHoBrwSX6[nPosCh1,2])) := oBrw3:aCols[nCont,nPosCh1]
                     &(cAlias+"->"+Alltrim(aHoBrwSX6[nPosDes,2])) := oBrw3:aCols[nCont,nPosDes]
                     &(cAlias+"->"+Alltrim(aHoBrwSX6[nPosCnt,2])) := oBrw3:aCols[nCont,nPosCnt]
                     Else
                        FWAlertError("Filial do parâmetro "+oBrw3:aCols[nCont,nPosTab]+" está vazia!")
                        &(cAlias)->(MsUnlock())
                        Loop
                     Endif
                  Endif
                  &(cAlias)->(MsUnlock())
                  If lWH
                     GrvArq(cFileLog,oBrw3:aCols[nCont,nPosFil]+";"+oBrw3:aCols[nCont,nPosTab]+";"+oBrw3:aCols[nCont,nPosCH1]+";"+oBrw3:aCols[nCont,nPosDes]+";"+oBrw3:aCols[nCont,nPosCnt])                  
                  Endif                  
               Else
                  If Dbseek(oBrw3:aCols[nCont,nPosFil]+oBrw3:aCols[nCont,nPosTab])
                     RecLock(cAlias, .F.)
                     DbDelete()
                     &(cAlias)->(MsUnlock())
                  EndIf
               EndIf
            Next nCont

            FWAlertSuccess("Registros atualizados com sucesso!!!")
            If lWH
               GrvArq(cFileLog,"")  
               GrvArq(cFileLog,"########## Termino: " + Time())
               ShellExecute('open', cFileLog, '', 'C:\', 1)
               lOk := .T.
            Endif            
         EndIf
      else
         lOk := .T.
      EndIf
   EndDo
EndIf
Return

/*Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„
Function  Â³ MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: 
Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„*/
Static Function MHoBrw1()

Local aAuxX3 := {}
Local nCont  := 0
Local aAux   := {}
noBrw1 := 0

aAuxX3 := FWSX3Util():GetAllFields( "ZX5" , .F. )

For nCont := 1 to len(aAuxX3)


   aAux := FWSX3Util():GetFieldStruct( aAuxX3[nCont] )

   Aadd(aHoBrw1,{ Alltrim(FWSX3Util():GetDescription( aAuxX3[nCont]  ) ),;
                     aAux[1],;
                     "",;
                     aAux[3],;
                     aAux[4],;
                     "",;
                     "",;
                     aAux[2],;
                     "",;
                     "" } )
Next nCont

noBrw1  := LEN(aHoBrw1)

Return


/*Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„
Function  Â³ MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: 
Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„*/
Static Function MCoBrw1()

Local nI   := 1
Local aAux := {"TFTS01","FILINC"}
Local nX   := 0
Local nPosFil := Ascan(aHoBrw1,{|x| Alltrim(x[2]) == "ZX5_FILIAL"})
Local nPosTab := Ascan(aHoBrw1,{|x| Alltrim(x[2]) == "ZX5_TABELA"})
Local nPosCh1 := Ascan(aHoBrw1,{|x| Alltrim(x[2]) == "ZX5_CHAVE"})
Local nPosCh2 := Ascan(aHoBrw1,{|x| Alltrim(x[2]) == "ZX5_CHAVE2"})
Local nPosDes := Ascan(aHoBrw1,{|x| Alltrim(x[2]) == "ZX5_DESCRI"})

DbSelectArea("ZX5")
DbSetOrder(1)
If Dbseek(cGet1+"_INCDP")
   
   While !EOF() .And. Alltrim(ZX5->ZX5_TABELA) == "_INCDP" .AND. ZX5->ZX5_FILIAL == cGet1
      
      Aadd(aCoBrw1,Array(noBrw1+1))

      aCoBrw1[nI][nPosFil] := ZX5->ZX5_FILIAL
      aCoBrw1[nI][nPosTab] := ZX5->ZX5_TABELA
      aCoBrw1[nI][nPosCh1] := ZX5->ZX5_CHAVE
      aCoBrw1[nI][nPosCh2] := ZX5->ZX5_CHAVE2
      aCoBrw1[nI][nPosDes] := ZX5->ZX5_DESCRI

      aCoBrw1[nI][noBrw1+1] := .F.
      nI++
       
      DBSkip()
   EndDo

else

   cQuery := "SELECT E1_PREFIXO,COUNT(*)"
   cQuery += " FROM "+RetSQLName("SE1")
   cQuery += " WHERE E1_FILIAL='"+cGet1+"' AND E1_SALDO>0"
   cQuery += " AND D_E_L_E_T_=' '"
   cQuery += " GROUP BY E1_PREFIXO"

   If Select('TRB') > 0
      dbSelectArea('TRB')
      dbCloseArea()
   EndIf

   DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

   DbSelectArea("TRB")

   While !EOF()
      Aadd(aCoBrw1,Array(noBrw1+1))

      aCoBrw1[nI][nPosFil] := cGet1
      aCoBrw1[nI][nPosTab] := "_INCDP"
      aCoBrw1[nI][nPosCh1] := TRB->E1_PREFIXO
      aCoBrw1[nI][nPosCh2] := SPACE(3)
      aCoBrw1[nI][nPosDes] := 'DE PARA INCORPORADOR - '+cEmp1+' para '+cEmp2

      aCoBrw1[nI][noBrw1+1] := .F.
      nI++
      Dbskip()
   EndDo
   
EndIf

DbSelectArea("ZX5")
DbSetOrder(1)
If Dbseek(cGet1)
   While !EOF() .And. ZX5->ZX5_FILIAL == cGet1 .And. ascan(aCoBrw1,{|x| x[1]+x[2] == ZX5->ZX5_FILIAL+ZX5->ZX5_TABELA}) == 0
      Aadd(aCoBrw1,Array(noBrw1+1))

      aCoBrw1[nI][nPosFil] := cGet2 //ZX5->ZX5_FILIAL
      aCoBrw1[nI][nPosTab] := ZX5->ZX5_TABELA
      aCoBrw1[nI][nPosCh1] := ZX5->ZX5_CHAVE
      aCoBrw1[nI][nPosCh2] := ZX5->ZX5_CHAVE2
      aCoBrw1[nI][nPosDes] := ZX5->ZX5_DESCRI

      aCoBrw1[nI][noBrw1+1] := .F.
      nI++
      DBSkip()
   EndDo
EndIf

DbSelectArea("ZX5")
DbSetOrder(1)
For nX := 1 to len(aAux)

   If Dbseek(xFilial("ZX5")+aAux[nX])
      While !EOF() .And. ZX5->ZX5_TABELA == aAux[nX]
         If Alltrim(ZX5->ZX5_CHAVE2) == cGet1
            Aadd(aCoBrw1,Array(noBrw1+1))

            aCoBrw1[nI][nPosFil] := ZX5->ZX5_FILIAL
            aCoBrw1[nI][nPosTab] := ZX5->ZX5_TABELA
            aCoBrw1[nI][nPosCh1] := ZX5->ZX5_CHAVE
            aCoBrw1[nI][nPosCh2] := cGet2 //ZX5->ZX5_CHAVE2
            aCoBrw1[nI][nPosDes] := If(aAux[nX]=="TFTS01",cEmp2,ZX5->ZX5_DESCRI)

            aCoBrw1[nI][noBrw1+1] := .F.
            nI++
         EndIf
         DBSkip()
      EndDo
   EndIf
Next nX

Return

/*Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„
Function  Â³ MHoBrw2() - Monta aHeader da MsNewGetDados para o Alias: 
Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã…Ã„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„*/
Static Function MHoBrw2()

Local aAuxX3 := {}
Local nCont  := 0
Local aAux   := {}

noBrw2 := 0

aAuxX3 := FWSX3Util():GetAllFields( "SX5" , .F. )

For nCont := 1 to len(aAuxX3)


   aAux := FWSX3Util():GetFieldStruct( aAuxX3[nCont] )

   Aadd(aHoBrw2,{ Alltrim(FWSX3Util():GetDescription( aAuxX3[nCont]  ) ),;
                     aAux[1],;
                     "",;
                     aAux[3],;
                     aAux[4],;
                     "",;
                     "",;
                     aAux[2],;
                     "",;
                     "" } )
Next nCont

noBrw2  := LEN(aHoBrw2)

Return


/*Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„
Function  Â³ MCoBrw2() - Monta aCols da MsNewGetDados para o Alias: 
Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã…Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„*/
Static Function MCoBrw2()

Local aArea    := GetArea()
Local nI       := 1
Local cQuery 

nPosFil := Ascan(aHoBrw2,{|x| Alltrim(x[2]) == "X5_FILIAL"})
nPosTab := Ascan(aHoBrw2,{|x| Alltrim(x[2]) == "X5_TABELA"})
nPosCh1 := Ascan(aHoBrw2,{|x| Alltrim(x[2]) == "X5_CHAVE"})
nPosDes := Ascan(aHoBrw2,{|x| Alltrim(x[2]) == "X5_DESCRI"})

cQuery := "SELECT X5_FILIAL AS FILGRP,X5_TABELA AS TABGRP,X5_CHAVE AS CHVGRP,X5_DESCRI AS DESGRP" 
cQuery += " FROM "+RetSQLName("SX5")
cQuery += " WHERE X5_FILIAL='"+cGet1+"' AND D_E_L_E_T_=' '"
cQuery += " UNION"
cQuery += " SELECT X5_FILIAL,X5_TABELA,X5_CHAVE,X5_DESCRI"
cQuery += " FROM "+RetSQLName("SX5")
cQuery += " WHERE X5_TABELA='_E' AND X5_DESCRI LIKE '"+cGet3+cGet1+"' AND D_E_L_E_T_=' '"

If Select("cGX5") > 0		
   ("cGX5")->(DbCloseArea()) 
EndIf

DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), "cGX5", .T., .F.)

While !EOF()
   Aadd(aCoBrw2,Array(noBrw2+1))
   aCoBrw2[nI,nPosFil] := If(Alltrim(cGX5->TABGRP)<>"_E",cGet2,cGX5->FILGRP)
   aCoBrw2[nI,nPosTab] := cGX5->TABGRP
   aCoBrw2[nI,nPosCh1] := cGX5->CHVGRP
   aCoBrw2[nI,nPosDes] := cGX5->DESGRP
   
   aCoBrw2[nI][noBrw2+1] := .F.
   nI++
   Dbskip()
EndDo 

If len(aCoBrw2) < 1

   Aadd(aCoBrw2,Array(noBrw2+1))

   For nI := 1 To noBrw2
      aCoBrw2[1][nI] := CriaVar(aHoBrw2[nI][2])
   Next

   aCoBrw2[1][noBrw2+1] := .F.

EndIf 

RestArea(aArea)

Return

/*Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„
Function  Â³ MHoBrw3() - Monta aHeader da MsNewGetDados para o Alias: 
Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã…Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„*/
Static Function MHoBrw3()

Local aAux := {"X6_FIL",;
               "X6_VAR",;
               "X6_TIPO",;
               "X6_DESCRIC",;
               "X6_CONTEUD" } 

Local nX  := 0
noBrw3 := 0

For nX := 1 to len(aAux)
   Aadd(aHoBrw3,{ aAux[nX],;
                  aAux[nX],;
                  "@!",;
                  15,;
                  0,;
                  "",;
                  "",;
                  "C",;
                  "",;
                  "" } )   
                  noBrw3++
Next nX            
 

Return


/*Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã‚Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„
Function  Â³ MCoBrw3() - Monta aCols da MsNewGetDados para o Alias: 
Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã…Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„*/
Static Function MCoBrw3()

Local nI   := 1


DbSelectArea("SX6")
DbSetOrder(1)

If Dbseek(cGet1)
   While !EOF() .And. SX6->(FieldGet(FieldPos("X6_FIL"))) == cGet1
      Aadd(aCoBrw3,Array(noBrw3+1))
//aCoBrw3[nI][1] := If(SX6->X6_VAR<>"TI_COMISLB",cGet2,SX6->(FieldGet(FieldPos("X6_FIL")))

      aCoBrw3[nI][1] := If(SX6->(FieldGet(FieldPos("X6_VAR")))<>"TI_COMISLB",cGet2,SX6->(FieldGet(FieldPos("X6_FIL")))) //
      aCoBrw3[nI][2] := SX6->(FieldGet(FieldPos("X6_VAR")))
      aCoBrw3[nI][3] := SX6->(FieldGet(FieldPos("X6_TIPO")))
      aCoBrw3[nI][4] := SX6->(FieldGet(FieldPos("X6_DESCRIC")))
      aCoBrw3[nI][5] := SX6->(FieldGet(FieldPos("X6_CONTEUD")))
      
      aCoBrw3[nI][noBrw3+1] := .F.
      nI++
      DBSkip()
   EndDo
Else

   Aadd(aCoBrw3,Array(noBrw3+1))

   For nI := 1 To noBrw3
      aCoBrw3[1][nI] := CriaVar(aHoBrw3[nI][2])
   Next

   aCoBrw3[1][noBrw3+1] := .F.

EndIf

/*
   Parametro que trava até que comissão seja liberada
*/

If ascan(aCoBrw3,{|x| Alltrim(x[2]) == 'TI_COMISLB'}) == 0
   Aadd(aCoBrw3,Array(noBrw3+1))

   aCoBrw3[nI][1] := cGet1
   aCoBrw3[nI][2] := 'TI_COMISLB'
   aCoBrw3[nI][3] := 'L'
   aCoBrw3[nI][4] := 'Comissao liberada'
   aCoBrw3[nI][5] := Avkey('.F.',"X6_CONTEUD")

   aCoBrw3[nI][noBrw3+1] := .F.
EndIf 
Return

/*/{Protheus.doc} fgrupos
   (long_description)
   @type  Static Function
   @author user
   @since 08/11/2022
   @version version
   @param param_name, param_type, param_descr
   @return return_var, return_type, return_description
   @example
   (examples)
   @see (links_or_references)
/*/
Static Function fgrupos()

Local aArea        := GetArea()
Local aRet         := {}  
Local nOpc         := 0
Private cGetS1     := Space(2)
Private cGetS2     := Space(11)
Private cGetS3     := Space(2)
Private cGetS4     := Space(11)

SetPrvt("oSel1","oGrp1","oSay1","oSay2","oSay3","oSay4","oGetS1","oGetS2","oGetS3","oGetS4","oSelb1","oSelb2")

oSel1      := MSDialog():New( 092,232,415,729,"Selecione Grupo e Filial",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 012,020,128,216,"",oSel1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 032,044,{||"Grupo Origem"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay2      := TSay():New( 056,044,{||"Filial Origem"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 080,044,{||"Grupo Destino"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay4      := TSay():New( 104,044,{||"Filial Destino"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetS1     := TGet():New( 032,120,{|u| If(PCount()>0,cGetS1:=u,cGetS1)},oGrp1,060,008,'',{|| cEmpAnt := cGetS1},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SM0TIN","cGetS1",,)
oGetS2     := TGet():New( 056,120,{|u| If(PCount()>0,cGetS2:=u,cGetS2)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SM0","cGetS2",,)
oGetS3     := TGet():New( 080,120,{|u| If(PCount()>0,cGetS3:=u,cGetS3)},oGrp1,060,008,'',{|| cEmpAnt := cGetS3},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SM0TIN","cGetS3",,)
oGetS4     := TGet():New( 104,120,{|u| If(PCount()>0,cGetS4:=u,cGetS4)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SM0","cGetS4",,)

oSelb1      := TButton():New( 136,064,"Confirmar",oSel1,{|| oSel1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
oSelb2      := TButton():New( 136,140,"Cancelar",oSel1,{|| oSel1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

oSel1:Activate(,,,.T.)

If nOpc == 1
   Aadd(aRet,cGetS1)
   Aadd(aRet,cGetS2)
   Aadd(aRet,cGetS3)
   Aadd(aRet,cGetS4)

EndIf 

RestArea(aArea)
Return(aRet)


/*/{Protheus.doc} fLoadcsv
   Carrega os arrays aBrwZX5,aBrwSX5,aBrwSX6 contendo os parâmetros a serem tombados pelo WH IntegraMais
    para a filial destino
   @type  Static Function
   @author Julio Saraiva
   @since 18/10/2024
   @version version
   @param aBrwZX5,aBrwSX5,aBrwSX6
   @return aRet com as informações de variáveis de empresa e filial ; Origem e Destino
   @example
   (examples)
      aRet := fLoadCsv(@aBrwZX5,@aBrwSX5,@aBrwSX6)
/*/

Static Function fLoadcsv(aBrwZX5,aBrwSX5,aBrwSX6,cPathGCT,oObjP)
Local aRet     := {}
Local aArqs    := {}
Local aArea    := GetArea()
Local nHdl	   := 0
Local nCnt     := 0
Local cFileSX5 := ""
Local cFileZX5 := ""
Local cFileSX6 := ""
Local cBuffer  := ""
Local nAtual   := 1
Local lOkZX5   := .F.
Local lOkSX5   := .F.
Local lOkSX6   := .F.

Aadd(aRet,cEmpAnt)
Aadd(aRet,cFilAnt)
Aadd(aRet,cEmpAnt)
Aadd(aRet,cFilDest)

aArqs := Directory(cPathGCT + "*.CSV*")

If Len(aArqs) > 0
   nCnt++
Endif

If nCnt > 0
   oObjP:SetRegua1(90)
   oObjP:IncRegua1("Importando parâmetros " + cValToChar(nAtual) + " de " + cValToChar(90) + "...")

   While nCnt <= Len(aArqs)
      Do Case
         Case "ZX5" $ Upper( AllTrim( aArqs[nCnt][1] )  )
            cFileZX5	:= cPathGCT  + aArqs[nCnt][1]
            lOkZX5 := .T.
         Case "SX5" $ Upper( AllTrim( aArqs[nCnt][1] )  )
            cFileSX5	:= cPathGCT  + aArqs[nCnt][1]
            lOkSX5 := .T.
         Case "SX6" $ Upper( AllTrim( aArqs[nCnt][1] )  )
            cFileSX6	:= cPathGCT  + aArqs[nCnt][1]
            lOkSX6 := .T.
      EndCase   
      nCnt++ 
      nAtual++     
   Enddo
   IF !lOkZX5 .or. !lOkSX5 .or. !lOkSX6
      FWAlertError("Uma ou mais tabela SX não foi encontrada na pasta especificada. A importação dos parâmetros será interrompida.")
      RestArea(aArea)
      Return {}
   Endif
   nHdl	:= FT_FUse( cFileZX5 )
   nCnt := 0

   While !FT_FEof()
      nCnt++
      cBuffer  := FReadLine()
      AADD(aBrwZX5, aBIToken(cBuffer, ';',.F.))
      If nCnt == 1
         AADD(aBrwZX5[nCnt]," ")
      Else
         AADD(aBrwZX5[nCnt],.F.)
      Endif
      FT_FSkip()
      oObjP:IncRegua2("Importando ZX5 " + cValToChar(nCnt) + " de " + cValToChar(15) + "...")      
      PROCESSMESSAGES()
   EndDo

   FClose(nHdl)
   nCnt := 0
   nHdl	:= FT_FUse( cFileSX5 )

   While !FT_FEof()
      nCnt++
      cBuffer  := FReadLine()
      AADD(aBrwSX5, aBIToken(cBuffer, ';',.F.))
      If nCnt == 1
         AADD(aBrwSX5[nCnt]," ")
      Else
         AADD(aBrwSX5[nCnt],.F.)
      Endif
      FT_FSkip()
      oObjP:IncRegua2("Importando SX5 " + cValToChar(nCnt) + " de " + cValToChar(15) + "...")      
      PROCESSMESSAGES()      
   EndDo

   FClose(nHdl)
   nCnt := 0
   nHdl	:= FT_FUse( cFileSX6 )

   While !FT_FEof()
      nCnt++
      cBuffer  := FReadLine()
      AADD(aBrwSX6, aBIToken(cBuffer, ';',.F.))
      If len(aBrwSX6[nCnt]) < 5
         AADD(aBrwSX6[nCnt]," ")
      Endif
      If nCnt == 1
         AADD(aBrwSX6[nCnt]," ")
      Else
         AADD(aBrwSX6[nCnt],.F.)
      Endif      
      FT_FSkip()
      oObjP:IncRegua2("Importando SX6 " + cValToChar(nCnt) + " de " + cValToChar(40) + "...")      
      PROCESSMESSAGES()      
   EndDo

   FClose(nHdl)   

Else
   FWAlertError("Arquivos CSV com origem dos parâmetros não lida !")
Endif

RestArea(aArea)
Return aRet


/*/{Protheus.doc} MHoBrwZX5
Monta o aHeader da ZX5 para o uso no webhook
   @type  Static Function
   @author Julio Saraiva
   @since 18/10/2024
   @version version
   @param 
   @return 
/*/

Static Function MHoBrwZX5()

Local aAuxX3 := {}
Local nCont  := 0
Local aAux   := {}
noBrw1 := 0

aAuxX3 := aBrwZX5[1]    // Linha do cabeçalho
For nCont := 1 to len(aAuxX3)
   If !Empty(AllTrim(aAuxX3[nCont]))
      aAux := FWSX3Util():GetFieldStruct( aAuxX3[nCont] )
      Aadd(aHoBrwZX5,{ Alltrim(FWSX3Util():GetDescription( aAuxX3[nCont]  ) ),;
                        aAux[1],;
                        "",;
                        aAux[3],;
                        aAux[4],;
                        "",;
                        "",;
                        aAux[2],;
                        "",;
                        "" } )
      CriaVar(aAuxX3[nCont])
   Endif
Next nCont

noBrw1  := LEN(aHoBrwZX5)
dbSelectArea("ZX5")

Return

/*/{Protheus.doc} MCoBrwZX5
   (long_description)
   Monta aCols da MsNewGetDados para o Alias ZX5 no caso de tombamento
   @type  Static Function
   @author Julio Saraiva
   @since 18/10/2024
   @version version
   @param None
   @return 
/*/

Static Function MCoBrwZX5()

Local aArrayAux := {}
Local lRet      := .T.
Local nI        := 0

For nI:=2 to Len(aBrwZX5)
   AADD(aArrayAux,aBrwZX5[nI])
Next nI

aBrwZX5 := aClone(aArrayAux)

Return lRet


/*/{Protheus.doc} MHoBrwSX5
Monta o aHeader da SX5 para o uso no webhook
   @type  Static Function
   @author Julio Saraiva
   @since 21/10/2024
   @version version
   @param 
/*/

Static Function MHoBrwSX5()

Local aAuxX3 := {}
Local nCont  := 0
Local aAux   := {}
noBrw2 := 0

aAuxX3 := aBrwSX5[1]    // Linha do cabeçalho
For nCont := 1 to len(aAuxX3)
   If !Empty(AllTrim(aAuxX3[nCont]))
      aAux := FWSX3Util():GetFieldStruct( aAuxX3[nCont] )
      Aadd(aHoBrwSX5,{ Alltrim(FWSX3Util():GetDescription( aAuxX3[nCont]  ) ),;
                        aAux[1],;
                        "",;
                        aAux[3],;
                        aAux[4],;
                        "",;
                        "",;
                        aAux[2],;
                        "",;
                        "" } )
   Endif
Next nCont

noBrw2  := LEN(aHoBrwSX5)

Return

/*/{Protheus.doc} MCoBrwSX5
   (long_description)
   Monta aCols da MsNewGetDados para o Alias SX5 no caso de tombamento
   @type  Static Function
   @author Julio Saraiva
   @since 21/10/2024
   @version version
   @param None
   @return 
/*/

Static Function MCoBrwSX5()

Local aArrayAux := {}
Local lRet      := .T.
Local nI        := 0

For nI:=2 to Len(aBrwSX5)
   AADD(aArrayAux,aBrwSX5[nI])
Next nI

aBrwSX5 := aClone(aArrayAux)

Return lRet

/*/{Protheus.doc} MHoBrwSX6
Monta o aHeader da SX6 para o uso no webhook
   @type  Static Function
   @author Julio Saraiva
   @since 21/10/2024
   @version version
   @param 
   @return 
/*/

Static Function MHoBrwSX6()

Local aAux := {"X6_FIL",;
               "X6_VAR",;
               "X6_TIPO",;
               "X6_DESCRIC",;
               "X6_CONTEUD" } 

Local nX   := 0
noBrw3     := 0

For nX := 1 to len(aAux)
   Aadd(aHoBrwSX6,{ aAux[nX],;
                  aAux[nX],;
                  "@!",;
                  15,;
                  0,;
                  "",;
                  "",;
                  "C",;
                  "",;
                  "" } )   
                  noBrw3++
Next nX            

Return

/*/{Protheus.doc} MCoBrwSX6
   (long_description)
   Monta aCols da MsNewGetDados para o Alias SX6 no caso de tombamento
   @type  Static Function
   @author Julio Saraiva
   @since 21/10/2024
   @version version
   @param None
   @return 
/*/

Static Function MCoBrwSX6()

Local aArrayAux := {}
Local lRet      := .T.
Local nI        := 0

For nI:=2 to Len(aBrwSX6)
   AADD(aArrayAux,aBrwSX6[nI])
Next nI

aBrwSX6 := aClone(aArrayAux)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} FReadLine
Funcao para leitura de linhas com o tamanho superior a 1023

@author Norbert/Ernani/Mansano
@since 05/10/05
@return NIL
/*/
//-------------------------------------------------------------------
Static Function FReadLine()
	Local cLinhaTmp  := ""
	Local cLinhaM100 := ""
	Local cLinAnt    := ""
	Local cLinProx   := ""
	Local cIdent     := ""

	cLinhaTmp	:= FT_FReadLN()
	If !Empty(cLinhaTmp)
		cIdent	:= MD5(cLinhaTmp,2)
		If Len(cLinhaTmp) < 1023
			cLinhaM100	:= cLinhaTmp
		Else
			cLinAnt		:= cLinhaTmp
			cLinhaM100	+= cLinAnt

			Ft_FSkip()
			cLinProx:= Ft_FReadLN()
			If Len(cLinProx) >= 1023 .and. MD5(cLinProx,2) <> cIdent
				While Len(cLinProx) >= 1023 .and. MD5(cLinProx,2) <> cIdent .and. !Ft_fEof()
					cLinhaM100 += cLinProx
					Ft_FSkip()
					cLinProx := Ft_fReadLn()
					If Len(cLinProx) < 1023 .and. MD5(cLinProx,2) <> cIdent
						cLinhaM100 += cLinProx
					EndIf
				Enddo
			Else
				cLinhaM100 += cLinProx
			EndIf
		EndIf
	EndIf
Return cLinhaM100


Static Function GrvArq(cArquivo, cLinha, lEnter)
   Local nHandle2 := 0
   Default lEnter := .t.
   If ! File(cArquivo)
      If (nHandle2 := MSFCreate(cArquivo,0)) == -1
         Return
      EndIf
   Else
      If (nHandle2 := FOpen(cArquivo,2)) == -1
         Return
      EndIf
   EndIf
   FSeek(nHandle2,0,2)
   If lEnter
      FWrite(nHandle2, cLinha + CRLF)
   Else 
      FWrite(nHandle2, cLinha )
   EndIf 
   FClose(nHandle2)
Return
