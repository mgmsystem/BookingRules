unit BookingRules.Reservation;

interface

uses
  BookingRules.CustomerRepository;

type
  TReservation = class
  private
    const MaxParticipants = 5;
  private
    FCustomerId: Integer;
    FCustomerRepository: ICustomerRepository;
  public
    constructor Create(
      ACustomerId: Integer;
      ACustomerRepository: ICustomerRepository);

    function CanConfirm(AParticipantCount: Integer): Boolean;
  end;

implementation

constructor TReservation.Create(
  ACustomerId: Integer;
  ACustomerRepository: ICustomerRepository);
begin
  inherited Create;

  FCustomerId := ACustomerId;
  FCustomerRepository := ACustomerRepository;
end;

function TReservation.CanConfirm(
  AParticipantCount: Integer): Boolean;
begin
  Result := (AParticipantCount > 0) and
            (AParticipantCount <= MaxParticipants) and
            Assigned(FCustomerRepository);

  if Result then
  begin
    Result := FCustomerRepository.IsActive(FCustomerId);

    if Result then
      Result := not FCustomerRepository.IsBlocked(FCustomerId);
  end;
end;

end.
