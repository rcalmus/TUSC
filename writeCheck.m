% Write through serial object s and retry until expected response is received
function result = writeCheck(s,command,expectedOutput)
    global writingToTPO;
    writingToTPO = true;
    % while writingToTPO == true
    %     pause(0.001);
    % end

    % logCommand(command);

    if isempty(s)
        result = 'DISCONNECTED';
        return;
    end

    if nargin < 3 || isempty(expectedOutput)
        expectedOutput = [];
    end
    retries = 1;
    result = '';
    count = 0;
    completed = false;

    logQueries = false;
    query = false;

    if endsWith(command,'?')
        query = true;
        % if writingToTPO
            % writingToTPO = false;
            % return;
        % end
        s.flush();
    end

    if isempty(expectedOutput)
        try
            s.writeline(command);
            if logQueries || (~logQueries && ~query)
                fprintf('CONFIGURING TPO WITH COMMAND: "%s" AT: %s\n',command,char(datetime));
            end
            % pause(0.0001);
            result = strtrim(s.readline());

            if strcmpi(result,'E2')
                % disp('clearing value error')
                writeCheck(s,'CLEARERROR');
                result = 'VALUE ERROR';
                writingToTPO = false;
                return;
            elseif strcmpi(result,'E1')
                % disp('clearing command error')
                writeCheck(s,'CLEARERROR');
                result = 'COMMAND ERROR';
                writingToTPO = false;
                return;
            elseif strcmpi(result,'E3')
                % disp('clearing query error')
                writeCheck(s,'CLEARERROR');
                result = 'QUERY ERROR';
                writingToTPO = false;
                return;
            end

        catch
            result = '';
        end
    else
        while ~endsWith(upper(result),upper(expectedOutput)) && count < retries
            count = count + 1;
    
            try
                s.writeline(command);
                % fprintf('CONFIGURING TPO WITH COMMAND: "%s"\n',command);
                if logQueries || (~logQueries && ~query)
                    fprintf('CONFIGURING TPO WITH COMMAND: "%s" AT: %s\n',command,char(datetime));
                end
                % pause(0.0001);
                result = strtrim(s.readline());
    
                if strcmpi(result,'E2')
                    % disp('clearing value error')
                    writeCheck(s,'CLEARERROR');
                    result = 'VALUE ERROR';
                    writingToTPO = false;
                    return;
                elseif strcmpi(result,'E1')
                    % disp('clearing command error')
                    writeCheck(s,'CLEARERROR');
                    result = 'COMMAND ERROR';
                    writingToTPO = false;
                    return;
                elseif strcmpi(result,'E3')
                    % disp('clearing query error')
                    writeCheck(s,'CLEARERROR');
                    result = 'QUERY ERROR';
                    writingToTPO = false;
                    return;
                end
                if endsWith(upper(result),upper(expectedOutput))
                    completed = true;
                end
            catch
                result = '';
            end
            if ~endsWith(upper(result),upper(expectedOutput))
                if logQueries || (~logQueries && ~query)
                    fprintf('FAILURE TO CONFIGURE TPO WITH COMMAND: "%s" at %s, retrying...\n',command,char(datetime));
                end
            end
        end
        if count >= retries && ~completed
            result = 'VALUE ERROR';
        end
    end

    if endsWith(command,'?')
        result = split(result,':');
        result = result{end};
        while startsWith(result,' ')
            result = result(2:end);
        end
        result = split(result,' ');
        try
            result = result{1};
        catch
            result = '';
        end
        try
            result = str2num(result);
        catch
        end
    end
    writingToTPO = false;

    % if ~contains(result,'ERROR')
        % logCommand(command);
    % end
end