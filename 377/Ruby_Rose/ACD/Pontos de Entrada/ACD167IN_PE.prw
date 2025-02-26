#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*
{Protheus.doc} ACD167IN
PE na Embalagem dos Produtos para verificar se existem Produtos com Portaria 344

@author    Paulo Lima
@since    13/12/2021
@return    Nil
*/

User Function ACD167IN()

//Local aArea		:= GetArea()
Local cAlias	:= GetNextAlias()

cQuery	:= "SELECT COUNT(*) TOTREG "
cQuery	+= "FROM " + RetSQLName("CB9") + " CB9 "
cQuery 	+= "INNER JOIN "+RetSqlName('SB1')+" SB1 "+CRLF
cQuery 	+= "	      ON SB1.B1_FILIAL	= '"+xFilial('SB1')+"' 	AND "+CRLF
cQuery 	+= "	         SB1.B1_COD		= CB9.CB9_PROD			AND "+CRLF
cQuery 	+= "	         SB1.B1_ZZTPP	= '02'					AND "+CRLF
cQuery 	+= "	      SB1.D_E_L_E_T_	= ' ' "+CRLF
cQuery	+= "WHERE "
cQuery	+= "  CB9.CB9_FILIAL = '" + xFilial("CB9") + "' 		AND "+CRLF
cQuery  += "  CB9.CB9_ORDSEP = '" + CB7->CB7_ORDSEP + "'	    AND "+CRLF
cQuery	+= "  CB9.D_E_L_E_T_ = ' ' "
TcQuery cQuery New Alias &cAlias

if (cAlias)->TOTREG > 0
	VtBeep(3)
	VTALERT("Conferir Produto Portaria 344","Aviso",.T.,4000,3)
endif

(cAlias)->(dbCloseArea())

Return

