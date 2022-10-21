@AbapCatalog.sqlViewName: 'ZISAPDEVCDSA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Annotations'
define view ZI_SapDevCdsAnno
  as select from ZI_SapDevCdsAnnoField
{
  key Strucobjn,
  key Name
}
union select from ZI_SapDevCdsAnnoField
{
  key Strucobjn,
  key Name
}
union select from ZI_SapDevCdsAnnoPrm
{
  key Strucobjn,
  key Name
}
