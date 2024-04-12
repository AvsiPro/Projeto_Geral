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
                                                    'Contagem 1','Contagem 2','Contagem 3','Divergência','Diverg. Valor','% Diverg.'},;
                                        {10,20,30,45,80,30,35,30,30,30,30,30,30,30,30,30,30},;
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
                            aList1[oList1:nAt,15],;
                            aList1[oList1:nAt,18],;
                            aList1[oList1:nAt,19]}}

        //oBtn1      := TButton():New( 332,664,"oBtn1",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
        //Botões diversos
        oMenu := TMenu():New(0,0,0,0,.T.)
        // Adiciona itens no Menu
        oTMenuIte1 := TMenuItem():New(oDlg1,"Novo",,,,{|| _novoinv()},,,,,,,,,.T.)
        oTMenuIte2 := TMenuItem():New(oDlg1,"Digitar Cotagens",,,,{|| Processa({||_buscainv(),"Aguarde"})} ,,,,,,,,,.T.)
        oTMenuIte3 := TMenuItem():New(oDlg1,"Impressões",,,,{|| Processa({||imprexc(),"Aguarde"}) } ,,,,,,,,,.T.)
        oTMenuIte4 := TMenuItem():New(oDlg1,"Importar Contagens",,,,{|| Processa({|| validPla(),"Aguarde"})} ,,,,,,,,,.T.)
        oTMenuIte5 := TMenuItem():New(oDlg1,"Gravar",,,,{|| Processa({||GravCont(),"Aguarde"}) } ,,,,,,,,,.T.)
        oTMenuIte6 := TMenuItem():New(oDlg1,"Processar",,,,{|| Processa({|| gerarB7(),"Aguarde"})} ,,,,,,,,,.T.)
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

If aList1[nLinha,17] == 'F'
    Return 
EndIf 

IF nPosCol < 3
    If nContag <> 4
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
    EndIf 
Else 
    //If nPosCol >= 12 .And. nPosCol <= 14
    If nContag <> 4
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
    EndIf
EndIf 

oList1:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} GravCont
    (long_description)
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GravCont()

Local nCont 

If nContag == 4 .Or. aList1[oList1:nAt,17] == "F"
    Return 
endIf 

If len(aList1) > 0 
    For nCont := 1 to len(aList1)
        If aList1[nCont,1]
            Processa({||GravPrInv(nCont)}, "Aguarde")
        EndIf 
    Next nCont 

    MsgAlert("Gravação finalizada")
EndIf
    
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

If aList1[oList1:nAt,17] == "F"
    Return 
EndIf 

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
        Processa({|| GeraConf()},"Aguarde")
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
aAdd(aPergs ,{2,"Contagem"	,"", {"1=Contagem 1","2=Contagem 2","3=Contagem 3","4=Conferência"},50,'',.T.})

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
            SB1.B1_FABRIC,
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
            SB1.B1_FABRIC,
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
                SB1.B1_FABRIC,
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
        cPrat := Posicione("SBZ",1,xFilial("SBZ")+(cAliasTop)->PRODUTO,"BZ_XLOCALI")
        Aadd(aList1,{ .T.,;
                    (cAliasTop)->ARMAZEM,;
                    cPrat,;
                    (cAliasTop)->PRODUTO,;
                    (cAliasTop)->B1_DESC,;
                    alltrim(Posicione("ZPM",1,xFilial("ZPM")+(cAliasTop)->B1_ZMARCA,"ZPM_DESC")),;
                    (cAliasTop)->B1_FABRIC,;
                    aSalAtu[1],;
                    nQtd1,;
                    nQtd2,;
                    aSalAtu[1]+nQtd1-nQtd2,;
                    0,;
                    0,;
                    0,;
                    0,;
                    0,;
                    '',;
                    0,;
                    0})
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
            cPrat := Posicione("SBZ",1,xFilial("SBZ")+(cAliasTop)->PRODUTO,"BZ_XLOCALI")
        
            Aadd(aList1,{ .T.,;
                            cLocIn,;
                            cPrat,;
                            TRB->B1_COD,;
                            TRB->B1_DESC,;
                            alltrim(TRB->ZPM_DESC),;
                            TRB->B1_FABRIC,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            0,;
                            '',;
                            0,;
                            0})
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
                    aList1[oList1:nAt,15],;
                    aList1[oList1:nAt,18],;
                    aList1[oList1:nAt,19]}}

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

