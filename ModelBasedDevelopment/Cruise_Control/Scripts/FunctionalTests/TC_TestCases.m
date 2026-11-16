
function cases = TC_TestCases()
% =========================================================
% CRUISE CONTROL - PERFORMANCE TEST CASES
% =========================================================

% TC-001: Baseline speed regulation
cases(1) = createCase('TC-001', 'Baseline speed tracking', ...
    20, 40, ...
    [0 0; 30 0], 0);

% TC-002: Uphill disturbance rejection
cases(2) = createCase('TC-002', 'Uphill disturbance', ...
    20, 40, ...
    [0 0; 5 0; 5.1 3; 15 3; 15.1 0; 30 0], 15.1);

% TC-003: Downhill disturbance response
cases(3) = createCase('TC-003', 'Downhill disturbance', ...
    20, 40, ...
    [0 0; 5 0; 5.1 -3; 15 -3; 15.1 0; 30 0], 15.1);

% TC-004: Lower-speed regulation with uphill disturbance
cases(4) = createCase('TC-004', 'Lower-speed regulation', ...
    15, 40, ...
    [0 0; 5 0; 5.1 2; 15 2; 15.1 0; 30 0], 15.1);

% TC-005: Higher-speed regulation with uphill disturbance
cases(5) = createCase('TC-005', 'Higher-speed regulation', ...
    25, 40, ...
    [0 0; 5 0; 5.1 2; 15 2; 15.1 0; 30 0], 15.1);

end


% =========================================================
% CREATE ONE PERFORMANCE TEST CASE
% =========================================================

function c = createCase(id, description, V0, stopTime, ...
    roadGradeProfile, disturbanceEnd)

c.ID = id;
c.Description = description;

c.V0 = V0;
c.Vtarget = V0;

c.StopTime = stopTime;
c.RoadGrade_Profile = roadGradeProfile;
c.DisturbanceEnd = disturbanceEnd;

c.SteadyStateWindow = 5;
c.MaxAllowedSteadyStateError = 0.5;

end
