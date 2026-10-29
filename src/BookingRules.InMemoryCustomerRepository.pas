
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

    function IsActive(ACustomerId: Integer): Boolean;
    function IsBlocked(ACustomerId: Integer): Boolean;
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

function TInMemoryCustomerRepository.IsActive(
  ACustomerId: Integer): Boolean;
var
  Customer: TCustomer;
begin
  Result := FCustomers.TryGetValue(ACustomerId, Customer)
    and Customer.Active;
end;

function TInMemoryCustomerRepository.IsBlocked(
  ACustomerId: Integer): Boolean;
var
  Customer: TCustomer;
begin
  Result := FCustomers.TryGetValue(ACustomerId, Customer)
    and Customer.Blocked;
end;

end.