cQuery := "SELECT ZPE.R_E_C_N_O_ AS RECZPE,B1_ZMARCA,ZPM_DESC,B1_DESC,B1_FABRIC,ZPE.* "
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
    If val(TRB->ZPE_STATUS)+1 <> nContag .And. val(TRB->ZPE_STATUS) <> 3 .And. nContag <> 4
        MsgAlert("Número da digitação informada é inválido, a contagem para este inventário atual é a numero "+cvaltochar(val(TRB->ZPE_STATUS)+1))
        exit
    EndIf 

    cCodUsr := TRB->ZPE_CODUSU
    cPrat := Posicione("SBZ",1,xFilial("SBZ")+TRB->ZPE_PRODUT,"BZ_XLOCALI")

    cVlrCm := Posicione("SB2",1,xFilial("SB2")+TRB->ZPE_PRODUT+TRB->ZPE_LOCAL,"B2_CM1")

    Aadd(aList1,{   .T.,;
                    TRB->ZPE_LOCAL,;
                    cPrat,;
                    TRB->ZPE_PRODUT,;
                    TRB->B1_DESC,;
                    TRB->ZPM_DESC,;
                    TRB->B1_FABRIC,;
                    TRB->ZPE_SLDINI,;
                    TRB->ZPE_QTDENT,;
                    TRB->ZPE_QTDSAI,;
                    TRB->ZPE_SLDFIM,;
                    TRB->ZPE_CONTA1,;
                    TRB->ZPE_CONTA2,;
                    TRB->ZPE_CONTA3,;
                    TRB->ZPE_RESULT,;
                    TRB->RECZPE,;
                    TRB->ZPE_STATUS,;
                    cVlrCm*TRB->ZPE_RESULT,;
                    If(nContag>3,3,(TRB->ZPE_RESULT * &('TRB->ZPE_CONTA'+cvaltochar(nContag)))/100)})
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
                    aList1[oList1:nAt,15],;
                    Transform(aList1[oList1:nAt,18],"@E 999,999.99"),;
                    aList1[oList1:nAt,19]}}

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

If aList1[nLinha,17] == 'F'
    Return 
EndIf 

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


/*/{Protheus.doc} GeraPlan
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

/*/{Protheus.doc} GeraConf
    Gera relatório de conferência de inventário.
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraConf()

Local oReport

Private nTamCod    := 500

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

oReport:= ReportDef()
oReport:PrintDialog()

return
/*/{Protheus.doc} GeraConf
    Gera relatório de conferência de inventário.
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static function ReportDef()

Local oReport
Local oSection1
Local cPicD1Qt     := PesqPict("SD1","D1_QUANT" ,18)
Local cTamD1Qt     := TamSX3( 'D1_QUANT' )[1]
Local cPicD1Cust   := PesqPict("SD1","D1_CUSTO",18)
Local cTamD1Cust   := TamSX3( 'D1_CUSTO' )[1]
Local cPicD2Qt     := PesqPict("SD2","D2_QUANT" ,18)
Local cTamD2Qt     := TamSX3( 'D2_QUANT' )[1]
Local cPicB2Cust   := PesqPict("SB2","B2_CM1",18)
Local cTamB2Cust   := TamSX3( 'B2_CM1' )[1]


oReport:= TReport():New("JESTM002","Conferência","", {|oReport| ReportPrint(oReport)},"Conferência de Inventário")
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)  

oSection0 := TRSection():New(oReport,'Conferência',{"SD1","SD2","SD3"}) //"Movimentação dos Produtos"
oSection0 :SetTotalInLine(.F.)
oSection0 :SetReadOnly()
oSection0 :SetLineStyle()

TRCell():New(oSection0, "cLocal"    	, " ", 'Local'             	, "@!"       , 2   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "cPrateleira"   , " ", 'Prateleira'			, /*Picture*/, 2      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "cProduto"   	, " ", 'Material'			, /*Picture*/, 6    , /*lPixel*/, )
TRCell():New(oSection0, "cDescric" 		,"SB1",'Descrição'          , /*Picture*/, 25         , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "cMarca"   		, " ", 'Marca'              , "@!"       , 10   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "cCodOri"  		, " ", 'Código'+CRLF+'Original'	, /*Picture*/, 10             , /*lPixel*/, )
TRCell():New(oSection0, "nENTQtd"  		, " ", 'Qtde'+CRLF+'Inicial', cPicD1Qt   , 5      , /*lPixel*/, /*{|| code-block de impressao }*/)
//TRCell():New(oSection0, "cTraco2"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
TRCell():New(oSection0, "nENTCus"  		, " ", 'Qtde'+CRLF+'Entradas', cPicD1Cust , 5    , /*lPixel*/, /*{|| code-block de impressao }*/)
//TRCell():New(oSection0, "cTraco3"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
TRCell():New(oSection0, "nSAIQtd"  		, " ", 'Qtde'+CRLF+'Saídas', cPicB2Cust , 5    , /*lPixel*/, /*{|| code-block de impressao }*/)
//TRCell():New(oSection0, "cTraco4"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
TRCell():New(oSection0, "nSALDQtd" 		, " ", 'Qtde'+CRLF+'Atual' , cPicD2Qt   , 5      , /*lPixel*/, /*{|| code-block de impressao }*/)

