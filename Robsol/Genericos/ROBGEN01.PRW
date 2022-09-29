#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "fileio.ch"
#INCLUDE "TOPCONN.CH"

/*
    Importar arquivo CSV para gerar pedidos Robsol

*/

User Function ROBGEN01
                                

Local nX 
Local cfile         :=  '' //dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.txt' 
Private cPathL		:=	'c:\PEDIDOS\'
Private aArquivo	:=  directory(cPathL+"*.CSV","D")		//Varredura no Diretorio padrao onde devem se encontrar os xmls para importacao
Private nHandlel	:=	'' //fcreate('C:\PEDIDOS\'+cfile, FO_READWRITE + FO_SHARED )
Private cAuxObs     :=  ''

If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

cfile           :=  dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.txt'
nHandlel	    :=	fcreate('C:\PEDIDOS\'+cfile, FO_READWRITE + FO_SHARED )

FWrite(nHandlel,"#######################################################"+CRLF,1000)
FWrite(nHandlel,"Inicio :"+cvaltochar(time())+CRLF,1000)

If !ExistDir( cPathL )
	MakeDir( cPathL )
EndIF

If !ExistDir( cPathL+"\Processados" )
	MakeDir( cPathL+"\Processados" )
EndIf

For nX := 1 to len(aArquivo)
	If Alltrim(aArquivo[nX,01]) <> "." .And. Alltrim(aArquivo[nX,01]) <> ".." .And. aArquivo[nX,05] <> "D"
        Processa({|| LerArquivo(Alltrim(aArquivo[nX,01]))},"Aguarde processando arquivo "+Alltrim(aArquivo[nX,01]))
    EndIf
Next nX

FWrite(nHandlel,"#######################################################"+CRLF,1000)
FWrite(nHandlel,"Finalizou :"+cvaltochar(time())+CRLF,1000)
FWrite(nHandlel,"#######################################################"+CRLF,1000)

fclose(nHandlel)

WinExec('NOTEPAD '+"C:\PEDIDOS\" + cfile,1)

Return

/*/{Protheus.doc} LerArquivo
    (long_description)
    @type  Static Function
    @author user
    @since 12/01/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function LerArquivo(cArquivo)
    
Local aAux			:=	{}
Local nAux          :=  0
Local nPosic        :=  0
Local nCont         :=  0
Local cnpj
Local lProdutos     :=  .F.
Local aItens        :=  {}
Local cVend         :=  ''
Local cCodigo       :=  ''
Local cLoja         :=  ''
Local nLinha        :=  1
Local cCupom        :=  ''
Local lContinua     :=  .T.
Local aCabC5        :=  {}
Private nHandle 	:=	FT_FUse(cPathL+cArquivo) 

FWrite(nHandlel,"#######################################################"+CRLF,1000)

cAuxObs := ''

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
   	aAux    := Separa(cLine,";",.T.)
    
    If 'CUPOM' $ UPPER(CLINE) .and. nLinha>1
        nPosic := ASCAN(AAUX,{|X| "CUPOM" $ X})
        For nAux := nPosic+1 to len(aAux)
            If val(aAux[nAux]) > 0
                cCupom := aAux[nAux]
                FWrite(nHandlel,"Cupom :"+cCupom+CRLF,1000)
                exit
            ENDIF
        Next nAux

        lContinua := .F.

        If !Empty(cCupom)
            lContinua := BuscaCup(cCupom)
        EndIf

        
    EndIf

    If lContinua

        If "CNPJ" $ UPPER(cLine)
            nPosic := ASCAN(AAUX,{|X| "CNPJ" $ X})
            For nAux := nPosic+1 to len(aAux)
                If val(aAux[nAux]) > 0
                    cnpj := aAux[nAux]
                    exit
                EndIF
            Next nAux
            DbSelectArea("SA1")
            DbSetOrder(3)
            If Dbseek(xFilial("SA1")+cnpj)
                cCodigo := SA1->A1_COD
                cLoja   := SA1->A1_LOJA
            ENDIF
        ENDIF

        If "VENDEDOR" $ UPPER(cLine) .And. len(aAux) > 19
            cVend := vendedores(Alltrim(aAux[20]))    
            //cVend := '000006'
        EndIf

        If lProdutos
            If !Empty(aAux[3])
                nPos := ascan(acabc5[1],{|x| UPPER(x) == "CODIGO"})
                codigo  := aAux[If(nPos>0,nPos,3)]
                
                nPos := ascan(acabc5[1],{|x| x == "QTD"})
                nQuant  := val(strtran(aAux[If(nPos>0,nPos,35)],","))

                nPos := ascan(acabc5[1],{|x| upper(x) == "PRECO"})
                nVlr    := val(strtran(aAux[If(nPos>0,nPos,42)],",","."))
                
                nPos := ascan(acabc5[1],{|x| upper(x) == "DES"})
                nDesc := val(strtran(strtran(aaux[If(nPos>0,nPos,63)],"%"),",","."))

                DbSelectArea("SB1")
                DbSetOrder(1)
                If DbSeek(xFilial("SB1")+codigo)
                    Aadd(aItens,{codigo,nQuant,nVlr,nDesc})
                Else
                    Fwrite(nHandlel,'Produto nao encontrado no cadastro '+codigo+CRLF,1000)
                EndIf
            else
                lProdutos := .F.
            EndIf
        EndIf              

        If 'CODIGO' $ UPPER(CLINE)
            Aadd(aCabC5,aAux)
            lProdutos := .T.
        EndIf

        lObs := .F.
        lIniOb := .F.
        
        If 'OBSERVACAO.' $ UPPER(CLINE)
            cAuxObs := ""
            lObs := .T.
            While lObs  
                cLine	:= FT_FReadLn() // Retorna a linha corrente  
                aAux    := Separa(cLine,";",.T.)
                
                If '"' $ cLine
                    lIniOb := If(!lIniOb,.T.,.F.)
                    If !lIniOb
                        lObs := .F.
                    EndIf
                EndIf

                If lIniOb
                    For nCont := 1 to len(aAux)
                        cAuxObs += aAux[nCont]
                    Next nCont
                EndIf 
                nLinha++
                If nLinha > 120
                    lObs  := .F.
                EndIf
                FT_FSKIP()
            EndDo
        ENDIF
    else
        Exit
    EndIf
    nLinha++
	FT_FSKIP()
End              

lRet := .F.



If !Empty(cCodigo) .And. !Empty(cLoja) .And. !Empty(cVend) .And. len(aItens) > 0
    lRet := GeraPV(cCodigo,cLoja,cVend,aItens,cCupom)
Else
    iF lContinua
        If Empty(cCodigo)
            Fwrite(nHandlel,'Nao encontrou o cliente'+CRLF,1000)
        EndIf
        If Empty(cLoja)
            Fwrite(nHandlel,'Nao encontrou a loja do cliente'+CRLF,1000)
        EndIf
        If Empty(cVend)
            Fwrite(nHandlel,'Nao encontrou o vendedor'+CRLF,1000)
        EndIf
        If len(aItens) < 1
            Fwrite(nHandlel,'Nao encontrou itens no arquivo'+CRLF,1000)
        EndIf
    ENDiF
EndIf

FT_FUse()

If lRet
    FRename(cPathL+cArquivo,cPathL+'Processados\'+strtran(upper(cArquivo),".CSV",".PROC"))
EndIf

Return   


/*/{Protheus.doc} vendedores
    (long_description)
    @type  Static Function
    @author user
    @since 12/01/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function vendedores(param_name)

Local cRet  := ''

DbSelectArea("SA3")
DbSetOrder(2)
If Dbseek(xFilial("SA3")+Alltrim(upper(param_name)))
    cRet := SA3->A3_COD
EndIf

Return cRet

/*/{Protheus.doc} 
    (long_description)
    @type  Static Function
    @author user
    @since 12/01/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GERAPV(cCodigo,cLoja,cVend,aItensCad,cCupom)

Local aArea		:=	GetArea()
Local lRet		:=	.F.
Local aCabec    := {}
Local aItens    := {}
Local aLinha    := {}
Local cDoc 		:= GetSxeNum("SC5", "C5_NUM")
Local nX		:=	0
Private lMsErroAuto := .F. 


Dbselectarea("SA1")
DbSetOrder(1)
Dbseek(xFilial("SA1")+cCodigo+cLoja)

aadd(aCabec, {"C5_NUM"		, cDoc			    ,Nil})
aadd(aCabec, {"C5_TIPO"		, "N"			    ,Nil})
aadd(aCabec, {"C5_CLIENTE"	, cCodigo		    ,Nil})
aadd(aCabec, {"C5_LOJACLI"	, cLoja		        ,Nil})
aadd(aCabec, {"C5_LOJAENT"	, cLoja 		    ,Nil})
aadd(aCabec, {"C5_EMISSAO"	, dDatabase		    ,Nil}) // Data de emissao
aadd(aCabec, {"C5_TIPOCLI"	, SA1->A1_TIPO	    ,Nil}) // Tipo de cliente
aadd(aCabec, {"C5_TIPOPV" 	, '1'			    ,Nil}) //
aadd(aCabec, {"C5_MOEDA"  	, 1				    ,Nil})  // Moeda
aadd(aCabec, {"C5_CONDPAG"	, '001'			    ,Nil})
aadd(aCabec, {"C5_NATUREZ"  ,"11010007"         ,Nil})  
aadd(aCabec, {"C5_VEND1"    , cVend             ,Nil})
aadd(aCabec, {"C5_MENNOTA"  , 'Cupom '+cCupom   ,Nil})
aadd(aCabec, {"C5_X_OBS"    , cAuxObs           ,Nil})

FOR nX := 1 to len(aItensCad)  
	aLinha := {}
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+aItensCad[nX,01])
	
      aadd(aLinha,{"C6_ITEM"    , strzero(nX,2)     , Nil})
      aadd(aLinha,{"C6_PRODUTO" , aItensCad[nX,01]  , Nil})
      aadd(aLinha,{"C6_QTDVEN"  , aItensCad[nX,02]  , Nil})
      aadd(aLinha,{"C6_PRCVEN"  , aItensCad[nX,03]  , Nil})
      aadd(aLinha,{"C6_PRUNIT"  , aItensCad[nX,03]  , Nil})
      aadd(aLinha,{"C6_TES"     , '502'             , Nil})
      aadd(aLinha,{"C6_DESCONT" , aItensCad[nX,04]  , Nil})
      aadd(aLinha,{"C6_LOCAL"   , SB1->B1_LOCPAD	, Nil})
      
      
      aadd(aItens, aLinha)

NEXT      

lMsErroAuto := .F.            

Begin Transaction 

         
MSExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 3)
 
If !lMsErroAuto
	ConOut("Incluído com sucesso! " + cDoc)
    Fwrite(nHandlel,'Pedido gerado '+cDoc+CRLF,1000)
	ConfirmSX8()
	lRet := .T.
Else
	MostraErro(cPathL,Alltrim(cCupom)+"_erro.txt")
    Fwrite(nHandlel,'Erro na geracao do pedido '+CRLF,1000)
	ConOut("Erro na inclusão!")
	lRet := .F.
EndIf

End Transaction 

RestAreA(aArea)

Return(lRet)

/*/{Protheus.doc} BuscaCup(cCupom)
    (long_description)
    @type  Static Function
    @author user
    @since 20/01/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaCup(cCupom)

Local aArea :=  GetArea()
Local cQuery
Local lRet  :=  .T.

cQuery := "SELECT C5_NUM FROM "+RetSQLName("SC5")
cQuery += " WHERE C5_FILIAL='"+xFilial("SC5")+"'"
cQuery += " AND UPPER(C5_MENNOTA) LIKE 'CUPOM "+cCupom+"%'"
cQuery += " AND D_E_L_E_T_=' '"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

If !Empty(TRB->C5_NUM)
    Fwrite(nHandlel,'Cupom ja importado para o pedido '+TRB->C5_NUM+CRLF,1000)
    lRet := .F.
EndIf 
    
    
RestArea(aArea)
    
Return(lRet)
