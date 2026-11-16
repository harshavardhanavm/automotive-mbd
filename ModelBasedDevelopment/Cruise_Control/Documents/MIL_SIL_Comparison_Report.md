# MIL-SIL Comparison Report – Cruise Control System

## 1. Overview

This report documents the comparison between Model-in-the-Loop (MIL) and Software-in-the-Loop (SIL) simulation results for the Cruise Control Model-Based Development project.

The objective is to verify that the Embedded Coder generated software produces performance results consistent with the original Simulink model.

## 2. Test Configuration

| Parameter | Configuration |
|---|---|
| Model | CruiseControl_V1 |
| MATLAB/Simulink | R2021b |
| Code Generation Target | ert.tlc |
| Controller Sample Time | 0.01 seconds |
| MIL Simulation | Normal Simulink simulation |
| SIL Simulation | Software-in-the-Loop |
| Test Duration | 40 seconds |
| Number of Test Cases | 5 |

## 3. Test Scenarios

| Test ID | Description | Scenario |
|---|---|---|
| TC-001 | Baseline speed tracking | Nominal speed tracking at 20 m/s |
| TC-002 | Uphill disturbance | +3° road grade |
| TC-003 | Downhill disturbance | -3° road grade |
| TC-004 | Lower-speed regulation | Speed tracking at 15 m/s with +2° grade |
| TC-005 | Higher-speed regulation | Speed tracking at 25 m/s with +2° grade |

## 4. MIL and SIL Test Summary

| Execution Mode | Total Tests | Passed | Failed | Pass Rate |
|---|---:|---:|---:|---:|
| MIL | 5 | 5 | 0 | 100% |
| SIL | 5 | 5 | 0 | 100% |

All five performance test cases passed in both execution modes.

## 5. Numerical Comparison

The following table compares the principal performance metrics.

| Test ID | Metric | MIL | SIL | Absolute Difference |
|---|---|---:|---:|---:|
| TC-001 | Final Speed | 20.000 | 20.000 | 0 |
| TC-001 | Final Error | 0.002034 | 0.002018 | 0.000015 |
| TC-001 | Steady-State Error Max | 0.004202 | 0.004168 | 0.000034 |
| TC-001 | Maximum Overshoot | 0.005428 | 0.005379 | 0.000048 |
| TC-001 | Maximum Throttle | 0.070024 | 0.070015 | 0.000009 |
| TC-002 | Final Speed | 20.026 | 20.026 | 0 |
| TC-002 | Final Error | 0.028069 | 0.028035 | 0.000034 |
| TC-002 | Steady-State Error Max | 0.141100 | 0.140760 | 0.000340 |
| TC-002 | Maximum Overshoot | 0.776230 | 0.776490 | 0.000260 |
| TC-002 | Maximum Throttle | 0.246790 | 0.246760 | 0.000030 |
| TC-003 | Final Speed | 19.985 | 19.985 | 0 |
| TC-003 | Final Error | 0.012999 | 0.013055 | 0.000056 |
| TC-003 | Steady-State Error Max | 0.090475 | 0.090387 | 0.000088 |
| TC-003 | Maximum Overshoot | 0.691470 | 0.691570 | 0.000100 |
| TC-003 | Maximum Throttle | 0.077127 | 0.077111 | 0.000016 |
| TC-004 | Final Speed | 15.016 | 15.016 | 0 |
| TC-004 | Final Error | 0.017524 | 0.017500 | 0.000024 |
| TC-004 | Steady-State Error Max | 0.094381 | 0.094139 | 0.000242 |
| TC-004 | Maximum Overshoot | 0.521890 | 0.522050 | 0.000160 |
| TC-004 | Maximum Throttle | 0.172920 | 0.172900 | 0.000020 |
| TC-005 | Final Speed | 25.019 | 25.019 | 0 |
| TC-005 | Final Error | 0.021292 | 0.021259 | 0.000033 |
| TC-005 | Steady-State Error Max | 0.096723 | 0.096477 | 0.000246 |
| TC-005 | Maximum Overshoot | 0.503510 | 0.503640 | 0.000130 |
| TC-005 | Maximum Throttle | 0.205840 | 0.205810 | 0.000030 |

*Note: Values are compared using the displayed MIL and SIL results, so differences are subject to the precision of the reported values.*

## 6. Additional Verification

The following conditions were also consistent between MIL and SIL:

- Minimum throttle remained within the expected range.
- Final operating mode was ACTIVE (Mode 2).
- Cruise enable was TRUE at the end of each test.
- No sensor faults were detected in the performance scenarios.
- All steady-state error checks passed.
- All throttle limit checks passed.
- All cruise activation checks passed.

## 7. Conclusion

All five performance test cases passed in both MIL and SIL simulation modes.

The numerical comparison shows that the generated Embedded Coder software produces results closely matching the original Simulink model across the tested operating conditions.

The observed differences in steady-state error, overshoot, throttle and recovery time are small.

Therefore, the results provide evidence of MIL-SIL performance consistency for the five tested scenarios.

## 8. Verification Scope and Limitations

- Verification covers five defined performance scenarios.
- Comparison uses the reported test summary metrics.
- Bit-for-bit equivalence has not been established.
- Detailed signal-level error analysis has not been performed.
- Processor-in-the-Loop (PIL) testing and hardware validation have not been performed.
- Results do not establish production-level automotive software compliance.

## 9. Final Status

**MIL Performance Testing:** PASS (5/5)

**SIL Performance Testing:** PASS (5/5)

**MIL-SIL Performance Consistency:** PASS for the reported test metrics and scenarios.