#INCLUDE 'PROTHEUS.CH'

User Function EVERTO01

Local cQuery 
Local nCont 
Local nY 
Local cErr      := ''
Local aLog      := {}
Local aTitulos  := {}
Local aRet 		:=	{}
Local aPergs	:=	{}
Local cSer		:=	space(3)
Local cNota		:=	ctod(' / / ')


If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv('T1','D MG 01 ')
EndIf 

cSer		:=	space(len(xFilial("SE1"))) 

aAdd( aPergs ,{1,"Filial de : " ,cSer,"@!",'.T.',"",'.T.',40,.F.})
aAdd( aPergs ,{1,"Filial Ate : ",cSer,"@!",'.T.',"",'.T.',40,.F.})
aAdd( aPergs ,{1,"Baixa De : "  ,cNota,"@!",'.T.',"",'.T.',50,.F.})
aAdd( aPergs ,{1,"Baixa Ate : " ,cNota,"@!",'.T.',"",'.T.',50,.F.})

If !ParamBox(aPergs ,"Informe os parametros",@aRet)
    Return 
Else 
	MV_PAR01 := aRet[1]
	MV_PAR02 := aRet[2]
	MV_PAR03 := aRet[3]
    MV_PAR04 := aRet[4]
EndIf


cQuery := "SELECT R_E_C_N_O_ AS RECSE1,E1_BAIXA,E1_PORTADO,E1_AGEDEP,E1_CONTA  FROM "+RetSQLName("SE1")
cQuery += " WHERE E1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND E1_BAIXA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"'"
cQuery += " AND D_E_L_E_T_=' ' AND E1_PORTADO<>' '"

cQuery := ChangeQuery(cQuery)

If Select("TMPZPC") > 0
    TMPZPC->( dbclosearea() )
Endif

DbUseArea(.T.,'TOPCONN', TcGenQry(,,cQuery),'TMPZPC', .T., .T.)

TMPZPC->( dbgotop() )

While TMPZPC->(!eof())
    Aadd(aTitulos,{TMPZPC->RECSE1,;
                    TMPZPC->E1_BAIXA,;
                    TMPZPC->E1_PORTADO,;
                    TMPZPC->E1_AGEDEP,;
                    TMPZPC->E1_CONTA})
    Dbskip()
EndDo 

For nCont := 1 to len(aTitulos)
    SE1->(Dbgoto(aTitulos[nCont,01]))

    dDataBase := stod(aTitulos[nCont,02])

    aBaixa := {}
    aBaixa:={	{"E1_FILIAL"	,SE1->E1_FILIAL 			,Nil},;
                {"E1_PREFIXO" 	,SE1->E1_PREFIXO 			,Nil},;
                {"E1_NUM" 		,SE1->E1_NUM 				,Nil},;
                {"E1_PARCELA" 	,SE1->E1_PARCELA 			,Nil},;
                {"E1_TIPO" 		,SE1->E1_TIPO 				,Nil},;
                {"E1_NATUREZ" 	,SE1->E1_NATUREZ 			,Nil},;
                {"E1_CLIENTE" 	,SE1->E1_CLIENTE 			,Nil},;
                {"E1_LOJA" 		,SE1->E1_LOJA 				,Nil}}

    lMsErroAuto := .F. 

    MSExecAuto({|x,y,b,a| Fina070(x,y,b,a)},aBaixa,5)

    If lMsErroAuto
        aLog := GetAutoGRLog()
        For nY := 1 To Len(aLog)
            cErr += AllTrim(aLog[nY])
        Next nY
        cErr := StrTran(cErr,CHR(13)+CHR(10))
        ProcLogAtu("MENSAGEM", cErr)
        
    else 
        SE1->(Dbgoto(aTitulos[nCont,01]))

        aBaixa := {}
        aBaixa:={	{"E1_FILIAL"	,SE1->E1_FILIAL 			,Nil},;
                    {"E1_PREFIXO" 	,SE1->E1_PREFIXO 			,Nil},;
                    {"E1_NUM" 		,SE1->E1_NUM 				,Nil},;
                    {"E1_PARCELA" 	,SE1->E1_PARCELA 			,Nil},;
                    {"E1_TIPO" 		,SE1->E1_TIPO 				,Nil},;
                    {"E1_NATUREZ" 	,SE1->E1_NATUREZ 			,Nil},;
                    {"E1_CLIENTE" 	,SE1->E1_CLIENTE 			,Nil},;
                    {"E1_LOJA" 		,SE1->E1_LOJA 				,Nil},;
                    {"AUTMOTBX"	 	, "NOR" 					,Nil},;
                    {"AUTBANCO" 	, aTitulos[nCont,03]		,Nil},;
                    {"AUTAGENCIA" 	, aTitulos[nCont,04]		,Nil},;
                    {"AUTCONTA" 	, aTitulos[nCont,05]		,Nil},;
                    {"AUTDTBAIXA"	, dDataBase 				,Nil},;
                    {"AUTDTDEB"		, dDataBase					,Nil}}
                    //,; {"AUTHIST"	    , "PRORROGACAO DE TITULO" 	,Nil}}

        lMsErroAuto := .F.

        MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)

        If lMsErroAuto
            aLog := GetAutoGRLog()
            For nY := 1 To Len(aLog)
                cErr += AllTrim(aLog[nY])
            Next nY
            cErr := StrTran(cErr,CHR(13)+CHR(10))
            ProcLogAtu("MENSAGEM", cErr)
        EndIF 
    EndIf
