//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function zCSSGrid
Altera o tamanho do texto usado nas grids antigas (MsNewGetDados e MsSelect)
@type  Function
@author Atilio
@since 18/08/2021
@version version
@param nTamFonte, Numeric, Tamanho da fonte em pixels na grid
@example
/*/
User Function zCSSGrid(nTamFonte)
    Local cCSSGrid := ""
    Default nTamFonte := 14
    
	cCSSGrid += "QHeaderView::section {" + CRLF
	cCSSGrid += "	background-color: #6E7D81;" + CRLF
	cCSSGrid += "	border: 1px solid #646769;" + CRLF
	cCSSGrid += "	border-bottom-color: #4B4B4B;" + CRLF
	cCSSGrid += "	border-right-color: #3F4548;" + CRLF
	cCSSGrid += "	border-left-color: #90989D;" + CRLF
	cCSSGrid += "	color: #FFFFFF;" + CRLF
	cCSSGrid += "	font-family: arial;" + CRLF
	cCSSGrid += "	height: 27px;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QHeaderView::section:pressed {" + CRLF
	cCSSGrid += "	background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #485154, stop: 1 #6D7C80);" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QTableView {" + CRLF
	cCSSGrid += "	selection-background-color: #1C9DBD;" + CRLF
	cCSSGrid += "	selection-color: #FFFFFF;" + CRLF
	cCSSGrid += "	alternate-background-color: #B2CBE7;" + CRLF
	cCSSGrid += "	background: #FFFFFF;" + CRLF
	cCSSGrid += "	color: #000000;" + CRLF
	cCSSGrid += "	font-size: " + cValToChar(nTamFonte) + "px;" + CRLF
	//cCSSGrid += "	border: 1px solid #C5C9CA;" + CRLF
	//cCSSGrid += "	border-top: 0px;" + CRLF
	//cCSSGrid += "	border-left: 0px;" + CRLF
	//cCSSGrid += "	border-right: 0px;" + CRLF
	cCSSGrid += "	border: none;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar:horizontal {" + CRLF
	cCSSGrid += "	background-color: #F2F2F2;" + CRLF
	cCSSGrid += "	border: 1px solid #C5C9CA;" + CRLF
	cCSSGrid += "	margin: 0 15px 0px 16px;" + CRLF
	cCSSGrid += "	max-height: 16px;" + CRLF
	cCSSGrid += "	min-height: 16px;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-page:horizontal," + CRLF
	cCSSGrid += "QScrollBar::sub-page:horizontal {" + CRLF
	cCSSGrid += "	background: #F2F2F2;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::handle:horizontal {" + CRLF
	cCSSGrid += "	background-color: #B2B2B2;" + CRLF
	cCSSGrid += "	border: 3px solid #F2F2F2;" + CRLF
	cCSSGrid += "	border-radius: 7px;" + CRLF
	cCSSGrid += "	min-width: 20px;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:horizontal {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_hrz_btn_rgt_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "	border: 1px solid black;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:horizontal:pressed {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_hrz_btn_rgt_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:horizontal {" + CRLF
	cCSSGrid += "	border-top-width: 2px;" + CRLF
	cCSSGrid += "	border-right-width: 2px;" + CRLF
	cCSSGrid += "	border-bottom-width: 2px;" + CRLF
	cCSSGrid += "	border-left-width: 2px;" + CRLF
	cCSSGrid += "	width: 13px;" + CRLF
	cCSSGrid += "	subcontrol-position: right;" + CRLF
	cCSSGrid += "	subcontrol-origin: margin;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:horizontal {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_hrz_btn_lft_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:horizontal:pressed {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_hrz_btn_lft_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:horizontal {" + CRLF
	cCSSGrid += "	border-top-width: 2px;" + CRLF
	cCSSGrid += "	border-right-width: 2px;" + CRLF
	cCSSGrid += "	border-bottom-width: 2px;" + CRLF
	cCSSGrid += "	border-left-width: 2px;" + CRLF
	cCSSGrid += "	width: 13px;" + CRLF
	cCSSGrid += "	subcontrol-position: left;" + CRLF
	cCSSGrid += "	subcontrol-origin: margin;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar:vertical {" + CRLF
	cCSSGrid += "	background-color: #F2F2F2;" + CRLF
	cCSSGrid += "	border-top-width: 0px;" + CRLF
	cCSSGrid += "	border-right-width: 0px;" + CRLF
	cCSSGrid += "	border-bottom-width: 0px;" + CRLF
	cCSSGrid += "	border-left-width: 0px;" + CRLF
	cCSSGrid += "	margin: 15px 0px 16px 0px;" + CRLF
	cCSSGrid += "	max-width: 16px;" + CRLF
	cCSSGrid += "	min-width: 16px;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-page:vertical," + CRLF
	cCSSGrid += "QScrollBar::sub-page:vertical {" + CRLF
	cCSSGrid += "	background: #F2F2F2;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::handle:vertical {" + CRLF
	cCSSGrid += "	background-color: #B2B2B2;" + CRLF
	cCSSGrid += "	border: 3px solid #F2F2F2;" + CRLF
	cCSSGrid += "	border-radius: 7px;" + CRLF
	cCSSGrid += "	min-height: 20px;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:vertical {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_vrt_btn_btm_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:vertical:pressed {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_vrt_btn_btm_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::add-line:vertical {" + CRLF
	cCSSGrid += "	border-top-width: 2px;" + CRLF
	cCSSGrid += "	border-right-width: 2px;" + CRLF
	cCSSGrid += "	border-bottom-width: 2px;" + CRLF
	cCSSGrid += "	border-left-width: 2px;" + CRLF
	cCSSGrid += "	height: 13px;" + CRLF
	cCSSGrid += "	subcontrol-position: bottom;" + CRLF
	cCSSGrid += "	subcontrol-origin: margin;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:vertical {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_vrt_btn_top_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:vertical:pressed {" + CRLF
	cCSSGrid += "	border-image: url(rpo:fwskin_scroll_vrt_btn_top_nml.png) 2 2 2 2 stretch;" + CRLF
	cCSSGrid += "}" + CRLF
	cCSSGrid += "" + CRLF
	cCSSGrid += "QScrollBar::sub-line:vertical {" + CRLF
	cCSSGrid += "	border-top-width: 2px;" + CRLF
	cCSSGrid += "	border-right-width: 2px;" + CRLF
	cCSSGrid += "	border-bottom-width: 2px;" + CRLF
	cCSSGrid += "	border-left-width: 2px;" + CRLF
	cCSSGrid += "	height: 13px;" + CRLF
	cCSSGrid += "	subcontrol-position: top;" + CRLF
	cCSSGrid += "	subcontrol-origin: margin;" + CRLF
	cCSSGrid += "}" + CRLF
Return cCSSGrid