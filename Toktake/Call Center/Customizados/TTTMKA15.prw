#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTTMKA15    �Autor  �Jackson E. de Deus� Data �  26/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Estorna o encerramento do atendimento.                      ���
���          �															  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �26/07/13�01.00 |Criacao                                 ���
���Jackson       �28/04/15�01.01 |Alterado para estornar tambem OMM		  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function TTTMKA15()

Local nCountSUD	:= 0
Local nAltSUD	:= 0
Local lExcPend	:= .F.
Local alArea	:= GetArea()
Local cAssOMM	:= If(cEmpAnt=="01",SuperGetMV("MV_XTMK002",.T.,""),"")				// Assunto OMM
Local cUsrPerm	:= If(cEmpAnt=="01",SuperGetMV("MV_XTMK015",.T.,"ADMINISTRADOR"),"")	// Usuarios do SAC com permissao para estorno de RA
Local cUsrVip	:= If(cEmpAnt=="01",SuperGetMV("MV_XTMK024",.T.,"ADMINISTRADOR"),"")	// Usuarios VIP - estornam qualquer atendimento

If cEmpAnt <> "01"
	Return
EndIf

If !Upper(cUserName) $ cUsrPerm
	If !Upper(cUserName) $ cUsrVip
		Aviso("TTTMKA15","Voc� n�o tem permiss�o para utilizar esta rotina.",{"Ok"})
		Return
	EndIf	
EndIf

If !MsgYesNo("Deseja realmente estornar o encerramento?")
	Return
EndIf


dbSelectArea("SUD")
dbSetOrder(1)
If dbSeek(xFilial("SUD") +SUC->UC_CODIGO)
	If SUD->UD_ASSUNTO == cAssOMM
		If ! UPPER(cUserName) $ UPPER(cUsrVip)
			Aviso("TTTMKA15","Voc� n�o tem permiss�o para estornar o encerramento de um atendimento de OMM.",{"Ok"})
			Return
		EndIf
	EndIf 
	// Conta quantos registros tem para o atendimento
	While SUD->UD_FILIAL == SUC->UC_FILIAL .And. SUD->UD_CODIGO == SUC->UC_CODIGO .And. SUD->(!Eof())
		nCountSUD++
		SUD->(dbSkip())
	End                      
	
	// Altera o status na SUD
	dbGoTop()
	dbSeek(xFilial("SUD") +SUC->UC_CODIGO)
	BeginTran()
	While SUD->UD_FILIAL == SUC->UC_FILIAL .And. SUD->UD_CODIGO == SUC->UC_CODIGO .And. SUD->(!Eof())
		If RecLock("SUD",.F.)
			SUD->UD_STATUS := "1" // 1 - pendente
			MsUnLock()
			nAltSUD++
		Else
			DisarmTransaction()	
		EndIf
		SUD->(dbSkip())
	End                
	
	dbSelectArea("SUC")
	If nAltSUD == nCountSUD
		//exclui a observacao de encerramento - SYP - MEMO VIRTUAL
		MSMM(SUC->UC_CODMOT,,,,2) 
		// Altera o status na SUC
		If RecLock("SUC",.F.)
		   	SUC->UC_STATUS := "2"	//2 - pendente
		   	SUC->UC_CODENCE := ""
		   	SUC->UC_DTENCER := CtoD(space(8))
		   	SUC->UC_CODMOT := ""
			MsUnLock()
			//��������������������������������������������������������������������������������������������Ŀ
			//�Encerra as listas de pendencias se existir alguma - SOMENTE PARA ESSE ATENDIMENTO ENCERRADO �
			//����������������������������������������������������������������������������������������������
			lExcPend := DelSU4(SUC->UC_CODIGO)
	        If ValType(lExcPend) == "L"
	        	If lExcPend
	        		EndTran()
	        		Aviso("TTTMKA15","Encerramento estornado com sucesso.",{"Ok"})
	        	Else
	        		DisarmTransaction()	
	        	EndIf
	        Else
	        	DisarmTransaction()	
	        EndIf
		Else
			DisarmTransaction()	
		EndIf
	Else                
		DisarmTransaction()	
	EndIf
	MSUnLockAll()
EndIf

RestArea(alArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DelSU4    �Autor  �Jackson E. de Deus  � Data �  26/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Apaga a lista de pendencia gerada pelo atendimento.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function DelSU4(cCodLig)

Local lRet := .F.
Local aArea := GetArea()		//Salva a area atual

DbSelectArea("SU4")
DbSetOrder(4) 					// Pesquisar pela descricao temporariamente.
If DbSeek(xFilial("SU4")+cCodLig)
	RecLock("SU4",.F.)	
	Replace SU4->U4_STATUS With "1"      	// Status da Lista 1=Pendente 2=Encerrada      
	MsUnlock()
	
	DbSelectArea("SU6")
	DbSetOrder(1)
	If DbSeek(xFilial("SU6")+SU4->U4_LISTA)
		RecLock("SU6",.F.)
		Replace SU6->U6_STATUS With	"1"		//1=Nao Enviado 2=Enviado
		MsUnlock()
	Endif
	
	DbCommit()
	lRet := .T.
Endif

RestArea(aArea)

Return lRet