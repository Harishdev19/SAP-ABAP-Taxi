CLASS lhc_TaxiBooking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    " Authorization method to prevent the system dump we saw last time!
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR TaxiBooking RESULT result.

    " Methods for our custom buttons
    METHODS AssignDriver FOR MODIFY
      IMPORTING keys FOR ACTION TaxiBooking~AssignDriver RESULT result.

    METHODS StartTrip FOR MODIFY
      IMPORTING keys FOR ACTION TaxiBooking~StartTrip RESULT result.

    METHODS CompleteTrip FOR MODIFY
      IMPORTING keys FOR ACTION TaxiBooking~CompleteTrip RESULT result.

    " Method to automatically set status when a new booking is created
    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR TaxiBooking~setInitialStatus.
ENDCLASS.

CLASS lhc_TaxiBooking IMPLEMENTATION.

  METHOD get_global_authorizations.
    " Granting global authorization so the Fiori app loads without dumping
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.
    IF requested_authorizations-%update = if_abap_behv=>mk-on.
      result-%update = if_abap_behv=>auth-allowed.
    ENDIF.
    IF requested_authorizations-%delete = if_abap_behv=>mk-on.
      result-%delete = if_abap_behv=>auth-allowed.
    ENDIF.
  ENDMETHOD.

  METHOD AssignDriver.
    " Update the status to 'Driver Assigned' [cite: 22]
    MODIFY ENTITIES OF ZI_CIT_TAXI_BOOK15 IN LOCAL MODE
      ENTITY TaxiBooking
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'Driver Assigned' ) ).

    " Refresh the UI with the new status
    READ ENTITIES OF ZI_CIT_TAXI_BOOK15 IN LOCAL MODE
      ENTITY TaxiBooking ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_bookings).
    result = VALUE #( FOR booking IN lt_bookings ( %tky = booking-%tky %param = booking ) ).
  ENDMETHOD.

  METHOD StartTrip.
    " Update the status to 'Trip Started' [cite: 22]
    MODIFY ENTITIES OF ZI_CIT_TAXI_BOOK15 IN LOCAL MODE
      ENTITY TaxiBooking
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'Trip Started' ) ).

    READ ENTITIES OF ZI_CIT_TAXI_BOOK15 IN LOCAL MODE
      ENTITY TaxiBooking ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_bookings).
    result = VALUE #( FOR booking IN lt_bookings ( %tky = booking-%tky %param = booking ) ).
  ENDMETHOD.

  METHOD CompleteTrip.
    " Update the status to 'Completed' [cite: 23]
    MODIFY ENTITIES OF ZI_CIT_TAXI_BOOK15 IN LOCAL MODE
      ENTITY TaxiBooking
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'Completed' ) ).

    READ ENTITIES OF ZI_CIT_TAXI_BOOK15 IN LOCAL MODE
      ENTITY TaxiBooking ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_bookings).
    result = VALUE #( FOR booking IN lt_bookings ( %tky = booking-%tky %param = booking ) ).
  ENDMETHOD.

  METHOD setInitialStatus.
    " Read the newly created bookings
    READ ENTITIES OF ZI_CIT_TAXI_BOOK15 IN LOCAL MODE
      ENTITY TaxiBooking FIELDS ( Status ) WITH CORRESPONDING #( keys ) RESULT DATA(lt_bookings).

    " Automatically set the status to 'Booked' if it is empty [cite: 21]
    MODIFY ENTITIES OF ZI_CIT_TAXI_BOOK15 IN LOCAL MODE
      ENTITY TaxiBooking
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR booking IN lt_bookings
                    WHERE ( Status IS INITIAL )
                    ( %tky = booking-%tky Status = 'Booked' ) ).
  ENDMETHOD.

ENDCLASS.
