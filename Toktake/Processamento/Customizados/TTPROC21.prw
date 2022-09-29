#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TBICONN.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � TTPROC21 � Autor � Alexandre Venancio    � Data � 23/10/13 ���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao �  Exibe o detalhe de cada auditoria gerada para faturamento.���
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

User Function TTPROC21(aAuditc,cliente,contrato,tipo,nAd)

Local aArea		:=	GetArea()
Local aCabeca	:=	{}    
Local aLista1	:=	{}
Local aLista2	:=	{}
Local aLista3	:=	{}
Local aLista4	:=	{}
Local aLista5	:=	{}
Local aLista6	:=	{}  
Local aLinha	:=	{}
Local aAudit	:=	{}  
Local cTexto1	:=	''
Local cTexto2	:=	''
Local cTexto3	:=	''
Local cTexto4	:=	'' 
Local cTexto5	:=	''


Local oDlg5,oFld1,oS2,oBrw2,oS3,oBrw3,oS4,oBrw4,oS1,oBrw1,oGr1,oS5,oS6
Local oS7,oS8,oS9,oS10,oBt1,oBrw5,oS11

If cEmpAnt <> "01"
	return
EndIF

If nAd == 1
	aAudit 	:= {"Auditoria 1","Auditoria 2","Auditoria 3","Auditoria 4","Auditoria 5"}
	Aadd(aCabeca,{'Patrim�nio','Status'})
	Aadd(aCabeca,{'Patrim�nio','Contador Atual','Contador Anterior','Status'})
	Aadd(aCabeca,{'Patrim�nio','Soma dos Ps','Soma Atual - Anterior','Status'})
	Aadd(aCabeca,{'Patrim�nio','Total m�s','M�dia 3 meses','Status'})
	Aadd(aCabeca,{'Patrim�nio','Botao','P Atual','P Anterior','Status'})
	
	cTexto1	:=	"Verifica se o contador de todos os patrim�nios contidos no cliente foram apontados"
	cTexto2	:= 	"Verifica se o Contador Atual � Maior que o Contador Anterior"
	cTexto3	:= 	"Soma dos P�s � igual ao Contador Atual - Contador Anterior"
	cTexto4	:=	"Valida o valor apontado no periodo com a m�dia dos ultimos 3 meses"
	cTexto5 :=	"Valida se o P atual � maior que o P anterior."
	
	For nY := 1 to len(aAuditc)
		If aAuditc[nY,01] == 1 .And. aAuditc[nY,06] == contrato
			Aadd(aLista1,aAuditc[nY])
		ElseIf aAuditc[nY,01] == 2 .And. aAuditc[nY,06] == contrato
	   		Aadd(aLista2,aAuditc[nY])
		ElseIf aAuditc[nY,01] == 3 .And. aAuditc[nY,06] == contrato
			Aadd(aLista3,aAuditc[nY])
		ElseIf aAuditc[nY,01] == 4 .And. aAuditc[nY,06] == contrato
			Aadd(aLista4,aAuditc[nY])  
		ElseIf aAuditc[nY,01] == 5 .And. aAuditc[nY,06] == contrato
			Aadd(aLista5,aAuditc[nY])
		EndIf                        
	Next nY
ElseIf nAd == 2
	aAudit 	:= {"Auditoria 1","Auditoria 2"}
	Aadd(aCabeca,{'Patrim�nio','P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12'})
	Aadd(aCabeca,{'Produto','Descri��o','Pre�o Atual PE','Pre�o Atual PP','Ultimo Pre�o PE','Ultimo Pre�o PP'})
	cTexto1	:=	"Todos os Patrim�nios est�o com os Bot�es Preenchidos"
	cTexto2	:= 	"Compara��o do pre�o de tabela neste faturamento com o anterior"
   
	For nX := 1 to len(aVlUnit)
		If aVlUnit[nX,01] == contrato
			Aadd(aLista1,{aVlUnit[nX,02],aVlUnit[nX,04],aVlUnit[nX,08],aVlUnit[nX,12],aVlUnit[nX,16],aVlUnit[nX,20],;
							aVlUnit[nX,24],aVlUnit[nX,28],aVlUnit[nX,32],aVlUnit[nX,36],aVlUnit[nX,40],aVlUnit[nX,44],aVlUnit[nX,48]})
		EndIf
	Next nX
	
	For nX := 1 to len(aAudPrM)
	   	If aAudPrM[nX,01] == contrato
	   		Aadd(aLista2,{aAudPrM[nX,02],aAudPrM[nX,06],aAudPrM[nX,03],aAudPrM[nX,09],aAudPrM[nX,04],aAudPrM[nX,10]})
	   	EndIf
	Next nX
