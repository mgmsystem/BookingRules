
unit BookingRules.FakeCustomerRepository;

interface

uses
  BookingRules.CustomerRepository;

type
  TFakeCustomerRepository = class(TInterfacedObject, ICustomerRepository)
  private
    FCustomerActive: Boolean;
    FCustomerBlocked: Boolean;

    FLastActiveCustomerId: Integer;
    FLastBlockedCustomerId: Integer;
  public
    constructor Create(
      ACustomerActive: Boolean;
      ACustomerBlocked: Boolean = False);

    function IsActive(ACustomerId: Integer): Boolean;
    function IsBlocked(ACustomerId: Integer): Boolean;

    property LastActiveCustomerId: Integer
      read FLastActiveCustomerId;

    property LastBlockedCustomerId: Integer
      read FLastBlockedCustomerId;
  end;

implementation

constructor TFakeCustomerRepository.Create(
  ACustomerActive: Boolean;
  ACustomerBlocked: Boolean);
begin
  inherited Create;
  FCustomerActive := ACustomerActive;
  FCustomerBlocked := ACustomerBlocked;
end;

function TFakeCustomerRepository.IsActive(
  ACustomerId: Integer): Boolean;
begin
  FLastActiveCustomerId := ACustomerId;
  Result := FCustomerActive;
end;

function TFakeCustomerRepository.IsBlocked(
  ACustomerId: Integer): Boolean;
begin
  FLastBlockedCustomerId := ACustomerId;
  Result := FCustomerBlocked;
end;

end.

