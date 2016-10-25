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
    cd 'D:\Dropbox\UCI RESEARCH\UCLA\MusicGlove'
end
cd data\

%% initializing variables
subjects = {'AM_Right','AP_Right','BG_Left','BLG_Left','cw_Left',...
            'EJ_Left','GC_Right','KY_Left','PM_Left','RM_Left','TC_Right'};  
conditions = {'Meds','Stim','Both','Follow Up'};

nSubs = length(subjects);   
nConds = length(conditions);

[hitRateAll, latency, lateVar] = deal(NaN(nSubs,nConds));
subGroup = NaN(nSubs,1);
%     hitRateThu, hitRateInd, hitRateMid, hitRateRin, hitRatePin]
% [bhr,phr,chr,bir,pir,cir,bmr,pmr,cmr,bLat,pLat,cLat,bStd,pStd,cStd] =...
%     deal(NaN(nSubs,1));

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
        
        % filling in Meds/Stim data     
        if subGroup(sub)==1
            condInd = find(ismember(subConds,'Meds'));
        else
%             condInd = find(ismember(subConds,'Stim'));
            condInd = find(ismember(subConds,'Meds'));
        end
        if ~isempty(condInd)
            condDate = subDates(condInd);
            condDateInds = find(allDates == condDate);
            allHits = sum(sum(data(condDateInds,1:5)));
            allPoss = sum(sum(data(condDateInds,6:10)));
            hitRateAll(sub,1) = allHits/allPoss*100;
            if hitRateAll(sub,1)~=0
                latency(sub,1) = -mean(data(condDateInds,11));                
                lateVar(sub,1) = mean(data(condDateInds,12));
            end
        end
        % filling in Stim/Meds data
        if subGroup(sub)==1
            condInd = find(ismember(subConds,'Stim'));
        else
%             condInd = find(ismember(subConds,'Meds'));
            condInd = find(ismember(subConds,'Stim'));
        end
        if ~isempty(condInd)
            condDate = subDates(condInd);
            condDateInds = find(allDates == condDate);
            allHits = sum(sum(data(condDateInds,1:5)));
            allPoss = sum(sum(data(condDateInds,6:10)));
            hitRateAll(sub,2) = allHits/allPoss*100;
            if hitRateAll(sub,1)~=0
                latency(sub,2) = -mean(data(condDateInds,11));                
                lateVar(sub,2) = mean(data(condDateInds,12));
            end
        end
        % filling in Stim+Meds data
        condInd = find(ismember(subConds,'Both'));
        if ~isempty(condInd)
            condDate = subDates(condInd);
            condDateInds = find(allDates == condDate);
            allHits = sum(sum(data(condDateInds,1:5)));
            allPoss = sum(sum(data(condDateInds,6:10)));
            hitRateAll(sub,3) = allHits/allPoss*100;
            if hitRateAll(sub,1)~=0
                latency(sub,3) = -mean(data(condDateInds,11));                
                lateVar(sub,3) = mean(data(condDateInds,12));
            end
        end
        % filling in Follow Up data
        condInd = find(ismember(subConds,'Follow Up'));
        if ~isempty(condInd)
            condDate = subDates(condInd);
            condDateInds = find(allDates == condDate);
            allHits = sum(sum(data(condDateInds,1:5)));
            allPoss = sum(sum(data(condDateInds,6:10)));
            hitRateAll(sub,4) = allHits/allPoss*100;
            if hitRateAll(sub,1)~=0
                latency(sub,4) = -mean(data(condDateInds,11));                
                lateVar(sub,4) = mean(data(condDateInds,12));
            end
        end        
        
   
        
    catch me 
        warning([subname ': Bad data, Subject skipped']);
    end
end

%% saving data
clear ans condInd filename I i me name sub subConds subDates subInds
save('processedDataTable.mat');

%% calling plotting function
plotMGUCLA();
