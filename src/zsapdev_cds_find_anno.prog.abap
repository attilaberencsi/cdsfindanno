*&---------------------------------------------------------------------*
*& Report zsapdev_cds_find_anno
*&---------------------------------------------------------------------*
*& Find Annotations in CDS Views
*&---------------------------------------------------------------------*
*& Purpose
*& Help developers to find samples, especially when this error message
*& appears in ADT: Text search services are not supported.
*&---------------------------------------------------------------------*
*& Features
*& - Search for CDS header/field/parameter annotations
*& - Type Ahead Value Help for Annotations (Existing in the System)
*& - Opens ADT, when running embedded,otherwise shows Data Def.in Popup
*&---------------------------------------------------------------------*
REPORT zsapdev_cds_find_anno.

TABLES: ddfieldanno.

CONSTANTS:
  co_view_of_magic type dbtabl VALUE 'ZI_SapDevCdsAnnoField'.

DATA:
  g_alv TYPE REF TO if_salv_gui_table_ida.

INCLUDE zsapdev_cds_find_anno_cl01.

SELECT-OPTIONS:
  s_fanno FOR ddfieldanno-name NO INTERVALS MATCHCODE OBJECT zsapdev_cds_anno OBLIGATORY.


START-OF-SELECTION.

  "Initialise ALV
  g_alv = cl_salv_gui_table_ida=>create_for_cds_view( iv_cds_view_name = co_view_of_magic ).

  "Collect Select-options
  DATA(g_selopt) = NEW cl_salv_range_tab_collector( ).
  g_selopt->add_ranges_for_name( EXPORTING iv_name = 'NAME' it_ranges = s_fanno[] ).
  g_selopt->get_collected_ranges( IMPORTING et_named_ranges = DATA(g_all_selopt) ).
  g_alv->set_select_options( EXPORTING it_ranges = g_all_selopt ).

  "ALV Configuration
  DATA(g_alv_handler) = NEW lcl_alv( i_alv = g_alv ).
  g_alv_handler->configure_alv( ).

  "Show ALV
  g_alv->fullscreen( )->display( ).
