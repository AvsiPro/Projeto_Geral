#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA030TOK   ºAutor  ³Alexandre Venancio  º Data ³  01/02/23   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Log de alteracao de cadastro                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA030TOK()
//USAR ESTE AGORA
//https://tdn.totvs.com/pages/releaseview.action?pageId=616215550
Local lRet	:=	.T.
Local nX    :=  0
Local aLogA	:=	{}
 
If Altera .And. lRet 
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
   	SX3->(dbGoTop())
	If SX3->(dbSeek("SA1"))
		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SA1" // !lFound .And.
			If X3USO(X3_USADO).And.cNivel>=X3_NIVEL .And. X3_CONTEXT<>"V"
				If &(SX3->X3_ARQUIVO+"->"+SX3->X3_CAMPO) != &("M->"+SX3->X3_CAMPO) 
					//lFound := .T.
					Aadd(aLogA,{SX3->X3_TITULO,&("M->"+SX3->X3_CAMPO),&(SX3->X3_ARQUIVO+"->"+SX3->X3_CAMPO)})
				EndIf
			EndIf
			SX3->(dbSkip())
		EndDo
	EndIf
	If len(aLogA) > 0
		For nX := 1 to len(aLogA)
			//ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
			xFil 	:= xFilial("SA1")
			Modulo 	:= "Cadastro Cliente"
			TipoMov := "Alteracao"
			Prefixo	:=	""
			Docto	:=	SA1->A1_COD
			Serie	:=	""
			UserMov	:=	cusername
			DiaMov	:=	ddatabase
			HoraMov	:=	time()
			Valor	:=	0
			Obs		:=	"Alterado campo "+Alltrim(aLogA[nX,01])+" conteudo anterior "+Alltrim(cvaltochar(aLogA[nX,03]))+" conteudo atual "+Alltrim(cvaltochar(aLogA[nX,02]))
			cCli	:=	SA1->A1_COD
			cLoja	:=	SA1->A1_LOJA
			cTabela	:=	"SA1" 
			U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
		Next nX
	EndIF
	
EndIf

Return(lRet)
