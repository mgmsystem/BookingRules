unit BookingRules.CustomerRepository;

interface

type
  TCustomerStatus = record
    Active: Boolean;
    Blocked: Boolean;
  end;

  ICustomerRepository = interface
    ['{8E7F2D13-2C3A-4B9F-9A74-6D5E9A2B71C0}']
    function TryGetStatus(
      ACustomerId: Integer;
      out AStatus: TCustomerStatus): Boolean;
  end;

implementation

end.
