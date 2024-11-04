#include "rwmake.ch"  
#Include "SigaWin.ch"
/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT1116GRV  ¦ Utilizador ¦ Eder França     ¦ Data ¦ 25/08/22¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Este ponto de entrada pertence a rotina de digitação de    ¦¦¦
¦¦¦          ¦ conhecimento de frete, MATA116()                           ¦¦¦
¦¦¦          ¦ Alteração - Everton Rosa 24/10/2024 - Retirar a            ¦¦¦
¦¦¦			 ¦funcionalidade para o grupo de empresa 03 		          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-MT                                                  ¦¦¦    
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MT116GRV

Local cEmpNExc := SuperGetMV("TI_EMPNEXC",.F.,"03")
Local _nPosCod     := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "D1_COD"})  
Local _nPosDesc    := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "D1_DESCRIC"})     
Local _cDescPro    := ""
Local _cCodProd    := ""
Local I            := 0
 
IF !cEmpAnt $ cEmpNExc 
		Return
	endif 
_cCodProd := aCols[n,ASCAN(aHeader,{|x| ALLTRIM(x[2]) == "D1_COD" })]                                                                                                                       
  
FOR I := 1 TO LEN(aCols)                  

     _cCodProd     := aCols[I,_nPosCod]
     _cDescPro     := POSICIONE("SB1",1,XFILIAL("SB1")+_cCodProd,"B1_DESC")

     aCols[I,_nPosDesc] := Alltrim(_cDescPro)

NEXT I

Return
