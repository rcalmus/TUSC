function writeSerialQueue(command)
    global serialQueue;
    serialQueue{end+1} = command;
end