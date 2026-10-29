
program BookingRules;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  BookingRules.Reservation in 'src\BookingRules.Reservation.pas',
  BookingRules.CustomerRepository in 'src\BookingRules.CustomerRepository.pas',
  BookingRules.InMemoryCustomerRepository in 'src\BookingRules.InMemoryCustomerRepository.pas';

function DecisionToText(ADecision: TReservationDecision): string;
begin
  case ADecision of
    rdConfirmed:
      Result := 'CONFIRMADA';
    rdInvalidParticipantCount:
      Result := 'RECUSADA - quantidade de participantes invalida';
    rdRepositoryUnavailable:
      Result := 'RECUSADA - repositorio indisponivel';
    rdCustomerNotFound:
      Result := 'RECUSADA - cliente nao encontrado';
    rdCustomerInactive:
      Result := 'RECUSADA - cliente inativo';
    rdCustomerBlocked:
      Result := 'RECUSADA - cliente bloqueado';
  else
    Result := 'RECUSADA - motivo desconhecido';
  end;
end;

procedure DemonstrateReservation(
  const ARepository: ICustomerRepository;
  ACustomerId: Integer;
  AParticipantCount: Integer);
var
  Reservation: TReservation;
begin
  Reservation := TReservation.Create(
    ACustomerId,
    ARepository
  );
  try
    Write(
      'Cliente: ', ACustomerId,
      ' | Participantes: ', AParticipantCount,
      ' | Resultado: '
    );

    Writeln(DecisionToText(
      Reservation.Evaluate(AParticipantCount)));
  finally
    Reservation.Free;
  end;
end;

var
  CustomerRepository: ICustomerRepository;
  MemoryRepository: TInMemoryCustomerRepository;

begin
  try
    Writeln('========================================');
    Writeln(' BookingRules - Demonstracao de Regras');
    Writeln('========================================');
    Writeln;

    MemoryRepository := TInMemoryCustomerRepository.Create;

    // Mantem o objeto vivo atraves da interface.
    CustomerRepository := MemoryRepository;

    // Configuracao dos clientes para demonstracao.
    MemoryRepository.AddCustomer(1, True, False);
    MemoryRepository.AddCustomer(2, False, False);
    MemoryRepository.AddCustomer(3, True, True);

    // Exemplos de aplicacao das regras.
    DemonstrateReservation(CustomerRepository, 1, 3);
    DemonstrateReservation(CustomerRepository, 1, 6);
    DemonstrateReservation(CustomerRepository, 2, 2);
    DemonstrateReservation(CustomerRepository, 3, 2);
    DemonstrateReservation(CustomerRepository, 99, 2);

    Writeln;
    Writeln('Pressione ENTER para sair...');
    Readln;

  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      ExitCode := 1;
      Readln;
    end;
  end;
end.

