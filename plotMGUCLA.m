function plotMGUCLA
load processedDataTable.mat
close all
hitRateAll(nSubs,nConds) = NaN; %throwing out outlier
xInds = [1 3 4 5 6];

%% plotting hit rate for each group across phases 
figure('Position', [100, 100, 800, 500]);
hold on
h = cell(nSubs,1);
for sub = 1:nSubs
    if subGroup(sub)==1
        h{sub} = plot(xInds,hitRateAll(sub,:),...
             'x-k','markers',16,'LineWidth',2); 
    else
        h{sub} = plot(xInds,hitRateAll(sub,:),...
             'o-b','markers',16,'LineWidth',2);
    end
    legend([h{1} h{4}], 'Meds first','Stim first');
    axis([0.5 6.5 -5 100])
    set(gca,'Xtick',xInds)
    set(gca,'XtickLabel',conditions)
    ylabel('Hit Rate (%)')   
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
end

%% plotting change in hit rate for each group across phases 
figure('Position', [900, 100, 800, 500]);
hold on
h = cell(nSubs,1);
for sub = 1:nSubs
    if subGroup(sub)==1       
        h{sub} = plot(xInds,hitRateAll(sub,:)-hitRateAll(sub,1),...
            'x-k','markers',16,'LineWidth',2); 
    else
        h{sub} = plot(xInds,hitRateAll(sub,:)-hitRateAll(sub,1),...
            'o-b','markers',16,'LineWidth',2);
    end
    legend([h{1} h{4}], 'Meds first','Stim first',...
        'Location','Northwest');
    axis([0.5 6.5 -35 35])
    set(gca,'Xtick',xInds)
    set(gca,'XtickLabel',conditions)
    ylabel('Change in Hit Rate (%)')   
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
end

hitRateChange = hitRateAll-repmat(hitRateAll(:,1),1,nConds);
[~,p(1)] = ttest(hitRateChange(:,2),hitRateChange(:,1));
[~,p(2)] = ttest(hitRateChange(:,3),hitRateChange(:,2));
[~,p(3)] = ttest(hitRateChange(:,3),hitRateChange(:,1));
fprintf('\n HIT RATE CHANGE \n \n');
fprintf('T-test, Stim Vs. Meds, p = %1.3f \n',p(1));
fprintf('T-test, Stim+Meds Vs. Stim, p = %1.3f \n',p(2));
fprintf('T-test, Stim+Meds Vs. Meds, p = %1.3f \n',p(3));

%% plotting intersubject hit rate change box plots
figure('Position', [100, 100, 1400, 500]);
hold on
subplot(121)
boxData = hitRateAll(:,:)-hitRateAll(:,1);
boxplot(boxData);
title('normalized to baseline')
axis([0.5 5.5 -35 35])
set(gca,'XtickLabel',conditions)
ylabel('Change in Hit Rate (%)')   
set(findall(gcf,'-property','FontSize'),'FontSize',16)

subplot(122)
boxData = hitRateAll(:,:)-hitRateAll(:,2);
boxplot(boxData);
title('normalized to meds')
axis([0.5 5.5 -35 35])
set(gca,'XtickLabel',conditions)
ylabel('Change in Hit Rate (%)')   
set(findall(gcf,'-property','FontSize'),'FontSize',16)


%% plotting latency change 
figure('Position', [100, 600, 800 500]);
hold on 
h = cell(nSubs,1);
for sub = 1:nSubs
    if subGroup(sub)==1
        h{sub} = plot(xInds,latency(sub,:)-latency(sub,2),...
            'x-k','markers',16,'LineWidth',2); 
    else
        h{sub} = plot(xInds,latency(sub,:)-latency(sub,2),...
            'o-r','markers',16,'LineWidth',2);
    end
    legend([h{1} h{4}], 'Meds first','Stim first',...
        'Location','Best');
    xlim([0.5 6.5])
    set(gca,'Xtick',xInds)
    set(gca,'XtickLabel',conditions)
    ylabel('Change in Mean Latency (ms)')   
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
end

latencyChange = latency-repmat(latency(:,1),1,nConds);
[~,p(1)] = ttest(latencyChange(:,2),latencyChange(:,1));
[~,p(2)] = ttest(latencyChange(:,3),latencyChange(:,2));
[~,p(3)] = ttest(latencyChange(:,3),latencyChange(:,1));
fprintf('\n LATENCY CHANGE \n \n');
fprintf('T-test, Stim Vs. Meds, p = %1.3f \n',p(1));
fprintf('T-test, Stim+Meds Vs. Stim, p = %1.3f \n',p(2));
fprintf('T-test, Stim+Meds Vs. Meds, p = %1.3f \n',p(3));

%% plotting latency variance change
figure('Position', [900, 600, 800 500]);
hold on 
h = cell(nSubs,1);
for sub = 1:nSubs
    if subGroup(sub)==1
        h{sub} = plot(xInds,lateVar(sub,:)-lateVar(sub,2),...
            'x-k','markers',16,'LineWidth',2); 
    else
        h{sub} = plot(xInds,lateVar(sub,:)-lateVar(sub,2),...
            'o-m','markers',16,'LineWidth',2);
    end
    legend([h{1} h{4}], 'Meds first','Stim first',...
        'Location','Best');
    xlim([0.5 6.5])
    set(gca,'Xtick',xInds)
    set(gca,'XtickLabel',conditions)
    ylabel('Change in STD of Latency (ms)')   
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
end

lateVarChange = lateVar-repmat(lateVar(:,1),1,nConds);
[~,p(1)] = ttest(lateVarChange(:,2),lateVarChange(:,1));
[~,p(2)] = ttest(lateVarChange(:,3),lateVarChange(:,2));
[~,p(3)] = ttest(lateVarChange(:,3),lateVarChange(:,1));
fprintf('\n LATENCY STD CHANGE \n \n');
fprintf('T-test, Stim Vs. Meds, p = %1.3f \n',p(1));
fprintf('T-test, Stim+Meds Vs. Stim, p = %1.3f \n',p(2));
fprintf('T-test, Stim+Meds Vs. Meds, p = %1.3f \n',p(3));

