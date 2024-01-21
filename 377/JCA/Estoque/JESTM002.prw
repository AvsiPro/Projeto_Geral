#INCLUDE 'PROTHEUS.CH'

/*
    Rotina para digitação de inventário rotativo
    MIT 44_ESTOQUE_EST014 - Tela de lançamento do inventário

    DOC MIT
    https://docs.google.com/document/d/1gWLAfq1rFwx43DRVUBRK87BVvtTec4QD/edit
    DOC Entrega
    
    
*/

User Function JESTM002

Private lNewInv := .F.

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

TelaDig()



Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function TelaDig()

Local aArea     := GetArea()
Local nOpcao    := 0
Local nCont     := 0

Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oGrp2,oBtn1
Private oList1
Private aList1  := {}
PRIVATE oOk     := LoadBitmap(GetResources(),'br_verde')  
PRIVATE oNo     := LoadBitmap(GetResources(),'br_vermelho')
Private cCodInv := ''
Private nContag := 0

Aadd(aList1,{.f.,'','','','','','','','','','','','','','','','','','','','','','',''})

oDlg1      := MSDialog():New( 092,232,809,1666,"Inventário Rotativo",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,196,040,440,"Informações inventário",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oSay1      := TSay():New( 012,260,{||"Código"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
        oSay2      := TSay():New( 012,284,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
        oSay3      := TSay():New( 028,200,{||"Usuário"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
        oSay4      := TSay():New( 028,224,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,212,008)
    
    oGrp2      := TGroup():New( 044,008,328,704,"Itens inventário",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{052,012,324,700},,, oGrp2 ) 
        oList1    := TCBrowse():New(052,012,685,270,, {'','Local','Prateleira','Material','Descrição','Marca','Cod.Original',;
                                                    'Qtd Inicial','Qtd Entrada','Qtd Saida','Qtd Atual',;
                                                    'Contagem 1','Contagem 2','Contagem 3','Divergência'},;
                                        {10,20,30,45,80,30,35,30,30,30,30,30,30,30,30},;
                                        oGrp1,,,,{|| /*FHelp(oList1:nAt)*/},{|| editped(oList1:nAt,1)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList1:SetArray(aList1)
        oList1:bLine := {||{iF(aList1[oList1:nAt,01],oOk,oNo),; 
                            aList1[oList1:nAt,02],;
                            aList1[oList1:nAt,03],;
                            aList1[oList1:nAt,04],;
                            aList1[oList1:nAt,05],;
                            aList1[oList1:nAt,06],;
                            aList1[oList1:nAt,07],;
                            aList1[oList1:nAt,08],;
                            aList1[oList1:nAt,09],;
                            aList1[oList1:nAt,10],;
                            aList1[oList1:nAt,11],;
                            aList1[oList1:nAt,12],;
                            aList1[oList1:nAt,13],;
                            aList1[oList1:nAt,14],;
                            aList1[oList1:nAt,15]}}

        //oBtn1      := TButton():New( 332,664,"oBtn1",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
        //Botões diversos
        oMenu := TMenu():New(0,0,0,0,.T.)
        // Adiciona itens no Menu
        oTMenuIte1 := TMenuItem():New(oDlg1,"Novo",,,,{|| _novoinv()},,,,,,,,,.T.)
        oTMenuIte2 := TMenuItem():New(oDlg1,"Digitar Cotagens",,,,{|| Processa({||_buscainv(),"Aguarde"})} ,,,,,,,,,.T.)
        oTMenuIte3 := TMenuItem():New(oDlg1,"Gravar",,,,{|| oDlg1:end(nOpcao:=1)} ,,,,,,,,,.T.)
        oTMenuIte4 := TMenuItem():New(oDlg1,"Impressões",,,,{|| Processa({||imprexc(),"Aguarde"}) } ,,,,,,,,,.T.)
        oTMenuIte5 := TMenuItem():New(oDlg1,"Liberar",,,,{|| /*Processa({|| GeraPv(0),"Aguarde"})*/} ,,,,,,,,,.T.)
        oTMenuIte6 := TMenuItem():New(oDlg1,"Processar",,,,{|| /*Processa({|| GeraPv(0),"Aguarde"})*/} ,,,,,,,,,.T.)
        oTMenuIte0 := TMenuItem():New(oDlg1,"Sair",,,,{|| oDlg1:end(nOpcao:=0)} ,,,,,,,,,.T.)


        oMenu:Add(oTMenuIte1)
        oMenu:Add(oTMenuIte2)
        oMenu:Add(oTMenuIte3)
        oMenu:Add(oTMenuIte4)
        oMenu:Add(oTMenuIte5)
        oMenu:Add(oTMenuIte6)
        oMenu:Add(oTMenuIte0)

        // Cria botão que sera usado no Menu  
        oTButton1 := TButton():New( 332, 664, "Opções",oDlg1,{||},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
        // Define botão no Menu
        oTButton1:SetPopupMenu(oMenu)

        MENU oMenuP1 POPUP 
		MENUITEM "Marcar/Desmarcar Todos" ACTION (Processa({|| editped(,2)},"Aguarde"))
        MENUITEM "Estornar Contagens" ACTION (Processa({|| estorncnt()},"Aguarde"))
        ENDMENU                                                                           

		oList1:bRClicked := { |oObject,nX,nY| oMenuP1:Activate( nX, (nY-10), oObject ) }


oDlg1:Activate(,,,.T.)

If nOpcao == 1
    If len(aList1) > 0 
        For nCont := 1 to len(aList1)
            If aList1[nCont,1]
                Processa({||GravPrInv(nCont)}, "Aguarde")
            EndIf 
        Next nCont 

        MsgAlert("Gravação finalizada")
    EndIf   
EndIf 


RestArea(aArea)

Return

/*/{Protheus.doc} editped
    (long_description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editped(nLinha,nOpc)

Local nCont := 1
Local nPosCol := oList1:nColPos

IF nPosCol < 3
    If nOpc == 1
        If !Empty(aList1[nLinha,04])
            If aList1[nLinha,01] 
                aList1[nLinha,01] := .F.
            Else 
                aList1[nLinha,01] := .T.
            EndIf
        endIf 
    Else 
        If !Empty(aList1[nCont,04])
            For nCont := 1 to len(aList1)
                If aList1[nCont,01]
                    aList1[nCont,01] := .F.
                Else 
                    aList1[nCont,01] := .T.
                EndIF 
            Next nCont 
        EndIf 
    EndIf 
Else 
    //If nPosCol >= 12 .And. nPosCol <= 14
        If aList1[oList1:nAt,01]
            lEditCell(aList1,oList1,"@E 9999999",If(nContag==1,12,If(nContag==2,13,14)))

            If nContag == 1
                aList1[oList1:nAt,15] := aList1[oList1:nAt,12] - aList1[oList1:nAt,11]
            ElseIf nContag == 2
                aList1[oList1:nAt,15] := aList1[oList1:nAt,13] - aList1[oList1:nAt,11]

            Else
                aList1[oList1:nAt,15] := aList1[oList1:nAt,14] - aList1[oList1:nAt,11]
            EndIf  
        EndIf 
    //EndIf
EndIf 

oList1:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} estorncnt()
    (long_description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function estorncnt()

Local aArea  := GetArea()
Local aPergs := {}
Local aRet   := {}
Local nCont  := 0
Local nAux   := 0

aAdd(aPergs ,{2,"Contagem"	,"", {"1=Estornar a ultima","2=Estornar todas"},90,'',.T.})

If ParamBox(aPergs ,"Filtrar por",@aRet)    
    
    nAux := val(aRet[1])
    DbSelectArea("ZPE")
    
    For nCont := 1 to len(aList1)
        DbGoto(aList1[nCont,16])
        Reclock("ZPE",.F.)

        If nAux == 1
            &("ZPE->ZPE_DTCNT"+aList1[nCont,17]) := ctod(' / / ')
            &("ZPE->ZPE_HRCNT"+aList1[nCont,17]) := ' '
            
            If val(aList1[nCont,17]) == 3
                aList1[nCont,14] := 0
                aList1[nCont,15] := aList1[nCont,13] - aList1[nCont,11]
            ElseIf val(aList1[nCont,17]) == 2
                aList1[nCont,13] := 0
                aList1[nCont,15] := aList1[nCont,12] - aList1[nCont,11]
            Else 
                aList1[nCont,12] := 0
                aList1[nCont,15] := 0 
            EndIf   

            ZPE->ZPE_STATUS := cvaltochar(val(aList1[nCont,17])-1)
            aList1[nCont,17] := cvaltochar(val(aList1[nCont,17])-1)
        Else 
            ZPE->ZPE_CONTA1 := 0
            ZPE->ZPE_CONTA2 := 0
            ZPE->ZPE_CONTA3 := 0
            ZPE->ZPE_RESULT := 0
            ZPE->ZPE_DTCNT1 := ctod(' / / ')
            ZPE->ZPE_DTCNT2 := ctod(' / / ')
            ZPE->ZPE_DTCNT3 := ctod(' / / ')
            ZPE->ZPE_HRCNT1 := ' '
            ZPE->ZPE_HRCNT2 := ' '
            ZPE->ZPE_HRCNT3 := ' '
            aList1[nCont,12] := 0
            aList1[nCont,13] := 0
            aList1[nCont,14] := 0
            aList1[nCont,15] := 0
            ZPE->ZPE_STATUS := '0'
        EndIf 

        ZPE->(Msunlock())

        

    Next nCont 
EndIf
    
oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} imprexc
    (long_description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function imprexc()
Local aArea  := GetArea()
Local aPergs := {}
Local aRet   := {}
Local nTipo  := 0
Local nCont  := 0
Private aHeader := {}
Private aAuxExc := {}

aAdd(aPergs ,{2,"Tipo Impressão"	,"", {"1=Excel p/ Contagem","2=Conferência"},90,'',.T.})

If ParamBox(aPergs ,"Filtrar por",@aRet)    
    
    nTipo := aRet[1]

    If val(nTipo) == 1
        Aadd(aHeader,{  'Local',;
                        'Prateleira',;
                        'Material',;
                        'Descrição',;
                        'Marca',;
                        'Codigo Original',;
                        'Contagem 1',;
                        'Contagem 2',;
                        'Contagem 3'})
        
        For nCont := 1 to len(aList1)
            Aadd(aAuxExc,{aList1[nCont,02],;
                        aList1[nCont,03],;
                        aList1[nCont,04],;
                        aList1[nCont,05],;
                        aList1[nCont,06],;
                        aList1[nCont,07],;  
                        '',;
                        '',;
                        ''  })
        Next nCont 

        Processa({|| GeraPlan()},"Aguarde")
    Else 

    EndIf 

EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} _novoinv
    Gera um novo inventário
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function _novoinv()

Local aPergs := {}
Local aRet   := {}

Private cProdDe := ''
Private cProdAt := ''
Private cGrupDe := ''
Private cGrupAt := ''
Private cMarcDe := ''
Private cMarcAt := ''
Private dDtDe   := CtoD(' / / ')
Private dDtAt   := CtoD(' / / ')
Private cLocIn  := ''
Private lSoMov  := .F.

aAdd(aPergs ,{1,"Produto de:"	,space(TamSx3("B1_COD")[1]),"@!",".T.","SB1",".T.",70,.F.})
aAdd(aPergs ,{1,"Produto Até:"	,padr('zz',TamSx3("B1_COD")[1]),"@!",".T.","SB1",".T.",70,.F.})
aAdd(aPergs ,{1,"Grupo de"	    ,space(TamSx3("B1_GRUPO")[1]) ,"@!",".T.","SBM",".T.",60,.F.})
aAdd(aPergs ,{1,"Grupo Até"	    ,padr('zz',TamSx3("B1_GRUPO")[1]) ,"@!",".T.","SBM",".T.",60,.F.})
aAdd(aPergs ,{1,"Marca de"      ,space(TamSx3("ZPM_COD")[1])   ,"@!",".T.","ZPM",".T.",80,.F.})
aAdd(aPergs ,{1,"Marca Até"     ,padr('zz',TamSx3("ZPM_COD")[1])   ,"@!",".T.","ZPM",".T.",80,.F.})
aAdd(aPergs ,{1,"Data de"       ,dDtDe   ,"",".T.","",".T.",80,.F.})
aAdd(aPergs ,{1,"Data Até"      ,dDtAt   ,"",".T.","",".T.",80,.F.})
aAdd(aPergs ,{1,"Local"         ,space(TamSx3("D1_LOCAL")[1])   ,"@!",".T.","NNR",".T.",80,.F.})
aAdd(aPergs ,{2,"Somente c/Mov.","", {"1=Sim","2=Nao"},50,'',.T.})


If ParamBox(aPergs ,"Filtrar por",@aRet)    
    
    cProdDe := aRet[1]
    cProdAt := aRet[2]
    cGrupDe := aRet[3]
    cGrupAt := aRet[4]
    cMarcDe := aRet[5]
    cMarcAt := aRet[6]
    dDtDe   := aRet[7]
    dDtAt   := aRet[8]
    cLocIn  := aRet[9]
    lSoMov  := If(aRet[10]=="1",.T.,.F.)

    _xQrjest2()

EndIf
    
Return

/*/{Protheus.doc} _buscainv
    Procura um inventário pelo código
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function _buscainv()

Local aPergs := {}
Local aRet   := {}

aAdd(aPergs ,{1,"Código:"	,space(TamSx3("ZPE_CODIGO")[1]),"@!",".T.","ZPE",".T.",70,.F.})
aAdd(aPergs ,{2,"Contagem"	,"", {"1=Contagem 1","2=Contagem 2","3=Contagem 3"},50,'',.T.})

//aAdd(aPergs ,{1,"Data"      ,dDtDe   ,"",".T.","",".T.",80,.F.})


If ParamBox(aPergs ,"Filtrar por",@aRet)    
    
    cCodInv := aRet[1]
    nContag := val(aRet[2])

    PreaList(cCodInv)

EndIf
    
Return
/*/{Protheus.doc} _novoinv
    Gera um novo inventário
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function _xQrjest2()

Local cWhereD1 := '', cWhereD1C := ''
Local cWhereD2 := '', cWhereD2C := ''
Local cWhereD3 := '', cWhereD3C := '', cWhereB1C := ''

Local cFromSBZ  := ''
Local cAliasTop := GetNextAlias()
Local aSalAtu   := { 0,0,0,0,0,0,0 }

aList1 := {}

cWhereB1A:= "%"
cWhereB1B:= "%"
cWhereB1C:= "%"
cWhereB1D:= "%"

cFromSBZ := '%'+RetSqlName('SB1')+' SB1,'+RetSqlName('SBZ')+' SBZ %'

cWhereD1C := "%"
cWhereD1C += " D1_FILIAL ='" + xFilial("SD1") + "' AND "
cWhereD1C += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND"
cWhereD1C += "%"


cWhereD1 := "%"
cWhereD1 += "AND"
cWhereD1 += " D1_LOCAL = '" + cLocIn + "' AND"
cWhereD1 += "%"

cWhereB1C += " SB1.B1_GRUPO >= '"+cGrupDe+"' AND SB1.B1_GRUPO <= '"+cGrupAt+"' AND"
cWhereB1C += " SB1.D_E_L_E_T_=' '"

cWhereD2 := "%"
cWhereD2 += "AND"
cWhereD2 += " D2_LOCAL = '" + cLocIn + "' AND"
cWhereD2 += "%"	

cWhereD2C := "%"
cWhereD2C += " D2_FILIAL ='" + xFilial("SD2") + "' AND "
cWhereD2C += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND"
cWhereD2C += "%"


cWhereB1A+= " AND SB1.B1_COD >= '"+cProdDe+"' AND SB1.B1_COD <= '"+cProdAt+"'"
cWhereB1B+= " AND SB1.B1_COD = SB1EXS.B1_COD"

cWhereD3 := "%"
If A900GetMV(2, 'MV_D3ESTOR', .F., 'N') == 'N'
    cWhereD3 += " D3_ESTORNO <> 'S' AND"
EndIf

cWhereD3 += " D3_LOCAL = '"+cLocIn+"' AND"
cWhereD3 += " SB1.B1_COD >= '"+cProdDe+"' AND SB1.B1_COD <= '"+cProdAt+"' AND"
cWhereD3 += " SB1.B1_GRUPO >= '"+cGrupDe+"' AND SB1.B1_GRUPO <= '"+cGrupAt+"' AND "
cWhereD3 += " SB1.D_E_L_E_T_=' ' AND"
cWhereD3 += "%"
cWhereD3C := "%"
cWhereD3C += " D3_FILIAL ='" + xFilial("SD3")  + "' AND "
cWhereD3C += "%"

cQueryB1A:= Subs(cWhereB1A,2)
cQueryB1B:= Subs(cWhereB1B,2)
cQueryB1C:= Subs(cWhereB1C,2)
cQueryB1D:= Subs(cWhereB1D,2)

cWhereB1A+= "%"
cWhereB1B+= "%"
cWhereB1C+= "%"
cWhereB1D+= "%"

cOrder := "%"
cOrder += " 2"
cOrder += "%"


BeginSql Alias cAliasTop

    SELECT 	'SD1' ARQ, 				//-- 01 ARQ
            SB1.B1_COD PRODUTO, 	//-- 02 PRODUTO
            SB1.B1_TIPO TIPO, 		//-- 03 TIPO
            SB1.B1_UM,   			//-- 04 UM
            SB1.B1_GRUPO,      	//-- 05 GRUPO
            SB1.B1_DESC,      		//-- 06 DESCR
            SB1.B1_POSIPI, 		//-- 07
            SB1.B1_ZMARCA,
            D1_SEQCALC SEQCALC,    //-- 08
            D1_DTDIGIT DTDIGIT,		//-- 09 DTDIGIT
            D1_TES TES,			//-- 10 TES
            D1_CF CF,				//-- 11 CF
            D1_NUMSEQ SEQUENCIA,	//-- 12 SEQUENCIA
            D1_DOC DOCUMENTO,		//-- 13 DOCUMENTO
            D1_SERIE SERIE,		//-- 14 SERIE
            D1_QUANT QUANTIDADE,	//-- 15 QUANTIDADE
            D1_QTSEGUM QUANT2UM,	//-- 16 QUANT2UM
            D1_LOCAL ARMAZEM,		//-- 17 ARMAZEM
            ' ' PROJETO,			//-- 18 PROJETO
            ' ' OP,				//-- 19 OP
            ' ' CC,				//-- 20 OP
            D1_FORNECE FORNECEDOR,	//-- 21 FORNECEDOR
            D1_LOJA LOJA,			//-- 22 LOJA
            ' ' PEDIDO,            //-- 23 PEDIDO
            D1_TIPO TIPONF,		//-- 24 TIPO NF
            ' ' TRT, 				//-- 26 TRT
            SD1.R_E_C_N_O_ NRECNO,  //-- 29 RECNO
            SD1.D1_LOCAL ARMLOC

    FROM %Exp:cFromSBZ%,%table:SD1% SD1,%table:SF4% SF4

    WHERE	SB1.B1_COD     =  SD1.D1_COD		AND  	%Exp:cWhereD1C%
            SD1.D1_TES     =  SF4.F4_CODIGO	AND
            SF4.F4_ESTOQUE =  'S'				AND 	SD1.D1_DTDIGIT >= %Exp:mv_par07%	AND
            SD1.D1_DTDIGIT <= %Exp:mv_par08%	AND		SD1.D1_ORIGLAN <> 'LF'
            %Exp:cWhereD1%
            SD1.%NotDel%						AND 	SF4.%NotDel%
            %Exp:cWhereB1A%                   AND
            %Exp:cWhereB1C%

    UNION

        SELECT 'SD2' ARQ,
            SB1.B1_COD,
            SB1.B1_TIPO,
            SB1.B1_UM,
            SB1.B1_GRUPO,
            SB1.B1_DESC,
            SB1.B1_POSIPI,
            SB1.B1_ZMARCA,
            D2_SEQCALC,
            D2_EMISSAO,
            D2_TES,
            D2_CF,
            D2_NUMSEQ,
            D2_DOC,
            D2_SERIE,
            D2_QUANT ,
            D2_QTSEGUM,
            D2_LOCAL,
            ' ',
            ' ',
            ' ',
            D2_CLIENTE,
            D2_LOJA,
            D2_PEDIDO,
            D2_TIPO,
            ' ',
            SD2.R_E_C_N_O_ SD2RECNO, //-- 29 RECNO
            SD2.D2_LOCAL
        FROM %Exp:cFromSBZ%,%table:SD2% SD2,%table:SF4% SF4

        WHERE	SB1.B1_COD     =  SD2.D2_COD		AND	%Exp:cWhereD2C%
                SD2.D2_TES     =  SF4.F4_CODIGO		AND
                SF4.F4_ESTOQUE =  'S'				AND	SD2.D2_EMISSAO >= %Exp:mv_par07%	AND
                SD2.D2_EMISSAO <= %Exp:mv_par08%	AND	SD2.D2_ORIGLAN <> 'LF'
                %Exp:cWhereD2%
                SD2.%NotDel%						AND SF4.%NotDel%
                %Exp:cWhereB1A%                     AND
                %Exp:cWhereB1C%

    UNION

        SELECT 	'SD3' ARQ,
                SB1.B1_COD,
                SB1.B1_TIPO,
                SB1.B1_UM,
                SB1.B1_GRUPO,
                SB1.B1_DESC,
                SB1.B1_POSIPI,
                SB1.B1_ZMARCA,
                D3_SEQCALC,
                D3_EMISSAO,
                D3_TM,
                D3_CF,
                D3_NUMSEQ,
                D3_DOC,
                ' ',
                D3_QUANT,
                D3_QTSEGUM,
                D3_LOCAL,
                D3_PROJPMS,
                D3_OP,
                D3_CC,
                ' ',
                ' ',
                ' ',
                ' ',
                D3_TRT,
                SD3.R_E_C_N_O_ SD3RECNO, //-- 29 RECNO
                SD3.D3_LOCAL

        FROM %Exp:cFromSBZ%,%table:SD3% SD3

        WHERE	SB1.B1_COD     =  SD3.D3_COD 		AND %Exp:cWhereD3C%
                SD3.D3_EMISSAO >= %Exp:mv_par07%	AND	SD3.D3_EMISSAO <= %Exp:mv_par08%	AND
                %Exp:cWhereD3%
                SD3.%NotDel%

    

    ORDER BY %Exp:cOrder%

EndSql
//%Exp:cUnion%
While !(cAliasTop)->(Eof())

    nPosic1 := Ascan(aList1,{|x| x[4] == (cAliasTop)->PRODUTO})

    nQtd1 := 0
    nQtd2 := 0
    nQtd3 := 0

    If (cAliasTop)->TES > '500'
        nQtd2 := (cAliasTop)->QUANTIDADE
    Else 
        nQtd1 := (cAliasTop)->QUANTIDADE
    EndIf 

    If nPosic1 == 0
        MR900ImpS1(@aSalAtu,cAliasTop,.T.)
        
        Aadd(aList1,{ .T.,;
                    (cAliasTop)->ARMAZEM,;
                    '',;
                    (cAliasTop)->PRODUTO,;
                    (cAliasTop)->B1_DESC,;
                    alltrim(Posicione("ZPM",1,xFilial("ZPM")+(cAliasTop)->B1_ZMARCA,"ZPM_DESC")),;
                    'CODIGO_ORIGINAL',;
                    aSalAtu[1],;
                    nQtd1,;
                    nQtd2,;
                    aSalAtu[1]+nQtd1-nQtd2,;
                    0,;
                    0,;
                    0,;
                    0,;
                    0,;
                    ''})
    Else 
        aList1[nPosic1,09] += nQtd1
        aList1[nPosic1,10] += nQtd2
        aList1[nPosic1,11] := aList1[nPosic1,11] + nQtd1 - nQtd2

    EndIf 

    Dbskip()
EndDo 

If !lSoMov
   
    cQuery := "SELECT ZPM_DESC,B1.*  "
    cQuery += " FROM "+RetSqlName("SB1")+" B1"
    cQuery += " INNER JOIN "+RetSqlName("ZPM")+" ZPM ON ZPM_FILIAL='"+xFilial("ZPM")+"' AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
    cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"
    cQuery += " AND B1_XCODPAI<>' ' AND B1.D_E_L_E_T_=' '"
    cQuery += " AND B1_COD BETWEEN '"+cProdDe+"' AND '"+cProdAt+"'"
    cQuery += " AND B1_GRUPO BETWEEN '"+cGrupDe+"' AND '"+cGrupAt+"'"
    cQuery += " AND B1_ZMARCA BETWEEN '"+cMarcDe+"' AND '"+cMarcAt+"'"
    
        
    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF

    MemoWrite("JESTM002.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB") 

    While !EOF()
        If ascan(aList1,{|x| x[4] == TRB->B1_COD}) == 0
            Aadd(aList1,{ .T.,;
                            cLocIn,;
                            '',;
                            TRB->B1_COD,;
                            TRB->B1_DESC,;
                            alltrim(TRB->ZPM_DESC),;
                            'CODIGO_ORIGINAL',;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            ''})
        endif
        Dbskip()
    EndDo 
EndIf 

If len(aList1) < 1
    Aadd(aList1,{.f.,'','','','','','','','','','','','','','','','','','','','','','',''})
Else 
    Asort(aList1,,,{|x,y| x[4] < y[4]})

    DbSelectArea("ZPE")
    cCodInv := GETSXENUM("ZPE","ZPE_CODIGO")     
    lNewInv := .T.
    oSay2:settext("")
    oSay4:settext("")
    oSay2:settext(cCodInv)
    oSay4:settext(cusername)                                                                                              
EndIf 


oList1:SetArray(aList1)
oList1:bLine := {||{iF(aList1[oList1:nAt,01],oOk,oNo),; 
                    aList1[oList1:nAt,02],;
                    aList1[oList1:nAt,03],;
                    aList1[oList1:nAt,04],;
                    aList1[oList1:nAt,05],;
                    aList1[oList1:nAt,06],;
                    aList1[oList1:nAt,07],;
                    aList1[oList1:nAt,08],;
                    aList1[oList1:nAt,09],;
                    aList1[oList1:nAt,10],;
                    aList1[oList1:nAt,11],;
                    aList1[oList1:nAt,12],;
                    aList1[oList1:nAt,13],;
                    aList1[oList1:nAt,14],;
                    aList1[oList1:nAt,15]}}

oList1:refresh()
oDlg1:refresh()

Return 

/*/{Protheus.doc} A900GetMV
	GetMV
	@type  Static Function
	@author g.moreira
	@since 10/04/2023
/*/
Static Function A900GetMV(nTipo, cParam, lHelp, xDefault, cFilMv)
	Local xRet := Nil
	If nTipo == 1
		xRet := GetMv(cParam, lHelp, xDefault)
	Else
		xRet := SuperGetMv(cParam, lHelp, xDefault, cFilMv)
	EndIf
Return xRet


/*/{Protheus.doc} MR900ImpS1
	busca saldo inicial na data informada
	@type  Static Function
	@author g.moreira
	@since 10/04/2023
/*/
Static Function MR900ImpS1(aSalAtu,cAliasTop,lQuery)

Local aArea     := GetArea()
Local i         := 0
Local nIndice   := 0
Local aSalAlmox := {}
Local cSeek     := ""
Local cFilBkp   := cFilAnt
Local cTrbSB2	:= CriaTrab(,.F.)
Local lSB2Mode  := .F.
Local lCusRep      := SuperGetMv("MV_CUSREP",.F.,.F.) .And. MA330AvRep()

Default lQuery   := .F.
Default cAliasTop:="SB1"
Default lCusFil  := .t.
default lCusEmp  := .F.
Default aFils    := {}

mv_par17 := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o Saldo Inicial do Produto             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusFil
	aArea:=GetArea()
	aSalAtu  := { 0,0,0,0,0,0,0 }
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(cSeek:=xFilial("SB2") + If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD))
	While !Eof() .And. B2_FILIAL+B2_COD == cSeek
		aSalAlmox := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),SB2->B2_LOCAL,dDtDe,,, ( lCusRep .And. mv_par17==2 ) )
		For i:=1 to Len(aSalAtu)
			aSalAtu[i] += aSalAlmox[i]
		Next i
		dbSkip()
	End
	RestArea(aArea)
ElseIf lCusEmp
	aArea	 := GetArea()
	aSalAtu  := { 0,0,0,0,0,0,0 }
	dbSelectArea("SB2")
	dbSetOrder(1)
	nIndice := RetIndex("SB2")
	dbSetOrder(nIndice+1)
	dbSeek(cSeek:=If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD))
	While !Eof() .And. SB2->B2_COD == cSeek
		If !Empty(xFilial("SB2"))
			cFilAnt := SB2->B2_FILIAL
		Else
			lSB2Mode := .T.
		EndIf
		If (!lSB2Mode .And. aScan(aFils, {|x| AllTrim(cFilAnt) $  AllTrim(x) }) > 0) .Or. lSB2Mode
			aSalAlmox := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),SB2->B2_LOCAL,mv_par05,,,( lCusRep .And. mv_par17==2 ) )
			For i:=1 to Len(aSalAtu)
				aSalAtu[i] += aSalAlmox[i]
			Next i
		EndIf
		dbSkip()
	End
	dbSelectArea("SB2")
	If !Empty(cTrbSB2) .And. File(cTrbSB2 + OrdBagExt())
		RetIndex("SB2")
		Ferase(cTrbSB2+OrdBagExt())
	EndIf
	cFilAnt := cFilBkp
	RestArea(aArea)
Else
	aSalAtu := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),mv_par08,mv_par05,,, ( lCusRep .And. mv_par17==2 ) )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o Custo de Reposicao do Produto        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusRep .And. mv_par17==2
	aSalAtu := {aSalAtu[1],aSalAtu[18],aSalAtu[19],aSalAtu[20],aSalAtu[21],aSalAtu[22],aSalAtu[07]}
EndIf

dbSelectArea("SB2")
MsSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+If(lCusFil .Or. lCusEmp,"",mv_par08))


RestArea(aArea)

RETURN

/*/{Protheus.doc} PreaList(cCodInv)
    Preenche array com o inventário ja cadastrado.
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function PreaList(cCodInv)

Local aArea := GetArea()
Local cQuery 
Local cCodUsr := ''

aList1 := {}

cQuery := "SELECT ZPE.R_E_C_N_O_ AS RECZPE,B1_ZMARCA,ZPM_DESC,B1_DESC,ZPE.* "
cQuery += " FROM "+RetSqlName("ZPE")+" ZPE "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=ZPE_PRODUT AND B1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSqlName("ZPM")+" ZPM ON ZPM_FILIAL='"+xFilial("ZPM")+"' AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
cQuery += " WHERE ZPE_FILIAL='"+xFilial("ZPE")+"'"
cQuery += " AND ZPE_CODIGO='"+cCodInv+"'"
cQuery += " AND ZPE.D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JESTM002.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    If val(TRB->ZPE_STATUS)+1 <> nContag .And. val(TRB->ZPE_STATUS) <> 3
        MsgAlert("Número da digitação informada é inválido, a contagem para este inventário atual é a numero "+cvaltochar(val(TRB->ZPE_STATUS)+1))
        exit
    EndIf 

    cCodUsr := TRB->ZPE_CODUSU

    Aadd(aList1,{   .T.,;
                    TRB->ZPE_LOCAL,;
                    TRB->ZPE_PRATEL,;
                    TRB->ZPE_PRODUT,;
                    TRB->B1_DESC,;
                    TRB->ZPM_DESC,;
                    'CODIGO_ORIGINAL',;
                    TRB->ZPE_SLDINI,;
                    TRB->ZPE_QTDENT,;
                    TRB->ZPE_QTDSAI,;
                    TRB->ZPE_SLDFIM,;
                    TRB->ZPE_CONTA1,;
                    TRB->ZPE_CONTA2,;
                    TRB->ZPE_CONTA3,;
                    TRB->ZPE_RESULT,;
                    TRB->RECZPE,;
                    TRB->ZPE_STATUS})
    Dbskip()
EndDo 


If len(aList1) < 1
    Aadd(aList1,{.f.,'','','','','','','','','','','','','','','','','','','','','','',''})
Else 
    oSay2:settext("")
    oSay4:settext("")
    oSay2:settext(cCodInv)
    oSay4:settext(FwGetUserName(cCodUsr))                                                                                              
EndIf 


oList1:SetArray(aList1)
oList1:bLine := {||{iF(aList1[oList1:nAt,01],oOk,oNo),; 
                    aList1[oList1:nAt,02],;
                    aList1[oList1:nAt,03],;
                    aList1[oList1:nAt,04],;
                    aList1[oList1:nAt,05],;
                    aList1[oList1:nAt,06],;
                    aList1[oList1:nAt,07],;
                    aList1[oList1:nAt,08],;
                    aList1[oList1:nAt,09],;
                    aList1[oList1:nAt,10],;
                    aList1[oList1:nAt,11],;
                    aList1[oList1:nAt,12],;
                    aList1[oList1:nAt,13],;
                    aList1[oList1:nAt,14],;
                    aList1[oList1:nAt,15]}}

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} GravPrInv
description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/


Static Function GravPrInv(nLinha)

Local aArea := GetArea()

DbSelectArea("ZPE")

If lNewInv
    Reclock("ZPE",.T.)
    ZPE->ZPE_FILIAL := xFilial("ZPE")
    ZPE->ZPE_CODIGO := cCodInv
    ZPE->ZPE_CODUSU := RetCodUsr()
    ZPE->ZPE_LOCAL  := aList1[nLinha,02]
    ZPE->ZPE_PRATEL := aList1[nLinha,03]
    ZPE->ZPE_PRODUT := aList1[nLinha,04]
    ZPE->ZPE_SLDINI := aList1[nLinha,08]
    ZPE->ZPE_QTDENT := aList1[nLinha,09]
    ZPE->ZPE_QTDSAI := aList1[nLinha,10]
    ZPE->ZPE_SLDFIM := aList1[nLinha,11]
    ZPE->ZPE_STATUS := '0'
Else 
    Dbgoto(aList1[nLinha,16])
    Reclock("ZPE",.F.)
    ZPE->ZPE_CONTA1 := aList1[nLinha,12]
    ZPE->ZPE_CONTA2 := aList1[nLinha,13]
    ZPE->ZPE_CONTA3 := aList1[nLinha,14]
    ZPE->ZPE_RESULT := aList1[nLinha,15]
    ZPE->ZPE_STATUS := cvaltochar(nContag)

    If nContag == 1
        ZPE->ZPE_DTCNT1 := ddatabase
        ZPE->ZPE_HRCNT1 := cvaltochar(time())
    ElseIf nContag == 2
        ZPE->ZPE_DTCNT2 := ddatabase
        ZPE->ZPE_HRCNT2 := cvaltochar(time())
    Else 
        ZPE->ZPE_DTCNT3 := ddatabase
        ZPE->ZPE_HRCNT3 := cvaltochar(time())
    EndIf 
EndIf 

ZPE->(Msunlock())

RestArea(aArea)

Return


/*/{Protheus.doc} GravPrInv
description)
    @type  Static Function
    @author user
    @since 20/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

Static Function GeraPlan()

Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local cArqXls 	:= "Contagem"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}
Local cInterno  :=  'Contagem'

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet(cInterno) 
oExcel:AddTable (cInterno,cInterno)

For nX := 1 to len(aHeader[1])
    oExcel:AddColumn(cInterno,cInterno,aHeader[1,nX],1,1)
Next nX


For nX := 1 to len(aAuxExc)
    aAux := {}
    For nY := 1 to len(aHeader[1])
        Aadd(aAux,aAuxExc[nX,nY])
    Next nY

    oExcel:AddRow(cInterno,cInterno,aAux)
Next nX


oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
oExcelApp:SetVisible(.T.)        
oExcelApp:Destroy()

	
    
Return(cDir+cArqXls)
