@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Driver Master'
define view entity ZI_CIT_TAXI_DRV15
  as select from zcit_taxi_drv1
{
  key driver_id as DriverID,
  driver_name as DriverName,
  phone_number as PhoneNumber,
  vehicle_number as VehicleNumber,
  availability_status as AvailabilityStatus,
  last_changed_at as LastChangedAt
}
