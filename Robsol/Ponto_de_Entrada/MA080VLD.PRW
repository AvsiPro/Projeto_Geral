User Function MA080VLD()

Local aLogA := {}
Local nX 

If Altera
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
   	SX3->(dbGoTop())
	If SX3->(dbSeek("SF4"))
		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SF4"
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
			xFil 	:= xFilial("SF4")
			Modulo 	:= "Cadastro TES"
			TipoMov := "Alteracao"
			Prefixo	:=	""
			Docto	:=	SF4->F4_CODIGO
			Serie	:=	""
			UserMov	:=	cusername
			DiaMov	:=	ddatabase
			HoraMov	:=	time()
			Valor	:=	0
			Obs		:=	"Alterado campo "+Alltrim(aLogA[nX,01])+" conteudo anterior "+Alltrim(cvaltochar(aLogA[nX,03]))+" conteudo atual "+Alltrim(cvaltochar(aLogA[nX,02]))
			cCli	:=	''
			cLoja	:=	''
			cTabela	:=	"SF4" 
			U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
		Next nX
	EndIF
	
EndIf
	
	
Return(.T.)
