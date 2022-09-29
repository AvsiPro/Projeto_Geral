#INCLUDE"PROTHEUS.CH"

USER FUNCTION MT103INF()

Local n_pos		:= aScan(aHeader,{|x|alltrim(x[2])=='D1_CC'	})

// AMC
If cEmpAnt == "10"
	Return
EndIf

ACOLS[N,n_pos] := SD2->D2_CCUSTO



RETURN()