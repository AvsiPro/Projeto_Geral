
//*!short: COMBOBOX */

#xcommand @ <nRow>, <nCol> COMBOBOX [ <oCbx> VAR ] <cVar> ;
				 [ <items: ITEMS, PROMPTS> <aItems> ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
				 [ <help:HELPID, HELP ID> <nHelpId> ] ;
				 [ ON CHANGE <uChange> ] ;
				 [ VALID <uValid> ] ;
				 [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
				 [ <pixel: PIXEL> ] ;
				 [ FONT <oFont> ] ;
				 [ <update: UPDATE> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ WHEN <uWhen> ] ;
				 [ <design: DESIGN> ] ;
				 [ BITMAPS <acBitmaps> ] ;
				 [ ON DRAWITEM <uBmpSelect> ] ;
		 => ;
			 [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, bSETGET(<cVar>),;
				 <aItems>, <nWidth>, <nHeight>, <oWnd>, <nHelpId>,;
				 [{|Self|<uChange>}], <{uValid}>, <nClrText>, <nClrBack>,;
				 <.pixel.>, <oFont>, <cMsg>, <.update.>, <{uWhen}>,;
				 <.design.>, <acBitmaps>, [{|nItem|<uBmpSelect>}] )

#xcommand REDEFINE COMBOBOX [ <oCbx> VAR ] <cVar> ;
				 [ <items: ITEMS, PROMPTS> <aItems> ] ;
				 [ ID <nId> ] ;
				 [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
				 [ <help:HELPID, HELP ID> <nHelpId> ] ;
				 [ ON CHANGE <uChange> ] ;
				 [ VALID   <uValid> ] ;
				 [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
				 [ <update: UPDATE> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ WHEN <uWhen> ] ;
				 [ BITMAPS <acBitmaps> ] ;
				 [ ON DRAWITEM <uBmpSelect> ] ;
				 [ STYLE <nStyle> ] ;
				 [ PICTURE <cPicture> ];
				 [ ON EDIT CHANGE <uEChange> ] ;
		 => ;
			 [ <oCbx> := ] TComboBox():ReDefine( <nId>, bSETGET(<cVar>),;
				 <aItems>, <oWnd>, <nHelpId>, <{uValid}>, [{|Self|<uChange>}],;
				 <nClrText>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>,;
				 <acBitmaps>, [{|nItem|<uBmpSelect>}], <nStyle>, <cPicture>,;
				 [<{uEChange}>] )

