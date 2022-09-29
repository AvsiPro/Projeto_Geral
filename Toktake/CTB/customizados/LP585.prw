#INCLUDE "RWMAKE.CH"

User Function LP585()

Local aArea	  := GetArea()    
Local _nvalor := 0

If "01/02" $ cEmpAnt 
	
	if ct5->ct5_lanpad=="585" .and. ct5->ct5_sequen=="001" .And. SEH->EH_APLEMP == "EMP" .AND. SEI->EI_MOTBX <> "APR"
	     
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "EMP" .AND. SEI->EI_MOTBX <> "APR"
			If SEI->EI_TIPODOC == "VL"
		    	_nvalor:=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo    
	Elseif ct5->ct5_lanpad=="585" .and. ct5->ct5_sequen=="002" .And. SEH->EH_APLEMP == "EMP" .AND. SEI->EI_MOTBX <> "APR"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "EMP" .AND. SEI->EI_MOTBX <> "APR"
			If SEI->EI_TIPODOC == "JR"
		    	_nvalor:=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo    
	
	Elseif ct5->ct5_lanpad=="585" .and. ct5->ct5_sequen=="003" .And. SEH->EH_APLEMP == "EMP" .AND. SEI->EI_MOTBX <> "APR"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "EMP" .AND. SEI->EI_MOTBX <> "APR"
			If SEI->EI_TIPODOC == "BL"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo    
	Elseif ct5->ct5_lanpad=="585" .and. ct5->ct5_sequen=="004" .And. SEH->EH_APLEMP == "APL" .AND. SEI->EI_MOTBX <> "APR"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "APL" .AND. SEI->EI_MOTBX <> "APR"
			If SEI->EI_TIPODOC == "BP"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo 
	Elseif ct5->ct5_lanpad=="585" .and. ct5->ct5_sequen=="005" .And. SEH->EH_APLEMP == "APL" .AND. SEI->EI_MOTBX <> "APR"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "APL" .AND. SEI->EI_MOTBX <> "APR"
			If SEI->EI_TIPODOC == "JR"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo 
	Elseif ct5->ct5_lanpad=="585" .and. ct5->ct5_sequen=="006" .And. SEH->EH_APLEMP == "APL" .AND. SEI->EI_MOTBX <> "APR"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "APL" .AND. SEI->EI_MOTBX <> "APR"
			If SEI->EI_TIPODOC == "VL"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo     
	Elseif ct5->ct5_lanpad=="585" .and. ct5->ct5_sequen=="007" .And. SEH->EH_APLEMP == "APL" .AND. SEI->EI_MOTBX <> "APR"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "APL" .AND. SEI->EI_MOTBX <> "APR"
			If SEI->EI_TIPODOC == "I1"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo    
	Elseif ct5->ct5_lanpad=="585" .and. ct5->ct5_sequen=="008" .And. SEH->EH_APLEMP == "APL" .AND. SEI->EI_MOTBX <> "APR"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "APL"
			If SEI->EI_TIPODOC == "I2"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo   			  
	endif                     
EndIf

RestArea(aArea)
  
Return(_nvalor)     

User Function LP586()

Local aArea	  := GetArea()    
Local _nvalor := 0

If "01/02" $ cEmpAnt
	
	if ct5->ct5_lanpad=="586" .and. ct5->ct5_sequen=="001"
	     
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "EMP"
			If SEI->EI_TIPODOC == "VL"
		    	_nvalor:=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo    
	Elseif ct5->ct5_lanpad=="586" .and. ct5->ct5_sequen=="002"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "EMP"
			If SEI->EI_TIPODOC == "JR"
		    	_nvalor:=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo    
	
	Elseif ct5->ct5_lanpad=="586" .and. ct5->ct5_sequen=="003"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "EMP"
			If SEI->EI_TIPODOC == "BL"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo    
	Elseif ct5->ct5_lanpad=="586" .and. ct5->ct5_sequen=="004"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "APL"
			If SEI->EI_TIPODOC == "BP"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo 
	Elseif ct5->ct5_lanpad=="586" .and. ct5->ct5_sequen=="005"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "APL"
			If SEI->EI_TIPODOC == "JR"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo 
	Elseif ct5->ct5_lanpad=="586" .and. ct5->ct5_sequen=="006"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "APL"
			If SEI->EI_TIPODOC == "VL"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo     
	Elseif ct5->ct5_lanpad=="586" .and. ct5->ct5_sequen=="007"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "APL"
			If SEI->EI_TIPODOC == "I1"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo    
	Elseif ct5->ct5_lanpad=="586" .and. ct5->ct5_sequen=="008"
		DbSelectArea("SEI")
		sei->(dbsetorder(1))     //EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ   
		//EI_FILIAL+EI_APLEMP+DTOS(EI_DTDIGIT)+EI_NUMERO+EI_REVISAO+EI_MOTBX+EI_TIPODOC
		sei->(dbseek(xfilial("SEI")+seh->eh_aplemp+seh->eh_numero+seh->eh_revisao))
		
		while !sei->(eof()) .and. seh->eh_numero == sei->ei_numero .And. SEI->EI_APLEMP == "APL"
			If SEI->EI_TIPODOC == "I2"
		    	_nvalor :=sei->ei_valor
		 	EndIf
		    sei->(dbskip())
		enddo   			  
	endif     
EndIf                

RestArea(aArea)
  
Return(_nvalor)