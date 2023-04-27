#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ROBRFT05  ³ Autor ³ Alexandre Venancio  ³  Data 21/03/2023 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Ranking de Vendas			                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ROBRFT05

LOCAL aPergs     :=    {}
LOCAL aRet       :=    {}      
LOCAL cCliD      :=    space(9)
LOCAL cCliA      :=    space(9)
LOCAL dDtD       :=    ctod(" / / ")
LOCAL dDtA       :=    ctod(" / / ")
Local cBanD      :=    space(6)
Local cBanA      :=    space(6)
Local cMarD      :=    space(2)
Local cMarA      :=    space(2)
Local cEstD      :=    space(2)
Local cEstA      :=    space(2)
Local cMunD      :=    space(60)
LOCAL cDir        
Local aTipo      :=    {'1=Produto','2=Cliente','3=Ambos'}

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf	

aAdd(aPergs ,{1,"Cliente de?",cCliD,"","","SA1","",050,.F.})
aAdd(aPergs ,{1,"Cliente ate?",cCliA,"","","SA1","",050,.F.})    
aAdd(aPergs ,{1,"Periodo de?",dDtD,"","","","",040,.T.})
aAdd(aPergs ,{1,"Periodo ate?",dDtA,"","","","",040,.T.})    
aAdd(aPergs ,{1,"Bandeira de?",cBanD,"","","Z01","",050,.F.})
aAdd(aPergs ,{1,"Bandeira ate?",cBanA,"","","Z01","",050,.F.})   
aAdd(aPergs ,{1,"Marca de?",cMarD,"","","Z03","",050,.F.})
aAdd(aPergs ,{1,"Marca ate?",cMarA,"","","Z03","",050,.F.})   
aAdd(aPergs ,{1,"Estado de?",cEstD,"","","12","",050,.F.})
aAdd(aPergs ,{1,"Estado ate?",cEstA,"","","12","",050,.F.})   
aAdd(aPergs ,{1,"Muncipio?",cMunD,"","","","",050,.F.})
aAdd(aPergs ,{2,"Relatorio por?"	,"",aTipo,080,'',.T.})

IF ParamBox(aPergs ,"Local para salvar o arquivo",@aRet)
    cDir         :=    cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
    
    IF Empty(cDir)
        RETURN
    ENDIF
Else 
    Return
EndIf 

If aRet[12] == "1"
    Processa({|| relprod(cDir,aRet)},"Aguarde")
ElseIf aRet[12] == "2"
    Processa({|| relcli(cDir,aRet)},"Aguarde")
Else 
    Processa({|| relcli(cDir,aRet)},"Aguarde")
    Processa({|| relprod(cDir,aRet)},"Aguarde")
EndIF 

Return 

