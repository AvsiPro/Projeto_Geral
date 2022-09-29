#include "protheus.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC14  �Autor  �Alexandre Venancio  � Data �  06/20/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de importacao de contadores de maquinas MVC	      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTPROC14() 

Local aSay := {}
Local aButton := {}
Local nOpc := 0
Local Titulo := 'IMPORTACAO DE PLANILHA DE CONTADORES DE MAQUINAS'
Local cDesc1 := 'Esta rotina far� a importa��o dos dados de invent�rio'
Local cDesc2 := 'conforme layout.'
Local cDesc3 := ''
Local lOk := .T.                  
Local aRegs	:= {}
Private cPergCal    := "TTPROC11"   

If cEmpAnt <> "01"
	return
EndIF

aAdd(aRegs,{cPergCal,"01","Arquivo      ?","","","mv_ch1","C",99,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","DIR",""})

ValidPerg(aRegs,cPergCal) 
Pergunte(cPergCal,.F.)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch() } } ) 
aAdd( aButton, { 5, .T., { || Pergunte(cPergCal,.T. ) } } )

FormBatch( Titulo, aSay, aButton )

If nOpc == 1
	Processa( { || lOk := Runproc() },'Aguarde','Processando...',.F.)
	If lOk
		ApMsgInfo( 'Processamento terminado com sucesso.', 'ATEN��O' )
	Else
		ApMsgStop( 'Processamento realizado com problemas.', 'ATEN��O' )
	EndIf
EndIf    

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC14  �Autor  �Microsiga           � Data �  06/20/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina Auxiliar de Importa��o                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Runproc()

Local lRet := .T.

Local aCposCab := {} 
Local aCposDet := {}
Local aAux	:=	{}           
Local nCont	:=	1 
Local aCabec:= {}                                                          
Local nHandle 	:= FT_FUse(MV_PAR01)
Local cCli		:=	''
Local cLoj		:=	''    
Local _BCli		:=	''  

// Posiciona na primeria linha
FT_FGoTop()

If nHandle < 0
	MsgAlert("Arquivo n�o encontrado","TTPROC14")
	Return(.F.)
EndIf

