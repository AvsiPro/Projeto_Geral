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
    Importar arquivo CSV para gerar TABELAS Robsol

*/

User Function ROBGEN05
                                

Local nX 
Local cfile         :=  ''
Private cPathL		:=	'c:\TABELAS\'
Private aArquivo	:=  directory(cPathL+"*.CSV","D")		//Varredura no Diretorio padrao onde devem se encontrar os xmls para importacao
Private nHandlel	:=	'' 
Private cAuxObs     :=  ''

If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

cfile           :=  dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.log'
nHandlel	    :=	fcreate('C:\TABELAS\'+cfile, FO_READWRITE + FO_SHARED )

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

WinExec('NOTEPAD '+"C:\TABELAS\" + cfile,1)

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
Local nLinha        :=  1
Local lContinua     :=  .T.
Local cItem         :=  1

Private nHandle 	:=	FT_FUse(cPathL+cArquivo) 

FWrite(nHandlel,"#######################################################"+CRLF,1000)

cAuxObs := ''

If nHandlel > 0
    While !FT_FEOF()    
        lContinua := .T.                                          
        cLine	:= FT_FReadLn() // Retorna a linha corrente  
        aAux    := Separa(cLine,";",.T.)
        DbSelectArea("DA0")
        DbSetOrder(1)
        If !Dbseek(xFilial("DA0")+aAux[1])
            FWrite(nHandlel,"Tabela na linha "+cvaltochar(nLinha)+" não encontrada ("+aAux[1]+")"+CRLF,1000)
            Reclock("DA0",.T.)
            DA0->DA0_CODTAB := aAux[1]
            DA0->DA0_DESCRI := 'TABELA IMPORTADA'
            DA0->DA0_DATDE  := DDATABASE-1
            DA0->DA0_HORADE := '00:00'
            DA0->DA0_HORATE := '23:59'
            DA0->DA0_TPHORA := '1'
            DA0->DA0_ATIVO  := '1'
            DA0->DA0_FILIAL := xFilial("DA0")
            DA0->(Msunlock())
        EndIf
        
        DbSelectArea("SB1")
        DbSetOrder(1)
        If !Dbseek(xFilial("SB1")+aAux[2])
            FWrite(nHandlel,"Produto na linha "+cvaltochar(nLinha)+" não encontrada ("+aAux[2]+")"+CRLF,1000)
            lContinua := .F.
            //exit
        EndIf

        nPreco := val(strtran(aAux[3],",","."))

        If lContinua 
            DbSelectArea("DA1")
            DbSetOrder(1)
            If !Dbseek(xFilial("DA1")+aAux[1]+aAux[2])
                Reclock("DA1",.T.)
            else
                Reclock("DA1",.F.)
            EndIf
            
            DA1->DA1_FILIAL := xFilial("DA1")
            If !Empty(DA1->DA1_ITEM)
                DA1->DA1_ITEM   := PegItm(aAux[1])
            Else
                DA1->DA1_ITEM   := strzero(cItem,4)
            EndIf 

            DA1->DA1_TIPPRE := '1'
            DA1->DA1_CODTAB := aAux[1]
            DA1->DA1_CODPRO := aAux[2]
            DA1->DA1_PRCVEN := nPreco
            DA1->DA1_ATIVO  := '1'
            DA1->DA1_TPOPER := '4'
            DA1->DA1_QTDLOT := 999999
            DA1->DA1_MOEDA  := 1
            DA1->(Msunlock())
            cItem++
        endIf

        nLinha++
        FT_FSKIP()
    End       
Else       
    FWrite(nHandlel,"### ARQUIVO NAO ENCONTRADO ###"+CRLF,1000)
endIf

FT_FUse()

If lContinua
    FRename(cPathL+cArquivo,cPathL+'Processados\'+strtran(upper(cArquivo),".CSV",".PROC"))
EndIf

Return   

 /*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
static Function PegItm(cTabela)

Local aArea := GetArea()
Local cRet 
Local cQuery

cQuery := "SELECT MAX(DA1_ITEM) AS ITEM FROM "+RetSQLName("DA1")
cQuery += " WHERE  DA1_CODTAB='"+cTabela+"' AND D_E_L_E_T_=' '"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

cRet := SOMA1(TRB->ITEM)

RestArea(aArea)

Return(cRet)