Next nCont 


aTitulos := {}

cQuery := "SELECT E2.R_E_C_N_O_ AS RECSE2,E2_BAIXA,E5_BANCO,E5_AGENCIA,E5_CONTA"
cQuery += " FROM "+RetSQLName("SE2")+" E2"
cQuery += " INNER JOIN "+RetSQLName("SE5")+" E5 ON E5_FILIAL=E2_FILIAL AND E2_NUM=E5_NUMERO" 
cQuery += " AND E2_PREFIXO=E5_PREFIXO AND E2_PARCELA=E5_PARCELA AND E2_FORNECE=E5_CLIFOR"
cQuery += " AND E2_LOJA=E5_LOJA AND E5.D_E_L_E_T_=' ' AND E5_RECPAG='P'"
cQuery += " AND E5_TIPO NOT IN('PA') AND E5_MOTBX NOT IN('CMP')"
cQuery += " WHERE E2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
cQuery += " AND E2_BAIXA BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "

cQuery := ChangeQuery(cQuery)

If Select("TMPZPC") > 0
    TMPZPC->( dbclosearea() )
Endif

DbUseArea(.T.,'TOPCONN', TcGenQry(,,cQuery),'TMPZPC', .T., .T.)

TMPZPC->( dbgotop() )

While TMPZPC->(!eof())
    Aadd(aTitulos,{TMPZPC->RECSE2,;
                    TMPZPC->E2_BAIXA,;
                    TMPZPC->E5_BANCO,;
                    TMPZPC->E5_AGENCIA,;
                    TMPZPC->E5_CONTA})
    Dbskip()
EndDo 


For nCont := 1 to len(aTitulos)
    SE2->(Dbgoto(aTitulos[nCont,01]))

    dDataBase := stod(aTitulos[nCont,02])

    aBaixa := {}
    aBaixa:={	{"E2_FILIAL"	,SE2->E2_FILIAL 			,Nil},;
                {"E2_PREFIXO" 	,SE2->E2_PREFIXO 			,Nil},;
                {"E2_NUM" 		,SE2->E2_NUM 				,Nil},;
                {"E2_PARCELA" 	,SE2->E2_PARCELA 			,Nil},;
                {"E2_TIPO" 		,SE2->E2_TIPO 				,Nil},;
                {"E2_NATUREZ" 	,SE2->E2_NATUREZ 			,Nil},;
                {"E2_FORNECE" 	,SE2->E2_FORNECE 			,Nil},;
                {"E2_LOJA" 		,SE2->E2_LOJA 				,Nil}}

    lMsErroAuto := .F. 

    MSExecAuto({|x,y,b,a| Fina080(x,y,b,a)},aBaixa,5)

    If lMsErroAuto
        aLog := GetAutoGRLog()
        For nY := 1 To Len(aLog)
            cErr += AllTrim(aLog[nY])
        Next nY
        cErr := StrTran(cErr,CHR(13)+CHR(10))
        ProcLogAtu("MENSAGEM", cErr)
        
    else 
        SE2->(Dbgoto(aTitulos[nCont,01]))

        aBaixa := {}
        aBaixa:={	{"E2_FILIAL"	,SE2->E2_FILIAL 			,Nil},;
                    {"E2_PREFIXO" 	,SE2->E2_PREFIXO 			,Nil},;
                    {"E2_NUM" 		,SE2->E2_NUM 				,Nil},;
                    {"E2_PARCELA" 	,SE2->E2_PARCELA 			,Nil},;
                    {"E2_TIPO" 		,SE2->E2_TIPO 				,Nil},;
                    {"E2_NATUREZ" 	,SE2->E2_NATUREZ 			,Nil},;
                    {"E2_FORNECE" 	,SE2->E2_FORNECE 			,Nil},;
                    {"E2_LOJA" 		,SE2->E2_LOJA 				,Nil},;
                    {"AUTMOTBX"	 	, "NOR" 					,Nil},;
                    {"AUTBANCO" 	, aTitulos[nCont,03]		,Nil},;
                    {"AUTAGENCIA" 	, aTitulos[nCont,04]		,Nil},;
                    {"AUTCONTA" 	, aTitulos[nCont,05]		,Nil},;
                    {"AUTDTBAIXA"	, dDataBase 				,Nil},;
                    {"AUTDTDEB"		, dDataBase					,Nil}}
                    //,; {"AUTHIST"	    , "PRORROGACAO DE TITULO" 	,Nil}}

        lMsErroAuto := .F.

        MSExecAuto({|x,y| Fina080(x,y)},aBaixa,3)

        If lMsErroAuto
            aLog := GetAutoGRLog()
            For nY := 1 To Len(aLog)
                cErr += AllTrim(aLog[nY])
            Next nY
            cErr := StrTran(cErr,CHR(13)+CHR(10))
            ProcLogAtu("MENSAGEM", cErr)
        EndIF 
    EndIf
Next nCont 

Return 
