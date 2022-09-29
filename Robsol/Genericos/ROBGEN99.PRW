#include "TOTVS.CH"
#include "fileio.ch"
#Include "Restful.Ch"
#include "FWMVCDEF.CH"
#Include "topconn.ch"
#Include "tbiconn.ch"
#include "fileio.ch"

user function gambi01

Local cQuery
Local aAux      :=  {}
Local nX
Local cNum      :=  '0000000001'

cQuery := "SELECT R_E_C_N_O_ AS REG FROM SE1010 "
cQuery += " WHERE E1_NUMBCO<>' ' AND E1_FILIAL BETWEEN ' ' AND 'ZZZ' AND D_E_L_E_T_=' '"


If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf


If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aAux,TRB->REG)
    Dbskip()
ENDDO

DbSelectArea("SE1")

For nX := 1 to len(aAux)
    DbGoto(aAux[nX])
    Reclock("SE1",.F.)
    SE1->E1_NUMBCO := cNum
    SE1->(Msunlock())
    cNum := cvaltochar(STRZERO(val(cNum)+1,10))
Next nX

return
/*
    importar titulos contas a receber
*/
user function gambi02

Local nPos1,nPos2,nPos3,nPos4,nPos5,nPos6,nPos7,nPos8,nCont

Private cPathL		:=	'c:\trash\'
Private nHandle 	:=	FT_FUse(cPathL+'titulos.csv') 
Private aAux        :=  {}
Private cLine       
Private aCabec      :=  {}
Private nLine       :=  1


If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

nHandlel	    :=	fcreate('C:\trash\log.txt', FO_READWRITE + FO_SHARED )

FWrite(nHandlel,"#######################################################"+CRLF,1000)
FWrite(nHandlel,"Inicio :"+cvaltochar(time())+CRLF,1000)

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
   	aAux    := Separa(cLine,";",.T.)
    If nLine == 1 
        Aadd(aCabec,aAux)
        nPos1 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_CLIENTE"})
        nPos2 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_LOJA"})
        nPos3 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_VALOR"})
        nPos4 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_EMISSAO"})
        nPos5 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_VENCTO"})
        nPos6 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_NUM"})
        nPos7 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_PREFIXO"})
        nPos8 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_PARCELA"})
        
        
    Else
        cCliente := ''
        cLoja    := ''

        DbSelectArea("SA1")
        DbSetOrder(3)
        If DbSeek(xFilial("SA1")+aAux[nPos1])

            cCliente := SA1->A1_COD
            cLoja    := SA1->A1_LOJA
            aAux[nPos1] := cCliente
            aAux[nPos2] := cLoja
            aAux[nPos3] := val(strtran(aAux[nPos3],",","."))
            aAux[nPos4] := CTOD(aAux[nPos4])
            aAux[nPos5] := CTOD(aAux[nPos5])
            aAux[nPos6] := strzero(VAL(aAux[nPos6]),9)

            DbSelectArea("SE1")
            Reclock("SE1",.T.)
            For nCont := 1 to len(aCabec[1])
                &("SE1->"+aCabec[1,nCont]) := aAux[nCont]
            Next nCont     
            SE1->E1_VENCREA := datavalida(aAux[nPos5])
            SE1->(Msunlock())
        Else
            FWrite(nHandlel,"Cliente nao encontrado :"+aAux[nPos1]+CRLF,1000)
        EndIf
    EndIf
    nLine++
    FT_FSKIP()
End   

FT_FUse()

Return

/*
    importar titulos contas a receber
*/
user function gambi03

Local nCont

Private cPathL		:=	'c:\trash\'
Private nHandle 	:=	FT_FUse(cPathL+'prodtim.txt') 
Private aAux        :=  {}
Private cLine       
Private aCabec      :=  {}
Private nLine       :=  1


If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

nHandlel	    :=	fcreate('C:\trash\logb10103.txt', FO_READWRITE + FO_SHARED )

FWrite(nHandlel,"#######################################################"+CRLF,1000)
FWrite(nHandlel,"Inicio :"+cvaltochar(time())+CRLF,1000)

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
   	aAux    := Separa(cLine,";",.T.)
    If nLine == 1
        Aadd(aCabec,aAux)
        nPos1 := Ascan(aCabec[1],{|x| Alltrim(x) == "B1_IPI"})
        nPos2 := Ascan(aCabec[1],{|x| Alltrim(x) == "B1_PESO"})
    Else
        DbSelectArea("SB1")
        DbSetOrder(1)
        If !Dbseek(xFilial("SB1")+Avkey(aAux[1],"B1_COD"))
            
            aAux[nPos1] := val(aAux[nPos1])
            aAux[nPos2] := val(aAux[nPos2])
            
            Reclock("SB1",.T.)
            For nCont := 1 to len(aCabec[1])
                &("SB1->"+Alltrim(aCabec[1,nCont])) := aAux[nCont]
            Next nCont

            SB1->B1_FILIAL := xFilial("SB1")
            SB1->(MsUnlock())
        Else
            FWrite(nHandlel,"Produto ja existe :"+Alltrim(aAux[1])+CRLF,1000)
        EndIf
    EndIf

    nLine++
    FT_FSKIP()
