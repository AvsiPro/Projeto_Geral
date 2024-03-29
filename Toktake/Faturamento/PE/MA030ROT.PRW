#INCLUDE "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MA030ROT � Autor � Artur Nucci Ferrari   � Data � 06/07/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para incluir rotinas no MATA030           ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/          



User Function MA030ROT()

Local _aRet:= {}

// Tratamento para AMC
If cEmpAnt == "10"
	Return _aRet
EndIf

aAdd(_aRet,{'Site','U_TTSA1ZZ3',0,1,0,.F.})
AAdd(_aRet,{"Locais Fisicos","U_TTSA1SZ8", 2, 0 } )


Return _aRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030ROT  �Autor  �Microsiga           � Data �  07/24/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

User Function TTSA1ZZ3()

Local cOldCad := cCadastro
//Local cOldCor := aCores
Local cOldRot := aRotina 
Local cCliZZ3 := SA1->A1_COD
Local cLojZZ3 := SA1->A1_LOJA
Local cFilter := "ZZ3_CODCLI='"+cCliZZ3+"' .AND. ZZ3_LOJA='"+cLojZZ3+"'"
cCadastro := "Sites do Cliente - " + AllTrim(SA1->A1_NOME)
//aCores  := {{ "ZZ3->ZZ3_MSBLQL = '2'" 	, "BR_VERDE" },;
//            { "ZZ3->ZZ3_MSBLQL = '1'" 	, "BR_VERMELHO"}}

aCores  := {{ "ZZ3->ZZ3_CODIGO<>''" 	, "BR_VERDE" }}
aRotina := {{ "Pesquisar"   ,'AxPesqui'    , 0, 1},;
            { "Visualizar"  ,'AxVisual'    , 0, 2},; 
            { "PAs"         ,'U_TTSA1ZZ1'   , 0, 3}}

dbSelectArea("ZZ3")
ZZ3->(dbSetOrder(1))
Set Filter To &cFilter
dbSelectArea("ZZ3")
mBrowse( 6,1,22,75,"ZZ3",,,,,,aCores)
Set Filter To            

cCadastro := cOldCad
//aCores    := cOldCor
aRotina   := cOldRot
Return(Nil)           
*/


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030ROT  �Autor  �Microsiga           � Data �  07/24/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function TTSA1ZZ1()

Local cOldCad := cCadastro
//Local cOldCor := aCores
Local cOldRot := aRotina  
Local cFilZZ1  := ZZ3->ZZ3_FILIAL
Local cSiteZZ1 := ZZ3->ZZ3_CODIGO
Local cFilter := "ZZ1_FILIAL='"+cFilZZ1+"' .AND. ZZ1_SITE='"+cSiteZZ1+"'"
cCadastro := "PAs do Cliente - " + AllTrim(SA1->A1_NOME)
//aCores  := {{ "ZZ3->ZZ3_MSBLQL = '2'" 	, "BR_VERDE" },;
//            { "ZZ3->ZZ3_MSBLQL = '1'" 	, "BR_VERMELHO"}}

aCores  := {{ "ZZ1->ZZ1_COD<>''" 	, "BR_VERDE" }}

aRotina := {{ "Pesquisar"     ,'AxPesqui'    , 0, 1},;
            { "Visualizar"    ,'AxVisual'    , 0, 2}} 

dbSelectArea("ZZ1")
ZZ1->(dbSetOrder(1))
Set Filter To &cFilter
dbSelectArea("ZZ1")
mBrowse( 6,1,22,75,"ZZ1",,,,,,aCores)
Set Filter To            

cCadastro := cOldCad
//aCores    := cOldCor
aRotina   := cOldRot
Return(Nil)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030ROT  �Autor  �Microsiga           � Data �  07/24/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Cadastro de locais fisicos de instalacao de patrimonio   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TTSA1SZ8()

Local aArea		:=	GetArea()
Local aPergs	:= {} 
Local aRet		:= {}
            
aAdd(aPergs ,{1,"Local Fisico"	,space(TamSx3("Z8_LOCFIS1")[1]),"@!",".T.",/*F3*/,".T.",100,.F.})

If ParamBox(aPergs ,"Local Fisico",@aRet)
	DbSelectArea("SZ8")
	DbsetOrder(2)
	If !DbSeek(xFilial("SZ8")+SA1->A1_COD+SA1->A1_LOJA+aRet[1])
		Reclock("SZ8",.T.) 
		SZ8->Z8_CLIENTE	:= SA1->A1_COD
		SZ8->Z8_LOJA	:= SA1->A1_LOJA
		SZ8->Z8_LOCFIS1 := aRet[1]
		SZ8->(Msunlock())
	Else
		MsgAlert("Local Fisico j� existente para este cliente.","MA030ROT - TTSA1SZ8")
	EndIf
EndIf

RestArea(aArea)

Return