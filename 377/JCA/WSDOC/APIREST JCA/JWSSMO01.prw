#include "Totvs.ch"
#include "RESTFUL.ch"

//CLASS
Class JWSSMO01
    data    COD_GRUPO
    data    DES_GRUPO
    data    COD_EMPRES
    data    DES_EMPRES
    data    CGC_EMPRES          
    //data    CGC_EMPRES

    METHOD New()
EndClass

METHOD New() Class JWSSMO01
    Self:COD_GRUPO      := ""
    Self:DES_GRUPO      := ""
    Self:COD_EMPRES     := ""
    Self:DES_EMPRES     := ""
    Self:CGC_EMPRES     := ""
Return


WSRESTFUL JWSSMO01 DESCRIPTION "API para interação com estabelecimento(Grupo de Empresa e Filial do Protheus"

    WSMETHOD GET DESCRIPTION 'Retorna todos os estabelimentos cadastrados no sistema' WSSYNTAX '/JWSSMO01'

END WSRESTFUL
//sperar código do grupo da empresa e incluir descrição do grupo

//criar o method
WSMETHOD GET WSSERVICE JWSSMO01

    Local aEstab := {}

    MyOpenSM0()
    SM0->( DBGOTOP() )

    WHILE !SM0->( EOF() )
        oEstab                  := JWSSMO01():New()

        oEstab:COD_GRUPO            := ALLTRIM(SM0->M0_CODIGO) 
        oEstab:DES_GRUPO            := EncodeUTF8(ALLTRIM(SM0->M0_NOME), "cp1252")
        oEstab:COD_EMPRES           := ALLTRIM(SM0->M0_CODFIL)
        oEstab:DES_EMPRES           := EncodeUTF8(ALLTRIM(SM0->M0_FILIAL), "cp1252")
        oEstab:CGC_EMPRES           := ALLTRIM(SM0->M0_CGC)
       // oEstab:DES_EMPRES           := ALLTRIM(SM0->M0_)
        
    
        AADD( aEstab, oEstab)

        SM0->( DBSKIP() )
    ENDDO

    ::SetContentType("application/json")

    ::SetResponse(FWJsonSerialize(aEstab, .F., .T.))
    
RETURN .T.

//ABRE O SM0
STATIC FUNCTION MyOpenSM0()
    LOCAL lOpen := .F.
    LOCAL i := 0

    IF !EMPTY(  SELECT('SM0'))
        lOpen := .T.
    ELSE

        FOR i := 1 TO 20
            dbUseArea(  .T., , 'SIGAMAT.EMP',   'SMO',  .T.,    .F.)
            IF !EMPTY(  SELECT('SM0'))
                lOpen := .T.
                dbSetIndex('SIGAMAT.IND')
                EXIT
            ENDIF
            Sleep(500)
        NEXT
    ENDIF
RETURN lOpen
