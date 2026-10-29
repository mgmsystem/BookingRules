
unit BookingRules.SpyCustomerRepository;

interface

uses
  BookingRules.CustomerRepository;

type
  TSpyCustomerRepository = class(TInterfacedObject, ICustomerRepository)
  private
    FActiveCalls: Integer;
    FBlockedCalls: Integer;
    FCustomerActive: Boolean;
  public
    constructor Create(ACustomerActive: Boolean = True);

    function IsActive(ACustomerId: Integer): Boolean;
    function IsBlocked(ACustomerId: Integer): Boolean;

    property ActiveCalls: Integer read FActiveCalls;
    property BlockedCalls: Integer read FBlockedCalls;
  end;

implementation

constructor TSpyCustomerRepository.Create(
  ACustomerActive: Boolean);
begin
  inherited Create;
  FCustomerActive := ACustomerActive;
end;

function TSpyCustomerRepository.IsActive(
  ACustomerId: Integer): Boolean;
begin
  Inc(FActiveCalls);
  Result := FCustomerActive;
end;

function TSpyCustomerRepository.IsBlocked(
  ACustomerId: Integer): Boolean;
begin
  Inc(FBlockedCalls);
  Result := False;
end;

end.

