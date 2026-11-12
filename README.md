# Automotive Model-Based Development & Simulation Portfolio

A hands-on automotive engineering portfolio focused on **Model-Based Development (MBD), MATLAB/Simulink, control systems, AUTOSAR concepts and model verification**.

This repository contains practical automotive engineering projects demonstrating system modelling, controller development, simulation, requirements traceability and automated testing.

The projects are developed as portfolio examples to demonstrate engineering concepts and workflows. They are not production-certified automotive software.

---

## Projects

| Project | Technologies | Key Engineering Demonstrations | Status |
|---|---|---|---|
| [Cruise Control System](ModelBasedDevelopment/Cruise_Control/) | MATLAB, Simulink | Longitudinal vehicle dynamics, discrete PI controller, mode management, sensor fault detection, automated MIL testing | 9/9 MIL tests passed |
| [AUTOSAR Brake Controller](ModelBasedDevelopment/Autosar_Brakecontroller/) | MATLAB, Simulink, AUTOSAR concepts | Model-based controller development, data dictionary, fixed-step simulation and automated MIL test reporting | Development project |

---

## 1. Cruise Control – Model-Based Development

**Project:** [ModelBasedDevelopment/Cruise_Control](ModelBasedDevelopment/Cruise_Control/)

A closed-loop automotive Cruise Control System developed using MATLAB and Simulink.

### Key Features

- Longitudinal vehicle dynamics modelling.
- Discrete-time PI controller for vehicle speed regulation.
- Cruise Control mode management using a MATLAB Function block.
- SET, CANCEL and RESUME functionality.
- Brake override handling.
- Vehicle speed sensor modelling.
- Stuck sensor fault detection and fault injection.
- Automated Model-in-the-Loop (MIL) test execution.
- MATLAB-based test automation and signal logging.

### Cruise Control Operating Modes

| Mode | Description |
|---|---|
| OFF (0) | Cruise Control disabled |
| STANDBY (1) | Cruise Control enabled but not actively regulating speed |
| ACTIVE (2) | Cruise Control actively regulates vehicle speed |

### Controller Details

The project uses a discrete-time PI controller with:

- Proportional and integral control.
- Output saturation.
- Anti-windup implementation.
- Controller sample time of 0.01 s (100 Hz).

The target speed is captured from the measured vehicle speed when the SET command is activated. The stored reference is retained during CANCEL and used again during RESUME.

### MIL Verification Results

An automated MIL test framework was developed to execute functional and fault-handling scenarios.

| Test ID | Scenario | Result |
|---|---|---|
| CC-001 | Cruise Control OFF | PASS |
| CC-002 | Cruise Control STANDBY | PASS |
| CC-003 | SET, CANCEL and RESUME | PASS |
| CC-004 | Brake Override | PASS |
| CC-005 | Stuck Sensor Fault | PASS |
| CC-006 | Healthy Sensor | PASS |
| CC-007 | RESUME Without SET | PASS |
| CC-008 | Cruise Control OFF While ACTIVE | PASS |
| CC-009 | Invalid Sensor Value | PASS |

**Current MIL test execution: 9/9 passed (100%).**

Signal-level verification was also performed for:
- SET/CANCEL/RESUME operation.
- Stuck sensor fault handling.
- Invalid sensor value handling.

### Cruise Control Project Contents

- [Model and implementation](ModelBasedDevelopment/Cruise_Control/Model/)
- [Parameters](ModelBasedDevelopment/Cruise_Control/Parameters/)
- [Requirements](ModelBasedDevelopment/Cruise_Control/Requirements/)
- [Test Cases](ModelBasedDevelopment/Cruise_Control/TestCases/)
- [Automation Scripts](ModelBasedDevelopment/Cruise_Control/Scripts/)
- [Documentation](ModelBasedDevelopment/Cruise_Control/Documents/)

For architecture, implementation details and execution instructions, refer to the [Cruise Control Project README](ModelBasedDevelopment/Cruise_Control/README.md).

---

## 2. AUTOSAR-Oriented Brake Controller

**Project:** [ModelBasedDevelopment/Autosar_Brakecontroller](ModelBasedDevelopment/Autosar_Brakecontroller/)

A separate automotive controller development project focused on MATLAB/Simulink modelling and AUTOSAR-oriented engineering concepts.

### Engineering Focus

- Model-Based Development using Simulink.
- Automotive controller architecture.
- Data dictionary concepts.
- Fixed-step simulation.
- Automated MIL test reporting.

Refer to the project folder for its model, parameters and implementation scripts.

---

## Repository Structure

```text
automotive-mbd/
│
├── README.md
│
└── ModelBasedDevelopment/
    │
    ├── Cruise_Control/
    │   ├── Model/
    │   ├── Parameters/
    │   ├── Requirements/
    │   ├── Scripts/
    │   ├── Documents/
    │   ├── results/
    │   └── README.md
    │
    └── Autosar_Brakecontroller/
        ├── Model/
        ├── Parameters/
        └── Scripts/
```

Directory names are shown as the intended project organisation; refer to the individual folders for their current contents.

---

## Engineering Workflow

The projects follow a practical Model-Based Development workflow:

```text
       Requirements
             |
             v
     System Architecture
             |
             v
    Simulink Model Development
             |
             v
     Controller Implementation
             |
             v
       MIL Simulation
             |
             v
    Automated Test Execution
             |
             v
     Signal-Level Verification
             |
             v
       Results & Reporting
             |
             v
       SIL Verification
         (Planned)
```

The workflow is progressively extended as new verification activities are implemented.

---

## Tools & Technologies

| Tool / Technology | Application |
|---|---|
| MATLAB | Engineering calculations and automation scripts |
| Simulink | System and controller modelling |
| MATLAB Function | Control and mode-management logic |
| Discrete PI Controller | Closed-loop speed regulation |
| Model-in-the-Loop (MIL) | Model-level functional verification |
| Git & GitHub | Version control and project documentation |
| AUTOSAR Concepts | Automotive software architecture learning |

**Development environment:** MATLAB/Simulink R2021b for the Cruise Control project.

Some project features may depend on installed MATLAB products and licences.

---

## Verification Scope

The current Cruise Control project includes:
- Functional mode-transition testing.
- Driver command sequence testing.
- Brake override testing.
- Sensor fault injection and detection.
- Automated MIL regression testing.
- Signal-level result verification.

### Planned Improvements

- Expand requirements-to-test traceability.
- Add further boundary-value and robustness scenarios.
- Improve automated test reporting.
- Perform Software-in-the-Loop (SIL) verification.
- Explore generated-code verification and additional automotive development workflows.

SIL and production-target validation are not claimed as completed activities.

---

## Repository Purpose

This repository serves as a practical engineering portfolio demonstrating my learning and implementation in automotive Model-Based Development.

The focus is on developing a clear understanding of:

- Automotive control systems.
- MATLAB/Simulink modelling.
- Discrete-time controller implementation.
- Requirements-based development.
- Fault detection and handling.
- Model-level verification.
- Test automation and engineering documentation.
- AUTOSAR-oriented development concepts.

---

## License

No open-source licence is currently specified. Please contact the repository owner before reusing or redistributing project contents.
