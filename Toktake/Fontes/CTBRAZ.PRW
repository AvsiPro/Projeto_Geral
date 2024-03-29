#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ�
��Programa  �CTBRAZ    �Autor  �Ricardo Souza        � Data �13/03/10      ��
��������������������������������������������������������������������������͹�
��Desc.     �Rotina respons�vel pela gera��o de planilha em excel   	   ��
��          �do Raz�o Cont�bil 										       ��
��������������������������������������������������������������������������͹�
��Alterado por      � Data     � Motivo                                    ��
��������������������������������������������������������������������������Ĵ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTBRAZx()

Local aArea     := GetArea()
Local cTitulo	:= "Raz�o Cont�bil"
Local cText1	:= "Esta rotina tem como objetivo gerar um arquivo em excel "
Local cText2	:= "do Raz�o Cont�bil. "
Local nOpcA		:= 0
Local aSays		:= {}
Local aButtons	:= {}
Local nOpc	  	:=1	
Local oDlg

Private	cPerg   := "CTBRAZ"

//����������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                     �
//� mv_par01            // Data de                           �
//� mv_par02            // Data ate                          �
//� mv_par03            // Conta de                          �
//� mv_par04            // Conta at�                         �
//������������������������������������������������������������

ValidPerg()
pergunte(cPerg,.F.)

While .T.

	AADD(aSays,OemToAnsi( cText1 ) )
	AADD(aSays,OemToAnsi( cText2 ) )
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	FormBatch( cTitulo, aSays, aButtons )
       
	Do Case
	   Case nOpca ==1
  	 	    //������������������������������������������������������������������������Ŀ
			//�Preparacao do inicio de processamento do arquivo pre-formatado          �
		  	//��������������������������������������������������������������������������
			
			Processa({||CTBRAZA()})
			
	   Case nOpca==3
			Pergunte(cPerg,.T.)
			Loop
	EndCase
	Exit
EndDo              

Aviso("Termino",OemToAnsi("Processo Concluido !"),{"Ok"})

RestArea(aArea)
Return()


//����������������������������Ŀ
//�Chamada da funcao principal.�
//������������������������������
Static Function CTBRAZA()

Local cQuery := " "
Local cPath  := " "
Local cArq   := " "
Local aStru  := {} 

//Geral Excel de movimentacao de estoque

