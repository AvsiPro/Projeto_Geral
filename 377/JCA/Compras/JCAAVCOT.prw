#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �         � Autor �                       � Data �           ���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �                                               ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function JCAAVCOT

Private oDlg1,oGrp1,oGrp2,oBtn1,oGrp3,oList1,oList2,oList3
Private aList1  :=  {}
Private aList2  :=  {}
Private aList2B :=  {}
Private aList3  :=  {}
Private aList3B :=  {}
Private aProds  :=  {}

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

Aadd(aList2,{'','','','','','','','','','','','',.f.})

OrcAtu()
OrcAnt()
Tela()

Return

/*/{Protheus.doc} Tela
    (long_description)
    @type  Static Function
    @author user
    @since 09/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Tela()

oDlg1      := MSDialog():New( 092,232,731,1375,"Avaliar cota��es",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,004,104,560,"Atual",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,100,556},,, oGrp1 ) 
    oList1    := TCBrowse():New(012,008,545,090,, {'Fornecedor','Cota��o','Item','Produto','Descri��o','Qtd','Valor Unit.','Valor Total'},;
                                        {70,30,20,30,50,30,30,30},;
                                        oGrp1,,,,{|| FHelp(oList1:nAt)},{|| /*editped(oList1:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],; 
                        aList1[oList1:nAt,02],;
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04],;
                        aList1[oList1:nAt,05],;
                        aList1[oList1:nAt,06],;
                        aList1[oList1:nAt,07],;
                        aList1[oList1:nAt,08]}}

oGrp2      := TGroup():New( 108,004,212,560,"Anteriores Vencedoras",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{116,008,208,556},,, oGrp2 ) 
//cotacao item produto quant vlruni vlrtot fornece loja condpg frete filent dtentr flagwin
    oList2    := TCBrowse():New(116,008,545,090,, {'Cota��o','Item','Produto','Qtd','Valor Unit.','Valor Total','Fornecedor','CondPagto','Frete','Filial','Entrega'},;
                                        {70,30,20,30,50,30,30,30},;
                                        oGrp2,,,,{||/* FHelp(oList2:nAt) */},{|| /*editped(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList2:SetArray(aList2)
    oList2:bLine := {||{aList2[oList2:nAt,01],; 
                        aList2[oList2:nAt,02],;
                        aList2[oList2:nAt,03],;
                        aList2[oList2:nAt,04],;
                        aList2[oList2:nAt,05],;
                        aList2[oList2:nAt,06],;
                        aList2[oList2:nAt,07],;
                        aList2[oList2:nAt,08],;
                        aList2[oList2:nAt,09],;
                        aList2[oList2:nAt,10],;
                        aList2[oList2:nAt,11]}}

oGrp3      := TGroup():New( 212,004,296,560,"Atualiza��es no item da Proposta",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw3      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{220,008,292,556},,, oGrp3 ) 
    //oList3    := TCBrowse():New(220,008,545,070,, {'Cota��o','Item','Produto','Qtd','Valor Unit.','Valor Total','Fornecedor','CondPagto','Frete','Filial','Entrega'},;
    //                                    {70,30,20,30,50,30,30,30},;
    //                                    oGrp3,,,,{|| FHelp(oList3:nAt)},{|| /*editped(oList3:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    /*oList3:SetArray(aList3)
    oList3:bLine := {||{aList3[oList3:nAt,01],; 
                        aList3[oList3:nAt,02],;
                        aList3[oList3:nAt,03],;
                        aList3[oList3:nAt,04],;
                        aList3[oList3:nAt,05],;
                        aList3[oList3:nAt,06],;
                        aList3[oList3:nAt,07],;
                        aList3[oList3:nAt,08],;
                        aList3[oList3:nAt,09],;
                        aList3[oList3:nAt,10],;
                        aList3[oList3:nAt,11]}}*/

    oList3    := TCBrowse():New(220,008,545,070,, {'Cota��o','Item','Usuario','Data','Hora','Altera��o'},;
                                        {50,40,50,40,40,150},;
                                        oGrp3,,,,{|| /*FHelp(oList3:nAt)*/},{|| /*editped(oList3:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList3:SetArray(aList3)
    oList3:bLine := {||{aList3[oList3:nAt,01],; 
                        aList3[oList3:nAt,02],;
                        aList3[oList3:nAt,03],;
                        aList3[oList3:nAt,04],; 
                        aList3[oList3:nAt,05],;
                        aList3[oList3:nAt,06]}}

oBtn1      := TButton():New( 300,256,"Sair",oDlg1,{||oDlg1:end()},037,010,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return

/*/{Protheus.doc} OrcAtu
    (long_description)
    @type  Static Function
    @author user
    @since 09/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function OrcAtu()

Local cQuery

cQuery := "SELECT C8_FORNOME,C8_NUM,C8_ITEM,C8_PRODUTO,B1_DESC,C8_QUANT,C8_PRECO,C8_TOTAL,C8_FORNECE,C8_LOJA"
cQuery += " FROM "+RetSQLName("SC8")+" C8"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=C8_PRODUTO AND B1.D_E_L_E_T_=' '"
cQuery += " WHERE C8.D_E_L_E_T_=' ' AND C8_NUM='"+SC8->C8_NUM+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF() 
    If Ascan(aProds,{|x| Alltrim(x) == Alltrim(TRB->C8_PRODUTO)}) == 0
        Aadd(aProds,TRB->C8_PRODUTO)
    ENDIF

    Aadd(aList1,{ TRB->C8_FORNOME,;
                  TRB->C8_NUM,;
                  TRB->C8_ITEM,;
                  TRB->C8_PRODUTO,;
                  TRB->B1_DESC,;
                  TRB->C8_QUANT,;
                  TRB->C8_PRECO,;
                  TRB->C8_TOTAL,;
                  TRB->C8_FORNECE,;
                  TRB->C8_LOJA})
    Dbskip()
EndDo 

cQuery := "SELECT ZL_DOCTO,ZL_ITEM,ZL_USUARIO,ZL_DATA,ZL_HORA,ZL_OBS,ZL_CLIENTE,ZL_LOJA"
cQuery += " FROM "+RetSQLName("SZL")+" ZL"
cQuery += " WHERE ZL.D_E_L_E_T_=' '"
cQuery += " AND ZL_FILIAL='"+xFilial("SZL")+"' AND ZL_DOCTO='"+SC8->C8_NUM+"' AND ZL_TABELA='SC8'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF() 
    Aadd(aList3B,{  TRB->ZL_DOCTO,;
                    TRB->ZL_ITEM,;
                    TRB->ZL_USUARIO,;
                    stod(TRB->ZL_DATA),;
                    TRB->ZL_HORA,;
                    TRB->ZL_OBS,;
                    TRB->ZL_CLIENTE,;
                    TRB->ZL_LOJA })
    Dbskip()
EndDo 

If len(aList3B) < 1
    Aadd(aList3B,{'','','','','','','','','','','','',''})
EndIf 

Return

/*/{Protheus.doc} OrcAnt()
    (long_description)
    @type  Static Function
    @author user
    @since 09/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function OrcAnt()

Local cQuery 
Local nCont  := 1
Local cTirar := ''
Local cBarra := ''

For nCont := 1 to len(aProds)
    cQuery := "SELECT ZPS_COTACA,ZPS_ITEMCO,ZPS_PRODUT,ZPS_QUANT,ZPS_VLRUNI,"
    cQuery += " ZPS_VLRTOT,ZPS_FORNEC,ZPS_LOJA,ZPS_CONDPG,ZPS_FRETE,ZPS_FILENT,"
    cQuery += " ZPS_DTENTR,ZPS_FLAGWI"
    cQuery += " FROM "+RetSQLName("ZPS")
    cQuery += " WHERE ZPS_COTACA IN(SELECT DISTINCT ZPS_COTACA"
    cQuery += "      FROM "+RetSQLName("ZPS")+" WHERE ZPS_PRODUT='"+aProds[nCont]+"' AND D_E_L_E_T_=' ')"
    cQuery += " AND D_E_L_E_T_=' '"

    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF

    MemoWrite("CONFATC01.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB") 
//cotacao item produto quant vlruni vlrtot fornece loja condpg frete filent dtentr flagwin
/*ZPS_COTACA,ZPS_ITEMCO,ZPS_PRODUT,ZPS_QUANT,ZPS_VLRUNI
        ZPS_VLRTOT,ZPS_FORNEC,ZPS_LOJA,ZPS_CONDPG,ZPS_FRETE,ZPS_FILENT
        ZPS_DTENTR,ZPS_FLAGWI*/
//'Cota��o','Item','Produto','Qtd','Valor Unit.','Valor Total','Fornecedor','CondPagto','Entrega'
    While !EOF()
        If !TRB->ZPS_COTACA $ cTirar
            cTirar += cBarra + TRB->ZPS_COTACA
            cBarra := '/'
        EndIF
        
        If TRB->ZPS_FLAGWI == "T"
            Aadd(aList2B,{  TRB->ZPS_COTACA,;
                            TRB->ZPS_ITEMCO,;
                            TRB->ZPS_PRODUT,;
                            TRB->ZPS_QUANT,;
                            TRB->ZPS_VLRUNI,;
                            TRB->ZPS_VLRTOT,;
                            Posicione("SA2",1,xFilial("SA2")+TRB->ZPS_FORNEC+TRB->ZPS_LOJA,"A2_NOME"),;
                            TRB->ZPS_CONDPG,;
                            TRB->ZPS_FRETE,;
                            TRB->ZPS_FILENT,;
                            stod(TRB->ZPS_DTENTR),;
                            TRB->ZPS_FLAGWI})
        /*Else 
            Aadd(aList3B,{  TRB->ZPS_COTACA,;
                            TRB->ZPS_ITEMCO,;
                            TRB->ZPS_PRODUT,;
                            TRB->ZPS_QUANT,;
                            TRB->ZPS_VLRUNI,;
                            TRB->ZPS_VLRTOT,;
                            Posicione("SA2",1,xFilial("SA2")+TRB->ZPS_FORNEC+TRB->ZPS_LOJA,"A2_NOME"),;
                            TRB->ZPS_CONDPG,;
                            TRB->ZPS_FRETE,;
                            TRB->ZPS_FILENT,;
                            stod(TRB->ZPS_DTENTR),;
                            TRB->ZPS_FLAGWI})*/
        EndIf
        Dbskip()
    EndDo
Next nCont 

If len(aList2B) < 1
    Aadd(aList2B,{'','','','','','','','','','','','',''})
EndIf 



Return

/*/{Protheus.doc} FHelp
nLinhadescription)
    @type  Static Function
    @author user
    @since 09/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FHelp(nLinha)

Local nCont 

aList2 := {}
aList3 := {}

For nCont := 1 to len(aList2B)
    nPos := Ascan(aList2,{|x| x[1]+x[2]+x[3] == aList2B[nCont,01]+aList2B[nCont,02]+aList2B[nCont,03]})
    If Alltrim(aList2B[nCont,03]) == Alltrim(aList1[nLinha,04]) .And. nPos == 0
        Aadd(aList2,aList2B[nCont])
    EndIf
Next nCont

If len(aList2) < 1
    Aadd(aList2,{'','','','','','','','','','','','',''})
EndIf 

oList2:SetArray(aList2)
oList2:bLine := {||{aList2[oList2:nAt,01],; 
                    aList2[oList2:nAt,02],;
                    aList2[oList2:nAt,03],;
                    aList2[oList2:nAt,04],;
                    aList2[oList2:nAt,05],;
                    aList2[oList2:nAt,06],;
                    aList2[oList2:nAt,07],;
                    aList2[oList2:nAt,08],;
                    aList2[oList2:nAt,09],;
                    aList2[oList2:nAt,10],;
                    aList2[oList2:nAt,11]}}

/*
For nCont := 1 to len(aList3B)
    nPos := Ascan(aList3,{|x| x[1]+x[2]+x[3]+x[7] == aList3B[nCont,01]+aList3B[nCont,02]+aList3B[nCont,03]+aList3B[nCont,07]})
    If Alltrim(aList3B[nCont,03]) == Alltrim(aList1[nLinha,04]) .And. nPos == 0
        Aadd(aList3,aList3B[nCont])
    EndIf
Next nCont
*/

For nCont := 1 to len(aList3B)
    If Alltrim(aList3B[nCont,01]) == Alltrim(aList1[nLinha,02]) .And. Alltrim(aList3B[nCont,02]) == Alltrim(aList1[nLinha,03]) .AND. Alltrim(aList3B[nCont,07]) == Alltrim(aList1[nLinha,09]) .AND. Alltrim(aList3B[nCont,08]) == Alltrim(aList1[nLinha,10]) 
        Aadd(aList3,aList3B[nCont])
    EndIf
Next nCont

If len(aList3) < 1
    Aadd(aList3,{'','','','','','','','','','','','',''})
EndIf 

oList3:SetArray(aList3)
oList3:bLine := {||{aList3[oList3:nAt,01],; 
                    aList3[oList3:nAt,02],;
                    aList3[oList3:nAt,03],;
                    aList3[oList3:nAt,04],; 
                    aList3[oList3:nAt,05],;
                    aList3[oList3:nAt,06]}}

oList2:refresh()
oList3:refresh()
oDlg1:refresh()

Return
