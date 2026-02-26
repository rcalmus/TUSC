function s = runTUS()
    disp('-----------------------------------------------');
    disp('TUS Setup Script');
    disp('Date: November 2022');
    disp('Author: Ryan Calmus (email: rmcalmus@uiowa.edu)');
    disp('Min. Software Requirements: MATLAB r2019b');
    disp('-----------------------------------------------');

    s = openConnection(); % open connection to TPO and return serial object
    
%     input('Single or dual transducer setup? [Respond S or D]\n','s');
    
end

% Open connection with TPO using serial object s, and configure to accept
% advanced commands over a remote connection:
function s = openConnection()
    freeports = serialportlist("available");
    % Open a serial connection at 115200 baud, 8 data bits, no parity, with
    % no handshaking:
    s = serialport(freeports(1),115200,"Parity","none","DataBits",8,"FlowControl","none");
    configureTerminator(s,"CR");

    firmwareversion = s.readline();
    fprintf('Successfully opened connection with device: %s\n',firmwareversion);
    pause(2);
    % Configure TPO to accept advanced commands:
    writeCheck(s,'LOCAL=0','Local: 0');
    writeCheck(s,'VOLUME=2','Sound volume: 2');

    writeCheck(s,'TRIGGERMODE=0','Trigger Mode: 0');



% writeCheck(s,'BURST=180000','Burst length: 180.000 ms');
% writeCheck(s,'PERIOD=500000','Burst period: 500.000 ms');
writeCheck(s,'BURST=80','Burst length: 0.080 ms');
writeCheck(s,'PERIOD=20000','Burst period: 20.000 ms');
% writeCheck(s,'BURST=5000','Burst length: 5.000 ms');

% writeCheck(s,'GLOBALPOWER=500','Global power: 0.500');

    writeCheck(s,'TIMER=0','Timer: 0.000 ms'); % 0 constant for calibration
%     writeCheck(s,'TIMER=500000','Timer: 500.000 ms'); % 500ms for pulse
%     writeCheck(s,'RAMPMODE=4','Ramp mode: 4'); % exponential ramp
    writeCheck(s,'RAMPMODE=0','Ramp mode: 0'); % no ramp
    writeCheck(s,'RAMPLENGTH=4000','Ramp length: 4.000 ms'); % exponential ramp
    writeCheck(s,'FOCUS=41900','Focus: 41.900 mm'); % UNDOCUMENTED!!!!!!
% writeCheck(s,'FOCUS=39200','Focus: 39.200 mm'); % UNDOCUMENTED!!!!!!
%     writeCheck(s,'ENFORCELIMITS=0','Enforce Power Limits: 0'); % TURN OFF SAFETY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    writeCheck(s,'ENFORCELIMITS=1','Enforce Power Limits: 1'); % TURN OFF SAFETY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%      writeCheck(s,'GLOBALPOWER=25000','Global power: 25.000');
%     writeCheck(s,'GLOBALPOWER=10000','Global power: 10.000');
%     writeCheck(s,'GLOBALPOWER=21250','Global power: 21.250');
    writeCheck(s,'GLOBALPOWER=12690','Global power: 12.690');
    
%     writeCheck(s,'START','Treatment started');
%     writeCheck(s,'ABORT','Treatment aborted');

% Sanguinetti params:

% writeCheck(s,'PERIOD=120000000','Burst period: 120000.000 ms');
% writeCheck(s,'BURST=600000','Burst length: 600.000 ms');
% writeCheck(s,'GLOBALPOWER=4230','Global power: 4.230');
end