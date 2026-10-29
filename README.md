# BookingRules

**A Delphi 10.4 project demonstrating SOLID principles, dependency injection, and automated testing with DUnitX.**

BookingRules is a small, focused application that implements reservation confirmation rules. Its purpose is to demonstrate maintainable object-oriented design, separation of concerns, and automated testing in Delphi.

## Features

- Reservation confirmation based on customer status and participant count.
- Validation of active and blocked customers.
- Detailed decision result explaining why a reservation was refused.
- Dependency injection through the `ICustomerRepository` interface.
- Atomic customer-status lookup through a single repository call.
- In-memory repository implementation.
- Unit tests using Fake, Spy, and failure-simulating repositories.
- Integration tests combining business rules with an in-memory repository.
- Console application demonstrating valid and invalid reservations.

## Business Rules

A reservation can be confirmed only when:

1. The participant count is between 1 and 5.
2. The customer is active.
3. The customer is not blocked.

Invalid conditions prevent confirmation. Repository exceptions are propagated rather than silently ignored.

`TReservation.Evaluate` returns a `TReservationDecision` describing the
outcome (`rdConfirmed`, invalid participant count, repository unavailable,
customer not found, inactive customer, or blocked customer). The existing
`CanConfirm` method remains available as a Boolean convenience method.

### Reservation Decisions

| Decision | Meaning |
|---|---|
| `rdConfirmed` | All reservation rules were satisfied. |
| `rdInvalidParticipantCount` | The participant count is outside the accepted range of 1 to 5. |
| `rdRepositoryUnavailable` | No customer repository was supplied to the reservation. |
| `rdCustomerNotFound` | The repository could not find the requested customer. |
| `rdCustomerInactive` | The customer exists but is inactive. |
| `rdCustomerBlocked` | The customer is active but blocked from confirming reservations. |

### Usage Example

```pascal
var
  Repository: ICustomerRepository;
  MemoryRepository: TInMemoryCustomerRepository;
  Reservation: TReservation;
  Decision: TReservationDecision;
begin
  MemoryRepository := TInMemoryCustomerRepository.Create;
  Repository := MemoryRepository;
  MemoryRepository.AddCustomer(25, True, False);

  Reservation := TReservation.Create(25, Repository);
  try
    Decision := Reservation.Evaluate(3);

    case Decision of
      rdConfirmed:
        Writeln('Reservation confirmed');
      rdInvalidParticipantCount:
        Writeln('Invalid participant count');
      rdRepositoryUnavailable:
        Writeln('Customer repository unavailable');
      rdCustomerNotFound:
        Writeln('Customer not found');
      rdCustomerInactive:
        Writeln('Customer is inactive');
      rdCustomerBlocked:
        Writeln('Customer is blocked');
    end;
  finally
    Reservation.Free;
  end;
end;
```

For callers that need only a Boolean answer, use
`Reservation.CanConfirm(3)`.

## Architecture

The project separates business logic from data access through an interface-based design.

```text
BookingRules/
├── src/
│   ├── BookingRules.CustomerRepository.pas
│   ├── BookingRules.InMemoryCustomerRepository.pas
│   └── BookingRules.Reservation.pas
├── tests/
│   ├── unit/
│   │   ├── BookingRules.ReservationTests.pas
│   │   ├── BookingRules.FakeCustomerRepository.pas
│   │   ├── BookingRules.SpyCustomerRepository.pas
│   │   └── BookingRules.FailingCustomerRepository.pas
│   └── integration/
│       └── BookingRules.ReservationIntegrationTests.pas
├── BookingRules.dpr
├── BookingRules.Tests.dpr
└── BookingRulesProject.groupproj
```

### Design Principles

- **Single Responsibility Principle (SRP):** Reservation rules and customer data access are handled by separate classes.
- **Dependency Inversion Principle (DIP):** `TReservation` depends on `ICustomerRepository` rather than a concrete repository.
- **Dependency Injection:** Repository dependencies are supplied through the constructor.
- **Consistent reads:** Customer existence, active state, and blocked state are obtained in one repository operation.
- **Testability:** Business rules can be tested without external databases or services.

## Automated Testing

The project uses **DUnitX** for unit and integration tests.

The test suite covers valid and invalid participant counts, customer eligibility, repository interactions, short-circuit behavior, and exception propagation.

**Last verified execution:** October 29, 2026, using Delphi 10.4.

| Result | Count |
|---|---:|
| Tests found | 19 |
| Passed | 19 |
| Failed | 0 |
| Errors | 0 |
| Leaks | 0 |

The project and test suite were also verified in both supported Win64 build
configurations:

| Platform | Configuration | Build | Tests |
|---|---|---|---|
| Win64 | Debug | Passed | 19 passed |
| Win64 | Release | Passed | 19 passed |

Integration tests use an in-memory repository. No external database is required.

## Requirements

- Embarcadero RAD Studio / Delphi 10.4
- Windows
- DUnitX (included with supported RAD Studio installations)

## Build and Run

1. Clone the repository.
2. Open `BookingRulesProject.groupproj` in RAD Studio.
3. Select the desired Windows target platform.
4. Build `BookingRules.exe` to run the demonstration.
5. Build `BookingRules.Tests.exe` to execute the test suite.

For example, using PowerShell after building the Win64 Debug configuration:

```powershell
.\Win64\Debug\BookingRules.Tests.exe
```

The test runner exits automatically and returns `0` when all tests pass, or `1` when tests fail.

To keep the console open during manual execution:

```powershell
.\Win64\Debug\BookingRules.Tests.exe --pause
```

## Scope

BookingRules is an educational and portfolio demonstration, not a production booking platform. It intentionally focuses on business rules, object-oriented architecture, and automated tests rather than user interfaces, external persistence, or deployment infrastructure.

## Author

**Marcelo Gutierrez**

[GitHub](https://github.com/mgmsystem)
