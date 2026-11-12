# Automotive Cruise Control – Model-Based Development

## 1. Project Overview

This project demonstrates the development and verification of an automotive Cruise Control System using MATLAB and Simulink.

The project follows a Model-Based Development (MBD) approach, covering system modelling, controller design, driver command management, sensor fault detection and automated Model-in-the-Loop (MIL) testing.

The objective is to maintain a desired vehicle speed using closed-loop control while ensuring safe behaviour during driver overrides and sensor faults.

### Key Features

- Longitudinal vehicle dynamics modelling.
- Discrete-time PI speed controller.
- Cruise Control mode management.
- SET, CANCEL, RESUME and brake override functionality.
- Vehicle speed sensor modelling.
- Stuck sensor fault detection and fault injection.
- Automated MIL test execution using MATLAB scripts.
- Test result logging and signal-level verification.

## 2. Development Environment

| Item | Configuration |
|---|---|
| MATLAB | R2021b |
| Modelling Tool | Simulink |
| Main Model | `CruiseControl_V1.slx` |
| Controller | Discrete PI Controller |
| Controller Sample Time | 0.01 s |
| Controller Frequency | 100 Hz |
| Verification | Model-in-the-Loop (MIL) |

## 3. System Architecture

The system consists of the following major components:

1. Driver command inputs
2. Cruise Control mode manager
3. Vehicle speed sensor and fault detection
4. Discrete PI controller
5. Throttle and brake command generation
6. Longitudinal vehicle dynamics model

### Control Flow

```text
 Driver Commands
       |
       v
 CC Mode Manager <----- Vehicle Speed
       |                       ^
       |                       |
       v                       |
 Speed Reference               |
       |                       |
       v                       |
 Discrete PI Controller        |
       |                       |
       v                       |
 Throttle / Brake              |
       |                       |
       v                       |
 Vehicle Dynamics Model -------+
       |
       v
 Vehicle Speed
```

The mode manager determines whether cruise control is OFF, in STANDBY or ACTIVE.

When SET is pressed, the current measured vehicle speed is stored as the cruise-control reference. CANCEL and brake override deactivate cruise control while retaining the stored reference for RESUME.

## 4. Vehicle Dynamics Model

The longitudinal vehicle model represents the relationship between driving force, braking force and vehicle speed.

The model considers:

- Vehicle mass
- Engine/traction force
- Braking force
- Aerodynamic drag
- Rolling resistance
- Road grade

Vehicle acceleration is calculated from the net longitudinal force:

\[
a = \frac{F_{\text{net}}}{m}
\]

Vehicle speed is obtained by integrating acceleration over time.

The plant provides vehicle speed feedback to the controller.

## 5. Controller Design

A discrete-time PI controller is used for vehicle speed regulation.

The speed error is:

\[
e(k)=V_{\text{ref}}(k)-V_{\text{vehicle}}(k)
\]

The PI controller generates a signed control demand based on proportional and integral actions.

The control output is limited to the valid range:

\[
-1 \leq u(k) \leq 1
\]

The output is separated into throttle and brake commands:

- Positive control demand generates throttle.
- Negative control demand generates braking.
- Zero control demand produces neither command.

Anti-windup is implemented to reduce integral accumulation during actuator saturation.

The controller uses a 10 ms sample time (100 Hz).

## 6. Cruise Control Mode Management

The `CC_Mode_Manager` MATLAB Function block manages the cruise-control operating states.

### Operating Modes

| Mode | State | Description |
|---|---|---|
| 0 | OFF | Cruise control disabled |
| 1 | STANDBY | Cruise control enabled but not regulating speed |
| 2 | ACTIVE | Cruise control actively regulates vehicle speed |

### Mode Manager Inputs

| Input | Description |
|---|---|
| `CC_Switch` | Main cruise-control enable switch |
| `SET_Command` | Captures current vehicle speed |
| `CANCEL_Command` | Cancels active cruise control |
| `RESUME_Command` | Resumes the previously stored speed |
| `Brake_Switch` | Brake override input |
| `Vehicle_Speed` | Measured vehicle speed |
| `Stuck_Sensor_Fault` | Indicates a detected stuck sensor fault |

### Mode Manager Outputs

| Output | Description |
|---|---|
| `CC_Enable` | Enables or disables the PI controller |
| `Speed_Reference` | Stored cruise-control target speed |
| `Mode` | Current operating mode |

### Functional Behaviour

**SET**
- Captures the current vehicle speed.
- Stores it as the cruise-control target.
- Transitions to ACTIVE.

**CANCEL**
- Disables active cruise control.
- Transitions to STANDBY.
- Retains the previously stored speed.

**RESUME**
- Reactivates cruise control using the previously stored speed.
- Does not activate if no valid speed has been stored.

**Brake Override**
- Deactivates active cruise control.
- Transitions to STANDBY.

**Main Cruise Control Switch OFF**
- Disables cruise control.
- Transitions to OFF.
- Clears the stored speed.

## 7. Sensor Fault Detection

A sensor monitoring function checks vehicle speed information for implausible values and detects a stuck sensor condition.

The implemented checks include:

- Invalid or negative vehicle speed.
- Vehicle speed outside the configured project plausibility range.
- Stuck sensor fault detection using the sensor diagnostic logic.

A stuck sensor fault is introduced through a fault-injection mechanism for verification.

When a sensor fault is detected:

1. The fault is indicated.
2. Cruise control is deactivated.
3. The mode manager transitions to STANDBY.
4. The controller is prevented from continuing normal cruise-speed regulation.

The sensor plausibility limits are project-specific simulation assumptions, not production vehicle calibration values.

## 8. Requirements and Traceability

The project maintains requirement documentation and traceability under:

`Requirements/`

