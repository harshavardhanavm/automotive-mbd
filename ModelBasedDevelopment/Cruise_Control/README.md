# Cruise Control — Model-Based Development

## Overview

A MATLAB/Simulink-based automotive Model-Based Development (MBD) portfolio project demonstrating a requirement-driven development, implementation and verification workflow for an automotive cruise control system.

The project implements a discrete-time PI cruise control controller, vehicle longitudinal dynamics, operating-mode management, sensor fault detection and automated verification.

It demonstrates the workflow from requirements definition and traceability through MIL testing, Embedded C code generation and SIL verification.

## Development Workflow

```text
Requirements Definition
          |
          v
Requirements Traceability
          |
          v
Simulink Model Development
          |
          v
Functional MIL Testing
          |
          v
Performance MIL Testing
          |
          v
Automated Regression Testing
          |
          v
Embedded C Code Generation (ERT)
          |
          v
Software-in-the-Loop (SIL) Testing
          |
          v
MIL-SIL Performance Comparison
          |
          v
Verification Documentation
```

## System Features

- Discrete PI controller with anti-windup.
- Vehicle longitudinal dynamics modelling.
- Speed reference capture using SET command.
- Speed reference retention and RESUME functionality.
- CANCEL and brake override functionality.
- Cruise control operating modes:
  - OFF
  - STANDBY
  - ACTIVE
- Sensor fault detection:
  - Stuck sensor detection.
  - Implausible sensor value detection.
- Throttle command limitation.
- Road-grade disturbance handling.
- Discrete controller implementation with a 0.01-second sample time.

The operating-mode management logic is implemented using MATLAB Function blocks within Simulink.

## Test Scenarios

### Functional Verification

Nine functional test cases verify:

- Cruise control OFF behavior.
- Standby operation.
- SET, CANCEL and RESUME functionality.
- Brake override.
- Stuck sensor fault detection.
- Healthy sensor operation.
- RESUME without a previous SET command.
- Cruise control switch OFF behavior.
- Implausible sensor fault detection.

**Functional MIL Test Results: 9/9 Passed (100%)**

### Performance Verification

Five performance test cases evaluate:

| Test ID | Scenario | Operating Condition |
|---|---|---|
| TC-001 | Baseline speed tracking | 20 m/s |
| TC-002 | Uphill disturbance | +3° road grade |
| TC-003 | Downhill disturbance | -3° road grade |
| TC-004 | Lower-speed regulation | 15 m/s, +2° grade |
| TC-005 | Higher-speed regulation | 25 m/s, +2° grade |

Performance metrics include:

- Final vehicle speed.
- Reference speed and final tracking error.
- Maximum steady-state error.
- Maximum overshoot.
- Maximum and minimum throttle.
- Recovery time.
- Final operating mode.
- Cruise enable status.
- Sensor fault status.

**Performance MIL Test Results: 5/5 Passed (100%)**

## Code Generation and SIL Verification

Embedded C code generation was performed using Embedded Coder with the ERT system target.

The generated code was executed using Software-in-the-Loop (SIL) simulation.

| Verification Activity | Result |
|---|---|
| GRT code generation | Completed |
| ERT code generation | Completed |
| SIL execution | Completed without errors |
| SIL performance tests | 5/5 Passed |
| MIL performance tests | 5/5 Passed |
| MIL-SIL comparison | Completed |

The five performance scenarios passed in both MIL and SIL.

The displayed performance metrics were closely matched, with small numerical differences between execution modes.

Detailed results are documented in `Documents/MIL_SIL_Comparison_Report.md`.

## Requirements Traceability

The project includes a requirements traceability workbook mapping system requirements to implementation and verification activities.

Six requirements were verified, covering:

- Nominal speed tracking.
- Throttle limitations.
- Uphill disturbance handling.
- Downhill disturbance handling.
- Controller sample time.
- Speed regulation at lower and higher operating speeds.

See:

`Requirements/CruiseControl_Requirements_Traceability.xlsx`

## Folder Contents

```text
Cruise_Control/
|
+-- Model/
|   +-- CruiseControl_V1.slx
|
+-- Parameters/
|   +-- CC_init.m
|
+-- Requirements/
|   +-- CruiseControl_Requirements_Traceability.xlsx
|
|
+-- Scripts/
|   +-- Test execution and regression scripts
|
+-- Documents/
|   +-- MBD_Documentation.md
|   +-- Performance_Test_Report.md
|   +-- MIL_SIL_Comparison_Report.md
|
+-- Results/
    +-- Test plots and verification results
```

