#include "protheus.ch"

User Function GrpMenux

Local aGrp	:= {}
Local aAllGrp := AllGroups()

For nI := 1 to len(aAllGrp)
	aadd(aGrp, aAllGrp[ni][1][1])
Next

Return        
