unit BookingRules.CustomerRepository;

interface

type
  ICustomerRepository = interface
    ['{8E7F2D13-2C3A-4B9F-9A74-6D5E9A2B71C0}']
    function IsActive(ACustomerId: Integer): Boolean;
    function IsBlocked(ACustomerId: Integer): Boolean;
  end;

implementation

end.
