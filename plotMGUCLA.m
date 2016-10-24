function plotMGUCLA
load processedDataTable.mat
close all

%% plotting hit rate for each group across phases 
figure('Position', [100, 100, 800, 500]);
hold on
h = cell(nSubs,1);
for sub = 1:nSubs
    if subGroup(sub)==1
        h{sub} = plot(1:4,hitRateAll(sub,:),...
             'x-k','markers',16,'LineWidth',2); 
    else
        h{sub} = plot(1:4,hitRateAll(sub,:),...
             'o-b','markers',16,'LineWidth',2);
    end
    legend([h{1} h{4}], '1:Meds  2: Stim','1:Stim  2:Meds');
    axis([0.5 4.5 -5 100])
    set(gca,'Xtick',1:4)
    set(gca,'XtickLabel',{'phase 1','phase 2','Meds+Stim','Follow-Up'})
    ylabel('Hit Rate (%)')   
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
end

%% plotting change in hit rate for each group across phases 
figure('Position', [900, 100, 800, 500]);
hold on
h = cell(nSubs,1);
for sub = 1:nSubs
    if subGroup(sub)==1
        h{sub} = plot(1:4,hitRateAll(sub,:)-hitRateAll(sub,1),...
            'x-k','markers',16,'LineWidth',2); 
    else
        h{sub} = plot(1:4,hitRateAll(sub,:)-hitRateAll(sub,1),...
            'o-b','markers',16,'LineWidth',2);
    end
    legend([h{1} h{4}], '1:Meds  2: Stim','1:Stim  2:Meds',...
        'Location','Northwest');
    axis([0.5 4.5 -30 30])
    set(gca,'Xtick',1:4)
    set(gca,'XtickLabel',{'phase 1','phase 2','Meds+Stim','Follow-Up'})
    ylabel('Change in Hit Rate (%)')   
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
end

%% plotting latency 
figure('Position', [100, 600, 800 500]);
hold on 
h = cell(nSubs,1);
for sub = 1:nSubs
    if subGroup(sub)==1
        h{sub} = plot(1:4,latency(sub,:),...
            'x-k','markers',16,'LineWidth',2); 
    else
        h{sub} = plot(1:4,latency(sub,:),...
            'o-r','markers',16,'LineWidth',2);
    end
    legend([h{1} h{4}], '1:Meds  2: Stim','1:Stim  2:Meds',...
        'Location','Best');
    xlim([0.5 4])
    set(gca,'Xtick',1:4)
    set(gca,'XtickLabel',{'phase 1','phase 2','Meds+Stim','Follow-Up'})
    ylabel('Mean Latency (ms)')   
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
end

%% plotting latency variance
figure('Position', [900, 600, 800 500]);
hold on 
h = cell(nSubs,1);
for sub = 1:nSubs
    if subGroup(sub)==1
        h{sub} = plot(1:4,lateVar(sub,:),...
            'x-k','markers',16,'LineWidth',2); 
    else
        h{sub} = plot(1:4,lateVar(sub,:),...
            'o-m','markers',16,'LineWidth',2);
    end
    legend([h{1} h{4}], '1:Meds  2: Stim','1:Stim  2:Meds',...
        'Location','Best');
    xlim([0.5 4])
    set(gca,'Xtick',1:4)
    set(gca,'XtickLabel',{'phase 1','phase 2','Meds+Stim','Follow-Up'})
    ylabel('Standard Dev. of Latency (ms)')   
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
end

