#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

/*/{Protheus.doc} User Function ROBRCM02
    (long_description)
    @type  Function
    @author user
    @since 25/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ROBRCM02()

Private aDados  :=  {}
Private _Vend1  :=  space(6)
Private _Vend2  :=  'ZZZZZZ'
Private _DtDe   :=  CTOD(' / / ')
Private _DtAt   :=  CTOD(' / / ')


Define msDialog oDlg01 From 00,00 To 220,370 Title "Comissões" Pixel &&145
Define Font oFont1 Name "Arial" Size 0,-12 Bold

@025,007 SAY "Vendedor De : " Font oFont1 of oDlg01 Pixel
@025,120 MSGET _Vend1  SIZE 60,9 F3 "SA3" OF oDlg01 Pixel 

@040,007 SAY "Vendedor Até : " Font oFont1 of oDlg01 Pixel
@040,120 MSGET _Vend2  SIZE 60,9 F3 "SA3" OF oDlg01 Pixel

@055,007 SAY "Data De : " Font oFont1 of oDlg01 Pixel
@055,120 MSGET _DtDe  SIZE 60,9 OF oDlg01 Pixel 

@070,007 SAY "Data Até : " Font oFont1 of oDlg01 Pixel
@070,120 MSGET _DtAt  SIZE 60,9 OF oDlg01 Pixel

@090,115 BmpButton Type 1 Action(lRet := .T.,Close(oDlg01))
@090,150 BmpButton Type 2 Action(lRet := .F.,Close(oDlg01))

Activate Dialog oDlg01 Centered

If lRet
    Processa({|| aDados := BuscaDados()},"Aguarde, buscando dados...")
    Processa({|| Geraexcel()},"Gerando arquivo")
EndIf 

Return

/*/{Protheus.doc} BuscaDados()
    (long_description)
    @type  Static Function
    @author user
    @since 25/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaDados()

Local aArea :=  GetArea()
Local cQuery 
Local aRet  :=  {}

cQuery := "SELECT C5_EMISSAO,C5_VEND1,A3_NOME AS NOME,Z30_REGIAO,"
cQuery += " BM_XMODELO,A3_GEREN,SUM(C6_QTDVEN) AS QTD,SUM(C6_VALOR) AS VALOR" 
cQuery += " FROM "+RetSQLName("SC6")+" C6"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM" 
cQuery += "    AND C5.D_E_L_E_T_=' '"
cQuery += "    AND C5_EMISSAO BETWEEN '"+DTOS(_DtDe)+"' AND '"+DTOS(_DtAt)+"'" 
cQuery += "    AND C5_VEND1 BETWEEN '"+_Vend1+"' AND '"+_Vend2+"'"
cQuery += "    AND C5_XCLASPV='1'"
cQuery += " INNER JOIN "+RetSQLName("SA3")+" A3 ON A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD=C5_VEND1 AND A3.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=C6_PRODUTO AND B1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SBM")+" BM ON BM_FILIAL=B1_FILIAL AND BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("Z30")+" Z3 ON Z30_FILIAL=B1_FILIAL AND Z30_CODVEN=C5_VEND1 AND Z3.D_E_L_E_T_=' '"
cQuery += " WHERE C6.D_E_L_E_T_=' '"
cQuery += " GROUP BY C5_EMISSAO,C5_VEND1,A3_NOME,Z30_REGIAO,BM_XMODELO,A3_GEREN"
cQuery += " ORDER BY A3_GEREN,C5_EMISSAO,C5_VEND1"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aRet,{ TRB->A3_GEREN,;
                Posicione("SA3",1,xFilial("SA3")+TRB->A3_GEREN,"A3_NOME"),;
                cvaltochar(stod(TRB->C5_EMISSAO)),;
                TRB->C5_VEND1,;
                TRB->NOME,;
                TRB->Z30_REGIAO,;
                TRB->BM_XMODELO,;
                TRB->QTD,;
                Transform(TRB->VALOR,"@E 999,999,999.99")})
    Dbskip()
