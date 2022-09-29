
/*-------------------------------------------------------------------------//
|      Bibliotecas de funções necessárias para o funcionamento da função   //   
|------------------------------------------------------------------------- */  
 #INCLUDE "PROTHEUS.CH"                                                    //
 #INCLUDE "RWMAKE.CH"                                                      //
 #INCLUDE "TOPCONN.CH"                                                     //
/*-------------------------------------------------------------------------*/

/*/
____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Função    ¦TTDEBIT()   ¦ Autor ¦ Ricardo Souza		¦ Data ¦26.06.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função que irá irá desbloquear o título no financeiro	  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ clChave--> Indice da tabela SZ4					  		  ¦¦¦       
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokTake / Compras                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
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
	