
# Model-Based Development Documentation
## Automotive Cruise Control System
---

# 1. Project Overview

This project demonstrates the development and verification of a simplified automotive cruise control system using MATLAB and Simulink.

The objective is to maintain a driver-selected vehicle speed by automatically controlling the vehicle's throttle demand while considering vehicle dynamics, braking, driver commands, and sensor fault conditions.

The project follows a Model-Based Development workflow covering:

- System requirements and traceability.
- Simulink model development.
- Vehicle longitudinal dynamics modelling.
- Discrete PI controller implementation.
- Cruise control mode management.
- SET, CANCEL, RESUME, and brake override functionality.
- Vehicle speed sensor fault detection.
- Automated MIL functional testing.
- Test result collection and documentation.

The model is intended for learning and portfolio demonstration. It is not a production-ready automotive cruise control implementation.

# 2. Development Environment

| Item | Configuration |
|---|---|
| MATLAB | R2021b |
| Simulink | R2021b |
| Development approach | Model-Based Development |
| Controller | Discrete PI Controller |
| Controller sample time | 0.01 seconds |
| Discretization method | Forward Euler |
| Vehicle plant | Continuous-time model |
| Verification | Model-in-the-Loop |
| Mode management | MATLAB Function block |
| Test execution | MATLAB scripts |

## 2.1 Sample Time Configuration

The PI controller is implemented as a discrete-time controller with a fixed sample time:


T_s = 0.01 seconds


The vehicle plant remains continuous-time, while the controller executes at discrete intervals.

A fixed-step controller does not automatically make the entire model discrete. The overall model contains both discrete and continuous components.

# 3. System Architecture

The Cruise Control system consists of the following major subsystems:

1. Driver Input and Command Interface
2. Cruise Control Mode Manager
3. Vehicle Speed Reference Management
4. Speed Error Calculation
5. Discrete PI Controller
6. Throttle and Brake Control
7. Vehicle Longitudinal Dynamics
8. Vehicle Speed Feedback
9. Sensor Fault Detection

## 3.1 System-Level Signal Flow

The main control flow is:

```text
Driver Commands
      |
      v
Cruise Control Mode Manager
      |
      +----> Cruise Control Enable
      |
      +----> Speed Reference
                    |
                    v
              Speed Error
                    |
                    v
             Discrete PI Controller
                    |
                    v
             Throttle / Brake Logic
                    |
                    v
          Vehicle Longitudinal Model
                    |
                    v
               Vehicle Speed
                    |
                    +------ Feedback
                    |
                    +------ Sensor Fault Detection
```

The mode manager determines whether cruise control is OFF, in STANDBY, or ACTIVE.

When cruise control is ACTIVE, the controller compares the reference speed with the measured vehicle speed and calculates the required control effort.

# 4. Cruise Control Mode Management

The cruise control mode manager is implemented using a MATLAB Function block.

It processes driver commands, vehicle speed, and sensor fault status to determine the current operating mode.

## 4.1 Operating Modes

| Mode | Value | Description |
|---|---:|---|
| OFF | 0 | Cruise control is switched OFF |
| STANDBY | 1 | Cruise control is available but not controlling vehicle speed |
| ACTIVE | 2 | Cruise control is actively regulating vehicle speed |

## 4.2 Mode Behaviour

### OFF

- Cruise control main switch is OFF.
- Cruise control output is disabled.
- Stored reference speed is cleared.

### STANDBY

- Cruise control main switch is ON.
- Cruise control is not actively regulating vehicle speed.
- The driver can issue a valid SET or RESUME command when the applicable conditions are satisfied.

### ACTIVE

- A valid SET or RESUME command activates cruise control.
- The controller uses the stored or captured speed reference.
- The PI controller regulates vehicle speed.

## 4.3 Driver Command Behaviour

| Driver Input | Expected Behaviour |
|---|---|
| CC Switch OFF | Disable cruise control and clear stored speed |
| CC Switch ON | Enable cruise control availability |
| SET | Capture current vehicle speed and activate cruise control |
| CANCEL | Disable active cruise control while retaining stored speed |
| RESUME | Reactivate cruise control using the stored speed |
| Brake | Override cruise control and return to STANDBY |

### SET Command

When SET is issued under valid operating conditions:

- The current measured vehicle speed is captured.
- The captured speed is stored as the reference speed.
- Cruise control enters ACTIVE mode.

### CANCEL Command

When CANCEL is issued:

- Cruise control is deactivated.
- The stored reference speed is retained.
- The system returns to STANDBY.

### RESUME Command

When RESUME is issued:

- The previously stored reference speed is used.
- Cruise control can return to ACTIVE mode.

If no valid reference speed has previously been stored, RESUME must not activate cruise control.

### Brake Override

When the brake switch is activated:

- Cruise control is disabled.
- The system returns to STANDBY.
- The driver retains manual control of vehicle speed.

