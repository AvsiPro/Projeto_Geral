#INCLUDE 'protheus.ch'

/*/{Protheus.doc} User Function ROBCMS06
    @type  Function
    @author user
    @since 14/09/2022
    @version 1
    @return lRet, boolean
    /*/
User Function ROBCMS06()

    Local lRet := .F.

    if '000002' $ UsrRetGrp( , RetCodUsr())
        lRet := .T.
    endif

Return lRet
