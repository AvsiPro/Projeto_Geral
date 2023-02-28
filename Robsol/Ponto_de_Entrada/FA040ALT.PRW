User Function FA040ALT

Local lRet := .T.
Local aLogA:= {} 
Local lFound := .F.
Local nX    :=  0

If Altera
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
   	SX3->(dbGoTop())
	If SX3->(dbSeek("SE1"))
		While SX3->(!Eof()) .And. !lFound .And. SX3->X3_ARQUIVO == "SE1"
			If X3USO(X3_USADO).And.cNivel>=X3_NIVEL .And. X3_CONTEXT<>"V"
				If &(SX3->X3_ARQUIVO+"->"+SX3->X3_CAMPO) != &("M->"+SX3->X3_CAMPO) 
					lFound := .T.
					Aadd(aLogA,{SX3->X3_TITULO,&("M->"+SX3->X3_CAMPO),&(SX3->X3_ARQUIVO+"->"+SX3->X3_CAMPO)})
				EndIf
			EndIf
			SX3->(dbSkip())
		EndDo
	EndIf
	If len(aLogA) > 0
		For nX := 1 to len(aLogA)
			//ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
			xFil 	:= xFilial("SE1")
			Modulo 	:= "Titulo a Receber"
			TipoMov := "Alteracao"
			Prefixo	:=	SE1->E1_PREFIXO
			Docto	:=	SE1->E1_NUM
			Serie	:=	SE1->E1_PARCELA
			UserMov	:=	cusername
			DiaMov	:=	ddatabase
			HoraMov	:=	time()
			Valor	:=	0
			Obs		:=	"Alterado campo "+Alltrim(aLogA[nX,01])+" conteudo anterior "+Alltrim(cvaltochar(aLogA[nX,03]))+" conteudo atual "+Alltrim(cvaltochar(aLogA[nX,02]))
			cCli	:=	SE1->E1_CLIENTE
			cLoja	:=	SE1->E1_LOJA
			cTabela	:=	"SE1" 
			U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
		Next nX
	EndIF
EndIf

Return(lRet)
