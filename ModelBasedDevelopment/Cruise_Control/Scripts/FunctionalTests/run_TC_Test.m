
function result = run_TC_Test(c, model)

% =========================================================
% RUN ONE CRUISE CONTROL PERFORMANCE TEST
% =========================================================

fprintf('\nRunning %s: %s\n', c.ID, c.Description);

simIn = Simulink.SimulationInput(model);

% ---------------------------------------------------------
% 1. Vehicle parameters
% ---------------------------------------------------------

simIn = simIn.setVariable('V0', c.V0);
simIn = simIn.setVariable('Vtarget', c.Vtarget);

% Time-varying road grade
simIn = simIn.setVariable( ...
    'RoadGrade', c.RoadGrade_Profile);

% No sensor fault
simIn = simIn.setVariable('FaultInjection', 0);

% ---------------------------------------------------------
% 2. Driver command profiles
% ---------------------------------------------------------

t = c.StopTime;

% Enable cruise control from the beginning
CC_Profile = [0 1; t 1];

% SET pulse at simulation start
SET_Profile = [
    0       1;
    0.1     0;
    t       0
];

CANCEL_Profile = [0 0; t 0];
RESUME_Profile = [0 0; t 0];
Brake_Profile = [0 0; t 0];

% ---------------------------------------------------------
% 3. Pass signals to Simulink
% ---------------------------------------------------------

simIn = simIn.setVariable('CC_Switch', CC_Profile);
simIn = simIn.setVariable('SET_Command', SET_Profile);
simIn = simIn.setVariable('CANCEL_Command', CANCEL_Profile);
simIn = simIn.setVariable('RESUME_Command', RESUME_Profile);
simIn = simIn.setVariable('Brake_Switch', Brake_Profile);

simIn = simIn.setModelParameter( ...
    'StopTime', num2str(t));

% ---------------------------------------------------------
% 4. Execute simulation
% ---------------------------------------------------------

out = sim(simIn);

% ---------------------------------------------------------
% 5. Read logged signals
% ---------------------------------------------------------

[Time, VehicleSpeed] = readLoggedSignal(out.yout, 'VehicleSpeed');
[~, Throttle] = readLoggedSignal(out.yout, 'Throttle');
[~, SpeedReference] = readLoggedSignal(out.yout, 'SpeedReference');
[~, Mode] = readLoggedSignal(out.yout, 'Mode');
[~, CCEnable] = readLoggedSignal(out.yout, 'CCEnable');
[~, SensorFault] = readLoggedSignal(out.yout, 'SensorFault');

% ---------------------------------------------------------
% 6. Calculate performance metrics
% ---------------------------------------------------------

FinalSpeed = VehicleSpeed(end);

% Use the reference captured by SET during the final window
SS_Index = Time >= (t - c.SteadyStateWindow);

if ~any(SS_Index)
    error('No samples found in the steady-state window.');
end

ReferenceSpeed = median(SpeedReference(SS_Index));

SteadyStateSpeed = VehicleSpeed(SS_Index);

SteadyStateError = abs( ...
    ReferenceSpeed - SteadyStateSpeed);

SteadyStateErrorMax = max(SteadyStateError);

FinalError = abs(ReferenceSpeed - FinalSpeed);

% Overshoot after SET
AfterSet = Time >= 0.1;

MaxOvershoot = max( ...
    VehicleSpeed(AfterSet) - ReferenceSpeed);

MaxOvershoot = max(0, MaxOvershoot);

% Throttle limits
MaxThrottle = max(Throttle);
MinThrottle = min(Throttle);

% ---------------------------------------------------------
% 7. Calculate disturbance recovery time
% ---------------------------------------------------------

RecoveryTime = NaN;

if c.DisturbanceEnd > 0

    RecoveryIndex = find(Time >= c.DisturbanceEnd);

    for k = 1:length(RecoveryIndex)

        idx = RecoveryIndex(k);

        RemainingError = abs( ...
            VehicleSpeed(idx:end) - ReferenceSpeed);

        if all(RemainingError <= c.MaxAllowedSteadyStateError)

            RecoveryTime = Time(idx) - c.DisturbanceEnd;
            break;

        end

    end

else
    RecoveryTime = 0;
end

% ---------------------------------------------------------
% 8. Functional and performance checks
% ---------------------------------------------------------

FinalMode = Mode(end);
FinalEnable = CCEnable(end);
FaultDetected = any(SensorFault ~= 0);

SteadyStatePass = ...
    SteadyStateErrorMax < c.MaxAllowedSteadyStateError;

ThrottlePass = ...
    MaxThrottle <= 1.0 && MinThrottle >= 0.0;

CruiseActivePass = ...
    round(FinalMode) == 2 && FinalEnable ~= 0;

SensorPass = ~FaultDetected;

% ---------------------------------------------------------
% 9. Store results
% ---------------------------------------------------------

result.ID = c.ID;
result.Description = c.Description;

result.FinalSpeed = FinalSpeed;
result.ReferenceSpeed = ReferenceSpeed;
result.FinalError = FinalError;
result.SteadyStateErrorMax = SteadyStateErrorMax;
result.MaxOvershoot = MaxOvershoot;

result.MaxThrottle = MaxThrottle;
result.MinThrottle = MinThrottle;

result.RecoveryTime = RecoveryTime;

result.FinalMode = FinalMode;
result.FinalEnable = FinalEnable;
result.FaultDetected = FaultDetected;

result.SteadyStatePass = SteadyStatePass;
result.ThrottlePass = ThrottlePass;
result.CruiseActivePass = CruiseActivePass;
result.SensorPass = SensorPass;

result.Pass = ...
    SteadyStatePass && ...
    ThrottlePass && ...
    CruiseActivePass && ...
    SensorPass;

if result.Pass
    result.Message = 'PASS';
else
    result.Message = 'FAIL - Check metrics';
end

% ---------------------------------------------------------
% 10. Display test result
% ---------------------------------------------------------

fprintf('\n------------------------------------------\n');
fprintf('Test ID                 : %s\n', result.ID);
fprintf('Reference Speed         : %.3f m/s\n', ReferenceSpeed);
fprintf('Final Speed             : %.3f m/s\n', FinalSpeed);
fprintf('Final Error             : %.3f m/s\n', FinalError);
fprintf('Maximum SS Error        : %.3f m/s\n', SteadyStateErrorMax);
fprintf('Maximum Overshoot       : %.3f m/s\n', MaxOvershoot);
fprintf('Maximum Throttle        : %.3f\n', MaxThrottle);
fprintf('Minimum Throttle        : %.3f\n', MinThrottle);
fprintf('Recovery Time           : %.3f s\n', RecoveryTime);
fprintf('Final Mode              : %.0f\n', FinalMode);
fprintf('Fault Detected          : %d\n', FaultDetected);
fprintf('RESULT                  : %s\n', result.Message);
fprintf('------------------------------------------\n');

end


% =========================================================
% READ LOGGED SIGNAL
% =========================================================

function [time, data] = readLoggedSignal(out, name)

signal = out.get(name);

if isa(signal, 'timeseries')

    time = signal.Time(:);
    data = squeeze(signal.Data);
    data = data(:);

elseif isstruct(signal) && isfield(signal, 'signals')

    time = signal.time(:);
    data = squeeze(signal.signals.values);
    data = data(:);
    
elseif isa(signal.Values, 'timeseries')
    time = signal.Values.time(:);
    data = squeeze(signal.Values.data);
    data = data(:);
else

    error(['Unsupported logged signal format for ', name]);

end

if length(time) ~= length(data)
    error('Time and data lengths do not match for %s.', name);
end

end
