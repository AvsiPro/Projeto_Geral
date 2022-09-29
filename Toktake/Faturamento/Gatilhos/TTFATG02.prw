#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     ºAutor  ³Microsiga           º Data ³  01/20/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TTFATG02(cCampo)

Local aArea		:=	GetArea()
Local cQuery    
Local cRetorno	:=	""
                
cQuery := "SELECT '01' AS EMP,RA_MAT,RA_NOME,RA_HABILIT
cQuery += " FROM SRA010
cQuery += " 	WHERE D_E_L_E_T_='' AND RA_MAT='"+M->DA4_COD+"'
cQuery += " UNION
cQuery += " (SELECT '02' AS EMP,RA_MAT,RA_NOME,RA_HABILIT 
cQuery += " 	FROM SRA020
cQuery += " 	WHERE D_E_L_E_T_=''AND RA_MAT='"+M->DA4_COD+"')
cQuery += " UNION
cQuery += " (SELECT '03' AS EMP,RA_MAT,RA_NOME,RA_HABILIT
cQuery += " 	FROM SRA030
cQuery += " 	WHERE D_E_L_E_T_=''AND RA_MAT='"+M->DA4_COD+"')
cQuery += " UNION
cQuery += " (SELECT '04' AS EMP,RA_MAT,RA_NOME,RA_HABILIT
cQuery += " 	FROM SRA040
cQuery += " 	WHERE D_E_L_E_T_=''AND RA_MAT='"+M->DA4_COD+"')UNION
cQuery += " (SELECT '05' AS EMP,RA_MAT,RA_NOME,RA_HABILIT
cQuery += " 	FROM SRA050
cQuery += " 	WHERE D_E_L_E_T_=''AND RA_MAT='"+M->DA4_COD+"')UNION
cQuery += " (SELECT '06' AS EMP,RA_MAT,RA_NOME,RA_HABILIT
cQuery += " 	FROM SRA060	WHERE D_E_L_E_T_=''AND RA_MAT='"+M->DA4_COD+"')UNION
cQuery += " (SELECT '07' AS EMP,RA_MAT,RA_NOME,RA_HABILIT 
cQuery += " 	FROM SRA070
cQuery += " 	WHERE D_E_L_E_T_=''AND RA_MAT='"+M->DA4_COD+"')UNION
cQuery += " (SELECT '08' AS EMP,RA_MAT,RA_NOME,RA_HABILIT
cQuery += " 	FROM SRA080
cQuery += " 	WHERE D_E_L_E_T_=''AND RA_MAT='"+M->DA4_COD+"')UNION
cQuery += " (SELECT '09' AS EMP,RA_MAT,RA_NOME,RA_HABILIT 
cQuery += " 	FROM SRA090
cQuery += " 	WHERE D_E_L_E_T_=''AND RA_MAT='"+M->DA4_COD+"')UNION
cQuery += " (SELECT '10' AS EMP,RA_MAT,RA_NOME,RA_HABILIT
cQuery += " 	FROM SRA100
cQuery += " 	WHERE D_E_L_E_T_=''AND RA_MAT='"+M->DA4_COD+"')UNION
cQuery += " (SELECT '11' AS EMP,RA_MAT,RA_NOME,RA_HABILIT
cQuery += " 	FROM SRA110
cQuery += " 	WHERE D_E_L_E_T_=''AND RA_MAT='"+M->DA4_COD+"')	

If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

If Alltrim(cCampo) == "NOME"
	cRetorno := TRB->RA_NOME
ElseIf Alltrim(cCampo) == "HABILIT"
	cRetorno := TRB->RA_HABILIT
EndIf                          

/*If ExistTrigger('DA4_MAT') 
	M->DA4_MAT :=  TRB->RA_MAT
	RunTrigger(3,nil,nil,,'DA4_MAT')
Endif     */


RestArea(aArea)

Return(cRetorno)