# 5. Vehicle Longitudinal Dynamics Model

The vehicle model represents simplified longitudinal vehicle behaviour.

It calculates vehicle acceleration and speed based on the driving force, braking force, aerodynamic drag, rolling resistance, and road grade.

## 5.1 Forces Acting on the Vehicle

The main forces considered are:

1. Traction force
2. Braking force
3. Aerodynamic drag
4. Rolling resistance
5. Road grade resistance

## 5.1 Vehicle Parameters

The model uses the following configured parameters:

| Parameter | Value | Unit |
|---|---:|---|
| Vehicle mass | 1500 | kg |
| Aerodynamic drag coefficient | 0.3 | - |
| Frontal area | 2.2 | m² |
| Air density | 1.225 | kg/m³ |
| Rolling resistance coefficient | 0.01 | - |
| Gravitational acceleration | 9.81 | m/s² |
| Maximum traction force | 5000 | N |
| Maximum braking force | 8000 | N |
| Initial vehicle speed | 0 | m/s |

These are simulation parameters selected for this project, not vehicle-specific production calibration values.

# 6. Discrete PI Controller

The cruise control speed controller uses a discrete Proportional-Integral controller.

The controller calculates the difference between the desired speed and measured vehicle speed.


# 7. Sensor Fault Detection

Vehicle speed feedback is important for closed-loop cruise control operation.

An incorrect speed measurement can cause the controller to calculate an inappropriate control demand.

For example, if the measured speed is stuck at a low value while the actual vehicle speed increases, the controller may continue requesting additional traction.

The model therefore includes sensor fault detection.

## 7.1 Implemented Fault Scenarios

### Stuck Sensor Fault

The sensor measurement remains constant even though the vehicle speed changes.

### Implausible Sensor Value

The measured speed is checked for an invalid or implausible value.

## 7.2 Fault Response

When a sensor fault is detected:

- The sensor fault status is activated.
- Cruise control is deactivated.
- The system returns to STANDBY.
- Closed-loop cruise control operation is prevented while the fault is active.

The current implementation keeps the sensor fault latched until the simulation is restarted.

The diagnostic thresholds and timing are project-level assumptions and should not be interpreted as validated automotive safety requirements.

# 8. Requirements and Traceability

The project maintains a separate requirements and traceability workbook.

**File:** `Requirements/CruiseControl_Requirements_Traceability.xlsx`

The workbook contains:

- Requirements
- Traceability
- Summary

The requirements cover system operation, controller configuration, driver command behaviour, brake override, and sensor fault handling.

## 8.1 Requirements Traceability

Requirements are mapped to their corresponding verification test cases.

Two test groups are maintained separately:

| Test Group | Purpose |
|---|---|
| TC-001 to TC-005 | performance-oriented test group |
| CC-001 to CC-009 | Cruise control functional MIL test group |

The test groups must not be combined when reporting test execution results.

The requirements workbook is the source of truth for detailed requirement descriptions, acceptance criteria, and requirement-to-test mappings.

# 9. Model-in-the-Loop Testing

Functional verification was performed using automated MATLAB test scripts.

The functional test group contains nine test cases.

## 9.1 Functional Test Results

| Test ID | Test Description | Expected Behaviour | Result |
|---|---|---|---|
| CC-001 | Cruise control OFF | System remains OFF | PASS |
| CC-002 | Cruise control standby | System remains in STANDBY | PASS |
| CC-003 | SET, CANCEL and RESUME | Correct activation, cancellation and resumption | PASS |
| CC-004 | Brake override | Cruise control deactivates and returns to STANDBY | PASS |
| CC-005 | Stuck sensor fault | Fault detected and cruise control deactivated | PASS |
| CC-006 | Healthy sensor | No false sensor fault detected | PASS |
| CC-007 | RESUME without SET | System remains in STANDBY | PASS |
| CC-008 | Main cruise control switch OFF | System deactivates and clears stored speed | PASS |
| CC-009 | Implausible sensor fault | Fault detected and cruise control deactivated | PASS |

## 9.2 Functional Test Summary

| Metric | Result |
|---|---:|
| Total functional test cases | 9 |
| Passed | 9 |
| Failed | 0 |
| Pass percentage | 100% |

These results represent the recorded functional MIL test execution.

They do not establish code-generation correctness, SIL equivalence, or production-level safety compliance.

## 9.3 Test Execution Script

The complete functional test suite can be executed using:

```matlab
[Results, Summary] = run_All_CruiseControl_Tests();
```

The test execution scripts automate:

- Test case configuration
- Model simulation
- Signal collection
- Result evaluation
- Test summary generation

# 10. Verification Evidence

The following signal plots are used as supporting evidence for selected functional test scenarios.

