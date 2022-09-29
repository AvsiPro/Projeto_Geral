#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/06/03      
#Include "tbiconn.ch"
#Include "TopConn.ch"

User Function TTTMKA01()        // incluido pelo assistente de conversao do AP6 IDE em 12/06/03    
Local aQuery := {}
SetPrvt("AROTINA, CCADASTRO, CALIAS")
SetPrvt("NOPCE, NOPCG, NUSADO")
SetPrvt("CTITULO, CALIASENCHOICE, CLINOK, CTUDOK, CFIELDOK")
SetPrvt("NREG")
Private oGetDados

//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" TABLES "ZZ4"             
If cEmpAnt <> "01"
	Return
EndIf

aRotina := {	{OemToAnsi("Pesquisar")	,"axPesqui"   		, 0, 1},;    	// Pesquisar
             	{OemToAnsi("Visualizar"),'U_MODEL2ZZ4(2)'	, 0, 2},;    	// Visualizar
              	{OemToAnsi("Incluir")	,'U_MODEL2ZZ4(3)'	, 0, 3},;    	// Incluir
              	{OemToAnsi("Alterar")	,'U_MODEL2ZZ4(4)'	, 0, 4},; 	// Alterar
              	{OemToAnsi("Excluir")	,'U_MODEL2ZZ4(5)'	, 0, 5},;	// Excluir
				{OemToAnsi("Gerar Lista"),'U_GeraLista()'	, 0, 6}}              	


						
	cAlias    := "ZZ4"                 
	cCadastro := "Cadastro de Rotas"

	dbSelectArea(cAlias)
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
	mBrowse(06,01,22,75,cAlias,,,,,,)		
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Encerra o filtro da tabela.                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Return