End   

FT_FUse()

Return

/*
    importar titulos contas a receber
*/
user function gambi04


Private cPathL		:=	'c:\trash\'
Private nHandle 	:=	FT_FUse(cPathL+'desconto.txt') 
Private aAux        :=  {}

If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

nHandlel	    :=	fcreate('C:\trash\logd1.txt', FO_READWRITE + FO_SHARED )

FWrite(nHandlel,"#######################################################"+CRLF,1000)
FWrite(nHandlel,"Inicio :"+cvaltochar(time())+CRLF,1000)

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
   	aAux    := Separa(cLine,";",.T.)
    
    DbSelectArea("SE1")
    DbSetOrder(1)
    If Dbseek(xFilial("SE1")+Avkey(aAux[2],"E1_PREFIXO")+Avkey(strzero(val(aAux[1]),9),"E1_NUM"))
        While !EOF() .AND. Alltrim(SE1->E1_PREFIXO) == aAux[2] .AND. SE1->E1_NUM == strzero(val(aAux[1]),9)
            Reclock("SE1",.F.)
            SE1->E1_DESCFIN := val(strtran(aAux[3],",",".")) * 100
            SE1->(MsUnlock())
            Dbskip()
        EndDo
    Else
        FWrite(nHandlel,"titulo nao encontrado :"+Alltrim(aAux[1])+CRLF,1000)
    EndIf
    

    FT_FSKIP()
End   

FT_FUse()

Return


/*
    importar titulos contas a receber
*/
user function gambi05

Local aCabec        :=  {}
Local cPathL		:=	'c:\trash\'
Local nHandle 	    :=	FT_FUse(cPathL+'crrob.txt') 
Local aAux          :=  {}
Local nLine         :=  1
Local nCont         :=  0

If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

nHandlel	    :=	fcreate('C:\trash\novocr_02032022.txt', FO_READWRITE + FO_SHARED )

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
   	aAux := Separa(cLine,";",.T.)
    
    If nLine == 1
        Aadd(aCabec,aAux)
        //E1_FILIAL;E1_PREFIXO;E1_NUM;E1_PARCELA;E1_TIPO;E1_NATUREZ;E1_CLIENTE;E1_LOJA;E1_EMISSAO;E1_VENCTO;E1_VALOR;E1_PORTADO;E1_AGEDEP;E1_NUMBCO;E1_IDCNAB
        nPos1 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_NUM"})
        nPos2 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_NATUREZ"})
        nPos3 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_CLIENTE"})
        nPos4 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_LOJA"})
        nPos5 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_VENCTO"})
        nPos6 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_VALOR"})
        nPos7 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_EMISSAO"})
        nPos8 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_PREFIXO"})
        nPos9 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_PARCELA"})
        nPosA := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_FILIAL"})   
        nPosB := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_TIPO"})        
    Else
        aAux[nPos1] := strzero(val(aAux[nPos1]),9)
        aAux[nPos2] := '11010007'
        aAux[nPos5] := ctod(aAux[nPos5])
        aAux[nPos6] := val(strtran(aAux[nPos6],",","."))
        aAux[nPos7] := ctod(aAux[nPos7])
        DbSelectArea("SA1")
        DbSetOrder(3)
        If Dbseek(xFilial("SA1")+aAux[nPos3])
            aAux[nPos3] := SA1->A1_COD
            aAux[nPos4] := SA1->A1_LOJA
            
            DbSelectArea("SE1")
            DbSetOrder(1)
            If !Dbseek(xFilial("SE1")+Avkey(aAux[nPos8],"E1_PREFIXO")+Avkey(aAux[nPos1],"E1_NUM")+Avkey(aAux[nPos9],"E1_PARCELA")+Avkey(aAux[nPosB],"E1_TIPO"))
                Reclock("SE1",.T.)
                For nCont := 1 to len(aCabec[1])
                    &("SE1->"+aCabec[1,nCont]) := aAux[nCont]
                Next nCont
                SE1->E1_VENCREA := datavalida(SE1->E1_VENCTO)
                SE1->E1_FILIAL  := xFilial("SE1")
                SE1->E1_SALDO   := SE1->E1_VALOR
                SE1->(Msunlock())
                Fwrite(nHandlel,"Titulo lançado com sucesso "+aAux[nPos1]+CRLF,1000000)  
            Else
                Fwrite(nHandlel,"Titulo ja esta na base "+aAux[nPos1]+CRLF,1000000)        
            EndIf
            /*If Dbseek(aAux[nPosA]+Avkey(aAux[nPos8],"E1_PREFIXO")+Avkey(aAux[nPos1],"E1_NUM")+Avkey(aAux[nPos9],"E1_PARCELA")+Avkey(aAux[nPosB],"E1_TIPO"))
                If Empty(SE1->E1_EMISSAO)
                    Reclock("SE1",.F.)
                    SE1->E1_EMISSAO := aAux[nPos7]
                    SE1->E1_VENCTO  := aAux[nPos5]
                    SE1->E1_VENCREA := aAux[nPos5]
                    SE1->(MsUnlock())
                ENDIF
            EndIf*/
        Else
            Fwrite(nHandlel,"Cliente não encontrado "+aAux[nPos1]+CRLF,1000000)        
        EndIf
    EndIf

    nLine++

    FT_FSKIP()
