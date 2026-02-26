function logCommand(command)
    curTime = char(datetime);
    newl = sprintf('Time: %s; Command: "%s".',curTime,command);
    writelines(newl,'log.txt','WriteMode','append');
end