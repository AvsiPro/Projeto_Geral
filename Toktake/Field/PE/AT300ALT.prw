
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AT300ALT  �Autor  �Jackson E. de Deus  � Data �  07/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE acionado na chamada da altera��o do chamado t�cnico,    ���
���          � logo ap�s a declara��o das vari�veis                       ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �07/05/14�01.01 |Criacao                                 ���
���Jackson       �19/05/14�01.02 |Inclusao da Transf. de Os Mobile		  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/


User Function AT300ALT()

Local lRet := .T.

/*
variavel criada para guardar o conteudo inicial do campo "codigo do tecnico"
utilizada posteriormente no PE AT300GRV para transferir ou nao as OS mobile 
*/          
If cEmpAnt <> "10"                                      
	_SetNamedPrvt( "_cCodTec" , "" , "TECA300" )           
	_cCodTec := ""//AB1->AB1_XTEC
EndIf

Return lRet