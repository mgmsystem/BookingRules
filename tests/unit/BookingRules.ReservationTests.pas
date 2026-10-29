
unit BookingRules.ReservationTests;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  BookingRules.Reservation,
  BookingRules.FailingCustomerRepository,
  BookingRules.SpyCustomerRepository;

type
  [TestFixture]
  TReservationTests = class
  private
    FReservation: TReservation;
    FSpy: TSpyCustomerRepository;

    function CriarReserva(
      AClienteAtivo: Boolean;
      AClienteBloqueado: Boolean = False): TReservation;

    procedure ConfigurarReserva(
      AClienteAtivo: Boolean;
      AClienteBloqueado: Boolean = False;
      ASemRepositorio: Boolean = False);

    procedure ConfigurarReservaComSpy(
      AClienteAtivo: Boolean = True);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure NaoDeveConfirmarReservaParaClienteInativo;
    [Test]
    procedure NaoDeveConfirmarReservaParaClienteBloqueado;
    [Test]
    procedure NaoDeveConfirmarReservaSemRepositorio;
    [Test]
    procedure DeveConsultarClienteDaReserva;
    [Test]
    procedure DevePropagarErroAoConsultarCliente;
    [Test]
    procedure DevePropagarErroAoConsultarBloqueio;
    [Test]
    procedure NaoDeveConsultarRepositorioQuandoQuantidadeInvalida;
    [Test]
    procedure DeveConsultarRepositorioAoConfirmarReservaValida;
    [Test]
    procedure NaoDeveConsultarBloqueioQuandoClienteInativo;

    [Test]
    [TestCase('Zero participantes', '0,False')]
    [TestCase('Participantes negativos', '-1,False')]
    [TestCase('Um participante', '1,True')]
    [TestCase('Capacidade maxima', '5,True')]
    [TestCase('Acima da capacidade', '6,False')]
    procedure DeveValidarQuantidadeParticipantes(
      AQuantidade: Integer;
      AEsperado: Boolean);
  end;

implementation

uses
  BookingRules.CustomerRepository,
  BookingRules.FakeCustomerRepository;

function TReservationTests.CriarReserva(
  AClienteAtivo: Boolean;
  AClienteBloqueado: Boolean): TReservation;
var
  Repository: ICustomerRepository;
begin
  Repository := TFakeCustomerRepository.Create(
    AClienteAtivo,
    AClienteBloqueado);

  Result := TReservation.Create(1, Repository);
end;

procedure TReservationTests.ConfigurarReserva(
  AClienteAtivo: Boolean;
  AClienteBloqueado: Boolean;
  ASemRepositorio: Boolean);
begin
  FreeAndNil(FReservation);
  FSpy := nil;

  if ASemRepositorio then
    FReservation := TReservation.Create(1, nil)
  else
    FReservation := CriarReserva(
      AClienteAtivo,
      AClienteBloqueado);
end;


procedure TReservationTests.ConfigurarReservaComSpy(
  AClienteAtivo: Boolean);
var
  Repository: ICustomerRepository;
begin
  FreeAndNil(FReservation);

  FSpy := TSpyCustomerRepository.Create(AClienteAtivo);
  Repository := FSpy;

  FReservation := TReservation.Create(1, Repository);
end;

procedure TReservationTests.Setup;
begin
  FReservation := nil;
  FSpy := nil;
  ConfigurarReserva(True);
end;

procedure TReservationTests.TearDown;
begin
  FreeAndNil(FReservation);
  FSpy := nil;
end;

procedure TReservationTests.NaoDeveConfirmarReservaParaClienteInativo;
begin
  ConfigurarReserva(False);

  Assert.IsFalse(FReservation.CanConfirm(1));
end;

procedure TReservationTests.NaoDeveConfirmarReservaParaClienteBloqueado;
begin
  ConfigurarReserva(True, True);

  Assert.IsFalse(FReservation.CanConfirm(1));
end;

procedure TReservationTests.NaoDeveConfirmarReservaSemRepositorio;
begin
  ConfigurarReserva(True, False, True);

  Assert.IsFalse(FReservation.CanConfirm(1));
end;

procedure TReservationTests.DeveConsultarClienteDaReserva;
var
  Repository: TFakeCustomerRepository;
  CustomerRepository: ICustomerRepository;
  Reservation: TReservation;
begin
  Repository := TFakeCustomerRepository.Create(True);

  CustomerRepository := Repository;

  Reservation := TReservation.Create(25, CustomerRepository);
  try
    Assert.IsTrue(Reservation.CanConfirm(1));

    Assert.AreEqual(25, Repository.LastActiveCustomerId);
    Assert.AreEqual(25, Repository.LastBlockedCustomerId);
  finally
    Reservation.Free;
  end;
end;

procedure TReservationTests.DeveValidarQuantidadeParticipantes(
  AQuantidade: Integer;
  AEsperado: Boolean);
begin
  Assert.AreEqual(
    AEsperado,
    FReservation.CanConfirm(AQuantidade));
end;


procedure TReservationTests.DevePropagarErroAoConsultarCliente;
var
  Repository: ICustomerRepository;
  Reservation: TReservation;
begin
  Repository := TFailingCustomerRepository.Create(rfIsActive);
  Reservation := TReservation.Create(1, Repository);
  try
    Assert.WillRaise(
      procedure
      begin
        Reservation.CanConfirm(1);
      end,
      Exception);
  finally
    Reservation.Free;
  end;
end;

procedure TReservationTests.DevePropagarErroAoConsultarBloqueio;
var
  Repository: ICustomerRepository;
  Reservation: TReservation;
begin
  Repository := TFailingCustomerRepository.Create(rfIsBlocked);
  Reservation := TReservation.Create(1, Repository);
  try
    Assert.WillRaise(
      procedure
      begin
        Reservation.CanConfirm(1);
      end,
      Exception);
  finally
    Reservation.Free;
  end;
end;

procedure TReservationTests.NaoDeveConsultarRepositorioQuandoQuantidadeInvalida;
begin
  ConfigurarReservaComSpy;

  Assert.IsFalse(FReservation.CanConfirm(0));

  Assert.AreEqual(0, FSpy.ActiveCalls);
  Assert.AreEqual(0, FSpy.BlockedCalls);
end;

procedure TReservationTests.DeveConsultarRepositorioAoConfirmarReservaValida;
begin
  ConfigurarReservaComSpy;

  Assert.IsTrue(FReservation.CanConfirm(1));

  Assert.AreEqual(1, FSpy.ActiveCalls);
  Assert.AreEqual(1, FSpy.BlockedCalls);
end;

procedure TReservationTests.NaoDeveConsultarBloqueioQuandoClienteInativo;
begin
  ConfigurarReservaComSpy(False);

  Assert.IsFalse(FReservation.CanConfirm(1));

  Assert.AreEqual(1, FSpy.ActiveCalls);
  Assert.AreEqual(0, FSpy.BlockedCalls);
end;

initialization
  TDUnitX.RegisterTestFixture(TReservationTests);

end.