TRCell():New(oSection0, "nCont1" 		, " ", 'Cont.1' , cPicD2Qt   , 5      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "nCont2" 		, " ", 'Cont.2' , cPicD2Qt   , 5      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "nCont3" 		, " ", 'Cont.3' , cPicD2Qt   , 5      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection0, "nDiverg" 		, " ", 'Divergencia', cPicD2Qt   , 5      , /*lPixel*/, /*{|| code-block de impressao }*/)

oSection1 := TRSection():New(oSection0,'Conferência',{"SD1","SD2","SD3"}) //"Movimentação dos Produtos"
oSection1 :SetTotalInLine(.F.)
oSection1 :SetReadOnly()
oSection1 :SetLineStyle()

//TRCell():New(oSection1, "cTraco5"  		, " ", ""        			, /*Picture*/, 1             , /*lPixel*/, )
//TRCell():New(oSection1, "cTraco5"  		, " ", ""        			, /*Picture*/, 1             , /*lPixel*/, )
//TRCell():New(oSection1, "cTraco5"  		, " ", ""        			, /*Picture*/, 1             , /*lPixel*/, )
//TRCell():New(oSection1, "cTraco5"  		, " ", ""        			, /*Picture*/, 1             , /*lPixel*/, )
//TRCell():New(oSection1, "cTraco5"  		, " ", ""        			, /*Picture*/, 1             , /*lPixel*/, )
//TRCell():New(oSection1, "cTraco2"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
//TRCell():New(oSection1, "cTraco3"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
//TRCell():New(oSection1, "cTraco4"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })

TRCell():New(oSection1, "cLocal"    	, " ", ''       	, "@!"       , 5   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "cPrateleira"   , " ", ''			, /*Picture*/, 10      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "cProduto"   	, " ", ''			, /*Picture*/, 15    , /*lPixel*/, )
TRCell():New(oSection1, "cDescric" 		,"SB1",''           , /*Picture*/, 35         , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "cMarca"   		, " ", ''           , "@!"       , 15   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "cCodOri"  		, " ", ''	        , /*Picture*/, 17             , /*lPixel*/, )
TRCell():New(oSection1, "nENTQtd"  		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nENTCus"  		, " ", ''           , cPicD2Qt   , 11    , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nSAIQtd"  		, " ", ''           , cPicD2Qt   , 11    , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nSALDQtd" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nCont1" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nCont2" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nCont3" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection1, "nDiverg" 		, " ", ''           , cPicD2Qt   , 11      , /*lPixel*/, /*{|| code-block de impressao }*/)

oSection1:SetNoFilter("SD1")
oSection1:SetNoFilter("SD2")
oSection1:SetNoFilter("SD3")

