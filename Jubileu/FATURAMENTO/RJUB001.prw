#include 'protheus.ch'
#include 'parmtype.ch'
#include 'tbiconn.ch'
#Include "TopConn.ch"
#include "fileio.ch"

/*/{Protheus.doc} RJUB001
//FATURAMENTO TNG
@author Rodrigo Barreto
@since 22/05/2021
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function RJUB001()

	Local aPergs   := {}
	Local dEmisDe	:= StoD('')
	Local dEmisAt	:= StoD('')
	Local cClienDe	:= SPACE(12)
	Local cClienAt	:= SPACE(12)
    Local cLojaDe     := SPACE(4)
    Local cLojaAt   := SPACE(4)
	//PREPARE ENVIRONMENT EMPRESA "33" FILIAL "01"
	
	aAdd(aPergs, {1, "Emissao de ",			 		dEmisDe,  "",  ".T.",   "",  ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Emissao Ate ",			 	dEmisAt,  "",  ".T.",   "",  ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Cliente De ",			 		cClienDe,  "",  ".T.",   "",  ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Cliente Ate ",			 	cClienAt,  "",  ".T.",   "",  ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Loja De ",			 		cLojaDe,  "",  ".T.",   "",  ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Loja Ate ",			 	cLojaAt,  "",  ".T.",   "",  ".T.", 80,  .T.})

	If ParamBox(aPergs, "Informe os paarametros")
		MsAguarde({|| GeraExcel()},,"O arquivo Excel está sendo gerado...")
	EndIf
		
return Nil

Static Function GeraExcel()

Local oExcel  := FWMSEXCEL():New()
Local lOK 	  := .F.
Local cArq 	  := "" 
Local cQuery  := ""
Local cPar1   := MV_PAR01
Local cPar2   := MV_PAR02
Local cPar3   := MV_PAR03
Local cPar4   := MV_PAR04
Local cPar5   := MV_PAR05
Local cPar6   := MV_PAR06
Local cDirTmp

Private dDataGer  := Date()
Private cHoraGer  := Time()

SetPrvt("MV_PAR01","MV_PAR02","MV_PAR03","MV_PAR04","MV_PAR05","MV_PAR06")

cQuery := " SELECT D2_COD,B1_DESC, D2_ITEM,D2_QUANT, D2_PRCVEN, D2_TOTAL,D2_PEDIDO,"
cQuery += " D2_CLIENTE,D2_LOJA,A1_NOME, A1_NREDUZ, A1_XLOJCLI,A1_CGC,D2_DOC,D2_SERIE,"
cQuery += " D2_EMISSAO FROM "+ RetSQLName('SD2')+" D2 "
cQuery += " INNER JOIN "+ RetSqlName('SB1')+ " B1 ON B1_COD=D2_COD AND B1.D_E_L_E_T_=''"
cQuery += " LEFT JOIN  "+ RetSqlName('SA1')+ " A1 ON A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " WHERE B1.D_E_L_E_T_='' AND B1_DESC LIKE '%TNG%' AND"
cQuery += " D2_FILIAL= "+ xFilial('SD2') +" AND D2.D_E_L_E_T_='' AND"
cQuery += " D2_EMISSAO BETWEEN '"+ DtoS(cPar1) +"' AND '"+ DtoS(cPar2) +"' AND"
cQuery += " D2_CLIENTE BETWEEN '"+ cPar3 +"' AND '"+ cPar4 +"' AND"
cQuery += " D2_LOJA BETWEEN '"+ cPar5 +"' AND  '"+ cPar6 +" ' "

If Select("TMP")<>0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf
	
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)
	
dbSelectArea("TMP")
TMP->(dbGoTop())

oExcel:SetLineFrColor("#000")
oExcel:SetTitleFrColor("#000")
oExcel:SetFrColorHeader("#000")																																																																																																																																																																																																																			

oExcel:AddWorkSheet("Vendas TNG")
oExcel:AddTable("Vendas TNG","Faturamento")
oExcel:AddColumn("Vendas TNG","Faturamento","COD PRODUTO"         		,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","DESCRICAO PROD"       				,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","ITEM FAT"       				,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","QUANTIDADE"       				,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","PREÇO VENDA"     				,3,3)
oExcel:AddColumn("Vendas TNG","Faturamento","TOTAL"     				,3,3)
oExcel:AddColumn("Vendas TNG","Faturamento","PEDIDO"     		,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","Cod CLIENTE"         		,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","Loja CLIENTE"         	,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","RAZAO SOCIAL"         	,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","NOME REDUZIDO"         		,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","LOJA PED OK"         			,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","CNPJ"       			,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","NOTA FISCAL"       			,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","SERIE"       			,1,1)
oExcel:AddColumn("Vendas TNG","Faturamento","EMISSAO"         	,1,1)

			
While TMP->(!EOF())
			  
    oExcel:AddRow("Vendas TNG","Faturamento",{TMP->D2_COD,;
				        				TMP->B1_DESC,;
										TMP->D2_ITEM,;
	   									TMP->D2_QUANT,;
										TMP->D2_PRCVEN,;	         							
										TMP->D2_TOTAL,;
	   									TMP->D2_PEDIDO,;
										TMP->D2_CLIENTE,;
										TMP->D2_LOJA,;
    									TMP->A1_NOME,;
										TMP->A1_NREDUZ,;
										TMP->A1_XLOJCLI,;
										TMP->A1_CGC,;
										TMP->D2_DOC,;
										TMP->D2_SERIE,;
                                        StoD(TMP->D2_EMISSAO)})

	        lOK := .T.
            TMP->(dbSkip())
EndDo

dbSelectArea("TMP")
dbCloseArea()
		
cDirTmp:= cGetFile( '*.csv|*.csv' , 'Selecionar um diretório para salvar', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

oExcel:Activate()
	
cArq := CriaTrab(NIL, .F.) +"_VENDAS TNG_"+dToS(dDataGer) + "_" + StrTran(cHoraGer, ':', '-')+ ".xml"  
oExcel:GetXMLFile(cArq)
			
If __CopyFile(cArq,cDirTmp + cArq)
	If lOK
		oExcelApp := MSExcel():New()
		oExcelApp:WorkBooks:Open(cDirTmp + cArq)
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
		MsgInfo("O arquivo Excel foi gerado no dirtório: " + cDirTmp + cArq + ". ")
	EndIf
Else
	MsgAlert("Erro ao criar o arquivo Excel!")
EndIf
		
return
