#include "protheus.ch"
#include "fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC30  ºAutor  ³Jackson E. de Deus  º Data ³  10/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa o programa externo crccalc.exe					  º±±
±±º          ³ Retorna o resultado do Log 5								  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³10/06/14³01.00 |Criacao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TTFINC30(cLog1,cLog2,cLog3,cLog4)

Local aArea	:=	GetArea()
Local cDir := "C:\temp\"
Local cProgram := "crccalc.exe"
Local cArqOrig := "crc_logs.txt"
Local cArqDest := "crc_result.txt"
Local cLinha := ""
Local nHdl
Local nHandle
Local cRet := ""

Default cLog1 := ""
Default cLog2 := ""
Default cLog3 := ""
Default cLog4 := ""

If Empty(cLog1) .Or. Empty(cLog2) .Or. Empty(cLog3) .Or. Empty(cLog4)
	MsgInfo("Todos os logs devem ser informados para o calculo!")
	Return
EndIf

ProcRegua(5)

IncProc("Verificando diretorio temporario..")
If !ExistDir(cDir)
	MakeDir(cDir)
EndIf

IncProc("Verificando programa de calculo..")         
If !File( cDir+cProgram )
	CpyS2T( "\system\crccalc.exe", cDir, .F. )
EndIf

IncProc("Preparando logs para leitura..")  
nHdl := FCreate( cDir+cArqOrig )
If nHdl = -1
	MsgAlert("Houve erro ao criar o arquivo de origem dos logs")
	Return cRet
Else
	FWrite(nHdl,cLog1 +CRLF)
	FWrite(nHdl,cLog2 +CRLF)
	FWrite(nHdl,cLog3 +CRLF)
	FWrite(nHdl,cLog4)
	FClose(nHdl)
EndIf	

IncProc("Efetuando calculo..")  
If ExistDir(cDir)         
	If File( cDir+cArqOrig )		
 		If File( cDir+cProgram )			
			//ShellExecute( "Open", cDir+cProgram, "" , cDir, 0 )

			WaitRun( cDir+cProgram, 0 )

			If File( cDir+cArqDest )
				sleep(5000)	// -> foi inserido aqui pois sem esse sleep o sistema nao consegue abrir o arquivo para leitura
				nHandle := FT_FUSE( cDir+cArqDest )
				If nHandle == -1
					MsgAlert("Houve erro ao abrir o arquivo de resposta do Log 5")
				Else                               
					IncProc("Verificando resposta..") 
					FT_FGOTOP()
					While ! FT_FEOF()
						cLinha := FT_FREADLN()
						FT_FSKIP()
					End 
					FT_FUSE()
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

cRet := UPPER(cLinha) 
                           
//FERASE(cDir+cArqOrig)	// exclui o arquivo de logs
//FERASE(cDir+cArqDest)	// exclui o arquivo de respostas

RestArea(aArea)
		
Return cRet