/*/{Protheus.doc} relcli
    (long_description)
    @type  Static Function
    @author user
    @since 21/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function relcli(cDir,aRet)

Local cQuery 	:= ""
Local aAux2     :=  {}
Local aAux3     :=  {}
Local nPos1
Local nPos2
Local aMeses    :=  {}
Local nQtdM     :=  DateDiffMonth(aRet[3],aRet[4])
Local dPrim     :=  aRet[3]
Local nX 

For nX := 1 to nQtdM+1
    Aadd(aMeses,{month(dPrim),0})
    dPrim := MonthSum(dPrim,1)
Next nX 


cQuery := "SELECT D2_FILIAL,A1_NOME,A1_CGC,A1_EST,A1_MUN,Z01_DESBAN,D2_COD,B1_DESC,BM_XMODELO,Z03_DESGRI,"
cQuery += " MONTH(D2_EMISSAO) AS MESVND ,SUM(D2_QUANT) AS TOTAL"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA AND A1.D_E_L_E_T_=' '"

If !Empty(aRet[9]) .Or. !Empty(aRet[10])
    cQuery += " AND A1_EST BETWEEN '"+aRet[9]+"' AND '"+aRet[10]+"'"
EndIf 

If !Empty(aRet[11]) 
    cQuery += " AND A1_MUN LIKE '%"+Alltrim(upper(aRet[11]))+"%'"
EndIf 


cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SA1")+"' AND B1_COD=D2_COD AND B1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SBM")+" BM ON BM_FILIAL=B1_FILIAL AND BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' '"

If !Empty(aRet[7]) .Or. !Empty(aRet[8])
    cQuery += " INNER JOIN "+RetSQLName("Z03")+" Z3 ON Z03_FILIAL=BM_FILIAL AND Z03_CODGRI=BM_XMODELO AND Z3.D_E_L_E_T_=' '"
    cQuery += " AND Z03_CODGRI BETWEEN '"+aRet[7]+"' AND '"+aRet[8]+"'"
Else
    cQuery += " LEFT JOIN "+RetSQLName("Z03")+" Z3 ON Z03_FILIAL=BM_FILIAL AND Z03_CODGRI=BM_XMODELO AND Z3.D_E_L_E_T_=' '"
EndIf

If !Empty(aRet[5]) .Or. !Empty(aRet[6])
    cQuery += " INNER JOIN "+RetSQLName("Z01")+" Z1 ON Z01_FILIAL=A1_FILIAL AND Z01_CODBAN=A1_XBANDEI AND Z1.D_E_L_E_T_=' '"
    cQuery += " AND A1_XBANDEI BETWEEN '"+aRet[5]+"' AND '"+aRet[6]+"'"
Else
    cQuery += " LEFT JOIN "+RetSQLName("Z01")+" Z1 ON Z01_FILIAL=A1_FILIAL AND Z01_CODBAN=A1_XBANDEI AND Z1.D_E_L_E_T_=' '"
EndIf 

cQuery += " WHERE D2_FILIAL BETWEEN ' ' AND 'ZZZ'"

cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(aRet[3])+"' AND '"+DTOS(aRet[4])+"'"

cQuery += " AND D2.D_E_L_E_T_=' '"

If !Empty(aRet[1]) .Or. !Empty(aRet[2])
    cQuery += " AND D2_CLIENTE BETWEEN '"+aRet[1]+"' AND '"+aRet[2]+"'"
Else
    cQuery += " AND D2_CLIENTE BETWEEN ' ' AND 'ZZ'"
EndIf 

cQuery += " GROUP BY D2_FILIAL,A1_NOME,A1_CGC,A1_EST,A1_MUN,Z01_DESBAN,D2_COD,B1_DESC,BM_XMODELO,Z03_DESGRI,MONTH(D2_EMISSAO)"
cQuery += " ORDER BY D2_COD"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
    
    nPos1 := Ascan(aAux2,{|x| x[2]+x[8]+x[10] == TRB->A1_CGC+TRB->BM_XMODELO+TRB->D2_FILIAL})
    nPos2 := Ascan(aMeses,{|x| x[1] == TRB->MESVND})

    aMeses[nPos2,02] := TRB->TOTAL
    
    If nPos1 == 0
        aAux3 := {}
        Aadd(aAux3,TRB->A1_NOME) 
        Aadd(aAux3,TRB->A1_CGC)
        Aadd(aAux3,TRB->A1_EST)
        Aadd(aAux3,TRB->A1_MUN)
        Aadd(aAux3,TRB->Z01_DESBAN)
        Aadd(aAux3,TRB->D2_COD)
        Aadd(aAux3,TRB->B1_DESC)
        Aadd(aAux3,TRB->BM_XMODELO)
        Aadd(aAux3,TRB->Z03_DESGRI)
        Aadd(aAux3,TRB->D2_FILIAL)
        
        For nX := 1 to len(aMeses)
            Aadd(aAux3,{aMeses[nX,01],aMeses[nX,02]})
        Next nX

        Aadd(aAux2,aAux3)

       
    Else 
        aAux2[nPos1,nPos2+10,2] += TRB->TOTAL
    EndIf 
    
    aMeses[nPos2,02] := 0 

    Dbskip()
EndDo

GeraExcC(aAux2,{},cDir,aMeses)

Return

/*/{Protheus.doc} relprod
    (long_description)
    @type  Static Function
    @author user
    @since 21/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function relprod(cDir,aRet)
    
Local cQuery 	:= ""
Local aAux1     :=  {}
Local aAux2     :=  {}
Local aAux3     :=  {}
Local nPos1
Local nPos2
Local aMeses    :=  {}
Local nQtdM     :=  DateDiffMonth(aRet[3],aRet[4])
Local dPrim     :=  aRet[3]
Local nX 
Local aClassf   :=  {{'1','Venda'},{'2','Garantia'},{'3','Mostruario'},{'4','Armarinho'},{'5','Bon.Cliente'},{'6','Bon.MKT'},{'7','Bon.Gerencia'},{'P','Garantia-Portal'}}

For nX := 1 to nQtdM+1
    Aadd(aMeses,{month(dPrim),0})
    dPrim := MonthSum(dPrim,1)
Next nX 