User Function Model2ZZ4(_nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,")
Private _cBase	                 
Private nReg	:= 0

If _nOpc == 3 // Incluir
	_lInclusao	:= .T.
	_lButtons 	:= .T.
	nOpcE 		:= 3 
	nOpcG 		:= 3
	_aDadosAdd	:= {}
ElseIf _nOpc == 4 // Alterar
	_lInclusao	:= .F.
 	_lButtons	:= .T.
	nOpcE 		:= 4
	nOpcG 		:= 3
ElseIf _nOpc == 2 // Visualizar
	_lInclusao	:= .F.
 	_lButtons	:= .F.
	nOpcE 		:= 2
	nOpcG 		:= 2
Else             // Excluir
	_lInclusao	:= .F.
  	_lButtons	:= .F.
	nOpcE 		:= 5
	nOpcG 		:= 5
EndIf


nOpcx:=_nOpc
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3") 
dbSetOrder(1)
dbSeek("ZZ4") 
nUsado		:= 0
aHeader		:= {}     
_cUsado 	:= "" 
_cContext   := ""
While !Eof() .And. (x3_arquivo == "ZZ4")  

	If Rtrim(SX3->X3_CAMPO) = "ZZ4_CODROT"  
		_cUsado		:= SX3->X3_USADO  
		_cContext   := SX3->X3_CONTEXT
	Endif		

	If Rtrim(SX3->X3_CAMPO) $ "ZZ4_CODCLI&ZZ4_LOJA&ZZ4_NOME"
    	nUsado:=nUsado+1
        AADD(aHeader,{ 	x3_titulo,;
	      				x3_campo,; 
	       				x3_picture,;
	           			x3_tamanho,;
	           			x3_decimal,;
	          			x3_valid,;
		        	   	_cUsado,;
		        	   	x3_tipo,; 
		        	   	x3_arquivo,;
		        	   	_cContext} )   
		        	   	
		If nOpcx = 3		        	   	 
			wVar  := "M->" + x3_campo
			&wVar := CriaVar(x3_campo)		        	   	
		Endif	
	        	   	
	Endif
		    
    dbSkip()
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nUsado			:= 3
aCols			:= Array(1,nUsado+1)   
aCpoEnchoice 	:= {} 
_nLinha			:= 0
dbSelectArea("SX3") 
dbSeek("ZZ4") 

While !Eof() .And. (x3_arquivo == "ZZ4") 

	If Rtrim(SX3->X3_CAMPO) $ "ZZ4_CODCLI&ZZ4_LOJA&ZZ4_NOME"

    	IF nOpcx == 3
			_nLinha += 1    	
           IF x3_tipo == "C"
             aCOLS[1][_nLinha] := SPACE(x3_tamanho)
           Elseif x3_tipo == "N"
              aCOLS[1][_nLinha] := 0
           Elseif x3_tipo == "D"
   	          aCOLS[1][_nLinha] := dDataBase
           Elseif x3_tipo == "M"
   	          aCOLS[1][_nLinha] := ""
           Else
   	          aCOLS[1][_nLinha] := .F.
    	   Endif
        Endif
        
        AADD(aCpoEnchoice,x3_campo)

	Else	 	
		If nOpcx = 3
			wVar  := "M->"+x3_campo
			&wVar := CriaVar(x3_campo) // executa x3_relacao
		Endif		
	Endif				

   	dbSkip()
End                 
                                                     
aCOLS[1][nUsado+1] 	:= .F.   
_nx					:= 0

If nOpcx <> 3                 
   
	DbSelectArea("ZZ4")
	nReg		:= Recno()
	_aAreaZZ4	:= GetArea()	             
	_cBase	:= ZZ4->ZZ4_CODROT

	DbSetOrder(1)                
	DbGoTop()
	DbSeek(xFilial("ZZ4")+_cBase)
	
	Do While 	ZZ4->ZZ4_FILIAL		==	xFilial("ZZ4")	.And.;
				ZZ4->ZZ4_CODROT		==	_cBase			.And. !Eof()
				
	     _nx += 1
		If _nx > 1
			AADD(aCols,{Acols[1][1],Acols[1][2],Acols[1][3],Acols[1][4]})  
		Endif			
		Acols[_nx][1] 	:= ZZ4->ZZ4_CODCLI
		Acols[_nx][2] 	:= ZZ4->ZZ4_LOJA
		Acols[_nx][3] 	:= ZZ4->ZZ4_NOME                  
		M->ZZ4_CODROT 	:= ZZ4->ZZ4_CODROT
		M->ZZ4_DESROT 	:= ZZ4->ZZ4_DESROT
		M->ZZ4_SEMANA 	:= ZZ4->ZZ4_SEMANA
		M->ZZ4_TIPO		:= ZZ4->ZZ4_TIPO
			
		DbSelectArea("ZZ4")
		DbSkip()
			
	Enddo	                              
	RestArea(_aAreaZZ4)
	
Endif 

//n:= 1	  

 	If Len(aHeader) > 0
  		cTitulo        := OemToAnsi("Cadastro de Rotas")
  		cAliasEnchoice := "ZZ4"
  		cAliasGetd     := "ZZ4"
  		cAlias         := "ZZ4"                                                   
  		cLinOk         := "U_ROTALOK()"
  		cTudOk         := "ROTATUDOOK"
  		cFieldOk       := "AllwaysTrue()"
  		nOpca          := 0
  
  		DEFINE MSDIALOG oDlg TITLE cTitulo From 09,00 to 41,100	of oMainWnd

  		EnChoice(cAliasEnchoice, nReg, nOpcE,,,, aCpoEnchoice, {015, 001, 100, 390},, 003,,,,,, .F.)
  		oGetDados := MsGetDados():New(105,001,213,390,nOpcG,cLinOk,cTudOk,"",.T.,,,,999, cFieldOk)
  		oGetDados:oBrowse:bChange  := {|| RotaRefresh()}
//		oGetDados:oBrowse:bEditCol := {|| RotaEdit() }                                                  
		
		_xx := -5 	// Coordenada X (LINHA)
		_yy := 15 	// Coordenada Y (COLUNA)

	
//		CalcTotais()				

  		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||If(VLDGRAVA(),oDlg:End(),.F.), nOpca := 1},{|| oDlg:End()})

 	Endif
	
