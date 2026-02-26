function result = enactWriteSerialQueue(s)
    global serialQueue;
    result = [];
    if length(serialQueue) > 0
       command = serialQueue{1};
       serialQueue(1) = [];
       result = writeCheck(s,command);
    end
end