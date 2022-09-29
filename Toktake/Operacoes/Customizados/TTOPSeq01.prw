#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTOPSEQ01 �Autor  �Alexandre Venancio  � Data �  24/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza a sequencia/hora de atendimentos do patrimonio.	  ���
���          �															  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Alexandre       �24/03/14�01.00 |Criacao                               ��� 
���Jackson	       �07/07/14�01.00 |Alteracao - Criacao de novas colunas  ���
���									na tela de sequencias e opcao para	  ���
���									manutencao dos horarios da ROTA		  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function TTOPSeq01(cRota,aAux)
 
Local aArea	:=	GetArea()
Local nOpc	:=	0 
Local aRet	:=	{}  
Local nOrdem:=	0
Local nI
Local cSrv := "<strong><font size=3 color=black>Tipo de Servi�o</strong>"
Private cDescSrv := ""
Default cRota := ""
Default aAux := {} 

If Empty(cRota) .Or. Len(aAux) == 0
	Return aRet
EndIf

SetPrvt("oTela","oGrupo","oBrowse","Botao1","Botao2")       
Private aItens	:=	{}

//nOrdem := fopcao() 
//Prepare Environment Empresa "01" FILIAL "01" 
                      
//Aadd(aItens,{'','','3','',''})

For nX := 1 to len(aAux)
	aAux[nX][5] := StrZero(Val(aAux[nX][5]),3)
	Aadd(aItens,aAux[nX])
Next nX

//Asort(aItens,,,{|x,y| cvaltochar(Strzero(val(x[3]),2)) < cvaltochar(Strzero(val(y[3]),2))})

oTela      := MSDialog():New( 088,232,494,1200,"Sequencia de atendimento",,,.F.,,,,,,.T.,,,.T. )
oGrupo      := TGroup():New( 015,004,176,480,"Sequencia",oTela,CLR_BLACK,CLR_WHITE,.T.,.F. )
     
	oSrv := TSay():New( 005,005,{ || cSrv },oTela,,,.F.,.F.,.F.,.T.,,,060,010,,,,,,.T.)
	oDescSrv := TSay():New( 005,065,{ || cDescSrv },oTela,,,.F.,.F.,.F.,.T.,,,350,010,,,,,,.T.)

	oBrowse := TCBrowse():New(022,008,470,150,, {'Patrimonio','Modelo','Endereco','Local fisico','Sequencia'/*,'Horario'*/},{40,110,110,90,35,35},;
	                            oGrupo,,,,{|| fHelp(oBrowse:nAt) },{|| editcol(oBrowse:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oBrowse:SetArray(aItens)
	oBrowse:bLine := {||{aItens[oBrowse:nAt,01],; 
	 					 aItens[oBrowse:nAt,02],;
	 					 aItens[oBrowse:nAt,08] +" / " +aItens[oBrowse:nAt,9] +" / " +aItens[oBrowse:nAt,10],;
	 					 aItens[oBrowse:nAt,11],;
	 					 aItens[oBrowse:nAt,05] }}
	 					 //aItens[oBrowse:nAt,12] }}  
	 					 	 

//Btn		:= TButton():New( 184,005,"Sugerir horarios",oTela,{|| Horario(@aItens,cRota) },050,012,,,,.T.,,"",,,,.F. )
Btn2	:= TButton():New( 184,005,"Horarios",oTela,{|| U_TTOPER08(aItens,cRota) },050,012,,,,.T.,,"",,,,.F. )	 	 					 
Botao1	:= TButton():New( 184,400,"Confirmar",oTela,{||oTela:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
Botao2	:= TButton():New( 184,440,"Cancelar",oTela,{||oTela:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

oTela:Activate(,,,.T.)

If nOpc == 1
	aRet	:=	aClone(aItens)
Else
	aRet	:=	aClone(aAux)	
EndIf
//Reset Environment

RestArea(aArea)   

Return(aRet)                 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTOPSEQ01 �Autor  �Microsiga           � Data �  03/24/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function editcol(nLinha)

Local cConteudo	:=	aItens[nLinha,05]

lEditcell(aItens,oBrowse,"@R 999",5)


Return              

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTOPSEQ01 �Autor  �Microsiga           � Data �  03/25/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fopcao() 
           
Local oDlgx 

DEFINE DIALOG oDlgx TITLE "Op��o" FROM 070,070 TO 160,220 PIXEL    

nRadio := 1                         
aItems := {'Ordenado por Dia','Ordenado por Semana'}    
oRadio := TRadMenu():New (01,01,aItems,,oDlgx,,,,,,,,110,10,,,,.T.)     
oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}	 
Botao3      := TButton():New( 025,025,"Confirmar",oDlgx,{||oDlgx:end()},030,010,,,,.T.,,"",,,,.F. )
 
ACTIVATE DIALOG oDlgx CENTERED   

Return(nRadio)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fHelp �Autor  �Jackson E. de Deus      � Data �  11/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza descricao dos tipos de servico do patrimonio      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fHelp(nLinha)
      
cDescSrv := "<strong><font size=3 color=#EE6363>"  +aItens[nLinha][12] + "</strong>"
oDescSrv:Refresh() 

Return