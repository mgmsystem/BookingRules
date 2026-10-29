
unit BookingRules.FailingCustomerRepository;

interface

uses
  System.SysUtils,
  BookingRules.CustomerRepository;

type
  TFailingCustomerRepository = class(
    TInterfacedObject,
    ICustomerRepository)
  private
  public
    function TryGetStatus(
      ACustomerId: Integer;
      out AStatus: TCustomerStatus): Boolean;
  end;

implementation

function TFailingCustomerRepository.TryGetStatus(
  ACustomerId: Integer;
  out AStatus: TCustomerStatus): Boolean;
begin
  raise Exception.Create('Falha ao consultar cliente');
end;

end.

