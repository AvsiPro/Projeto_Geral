#include "tbiconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TSTFT18   �Autor  �Jackson E. de Deus  � Data �  06/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Auxiliar para movimentar mercadorias para PA em caso de    ���
���          � Nao preenchimento da OS de conferencia                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// transferencia de produtos para PA - abastecimento
User Function TSTFT18()

Local cFile			:= "C:\temp\nf_transf2.csv"
Local nHandle
Local aLinArq		:= {}
Local cNumNf := ""
Local cSerie := ""
Local cCliente := ""
Local cLoja := ""
Local axItens := {}
Local aNF := {}

prepare environment empresa "01" filial "01"

nHandle := FT_FUse(cFile)
If nHandle == -1
	ApMsgStop("Erro na abertura do arquivo" +Str(Ferror()))
	Return
EndIf

FT_FGoTop()     
While !FT_FEOF()
	aLinArq := StrToKarr(FT_FReadLn(),";")
	
	If Ascan( aNF, { |x| x[1] == aLinArq[1] } ) == 0
		AADD( aNF, { aLinArq[1] ,aLinArq[2],aLinArq[3],aLinArq[4], aLinArq[5]   } ) // nf serie cliente loja FILIAL
    EndIf
	FT_FSKIP()
End
FT_FUSE()

For nI := 1 To Len(aNF)
	//U_TTFAT18C( cNumNf,cSerie,cCliente,cLoja,axItens )
	If aNF[nI][5] <> "01"
		cFilAnt := aNf[nI][5]
	EndIf
	U_TTFAT18C( aNF[nI][1],aNF[nI][2],aNF[nI][3],aNF[nI][4],axItens )      
Next nI

Reset Environment


Return