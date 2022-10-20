*&---------------------------------------------------------------------*
*& Report zsapdev_cds_find_anno
*&---------------------------------------------------------------------*
*& Find Annotations in CDS Views

*&---------------------------------------------------------------------*
REPORT zsapdev_cds_find_anno.

TABLES: ddfieldanno.

DATA:
  g_alv TYPE REF TO if_salv_gui_table_ida.

PARAMETERS:
  p_field RADIOBUTTON GROUP r1 DEFAULT 'X'.

SELECT-OPTIONS:
  s_fanno FOR ddfieldanno-name NO INTERVALS MATCHCODE OBJECT zsapdev_cds_fieldanno OBLIGATORY.

SELECTION-SCREEN SKIP.

PARAMETERS:
  p_hdr   RADIOBUTTON GROUP r1.


START-OF-SELECTION.

  CASE abap_true.

    WHEN p_field.
      g_alv = cl_salv_gui_table_ida=>create_for_cds_view( iv_cds_view_name = 'ZI_SapDevCdsAnnoField' ).

      "Collect Select-options
      DATA(g_selopt) = NEW cl_salv_range_tab_collector( ).
      g_selopt->add_ranges_for_name( EXPORTING iv_name = 'NAME' it_ranges = s_fanno[] ).
      g_selopt->get_collected_ranges( IMPORTING et_named_ranges = DATA(g_all_selopt) ).
      g_alv->set_select_options( EXPORTING it_ranges = g_all_selopt ).

      g_alv->display_options( )->set_title( iv_title = 'CDS Field Annotations' ).
      g_alv->fullscreen( )->display( ).

    WHEN p_hdr.

  ENDCASE.
