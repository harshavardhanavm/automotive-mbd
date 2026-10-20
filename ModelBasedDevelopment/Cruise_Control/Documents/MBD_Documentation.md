# Automotive Cruise Control — Model-Based Development

## 1. Project Overview

This project demonstrates an automotive cruise-control function developed using a Model-Based Development (MBD) workflow with MATLAB/Simulink.

The project covers:
- Requirement definition and traceability
- Simulink-based controller and plant modeling
- Discrete-time control with a 10 ms execution period
- Model-in-the-Loop (MIL) verification
- Automated test execution
- C code generation using Simulink Coder
- Software-in-the-Loop (SIL) verification
- Regression testing

## 2. Development Environment

| Item | Configuration |
|---|---|
| Model | `CruiseControl_V1.slx` |
| MATLAB | R2021b |
| Code Generation | Simulink Coder |
| Initial target | `grt.tlc` |
| Controller sample time | 10 ms |
| Control frequency | 100 Hz |
| Verification | MIL and SIL|

## 3. System Objective

The cruise-control system regulates vehicle speed toward a requested target speed. The controller receives vehicle speed and target speed and generates throttle and brake commands.

```text
Target Speed
     |
     v
Speed Error
     |
     v
Discrete PI Controller
     |
     v
Command Limitation
     |
   +---+---+
   |       |
   v       v
Throttle Brake
   |       |
   +---+---+
       |
       v
   Vehicle Plant
       |
       v
 Vehicle Speed
       |
       +---- Feedback
```

## 4. Requirements

| Requirement ID | Description | Acceptance Criteria | Test |
|---|---|---|---|
| CC-REQ-001 | Vehicle shall track the requested target speed under nominal road conditions. | Maximum steady-state speed error < 0.5 m/s | TC-001 |
| CC-REQ-002 | Throttle command shall remain within its valid operating range. | Throttle shall remain between 0 and 1 | TC-002 |
| CC-REQ-003 | Vehicle shall maintain requested speed while driving uphill. | Maximum steady-state speed error < 0.5 m/s at +5° | TC-003 |
| CC-REQ-004 | Vehicle shall maintain requested speed while driving downhill using braking when required. | Maximum steady-state speed error < 0.5 m/s at -5° | TC-004 |
| CC-REQ-005 | Cruise-control algorithm shall execute with a fixed sample time of 10 ms. | Controller sample time = 0.01 s / 100 Hz | TC-005 |

Complete traceability is maintained in `Requirements/CruiseControl_Requirements_Traceability.xlsx`.

## 5. MBD Workflow

```text
Requirements
     |
     v
Simulink Model
     |
     v
MIL Verification
     |
     v
Discrete 10 ms Controller
     |
     v
C Code Generation
     |
     v
SIL Verification
     |
     v
Regression Report
```

## 6. Controller Design

The controller operates at:

```text
Ts = 0.001 s
Frequency = 100 Hz
```

The controller generates a signed control demand that is limited and separated into throttle and brake commands. Output commands are constrained to valid operating ranges.

## 7. Test Cases

### TC-001 — Nominal Cruise Control

Configuration:
```text
Initial speed : 0 m/s
Target speed  : 20 m/s
Road grade    : 0°
Simulation    : 30 s
```

Acceptance: steady-state maximum speed error < 0.5 m/s.

**Result: PASS**

### TC-002 — Throttle Limitation

Configuration:
```text
Target speed : 30 m/s
Road grade   : 0°
```

Acceptance:
```text
0 <= Throttle <= 1
```

**Result: PASS**

### TC-003 — Uphill Compensation

Configuration:
```text
Initial speed : 20 m/s
Target speed  : 20 m/s
Road grade    : +5°
Simulation    : 30 s
```

Acceptance: steady-state maximum speed error < 0.5 m/s.

**Result: PASS**

### TC-004 — Downhill Compensation

Configuration:
```text
Initial speed : 20 m/s
Target speed  : 20 m/s
Road grade    : -5°
Simulation    : 30 s
```

Acceptance: steady-state maximum speed error < 0.5 m/s. Brake command is activated when required.

**Result: PASS**

### TC-005 — Control Task Timing

Acceptance:
```text
Sample time = 0.01 s
Frequency   = 100 Hz
```

Verification method: model inspection / automated check.

**Result: PASS**

## 8. Automated Test Framework

The MATLAB test framework:
1. Loads the model.
2. Loads model parameters.
3. Applies test-case inputs.
4. Runs the simulation.
5. Reads logged signals.
6. Calculates verification metrics.
7. Applies requirement-specific acceptance criteria.
8. Produces PASS/FAIL results.
9. Generates a regression summary.

Requirement-specific acceptance criteria are intentional. For example, TC-002 verifies throttle limitation and therefore does not fail solely because its speed-tracking error exceeds the speed-tracking threshold.

## 9. Verification Metrics

The framework currently evaluates:
- Final vehicle speed
- Final speed error
- Steady-state maximum speed error over the last 5 seconds
- Maximum/minimum throttle
- Maximum/minimum brake
- Road grade
- PASS/FAIL status

## 10. MIL Verification

The functional tests passed:

```text
TC-001  PASS
TC-002  PASS
TC-003  PASS
TC-004  PASS
```

The timing requirement TC-005 also passed.

**MIL status: 5 requirements passed, 0 failed.**

## 11. Discrete-Time Implementation

The controller was changed to a discrete 10 ms control task:

```text
Sample Time = 0.01 s
Frequency   = 100 Hz
```

The existing regression suite was rerun after this implementation change and remained passing.

## 12. C Code Generation

C code was generated from `CruiseControl_V1` using Simulink Coder.

Configuration:
```text
System target file: grt.tlc
MATLAB/Simulink: R2021b
```

Generated artifacts include the model C source and associated header/type files. Generated code is treated as an implementation artifact of the Simulink model and is verified through SIL rather than manually rewritten.

## 13. Software-in-the-Loop Verification

The generated controller implementation was executed in SIL while using the Simulink vehicle plant.

```text
          MIL                         SIL
           |                           |
    Simulink Controller         Generated C Code
           |                           |
           +------------+--------------+
                        |
                  Same Test Case
                        |
                        v
                 Signal Comparison
                        |
                        v
                     PASS/FAIL
```

## 14. Current Project Status

| Area | Status |
|---|---|
| Requirements | Complete |
| Requirement traceability | Complete |
| Simulink model | Complete |
| Discrete 10 ms controller | Complete |
| MIL functional testing | PASS |
| Automated regression | PASS |
| C code generation | Complete |
| SIL setup | Complete |

## 15. Conclusion

This project demonstrates an end-to-end Model-Based Development workflow for an automotive cruise-control function.

The implementation has been verified at the model level, converted to C code, and verified at the generated-code level using SIL.

The key workflow is:

```text
Build the model
      |
Define requirements
      |
Verify the model
      |
Generate implementation
      |
Verify the implementation
      |
Maintain traceability
      |
Run regression tests
```