Return(oReport)
/*/{Protheus.doc} GeraConf
    Gera relatório de conferência de inventário.
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
static function ReportPrint(oReport)

Local nSldDia

Local oSection0 := oReport:Section(1)
Local oSection1 := oReport:Section(1):Section(1)


oSection0:Init()
oSection1:Init()

oSection0:PrintLine()

For nSldDia := 1 to len(aList1)
    oSection1:Cell("cLocal"):SetValue(aList1[nSldDia,02])
    oSection1:Cell("cPrateleira"):SetValue(Avkey(aList1[nSldDia,03],"B1_COD")) 
    oSection1:Cell("cProduto"):SetValue(aList1[nSldDia,04])
    oSection1:Cell("cDescric"):SetValue(aList1[nSldDia,05])
    oSection1:Cell("cMarca"):SetValue(aList1[nSldDia,06])
    oSection1:Cell("cCodOri"):SetValue(aList1[nSldDia,07])
    oSection1:Cell("nENTQtd"):SetValue(aList1[nSldDia,08])
    oSection1:Cell("nENTCus"):SetValue(aList1[nSldDia,09])
    oSection1:Cell("nSAIQtd"):SetValue(aList1[nSldDia,10])
    oSection1:Cell("nSALDQtd"):SetValue(aList1[nSldDia,11])
    oSection1:Cell("nCont1"):SetValue(aList1[nSldDia,12])
    oSection1:Cell("nCont2"):SetValue(aList1[nSldDia,13])
    oSection1:Cell("nCont3"):SetValue(aList1[nSldDia,14])
    oSection1:Cell("nDiverg"):SetValue(aList1[nSldDia,15])

    oSection1:PrintLine()
Next

//oReport:EndPage()

Return 

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 08/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function validPla()

Local cArqAux 
Local aAux      :=  {}
Local aRet      :=  {}
Local nCont     :=  0
Local nTamLin   :=  0
Local aPergs    := {}
Local aRetP     := {}
Local nY        :=  0
Local lOk       := .T.

If nContag == 4 
    Return 
Endif 

nContag   :=  0

cArqAux := cGetFile( '*.csv|*.csv',; //[ cMascara], 
                         'Selecao de Arquivos',;                  //[ cTitulo], 
                         0,;                                      //[ nMascpadrao], 
                         'C:\',;                            //[ cDirinicial], 
                         .F.,;                                    //[ lSalvar], 
                         GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                         .T.)   
                                                           //[ lArvore] 
oFile := FwFileReader():New(cArqAux)

If (oFile:Open())

    If Empty(cCodInv)
        aAdd(aPergs ,{1,"Código do inventário:"	,space(TamSx3("ZPE_CODIGO")[1]),"@!",".T.","ZPE",".T.",70,.F.})

        If ParamBox(aPergs ,"Filtrar por",@aRetP)    
        
            cCodInv := aRetP[1]
            
            DbSelectArea("ZPE")
            dbSetOrder(1)
            If !Dbseek(xFilial("ZPE")+cCodInv)
                MsgAlert("Inventário inexistente, verifique!!!")
                Return 
            endIf 

        EndIf 
    endIf 

    aAux := oFile:GetAllLines()
     
    For nCont := 1 to len(aAux)
        Aadd(aRet,Separa(aAux[nCont],";"))
        If nCont == 1
            nTamLin := len(aRet[1])
        Else 
            If len(aRet[len(aRet)]) <> nTamLin
                aRet := {}
                Return
            EndIf
        EndIf
    Next nCont

    nY := Ascan(aret,{|x| x[1] == "Local"})

    DBSelectArea("ZPE")
    dbSetOrder(2)
    For nCont := nY+1 to len(aRet)
        If !Dbseek(xFilial("ZPE")+cCodInv+aRet[nCont,03])
            MsgAlert("Erro na linha "+cvaltochar(nCont)+" - Produto não se encontra no inventário")
            lOk := .F.
            exit 
        EndIf 
        
    Next nCont
    
    If lOk 
        DBSelectArea("ZPE")
        dbSetOrder(2)
        For nCont := nY+1 to len(aRet)
            If Dbseek(xFilial("ZPE")+cCodInv+aRet[nCont,03])
                nContag := 0

                Reclock("ZPE",.F.) 
                ZPE->ZPE_CONTA1 := val(aRet[nCont,07])
                ZPE->ZPE_CONTA2 := val(aRet[nCont,08])
                ZPE->ZPE_CONTA3 := val(aRet[nCont,09])
                
                If !Empty(aRet[nCont,07])
                    ZPE->ZPE_DTCNT1 := ddatabase
                    ZPE->ZPE_HRCNT1 := cvaltochar(time())
                    nContag++
                EndIF 

                If !Empty(aRet[nCont,08])
                    ZPE->ZPE_DTCNT2 := ddatabase
                    ZPE->ZPE_HRCNT2 := cvaltochar(time())
                    nContag++
                EndIF 

                If !Empty(aRet[nCont,09])
                    ZPE->ZPE_DTCNT3 := ddatabase
                    ZPE->ZPE_HRCNT3 := cvaltochar(time())
                    nContag++
                EndIF 

                ZPE->ZPE_STATUS := cvaltochar(nContag)

                ZPE->(Msunlock())
            EndIf

            nPosL1 := Ascan(aList1,{|x| Alltrim(x[4]) == Alltrim(aRet[nCont,03])})

            IF nPosL1 > 0
                aList1[nPosL1,12] := val(aRet[nCont,07])
                aList1[nPosL1,13] := val(aRet[nCont,08])
                aList1[nPosL1,14] := val(aRet[nCont,09])
                aList1[nPosL1,15] := If(nContag==1,val(aRet[nCont,07]),If(nContag==2,val(aRet[nCont,08]),val(aRet[nCont,09]))) - aList1[nPosL1,11]
            EndIf 

        Next nCont 
    EndIF 
    
    oList1:refresh()
    oDlg1:refresh()
    
Else 
    MsgAlert("Não foi possível abrir o arquivo selecionado!!!")
EndIf 

Return(aRet)

/*/{Protheus.doc} gerarB7
    (long_description)
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gerarB7()

