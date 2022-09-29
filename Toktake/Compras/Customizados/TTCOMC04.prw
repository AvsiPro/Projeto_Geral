#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � TTCOMC04 � Autor � Alexandre Venancio    � Data �26/04/2012���
�������������������������������������������������������������������������Ĵ��
���Locacao   �  Compras         �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Informacoes sobre cubagem do produto.                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �                                               ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function TTCOMC04()
      
Local aArea	:=	GetArea()
Local nComp	:=	0
Local nEspe	:=	0
Local nLarg	:=	0  
Local nOpc	:=	0

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oGet1","oGet2","oGet3","oSBtn1")
                 
While nOpc == 0
	oDlg1      := MSDialog():New( 091,232,314,580,"Cubagem",,,.F.,,,,,,.T.,,,.T. )
	
	oGrp1      := TGroup():New( 008,008,084,160,"Informa��es sobre cubagem do produto",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSay1      := TSay():New( 024,024,{||"Comprimento"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet1      := TGet():New( 024,072,{|u|If(PCount()>0,nComp:=u,nComp)},oGrp1,060,008,'@E 999.99',{||nComp>0},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
		oSay2      := TSay():New( 044,024,{||"Altura"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet2      := TGet():New( 044,072,{|u|If(PCount()>0,nEspe:=u,nEspe)},oGrp1,060,008,'@E 999.99',{||nEspe>0},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
		oSay3      := TSay():New( 064,024,{||"Largura"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet3      := TGet():New( 064,072,{|u|If(PCount()>0,nLarg:=u,nLarg)},oGrp1,060,008,'@E 999.99',{||nLarg>0},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSBtn1     := SButton():New( 089,074,1,{||oDlg1:end(nOpc:=1)},oDlg1,,"", )
	
	oDlg1:Activate(,,,.T.)
EndDo

TTMata180(nComp,nEspe,nLarg)

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTCOMC04  �Autor  �Alexandre Venancio  � Data �  04/26/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gravacao das informacoes de cubagem na tabela SB5          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function TTMata180(nComp,nEspe,nLarg)

Local aCab 		:= {}
Local lBlq 		:= .F.  
Local aAreaB1	:= {}

private lMsErroAuto := .F.

aCab:= { 	{"B5_COD"  	,SB1->B1_COD  	,Nil},;	// Codigo identificador do produto
			{"B5_CEME" 	,SB1->B1_DESC  	,Nil},;// Nome cientifico do produto
			{"B5_COMPR"	,nComp			,Nil},;
			{"B5_ESPESS",nEspe			,Nil},;
			{"B5_LARG"	,nLarg			,Nil}}		

If SB1->B1_MSBLQL == "1"
	Reclock("SB1",.F.)
	SB1->B1_MSBLQL := "2"
	SB1->(Msunlock())
	lBlq	:=	.T.
EndIf

aAreaB1 := GetArea()
						
MSExecAuto({|x,y| Mata180(x,y)},aCab,3) //Inclusao   

RestArea(aAreaB1)

conout("Acabou de executar a rotina automatica do Cadastro de Complemento do Produto")

//-- Retorno de erro na execucao da rotina
If lMsErroAuto
	conout("erro")
	cErro:=MostraErro()
Else
	conout("Ok") 
	If lBlq	
		Reclock("SB1",.F.)
		SB1->B1_MSBLQL := "1"
		SB1->(Msunlock())
	EndIf
Endif  

Return