The requirements documentation covers the speed-control function, actuator limitations, road-grade compensation and controller execution timing.

The requirement traceability workbook is:

`Requirements/CruiseControl_Requirements_Traceability.xlsx`

Functional mode-management and sensor-fault behaviour are additionally verified through the automated test suite described below.

## 9. Automated MIL Test Framework

An automated MATLAB test framework was developed to execute multiple Cruise Control test scenarios.

The framework:

1. Loads the Simulink model.
2. Applies the required simulation parameters.
3. Generates driver command profiles.
4. Runs the simulation.
5. Retrieves logged signals.
6. Evaluates expected system behaviour.
7. Determines PASS/FAIL status.
8. Produces a consolidated test summary.

### Test Cases

| Test ID | Test Description | Expected Behaviour | Result |
|---|---|---|---|
| CC-001 | Cruise OFF | Mode OFF, controller disabled | PASS |
| CC-002 | Cruise Standby | Mode STANDBY | PASS |
| CC-003 | SET, CANCEL and RESUME | Correct mode transitions and speed retention | PASS |
| CC-004 | Brake Override | Cruise control deactivated | PASS |
| CC-005 | Stuck Sensor Fault | Fault detected and cruise control deactivated | PASS |
| CC-006 | Healthy Sensor | No false sensor fault | PASS |
| CC-007 | RESUME Without SET | Remains in STANDBY | PASS |
| CC-008 | Cruise OFF While ACTIVE | Transitions to OFF and clears stored speed | PASS |
| CC-009 | Invalid Sensor Value | Fault detected and cruise control deactivated | PASS |

### MIL Test Summary

| Metric | Result |
|---|---:|
| Total Test Cases | 9 |
| Passed | 9 |
| Failed | 0 |
| Pass Percentage | 100% |

**MIL functional test status: 9/9 PASSED.**

These results represent the current automated test execution for the implemented functional scenarios.

## 10. Signal-Level Verification

The following signals are logged and analysed during simulation:

- `VehicleSpeed`
- `SpeedReference`
- `Mode`
- `CCEnable`
- `SensorFault`

Signal-level verification was performed for the following scenarios:

### CC-003 – SET, CANCEL and RESUME

Verified:
- Speed reference capture during SET.
- Stored speed retention after CANCEL.
- Speed reference reuse during RESUME.
- Correct mode sequence: STANDBY → ACTIVE → STANDBY → ACTIVE.
- Correct controller enable and disable behaviour.

### CC-005 – Stuck Sensor Fault

Verified:
- Stuck sensor fault detection.
- Cruise control deactivation.
- Transition to STANDBY.
- No continued active speed regulation.

### CC-009 – Invalid Sensor Value

Verified:
- Invalid sensor value detection.
- Fault indication.
- Cruise control deactivation.
- Transition to STANDBY.

Signal plots are maintained in the `results/` directory.

## 11. Project Structure

```text
Cruise_Control/
│
├── CruiseControl_V1.slx
│
├── Documents/
│   └── MBD_Documentation.md
│
├── Requirements/
│   └── CruiseControl_Requirements_Traceability.xlsx
│
├── Scripts/
│   ├── CC_init.m
│   ├── CC_TestCases.m
│   ├── run_CruiseControl_Test.m
│   └── run_All_CruiseControl_Tests.m
│
├── results/
│   ├── CC-003_SET_CANCEL_RESUME.png
│   ├── CC-005_Stuck_Sensor_Fault.png
│   └── CC-009_Invalid_Sensor.png
│
├── README.md
└── MIL_Test_Report.md
```

The structure above describes the intended organisation. File names and directory names should match the actual repository contents.

## 12. How to Run the Project

### Prerequisites

- MATLAB R2021b.
- Simulink.
- Required Simulink features used by the model.

### Execution Steps

1. Download or clone the repository.
2. Open MATLAB.
3. Navigate to the `Cruise_Control` project directory.
4. Open `CruiseControl_V1.slx`.
5. Run the initialization script:

```matlab
CC_init
```

6. Run the model to inspect the system behaviour.

### Run Automated MIL Tests

Execute:

```matlab
[Results, Summary] = run_All_CruiseControl_Tests();
```

The framework runs the configured test cases and returns the detailed results and consolidated summary.

## 13. Verification Scope and Future Work

### Completed

- Longitudinal vehicle dynamics modelling.
- Discrete-time PI controller implementation.
- Cruise-control mode management.
- SET/CANCEL/RESUME functionality.
- Brake override.
- Sensor fault detection and fault injection.
- Automated MIL test framework.
- Nine passing functional MIL test cases.
- Signal-level verification for key functional and fault scenarios.

### Planned Improvements

- Extend requirement-to-test traceability for all new functional scenarios.
- Add boundary-value and robustness testing.
- Improve automated test reporting and evidence generation.
- Perform generated-code verification through SIL.
- Investigate code-generation and SIL workflow availability in the development environment.
- Perform regression testing after future model changes.

SIL verification and production-target validation should only be marked complete after the corresponding activities have been executed and their results recorded.

## 14. Conclusion

This project demonstrates a practical automotive Model-Based Development workflow using MATLAB and Simulink.

It covers vehicle dynamics, discrete-time speed control, cruise-control mode management, driver command handling, sensor fault detection and automated MIL verification.

The automated functional test suite currently achieves **9 out of 9 passing test cases**.

The project provides practical experience in:

- MATLAB/Simulink modelling.
- Discrete PI controller design.
- Automotive control logic.
- Fault detection and handling.
- Model-in-the-Loop testing.
- MATLAB-based test automation.
- Signal-level verification.
- Engineering documentation and test reporting.

**Project focus: Automotive Model-Based Development | MATLAB/Simulink | MIL Testing | Control Systems**
