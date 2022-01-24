FUNCTION /akn/icon_f4if_shlp_exit_icon.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     VALUE(SHLP) TYPE  SHLP_DESCR
*"     VALUE(CALLCONTROL) LIKE  DDSHF4CTRL STRUCTURE  DDSHF4CTRL
*"----------------------------------------------------------------------
*== Info:
* Dieser Baustein kann in Suchhilfen als Suchhilfe-Exit verwendet werden
*== Zweck:
* Anzeige des Icons zu einem Icon-Namen, der in der Tabelle vorhanden ist
*== Voraussetzung:
* Spalte mit dem Namen eines Icons

* Einstellungen in der Suchhilfe:
" Parameter               |  IMP  |  EXP | LPos | SPos | SDis | Data element   | M | Default value
" FIELD                   |   X   |   X  |   1  |  1   |      | XY_FIELD       |   |
" TEXT                    |       |      |   2  |  2   |      | DESCRIPTION    |   |
" ICON                    |       |      |   3  |  3   |      | ICON           |   |
" COLUMN_WITH_ICON_NAME	  |	      |      |      |      |      | CHAR30         | X | 'ICON'     <= Daten manuell eintragen
" COLUMN_FOR_ICON_DISPLAY	|    	  |      |      |      |      | CHAR30         | X | 'ICON'     <= Daten manuell eintragen


  "MAKRO GET_PARAM
  DEFINE get_param.
    CALL FUNCTION 'F4UT_PARAMETER_VALUE_GET'
      EXPORTING
        parameter         = &1
        fieldname         = '*'
      IMPORTING
        value             = lv_parameter_value
      TABLES
        shlp_tab          = shlp_tab
        record_tab        = record_tab
      CHANGING
        shlp              = shlp
        callcontrol       = callcontrol
      EXCEPTIONS
        parameter_unknown = 1.
    IF sy-subrc = 0.
      &2 = lv_parameter_value.
    ENDIF.
  END-OF-DEFINITION.


  "Tabelle für den Iconnamen, der aus der RESULTTAB ermittelt wird
  DATA lt_col_iconname TYPE STANDARD TABLE OF icon_name.
  "Tabelle für den Inhalt der Info zum Icon
  DATA lt_col_iconinfo TYPE STANDARD TABLE OF icon_text.
  "Tabelle für das Aufbereitete Icon, das an die RESULTTAB übergeben wird
  DATA lt_col_icontext TYPE STANDARD TABLE OF icon_text.
  DATA lv_icontext TYPE icon_text.

  "Generischer Parameter
  DATA lv_parameter_value       TYPE  ddshvalue.
  "Name der Spalte, die den Iconnamen enthält
  DATA lv_column_with_icon_name TYPE  shlpfield.
  "Name der Spalte, die den Icontext enthält
  DATA lv_column_with_icon_info TYPE  shlpfield.
  "Name der Spalte, in der das aufbereitete Icon dargestellt werden soll
  DATA lv_column_for_display    TYPE  shlpfield.


* EXIT immediately, if you do not want to handle this step
  IF callcontrol-step <> 'SELONE' AND
     callcontrol-step <> 'SELECT' AND
     callcontrol-step <> 'SELONE' AND
     callcontrol-step <> 'PRESEL' AND
     callcontrol-step <> 'SELECT' AND
     callcontrol-step <> 'DISP'.
    EXIT.
  ENDIF.

*"----------------------------------------------------------------------
* STEP DISP     (Display values)
*"----------------------------------------------------------------------
  IF callcontrol-step = 'DISP'.

    get_param 'COLUMN_WITH_ICON_NAME'    lv_column_with_icon_name.
    get_param 'COLUMN_WITH_ICON_INFO'    lv_column_with_icon_info.
    get_param 'COLUMN_FOR_ICON_DISPLAY'  lv_column_for_display.


    "Ermitteln aller ICON_NAMEN der einzelnen Einträge
    CALL FUNCTION 'F4UT_PARAMETER_VALUE_GET'
      EXPORTING
        parameter         = lv_column_with_icon_name
        fieldname         = '*'
      TABLES
        shlp_tab          = shlp_tab
        record_tab        = record_tab
        results_tab       = lt_col_iconname
      CHANGING
        shlp              = shlp
        callcontrol       = callcontrol
      EXCEPTIONS
        parameter_unknown = 1
        OTHERS            = 2.
    IF sy-subrc = 0.
      "Wenn alles geklappt hat, dann sind in Tabelle LT_COL_ICONNAME die Namen
      "der Icons aus dem Parameter COLUMN_WITH_ICON_NAME

      "Nun noch die die Texte für die Quickinfo ermitteln
      CALL FUNCTION 'F4UT_PARAMETER_VALUE_GET'
        EXPORTING
          parameter         = lv_column_with_icon_info
          fieldname         = '*'
        TABLES
          shlp_tab          = shlp_tab
          record_tab        = record_tab
          results_tab       = lt_col_iconinfo
        CHANGING
          shlp              = shlp
          callcontrol       = callcontrol
        EXCEPTIONS
          parameter_unknown = 1
          OTHERS            = 2.
      IF sy-subrc > 0.
        "Macht nichts: Es ist kein Feld definiert/ vorhanden, das zum Icon angezeigt werden soll
        "Die Tabelle LT_COL_ICONINFO ist dann halt leer
      ENDIF.


      LOOP AT lt_col_iconname INTO DATA(lv_iconname).
        "Info zum Icon lesen:
        READ TABLE lt_col_iconinfo INTO DATA(lv_iconinfo) INDEX sy-tabix.
        "Aufbereitung des Icons zur Darstellung
        lv_icontext = /akn/cl_icon=>create(
          i_icon =  lv_iconname
          i_info = lv_iconinfo ).
        APPEND lv_icontext TO lt_col_icontext.
      ENDLOOP.
    ENDIF.

    "Alle aufbereiteten Icons an RESULTTAB übergeben
    CALL FUNCTION 'F4UT_PARAMETER_RESULTS_PUT'
      EXPORTING
        parameter         = lv_column_for_display
      TABLES
        shlp_tab          = shlp_tab
        record_tab        = record_tab
        source_tab        = lt_col_icontext
      CHANGING
        shlp              = shlp
        callcontrol       = callcontrol
      EXCEPTIONS
        parameter_unknown = 1
        OTHERS            = 2.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
    EXIT.
  ENDIF.

ENDFUNCTION.
