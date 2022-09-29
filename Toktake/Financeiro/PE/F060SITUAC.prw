
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F060SITUAC�Autor  �Alexandre Venancio  � Data �  03/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE Utilizado para incluir novas carteiras no bordero de    ���
���          �contas a pagar.                                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F060SITUAC()

Local aSituacoes := paramixb

Aadd(aSituacoes,"A Cobranca Provisao/Perdas")
Aadd(aSituacoes,"B Cobranca Transitoria")
Aadd(aSituacoes,"C Carteira Protesto")
Aadd(aSituacoes,"D Carteira Acordo")
Aadd(aSituacoes,"E Cobranca Cartorio")
Aadd(aSituacoes,"F Provisao Devedores Duvidosos")
Aadd(aSituacoes,"G Terceirizada")
Aadd(aSituacoes,"H Juridico")
Aadd(aSituacoes,if(cempant=="02","I VENDOR","I Permuta"))


Return aSituacoes