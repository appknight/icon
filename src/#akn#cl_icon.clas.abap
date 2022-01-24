class /AKN/CL_ICON definition
  public
  final
  create public .

public section.

  class-methods CREATE
    importing
      !I_ICON type ICON_NAME
      !I_TEXT type CLIKE optional
      !I_INFO type CLIKE optional
    returning
      value(E_ICON) type STRING .
protected section.
private section.
ENDCLASS.



CLASS /AKN/CL_ICON IMPLEMENTATION.


  METHOD create.

    IF i_icon IS INITIAL.
      e_icon = space.
    ELSE.
      CALL FUNCTION 'ICON_CREATE'
        EXPORTING
          name       = i_icon
          text       = i_text
          info       = i_info
          add_stdinf = ''
        IMPORTING
          result     = e_icon
        EXCEPTIONS
          OTHERS     = 3.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
