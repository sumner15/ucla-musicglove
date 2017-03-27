%% CODED variable table 
% FIRST LETTER 
% b - baseline
% p - post
% c - change (change = post - baseline)
%
% SECOND LETTER 
% h - hit (all grips included)
% i - index
% m - middle
%
% THIRD LETTER(S) 
% r - hit rate (percentage of notes hit for a particular grip)
% lat - latency (mean timing of a grip compared to actual note timing)
% std - standard deviation of latency (all grips)

%% path handling
addpath(cd);
[~, name] = system('hostname');
if strcmp(name(1:end-1),'DARTH-10')
    cd 'D:\Dropbox\UCI RESEARCH\UCLA\MusicGlove\data\'
elseif strcmp(name(1:end-1),'LABPC-EEG')
    cd 'C:\Users\Sumner\Dropbox\UCI RESEARCH\UCLA\MusicGlove\data\'
end

%% initializing variables
subjects = {'AM_Right','AP_Right','BG_Left','BLG_Left','cw_Left',...
            'EJ_Left','GC_Right','KY_Left','PM_Left','RM_Left','TC_Right'};  
        
conditions = {'baseline','meds','stim','both','follow Up'};
chronoConditions = {'baseline','','','both','follow up'};

nSubs = length(subjects);   
nConds = length(conditions);

[hitRateAll, latency, lateVar] = deal(NaN(nSubs,nConds));
subGroup = NaN(nSubs,1);
nBaseMeasurements = NaN(nSubs,nConds);

%% loading summary table
load summary
cd summary

%% organizing data
for sub = 1:nSubs  
    % loading file
    try 
        subname = subjects{sub};       
        filename = celldir([subname '*.csv']);                        
        disp(['Loading ' filename{1} '...']);
        importfile(filename{1})  
    catch me 
        warning([subname ': No data found for this subject']);
        clear data textdata
    end        
    
    % filling data 
    try
        % getting dates  & conditions from summary sheet
        subInds = find(ismember(Dataexistsfor,subname(1:2)));
        subDates = datetime(Date(subInds),'Format','yyyy-MM-dd');
        subConds = Phase(subInds);
        if strcmp(subConds{1}, 'Meds')
            subGroup(sub) = 1;
        elseif strcmp(subConds{1}, 'Stim')
            subGroup(sub) = 2;
        end
        
        % finding relevant data indices from dates
        allDates = datetime(importdate(filename{1}),'Format','yyyy-MM-dd');
        
        % filling in Baseline data
        condInd = find(ismember(subConds,'Meds'));        
        if ~isempty(condInd)
            condDate = subDates(condInd);
            condDateInds = find(allDates == condDate); %meds inds
            if condDateInds(1)>2
                condDateInds = 1:condDateInds(1)-1; %baseline inds               
                allHits = sum(sum(data(condDateInds,1:5)));
                allPoss = sum(sum(data(condDateInds,6:10)));
                hitRateAll(sub,1) = allHits/allPoss*100;
                if hitRateAll(sub,1)~=0
                    latency(sub,1) = -mean(data(condDateInds,11));                
                    lateVar(sub,1) = mean(data(condDateInds,12));
                end
                nBaseMeasurements(sub,1) = length(condDateInds);
            end
        end        
        % filling in Meds/Stim data     
        condInd = find(ismember(subConds,'Meds'));        
        if ~isempty(condInd)
            condDate = subDates(condInd);
            condDateInds = find(allDates == condDate);
            allHits = sum(sum(data(condDateInds,1:5)));
            allPoss = sum(sum(data(condDateInds,6:10)));
            hitRateAll(sub,2) = allHits/allPoss*100;
            if hitRateAll(sub,2)~=0
                latency(sub,2) = -mean(data(condDateInds,11));                
                lateVar(sub,2) = mean(data(condDateInds,12));
            end
            nBaseMeasurements(sub,2) = length(condDateInds);
        end
        % filling in Stim/Meds data        
            condInd = find(ismember(subConds,'Stim'));
        if ~isempty(condInd)
            condDate = subDates(condInd);
            condDateInds = find(allDates == condDate);
            allHits = sum(sum(data(condDateInds,1:5)));
            allPoss = sum(sum(data(condDateInds,6:10)));
            hitRateAll(sub,3) = allHits/allPoss*100;
            if hitRateAll(sub,3)~=0
                latency(sub,3) = -mean(data(condDateInds,11));                
                lateVar(sub,3) = mean(data(condDateInds,12));
            end
            nBaseMeasurements(sub,3) = length(condDateInds);
        end
        % filling in Stim+Meds data
        condInd = find(ismember(subConds,'Both'));
        if ~isempty(condInd)
            condDate = subDates(condInd);
            condDateInds = find(allDates == condDate);
            allHits = sum(sum(data(condDateInds,1:5)));
            allPoss = sum(sum(data(condDateInds,6:10)));
            hitRateAll(sub,4) = allHits/allPoss*100;
            if hitRateAll(sub,4)~=0
                latency(sub,4) = -mean(data(condDateInds,11));                
                lateVar(sub,4) = mean(data(condDateInds,12));
            end
            nBaseMeasurements(sub,4) = length(condDateInds);
        end
        % filling in Follow Up data
        condInd = find(ismember(subConds,'Follow Up'));
        if ~isempty(condInd)
            condDate = subDates(condInd);
            condDateInds = find(allDates == condDate);
            allHits = sum(sum(data(condDateInds,1:5)));
            allPoss = sum(sum(data(condDateInds,6:10)));
            hitRateAll(sub,5) = allHits/allPoss*100;
            if hitRateAll(sub,5)~=0
                latency(sub,5) = -mean(data(condDateInds,11));                
                lateVar(sub,5) = mean(data(condDateInds,12));
            end
            nBaseMeasurements(sub,5) = length(condDateInds);
        end        
        
   
        
    catch me 
        warning([subname ': Bad data, Subject skipped']);
    end
end

%% create a chronological hit rate matrix
chronoHitRateAll = NaN(size(hitRateAll));
reOrder = [1 3 2 4 5]; % reverses stim & meds
for sub = 1:nSubs
    if subGroup(sub) == 1
        chronoHitRateAll(sub,:) = hitRateAll(sub,:);
    elseif subGroup(sub) ==2        
        chronoHitRateAll(sub,:) = hitRateAll(sub,reOrder);
    end
end       

%% saving data
clear ans condInd filename I i me name sub subConds subDates subInds
save('processedDataTable.mat');

%% calling plotting function
plotMGUCLA();
