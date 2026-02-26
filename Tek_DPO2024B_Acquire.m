% Ryan Calmus, March 2023
% FIRST Open TekVISA software and click "Properties" --> "Reset Instrument"
% Then run:
function scope = Tek_DPO2024B_Acquire
%     if nargin < 1 || isempty(scope)
        scope = oscilloscope;
        scope.Resource = 'USB::0x0699::0x03A3::C031377::INSTR'%'USB::0x0699::0x03A3::C031377::INSTR';    
        connect(scope);
       autoSetup(scope);
%     end
   
     ch = 'CH1';
    enableChannel(scope,ch);
    setVerticalRange(scope,ch, 3);
%     configureChannel(scope,ch,"VerticalRange",10);
%     configureChannel(scope,ch,"ProbeAttenuation",10);
    
    scope.AcquisitionTime = 0.25;
    scope.TriggerLevel = 0.5%0.1;
    scope.TriggerSource = ch;
    scope.TriggerSlope = "rising";
    scope.TriggerMode = "normal";
    
    % Set the acquisition to collect 2000 data points. 
    scope.WaveformLength = 2000;
   
%    disconnect(scope);
   
%    visaObj = visa('tek',scope.Resource);%'USB::0x0699::0x03A3::C031377::INSTR');
% % % fprintf(visaObj,'*RST; :AUTOSCALE')
%     fopen(visaObj);
%     fprintf(visaObj,'*RST; :AUTOSCALE');
%     fclose(visaObj);
%     
%     connect(scope);
    
  


    disp(scope)
    
    y = readWaveform(scope);
%     fprintf('Range of oscillation: %.2f V\n',(max(y(:)) - min(y(:)))/2);
%     scope.AcquisitionTime
    yupper = envelope(y(round(length(y)/2):end),7500,'peak');
    fprintf('Envelope max: %.2f V\n',median(yupper(:)));
%     scope.WaveformLength
    t = linspace(0,scope.AcquisitionTime,length(y));
%     figure;
%     plot(y);
    figure; plot(t,y); ylabel('Amplitude (Volts)'); xlabel('Time (Secs)');
    
%     if nargin < 1 || isempty(scope)
        disconnect(scope);
%     end
    
%     if nargin < 1 || isempty(visaObj)
%         try
%             visaObj = visa('tek','USB::0x0699::0x03A3::C031377::INSTR');
%         catch
%         end
%     end
%     
%     % Set the buffer size
%     visaObj.InputBufferSize = 100000;
%     % Set the timeout value
%     visaObj.Timeout = 10;
%     % Set the Byte order
%     visaObj.ByteOrder = 'littleEndian';
%     % Open the connection
%     fopen(visaObj);
%     
%     try
%         % Reset the instrument and autoscale and stop
%         fprintf(visaObj,'*RST; :AUTOSCALE'); 
%         fprintf(visaObj,':STOP');
%         % Specify data from Channel 1
%         fprintf(visaObj,':WAVEFORM:SOURCE CHAN1'); 
%         % Set timebase to main
%         fprintf(visaObj,':TIMEBASE:MODE MAIN');
%         % Set up acquisition type and count. 
%         fprintf(visaObj,':ACQUIRE:TYPE NORMAL');
%         fprintf(visaObj,':ACQUIRE:COUNT 1');
%         % Specify 5000 points at a time by :WAV:DATA?
%         fprintf(visaObj,':WAV:POINTS:MODE RAW');
%         fprintf(visaObj,':WAV:POINTS 5000');
%         % Now tell the instrument to digitize channel1
%         fprintf(visaObj,':DIGITIZE CHAN1');
%         % Wait till complete
%         operationComplete = str2double(query(visaObj,'*OPC?'));
%         while ~operationComplete
%             operationComplete = str2double(query(visaObj,'*OPC?'));
%         end
%         % Get the data back as a WORD (i.e., INT16), other options are ASCII and BYTE
%         fprintf(visaObj,':WAVEFORM:FORMAT WORD');
%         % Set the byte order on the instrument as well
%         fprintf(visaObj,':WAVEFORM:BYTEORDER LSBFirst');
%         % Get the preamble block
%         preambleBlock = query(visaObj,':WAVEFORM:PREAMBLE?');
%         % The preamble block contains all of the current WAVEFORM settings.  
%         % It is returned in the form <preamble_block><NL> where <preamble_block> is:
%         %    FORMAT        : int16 - 0 = BYTE, 1 = WORD, 2 = ASCII.
%         %    TYPE          : int16 - 0 = NORMAL, 1 = PEAK DETECT, 2 = AVERAGE
%         %    POINTS        : int32 - number of data points transferred.
%         %    COUNT         : int32 - 1 and is always 1.
%         %    XINCREMENT    : float64 - time difference between data points.
%         %    XORIGIN       : float64 - always the first data point in memory.
%         %    XREFERENCE    : int32 - specifies the data point associated with
%         %                            x-origin.
%         %    YINCREMENT    : float32 - voltage diff between data points.
%         %    YORIGIN       : float32 - value is the voltage at center screen.
%         %    YREFERENCE    : int32 - specifies the data point where y-origin
%         %                            occurs.
%         % Now send commmand to read data
%         fprintf(visaObj,':WAV:DATA?');
%         % read back the BINBLOCK with the data in specified format and store it in
%         % the waveform structure. FREAD removes the extra terminator in the buffer
%         waveform.RawData = binblockread(visaObj,'uint16'); fread(visaObj,1);
%         % Read back the error queue on the instrument
%         instrumentError = query(visaObj,':SYSTEM:ERR?');
%         while ~isequal(instrumentError,['+0,"No error"' char(10)])
%             disp(['Instrument Error: ' instrumentError]);
%             instrumentError = query(visaObj,':SYSTEM:ERR?');
%         end
%     catch
%     end
%     fclose(visaObj);
end