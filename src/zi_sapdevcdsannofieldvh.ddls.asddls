@AbapCatalog.sqlViewName: 'ZISAPDEVCDSFAVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Field Annotations'
define view ZI_SapDevCdsAnnoFieldVH
  as select distinct from ZI_SapDevCdsAnnoField as FieldAnno
{
  key FieldAnno.Name as Name
}
