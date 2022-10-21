@AbapCatalog.sqlViewName: 'ZISAPDEVCDSAVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Annotation Value Help'
define view ZI_SapDevCdsAnnoVH
  as select distinct from ZI_SapDevCdsAnno as Anno
{
  key Anno.Name as Name
}
