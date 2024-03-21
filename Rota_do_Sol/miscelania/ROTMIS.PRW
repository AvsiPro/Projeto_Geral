#include "totvs.ch"
#include "fwmvcdef.ch"
#Include "TopConn.ch"
#include "rwmake.ch"

/*
+----------------------------------------------------------------------------+
!Descricao         ! Programas Com Funcoes Distintas no sistema              !
+------------------+---------------------------------------------------------+
!Programa          ! ROTMIS                                                  !
+------------------+---------------------------------------------------------+
!Autor             ! Marcio Da Silva                                         !
+------------------+---------------------------------------------------------+
!Empresa           ! TOTVS                                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 26/08/2023                                              !
+------------------+---------------------------------------------------------+
*/



**************************
User Function AF010DEL() // Ponto de Entrada Exclusao ATFA012 - ATIVO FISICO
*************
Local cQuery  	:= ''
    nQueryRet := TCSQLEXEC(cQuery)
	cQuery := " UPDATE  " + retSqlName("CT2")       									 + CRLF
	cQuery += " SET CT2_ZZINTA = '', "    										 	 	 + CRLF
	cQuery += "     CT2_ZZFILA = '', "    												 + CRLF
	cQuery += "     CT2_ZZCAI = '', "    									 			 + CRLF
	cQuery += "     CT2_ZZITAI = '', "    									 			 + CRLF
	cQuery += "     CT2_ZZDTAI = '', "    							 					 + CRLF
	cQuery += "     CT2_ZZHRAI = '' "   										 	 	 + CRLF
	cQuery += " WHERE CT2_ZZFILA = '"+xFilial("CT2")+"' "							 	 + CRLF
	cQuery += " AND CT2_ZZCAI = '"+Alltrim(SN1->N1_CBASE)+"' "   			 			 + CRLF
	cQuery += " AND CT2_ZZITAI = '"+Alltrim(SN1->N1_ITEM)+"' "    						 + CRLF
	cQuery += " AND D_E_L_E_T_ = ' '"	 			    						 	 + CRLF
 nQueryRet := TCSQLEXEC(cQuery)
Return




************************
User Function CT101TOK() // Confirmacao de alteracao de registro
*************
Local tRet := .T.
If (Altera .Or. OPCAO == 5) .And. CT2->CT2_ZZINTA=='1'
	tRet := .F.
	Help( " ", 1, "CT101TOK",,"Registro Vinculado ao Ativo = " + CT2->CT2_ZZCAI + " Item = " + CT2->CT2_ZZITAI, 1, 0 ) //"A conta contábil débito está configurada para não permitir a 
EndIf 
Return(tRet)


************************
User Function CT102VLES() // ctba102 exclusao
*************
Local tRet := .T.
If Altera .And. CT2->CT2_ZZINTA=='1'
	tRet := .F.
	Help( " ", 1, "CT102VLES",,"Registro Vinculado ao Ativo = " + CT2->CT2_ZZCAI + " Item = " + CT2->CT2_ZZITAI, 1, 0 ) //"A conta contábil débito está configurada para não permitir a 
EndIf 
Return(tRet)

************************
User Function CTB102EXC() // ctba102 exclusao
*************
Local tRet := .T.
If (Altera .Or. OPCAO == 5) .And. CT2->CT2_ZZINTA=='1'
	tRet := .F.
	Help( " ", 1, "CTB102EXC",,"Registro Vinculado ao Ativo = " + CT2->CT2_ZZCAI + " Item = " + CT2->CT2_ZZITAI, 1, 0 ) //"A conta contábil débito está configurada para não permitir a 
EndIf 
Return(tRet)


************************
User Function ROTMIS01(cCNPJ) // ctba102 exclusao
*************
Local nInd     := 0
Local aSx3Cpo  := { 'A2_NOME', 'A2_NREDUZ', 'A2_EST', 'A2_CEP', 'A2_BAIRRO', 'A2_MUN', 'A2_COD_MUN', 'A2_END', 'A2_TIPO', 'A2_DDD', 'A2_TEL', 'A2_CNAE' }
Local aRetCpo,aSetCpo  := {}

   aRetJson := APIForCli(cCNPJ) // Realiza o POST de consulta CNPJ na Carol
   oRest    := JsonObject():New()
   oRest:FromJson(aRetJson[2])
   aRet     := oRest:GetJsonObject("hits")

	If ValType(aRet) == "U" .OR. Len(aRet) == 0
		lRet := .F.
	Else
		If !( aRetJson[1] )
			lRet := .F.
		Else
			oRetJson := oRest["hits"][1]["mdmGoldenFieldAndValues"]
			For nInd := 1 To Len( aSx3Cpo )
				aRetCpo := fROTMIS01A( oRetJson, aSx3Cpo[ nInd ] )
				Aadd( aSetCpo,{ aSx3Cpo[ nInd ], aRetCpo[ 1 ][ 1 ], aRetCpo[ 1 ][ 2 ] } )
			Next nInd
		EndIf
	EndIf
Return(aSetCpo)   

