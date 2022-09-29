#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATG05  บAutor  ณAlexandre Venancio  บ Data ณ  05/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gatilho para preenchimento do nome do funcionario no cadas-บฑฑ
ฑฑบ          ณtro da PA                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFATG05(cConteudo)

Local aArea		:=	GetArea()
Local cMat		:=	""

// Tratamento para AMC
If cEmpAnt == "10"
	Return cMat
EndIf
                             
cQuery := "SELECT RA_MAT,RA_NOME
cQuery += " FROM SRA010 RA
cQuery += " WHERE RA_MAT='"+cConteudo+"' AND RA_SITFOLH<>'D' AND RA.D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT RA_MAT,RA_NOME
cQuery += " FROM SRA020 RA
cQuery += " WHERE RA_MAT='"+cConteudo+"' AND RA_SITFOLH<>'D' AND RA.D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT RA_MAT,RA_NOME
cQuery += " FROM SRA030 RA
cQuery += " WHERE RA_MAT='"+cConteudo+"' AND RA_SITFOLH<>'D' AND RA.D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT RA_MAT,RA_NOME
cQuery += " FROM SRA040 RA
cQuery += " WHERE RA_MAT='"+cConteudo+"' AND RA_SITFOLH<>'D' AND RA.D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT RA_MAT,RA_NOME
cQuery += " FROM SRA050 RA
cQuery += " WHERE RA_MAT='"+cConteudo+"' AND RA_SITFOLH<>'D' AND RA.D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT RA_MAT,RA_NOME
cQuery += " FROM SRA060 RA
cQuery += " WHERE RA_MAT='"+cConteudo+"' AND RA_SITFOLH<>'D' AND RA.D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT RA_MAT,RA_NOME
cQuery += " FROM SRA070 RA
cQuery += " WHERE RA_MAT='"+cConteudo+"' AND RA_SITFOLH<>'D' AND RA.D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT RA_MAT,RA_NOME
cQuery += " FROM SRA080 RA
cQuery += " WHERE RA_MAT='"+cConteudo+"' AND RA_SITFOLH<>'D' AND RA.D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT RA_MAT,RA_NOME
cQuery += " FROM SRA090 RA
cQuery += " WHERE RA_MAT='"+cConteudo+"' AND RA_SITFOLH<>'D' AND RA.D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT RA_MAT,RA_NOME
cQuery += " FROM SRA100 RA
cQuery += " WHERE RA_MAT='"+cConteudo+"' AND RA_SITFOLH<>'D' AND RA.D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT RA_MAT,RA_NOME
cQuery += " FROM SRA110 RA
cQuery += " WHERE RA_MAT='"+cConteudo+"' AND RA_SITFOLH<>'D' AND RA.D_E_L_E_T_=''

If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

MemoWrite("TTFATG05.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )


DbSelectArea( "TRB" )        

If Alltrim(ReadVar()) == "M->ZZ1_XATEND"
	M->ZZ1_XNOMAT := TRB->RA_NOME
ElseIf Alltrim(ReadVar()) == "M->ZZ1_XGEREN"
	M->ZZ1_XNOMGE := TRB->RA_NOME
ElseIf Alltrim(ReadVar()) == "M->ZZ1_XSUPER"    
	M->ZZ1_XNOMSU := TRB->RA_NOME
EndIf


RestArea(aArea)

Return(cConteudo)