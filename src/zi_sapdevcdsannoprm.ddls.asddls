@AbapCatalog.sqlViewName: 'ZISAPDEVCDSPA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Parameter Annotations'
define view ZI_SapDevCdsAnnoPrm
  as select distinct from ddparameteranno as ParameterAnno
{
  key    cast( ParameterAnno.strucobjn as zde_ddstrucobjname )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            as Strucobjn,
         //key FieldAnno.name                     as Name,
  key    cast( REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ParameterAnno.name, '$1$', ''), '$2$', '') , '$3$', ''), '$4$', ''), '$5$', ''), '$6$', ''), '$7$', ''), '$8$', ''), '$9$', ''), '$10$', ''), '$11$', ''), '$12$', ''), '$13$', ''), '$14$', ''), '$15$', ''), '$16$', ''), '$17$', ''), '$18$', ''), '$19$', ''), '$20$', ''), '$21$', ''), '$22$', ''), '$23$', ''), '$24$', ''), '$25$', ''), '$26$', ''), '$27$', ''), '$28$', ''), '$29$', ''), '$30$', '') as zde_ddannotation_key ) as Name

}
