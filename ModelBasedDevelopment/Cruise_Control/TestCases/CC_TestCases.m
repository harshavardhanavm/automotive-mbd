
function cases = CC_TestCases()

% =========================================================
% CRUISE CONTROL - TEST CASES
% =========================================================

% Test 1: Master switch OFF
cases(1) = createCase('CC-001', 'Cruise OFF', ...
    20, 20, 0, 5, 0, ...
    0, 0, 0, 0, 0, 'OFF');

% Test 2: Master switch ON - Standby
cases(2) = createCase('CC-002', 'Cruise standby', ...
    20, 20, 0, 5, 0, ...
    1, 0, 0, 0, 0, 'STANDBY');

% Test 3: SET, CANCEL and RESUME sequence
cases(3) = createCase('CC-003', 'SET CANCEL RESUME', ...
    20, 20, 0, 8, 0, ...
    1, 0, 0, 0, 0, 'SEQUENCE');

% Test 4: Brake override
cases(4) = createCase('CC-004', 'Brake override', ...
    20, 20, 0, 6, 0, ...
    1, 0, 0, 0, 0, 'BRAKE');

% Test 5: Stuck sensor fault
cases(5) = createCase('CC-005', 'Stuck sensor fault', ...
    20, 25, 0, 8, 1, ...
    1, 0, 0, 0, 0, 'FAULT');

% Test 6: Normal sensor operation
cases(6) = createCase('CC-006', 'Healthy sensor', ...
    20, 20, 0, 5, 0, ...
    1, 0, 0, 0, 0, 'HEALTHY');

% Test 7: RESUME Without SET
cases(7) = createCase('CC-007', 'RESUME Without SET', ...
    20, 20, 0, 5, 0, ...
    1, 0, 1, 0, 0, 'STANDBY');

% Test 8: CC OFF
cases(8) = createCase('CC-008', 'CC OFF', ...
    20, 20, 0, 5, 0, ...
    0, 0, 0, 0, 0, 'OFF');

% Test 9: Sensor Fault
cases(9) = createCase('CC-009', 'Sensor Fault', ...
    20, 20, 0, 5, 1, ...
    1, 0, 0, 0, 0, 'FAULT');

end


% =========================================================
% CREATE ONE TEST CASE
% =========================================================

function c = createCase(id, description, ...
    V0, Vtarget, grade, stopTime, fault, ...
    cc, setCmd, cancelCmd, resumeCmd, brake, checkType)

c.ID = id;
c.Description = description;

c.V0 = V0;
c.Vtarget = Vtarget;
c.RoadGrade = grade;
c.StopTime = stopTime;
c.FaultInjection = fault;

% Initial command values
c.CC_Switch = cc;
c.SET_Command = setCmd;
c.CANCEL_Command = cancelCmd;
c.RESUME_Command = resumeCmd;
c.Brake_Switch = brake;

c.CheckType = checkType;

end