Return .T.                               

User Function _LinOK(_nTipo)   
nLinGetD	:= 0 
For _ny := 1 to Len(aCols)   
	If !ACols[_ny][nUsado+1]
		If _ny = n .And. _nTipo <> Nil
			nLinGetD	+= &(readvar())
		Else		
			nLinGetD 	+= Acols[_ny][2]	
		Endif		
	Endif		
Next
Return .T.

User Function _TudoOK() 
nLinGetD	:= 0 
For _ny := 1 to Len(aCols)
	If !ACols[_ny][nUsado+1]
		nLinGetD += Acols[_ny][2]	
	Endif		
Next
Return .T.

Static Function RotaRefresh()		
  	                                              
oGetDados:oBrowse:Refresh()
  	
Return(.T.)

User Function RotalOK()
Local _lRet 		:= .T.
Local _cCliente     := aCols[n][1]
Local _cLoja		:= aCols[n][2]
Local _nAnt			:= n

For _nLinha	:= 1 to Len(aCols)
	If Acols[_nLinha][Len(aHeader)+1] <> .T. .And. _nLinha <> _nAnt
		If aCols[_nLinha][1] = _cCliente .And. aCols[_nLinha][2] = _cLoja
			MsgBox("Cliente já cadastrado para esta rota !")  
			Acols[_nAnt][1] := Space(06) 
			Acols[_nAnt][2] := Space(04) 			
			_lRet := .F.
			Exit
		Endif	
	Endif
Next			
	  	                                              
oGetDados:oBrowse:Refresh()
  	
Return(_lRet)          

Static Function RotaTudoOK()		
  	                                              
oGetDados:oBrowse:Refresh()
  	
Return(.T.)



Static Function VldGrava()   

DbSelectArea("ZZ4")
DbSetOrder(1)
DbGotop()

If nOpcx = 4 .Or. nOpcx = 5

	_cBase		:= M->ZZ4_CODROT  
	DbSelectArea("ZZ4")
	DbSetOrder(1)
	DbGotop()
	DbSeek(xFilial("ZZ4")+_cBase)
	
	Do While 	ZZ4->ZZ4_FILIAL		= xFilial("ZZ4")	.And.;
				ZZ4->ZZ4_CODROT		= _cBase			.And. !Eof()
				
		RecLock("ZZ4",.F.)
		DbDelete()
		MsUnlock()
		
		DbSkip()
		
					
	Enddo
Endif	

If nOpcx = 3 .Or. nOpcx = 4
	
	For _n:=1 to Len(aCols) 
	
		If Acols[_n][Len(aHeader)+1] <> .T.
	
			DbSelectArea("ZZ4")
			
			RecLock("ZZ4",.T.)
			ZZ4->ZZ4_FILIAL		:= xFilial("ZZ4")
			ZZ4->ZZ4_CODROT		:= M->ZZ4_CODROT
			ZZ4->ZZ4_DESROT		:= M->ZZ4_DESROT
			ZZ4->ZZ4_SEMANA		:= M->ZZ4_SEMANA
			ZZ4->ZZ4_TIPO		:= M->ZZ4_TIPO
			ZZ4->ZZ4_CODCLI		:= aCols[_n,1]
			ZZ4->ZZ4_LOJA		:= aCols[_n,2]
			ZZ4->ZZ4_NOME		:= aCols[_n,3]
			MsUnlock()
		
		Endif	
			
	Next
	
Endif
	                               
Return .T.	
	
Static Function RotaEdit()

Return .T.

User Function GeraLista()
Local _aArea	:= GetArea()

If Pergunte("TTTMKA01",.T.) 

	Processa({|| ProcLista() },"Processando...") 
	
Endif

RestArea(_aArea)
Return

Static Function ProcLista()
Local _nCont	:= 1     

DbSelectArea("SU4")  
DbGotop()