Local aArea := GetArea()
Local lOk   := .T.
Local nCont 

PRIVATE lMsErroAuto := .F.

For nCont := 1 to len(aList1)
    If val(aList1[nCont,17]) < 3 .or. aList1[nCont,17] == 'F'
        lOk := .F.
        exit 
    EndIf 
Next nCont 

If !lOk 
    MsgAlert("Para processar o inventário, todos os itens devem conter a 3 contagens.")
    return
Else
    Begin Transaction
    For nCont := 1 to len(aList1)
        DbSelectArea("SB1")
        DbSetOrder(1)
        If DbSeek(xFilial("SB1")+aList1[nCont,04])  
        
            DbSelectArea("SB2")
            DbSetOrder(1)
            If !DbSeek(xFilial("SB2")+Avkey(Alltrim(aList1[nCont,04]),"B2_COD")+Avkey(aList1[nCont,02],"B2_LOCAL"))
                CriaSB2(aList1[nCont,04],aList1[nCont,02])
            EndIf

            aVetor := {;
                    {"B7_FILIAL" 	,xFilial("SB7")		        ,Nil},;
                    {"B7_COD"		,aList1[nCont,04]			,Nil},;
                    {"B7_DOC"		,cCodInv			        ,Nil},;
                    {"B7_QUANT"		,aList1[nCont,14]   		,Nil},;
                    {"B7_LOCAL"		,aList1[nCont,02]		    ,Nil},;
                    {"B7_CONTAGE"	,aList1[nCont,17]		    ,Nil},;
                    {"B7_ESCOLHA"	,'S'            		    ,Nil},;
                    {"B7_DATA"		,DDATABASE			        ,Nil} }

            lMsErroAuto	:=	.F.
        
            MSExecAuto({|x,y| mata270(x,y)},aVetor,.F.,3)
            
            If lMsErroAuto
                MostraErro()
                DisarmTransaction()
                lOk := .F.
                exit 
            Endif		
            
        EndIF	
    Next nCont 
    
    End Transaction

    If lOk 
        lOk := procinvt()

        If lOk 
            For nCont := 1 to len(aList1)
                aList1[nCont,17] := 'F'
                DbSelectArea("ZPE")
                DbGoto(aList1[nCont,16])
                Reclock("ZPE",.F.)
                ZPE->ZPE_STATUS := 'F'
                ZPE->ZPE_DATAB7 := ddatabase
                ZPE->ZPE_HORAB7 := cvaltochar(time())
                ZPE->(Msunlock())
            Next nCont 
        EndIf 

    EndIf 
EndIf 

RestArea(aarea)


Return


/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function procinvt()
    
Local lOk      := .T.
Private lMsErroAuto := .F.


DbSelectArea("SB7")
DbSetOrder(3)

If !SB7->(MsSeek(xFilial("SB7")+cCodInv))
    lOk := .F.  
    ConOut(OemToAnsi("Cadastrar inventário: "+cCodInv))
EndIf

If lOk
    SB7->(MsSeek(xFilial("SB7")+cCodInv))

    While !EOF() .And. alltrim(SB7->B7_DOC) == alltrim(cCodInv)
        MSExecAuto({|x,y,z| mata340(x,y,z)}, .T., cCodInv, .T.)               
        
        If lMsErroAuto
            lOk := .F.
            MostraErro()        
        EndIf    

        dBSKIP()
    EndDo    
    
        
ENDIF

Return(lOk)
