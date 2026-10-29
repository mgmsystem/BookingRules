
unit BookingRules.ReservationIntegrationTests;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TReservationIntegrationTests = class
  public
    [Test]
    procedure DeveConfirmarReservaParaClienteAtivo;

    [Test]
    procedure NaoDeveConfirmarReservaParaClienteBloqueado;

    [Test]
    procedure NaoDeveConfirmarReservaParaClienteInexistente;

    [Test]
    procedure DeveInformarMotivoParaClienteInativo;

    [Test]
    procedure DeveInformarMotivoParaClienteBloqueado;

    [Test]
    procedure DeveInformarQuandoClienteNaoExiste;
  end;

implementation

uses
  BookingRules.Reservation,
  BookingRules.CustomerRepository,
  BookingRules.InMemoryCustomerRepository;

procedure TReservationIntegrationTests.DeveConfirmarReservaParaClienteAtivo;
var
  Repository: ICustomerRepository;
  MemoryRepository: TInMemoryCustomerRepository;
  Reservation: TReservation;
begin
  MemoryRepository := TInMemoryCustomerRepository.Create;
  Repository := MemoryRepository;

  MemoryRepository.AddCustomer(25, True, False);

  Reservation := TReservation.Create(25, Repository);
  try
    Assert.IsTrue(Reservation.CanConfirm(1));
  finally
    Reservation.Free;
  end;
end;

procedure TReservationIntegrationTests.NaoDeveConfirmarReservaParaClienteBloqueado;
var
  Repository: ICustomerRepository;
  MemoryRepository: TInMemoryCustomerRepository;
  Reservation: TReservation;
begin
  MemoryRepository := TInMemoryCustomerRepository.Create;
  Repository := MemoryRepository;

  MemoryRepository.AddCustomer(25, True, True);

  Reservation := TReservation.Create(25, Repository);
  try
    Assert.IsFalse(Reservation.CanConfirm(1));
  finally
    Reservation.Free;
  end;
end;

procedure TReservationIntegrationTests.NaoDeveConfirmarReservaParaClienteInexistente;
var
  Repository: ICustomerRepository;
  MemoryRepository: TInMemoryCustomerRepository;
  Reservation: TReservation;
begin
  MemoryRepository := TInMemoryCustomerRepository.Create;
  Repository := MemoryRepository;

  Reservation := TReservation.Create(99, Repository);
  try
    Assert.IsFalse(Reservation.CanConfirm(1));
  finally
    Reservation.Free;
  end;
end;

procedure TReservationIntegrationTests.DeveInformarMotivoParaClienteInativo;
var
  Repository: ICustomerRepository;
  MemoryRepository: TInMemoryCustomerRepository;
  Reservation: TReservation;
begin
  MemoryRepository := TInMemoryCustomerRepository.Create;
  Repository := MemoryRepository;
  MemoryRepository.AddCustomer(25, False, False);

  Reservation := TReservation.Create(25, Repository);
  try
    Assert.AreEqual(rdCustomerInactive, Reservation.Evaluate(1));
  finally
    Reservation.Free;
  end;
end;

procedure TReservationIntegrationTests.DeveInformarMotivoParaClienteBloqueado;
var
  Repository: ICustomerRepository;
  MemoryRepository: TInMemoryCustomerRepository;
  Reservation: TReservation;
begin
  MemoryRepository := TInMemoryCustomerRepository.Create;
  Repository := MemoryRepository;
  MemoryRepository.AddCustomer(25, True, True);

  Reservation := TReservation.Create(25, Repository);
  try
    Assert.AreEqual(rdCustomerBlocked, Reservation.Evaluate(1));
  finally
    Reservation.Free;
  end;
end;

procedure TReservationIntegrationTests.DeveInformarQuandoClienteNaoExiste;
var
  Repository: ICustomerRepository;
  MemoryRepository: TInMemoryCustomerRepository;
  Reservation: TReservation;
begin
  MemoryRepository := TInMemoryCustomerRepository.Create;
  Repository := MemoryRepository;

  Reservation := TReservation.Create(99, Repository);
  try
    Assert.AreEqual(rdCustomerNotFound, Reservation.Evaluate(1));
  finally
    Reservation.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TReservationIntegrationTests);

end.

