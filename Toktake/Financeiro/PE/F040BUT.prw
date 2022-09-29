#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F040BUT   �Autor  �Alexandre Venancio  � Data �  04/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE utilizado para incluir botoes na enchoicebar do contas  ���
���          �a receber.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F040BUT()

Local aButtons := {}
              
Aadd(aButtons,{"SDUIMPORT" ,{|| VisualNF()} ,"Consultar NF" })
Aadd(aButtons,{"SDUIMPORT" ,{|| U_TTFAT03C()} ,"Romaneio" })
                  
Return (aButtons)  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F040BUT   �Autor  �Alexandre Venancio  � Data �  04/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Visualiza NF de saida                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VisualNF()

Local cArea := GetArea()					

PRIVATE aRotina   := {  { "Pesquisar","Ma460Pesq", 0 , 1},;  //
								{ "Ordem","Ma460Ordem", 0 , 0},; //
								{ "Prep. Doc's","Ma460Nota", 0 , 4},;  //
								{ "Estor.Doc's","Ma461Estor", 0 , 0},; //	
								{ "Visualiza Doc.","Ma461View" , 0 , 2},; //
								{ "Legenda","A461Legend", 0 , 6}}  //	

If Trim(SE1->E1_TIPO)=="NF"
	dbSelectArea("SF2")
	dbSetOrder(2)
	If dbSeek(IF(!EMPTY(SE1->E1_PREFIXO),SUBSTR(SE1->E1_PREFIXO,1,2),SE1->E1_MSFIL)+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_NUM+SUBSTR(SE1->E1_PREFIXO,3,1))
	   		aRotina := { { "Visualiza Doc.", "Mc090visual", 0, 2 } } //
			Mc090Visual("SF2",Recno(),2,.F.,.F.) // Rotina padr�o de visualizacao de NF
	EndIf
Else
	//Aviso("Informa��o","S� � poss�vel visualizar Origem de t�tulo do tipo NF",{"OK"},1,"Aten��o")
	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(SE1->E1_MSFIL+SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_CLIENTE+SE1->E1_LOJA)
		A103NFiscal("SF1",Recno(),2,.F.,.F.) // Rotina padr�o de visualizacao de NF
	EndIf

EndIf	     

RestArea(cArea)

Return