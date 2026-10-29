
unit BookingRules.FakeCustomerRepository;

interface

uses
  BookingRules.CustomerRepository;

type
  TFakeCustomerRepository = class(TInterfacedObject, ICustomerRepository)
  private
    FCustomerActive: Boolean;
    FCustomerBlocked: Boolean;

    FLastCustomerId: Integer;
  public
    constructor Create(
      ACustomerActive: Boolean;
      ACustomerBlocked: Boolean = False);

    function TryGetStatus(
      ACustomerId: Integer;
      out AStatus: TCustomerStatus): Boolean;

    property LastCustomerId: Integer read FLastCustomerId;
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

function TFakeCustomerRepository.TryGetStatus(
  ACustomerId: Integer;
  out AStatus: TCustomerStatus): Boolean;
begin
  FLastCustomerId := ACustomerId;
  AStatus.Active := FCustomerActive;
  AStatus.Blocked := FCustomerBlocked;
  Result := True;
end;

end.