//Carrego o path de onde sera gerado o arquivo em execel
cPath	:= cGetFile("","Local",0,"",.T.,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)
cPath   += IIf( Right( AllTrim( cPath ), 1 ) <> '\' , '\', '' )
cARQ    := ALLTRIM(cPath)+"RAZCTB"+Substr(dtos(date()),7,2)+"_"+Substr(dtos(date()),5,2)+"_"+Substr(dtos(date()),3,2)+".XLS"
ARQUIVO := "\RAZCTB"+Substr(dtos(date()),7,2)+"_"+Substr(dtos(date()),5,2)+"_"+Substr(dtos(date()),3,2)+".XLS"


IncProc("Processando CtbRaz, aguarde... ")

cQuery := "SELECT "
cQuery += "CT2_FILORI as FILIAL, " 
cQuery += "SUBSTRING(CT2_DATA, 7, 2) + '/' + SUBSTRING(CT2_DATA, 5, 2) + '/' + SUBSTRING(CT2_DATA, 1, 4) as EMISSAO, "
cQuery += "CT2_LOTE as LOTE, CT2_SBLOTE as SBLOTE, CT2_DOC as DOC, CT2_LINHA as LINHA,   "
cQuery += "CT2_DEBITO as DEBITO, CT1.CT1_DESC01 AS DESC_DEB, CT2_CREDIT as CREDITO, CT1_1.CT1_DESC01 AS DESC_CRED, CT2_ATIVDE as ATIVDE, CT2_ATIVCR as ATIVCR,   "
cQuery += "'VRDEB' = CASE WHEN CT2_DEBITO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' THEN CT2_VALOR ELSE 0 END, "
cQuery += "'VRCRED' = CASE WHEN CT2_CREDIT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' THEN CT2_VALOR ELSE 0 END,   "
cQuery += "CT2_CCD AS CC_DEB, CT2_CCC AS CC_CRED, CT2_ITEMD AS ITEM_DEB, CT2_ITEMC AS ITEM_CRED, CT2_HIST AS HIST1, CT2_KEY AS CHAVE,  CT2_ORIGEM AS ORIGEM, CT2_ROTINA AS ROTINA, CT2_LP AS LP "
cQuery += "FROM "+retsqlname("CT2")+" AS CT2 LEFT OUTER JOIN "
cQuery += ""+retsqlname("CT1")+" AS CT1_1 ON CT2.CT2_CREDIT = CT1_1.CT1_CONTA AND CT2.D_E_L_E_T_ = CT1_1.D_E_L_E_T_ LEFT OUTER JOIN "
cQuery += ""+retsqlname("CT1")+" AS CT1 ON CT2.CT2_DEBITO = CT1.CT1_CONTA AND CT2.D_E_L_E_T_ = CT1.D_E_L_E_T_ "
cQuery += "WHERE "
cQuery += "CT2.D_E_L_E_T_ <> '*' AND   "
cQuery += "CT2_FILIAL='"+xFilial("CT2")+"' AND   "
cQuery += "(CT2_DEBITO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' OR CT2_CREDIT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' ) AND  "
cQuery += "(CT2_CCD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' OR CT2_CCC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' ) AND  "
cQuery += "CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
cQuery += "ORDER BY CT2_DATA, CT2_DEBITO, CT2_CREDIT, CT2_HIST"

Query := ChangeQuery(cQuery)           	

MemoWrite( "RAZCTB.SQL" , cQuery ) //Grava a Query

If Select("QUERY") > 0
   DbSelectArea("QUERY")
   DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "QUERY"

AADD(aStru, {"FILIAL"  			,"C",02,0})
AADD(aStru, {"EMISSAO" 		   	,"C",10,0})
AADD(aStru, {"LOTE"  			,"C",06,0})
AADD(aStru, {"SBLOTE"  			,"C",03,0})
AADD(aStru, {"DOC"  			,"C",06,0})
AADD(aStru, {"LINHA"  			,"C",03,0})
AADD(aStru, {"DEBITO"    		,"C",15,0})
AADD(aStru, {"DESC_DEB"    		,"C",40,0})
AADD(aStru, {"CREDITO"    		,"C",15,0})
AADD(aStru, {"DESC_CRED"   		,"C",40,0})
AADD(aStru, {"ATIVDE"    		,"C",40,0})
AADD(aStru, {"ATIVCR"    		,"C",40,0})
AADD(aStru, {"VRDEB"  			,"N",20,6})
AADD(aStru, {"VRCRED"  			,"N",20,6})
AADD(aStru, {"CC_DEB"    		,"C",09,0})
AADD(aStru, {"CC_CRED"    		,"C",09,0})
AADD(aStru, {"ITEM_DEB"    		,"C",09,0})
AADD(aStru, {"ITEM_CRED"   		,"C",09,0})
AADD(aStru, {"HIST1"  			,"C",40,0})
AADD(aStru, {"CHAVE"  			,"C",30,0})
AADD(aStru, {"ORIGEM"  			,"C",100,0})
AADD(aStru, {"ROTINA"  			,"C",10,0})
AADD(aStru, {"LP"  				,"C",03,6})


_cArq:=Criatrab(aStru,.T.)

DBUSEAREA(.T.,,_cArq,"TRB")

DBSELECTAREA("QUERY")
ProcRegua(RecCount())
DBGOTOP()

While QUERY->(!Eof())
        
		IncProc("Processando RazCTB "+QUERY->EMISSAO+" - "+QUERY->LOTE)

		AADD(aStru, {"FILIAL"  			,"C",02,0})
		AADD(aStru, {"EMISSAO" 		   	,"C",10,0})
		AADD(aStru, {"LOTE"  			,"C",06,0})
		AADD(aStru, {"SBLOTE"  			,"C",03,0})
		AADD(aStru, {"DOC"  			,"C",06,0})
		AADD(aStru, {"LINHA"  			,"C",03,0})
		AADD(aStru, {"DEBITO"    		,"C",15,0})
		AADD(aStru, {"DESC_DEB"    		,"C",40,0})
		AADD(aStru, {"CREDITO"    		,"C",15,0})
		AADD(aStru, {"DESC_CRED"   		,"C",40,0})
		AADD(aStru, {"ATIVDE"    		,"C",40,0})
		AADD(aStru, {"ATIVCR"    		,"C",40,0})
		AADD(aStru, {"VRDEB"  			,"N",20,6})
		AADD(aStru, {"VRCRED"  			,"N",20,6})
		AADD(aStru, {"CC_DEB"    		,"C",09,0})
		AADD(aStru, {"CC_CRED"    		,"C",09,0})
		AADD(aStru, {"ITEM_DEB"    		,"C",09,0})
		AADD(aStru, {"ITEM_CRED"   		,"C",09,0})
		AADD(aStru, {"HIST1"  			,"C",40,0})
		AADD(aStru, {"CHAVE"  			,"C",30,0})
		AADD(aStru, {"ORIGEM"  			,"C",100,0})
		AADD(aStru, {"ROTINA"  			,"C",10,0})
		AADD(aStru, {"LP"  				,"C",03,6})
		
				
        DBSELECTAREA("TRB")
        RECLOCK("TRB",.T.)
         TRB->FILIAL      		:= QUERY->FILIAL  
         TRB->EMISSAO  			:= QUERY->EMISSAO
         TRB->LOTE	  			:= QUERY->LOTE
         TRB->SBLOTE 	    	:= QUERY->SBLOTE          
         TRB->DOC       		:= QUERY->DOC        
         TRB->LINHA		     	:= QUERY->LINHA
         TRB->DEBITO  			:= QUERY->DEBITO        
         TRB->DESC_DEB 			:= QUERY->DESC_DEB                 
         TRB->CREDITO     		:= QUERY->CREDITO                    
         TRB->DESC_CRED			:= QUERY->DESC_CRED
         TRB->ATIVDE  			:= QUERY->ATIVDE        
         TRB->ATIVCR     		:= QUERY->ATIVCR                   
         TRB->VRDEB  			:= QUERY->VRDEB        
         TRB->VRCRED     		:= QUERY->VRCRED   
         TRB->CC_DEB 			:= QUERY->CC_DEB
         TRB->CC_CRED 			:= QUERY->CC_CRED
         TRB->ITEM_DEB 			:= QUERY->ITEM_DEB
         TRB->ITEM_CRED			:= QUERY->ITEM_CRED                                    
		 TRB->HIST1  			:= QUERY->HIST1        
         TRB->CHAVE   			:= QUERY->CHAVE
         TRB->ORIGEM   			:= QUERY->ORIGEM
         TRB->ROTINA   			:= QUERY->ROTINA
         TRB->LP	   			:= QUERY->LP                           
         MSUNLOCK()       

     DbSelectArea("QUERY")
     DBSKIP()                      

EndDo

DBSELECTAREA("TRB")
  
IF FILE(ARQUIVO)
   DELETE FILE(ARQUIVO) 
ENDIF
COPY TO &ARQUIVO
//direciona o arquivo para o \temp  do path c:\windows\
IF FILE(ARQUIVO)
   COPY FILE &ARQUIVO TO &cARQ
ENDIF
//carrega o excel com o arquivo gerado, para isso, colocar o excel no path da maquina.
WINEXEC("EXCEL "+ALLTRIM(cARQ),1)

dbSelectArea("TRB")
DBCLOSEAREA() 

Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor �                    � Data �  02/10/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg()

//          Grupo/Ordem/Pergunta              /Variavel/      Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01      /Cnt01/ Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/X1_F3
PutSx1(cPerg,"01","Data de   ?","","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Data ate  ?","","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Conta De  ? ","","","MV_CH3","C",20,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","CT1")
PutSx1(cPerg,"04","Conta Ate ? ","","","MV_CH4","C",20,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","CT1")
PutSx1(cPerg,"05","Centro Custo De  ? ","","","MV_CH5","C",09,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","CTT")
PutSx1(cPerg,"06","Centro Custo Ate ? ","","","MV_CH6","C",09,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","CTT")

Return Nil
                    