Do While !Eof()
    
    If SU4->U4_DATA < dDatabase .And. "Lista Automática " $ SU4->U4_DESC 
    
    	If SimNao("Confirma Cancelamento da Lista de "+Dtoc(SU4->U4_DATA),"Apagar Rota") = "S"

	    	DbSelectArea("SU6")
	    	DbSetOrder(1)
	    	DbGotop()    
	    	
	    	DbSeek(xFilial("SU6")+SU4->U4_LISTA)
	    	
	    	Do While	SU6->U6_FILIAL	= 	xFilial("SU6")	.And.;
	    				SU6->U6_LISTA	=	SU4->U4_LISTA	.And.	!Eof()
	    				
				RecLock("SU6",.F.)
				DbDelete()
				MsUnlock()
				
				DbSkip()
				
			Enddo
			
			DbSelectArea("SU4")
			RecLock("SU4",.F.)
			DbDelete()
			MsUnlock()	
			
		Endif			
			
	Endif           
	
	DbSelectArea("SU4")
	DbSkip()
    	
Enddo

DbSelectArea("ZZ4")
ProcRegua(0)
DbSetOrder(5)
DbGoTop()  

If DbSeek(xFilial("ZZ4")+Rtrim(Mv_Par02)+Rtrim(Mv_par01))   

	_dDataRef	:= dDatabase
	Do While !Eof()
		
		If Dow(_dDataRef) = Val(Mv_Par01)
			Exit
		Endif
		_dDataRef += 1	
		
	Enddo	 
	
	DbSelectArea("SU4")
	RecLock("SU4",.T.)
	SU4->U4_FILIAL		:= 	xFilial("SU4")
	SU4->U4_TIPO		:= "1"
	SU4->U4_LISTA 		:= GetSx8Num("SU4","U4_LISTA")
	SU4->U4_DESC		:= "Lista Automática: "+" "+Mv_Par03+" "+Dtoc(_dDataRef)
	SU4->U4_DATA		:= _dDataRef
	SU4->U4_FORMA		:= "1"
	SU4->U4_STATUS		:= "1"  
	SU4->U4_TIPOTEL		:= "1"    
	SU4->U4_HORA1		:= "08:00:00"   
	SU4->U4_TELE		:= "1"
	SU4->U4_TIPOTEL		:= "1"
	MsUnlock() 
	ConfirmSx8()


	Do While 	ZZ4->ZZ4_FILIAL		==	xFilial("ZZ4")	.And.;
				ZZ4->ZZ4_TIPO		==	Rtrim(Mv_Par02)	.And.;
				ZZ4->ZZ4_SEMANA		==	Rtrim(Mv_Par01)	.And. 	!Eof()     

		IncProc()				
		DbSelectArea("AC8")	
		DbSetOrder(2)
		
		If DbSeek(xFilial("AC8")+"SA1"+xFilial("SA1")+ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA)			 
				
			DbSelectArea("SU6")
			RecLock("SU6",.T.)
			SU6->U6_FILIAL		:= xFilial("SU6")
			SU6->U6_LISTA		:= SU4->U4_LISTA  
			SU6->U6_CODIGO		:= GetSx8Num("SU6","U6_CODIGO")  
			SU6->U6_ENTIDA		:= "SA1"
			SU6->U6_CONTATO		:= AC8->AC8_CODCON    
			SU6->U6_CODENT		:= ZZ4->ZZ4_CODCLI+ZZ4->ZZ4_LOJA
			SU6->U6_ORIGEM		:= "1"
			SU6->U6_DATA		:= _dDataRef
			SU6->U6_HRINI		:= "08:00"
			SU6->U6_HRFIM		:= "18:00"
			SU6->U6_STATUS		:= "1"        
			SU6->U6_DTBASE		:= _dDataRef
			MsUnlock()
			ConfirmSx8()
			
			_nCont += 1
			
		Endif
		
		DbSelectArea("ZZ4")
		DbSkip()
		
	Enddo
	
Endif

If _nCont > 1

	MsgInfo("Lista Gerada com Sucesso: "+SU4->U4_DESC)
	
Else
	
	MsgBox("Lista não gerada, verifique os parâmetros !")

Endif		

Return .T.						
						