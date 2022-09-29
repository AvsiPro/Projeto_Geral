#INCLUDE "PROTHEUS.CH"
#include "tbiconn.ch"

User Function ttajusfd()

Local aArea	:=	GetArea()
Local aAux	:=	{}

Prepare Environment Empresa "01" Filial "01" Tables "SZI" 

cquery := "SELECT ZI_PATRIMO,COUNT(*) FROM SZI010 WHERE ZI_TIPO<>'8' AND ZI_PATRIMO<>'' GROUP BY ZI_PATRIMO ORDER BY 1"
                                                                                                    
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTCMRL01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{TRB->ZI_PATRIMO,0,'',0,0,0,'',''})
	Dbskip()
EndDo
 
For nX := 1 to len(aAux)
	cquery := "SELECT * FROM SZI010 WHERE ZI_PATRIMO='"+aAux[nX,01]+"' AND ZI_TIPO ='1' AND ZI_DATA =(SELECT MAX(ZI_DATA) FROM SZI010 WHERE ZI_PATRIMO='"+aAux[nX,01]+"' AND ZI_TIPO ='1')"
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	  
	MemoWrite("TTCMRL01.SQL",cQuery)
	
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
	DbSelectArea("TRB")
	If !EMPTY(TRB->ZI_PATRIMO)	
		aAux[nX,02] := TRB->ZI_FDOTRO
		aAux[nX,03] := TRB->ZI_DATA                                             
		If Posicione("SN1",2,xFilial("SN1")+aAux[nX,01],"N1_XLIMTRO") <> 0	
			cVlrtr := Posicione("SN1",2,xFilial("SN1")+aAux[nX,01],"N1_XLIMTRO")
		Else
			cVlrtr := 115
		EndIf
		      
		If TRB->ZI_FDOTRO < 0
			aAux[nX,04] := -((TRB->ZI_FDOTRO*-1)+ (cVlrtr / 2))
		Else
			aAux[nX,04] := (TRB->ZI_FDOTRO - (cVlrtr / 2))
		EndIF                        
		
		aAux[nX,04] :=  aAux[nX,04] * -1
		aAux[nX,05] := (cVlrtr / 2)    
		aAux[nX,06] := TRB->ZI_CNTCAS
		aAux[nX,07] := TRB->ZI_CLIENTE
		aAux[nX,08] := TRB->ZI_LOJA
	EndIf
	
Next nX

For nX := 1 to len(aAux)
	If aAux[nX,05] <> 0
		Reclock("SZI",.T.)
		SZI->ZI_PATRIMO 	:=	aAux[nX,01]
		SZI->ZI_DATA		:=	Ddatabase
		SZI->ZI_TIPO		:=	'8'
		SZI->ZI_VLRAJU		:=	aAux[nX,04]
		SZI->ZI_LIMTRO		:=	aAux[nX,05] * 2
		SZI->ZI_FDOTRO		:=	aAux[nX,05]
		SZI->ZI_CLIENTE		:=	aAux[nX,07]
		SZI->ZI_LOJA		:=	aAux[nX,08]
		SZI->ZI_CNTCAS		:=	aAux[nX,06]
		SZI->(Msunlock())
	EndIf		
Next nX

RestArea(aArea)

Return