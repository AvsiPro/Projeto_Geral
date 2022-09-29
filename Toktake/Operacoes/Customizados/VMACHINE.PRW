#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO9     ºAutor  ³Microsiga           º Data ³  10/28/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Class VMACHINE
             
	Data cPlaqueta As String
	Data cCodModel As String
	Data cDescModel As String
	Data cTipo	As String
	Data cTabPreco As String
	Data aMapa As Array
	Data lColetaPs As Boolean
	Data nCapacidade As Integer
	Data cLatitude As String
	Data cLongitude As String
	Data cCodPa As String
	Data cDescPa As String
	Data cCodCli As String
	Data cLoja As String
	Data cLocFis As String
	Data lTelemet As Boolean
	Data cContrato As String
	
	
	Method New( cPlaqueta ) CONSTRUCTOR
	//Method Init( cPlaqueta )
    Method install( dData )
    Method remove( dData )
    Method readHist()
    Method readStock( lTelemet )
    Method newMap( aMap )
    Method updateMap( aMap )
    Method readMap()
    Method readSupply( dInicio, dFim )
    Method readCounters( dInicio, dFim )

EndClass


// instancia de objeto
Method New( cPlaqueta ) CLASS VMACHINE
    	                            	     
	Default cPlaqueta := ""
	/*
	::cPlaqueta := cPlaqueta                
	Self:cCodModel := ""
	Self:cDescModel := ""
	Self:cCodCli := ""
	Self:cLoja := ""
	Self:cCodPa := ""
	Self:cLocFis := ""
	Self:lTelemet := ""
	Self:cLatitude := ""
	Self:cLongitude := ""
	Self:cTabPreco := ""	
	Self:cDescPa := ""  
	Self:cTipo := ""
	Self:aMapa := {}
	Self:lColetaPs := .F.
	Self:nCapacidade := 0
	Self:cContrato := "" 
	*/
	If !Empty( cPlaqueta )
		InitVM(cPlaqueta)	//::Init() 
	EndIf

Return Self


/*
Method Init() Class VMACHINE

	Local cTipo := "" 
	
	If Empty( Self:cPlaqueta )
		Return
	EndIf
    	
	dbSelectArea("AA3")
	dbSetOrder(7)
	If MsSeek( xFilial("AA3") +AvKey(cPlaqueta,"AA3_CHAPA") )
		Self:cCodModel := AA3->AA3_CODPRO
		Self:cCodCli := AA3->AA3_CODCLI
		Self:cLoja := AA3->AA3_LOJA
		Self:cCodPa := AA3->AA3_SITE
		Self:cLocFis := AA3->AA3_LOCAL
		//::lTelemet := AA3->AA3_XTELEM
		//::cLatitude := AA3->AA3_XLAT
		//::cLongitude := AA3->AA3_XLNG
		//::cTabPreco := AA3->AA3_XTABPRC
		
		Self:cDescPa := Posicione( "ZZ1",1,xFilial("ZZ1") +AvKey(Self:cCodPa,"ZZ1_CODIGO"),"ZZ1_DESCRI" )
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If MSSeek( xFilial("SB1") +AvKey(Self:cCodModel,"B1_COD") )
			Self:cDescModel := AllTrim( SB1->B1_DESC )
			cTipo := SB1->B1_XFAMILI
			
			If cTipo == "144"
				Self:cTipo := ""
			ElseIf cTipo == ""
				Self:cTipo := ""
			ElseIf cTipo == ""
				Self:cTipo := ""
			EndIf
		EndIf
		
		Self:aMapa := ::verMapa()
		
		// Tem coleta de PS?
		dbSelectArea("ZZP")
		dbSetOrder(1)
		If MsSeek( xFilial("ZZP") +AvKey( ::cCodModel,"ZZP_CODIGO") )
			Self:lColetaPs := ZZP->ZZP_LEITUR
			Self:nCapacidade := ZZP->ZZP_CAPAC
		EndIf
		
		// contrato da maquina?
		Self:cContrato := ""
		
	EndIf
	
Return
*/


// inicializar
Static Function InitVM(cPlaqueta)

	Local cTipo := ""
	
	If Empty( cPlaqueta )
		Return
	EndIf
    	
	dbSelectArea("AA3")
	dbSetOrder(7)
	If MsSeek( xFilial("AA3") +AvKey(::cPlaqueta,"AA3_CHAPA") )
		Self:cCodModel := AA3->AA3_CODPRO
		Self:cCodCli := AA3->AA3_CODCLI
		Self:cLoja := AA3->AA3_LOJA
		Self:cCodPa := AA3->AA3_SITE
		Self:cLocFis := AA3->AA3_LOCAL
		//::lTelemet := AA3->AA3_XTELEM
		//::cLatitude := AA3->AA3_XLAT
		//::cLongitude := AA3->AA3_XLNG
		//::cTabPreco := AA3->AA3_XTABPRC
		
		Self:cDescPa := Posicione( "ZZ1",1,xFilial("ZZ1") +AvKey(Self:cCodPa,"ZZ1_CODIGO"),"ZZ1_DESCRI" )
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If MSSeek( xFilial("SB1") +AvKey(Self:cCodModel,"B1_COD") )
			Self:cDescModel := AllTrim( SB1->B1_DESC )
			cTipo := SB1->B1_XFAMILI
			
			If cTipo == "144"
				Self:cTipo := ""
			ElseIf cTipo == ""
				Self:cTipo := ""
			ElseIf cTipo == ""
				Self:cTipo := ""
			EndIf
		EndIf
		
		Self:aMapa := ::readMap()
		
		// Tem coleta de PS?
		dbSelectArea("ZZP")
		dbSetOrder(1)
		If MsSeek( xFilial("ZZP") +AvKey( ::cCodModel,"ZZP_CODIGO") )
			Self:lColetaPs := ZZP->ZZP_LEITUR
			Self:nCapacidade := ZZP->ZZP_CAPAC
		EndIf
		
		// contrato da maquina?
		Self:cContrato := ""
		
	EndIf      


Return


 
// instala a maquina no cliente
Method install( dData ) Class VMACHINE

Return

// remove a maquina do cliente atual
Method remove( dData ) Class VMACHINE

Return

// retorna o historico de instalacoes dessa maquina
Method readHist() Class VMACHINE


Return



// ver saldo atual da maquina - telemetria
Method readStock( lTelemet ) Class VMACHINE

	Local aSaldo := {}
    
	// telemetria
	If lTelemet
		If !Self:lTelemet
			Return aSaldo         
		Else
			// busca do vmPay
		EndIf    
	// SZ0 - ultimo abastecimento
	Else
	
	EndIf
	
Return

// incluir novo mapa de maquina
Method newMap( aMap ) Class VMACHINE

	Local lRet := .F.
	
	Default aMapa := {}
	If Empty( aMapa )
		Return lRet
	EndIf     
	
	If Empty( Self:cPlaqueta )
		Return lRet
	EndIf
	
	lRet := STATICCALL( VMFUNCS, newMap, Self:cPlaqueta, aMapa )   
	
Return lRet

// retorna o mapa da maquina
Method readMap() Class VMACHINE
	
	Self:aMapa := STATICCALL( VMFUNCS, readMap, ::cPlaqueta )
	
Return


// atualizar o mapa da maquina
Method updateMap() Class VMACHINE

	// atualiza SZH
	     

Return




// ver abastecimentos do periodo
Method readSupply( dInicio,dFim ) Class VMACHINE

Return

// ver leituras do periodo
Method readCounters( dInicio, dFim ) Class VMACHINE

Return