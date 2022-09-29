#include "totvs.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"
#INCLUDE "XMLXFUN.CH"  


User Function TTPROC38()

Local oBrowse
Private cCadastro := "Indicadores"

If cEmpAnt <> "01"
	return
EndIF

dbSelectArea("SX2")
SX2->(dbSetOrder(1))
If !SX2->(dbSeek("SZK"))
	ShowHelpDlg("SZK", {"Tabela: SZK" + CRLF + " N�o encontrada no cadastro de tabelas (SX2)."},5,{"N�o � poss�vel continuar."},5)							
	Return
EndIf

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SZK")
oBrowse:SetDescription(cCadastro)
             
oBrowse:AddLegend("ZK_PRAZOOK=='0'","GREEN"	,"Atendida no prazo")
oBrowse:AddLegend("ZK_PRAZOOK=='1'","RED"	,"Atendida fora do prazo")

oBrowse:Activate()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   �Autor  �Jackson E. de Deus  � Data �  07/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Define o menu do Browse.			                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()

Local aRotina	:= {}

ADD OPTION aRotina TITLE 'Pesquisar'	ACTION "PesqBrw"							OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'STATICCALL(TTPROC38, Visual)'		OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Reprocessar'	ACTION 'STATICCALL(TTPROC38, Reproc)'		OPERATION 7 ACCESS 0
ADD OPTION aRotina TITLE 'Legenda'		ACTION 'STATICCALL(TTPROC38, Legenda)'		OPERATION 6 ACCESS 0


Return(aRotina)      


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Visual     �Autor  �Jackson E. de Deus � Data �  07/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Visualiza o registro                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Visual()

Local aCampos := {"NOUSER"}	//,"ZK_NUMOS","ZK_"}

dbSelectArea("SX3")
dbSetOrder(1)
If dbSeek( "SZK" )
	While !EOF() .And. SX3->X3_ARQUIVO == "SZK"
		If AllTrim(SX3->X3_CAMPO) == "ZK_FILIAL"
			dbSkip()
			Loop
		EndIf
		AADD(aCampos, SX3->X3_CAMPO)
		dbSkip()
	End
EndIf
                        
AxVisual('SZK',Recno(),2,aCampos)   

Return

      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC38  �Autor  �Microsiga           � Data �  01/12/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Reproc()

Local aArea := GetArea()
Local aPergs	:= {}
Local aRet		:= {}
Local cNumOSDe	:= ""
Local cNumOSAte := ""
Local cRotaDe	:= ""
Local cRotaAte	:= ""
Local dDataIni	:= stod("")
Local dDataFim  := stod("")
Local aArea		:= GetArea()

// data - considerar data de encerramento
aAdd(aPergs ,{1,"OS De"		,SZK->ZK_NUMOS,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"OS Ate"	,SZK->ZK_NUMOS,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Rota De"	,Space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{1,"Rota Ate"	,Space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{1,"Data Fim De",dDatabase,"99/99/99","","","",50,.F.})
aAdd(aPergs ,{1,"Data Fim Ate",dDatabase,"99/99/99","","","",50,.F.})

If !ParamBox(aPergs ,"Reprocessamento",@aRet)
	Return                                     
Else
	cNumOSDe := aRet[1] 
	cNumOSAte := aRet[2]
	cRotaDe := aRet[3] 
	cRotaAte := aRet[4] 
	dDataIni := aRet[5]
	dDataFim := aRet[6]
EndIf		

If MsgYesNo("Confirma o reprocessamento?") 
	Processa( { || ReprocSZK(cNumOSDe,cNumOSAte,cRotaDe,cRotaAte,dDataIni,dDataFim) },"Reprocessando indicadores, aguarde.." ) 
EndIf

RestArea(aArea)
         
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC38  �Autor  �Microsiga           � Data �  01/12/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReprocSZK(cNumOSDe,cNumOSAte,cRotaDe,cRotaAte,dDataIni,dDataFim)

Local cSql := ""
Local nTot := 0

dbSelectArea("SZG")
dbSetOrder(1)

cSql := "SELECT R_E_C_N_O_ RECZG FROM " +RetSqlName("SZG") 
cSql += " WHERE "
cSql += " ZG_NUMOS BETWEEN '"+cNumOSDe+"' AND '"+cNumOSAte+"' "
cSql += " AND ZG_ROTA BETWEEN '"+cRotaDe+"' AND '"+cRotaAte+"' "
cSql += " AND ZG_DATAFIM BETWEEN '"+dtos(dDataIni)+"' AND '"+dtos(dDatafim)+"' " 
cSql += " AND ZG_STATUS = 'FIOK' AND D_E_L_E_T_ = '' "
cSql += " ORDER BY ZG_NUMOS "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

//TcQuery cSql New Alias "TRB"
dbUseArea( .T., "TOPCONN", TcGenQry(,,cSql), "TRB", .F. ,.F. )
dbSelectArea("TRB")
While !EOF()
	nTot++
	dbSkip()
End


ProcRegua(nTot)
dbGoTop()
While !EOF()
	dbSelectArea("SZG")
	dbGoTo(TRB->RECZG)
	IncProc("# OS " +AllTrim(SZG->ZG_NUMOS))
	If Recno() == TRB->RECZG
		U_TTPROC35(SZG->ZG_FILIAL,SZG->ZG_NUMOS,SZG->ZG_RESPOST,.T.)    
	EndIf            
	
	dbSelectArea("TRB")
	dbSkip()
End

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Legenda     �Autor  �Jackson E. de Deus� Data �  07/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Legenda do browse                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Legenda()

BrwLegenda(cCadastro,"Prazo",{{"BR_VERDE","Atendida no prazo"},;
							{"BR_VERMELHO","Atendida fora do prazo"} })   
Return