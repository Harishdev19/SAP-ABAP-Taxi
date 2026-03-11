@EndUserText.label: 'Consumption View for Driver Master'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
define view entity ZC_CIT_TAXI_DRV15
  as select from ZI_CIT_TAXI_DRV15
{
  @Search.defaultSearchElement: true
  key DriverID,
  
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  DriverName,
  
  PhoneNumber,
  VehicleNumber,
  AvailabilityStatus,
  LastChangedAt
}