***********************************************
Static Function fROTMIS01A( oRetJson, cSx3Cpo ) // Guarda No Array Os Dados Do Fornecedor do Objeto
***************
Local xRet  := Nil
Local aRet  := {}
Local aTel  := {}
Local _nTmDDD       := GetSX3Cache("A1_DDD", "X3_TAMANHO")
Local _nTmTel       := GetSX3Cache("A1_TEL", "X3_TAMANHO")

   IF !type('oRetJson["mdmphone"][2]["mdmphonenumber"]"') == 'U'
      aTel  := RemDddTel( oRetJson["mdmphone"][2]["mdmphonenumber"] )
   EndIf   

   Do Case
      Case cSx3Cpo == 'A2_NOME'
         IF !type('oRetJson["mdmname"]') == 'U'
            Aadd( aRet, { Upper( DecodeUTF8( oRetJson["mdmname"] ) ), .F. } )
         Else 
            Aadd( aRet, { '', .F. } )
         EndIf
      Case cSx3Cpo == 'A2_NREDUZ'
         IF !type('oRetJson["mdmdba"]') == 'U'
            Aadd( aRet, { Upper( DecodeUTF8( oRetJson["mdmdba"] ) ), .F. } )
         Else 
            Aadd( aRet, { '', .F. } )
         EndIf
      Case cSx3Cpo == 'A2_COD_MUN'
         IF !type('oRetJson["mdmaddress"][1]["mdmstate"]') == 'U' .And. !type('oRetJson["mdmaddress"][1]["mdmcity"]') == 'U'
            Aadd( aRet, { Posicione("CC2",4,xFilial("CC2")+oRetJson["mdmaddress"][1]["mdmstate"]+oRetJson["mdmaddress"][1]["mdmcity"],"CC2_CODMUN"), .F. } )
         Else 
            Aadd( aRet, { '', .F. } )
         EndIf
      Case cSx3Cpo == 'A2_EST'
         IF !type('oRetJson["mdmaddress"][1]["mdmstate"]') == 'U'
            Aadd( aRet, { oRetJson["mdmaddress"][1]["mdmstate"], .F. } )
         Else 
            Aadd( aRet, { '', .F. } )
         EndIf
      Case cSx3Cpo == 'A2_CEP'
         IF !type('oRetJson["mdmaddress"][1]["mdmzipcode"]') == 'U'
            Aadd( aRet, { oRetJson["mdmaddress"][1]["mdmzipcode"], .F. } )
         Else 
            Aadd( aRet, { '', .F. } )
         EndIf
      Case cSx3Cpo == 'A2_BAIRRO'
         IF !type('oRetJson["mdmaddress"][1]["mdmaddress3"]') == 'U'
            Aadd( aRet, { oRetJson["mdmaddress"][1]["mdmaddress3"], .F. } )
         Else 
            Aadd( aRet, { '', .F. } )
         EndIf
      Case cSx3Cpo == 'A2_MUN'                     
         IF !type('oRetJson["mdmaddress"][1]["mdmcity"]') == 'U'
            Aadd( aRet, { oRetJson["mdmaddress"][1]["mdmcity"], .F. } )
         Else 
            Aadd( aRet, { '', .F. } )
         EndIf
      Case cSx3Cpo == 'A2_END'                     
         IF !type('oRetJson["mdmaddress"][1]["mdmaddress1"]') == 'U'
            Aadd( aRet, { Upper( oRetJson["mdmaddress"][1]["mdmaddress1"] ), .F. } )
         Else 
            Aadd( aRet, { '', .F. } )
         EndIf
      Case cSx3Cpo == 'A2_TIPO'                  
         Aadd( aRet, { Iif( Len( AllTrim( oRetJson["mdmtaxid"] ) ) == 11,;
                            "F",;
                            "J" ), .F. } )
      Case cSx3Cpo == 'A2_DDD'
         If Len(aTel)> 0 
            Aadd( aRet, { IIf( Empty(aTel[2]),;
                              Space(_nTmDDD),;
                              PadR(aTel[2], _nTmDDD) ), .F. } )
         Else 
            Aadd( aRet, { '', .F. } )
         EndIf                              
      Case cSx3Cpo == 'A2_TEL'
         If Len(aTel)> 0 
            Aadd( aRet, { IIf( Empty(aTel[1]),;
                              Space(_nTmTel),;
                              PadR(aTel[1], _nTmTel) ), .F. } )
         Else 
            Aadd( aRet, { '', .F. } )
         EndIf                              
      Case cSx3Cpo == 'A2_CNAE'
         If !Empty( oRetJson["cnaebr"] )
            If Len( AllTrim( oRetJson["cnaebr"] ) ) == 7
               xRet := SubStr( oRetJson["cnaebr"], 1, 4 ) +'-'+ SubStr( oRetJson["cnaebr"], 5, 1 ) +'/'+ SubStr( oRetJson["cnaebr"], 6, 2 )
            Else
               xRet := oRetJson["cnaebr"]
            EndIf
         EndIf
         Aadd( aRet, { xRet, .T. } )
   EndCase
Return aRet


