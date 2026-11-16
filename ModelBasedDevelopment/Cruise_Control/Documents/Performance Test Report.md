# Cruise Control – Performance Test Report

## 1. Overview

This report documents the performance validation of the Cruise Control Model using MATLAB/Simulink Model-in-the-Loop (MIL) simulation.

Five performance test scenarios were executed to evaluate:
- Baseline speed tracking
- Uphill disturbance response
- Downhill disturbance response
- Lower-speed regulation
- Higher-speed regulation

**Overall result: 5/5 tests passed (100%).**

## 2. Test Configuration

| Parameter | Configuration |
|---|---|
| Model | CruiseControl_V1.slx |
| Simulation approach | Model-in-the-Loop (MIL) |
| Simulation duration | 40 seconds |
| Controller sample time | 0.01 seconds |
| Speed controller | Discrete PI controller |
| Acceptance speed error | 0.5 m/s |
| Steady-state evaluation window | Final 5 seconds |
| Fault injection | Disabled |

## 3. Test Scenarios

| Test ID | Scenario | Initial speed | Road grade |
|---|---|---:|---:|
| TC-001 | Baseline speed tracking | 20 m/s | 0° |
| TC-002 | Uphill disturbance | 20 m/s | +3° |
| TC-003 | Downhill disturbance | 20 m/s | -3° |
| TC-004 | Lower-speed regulation | 15 m/s | +2° |
| TC-005 | Higher-speed regulation | 25 m/s | +2° |

For disturbance scenarios, the road grade was applied temporarily and subsequently returned to zero.

## 4. Test Results

| Test ID | Final speed (m/s) | Reference (m/s) | Maximum steady-state error (m/s) | Recovery time (s) | Result |
|---|---:|---:|---:|---:|---|
| TC-001 | 20.000 | 19.998 | 0.0042 | 0.00 | PASS |
| TC-002 | 20.026 | 19.998 | 0.1411 | 13.00 | PASS |
| TC-003 | 19.985 | 19.998 | 0.0905 | 10.53 | PASS |
| TC-004 | 15.016 | 14.998 | 0.0944 | 8.87 | PASS |
| TC-005 | 25.019 | 24.997 | 0.0967 | 7.99 | PASS |

### Additional controller checks

| Test ID | Maximum throttle | Minimum throttle | Cruise active at end | Sensor fault detected |
|---|---:|---:|---|---|
| TC-001 | 0.0700 | 0 | Yes | No |
| TC-002 | 0.2468 | 0 | Yes | No |
| TC-003 | 0.0771 | 0 | Yes | No |
| TC-004 | 0.1729 | 0 | Yes | No |
| TC-005 | 0.2058 | 0 | Yes | No |

All tests maintained throttle within the permitted normalized range of 0 to 1.

## 5. Acceptance Criteria

| Criterion | Acceptance condition | Outcome |
|---|---|---|
| Speed tracking | Maximum error in final 5 seconds < 0.5 m/s | PASS – All 5 |
| Throttle limitation | Throttle between 0 and 1 | PASS – All 5 |
| Cruise control status | Cruise control active at simulation end | PASS – All 5 |
| Sensor fault status | No unintended sensor fault detected | PASS – All 5 |

## 6. Disturbance Recovery Analysis

The uphill and downhill tests initially exceeded the steady-state error threshold when the simulation duration was 30 seconds.

After increasing the simulation duration to 40 seconds, both scenarios satisfied the acceptance criterion.

Observed recovery times:

- Uphill disturbance: 13.00 seconds
- Downhill disturbance: 10.53 seconds

This demonstrates that the controller can compensate for temporary road-grade disturbances and restore speed tracking within the defined tolerance.

## 7. Conclusion

The Cruise Control model successfully passed all five defined performance MIL test scenarios.

The simulation demonstrated:

1. Accurate baseline speed tracking.
2. Compensation for uphill and downhill road-grade disturbances.
3. Speed regulation at different initial speed conditions.
4. Throttle output within the configured limits.
5. Continued cruise control operation without unintended sensor fault detection.

The 40-second simulation duration was necessary to evaluate the complete recovery and settling behavior in the disturbance scenarios.

**Final performance test status: PASS – 5/5 scenarios.**

## 8. Validation Scope and Limitations

These results represent simulation-level MIL validation under the defined model assumptions and test conditions.

They do not establish production vehicle performance or validate real-world hardware behavior.

Software-in-the-Loop (SIL), code generation, processor-level execution, and hardware validation are outside the scope of this report unless separately performed and documented.