/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTGeraPV	�Autor  �Jackson E. de Deus  � Data �  06/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera Pedido de Venda via MSExecAuto                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Param.    � _aSC5  - Cabe�alho do PV                                   ���
���			 � _aItem - Itens do PV 									  ���
�������������������������������������������������������������������������͹��
���Retorno.  � llRet  - .T. ou .F.		                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Gen�rico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTGeraPV(_aSC5,_aItem)
                                    
Local aArea				:= GetArea()
Local llRet 			:= .F.
Private lMsErroAuto		:= .F.
Private lMsHelpAuto 	:= .T.
Private lAutoErrNoFile	:= .F.

/*----------------------------------------------+
| Par�metros									|
| aPar1 -> Cabe�alho		|	SC5				|
| aPar2 -> Itens 			| 	SC6				|
|												|
|-----------------------------------------------+
| Retorno										|
| .T. ou .F.									|
+-----------------------------------------------*/

If cEmpAnt <> "01"
	Return
EndIf
// -> Valida tamanho dos Arrays                                                                              
If Len(_aSC5) > 0 .And. Len(_aItem) > 0                                 
	
	BeginTran()
	
	MsExecAuto({|x, y, z| MATA410(x, y, z)}, _aSC5, _aItem, 3)                    
	
	If lMsErroAuto

		DisarmTransaction()
		MostraErro()
	
	Else 
	
	    llRet := .T.
		EndTran()		
	
	EndIf                            
	
EndIf	                                                               
                                                                    
MSUnlockAll()                  

RestArea(aArea)

Return llRet 