End   

FT_FUse()

Return

/*
    importar titulos contas a receber
*/
user function gambi06

Local aCabec        :=  {}
Local cPathL		:=	'c:\trash\'
Local nHandle 	    :=	FT_FUse(cPathL+'crIDCNAB.txt') 
Local aAux          :=  {}
Local nLine         :=  1
Local nCont         :=  0

If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

nHandlel	    :=	fcreate('C:\trash\novocr_280322.txt', FO_READWRITE + FO_SHARED )

While !FT_FEOF()                                              
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
   	aAux := Separa(cLine,";",.T.)
    
    If nLine == 1
        Aadd(aCabec,aAux)
        //E1_FILIAL;E1_PREFIXO;E1_NUM;E1_PARCELA;E1_TIPO;E1_NATUREZ;E1_CLIENTE;E1_LOJA;E1_EMISSAO;E1_VENCTO;E1_VALOR;E1_PORTADO;E1_AGEDEP;E1_NUMBCO;E1_IDCNAB
        nPos1 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_NUM"})
        nPos2 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_NATUREZ"})
        nPos3 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_CLIENTE"})
        nPos4 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_LOJA"})
        nPos5 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_VENCTO"})
        nPos6 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_VALOR"})
        nPos7 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_EMISSAO"})
        nPos8 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_PREFIXO"})
        nPos9 := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_PARCELA"})
        nPosA := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_FILIAL"})   
        nPosB := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_TIPO"})   
        nPosI := Ascan(aCabec[1],{|x| Alltrim(x) == "E1_IDCNAB"})   
    Else
        aAux[nPos1] := strzero(val(aAux[nPos1]),9)
        aAux[nPos2] := '11010007'
        aAux[nPos5] := ctod(aAux[nPos5])
       
        
        DbSelectArea("SE1")
        DbSetOrder(1)
        If Dbseek(xFilial("SE1")+Avkey(aAux[nPos8],"E1_PREFIXO")+Avkey(aAux[nPos1],"E1_NUM")+Avkey(aAux[nPos9],"E1_PARCELA")+Avkey(aAux[nPosB],"E1_TIPO"))
            Reclock("SE1",.F.)
            SE1->E1_IDCNAB   := strtran(aAux[nPosI],"/"," ")
            SE1->(Msunlock())
            Fwrite(nHandlel,"Titulo alterado com sucesso "+aAux[nPos1]+CRLF,1000000)  
        Else
            Fwrite(nHandlel,"Titulo nao encontrado "+aAux[nPos1]+CRLF,1000000)        
        EndIf
        
               
    EndIf

    nLine++

    FT_FSKIP()
End   

FT_FUse()

Return
/*
    importar titulos contas a receber
*/
user function gambi17

Local aCabec        :=  {}
Local cPathL		:=	'c:\trash\'
Local aAux          :=  {}
Local aItens        :=  {}
Local nCont         :=  0
Local nCC           :=  1

Local oFile := FwFileReader():New(cPathL+'SRA.CSV')
    
If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

ACAMPOSA := FWSX3Util():GetAllFields( "SRA" , .F. )

