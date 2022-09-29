#Include "PROTHEUS.CH"                    

#IFNDEF WINDOWS
   #DEFINE PSAY SAY
#ENDIF

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AMCCTB03  �Autor  �Ronaldo G. de Jesus � Data �  02/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Este programa valida, atrav�s do X3_VALID, o centro de     ���
���          �custo digitado no Pedido de Venda 	                      ���
�������������������������������������������������������������������������͹��
���Uso       � AMC                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

User Function AMCCTB03()     

Local lRet 	:= .T.                          
Local aArea	:=	GetArea()


If cEmpAnt <> "10"
	Return(lRet)
EndIf

dbSelectArea("CTT")

DBSetOrder(1)   

If DbSeek(xFilial("CTT") + ALLTRIM(M->C6_CC))
    
   IF CTT->CTT_CLASSE == "1"  
      Alert("Centro de Custo Sintetico"+M->C6_CC+", Utilizar Centro de Custo Anal�tico.")        
      lRet := .F.
   EndIf    
                                          
Endif

RestArea(aArea)

Return lRet
