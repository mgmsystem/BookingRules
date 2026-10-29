
unit BookingRules.FailingCustomerRepository;

interface

uses
  System.SysUtils,
  BookingRules.CustomerRepository;

type
  TRepositoryFailure = (
    rfIsActive,
    rfIsBlocked
  );

  TFailingCustomerRepository = class(
    TInterfacedObject,
    ICustomerRepository)
  private
    FFailure: TRepositoryFailure;
  public
    constructor Create(AFailure: TRepositoryFailure);

    function IsActive(ACustomerId: Integer): Boolean;
    function IsBlocked(ACustomerId: Integer): Boolean;
  end;

implementation

constructor TFailingCustomerRepository.Create(
  AFailure: TRepositoryFailure);
begin
  inherited Create;
  FFailure := AFailure;
end;

function TFailingCustomerRepository.IsActive(
  ACustomerId: Integer): Boolean;
begin
  if FFailure = rfIsActive then
    raise Exception.Create('Falha ao consultar cliente');

  Result := True;
end;

function TFailingCustomerRepository.IsBlocked(
  ACustomerId: Integer): Boolean;
begin
  if FFailure = rfIsBlocked then
    raise Exception.Create('Falha ao consultar bloqueio');

  Result := False;
end;

end.

