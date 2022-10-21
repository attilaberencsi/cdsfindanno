*&---------------------------------------------------------------------*
*& Include zsapdev_cds_find_anno_cl01
*& Find Annotations in CDS Views - All ALV related functions
*&---------------------------------------------------------------------*

"! Handles and implements all ALV related functions in one
CLASS lcl_alv DEFINITION.
  PUBLIC SECTION.

    CONSTANTS:
      "! Action buttons at top of the ALV
      BEGIN OF co_action,
        show_cds TYPE ui_func VALUE 'SHOW_CDS',
      END OF co_action.

    DATA:
      alv      TYPE REF TO if_salv_gui_table_ida READ-ONLY.

    "! Setup
    "! @parameter i_alv | CDS SALV Reference
    METHODS constructor
      IMPORTING
        i_alv TYPE REF TO if_salv_gui_table_ida.

    "! Initialise ALV Settings
    METHODS configure_alv.

    "! Handle Action Button Events
    METHODS handle_action FOR EVENT function_selected OF if_salv_gui_toolbar_ida
      IMPORTING ev_fcode.

  PROTECTED SECTION.

    "! Show CDS View in ADT / GUI: Popup
    METHODS handle_show_cds.

  PRIVATE SECTION.
    "Dark stuff
    CONSTANTS co_cl_adt_gui_event_dispatcher TYPE string VALUE 'CL_ADT_GUI_EVENT_DISPATCHER' ##NO_TEXT.

    "! Opens in ADT Editor?
    "! @parameter wb_request | the wb request
    "! @parameter processed | C1 Flag: abap_false; abap_true; E - internal error
    METHODS open_in_adt_editor
      CHANGING
        wb_request       TYPE REF TO cl_wb_request
      RETURNING
        VALUE(processed) TYPE sychar01 .

ENDCLASS.

CLASS lcl_alv IMPLEMENTATION.

  METHOD constructor.
    me->alv = i_alv.
  ENDMETHOD.

  METHOD configure_alv.
    "Allow to select 1 CDS at a time to navigate/show
    alv->selection( )->set_selection_mode( iv_mode = if_salv_gui_selection_ida=>cs_selection_mode-single ).

    "Custom functions
    "- Show CDS
    alv->toolbar( )->add_separator( ).

    alv->toolbar( )->add_button(
      EXPORTING
        iv_fcode     = co_action-show_cds
        iv_icon      = icon_display
        iv_text      = TEXT-001
        iv_quickinfo = CONV iconquick( TEXT-001 )
    ).

    "Register myself as handler instance of ALV Buttons
    SET HANDLER me->handle_action FOR alv->toolbar( ).

  ENDMETHOD.

  METHOD handle_action.
    CASE ev_fcode.
      WHEN co_action-show_cds.
        handle_show_cds( ).
    ENDCASE.

  ENDMETHOD.

  METHOD handle_show_cds.
    DATA:
      field_anno_selected_row TYPE ZI_SapDevCdsAnnoField.

    "Get CDS Object Name selected
    TRY.
        alv->selection( )->get_selected_row( IMPORTING es_row = field_anno_selected_row ).
      CATCH cx_salv_ida_row_key_invalid.
      CATCH cx_salv_ida_contract_violation.
      CATCH cx_salv_ida_sel_row_deleted.
        RETURN.
    ENDTRY.

    IF field_anno_selected_row IS INITIAL.
      MESSAGE 'Select a line ;-)' TYPE 'I'.
      RETURN.
    ENDIF.

    "Try to open in ADT
    SELECT SINGLE ddlname INTO @DATA(ddl_source_name)
      FROM ddldependency
        WHERE objectname = @field_anno_selected_row-Strucobjn
          AND state = 'A'.

    DATA(wb_request) = NEW cl_wb_request( p_object_type = swbm_c_type_ddic_ddl_source
                                          p_object_name = CONV seu_objkey( ddl_source_name )
                                          p_operation   = swbm_c_op_display                                   ).

    "Show source directly when GUI was not opened through ADT
    IF open_in_adt_editor( CHANGING wb_request = wb_request ) <> abap_true.

      TRY.
          cl_dd_ddl_handler_factory=>create( )->read(
            EXPORTING
              name = CONV ddlname( to_upper( ddl_source_name ) )
            IMPORTING
              ddddlsrcv_wa = DATA(source_code_info) ).
        CATCH cx_dd_ddl_read INTO DATA(exc).
          cl_demo_output=>display( exc->get_text( ) ).
      ENDTRY.

      IF source_code_info IS INITIAL.
        cl_demo_output=>display( |Fatal Error Sorry :-(| ).
        RETURN.
      ENDIF.

      cl_demo_output=>display( replace( val = source_code_info-source sub = |\n| with = '' occ = 0 ) ).
    ENDIF.


  ENDMETHOD.

  METHOD open_in_adt_editor.

    DATA:
      adt_available TYPE c LENGTH 1,
      object_type   TYPE seu_objtyp,
      object_name   TYPE seu_objkey,
      tabl_state    TYPE REF TO cl_wb_tabl_state.

    object_type = wb_request->object_type.
    object_name = wb_request->object_name.

    "don't navigate to ADT UI. TODO remove when table index editor is available
    IF object_type = swbm_c_type_ddic_db_table AND wb_request->object_state IS INSTANCE OF cl_wb_tabl_state.
      tabl_state ?= wb_request->object_state.
      IF tabl_state->view = cl_wb_tabl_state=>view_indx.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        "change client navigation state
        CALL METHOD (co_cl_adt_gui_event_dispatcher)=>is_adt_tool_available
          EXPORTING
            operation          = wb_request->operation
            wb_object_type     = object_type
            wb_object_name     = object_name
          IMPORTING
            adt_tool_available = adt_available
          CHANGING
            wb_request         = wb_request.
        IF adt_available IS NOT INITIAL.
          TRY.
              CALL METHOD (co_cl_adt_gui_event_dispatcher)=>open_adt_editor
                EXPORTING
                  wb_request  = wb_request
                  object_type = object_type
                  object_name = object_name
                  operation   = wb_request->operation.

              processed = abap_true.
            CATCH cx_adt_gui_event_error.
              processed = 'E'.
          ENDTRY.
        ENDIF.
      CATCH cx_sy_dyn_call_error ##no_handler.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
