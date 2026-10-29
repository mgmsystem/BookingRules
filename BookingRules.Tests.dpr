
program BookingRules.Tests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  BookingRules.ReservationTests in 'tests\unit\BookingRules.ReservationTests.pas',
  BookingRules.ReservationIntegrationTests in 'tests\integration\BookingRules.ReservationIntegrationTests.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;

begin
  try
    TDUnitX.CheckCommandLine;

    Runner := TDUnitX.CreateRunner;

    // Exibe os resultados detalhados dos testes
    Runner.AddLogger(TDUnitXConsoleLogger.Create(True));

    // Executa todos os testes registrados
    Results := Runner.Execute;

    // Retorna um codigo de saida para automacao/CI
    if Results.AllPassed then
      ExitCode := 0
    else
      ExitCode := 1;

  except
    on E: Exception do
    begin
      Writeln('Erro ao executar os testes: ', E.Message);
      ExitCode := 1;
    end;
  end;

  // Pausa opcional para execucao manual
  if FindCmdLineSwitch('pause', True) then
  begin
    Writeln;
    Writeln('Pressione ENTER para sair...');
    Readln;
  end;
end.

