class /AKN/CL_ICON_APACK_MANIFEST definition
  public
  final
  create public .

public section.

  interfaces ZIF_APACK_MANIFEST .

  methods CONSTRUCTOR .
PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /AKN/CL_ICON_APACK_MANIFEST IMPLEMENTATION.


  METHOD constructor.

    zif_apack_manifest~descriptor-group_id     = 'https://github.com/appknight'.
    zif_apack_manifest~descriptor-artifact_id  = 'icon'.
    zif_apack_manifest~descriptor-version      = '1.0'.
    zif_apack_manifest~descriptor-git_url      = 'https://github.com/appknight/icon.git'.
    zif_apack_manifest~descriptor-dependencies = VALUE #( ).

  ENDMETHOD.
ENDCLASS.