// Criamos um vetor com os dados para facilitar o manuseio dos dados
aCampos := {}

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	aAux    := StrTokArr(cLine,";")                    
    If nCont > 1
    	If Empty(aAux[5]) .Or. aAux[5] == "0"
    		MsgAlert("Patrimonio inv�lido na linha "+cvaltochar(nCont),"TTPROC14")
    	EndIf
    	
		aCabec 		:= {}
		aCposDet 	:= {}    
		aCposCab 	:= {} 
		
		If Alltrim(aAux[1]) == "0"
			_BCli 	:= 	BuscaCli(aAux[5])
			cCli	:=	substr(_BCli,1,6)
			cLoj	:=	substr(_BCli,7,4)
		Else
			cCli	:=	aAux[1]
			cLoj	:=	aAux[2]
		EndIf
    //    cCli    	:=	If(Alltrim(aAux[1]) == "0",Posicione("SN1",2,xFilial("SN1")+AvKey(aAux[5],"N1_CHAPA"),"N1_XCLIENT"),aAux[1])
      //  cLoj		:=	If(Alltrim(aAux[2]) == "0",Posicione("SN1",2,xFilial("SN1")+AvKey(aAux[5],"N1_CHAPA"),"N1_XLOJA"),aAux[2])
        
        If Posicione("SA1",1,xFilial("SA1")+cCli+cLoj,"A1_MSBLQL") == "1"
        	DbSelectArea("SA1")
        	DbSetOrder(1)
        	If DbSeek(xFilial("SA1")+cCli+cLoj)
        		Reclock("SA1",.F.)
        		SA1->A1_MSBLQL	:=	"2"
        		SA1->(Msunlock())
        	EndIf
        	MsgAlert("O Cliente c�digo "+cCli+cLoj+" estava bloqueado e foi desbloqueado automaticamente para importa��o dos contadores.","TTPROC14")
        EndIf
        	
        If Empty(cCli)
        	nCont++
			FT_FSKIP()
			loop
		EndIf
		
		//indice 2 filial data patrimonio tipo de inclusao
		DbSelectArea("SZN")
		DbSetOrder(2)
		If Dbseek(xFilial("SZN")+Dtos(ctod(aAux[4]))+AvKey(aAux[5],"N1_CHAPA")+'FECHAMENTO')
			nCont++
			FT_FSKIP()
			loop
		EndIf
		
    	Aadd(aCposCab,{'ZN_CLIENTE'	,cvaltochar(Strzero(val(cCli),6))})
    	Aadd(aCposCab,{'ZN_LOJA'	,cvaltochar(Strzero(val(cLoj),4))})
    	Aadd(aCposCab,{'ZN_CODPA'	,If(aAux[3]=="0","",aAux[3])})
        
		aAdd( aCabec, {'ZN_TIPINCL'	,'Imp. Excel'		})
    	aAdd( aCabec, {'ZN_DATA'	,ctod(aAux[4])		})
    	aAdd( aCabec, {'ZN_PATRIMO'	,aAux[5]			})
    	aAdd( aCabec, {'ZN_NUMATU'	,Val(aAux[6])		})
    	aAdd( aCabec, {'ZN_COTCASH'	,val(Strtran(aAux[7],",","."))		})
    	aAdd( aCabec, {'ZN_BOTTEST'	,Val(aAux[8])		})
    	aAdd( aCabec, {'ZN_BOTAO01'	,Val(aAux[9])		})
    	aAdd( aCabec, {'ZN_BOTAO02'	,Val(aAux[10])		})
    	aAdd( aCabec, {'ZN_BOTAO03'	,Val(aAux[11])		})
    	aAdd( aCabec, {'ZN_BOTAO04'	,Val(aAux[12])		})
    	aAdd( aCabec, {'ZN_BOTAO05'	,Val(aAux[13])		})
    	aAdd( aCabec, {'ZN_BOTAO06'	,Val(aAux[14])		})
    	aAdd( aCabec, {'ZN_BOTAO07'	,Val(aAux[15])		})
    	aAdd( aCabec, {'ZN_BOTAO08'	,Val(aAux[16])		})
    	aAdd( aCabec, {'ZN_BOTAO09'	,Val(aAux[17])		})
    	aAdd( aCabec, {'ZN_BOTAO10'	,Val(aAux[18])		})
    	aAdd( aCabec, {'ZN_BOTAO11'	,Val(aAux[19])		})
    	aAdd( aCabec, {'ZN_BOTAO12'	,Val(aAux[20])		})
    	/*aAdd( aCabec, {'ZN_LACRMOE'	,If(aAux[21]=="0","",aAux[21])})
		aAdd( aCabec, {'ZN_LACRCED'	,If(aAux[22]=="0","",aAux[22])})
		aAdd( aCabec, {'ZN_MOEDA05'	,Val(aAux[23])		})
		aAdd( aCabec, {'ZN_MOEDA10'	,Val(aAux[24])		})
		aAdd( aCabec, {'ZN_MOEDA25'	,Val(aAux[25])		})
		aAdd( aCabec, {'ZN_MOEDA50'	,Val(aAux[26])		})
		aAdd( aCabec, {'ZN_MOEDA1R'	,Val(aAux[27])		})
		aAdd( aCabec, {'ZN_BANANIN'	,If(aAux[28]=="0","",aAux[28])})	
		aAdd( aCabec, {'ZN_LACCMOE'	,If(aAux[29]=="0","",aAux[29])})
		aAdd( aCabec, {'ZN_LACCCED'	,If(aAux[30]=="0","",aAux[30])})
		aAdd( aCabec, {'ZN_CARCOMR'	,If(aAux[31]=="0","",aAux[31])})
		aAdd( aCabec, {'ZN_CARCOMC'	,If(aAux[32]=="0","",aAux[32])})
		aAdd( aCabec, {'ZN_LOGC01'	,If(aAux[33]=="0","",aAux[33])})
		aAdd( aCabec, {'ZN_LOGC02'	,If(aAux[34]=="0","",aAux[34])})
		aAdd( aCabec, {'ZN_LOGC03'	,If(aAux[35]=="0","",aAux[35])})
		aAdd( aCabec, {'ZN_LOGC04'	,If(aAux[36]=="0","",aAux[36])})
		aAdd( aCabec, {'ZN_LOGC05'	,If(aAux[37]=="0","",aAux[37])})*/
		aAdd( aCabec, {'ZN_HORA'	,If(aAux[21]=="0","",aAux[21])})

    	Aadd( aCposDet, aCabec )
    	
	   	If !Import( 'SZN','SZN', aCposCab, aCposDet)
			lRet := .F.
		Else 
			Reclock("SZN",.F.)
			SZN->ZN_LOJA := cLoj
			SZN->(Msunlock())
			aCposDet := {}    
			aCposCab := {}
		EndIf	
    EndIF
 	nCont++
	FT_FSKIP()
End


Return lRet 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC14  �Autor  �Microsiga           � Data �  06/21/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida os dados e importa para as tabelas se estiver tudo  ���
���          �certo                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Import( cMaster, cDetail, aCpoMaster, aCpoDetail  )

Local oModel, oAux, oStruct
Local nI := 0
Local nJ := 0
Local nPos := 0
Local lRet := .T.
Local aAux := {}  
Local aC   := {}
Local aH   := {}
Local nItErro := 0
Local lAux   := .T.

dbSelectArea( cMaster )
dbSetOrder( 1 )
// Aqui ocorre o inst�nciamento do modelo de dados (Model)
// Neste exemplo instanciamos o modelo de dados do fonte COMP011_MVC
// que � a rotina de manuten��o de compositores/interpretes
oModel := FWLoadModel( 'TTPROC13' )

// Temos que definir qual a opera��o deseja: 3 � Inclus�o / 4 � Altera��o / 5 - Exclus�o
oModel:SetOperation( 3 )    

// Antes de atribuirmos os valores dos campos temos que ativar o modelo
oModel:Activate() 

