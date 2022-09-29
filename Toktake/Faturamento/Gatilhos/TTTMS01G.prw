#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMS01G  บAutor  ณAlexandre Venancio  บ Data ณ  03/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gatilho para preenchimento dos dados do motorista atraves  บฑฑ
ฑฑบ          ณdo campo DA4_COD procurando em todas as empresas.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMS01G()

Local aArea	:=	GetArea()
Local cQuery 

// Tratamento para AMC
If cEmpAnt == "10"
	Return ""
EndIf


cQuery := "SELECT '01',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,"
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,RA_RGORG,RA_ESTCIVI"
cQuery += " FROM SRA010
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT '02',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,
cQuery += " RA_RGORG,RA_ESTCIVI
cQuery += " FROM SRA020
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT '03',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,
cQuery += " RA_RGORG,RA_ESTCIVI
cQuery += " FROM SRA030
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT '04',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,
cQuery += " RA_RGORG,RA_ESTCIVI
cQuery += " FROM SRA040
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
cQuery += " UNION 
cQuery += " SELECT '05',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,
cQuery += " RA_RGORG,RA_ESTCIVI
cQuery += " FROM SRA050
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT '06',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,
cQuery += " RA_RGORG,RA_ESTCIVI
cQuery += " FROM SRA060
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT '07',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,
cQuery += " RA_RGORG,RA_ESTCIVI
cQuery += " FROM SRA070
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
cQuery += " UNION 
cQuery += " SELECT '08',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,
cQuery += " RA_RGORG,RA_ESTCIVI
cQuery += " FROM SRA080
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
cQuery += " UNION 
cQuery += " SELECT '09',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,
cQuery += " RA_RGORG,RA_ESTCIVI
cQuery += " FROM SRA090
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
cQuery += " UNION 
cQuery += " SELECT '10',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,
cQuery += " RA_RGORG,RA_ESTCIVI
cQuery += " FROM SRA100
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT '11',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,
cQuery += " RA_RGORG,RA_ESTCIVI
cQuery += " FROM SRA110
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
cQuery += " UNION
cQuery += " SELECT '12',RA_FILIAL,RA_MAT,RA_ENDEREC,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP,RA_CIC,
cQuery += " RA_TELEFON,RA_HABILIT,RA_NOME,RA_PAI,RA_MAE,RA_RG,
cQuery += " RA_RGORG,RA_ESTCIVI
cQuery += " FROM SRA120
cQuery += " WHERE RA_SITFOLH<>'D' AND RA_MAT='"+M->DA4_COD+"' AND D_E_L_E_T_=''
 
If Select('QUERY') > 0
	dbSelectArea('QUERY')
	dbCloseArea()                    
EndIf

MemoWrite("TTTMS01G.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )


DbSelectArea( "QUERY" )  

M->DA4_MAT		:=	QUERY->RA_MAT
M->DA4_END   	:=	QUERY->RA_ENDEREC
M->DA4_BAIRRO  	:=	QUERY->RA_BAIRRO
M->DA4_MUN   	:=	QUERY->RA_MUNICIP
M->DA4_EST   	:=	QUERY->RA_ESTADO
M->DA4_CEP   	:=	QUERY->RA_CEP
M->DA4_CGC   	:=	QUERY->RA_CIC
M->DA4_TEL   	:=	QUERY->RA_TELEFON
M->DA4_NUMCNH	:=	QUERY->RA_HABILIT
M->DA4_NOME  	:=	QUERY->RA_NOME
M->DA4_PAI   	:=	QUERY->RA_PAI
M->DA4_MAE   	:=	QUERY->RA_MAE
M->DA4_RG    	:=	QUERY->RA_RG
M->DA4_RGORG 	:=	QUERY->RA_RGORG
M->DA4_ESTCIV	:=	QUERY->RA_ESTCIVI

RestArea(aArea)

Return(M->DA4_COD)