#include "Protheus.ch"
 
/*
===============================================================================================================================
Programa----------: F380FIL 
===============================================================================================================================
Descrição---------: Ponto de Entrada com o objetivo de complementar os filtro de registros na conciliação bancaria 
===============================================================================================================================
Uso---------------: Filtra no momento da montagem da conciliação bancaria
===============================================================================================================================
Parâmetros--------: Nenhum
===============================================================================================================================
Retorno-----------: cFiltro = instrução do filtro a ser realizado em sintaxe SQL
===============================================================================================================================
*/
User Function F380FIL()
 
    Local aArea     := GetArea()
    Local cFil1    := space(4)
    Local _cTipoMov  := ""
    Local oDlg1     := NIL
    Local oGrp1     := NIL
    Local _oTipoMov  := NIL
    Local aOpcoes := {"Ambos","Receber","Pagar"}
 
    _cTipoMov := "Ambos"
   
    DEFINE MSDIALOG oDlg1 TITLE "Conciliação Bancaria" FROM 162,370 TO 320,770 PIXEL
 
        oGrp1   := TGroup():New( 008,012,074,188,"Filtro",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            @ 028,016   SAY "Filial: "    of oGrp1            PIXEL
            @ 026,040   MSGET cFil1     size 060,008 of oGrp1   PIXEL

            @ 044, 016 Say "Tipo: "  Pixel Size 050,006 Of oGrp1
            @ 042, 040 MSCOMBOBOX _oTipoMov Var _cTipoMov ITEMS  aOpcoes Pixel Size 070, 012 Of oGrp1
             
    DEFINE SBUTTON FROM 058,060 TYPE 1 ACTION (oDlg1:End()) ENABLE OF oDlg1 // 085,115

    Activate Dialog oDlg1 Center
     
    cFiltro := "(E5_FILORIG = '"+ cFil1 +"') " /* AND E5_FILORIG <= '"+ cFil2 +"') "/*AND " +;
                "(E5_VALOR >= "+ str(nVal1) +" AND E5_VALOR <="+ str(nVal2) +") "
                 */
    If AllTrim(_cTipoMov) == "Receber"
       cFiltro += " AND E5_RECPAG = 'R' "
    EndIf
     
    If AllTrim(_cTipoMov) == "Pagar"
       cFiltro += " AND E5_RECPAG = 'P' "
    EndIf
 
    RestArea(aArea)
         
Return cFiltro
