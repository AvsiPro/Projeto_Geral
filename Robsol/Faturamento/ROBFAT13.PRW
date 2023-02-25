#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 23/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ROBFAT13()

Local cTitulo := " NOTAS COMPLEMENTARES "
Local nOpc    := 0
Local aSay    := {}
Local aButton := {}   
Private cPerg := 'XXX190    '

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0103")
Endif
 
//ValidPerg()

aAdd( aSay, "Programa para geração de notas de complemento por arquivo" )

AADD( aButton, { 5,	.T., {|| Pergunte(cPerg,.T. ) }} )

aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )

aAdd( aButton, { 2, .T., {|| FechaBatch() }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc == 1
	Processa( {||  geranf() }, "Processando..." )
Endif
    

Return

/*/{Protheus.doc} geranf
    (long_description)
    @type  Static Function
    @author user
    @since 23/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function geranf()

Local aArea	 :=	GetArea()                          
Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local cDoc   := ""
Local aAux   :=  {}
Local aFilel :=  {}
Local nCont  := 1

Private cArqTxt 	:=	MV_PAR01  //'C:\000\nfcompl.csv' //
Private nHandle 	:=	FT_FUse(cArqTxt)


PRIVATE lMsErroAuto := .F.

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	aAux    := SEPARA(cLine,";") 
    If nCont > 1
        Aadd(aFilel,aAux)
    EndIF 
    nCont++
	FT_FSKIP()
End

FT_FUSE()

For nCont := 1 to len(aFilel)
    aFilel[nCont,01] := strzero(val(aFilel[nCont,01]),4)
    aFilel[nCont,13] := strzero(val(aFilel[nCont,13]),9)
    aFilel[nCont,05] := val(strtran(aFilel[nCont,05],",","."))
    aFilel[nCont,19] := val(strtran(aFilel[nCont,19],",","."))

    DbSelectArea("SF2")
    DbSetOrder(1)
    If Dbseek(aFilel[nCont,01]+aFilel[nCont,13]+'1  ')
        aFilel[nCont,17] := SF2->F2_CLIENTE
        aFilel[nCont,20] := SF2->F2_LOJA
    EndIf
Next nCont

cDoc := ''

For nCont := 1 to len(aFilel)
    If Empty(cDoc) .Or. cDoc <> aFilel[nCont,13]
        If !Empty(cDoc)
            SA1->( dbSetOrder( 1 ) )
            SB1->( dbSetOrder( 1 ) )
            SF2->( dbSetOrder( 1 ) )
            SD2->( dbSetOrder( 1 ) )

            MSExecAuto ({|x,y,z| MATA920(x,y,z)}, aCabec, aItens, 3) 
        
            If !lMsErroAuto    
                ConOut("Incluido com sucesso! ")      
            Else  
                MostraErro()     
                ConOut("Erro na inclusao!")
            EndIf   
        EndIf

        cDoc := aFilel[nCont,13]
        cItem := '01'
        aCabec := {}
        aItens := {}
        cNota := ''
        DbSelectArea("SX5")
        DbSetOrder(1)
        If Dbseek(aFilel[nCont,01]+'011     ')
            cNota := Alltrim(SX5->X5_DESCRI)
            Reclock("SX5",.F.)
            SX5->X5_DESCRI := soma1(cNota)
            SX5->(MSUNLOCK())
        EndIf 

        //Montagem da capa do documento fiscal 
        aadd(aCabec,{"F2_FILIAL"    ,aFilel[nCont,01]   ,NIL}) 
        aadd(aCabec,{"F2_TIPO"      ,"I"   ,NIL})
        aadd(aCabec,{"F2_FORMUL"    ,"S"   ,NIL})
        aadd(aCabec,{"F2_DOC"       ,cNota   ,NIL})   
        aadd(aCabec,{"F2_SERIE"     ,"1"          ,nil })  
        aadd(aCabec,{"F2_EMISSAO"   ,dDataBase   ,NIL})  
        aadd(aCabec,{"F2_CLIENTE"   ,aFilel[nCont,17]   ,NIL})   
        aadd(aCabec,{"F2_LOJA"      ,aFilel[nCont,20]   ,NIL})   
        aadd(aCabec,{"F2_ESPECIE"   ,"SPED"   ,NIL})   
        aadd(aCabec,{"F2_COND"      ,"001"   ,NIL}) 
        aadd(aCabec,{"F2_DESCONT"   ,0   ,NIL})  
        aadd(aCabec,{"F2_FRETE"     ,0   ,NIL})
        aadd(aCabec,{"F2_SEGURO"    ,0   ,NIL})   
        aadd(aCabec,{"F2_DESPESA"   ,0   ,NIL})      
    EndIf 

    //Montagem dos itens do documento fiscal   
    aLinha := {}   
    cItmori := buscitm(aFilel[nCont,01],aFilel[nCont,13],aFilel[nCont,02],aFilel[nCont,03])        
    
    aadd(aLinha,{"D2_FILIAL"    ,aFilel[nCont,01]   ,Nil})
    aadd(aLinha,{"D2_ITEM"      ,cItem   ,Nil}) 
    aadd(aLinha,{"D2_COD"       ,aFilel[nCont,02]   ,Nil})
    //aadd(aLinha,{"D2_QUANT"     ,0                  ,Nil})
    aadd(aLinha,{"D2_PRCVEN"    ,aFilel[nCont,05]   ,Nil}) 
    aadd(aLinha,{"D2_TOTAL"     ,aFilel[nCont,05]   ,Nil})
    aadd(aLinha,{"D2_TES"       ,"703"              ,Nil})    
    aadd(aLinha,{"D2_NFORI"     ,aFilel[nCont,13]   ,Nil})    
    aadd(aLinha,{"D2_SERIORI"   ,"1"                ,Nil})    
    aadd(aLinha,{"D2_ITEMORI"   ,cItmori            ,Nil})    
    aadd(aLinha,{"D2_CLASFIS"   ,'100'              ,Nil})    
    aadd(aLinha,{"D2_BASEICM"   ,aFilel[nCont,05]   ,Nil})    
    aadd(aLinha,{"D2_PICM"      ,VAL(aFilel[nCont,12])   ,Nil})    
    aadd(aLinha,{"D2_VALICM"    ,aFilel[nCont,05]*(VAL(aFilel[nCont,12])/100)              ,Nil})    
    
    cItem := soma1(cItem)
    
    aadd(aItens,aLinha)
    
Next nCont
 
If len(aCabec) > 0
    lMsErroAuto := .F.

    MSExecAuto ({|x,y,z| MATA920(x,y,z)}, aCabec, aItens, 3) 
        
    If !lMsErroAuto    
        ConOut("Incluido com sucesso! "+cDoc)      
    Else       
        MostraErro()
        ConOut("Erro na inclusao!")
    EndIf
EndIf 

ConOut("Fim  : "+Time())
 
RestArea(aArea)
 
Return .T.

/*/{Protheus.doc} buscitm
    (long_description)
    @type  Static Function
    @author user
    @since 23/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function buscitm(cFilOri,cDocOri,cProdori,cQtdori)

Local aArea := GetArea()
Local cRet  := ''
Local cQuery 

cQuery := "SELECT D2_ITEM"
cQuery += " FROM "+RetSQLName("SD2")
cQuery += " WHERE D2_FILIAL='"+cFilOri+"' AND D2_DOC='"+cDocOri+"'"
cQuery += " AND D2_COD='"+cProdori+"' AND D2_QUANT="+cQtdori
cQuery += " AND D_E_L_E_T_=' '"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

cRet := TRB->D2_ITEM

RestArea(aArea)

Return(cRet)