If (oFile:Open())
    aAux := oFile:GetAllLines() // ACESSA TODAS AS LINHAS
    aCabec := Separa(aAux[1],";",.T.)
    For nCont := 2 to len(aAux)
        nPos := Ascan(aCabec,{|x| Alltrim(x) == "RA_MAT"})
        aItens := Separa(aAux[nCont],";",.T.)
        DbSelectArea("SRA")
        DbSetOrder(1)
        If !Dbseek(xFilial("SRA")+aItens[nPos])
            Reclock("SRA",.T.)
            For nCC := 1 to len(aCabec)-1 
                If Ascan(ACAMPOSA,{|x| Alltrim(x) == Alltrim(aCabec[nCC])}) > 0 
                    aAux2 := FWSX3Util():GetFieldStruct( aCabec[nCC] )
                    IF aCabec[nCC] == "RA_HRSMES"   
                        MSGALERT("E")
                    ENDIF
                    If aAux2[2] == "C"
                        &('SRA->'+aCabec[nCC]) := aItens[nCC]
                    ElseIf aAux2[2] == "N"
                        &('SRA->'+aCabec[nCC]) := val(aItens[nCC])
                    Else
                        lDate := aCabec[nCC] $ 'RA_NASC/RA_ADMISSA/RA_OPCAO/RA_VCTOEXP/RA_VCTEXP2/RA_DTRGEXP/RA_DTCPEXP'
                        &('SRA->'+aCabec[nCC]) := If(lDate,ctod(aItens[nCC]),aItens[nCC])
                    EndIf
                EndIf
            Next nCC
            SRA->(Msunlock())
        EndIf
    Next nCont
endif 


Return

/*
    importar titulos contas a receber
*/
user function gambi18

Local aCabec        :=  {}
Local cPathL		:=	'c:\trash\'
Local aAux          :=  {}
Local aItens        :=  {}
Local nCont         :=  0
Local nCC           :=  1

Local oFile := FwFileReader():New(cPathL+'SRB.CSV')
    
If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

ACAMPOSA := FWSX3Util():GetAllFields( "SRB" , .F. )

If (oFile:Open())
    aAux := oFile:GetAllLines() // ACESSA TODAS AS LINHAS
    aCabec := Separa(aAux[1],";",.T.)
    For nCont := 2 to len(aAux)
        nPos := Ascan(aCabec,{|x| Alltrim(x) == "RB_MAT"})
        aItens := Separa(aAux[nCont],";",.T.)
        DbSelectArea("SRB")
        DbSetOrder(1)
        If !Dbseek(xFilial("SRB")+aItens[nPos])
            Reclock("SRB",.T.)
            For nCC := 1 to len(aCabec)-1 
                If Ascan(ACAMPOSA,{|x| Alltrim(x) == Alltrim(aCabec[nCC])}) > 0 
                    aAux2 := FWSX3Util():GetFieldStruct( aCabec[nCC] )
                    
                    If aAux2[2] == "C"
                        &('SRB->'+aCabec[nCC]) := aItens[nCC]
                    ElseIf aAux2[2] == "N"
                        &('SRB->'+aCabec[nCC]) := val(aItens[nCC])
                    Else
                        lDate := aCabec[nCC] $ 'RB_DTNASC'
                        &('SRB->'+aCabec[nCC]) := If(lDate,ctod(aItens[nCC]),aItens[nCC])
                    EndIf
                EndIf
            Next nCC
            SRB->(Msunlock())
        EndIf
    Next nCont
endif 


Return

User Function xgambi19
Local nCont
Local aPergs := {}
Local aRet   := {}
Local cAlias := space(3)

If Empty(FunName())
    RpcSetType(3)
    //RPCSetEnv("00","00001000100")
    RPCSetEnv("01","0101")
EndIf

aAdd( aPergs ,{1,"Tabela : "     ,cAlias   ,"@!",'.T.',"",'.T.',40,.F.})

If ParamBox(aPergs ,"Informe a tabela",@aRet)

    cAlias := aRet[1]
    cNome  := FWX2Nome( cAlias )
    cUnKey := FWX2Unico( cAlias ) 
    aCampos := FWSX3Util():GetListFieldsStruct( cAlias , .F. ) 

    For nCont := 1 to len(aCampos)
        aCampos[nCont,04] := FWSX3Util():GetDescription( aCampos[nCont,01] )
    Next nCont
EndIf

Return


User function xEsto

Local nCont
Local aPergs := {}
Local aRet   := {}
Local cAlias := space(3)
Private cPathL		:=	'c:\temp\'
Private nHandle 	:=	FT_FUse(cPathL+'esto_robsol.txt') 

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

While !FT_FEOF() 
    cLine	:= FT_FReadLn() // Retorna a linha corrente  
    aAux    := Separa(cLine,";",.T.)
    DbSelectArea("SB9")
    Reclock("SB9",.T.)
    SB9->B9_FILIAL := xFilial("SB9")
    SB9->B9_DATA   := CTOD('28/02/2022')
    SB9->B9_COD    := aAux[1]
    SB9->B9_LOCAL  := cvaltochar(aAux[2])
    SB9->B9_QINI   := VAL(aAux[3])
    SB9->B9_VINI1  := VAL(aAux[4])
    SB9->(Msunlock())
    FT_FSKIP()
End   

FT_FUse()
Return
