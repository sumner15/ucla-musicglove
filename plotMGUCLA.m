function plotMGUCLA
load processedDataTable.mat
close all
hitRateAll(nSubs,nConds) = NaN; %throwing out outlier
chronoHitRateAll(nSubs,nConds) = NaN;
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
[~,p(1)] = ttest(hitRateChange(:,3),hitRateChange(:,2));
[~,p(2)] = ttest(hitRateChange(:,4),hitRateChange(:,3));
[~,p(3)] = ttest(hitRateChange(:,4),hitRateChange(:,2));
fprintf('\n HIT RATE CHANGE \n \n');
fprintf('T-test, Stim Vs. Meds, p = %1.3f \n',p(1));
fprintf('T-test, Stim+Meds Vs. Stim, p = %1.3f \n',p(2));
fprintf('T-test, Stim+Meds Vs. Meds, p = %1.3f \n',p(3));

%% plotting chronological results
figure('Position', [100, 900, 800, 500]);
hold on
h = cell(nSubs,1);
for sub = 1:nSubs
    if subGroup(sub)==1       
        h{sub} = plot(xInds,chronoHitRateAll(sub,:)-hitRateAll(sub,1),...
            'x-k','markers',16,'LineWidth',2); 
    else
        h{sub} = plot(xInds,chronoHitRateAll(sub,:)-hitRateAll(sub,1),...
            'o-b','markers',16,'LineWidth',2);
    end
    legend([h{1} h{4}], 'meds  stim','stim  meds',...
        'Location','Northwest');
    axis([0.5 6.5 -35 35])
    set(gca,'Xtick',xInds)
    set(gca,'XtickLabel',chronoConditions)
    ylabel('Change in Hit Rate (%)')   
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
end

%% plotting intersubject hit rate change box plots
figure('Position', [100, 100, 1400, 500]);
hold on
subplot(121)
boxData = hitRateAll-repmat(hitRateAll(:,1),[1 5]);
boxplot(boxData,'colors','k'    ,'notch','on','widths',0.4);
title('normalized to baseline')
axis([0.5 5.5 -35 35])
set(gca,'XtickLabel',conditions)
ylabel('Change in Hit Rate (%)')   
set(findall(gcf,'-property','FontSize'),'FontSize',16)

subplot(122)
boxData = hitRateAll-repmat(hitRateAll(:,2),[1 5]);
boxplot(boxData);
title('normalized to meds')
axis([0.5 5.5 -35 35])
set(gca,'XtickLabel',conditions)
ylabel('Change in Hit Rate (%)')   
set(findall(gcf,'-property','FontSize'),'FontSize',16)

%% plotting intersubject hit rate change bar plots
figure('Position', [100, 100, 700, 500]);
hold on
boxData = hitRateAll(:,1:4);
inBar = nanmean(boxData,1);
inWhisker = nanstd(boxData,1); 
inBridge = zeros(nConds,nConds,1);
inBridge(4,2) = 2;

% plot bar whisker plot
h = barWhiskerBridge(inBar,inWhisker,inBridge);

% set x axis type
h.XTick = [0.7 0.9 1.1 1.3];
h.XTickLabel = conditions(1:4);

% set y axis limits & type
ylim([0 (max(inBar(:))+max(inWhisker(:)))*1.1]);
ylabel('Hit Rate (%)')   

set(findall(gcf,'-property','FontSize'),'FontSize',16)