| Evidence File | Test Scenario |
|---|---|
| `CC-003_SET_CANCEL_RESUME.png` | SET, CANCEL and RESUME behaviour |
| `CC-005_Stuck_Sensor_Fault.png` | Stuck sensor fault detection |
| `CC-009_Invalid_Sensor.png` | Implausible sensor fault detection |

Important signals observed during verification include:

- Vehicle Speed
- Speed Reference
- Cruise Control Mode
- Cruise Control Enable
- Sensor Fault Status

Only include evidence files that are actually present in the repository.

# 11. MATLAB Test Automation

The project uses MATLAB scripts to initialize the model, configure test cases, execute simulations, and evaluate results.

| File | Purpose |
|---|---|
| `CC_init.m` | Initializes model parameters and simulation configuration |
| `CC_TestCases.m` | Defines test case configurations |
| `run_CruiseControl_Test.m` | Executes an individual test case |
| `run_All_CruiseControl_Tests.m` | Executes the functional test suite and generates the summary |

## 11.1 Test Execution Workflow

```text
Initialize Parameters
        |
        v
Load Test Case Configuration
        |
        v
Configure Model Inputs
        |
        v
Run Simulink Simulation
        |
        v
Collect Simulation Outputs
        |
        v
Evaluate Expected Behaviour
        |
        v
Generate Test Results
```

# 12. Current Project Status

The following table summarizes the current development and verification status.

| Activity | Status |
|---|---|
| Vehicle longitudinal dynamics model | Implemented |
| Cruise control mode management | Implemented |
| SET command | Implemented and tested |
| CANCEL command | Implemented and tested |
| RESUME command | Implemented and tested |
| Brake override | Implemented and tested |
| Discrete PI controller | Implemented |
| Forward Euler discretization | Implemented |
| Anti-windup | Implemented |
| Sensor stuck fault detection | Implemented and tested |
| Implausible sensor fault detection | Implemented and tested |
| Functional MIL testing | 9/9 passed |
| Requirements traceability | Maintained |
| Original performance test group TC-001 to TC-005 | Requires separate verification and reporting |
| Embedded C code generation | Not yet verified |
| Software-in-the-Loop testing | Not yet verified |

# 13. Limitations and Future Improvements

The current implementation is a simplified cruise control model developed for Model-Based Development learning and portfolio demonstration.

Potential future improvements include:

1. Record quantitative performance metrics such as rise time, settling time, overshoot, and steady-state error where applicable.
2. Add additional boundary and transition test cases.
3. Improve sensor diagnostics using configurable thresholds and diagnostic timing.
4. Investigate fault recovery and reset behaviour.
5. Perform model coverage analysis where supported by the available MATLAB/Simulink license.
6. Generate embedded C code using Simulink Coder or Embedded Coder, if available.
7. Perform Software-in-the-Loop verification after code generation.
8. Compare generated code behaviour against the reference model.

Code generation and SIL verification should be reported as completed only after successful execution and supporting evidence are available.

# 14. Repository Structure

The intended project organization is:

```text
automotive-mbd/
|
+-- README.md
|
+-- ModelBasedDevelopment/
    |
    +-- Cruise_Control/
        |
        +-- README.md
        |
        +-- Documents/
        |   |
        |   +-- MBD_Documentation.md
        |
        +-- Requirements/
        |   |
        |   +-- CruiseControl_Requirements_Traceability.xlsx
        |
        +-- results/
        |   |
        |   +-- CC-003_SET_CANCEL_RESUME.png
        |   +-- CC-005_Stuck_Sensor_Fault.png
        |   +-- CC-009_Invalid_Sensor.png
        |
        +-- Scripts/
		|   |
		|   +--PerformanceTests/
		|   |  |  
		|	|  +--run_All_TC_Tests.m
		|	|  +--run_TC_Test.m
		|   |  +--TC_TestCases.m
		|	|
		|   +--FunctionalTests/
		|   |   |
        |	|	+-- CC_TestCases.m
		|	|	+-- run_All_CruiseControl_Tests.m
		|   |   +-- CC_TestCases.m
        +-- Model/
		|   |
		|	+--CruiseControl_V1.slx
		+--Parameters/
		   | 
		   +--CC_init.m
```

The structure above describes the intended organization. Keep only files and folders that actually exist in the repository.

# 15. Conclusion

This project demonstrates an end-to-end introductory Model-Based Development workflow for a simplified automotive cruise control system.

It covers vehicle dynamics modelling, discrete PI controller implementation, cruise control mode management, driver command handling, sensor fault detection, requirements traceability, and automated Model-in-the-Loop functional verification.

The functional test suite currently records nine passed test cases out of nine.

The project provides a foundation for further work in controller performance verification, model coverage, embedded code generation, and Software-in-the-Loop testing.

---

**Project:** Automotive Cruise Control System  
**Development Methodology:** Model-Based Development  
**Verification Level Completed:** Model-in-the-Loop functional testing  
**Functional MIL Result:** 14/14 Passed
