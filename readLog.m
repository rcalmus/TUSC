function t = readLog
    t = readtable('.\log.txt','Delimiter',';');
    if isempty(t)
        t = table({''},{''});
    end
    t.Properties.VariableNames = {'Time','Event'};
    t(:,1) = cellfun(@(x) strrep(x,'Time: ',''),t{:,1},'UniformOutput',false);
    t(:,2) = cellfun(@(x) strrep(x,'Command: "',''),t{:,2},'UniformOutput',false);
    t(:,2) = cellfun(@(x) x(1:(end-2)),t{:,2},'UniformOutput',false);
end