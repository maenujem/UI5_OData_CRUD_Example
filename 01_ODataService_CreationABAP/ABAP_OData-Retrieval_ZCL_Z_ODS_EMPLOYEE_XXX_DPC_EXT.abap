class zcl_z_ods_employee_###_dpc_ext definition
  public
  inheriting from zcl_z_ods_employee_###_dpc
  create public .

public section.

  methods /iwbep/if_mgw_appl_srv_runtime~execute_action
    redefinition .
protected section.

  methods ztt_employee_###_create_entity
    redefinition .
  methods ztt_employee_###_delete_entity
    redefinition .
  methods ztt_employee_###_get_entity
    redefinition .
  methods ztt_employee_###_get_entityset
    redefinition .
  methods ztt_employee_###_update_entity
    redefinition .
private section.
endclass.



class zcl_z_ods_employee_###_dpc_ext implementation.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_z_ods_EMPLOYEE_###_DPC_EXT->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ACTION_NAME                 TYPE        STRING(optional)
* | [--->] IT_PARAMETER                   TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR(optional)
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_FUNC_IMPORT(optional)
* | [<---] ER_DATA                        TYPE REF TO DATA
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method /iwbep/if_mgw_appl_srv_runtime~execute_action.
try.
call method super->/iwbep/if_mgw_appl_srv_runtime~execute_action
  exporting
    iv_action_name          = iv_action_name
    it_parameter            = it_parameter
    io_tech_request_context = io_tech_request_context
  importing
    er_data                 = er_data
    .
 catch /iwbep/cx_mgw_busi_exception .
 catch /iwbep/cx_mgw_tech_exception .
endtry.

    data: ls_parameter    type /iwbep/s_mgw_name_value_pair,
          lv_dayspermonth type zde_int10_decimal2, "p DECIMALS 2,
          lv_salary       type zde_int10_decimal2,
          lt_employee     type table of ztt_employee_msc,
          ls_employee     like line of lt_employee,
          ls_entity       type zcl_z_ods_employee_###_mpc=>ts_ztt_employee_msc,
          lt_entityset    type zcl_z_ods_employee_###_mpc=>tt_ztt_employee_msc.

* check for required action
    if iv_action_name = 'EmployeesSalaryPerDay'.
      if it_parameter is not initial.

* read function import parameter
        read table it_parameter into ls_parameter with key name = 'DaysPerMonth'.
        if sy-subrc = 0.
          lv_dayspermonth = ls_parameter-value.
        endif.
        if lv_dayspermonth is not initial.

* read data
          select * from ztt_employee_msc into table lt_employee.
          loop at lt_employee into ls_employee.
            move-corresponding ls_employee to ls_entity.

* calculate salary per day using function module
            lv_salary = ls_entity-salary.
            call function 'ZFM_2018_###_00'
              exporting
                iv_number01 = lv_salary
                iv_number02 = lv_dayspermonth
              importing
                ev_result   = lv_salary " overwrite salary per month
*     EXCEPTIONS
*               EX_DIVISION_BY_ZERO       = 1
*               OTHERS      = 2
              .
            if sy-subrc <> 0.
* Implement suitable error handling here
            endif.
            ls_entity-salary = lv_salary.

            append ls_entity to lt_entityset.
          endloop.

* export data
          copy_data_to_ref( exporting is_data = lt_entityset changing cr_data = er_data ).

        endif.
      endif.
    endif.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_z_ods_EMPLOYEE_###_DPC_EXT->ZTT_EMPLOYEE_###_CREATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_C(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        ZCL_z_ods_EMPLOYEE_###_MPC=>TS_ZTT_EMPLOYEE_MSC
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ztt_employee_###_create_entity.
**TRY.
*CALL METHOD SUPER->ZTT_EMPLOYEE_###_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

* request-example:
* 1. GET /sap/opu/odata/sap/ZOD_EMPLOYEE_###_SRV/ZTT_EMPLOYEE_MSCSet(IdEmployee='1',Carrier='AA')
* 2. Use response as request, modify values
* 3. POST /sap/opu/odata/sap/ZOD_EMPLOYEE_###_SRV/ZTT_EMPLOYEE_MSCSet
    data: ls_request_input_data type zcl_z_ods_employee_###_mpc=>ts_ztt_employee_msc, "zcl_zuserinfo_mpc=>ts_user,
          ls_employee           type ztt_employee_msc.

* read request data
    io_data_provider->read_entry_data( importing es_data = ls_request_input_data ).
    move-corresponding ls_request_input_data to ls_employee.

* insert into table
    insert ztt_employee_msc from ls_employee.
    if sy-subrc = 0.
      er_entity = ls_request_input_data.
    endif.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_z_ods_EMPLOYEE_###_DPC_EXT->ZTT_EMPLOYEE_###_DELETE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_D(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ztt_employee_###_delete_entity.
**TRY.
*CALL METHOD SUPER->ZTT_EMPLOYEE_###_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

      data: ls_key_tab    type /iwbep/s_mgw_name_value_pair,
        lv_employeeid type ztt_employee_msc-id_employee,
        lv_carrier    type ztt_employee_msc-carrier.

* read key values
  read table it_key_tab into ls_key_tab with key name = 'IdEmployee'.
  lv_employeeid = ls_key_tab-value.
  read table it_key_tab into ls_key_tab with key name = 'Carrier'.
  lv_carrier = ls_key_tab-value.

  if lv_employeeid is not initial.
*  delete record
    delete from ztt_employee_msc where id_employee = lv_employeeid and carrier = lv_carrier.
  endif.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_z_ods_EMPLOYEE_###_DPC_EXT->ZTT_EMPLOYEE_###_GET_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_REQUEST_OBJECT              TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [<---] ER_ENTITY                      TYPE        ZCL_z_ods_EMPLOYEE_###_MPC=>TS_ZTT_EMPLOYEE_MSC
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ztt_employee_###_get_entity.
**TRY.
*CALL METHOD SUPER->ZTT_EMPLOYEE_###_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