ENDDO

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} Geraexcel
    (long_description)
    @type  Static Function
    @author user
    @since 25/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Geraexcel()

Local oExcel 	:= FWMSEXCEL():New()
//Local cTitulo 	:= "Venda_Diaria Comissao"
Local cDir 		:= ""
Local nX 
Local cArqXls 	:= "Venda_Diaria_"+dtos(ddatabase)+strtran(time(),":")+".xls" 

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet("Venda_Diaria") 

oExcel:AddTable ("Venda_Diaria","Resumo")

oExcel:AddColumn("Venda_Diaria","Resumo","Gerente",1,1)
oExcel:AddColumn("Venda_Diaria","Resumo","Nome",1,1) 
oExcel:AddColumn("Venda_Diaria","Resumo","Emissao",1,1) 
oExcel:AddColumn("Venda_Diaria","Resumo","Vendedor",1,1) 
oExcel:AddColumn("Venda_Diaria","Resumo","Nome",1,1) 
oExcel:AddColumn("Venda_Diaria","Resumo","Regiao",1,1)
oExcel:AddColumn("Venda_Diaria","Resumo","Mala",1,1) 
oExcel:AddColumn("Venda_Diaria","Resumo","Qtd",1,1)
oExcel:AddColumn("Venda_Diaria","Resumo","Valor",1,1)   

/*cVendAux := aDados[1,1]
cNomVnd  := aDados[1,18]
nComisVn := 0
nTotVnd  := 0*/

For nX := 1 to len(aDados)
    /*If cVendAux == aDados[nX,01]
        nComisVn += aDados[nX,20]
        nTotVnd  += aDados[nX,17]
    else
        oExcel:AddRow("Venda_Diaria","Resumo",{  "",;
                                                        "",; 
                                                        "",;	
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",; 
                                                        "",;
                                                        "Total Vend. "+cNomVnd,;	
                                                        "",;
                                                        "",;
                                                        "",; 
                                                        nTotVnd,;
                                                        "",;	
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;	
                                                        "Total Comissao",;
                                                        "",;
                                                        nComisVn}) 
            
            oExcel:AddRow("Venda_Diaria","Resumo",{  "",;
                                                        "",; 
                                                        "",;	
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",; 
                                                        "",;
                                                        "",;	
                                                        "",;
                                                        "",;
                                                        "",; 
                                                        "",;
                                                        "",;	
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;	
                                                        "",;
                                                        "",;
                                                        ""}) 

        cVendAux := aDados[nX,01]
        cNomVnd  := aDados[nX,18]
        nComisVn := aDados[nX,20]
        nTotVnd  := aDados[nX,17]
    EndIf */

	oExcel:AddRow("Venda_Diaria","Resumo",{aDados[nX,01],;
                                                        aDados[nX,02],; 
                                                        aDados[nX,03],;	
                                                        aDados[nX,04],;
                                                        aDados[nX,05],;
                                                        aDados[nX,06],;
                                                        aDados[nX,07],; 
                                                        aDados[nX,08],;
                                                        aDados[nX,09]}) 
Next nX

/*
oExcel:AddRow("Venda_Diaria","Resumo",{  "",;
                                                        "",; 
                                                        "",;	
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",; 
                                                        "",;
                                                        "Total Vend. "+cNomVnd,;	
                                                        "",;
                                                        "",;
                                                        "",; 
                                                        nTotVnd,;
                                                        "",;	
                                                        "",;
                                                        "",;
                                                        "",;
                                                        "",;	
                                                        "Total Comissao",;
                                                        "",;
                                                        nComisVn}) 
*/
oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

WinExec('Explorer.exe /select,"' + cDir + '"', 1)

oExcelApp := MsExcel():New()
oExcelApp:Destroy()
	
Return
