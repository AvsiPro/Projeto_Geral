#INCLUDE "PROTHEUS.CH
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ttPagItau   ºAutor  ³RFB SISTEMAS   	 º Data ³  2014   	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tratativa de SISPAG para DOC/TED							  º±±
±±º          ³                                      					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

                                                  '

User Function PagItau(_cOpcao)

Local  _cTipo     := ""
Local  _cRetorno  := ""
Local  _cBanco 	  := ""                       
Local  _Agc		  := ""
Local  _DigAgc	  := ""
Local  _CtaCed	  := ""
Local  _CtaDV     := ""
Local  aArea      := GetArea()

_cTipo    := Alltrim(Upper(_cOpcao))

Do Case

  Case _cTipo == "PGIT_1"  //  Codigo do Banco               
	       
          IF !EMPTY(SE2->E2_XBANCO)
          	_cBanco := SE2->E2_XBANCO
          Else
          	_cBanco := POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_BANCO")
          Endif
       
       _cRetorno:= _cBanco
  
  Case _cTipo == "PGIT_2"
  
	 		IF !EMPTY(SE2->E2_XAGENCI)
	 			
	 			_Agc := "0"+SUBS(SE2->E2_XAGENCI,1,4)
	 			
	 			If	!EMPTY(ALLTRIM(Substr(SE2->E2_XAGENCI,6,1)))
       		   		_DigAgc := (ALLTRIM(Substr(SE2->E2_XAGENCI,6,1)))
       		 	Else
       		 		_DigAgc := " "
       			Endif        
	 		Else
	 			_Agc := "0"+SUBS(POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_AGENCIA"),1,4)
	 		Endif
	 		
   			_cRetorno := _Agc+_DigAgc

	Case _cTipo == "PGIT_3"

	       	IF !EMPTY(SE2->E2_XCONTA)
	       			_CtaCed := strzero(val(SE2->E2_XCONTA),12,0)+" "
	       			_CtaDV  := SUBS(SE2->E2_XCONTA,14,1)
	       	Else
	       		    _CtaCed := SUBS(SA2->A2_NUMCON,1,12)+" "+SUBS(SA2->A2_NUMCON,14,1)    
	       	Endif
	       	
				_cRetorno := _CtaCed+_CtaDV
ENDCASE

RestArea(aArea)		      
RETURN(_cRetorno) 