* request-example:
* /sap/opu/odata/sap/ZOD_EMPLOYEE_###_SRV/ZTT_EMPLOYEE_MSCSet(IdEmployee='1',Carrier='AA')
*   ztt_employee_msc

    data: ls_key_tab    type /iwbep/s_mgw_name_value_pair,
          lv_employeeid type ztt_employee_msc-id_employee,
          lv_carrier    type ztt_employee_msc-carrier,
          ls_employee   type ztt_employee_msc.

* get the input parameters: key property values
    read table it_key_tab with key name = 'IdEmployee' into ls_key_tab.
    lv_employeeid = ls_key_tab-value.

    read table it_key_tab with key name = 'Carrier' into ls_key_tab.
    lv_carrier = ls_key_tab-value.

* read record
    select single * from ztt_employee_msc into ls_employee where id_employee = lv_employeeid and carrier = lv_carrier.

* fill er_entity
    if sy-subrc = 0.
      move-corresponding ls_employee to er_entity.
    else.
* Raise Exception
      raise exception type /iwbep/cx_mgw_busi_exception
        exporting
          textid = /iwbep/cx_mgw_busi_exception=>resource_not_found.
    endif.

*  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
*    EXPORTING
*      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
*      method = 'ZTT_EMPLOYEE_###_GET_ENTITY'.


  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_z_ods_EMPLOYEE_###_DPC_EXT->ZTT_EMPLOYEE_###_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS       TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                      TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                       TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING               TYPE        STRING
* | [--->] IV_SEARCH_STRING               TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<---] ET_ENTITYSET                   TYPE        ZCL_z_ods_EMPLOYEE_###_MPC=>TT_ZTT_EMPLOYEE_MSC
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ztt_employee_###_get_entityset.
**TRY.
*CALL METHOD SUPER->ZTT_EMPLOYEE_###_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

* request-example:
* /sap/opu/odata/sap/ZOD_EMPLOYEE_###_SRV/ZTT_EMPLOYEE_MSCSet
* /sap/opu/odata/sap/ZOD_EMPLOYEE_###_SRV/ZTT_EMPLOYEE_MSCSet(IdEmployee='1',Carrier='AA')
* /sap/opu/odata/sap/ZOD_EMPLOYEE_###_SRV/ZTT_EMPLOYEE_MSCSet/?$select=Lastname,Firstname,Department
* /sap/opu/odata/sap/ZOD_EMPLOYEE_###_SRV/ZTT_EMPLOYEE_MSCSet/?$filter=Carrier eq 'SR'
* /sap/opu/odata/sap/ZOD_EMPLOYEE_###_SRV/ZTT_EMPLOYEE_MSCSet/?$orderby=Carrier desc

    data: lt_employee type table of ztt_employee_msc,
          ls_employee like line of lt_employee,
          ls_entity   like line of et_entityset,
          ls_orderopt like line of it_order,
          lv_order    type string.

* read data
    if iv_filter_string is initial.
      select * from ztt_employee_msc into table lt_employee.
    else.
* read data with one filter: property and select_options
      " simple way for any parameter
      select * from ztt_employee_msc into table lt_employee where (iv_filter_string).
    endif.

* order itab
    if it_order is not initial.
      loop at it_order into ls_orderopt.
        "CONCATENATE: ls_orderopt-order 'ending' INTO lv_order.
        case ls_orderopt-order.
          when 'asc'.
            sort lt_employee by (ls_orderopt-property) ascending. "(lv_order).
          when 'desc'.
            sort lt_employee by (ls_orderopt-property) descending.
        endcase.
      endloop.
    endif.

* fill et_entityset
    loop at lt_employee into ls_employee.
      move-corresponding ls_employee to ls_entity.
      append ls_entity to et_entityset.
    endloop.

*  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
*    EXPORTING
*      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
*      method = 'ZTT_EMPLOYEE_###_GET_ENTITYSET'.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_z_ods_EMPLOYEE_###_DPC_EXT->ZTT_EMPLOYEE_###_UPDATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_U(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        ZCL_z_ods_EMPLOYEE_###_MPC=>TS_ZTT_EMPLOYEE_MSC
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ztt_employee_###_update_entity.
**TRY.
*CALL METHOD SUPER->ZTT_EMPLOYEE_###_UPDATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

 data: ls_request_input_data type zcl_z_ods_employee_###_mpc=>ts_ztt_employee_msc,
          ls_key_tab            type /iwbep/s_mgw_name_value_pair,
          lv_employeeid         type ztt_employee_msc-id_employee,
          ls_employee           type ztt_employee_msc.

* get key values
    read table it_key_tab with key name = 'IdEmployee' into ls_key_tab.
    lv_employeeid = ls_key_tab-value.

    if lv_employeeid is not initial.
* read request data
      io_data_provider->read_entry_data( importing es_data = ls_request_input_data ).

* update db-table
      update ztt_employee_msc set
        area = ls_request_input_data-area
        department = ls_request_input_data-department
        firstname = ls_request_input_data-firstname
        lastname = ls_request_input_data-lastname
        salary = ls_request_input_data-salary
        currency = ls_request_input_data-currency
      where
        id_employee = lv_employeeid.

      if sy-subrc = 0.
        er_entity = ls_request_input_data.
      endif.
    endif.

*  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
*    EXPORTING
*      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
*      method = 'ZTT_EMPLOYEE_###_UPDATE_ENTITY'.

  endmethod.
endclass.
