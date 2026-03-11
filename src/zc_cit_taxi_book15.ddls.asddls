@EndUserText.label: 'Consumption View for Taxi Booking'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_CIT_TAXI_BOOK15
  provider contract transactional_query
  as projection on ZI_CIT_TAXI_BOOK
{
  @Search.defaultSearchElement: true
  key BookingUUID,
  
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  CustomerName,
  
  PickupLocation,
  DropLocation,
  
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_CIT_TAXI_DRV', element: 'DriverID' } }]
  DriverID,
  
  VehicleNumber,
  Status,
  
  /* Hidden field used for UI color coding */
  StatusCriticality,
  
  BookingDate,
  
  @Semantics.amount.currencyCode: 'Currency'
  FareAmount,
  
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency' } }]
  Currency,
  
  LocalLastChangedAt,
  LastChangedAt,
  
  /* Expose Associations */
  _Driver
}
