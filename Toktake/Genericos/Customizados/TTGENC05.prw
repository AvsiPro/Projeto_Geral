#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTGENC05  �Autor  �Alexandre Venancio  � Data �  01/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Log Interno para alteracao de cadastros genericos.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTGENC05(cTab)

Local aArea1	:=	GetArea()
Local aArea2	:=	GetArea()
Local aChave	:=	{}
Local cChave	:=	''

cTab	+=	"->"

If cEmpAnt == "01" .Or. cEmpAnt == "02"
	Return
EndIF

dbSelectArea("SX3")
SX3->(DbSetOrder(1))
DbSeek(substr(cTab,1,3))
While !eof() .AND. SX3->X3_ARQUIVO == substr(cTab,1,3)
		cCampo := alltrim(SX3->X3_CAMPO) 
		IF X3_CONTEXT != "V"
			IF M->&(cCampo) != &(cTab+cCampo)
				If len(aChave) < 1
					aArea2 := GetArea()
					DbSelectArea("SX2")
					SX2->(DbSetOrder(1))
					DbSeek(substr(cTab,1,3))
					aChave := StrTokArr(SX2->X2_UNICO,"+")  
					For nX := 1 to len(aChave)
						If !"FILIAL" $ Alltrim(aChave[nX])
							cChave += M->&(aChave[nX])
						EndIf
					Next nX
					RestArea(aArea2)   
				EndIf
					//TTGENC01(xFilial,Modulo,Tipo Mov,Prefixo,Docto,Serie,Usuario,Data,Hora,Valor,Obs,Cliente,Loja,Tabela)
		            //Gravacao do log de transacao interno.
				U_TTGENC01(xFilial(substr(cTab,1,3)),FUNDESC(),"ALTERACAO DE CADASTRO",,cChave,,cusername,dtos(date()),cvaltochar(time()),0,'Alterado o conteudo do campo '+cCampo+' Valor anterior '+Alltrim(&(cTab+cCampo)),,,substr(cTab,1,3))
			EndIf
		EndIf
	SX3->(dbskip())
EndDo              

RestArea(aArea1)

Return