/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTA100MNU ºAutor  ³Jackson E. de Deus  º Data ³  08/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adiciona botoes em Acoes Relacionadas da tela de Contrato.  º±±
±±º          ³							                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gestao de Contratos                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CTA100MNU()

If cEmpAnt == "01"
	
	If FindFunction("U_TTCTAC01")
		aAdd( aRotina, { 'Relac. Pai/filho' ,'U_TTCTAC01()', 0 , 7, NIL })
	EndIf
	       
	If FindFunction("U_TTCTAC02")
		aAdd( aRotina, { 'Patrimonios' ,'U_TTCTAC02()', 0 , 7, NIL })
	EndIf
	
	Aadd(aRotina,{"Alterar Status","U_TTCNTA04",0,7}) 
	Aadd(aRotina,{"Tip.Serv. Patr.","U_TTCNTA07()",0,7})
	Aadd(aRotina,{"Config. Patrimônios.","U_TTCNTA18()",0,7})
	
	Aadd(aRotina,{"Locação","U_TTCNTLOC()",0,7})
EndIF

Return       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CNT200MNU ºAutor  ³Microsiga           º Data ³  08/22/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Voltar o status do contrato para alteracoes                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTCNTA04()

Local aArea	:=	GetArea()
Local cQuery	:=	''      
Reclock("CN9")

CN9->CN9_SITUAC	:=	"02"
CN9->CN9_DTULST	:=	CTOD(' / / ')
CN9->CN9_DTASSI	:=	CTOD(' / / ')
CN9->(Msunlock())
                      
cQuery := "UPDATE "+RetSQLName("SE1")+" SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_
cQuery += " WHERE E1_CLIENTE='"+CN9->CN9_CLIENT+"' AND E1_LOJA='"+CN9->CN9_LOJACL+"' AND E1_PREFIXO='CTR' AND E1_MDCONTR='"+CN9->CN9_NUMERO+"' AND D_E_L_E_T_=''"

MemoWrite("UPDSE1.SQL",cQuery)
TcSqlExec(cQuery)

                      
// Exclui do cronograma fisico os registros que ja foram excluidos do cronograma financeiro - Jackson 01/11/2013
cQuery := "UPDATE " +RetSqlName("CNS")+" SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_ "
cQuery += "WHERE CNS_CRONOG NOT IN ( SELECT CNF_NUMERO FROM " +RetSqlName("CNF") +" WHERE CNF_CONTRA = CNS_CONTRA AND D_E_L_E_T_ = '' ) "
cQuery += "AND CNS_CONTRA = '"+CN9->CN9_NUMERO+"' "
cQuery += "AND D_E_L_E_T_= '' "

MemoWrite("UPDCNS.SQL",cQuery)
TcSqlExec(cQuery)
                                                                                                                            

RestArea(aArea)                                                                                                                     

Return