
/*-------------------------------------------------------------------------//
|      Bibliotecas de fun��es necess�rias para o funcionamento da fun��o   //   
|------------------------------------------------------------------------- */  
 #INCLUDE "PROTHEUS.CH"                                                    //
 #INCLUDE "RWMAKE.CH"                                                      //
 #INCLUDE "TOPCONN.CH"                                                     //
/*-------------------------------------------------------------------------*/

/*/
____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �TTDEBIT()   � Autor � Ricardo Souza		� Data �26.06.2011���
��+----------+------------------------------------------------------------���
���Descri��o � Fun��o que ir� ir� desbloquear o t�tulo no financeiro	  ���
��+----------+------------------------------------------------------------���
���Parametros� clChave--> Indice da tabela SZ4					  		  ���       
��+----------+------------------------------------------------------------���
���Uso       � TokTake / Compras                                          ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TTBLQ000(clChave)

Local nlTotal  := 0

If cEmpAnt == "01"

	clQuery :="  SELECT Z4_TOTDIV FROM "+RetSqlName("SZ4")+" AS SZ4  "
	clQuery +="  WHERE  Z4_CHAVENF='"+clChave+"' AND Z4_STATUS='1' AND SZ4.D_E_L_E_T_='' "
	
	If Select("FINBLQ") > 0
		dbSelectArea("FINBLQ")
		DbCloseArea()
	EndIf
	TcQuery clQuery New Alias "FINBLQ"
	TcSetField("FINBLQ","Z4_TOTDIV","N",16,2)
	DbSelectArea("FINBLQ")
	DbGoTop()
	While FINBLQ->(!Eof())
		nlTotal:= nlTotal + FINBLQ->Z4_TOTDIV
		FINBLQ->(DbSkip())
	EndDo	
EndIF

Return (nlTotal)
	