ElseIf nAd == 3
	aAudit 	:= {"Auditoria 1","Auditoria 2"}
	Aadd(aCabeca,{'Patrim�nio','LOG'})
	Aadd(aCabeca,{'Patrim�nio','LOG','Ps Apontados'})
	cTexto1	:=	"Todos os Patrim�nios est�o com os Logs Apontados"
	cTexto2 :=	"Valida��o entre a quantidade de consumo no Ccart�es e os Ps apontados"

	For nX := 1 to len(aCcart4)
		If aCcart4[nX,01] == contrato
			Aadd(aLista1,{aCcart4[nX,02],aCcart4[nX,03]})
			 
			Aadd(aLista2,{aCcart4[nX,02],aCcart4[nX,03],0})
			For nP := 1 to len(aConta)
				If aConta[nP,01] == contrato .And. aConta[nP,06] == aCcart4[nX,02]
					aLista2[len(aLista2),03] += aConta[nP,12] - aConta[nP,15]
				EndIf
			Next nP
		EndIf
	Next nX 
ElseIf nAd == 4
	aAudit 	:= {"Auditoria 1","Auditoria 2"}
	Aadd(aCabeca,{'Patrim�nio','Cedulas e Moedas','Moeda Eletr�nica','Total','P�s X Pre�o Publico'})
	Aadd(aCabeca,{'Patrim�nio','Contador Cash','P�s X Pre�o Publico'})
	cTexto1	:=	"Sangrias + Moeda Eletr�nica X Pre�o Publico"
	cTexto2 :=	"Contador Cash X Pre�o Publico"

	For nX := 1 to len(aAuditc)
		If aAuditc[nX,10] == contrato
			Aadd(aLista1,{aAuditc[nX,01],aAuditc[nX,02],aAuditc[nX,03],aAuditc[nX,02]+aAuditc[nX,03],aAuditc[nX,05]})
			 
			Aadd(aLista2,{aAuditc[nX,01],aAuditc[nX,04],aAuditc[nX,05]})
		EndIf
	Next nX	
EndIf

If len(aLista1) < 1
	Aadd(aLista1,{'Sem Registro','','','','','','','','','','',''})
EndIf

If len(aLista2) < 1
	Aadd(aLista2,{'Sem Registro','','','','',''})
EndIf

If len(aLista3) < 1
	Aadd(aLista3,{'Sem Registro','','','','',''})
EndIf

If len(aLista4) < 1
	Aadd(aLista4,{'Sem Registro','','','','',''})
EndIf    

If len(aLista5) < 1
	Aadd(aLista5,{'Sem Registro','','','','',''})
EndIf    

//Prepare Environment Empresa "01" Filial "01" Tables "SZN"

