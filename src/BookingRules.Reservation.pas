unit BookingRules.Reservation;

interface

uses
  BookingRules.CustomerRepository;

type
  TReservationDecision = (
    rdConfirmed,
    rdInvalidParticipantCount,
    rdRepositoryUnavailable,
    rdCustomerNotFound,
    rdCustomerInactive,
    rdCustomerBlocked
  );

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

    function Evaluate(AParticipantCount: Integer): TReservationDecision;
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
  Result := Evaluate(AParticipantCount) = rdConfirmed;
end;

function TReservation.Evaluate(
  AParticipantCount: Integer): TReservationDecision;
var
  CustomerStatus: TCustomerStatus;
begin
  if (AParticipantCount <= 0) or
     (AParticipantCount > MaxParticipants) then
    Exit(rdInvalidParticipantCount);

  if not Assigned(FCustomerRepository) then
    Exit(rdRepositoryUnavailable);

  if not FCustomerRepository.TryGetStatus(
    FCustomerId,
    CustomerStatus) then
    Exit(rdCustomerNotFound);

  if not CustomerStatus.Active then
    Exit(rdCustomerInactive);

  if CustomerStatus.Blocked then
    Exit(rdCustomerBlocked);

  Result := rdConfirmed;
end;

end.
