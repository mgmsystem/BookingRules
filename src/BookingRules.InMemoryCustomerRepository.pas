
unit BookingRules.InMemoryCustomerRepository;

interface

uses
  System.Generics.Collections,
  BookingRules.CustomerRepository;

type
  TCustomer = record
    Id: Integer;
    Active: Boolean;
    Blocked: Boolean;
  end;

  TInMemoryCustomerRepository = class(
    TInterfacedObject, ICustomerRepository)
  private
    FCustomers: TDictionary<Integer, TCustomer>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddCustomer(
      AId: Integer;
      AActive: Boolean;
      ABlocked: Boolean);

    function TryGetStatus(
      ACustomerId: Integer;
      out AStatus: TCustomerStatus): Boolean;
  end;

implementation

constructor TInMemoryCustomerRepository.Create;
begin
  inherited Create;
  FCustomers := TDictionary<Integer, TCustomer>.Create;
end;

destructor TInMemoryCustomerRepository.Destroy;
begin
  FCustomers.Free;
  inherited;
end;

procedure TInMemoryCustomerRepository.AddCustomer(
  AId: Integer;
  AActive: Boolean;
  ABlocked: Boolean);
var
  Customer: TCustomer;
begin
  Customer.Id := AId;
  Customer.Active := AActive;
  Customer.Blocked := ABlocked;

  FCustomers.AddOrSetValue(AId, Customer);
end;

function TInMemoryCustomerRepository.TryGetStatus(
  ACustomerId: Integer;
  out AStatus: TCustomerStatus): Boolean;
var
  Customer: TCustomer;
begin
  Result := FCustomers.TryGetValue(ACustomerId, Customer);

  if Result then
  begin
    AStatus.Active := Customer.Active;
    AStatus.Blocked := Customer.Blocked;
  end
  else
    AStatus := Default(TCustomerStatus);
end;

end.

