#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT097BUT  �Autor  �Jackson E. de Deus  	� Data � 18/02/13 ���
�������������������������������������������������������������������������͹��
���Desc.     � PE executado na libera��o do Pedido de Compra.             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT097BUT()

// Executa programa respons�vel pela busca e apresenta��o das informa��es
ViewCC()
	
Return





/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ViewCC  �Autor  �Jackson E. de Deus  		� Data � 18/02/13 ���
�������������������������������������������������������������������������͹��
���Desc.     � Mostra na tela os Centros de Custo do Pedido de Compras.   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ViewCC()

Local oDlg
Local oLbx
Local cTitulo := "MT097BUT - Centro de Custo"
Local aDados := {}

               
// Busca Centros de Custo do pedido posicionado na tabela SCR
aDados := RetCC()       
 

If Len(aDados) > 0


	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL

		@ 10,10 LISTBOX oLbx FIELDS HEADER "Centro de Custo", "Descri��o" SIZE 230,95 OF oDlg PIXEL
		oLbx:SetArray( aDados )
		oLbx:bLine := {|| {aDados[oLbx:nAt,1],aDados[oLbx:nAt,2] } }
    
		DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
	

	ACTIVATE MSDIALOG oDlg CENTER

Else      
	Aviso("Aten��o", "Pedido n�o possui Centro de Custo em seus itens.", {"Ok"}, 2)
EndIf
  


Return 



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RetCC  �Autor  �Jackson E. de Deus  		� Data � 18/02/13 ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca os Centros de Custo e alimenta Array que ser� usado  ���
���          � na ListBox para apresenta��o dos dados.                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RetCC()

Local cQry 		:= ""
Local aDados	:= {}
Local cNumPed
Local nRes		:= 0

// Salva numero do pedido posicionado - pega da tabela SCR que est� ativa
cNumPed := SCR->CR_NUM


// Monta Query
cQry := "SELECT "
cQry += "C7_CC, "
cQry += "I3_DESC "
cQry += "FROM "+RetSQLName("SC7")+" AS SC7 "

cQry += "LEFT JOIN "+RetSQLName("SI3")+" AS SI3 ON "
cQry += "SC7.C7_CC = SI3.I3_CUSTO "

cQry += "WHERE C7_NUM = '"+ cNumPed +"' AND "
cQry += "SC7.D_E_L_E_T_ <> '*' AND "
cQry += "SI3.D_E_L_E_T_ <> '*' "

cQry += "ORDER BY C7_CC"


TCQUERY cQry NEW ALIAS "QRYCC" 


// Preenche Array
dbSelectArea("QRYCC")
dbGoTop()
While !EOF()
	 
	// Verifica Array - procura Centro de Custo j� existente
	nRes := aScan(aDados, { |x| Alltrim(x[1]) == Alltrim(QRYCC->C7_CC) } )
			    
	// Se Centro de Custo ainda n�o est� no Array, adiciona no Array (evita duplicidade)                                                        
	If nRes == 0
		AADD(aDados, { QRYCC->C7_CC, QRYCC->I3_DESC	} )
	EndIf                                          
			
	QRYCC->(Dbskip())
	
End
QRYCC->(DbCloseArea())



Return (aDados)