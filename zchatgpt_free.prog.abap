*&---------------------------------------------------------------------*
*& Report ZCHATGPT_FREE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCHATGPT_FREE.

PARAMETERS: p_vkorg TYPE vkorg OBLIGATORY,  " Sales Organization
            p_vbeln TYPE auart OBLIGATORY.  " Sales Document Type

TYPES: BEGIN OF ty_sales_doc,
         vbeln       TYPE vbeln_va,     " Sales Document Number
         erdat       TYPE erdat,        " Document Date
         kunnr       TYPE kunnr,        " Sold-to Party Number
         name1       TYPE name1,        " Sold-to Party Name
       END OF ty_sales_doc.

DATA: it_sales_doc TYPE TABLE OF ty_sales_doc,
      wa_sales_doc TYPE ty_sales_doc.

DATA: gr_table TYPE REF TO cl_salv_table.

START-OF-SELECTION.

  " Fetch data from the database
  SELECT vbak~vbeln,
         vbak~erdat,
         vbak~kunnr,
         kna1~name1
    INTO TABLE @it_sales_doc        "Fixed it
    FROM vbak
    INNER JOIN kna1 ON vbak~kunnr = kna1~kunnr
    WHERE vbak~vkorg = @p_vkorg     "Fixed it
      AND vbak~auart = @p_vbeln.    "Fixed it

  " Display data using SALV
  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = gr_table
        CHANGING  t_table      = it_sales_doc ).

      gr_table->display( ).

    CATCH cx_salv_msg.
      MESSAGE `Error displaying the ALV.` TYPE 'E'.
  ENDTRY.
