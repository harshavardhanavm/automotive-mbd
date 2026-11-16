
function result = run_CruiseControl_Test(c, model)

% =========================================================
% RUN ONE CRUISE CONTROL TEST
% =========================================================

simIn = Simulink.SimulationInput(model);

% ---------------------------------------------------------
% 1. Set vehicle inputs
% ---------------------------------------------------------

simIn = simIn.setVariable('V0', c.V0);
simIn = simIn.setVariable('Vtarget', c.Vtarget);
simIn = simIn.setVariable('RoadGrade', c.RoadGrade);
simIn = simIn.setVariable('FaultInjection', c.FaultInjection);

% ---------------------------------------------------------
% 2. Create command input profiles
% ---------------------------------------------------------

t = c.StopTime;

% Default: command remains at its initial value
CC_Profile = [0 c.CC_Switch; t c.CC_Switch];

SET_Profile = [0 0; t 0];
CANCEL_Profile = [0 0; t 0];
RESUME_Profile = [0 0; t 0];
Brake_Profile = [0 0; t 0];

% ---------------------------------------------------------
% 3. Apply command sequences
% ---------------------------------------------------------

switch c.CheckType

    case 'SEQUENCE'

        % SET pulse: 1.0 to 1.1 seconds
SET_Profile = [0 0; 0.99 0;
                       1.0 1;
                       1.1 0;
                       t 0];

CANCEL_Profile = [0 0; 2.99 0;
                          3.0 1;
                          3.1 0;
                          t 0];

RESUME_Profile = [0 0;4.99 0;
                          5.0 1;
                          5.1 0;
                          t 0];

    case 'BRAKE'

        % First activate cruise using SET
        SET_Profile = [0 0; 1.0 1; 1.1 0; t 0];

        % Then press brake
        Brake_Profile = [0 0; 3.0 1; 3.1 0; t 0];

end

% ---------------------------------------------------------
% 4. Pass profiles to Simulink
% ---------------------------------------------------------

simIn = simIn.setVariable('CC_Switch', CC_Profile);
simIn = simIn.setVariable('SET_Command', SET_Profile);
simIn = simIn.setVariable('CANCEL_Command', CANCEL_Profile);
simIn = simIn.setVariable('RESUME_Command', RESUME_Profile);
simIn = simIn.setVariable('Brake_Switch', Brake_Profile);

simIn = simIn.setModelParameter('StopTime', num2str(t));

% ---------------------------------------------------------
% 5. Run simulation
% ---------------------------------------------------------

out = sim(simIn);

% ---------------------------------------------------------
% 6. Read logged signals
% ---------------------------------------------------------

mode = readSignal(out, 'Mode');
enable = readSignal(out, 'CCEnable');
fault = readSignal(out, 'SensorFault');
reference = readSignal(out, 'SpeedReference');
speed = readSignal(out, 'VehicleSpeed');
cancel = readSignal(out, 'CANCEL_Command');


% ---------------------------------------------------------
% 7. Initialize result
% ---------------------------------------------------------

result.ID = c.ID;
result.Description = c.Description;
result.Pass = false;
result.Message = '';

result.FinalMode = mode(end);
result.FinalEnable = enable(end);
result.FaultDetected = any(fault ~= 0);

% ---------------------------------------------------------
% 8. Test-specific checks
% ---------------------------------------------------------

switch c.CheckType

    case 'OFF'

        result.Pass = (mode(end) == 0);

    case 'STANDBY'

        result.Pass = (mode(end) == 1);

    case 'SEQUENCE'

        % SET should capture the speed reference
        % at approximately 1 second.
        capturedSpeed = speedAt(out, 'VehicleSpeed', 1.0);
        storedSpeed = speedAt(out, 'SpeedReference', 1.0);

        % CANCEL should return to standby.
        cancelMode = speedAt(out, 'Mode', 4.0);

        % RESUME should reactivate cruise control.
        resumeMode = speedAt(out, 'Mode', 6.0);

        result.Pass = ...
            abs(capturedSpeed - storedSpeed) < 0.1 && ...
            round(cancelMode) == 1 && ...
            round(resumeMode) == 2;

        fprintf('\n--- CC-003 DEBUG ---\n');

        fprintf('Captured speed : %.3f\n', capturedSpeed);
        fprintf('Stored speed   : %.3f\n', storedSpeed);
        fprintf('Mode after CANCEL : %.0f\n', cancelMode);
        fprintf('Mode after RESUME : %.0f\n', resumeMode);
        
        fprintf('Final mode : %.0f\n', mode(end));
        fprintf('Final CC Enable : %.0f\n', enable(end));

        
        fprintf('\n--- CANCEL SIGNAL CHECK ---\n');

        cancelSignal = readSignal(out, 'CANCEL_Command');

        fprintf('Maximum CANCEL value: %.0f\n', max(cancelSignal));

        modeSignal = readSignal(out, 'Mode');

    case 'BRAKE'

        % Brake should deactivate cruise control.
        brakeMode = speedAt(out, 'Mode', 4.0);

        result.Pass = ...
            round(brakeMode) == 1 && enable(end) == 0;

    case 'FAULT'

        result.Pass = ...
            result.FaultDetected && ...
            round(mode(end)) == 1 && ...
            enable(end) == 0;

    case 'HEALTHY'

        result.Pass = ~result.FaultDetected;

end

% ---------------------------------------------------------
% 9. Final test status
% ---------------------------------------------------------

if result.Pass
    result.Message = 'PASS';
else
    result.Message = 'FAIL - Check expected behaviour';
end

end


% =========================================================
% READ A LOGGED SIGNAL
% =========================================================

function data = readSignal(out, name)

signal = out.get(name);

if isa(signal, 'timeseries')
    data = squeeze(signal.Data);

elseif isstruct(signal) && isfield(signal, 'signals')
    data = squeeze(signal.signals.values);

else
    data = squeeze(signal);

end

data = data(:);

end


% =========================================================
% READ SIGNAL VALUE AT A PARTICULAR TIME
% =========================================================

function value = speedAt(out, name, targetTime)

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
    error('Signal %s must be logged as Timeseries or Structure With Time.', name);
end

[~, index] = min(abs(time - targetTime));

value = data(index);

end