// Instanciamos apenas referentes �s dados
oAux := oModel:GetModel( Substr(cMaster,2,2) + 'MASTER' )

// Obtemos a estrutura de dados
oStruct := oAux:GetStruct()
aAux := oStruct:GetFields() 
                                

If lRet
	For nI := 1 To Len( aCpoMaster )
		// Verifica se os campos passados existem na estrutura do cabe�alho
		If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) == AllTrim(aCpoMaster[nI][1] ) } ) ) > 0
			// � feita a atribui��o do dado aos campo do Model do cabe�alho
			If !( lAux := oModel:SetValue( substr(cMaster,2,2) + 'MASTER', aCpoMaster[nI][1], aCpoMaster[nI][2] ) )
				// Caso a atribui��o n�o possa ser feita, por algum motivo(valida��o, por exemplo)
				// o m�todo SetValue retorna .F.
				lRet := .F.
				Exit
			EndIf
		EndIf
	Next
EndIf


If lRet
	// Instanciamos apenas a parte do modelo referente aos dados do item
	oAux := oModel:GetModel( cDetail + 'DETAIL' )
	// Obtemos a estrutura de dados do item
	oStruct := oAux:GetStruct()
	aAux := oStruct:GetFields()
	nItErro := 0
	For nI := 1 To Len( aCpoDetail )
		// Inclu�mos uma linha nova
		// ATEN��O: O itens s�o criados em uma estrutura de grid (FORMGRID), portanto j� � criada uma primeira linha
		//branco automaticamente, desta forma come�amos a inserir novas linhas a partir da 2� vez
		If nI > 1
			// Inclu�mos uma nova linha de item
			If ( nItErro := oAux:AddLine() ) <> nI
				// Se por algum motivo o m�todo AddLine() n�o consegue incluir a linha,
				// ele retorna a quantidade de linhas j�
				// existem no grid. Se conseguir retorna a quantidade mais 1
				lRet := .F.
				Exit
			EndIf
		EndIf
		For nJ := 1 To Len( aCpoDetail[nI] )
			// Verifica se os campos passados existem na estrutura de item
			If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) == AllTrim(aCpoDetail[nI][nJ][1] ) } ) ) > 0
				If !( lAux := oModel:SetValue( cDetail + 'DETAIL',aCpoDetail[nI][nJ][1], aCpoDetail[nI][nJ][2] ) )
					// Caso a atribui��o n�o possa ser feita, por algum motivo (valida��o, por exemplo)
					// o m�todo SetValue retorna .F.
					lRet := .F.
					nItErro := nI
					Exit
				EndIf
			EndIf
		Next
		If !lRet
			Exit
		EndIf
	Next
EndIf
If lRet
	// Faz-se a valida��o dos dados, note que diferentemente das tradicionais "rotinas	autom�ticas"
	// neste momento os dados n�o s�o gravados, s�o somente validados.
	If ( lRet := oModel:VldData() )
		// Se o dados foram validados faz-se a grava��o efetiva dos
		// dados (commit)
		oModel:CommitData()
	EndIf
EndIf
If !lRet
	// Se os dados n�o foram validados obtemos a descri��o do erro para gerar
	// LOG ou mensagem de aviso
	aErro := oModel:GetErrorMessage()
	// A estrutura do vetor com erro �:
	// [1] identificador (ID) do formul�rio de origem
	// [2] identificador (ID) do campo de origem
	// [3] identificador (ID) do formul�rio de erro
	// [4] identificador (ID) do campo de erro
	// [5] identificador (ID) do erro
	// [6] mensagem do erro
	// [7] mensagem da solu��o
	// [8] Valor atribu�do
	// [9] Valor anterior
	AutoGrLog( "Id do formul�rio de origem:" + ' [' + AllToChar( aErro[1] ) + ']' )
	AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' )
	AutoGrLog( "Id do formul�rio de erro: " + ' [' + AllToChar( aErro[3] ) + ']' )
	AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' )
	AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']' )
	AutoGrLog( "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' )
	AutoGrLog( "Mensagem da solu��o: " + ' [' + AllToChar( aErro[7] ) + ']' )
	AutoGrLog( "Valor atribu�do: " + ' [' + AllToChar( aErro[8] ) + ']' )
	AutoGrLog( "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' )
	If nItErro > 0
		AutoGrLog( "Erro no Item: " + ' [' + AllTrim( AllToChar(nItErro ) ) + ']' )
	EndIf
	MostraErro()
EndIf
// Desativamos o Model
oModel:DeActivate()

Return lRet            

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROC14  �Autor  �Microsiga           � Data �  12/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function BuscaCli(chapa)

Local aArea	:=	GetArea()
Local cQuery 
Local cRet	:=	''

cQuery := "SELECT N1_XCLIENT,N1_XLOJA FROM "+RetSQLName("SN1")
cQuery += " WHERE N1_CHAPA='"+chapa+"' AND D_E_L_E_T_=''"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTPROC14.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")
 
cRet	:=	TRB->N1_XCLIENT+N1_XLOJA

RestArea(aArea)

Return(cRet)