
unit BookingRules.SpyCustomerRepository;

interface

uses
  BookingRules.CustomerRepository;

type
  TSpyCustomerRepository = class(TInterfacedObject, ICustomerRepository)
  private
    FStatusCalls: Integer;
    FCustomerActive: Boolean;
  public
    constructor Create(ACustomerActive: Boolean = True);

    function TryGetStatus(
      ACustomerId: Integer;
      out AStatus: TCustomerStatus): Boolean;

    property StatusCalls: Integer read FStatusCalls;
  end;

implementation

constructor TSpyCustomerRepository.Create(
  ACustomerActive: Boolean);
begin
  inherited Create;
  FCustomerActive := ACustomerActive;
end;

function TSpyCustomerRepository.TryGetStatus(
  ACustomerId: Integer;
  out AStatus: TCustomerStatus): Boolean;
begin
  Inc(FStatusCalls);
  AStatus.Active := FCustomerActive;
  AStatus.Blocked := False;
  Result := True;
end;

end.

