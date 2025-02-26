#Include 'Protheus.ch'
#Include 'Topconn.ch'

 /*/{Protheus.doc} DadosEtq
Utilizado para informar os dados pertinentes a etiquetas.

@author    Paulo Lima
@since    17/12/2021
@return    aRet
/*/
User Function DadosEtq(aDados)

	Local cCod		:= AllTrim(aDados[1]) && Código da etiqueta lida
	Local cProduto	:= ""	
	Local nQuant	:= 0	
	Local cLote		:= ""	
	Local dValid	:= CToD("")
	Local cNumSer	:= ""
	Local aRet	 	:= {}
	

	If Upper(Alltrim(FunName())) == "ACDV167"
		cCod 		:= cCod
		cProduto 	:= cProduto
		nQuant		:= nQuant
		cLote		:= cLote
		dValid		:= dValid
		cNumSer		:= cNumSer
		aRet		:= aRet
	else

	endif

	/*/
	cNada   := cCod
	cProduto:= "HB750          "
	nQuant	:= 10
	cLote	:= "741""
	
	aRet := {cProduto, nQuant, cLote, dValid, cNumSer}
	/*/

Return(aRet)
