#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   ºAutor  ³Alexandre Venancio  º Data ³  01/02/23   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Log de alteração de cadastro                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A010TOK()

Local lRet	:=	.T.          
Local aLogA	:=	{}
Local nX    :=  0

If lRet .And. Altera
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
   	SX3->(dbGoTop())
	If SX3->(dbSeek("SB1"))
		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SB1"
			If X3USO(X3_USADO).And.cNivel>=X3_NIVEL .And. X3_CONTEXT<>"V"
				If &(SX3->X3_ARQUIVO+"->"+SX3->X3_CAMPO) != &("M->"+SX3->X3_CAMPO) 
					Aadd(aLogA,{SX3->X3_TITULO,&("M->"+SX3->X3_CAMPO),&(SX3->X3_ARQUIVO+"->"+SX3->X3_CAMPO)})
				EndIf
			EndIf
			SX3->(dbSkip())
		EndDo
	EndIf
	If len(aLogA) > 0
		For nX := 1 to len(aLogA)
			//ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
			xFil 	:= xFilial("SB1")
			Modulo 	:= "Cadastro Produto"
			TipoMov := "Alteracao"
			Prefixo	:=	""
			Docto	:=	SB1->B1_COD
			Serie	:=	""
			UserMov	:=	cusername
			DiaMov	:=	ddatabase
			HoraMov	:=	time()
			Valor	:=	0
			Obs		:=	"Alterado campo "+Alltrim(aLogA[nX,01])+" conteudo anterior "+Alltrim(cvaltochar(aLogA[nX,03]))+" conteudo atual "+Alltrim(cvaltochar(aLogA[nX,02]))
			cCli	:=	''
			cLoja	:=	''
			cTabela	:=	"SB1" 
			U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
		Next nX
	EndIF
	
EndIf

Return(lRet)
