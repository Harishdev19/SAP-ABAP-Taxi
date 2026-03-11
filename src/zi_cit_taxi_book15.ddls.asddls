@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Taxi Booking'
define root view entity ZI_CIT_TAXI_BOOK15
  as select from zcit_taxi_book1
  association [0..1] to ZI_CIT_TAXI_DRV as _Driver on $projection.DriverID = _Driver.DriverID
{
  key booking_uuid as BookingUUID,
  customer_name as CustomerName,
  pickup_location as PickupLocation,
  drop_location as DropLocation,
  driver_id as DriverID,
  vehicle_number as VehicleNumber,
  status as Status,
  
  /* Dynamic color coding for the UI based on Status */
  case status
    when 'Completed' then 3       // 3 = Green
    when 'Trip Started' then 2    // 2 = Yellow
    when 'Driver Assigned' then 2 // 2 = Yellow
    when 'Booked' then 1          // 1 = Blue/Neutral
    else 0                        // 0 = Unknown/Grey
  end as StatusCriticality,

  booking_date as BookingDate,
  
  @Semantics.amount.currencyCode: 'Currency'
  fare_amount as FareAmount,
  currency as Currency,

  /* Admin fields required by Managed RAP */
  local_last_changed_at as LocalLastChangedAt,
  last_changed_at as LastChangedAt,

  /* Expose the association so the UI can use it */
  _Driver
}