oDlg5      := MSDialog():New( 083,252,649,800,"Auditoria - X",,,.F.,,,,,,.T.,,,.T. )
    

	oGr1    := TGroup():New( 008,016,064,252,"Contrato",oDlg5,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oS5      := TSay():New( 024,032,{||"Cliente"},oGr1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oS6	     := TSay():New( 024,060,{||cliente},oGr1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)
	oS7      := TSay():New( 044,028,{||"Contrato"},oGr1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oS8      := TSay():New( 044,052,{||contrato},oGr1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
	oS9      := TSay():New( 044,128,{||"Tipo Contrato"},oGr1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oS10     := TSay():New( 044,164,{||tipo},oGr1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)

	oFld1    := TFolder():New( 076,016,aAudit,{},oDlg5,,,,.T.,.F.,236,172,) 
	
	If nAd == 1
		oS1      := TSay():New( 008,012,{||cTexto1},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,020)
		
		oS2      := TSay():New( 008,036,{||cTexto2},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,152,008)
		
		oS3      := TSay():New( 008,040,{||cTexto3},oFld1:aDialogs[3],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,144,008)
		
		oS4      := TSay():New( 008,028,{||cTexto4},oFld1:aDialogs[4],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,168,008)  
		
		oS11     := TSay():New( 008,028,{||cTexto5},oFld1:aDialogs[5],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,168,008)  
	ElseIf nAd == 2
		oS1      := TSay():New( 008,012,{||cTexto1},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,020)
		
		oS2      := TSay():New( 008,036,{||cTexto2},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,020) 
	ElseIf nAd == 3
		oS1      := TSay():New( 008,012,{||cTexto1},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,020)
		                                                                                                                 
		oS2      := TSay():New( 008,036,{||cTexto2},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,020) 
	ElseIf nAd == 4
		oS1      := TSay():New( 008,012,{||cTexto1},oFld1:aDialogs[1],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,020)
		                                                                                                                 
		oS2      := TSay():New( 008,036,{||cTexto2},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,020) 
	EndIf
	
	If nAd == 1
		For nX := 1 to 5
			&("oBrw"+cvaltochar(nX)) := TCBrowse():New(028,016,205,120,, aCabeca[nX],{30,30,30,30,30,30},;
			   									oFld1:aDialogs[nX],,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
		Next nX	 
			
		&("oBrw"+cvaltochar(1)):SetArray(aLista1)
		&("oBrw"+cvaltochar(1)):bLine := {||{ aLista1[&("oBrw"+cvaltochar(1)):nAt,02],; 
												aLista1[&("oBrw"+cvaltochar(1)):nAt,05]}} 
	
		&("oBrw"+cvaltochar(2)):SetArray(aLista2)
		&("oBrw"+cvaltochar(2)):bLine := {||{ aLista2[&("oBrw"+cvaltochar(2)):nAt,02],; 
												aLista2[&("oBrw"+cvaltochar(2)):nAt,03],;
												aLista2[&("oBrw"+cvaltochar(2)):nAt,04],;
						 						aLista2[&("oBrw"+cvaltochar(2)):nAt,05]}} 
	
		&("oBrw"+cvaltochar(3)):SetArray(aLista3)
		&("oBrw"+cvaltochar(3)):bLine := {||{ aLista3[&("oBrw"+cvaltochar(3)):nAt,02],; 
												aLista3[&("oBrw"+cvaltochar(3)):nAt,03],;
												aLista3[&("oBrw"+cvaltochar(3)):nAt,04],;
						 						aLista3[&("oBrw"+cvaltochar(3)):nAt,05]}} 
	
		&("oBrw"+cvaltochar(4)):SetArray(aLista4)
		&("oBrw"+cvaltochar(4)):bLine := {||{ aLista4[&("oBrw"+cvaltochar(4)):nAt,02],; 
												aLista4[&("oBrw"+cvaltochar(4)):nAt,03],;
												aLista4[&("oBrw"+cvaltochar(4)):nAt,04],;
						 						aLista4[&("oBrw"+cvaltochar(4)):nAt,05]}} 

		&("oBrw"+cvaltochar(5)):SetArray(aLista5)
		&("oBrw"+cvaltochar(5)):bLine := {||{ aLista5[&("oBrw"+cvaltochar(5)):nAt,02],;
		 										aLista5[&("oBrw"+cvaltochar(5)):nAt,07],;
												aLista5[&("oBrw"+cvaltochar(5)):nAt,03],;
												aLista5[&("oBrw"+cvaltochar(5)):nAt,04],;
						 						aLista5[&("oBrw"+cvaltochar(5)):nAt,05]}} 
	
	ElseIf nAd == 2
		For nX := 1 to 2
			&("oBrw"+cvaltochar(nX)) := TCBrowse():New(028,016,205,120,, aCabeca[nX],{30,30,30,30,30,30,30,30,30,30,30,30,30,30},;
			   									oFld1:aDialogs[nX],,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
		Next nX

		&("oBrw"+cvaltochar(1)):SetArray(aLista1)
		&("oBrw"+cvaltochar(1)):bLine := {||{ aLista1[&("oBrw"+cvaltochar(1)):nAt,01],; 
												aLista1[&("oBrw"+cvaltochar(1)):nAt,02],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,03],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,04],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,05],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,06],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,07],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,08],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,09],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,10],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,11],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,12],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,13]}} 
	
		&("oBrw"+cvaltochar(2)):SetArray(aLista2)
		&("oBrw"+cvaltochar(2)):bLine := {||{ aLista2[&("oBrw"+cvaltochar(2)):nAt,01],; 
												aLista2[&("oBrw"+cvaltochar(2)):nAt,02],;
												aLista2[&("oBrw"+cvaltochar(2)):nAt,03],;
						 						aLista2[&("oBrw"+cvaltochar(2)):nAt,04],;
						 						aLista2[&("oBrw"+cvaltochar(2)):nAt,05],;
						 						aLista2[&("oBrw"+cvaltochar(2)):nAt,06]}} 

	ElseIf nAd == 3
		For nX := 1 to 2
			&("oBrw"+cvaltochar(nX)) := TCBrowse():New(028,016,205,120,, aCabeca[nX],{30,30,30,30,30,30,30,30,30,30,30,30,30,30},;
			   									oFld1:aDialogs[nX],,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
		Next nX

		&("oBrw"+cvaltochar(1)):SetArray(aLista1)
		&("oBrw"+cvaltochar(1)):bLine := {||{ aLista1[&("oBrw"+cvaltochar(1)):nAt,01],; 
												aLista1[&("oBrw"+cvaltochar(1)):nAt,02]}}
												
		&("oBrw"+cvaltochar(2)):SetArray(aLista2)
		&("oBrw"+cvaltochar(2)):bLine := {||{ aLista2[&("oBrw"+cvaltochar(2)):nAt,01],; 
												aLista2[&("oBrw"+cvaltochar(2)):nAt,02],;
												aLista2[&("oBrw"+cvaltochar(2)):nAt,03]}}
												
	ElseIf nAd == 4
		For nX := 1 to 2
			&("oBrw"+cvaltochar(nX)) := TCBrowse():New(028,016,205,120,, aCabeca[nX],{30,30,30,30,30,30,30,30,30,30,30,30,30,30},;
			   									oFld1:aDialogs[nX],,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
		Next nX

		&("oBrw"+cvaltochar(1)):SetArray(aLista1)
		&("oBrw"+cvaltochar(1)):bLine := {||{ aLista1[&("oBrw"+cvaltochar(1)):nAt,01],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,02],; 
												aLista1[&("oBrw"+cvaltochar(1)):nAt,03],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,04],;
												aLista1[&("oBrw"+cvaltochar(1)):nAt,05]}}
												
		&("oBrw"+cvaltochar(2)):SetArray(aLista2)
		&("oBrw"+cvaltochar(2)):bLine := {||{ aLista2[&("oBrw"+cvaltochar(2)):nAt,01],; 
												aLista2[&("oBrw"+cvaltochar(2)):nAt,02],;
												aLista2[&("oBrw"+cvaltochar(2)):nAt,03]}}
												
	EndIf
	
	oBt1      := TButton():New( 256,108,"Sair",oDlg5,{||oDlg5:end()},037,012,,,,.T.,,"",,,,.F. )

oDlg5:Activate(,,,.T.)

RestArea(aArea)

Return