cQuery := "SELECT D2_FILIAL,D2_COD,B1_DESC,C5_XCLASPV,MONTH(D2_EMISSAO) AS MESVND ,SUM(D2_QUANT) AS TOTAL"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='01' AND B1_COD=D2_COD AND B1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=D2_FILIAL AND C5_NUM=D2_PEDIDO AND C5.D_E_L_E_T_=' '"
cQuery += " WHERE D2_FILIAL BETWEEN ' ' AND 'ZZZ'"
cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(aRet[3])+"' AND '"+DTOS(aRet[4])+"'"
cQuery += " AND D2.D_E_L_E_T_=' '"
cQuery += " GROUP BY D2_FILIAL,D2_COD,B1_DESC,C5_XCLASPV,MONTH(D2_EMISSAO)"
cQuery += " ORDER BY D2_FILIAL,C5_XCLASPV,D2_COD"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
    nPosCf := Ascan(aClassf,{|x| x[1] == Alltrim(TRB->C5_XCLASPV)})

    nPos1 := Ascan(aAux1,{|x| x[1]+x[3]+x[4] == TRB->D2_COD+TRB->D2_FILIAL+If(nPosCf>0,aClassf[nPosCf,02],"Sem_Classificacao")})
    nPos2 := Ascan(aMeses,{|x| x[1] == TRB->MESVND})
    
    aMeses[nPos2,02] := TRB->TOTAL

    If nPos1 == 0
        
        aAux3 := {}

        Aadd(aAux3,TRB->D2_COD)
        Aadd(aAux3,TRB->B1_DESC)
        Aadd(aAux3,TRB->D2_FILIAL)
        Aadd(aAux3,If(nPosCf>0,aClassf[nPosCf,02],"Sem_Classificacao"))
        
        For nX := 1 to len(aMeses)
            Aadd(aAux3,{aMeses[nX,01],aMeses[nX,02]})
        Next nX

        Aadd(aAux1,aAux3)

    Else 
        aAux1[nPos1,nPos2+4,2] += TRB->TOTAL
    EndIf 
    
    aMeses[nPos2,02] := 0
    
    Dbskip()
ENDDO

GeraExcP(aAux1,aAux2,cDir,aMeses)

Return

/*/{Protheus.doc} GeraExc
    (long_description)
    @type  Static Function
    @author user
    @since 21/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraExcP(aAux1,aAux2,cDir,aMeses)

LOCAL oExcel     :=    FWMSEXCEL():New()
LOCAL cArqXls    :=    "Ranking_Produtos_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
LOCAL nX,nJ
Local aAux       :=     {}

oExcel:AddworkSheet("Produtos") 

oExcel:AddTable ("Produtos","Produtos")

oExcel:AddColumn("Produtos","Produtos","Codigo",1,1)
oExcel:AddColumn("Produtos","Produtos","Descricao",1,1)
oExcel:AddColumn("Produtos","Produtos","Filial",1,1)
oExcel:AddColumn("Produtos","Produtos","Tipo_Pedido",1,1)


For nX := 1 to len(aMeses)
    oExcel:AddColumn("Produtos","Produtos",strzero(aMeses[nX,01],2)+"/"+cvaltochar(year(ddatabase)),1,1)
Next nX 

FOR nX := 1 TO len(aAux1)
    aAux := {}

    Aadd(aAux,Alltrim(aAux1[nX,01]))
    Aadd(aAux,Alltrim(aAux1[nX,02]))
    Aadd(aAux,Alltrim(aAux1[nX,03]))
    Aadd(aAux,Alltrim(aAux1[nX,04]))

    For nJ := 1 to len(aMeses)
        Aadd(aAux,cvaltochar(aAux1[nX,nJ+4,02]))
    Next nJ

    oExcel:AddRow("Produtos","Produtos",aAux)
Next nX 

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:Destroy()

Return

/*/{Protheus.doc} GeraExcC
    (long_description)
    @type  Static Function
    @author user
    @since 21/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraExcC(aAux1,aAux2,cDir,aMeses)

LOCAL oExcel     :=    FWMSEXCEL():New()
LOCAL cArqXls    :=    "Ranking_Clientes_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
LOCAL nX,nJ
Local aAux       :=     {}

oExcel:AddworkSheet("Clientes") 

oExcel:AddTable ("Clientes","Clientes")

oExcel:AddColumn("Clientes","Clientes","Razao",1,1)
oExcel:AddColumn("Clientes","Clientes","Bandeira",1,1)
oExcel:AddColumn("Clientes","Clientes","Cnpj",1,1)
oExcel:AddColumn("Clientes","Clientes","Estado",1,1)
oExcel:AddColumn("Clientes","Clientes","Cidade",1,1)
oExcel:AddColumn("Clientes","Clientes","Marca",1,1)
oExcel:AddColumn("Clientes","Clientes","Filial",1,1)

For nX := 1 to len(aMeses)
    oExcel:AddColumn("Clientes","Clientes",strzero(aMeses[nX,01],2)+"/"+cvaltochar(year(ddatabase)),1,1)
Next nX 

FOR nX := 1 TO len(aAux1)
    aAux := {}

    Aadd(aAux,Alltrim(strtran(aAux1[nX,01],"&")))
    Aadd(aAux,Alltrim(aAux1[nX,05]))
    Aadd(aAux,Alltrim(aAux1[nX,02]))
    Aadd(aAux,aAux1[nX,03])
    Aadd(aAux,Alltrim(aAux1[nX,04]))
    Aadd(aAux,Alltrim(aAux1[nX,09]))
    Aadd(aAux,aAux1[nX,10])

    For nJ := 1 to len(aMeses)
        Aadd(aAux,aAux1[nX,nJ+10,02])
    Next nJ

    oExcel:AddRow("Clientes","Clientes",aAux)
Next nX 

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:Destroy()

Return
