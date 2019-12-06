%% Data extraction
clc
clear all
close all

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

%load files
[DataNum,DataText] = xlsread('DataInformation');
[VarNum,VarText] = xlsread('VariableInformation');
%FileNames{:}=InfoText{2:end,2};

for k=[1:11]

load(strcat(DataText{k+1,2},'.mat'));

for i=1:VarNum(end,1)
Data{1,k}=eval(strcat(DataText{k+1,2},'.X(1).Data(2501:87501)'))-eval(strcat(DataText{k+1,2},'.X(1).Data(2501)'))
Data{i+1,k}=eval(strcat(DataText{k+1,2},'.Y(i).Data(2501:87501)'));
end


Info{k}=strcat('DataEntry = ',num2str(k),'DataName',DataText{k+1,2},',','Note: ',DataText{k+1,3})
%Info{k}=strcat('DataEntry = ',num2str(k),',',' DataName',DataText{k+1,2},',',' Amplitude=', ...
 %num2str(DataText(k,2)),',',' Frequency=');%num2str(InfoNum(k,4)),',',' Bias=',num2str(InfoNum(k,5)));

%% Biasing data
%Data{1,k}=Data{1,k}-Data{1,k}(1);
%Data{2,k}=Data{2,k}-Data{2,k}(1);

end 

    for k=[1:11]
            for j=1:length(Data{1,k})
u=[cos(Data{14,k}(j)),sin(Data{14,k}(j))];
v=[cos(Data{19,k}(j)),sin(Data{19,k}(j))];
thetaerr(k,j)=acos(u(1)*v(1)+u(2)*v(2))/(norm(u)*norm(v))*180/pi;
cross = v(1)*u(2)-v(2)*u(1);
thetaerr(k,j) = thetaerr(k,j)*sign(cross);
            end 
    end
%%
k=10;
i=5;
SS1=10000; SS2=15000; SS3=40000; SS4=45000;
DCoffsetLo=sum(Data{i+1,k}(SS1:SS2))
DCoffsetHi=sum(Data{i+1,k}(SS3:SS4))

averageHi=(max(Data{i+1,k}(SS1:SS2))+min(Data{i+1,k}(SS1:SS2)))/2
averageLo=(max(Data{i+1,k}(SS3:SS4))+min(Data{i+1,k}(SS3:SS4)))/2
%%
SS1=10000; SS2=11000; SS3=42500; SS4=45000;
for k=[1:11]
AngleAvg(k)= mean(thetaerr(k,SS1:SS2));
AngleVar(k)= (max(thetaerr(k,SS1:SS2))-min(thetaerr(k,SS1:SS2)))/2;
RMSE(k) = sqrt(mean((Data{10+1,k} - Data{9+1,k}).^2))  % Root Mean Squared Error

CollectedHS(k,:)=[k,RMSE(k),AngleAvg(k),AngleVar(k)]
plot(Data{10+1,k} - Data{9+1,k});
end
%%
for k=[10]
AngleAvg(k)= mean(thetaerr(k,SS3:SS4));
AngleVar(k)= (max(thetaerr(k,SS3:SS4))-min(thetaerr(k,SS3:SS4)))/2;
RMSE(k) = sqrt(mean((Data{10+1,k} - Data{9+1,k}).^2))  % Root Mean Squared Error

CollectedLS(k,:)=[k,RMSE(k),AngleAvg(k),AngleVar(k)]
%plot(Data{10+1,k} - Data{9+1,k});
end
%% Theta and speed error
SS1=10000; SS2=11000; SS3=42500; SS4=45000;
close all
LegFS=15;
AxLFS=15;
for k=[11] %4,5
    name=DataText(k+1,4)
    figure
    set(gcf,'Position', [10 10 1000 1420]);
    %grid on
    %box on
    j=1;
   %subplot(2,1,1)
axes('position',[.1 .75 .85 .2])
    for i=[17,9,10]
        legstr(j)={VarText(i,1)};
        plot(Data{1,k},Data{i+1,k},'DisplayName',legstr{j}{1})
        ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        j=j+1;
        legend('show','fontsize',LegFS)
        grid on; box on; hold on;
           ylim([0 1500])
    end
  %title(name{1})  

 axes('position',[.1 .52 .40 .17])
box on % put box around new pair of axes
    for i=[17,9,10]
         legstr(j)={VarText(i,1)};
plot(Data{1,k}(SS1:SS2),Data{i+1,k}(SS1:SS2),'DisplayName',legstr{j}{1}) % plot on new axes
j=j+1;
axis tight; grid on; box on; hold on;
    end
            ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);

axes('position',[.555 .52 .40 .17])
box on % put box around new pair of axes
    for i=[17,9,10]
         legstr(j)={VarText(i,1)};
plot(Data{1,k}(SS3:SS4),Data{i+1,k}(SS3:SS4),'DisplayName',legstr{j}{1}) % plot on new axes
j=j+1;
axis tight; grid on; box on; hold on;
    end
            ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);
    
    
 axes('position',[.1 .30 .40 .17])
box on % put box around new pair of axes
    for i=[5,7]%11,16
         legstr(j)={VarText(i,1)};
x1=2;x2=2.2;y=0;
line([x1 x2], [y y],'linewidth',1,'color','black','HandleVisibility','off');
plot(Data{1,k}(SS1:SS2),Data{i+1,k}(SS1:SS2),'DisplayName',legstr{j}{1}) % plot on new axes
j=j+1;
axis tight; grid on; box on; hold on;
    end
            ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);


axes('position',[.555 .30 .40 .17])
box on % put box around new pair of axes
    for i=[5,7]%%11,16
                x1=8.5;x2=9;y=0;
line([x1 x2], [y y],'linewidth',1,'color','black','HandleVisibility','off');
         legstr(j)={VarText(i,1)};
plot(Data{1,k}(SS3:SS4),Data{i+1,k}(SS3:SS4),'DisplayName',legstr{j}{1}) % plot on new axes
j=j+1;

axis tight; grid on; box on; hold on;
    end    
            ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);

axes('position',[.1 .08 .40 .17])
box on % put box around new pair of axes

plot(Data{1,k}(SS1:SS2),thetaerr(k,SS1:SS2)) % plot on new axes
j=j+1;
axis tight; grid on; box on; hold on;

        ylabel(strcat('Angle Est. Err.',' ','[deg]'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('$\theta_{est,err}$','fontsize',LegFS);

axes('position',[.555 .08 .40 .17])
box on % put box around new pair of axes
plot(Data{1,k}(SS3:SS4),thetaerr(k,SS3:SS4)) % plot on new axes
axis tight; grid on; box on; hold on;
        ylabel(strcat('Angle Est. Err.',' ','[deg]'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('$\theta_{est,err}$','fontsize',LegFS);

dim = [.195 .918 .01 .01]; %Left box
annotation('rectangle',dim,'Color','red','linewidth',2)    
dim = [.5 .776 .025 .03]; % Right box
annotation('rectangle',dim,'Color','red','linewidth',2)

   pos = [10 10 1000 1420];
set(gcf,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3)-300, pos(4)-850])
print(gcf,name{1},'-dpdf','-r0'); 
hold off
end



%%

%% Theta and speed error
SS1=14800; SS2=16800; SS3=44800; SS4=46800;

close all
LegFS=15;
AxLFS=15;
for k=[5] %4,5
    name=DataText(k+1,4)
    figure
    set(gcf,'Position', [10 10 1000 1420]);
    %grid on
    %box on
    j=1;
   %subplot(2,1,1)
axes('position',[.1 .75 .85 .2])
    for i=[17,9,10]
        legstr(j)={VarText(i,1)};
        plot(Data{1,k},Data{i+1,k},'DisplayName',legstr{j}{1})
        ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        j=j+1;
        legend('show','fontsize',LegFS)
        grid on; box on; hold on;
           ylim([0 1500])
    end
  %title(name{1})  

 axes('position',[.1 .52 .40 .17])
box on % put box around new pair of axes
    for i=[17,9,10]
         legstr(j)={VarText(i,1)};
plot(Data{1,k}(SS1:SS2),Data{i+1,k}(SS1:SS2),'DisplayName',legstr{j}{1}) % plot on new axes
j=j+1;
axis tight; grid on; box on; hold on;
    end
            ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);

axes('position',[.555 .52 .40 .17])
box on % put box around new pair of axes
    for i=[17,9,10]
         legstr(j)={VarText(i,1)};
plot(Data{1,k}(SS3:SS4),Data{i+1,k}(SS3:SS4),'DisplayName',legstr{j}{1}) % plot on new axes
j=j+1;
axis tight; grid on; box on; hold on;

    end
            ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);
    
    
 axes('position',[.1 .30 .40 .17])
box on % put box around new pair of axes
    for i=[13,18]
         legstr(j)={VarText(i,1)};
plot(Data{1,k}(SS1:SS2),Data{i+1,k}(SS1:SS2),'DisplayName',legstr{j}{1}) % plot on new axes
j=j+1;
axis tight; grid on; box on; hold on;
    end
            ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);

axes('position',[.555 .30 .40 .17])
box on % put box around new pair of axes
    for i=[13,18]
         legstr(j)={VarText(i,1)};
plot(Data{1,k}(SS3:SS4),Data{i+1,k}(SS3:SS4),'DisplayName',legstr{j}{1}) % plot on new axes
j=j+1;
axis tight; grid on; box on; hold on;
    end    
            ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);

axes('position',[.1 .08 .40 .17])
box on % put box around new pair of axes

plot(Data{1,k}(SS1:SS2),thetaerr(k,SS1:SS2)) % plot on new axes
j=j+1;
axis tight; grid on; box on; hold on;

        ylabel(strcat('Angle Est. Err.',' ','[deg]'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('$\theta_{est,err}$','fontsize',LegFS);

axes('position',[.555 .08 .40 .17])
box on % put box around new pair of axes
plot(Data{1,k}(SS3:SS4),thetaerr(k,SS3:SS4)) % plot on new axes
axis tight; grid on; box on; hold on; 
        ylabel(strcat('Angle Est. Err.',' ','[deg]'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('$\theta_{est,err}$','fontsize',LegFS);


dim = [.52 .763 .02 .045]; % Anything else right box
annotation('rectangle',dim,'Color','red','linewidth',2)
dim = [.234 .899 .02 .035]; %Left box
annotation('rectangle',dim,'Color','red','linewidth',2)   % end 

   pos = [10 10 1000 1420];
set(gcf,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3)-300, pos(4)-850])
print(gcf,strcat(name{1},'_transient'),'-dpdf','-r0'); 
hold off
end
%-----------------------------------------%
%% Sensored (Real Measurements)
%% Theta and speed error
SS1=10000; SS2=11000; SS3=40000; SS4=41000;
t1=15000; t2=18000; t3=45000; t4=48000;
close all
LegFS=15;
AxLFS=15;
for k=[8,9] %4,5
    legstr={'$n_{ref}$','$n_{meas}$'};
    name=DataText(k+1,4)
    figure
    set(gcf,'Position', [10 10 1000 1000]);
j=1;
axes('position',[.1 .7 .85 .22])
    for i=[8,15]
        h(j)=plot(Data{1,k},Data{i+1,k},'DisplayName',legstr{j});
        ylabel(strcat('Speed',' ','[rpm]'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);
        grid on; box on; hold on;
        j=j+1;
        ylim([0 1500])
    end
    
   set(h(1),'linewidth',1.5);
   set(h(2),'linewidth',1.5);
 axes('position',[.1 .40 .40 .22])
box on % put box around new pair of axes
j=1;
    for i=[8,15]
         
h(j)=plot(Data{1,k}(SS1:SS2),Data{i+1,k}(SS1:SS2),'DisplayName',legstr{j}); % plot on new axes
j=j+1;
axis tight;grid on;box on;
hold on
    end
        ylabel(strcat('Speed',' ','[rpm]'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);
   set(h(1),'linewidth',2);
axes('position',[.555 .4 .40 .22])


j=1;
    for i=[8,15]

h(j)=plot(Data{1,k}(SS3:SS4),Data{i+1,k}(SS3:SS4),'DisplayName',legstr{j}); % plot on new axes
j=j+1;
axis tight;grid on;box on;
hold on
    end
        ylabel(strcat('Speed',' ','[rpm]'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);
        set(h(1),'linewidth',1.5);
        
 axes('position',[.1 .13 .40 .22])

j=1;
    for i=[8,15]
         
h(j)=plot(Data{1,k}(t1:t2),Data{i+1,k}(t1:t2),'DisplayName',legstr{j}); % plot on new axes
j=j+1;
axis tight;grid on;box on;
hold on
    end
        ylabel(strcat('Speed',' ','[rpm]'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS,'location','best');
   set(h(1),'linewidth',2);
axes('position',[.555 .13 .40 .22])


j=1;
    for i=[8,15]

h(j)=plot(Data{1,k}(t3:t4),Data{i+1,k}(t3:t4),'DisplayName',legstr{j}); % plot on new axes
j=j+1;
axis tight;grid on;box on;
hold on
    end
        ylabel(strcat('Speed',' ','[rpm]'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS,'location','best');
        set(h(1),'linewidth',1.5);        
        
           
dim = [.195 .88 .01 .02]; %Left box steady state
annotation('rectangle',dim,'Color','red','linewidth',2)   % end  

dim = [.475 .73 .01 .02]; % right box steady state
annotation('rectangle',dim,'Color','red','linewidth',2)

dim = [.24 .87 .03 .03]; %Left box transient
annotation('rectangle',dim,'Color','red','linewidth',2)   % end  

dim = [.52 .72 .03 .03]; % right box transient
annotation('rectangle',dim,'Color','red','linewidth',2)
  
   pos = [10 10 1000 600];
set(gcf,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3)-300, pos(4)-70])
print(gcf,name{1},'-dpdf','-r0'); 
hold off           

end
%% IF and Profile




%%


%%
k=6;
name=DataText(k+1,4)
    legstr={'$n_{ref}$','$n_{meas}$'};
LegFS=15;
AxLFS=15;
figure
 set(gcf,'Position', [10 10 1000 300]);
 j=1;
for i=[8,9]
    grid on;box on;
    
   plot(Data{1,k}(1:end-50000),Data{i+1,k}(1:end-50000),'DisplayName',legstr{j});
   j=j+1;
   hold on
end
        ylabel(strcat('Speed',' ','[rpm]'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'),'fontsize',AxLFS);
        legend('show','fontsize',LegFS,'location','best');
   
   pos = [10 10 1000 300];
set(gcf,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3)-300, pos(4)-70])
print(gcf,name{1},'-dpdf','-r0'); 

%%
SS1=10000; SS2=11000; SS3=40000; SS4=41000;
t1=15000; t2=18000; t3=45000; t4=48000;
close all
LegFS=15;
AxLFS=15;

for k=[20]
    name=DataText(k+1,4)
    figure
    set(gcf,'Position', [10 10 1000 700]);
    grid on
    box on
   
j=1;

subplot(2,2,1)
       j=1;
for i=[2,4]
     legstr(j)={VarText(i,1)};
        plot(Data{1,k}(SS1:SS2),Data{i+1,k}(SS1:SS2),'DisplayName',legstr{j}{1}) % plot on new axes)
                grid on; box on; hold on;
        j=j+1;
end
        ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);

subplot(2,2,2)
j=1;
for i=[2,4]
        legstr(j)={VarText(i,1)};
        plot(Data{1,k}(SS3:SS4),Data{i+1,k}(SS3:SS4),'DisplayName',legstr{j}{1}) % plot on new axes)
                grid on; box on; hold on;
        j=j+1;
end
        ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        
        legend('show','fontsize',LegFS);

subplot(2,2,3)
j=1;
for i=[5,6,17]

   legstr(j)={VarText(i,1)};
   plot(Data{1,k}(SS1:SS2),Data{i+1,k}(SS1:SS2),'DisplayName',legstr{j}{1}) % plot on new axes)
           grid on; box on; hold on;
   j=j+1;
end
        ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);

subplot(2,2,4)
j=1;
for i=[5,6,17]
        legstr(j)={VarText(i,1)};
        plot(Data{1,k}(SS3:SS4),Data{i+1,k}(SS3:SS4),'DisplayName',legstr{j}{1}) % plot on new axes)
                grid on; box on; hold on;
        j=j+1;
end
        ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        
        legend('show','fontsize',LegFS);

set(gca,'XTickLabel',cellstr(num2str(get(gca,'XTick')'))) 
set(gca,'YTickLabel',cellstr(num2str(get(gca,'YTick')'))) 
  
%set(gcf,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3)-300, pos(4)-240])
print(gcf,strcat(name{1},'_var'),'-dpdf','-r0'); 
hold off
end

%% 
figure

for k=[9,10,11]
subplot(3,2,(k-8))
j=1;
for i=[5,6,17]

   legstr(j)={VarText(i,1)};
   plot(Data{1,k}(SS1:SS2),Data{i+1,k}(SS1:SS2),'DisplayName',legstr{j}{1}) % plot on new axes)
           grid on; box on; hold on;
   j=j+1;
end
        ylabel(strcat(VarText(i,3),' ',VarText(i,2)),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);
end


%% Angle error over whole profile
%% Theta and speed error
SS1=10000; SS2=11000; SS3=40000; SS4=41000;
t1=15000; t2=18000; t3=45000; t4=48000;
close all
LegFS=15;
AxLFS=15;

    legstr={'$\theta_{est} \,\,\, lagging \,\,\, \theta_{act} $'};
    

    
    figure(1)
    set(gcf,'Position', [10 10 1000 400]);

axes('position',[.1 .15 .85 .8])
   for k=[9,10,11]
name=DataText(k+1,4)
       h(k)=plot(Data{1,k}(:)',thetaerr(k,1:end),'DisplayName',name{1},'linewidth',1.5);
       ErrNorm(k)=sum(abs(thetaerr(k,1:end)));
               grid on; box on; hold on;
   end
        ylabel(strcat('Angle err',' ','[deg]'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'));
        legend('show','fontsize',LegFS);
set(h(5:8),'linewidth',0.1);
ylim([-20 60])
xlim([0 8])

   pos = [10 10 1000 600];
set(gcf,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3)-300, pos(4)-70])
print(gcf,strcat(name{1},'_thetaerr'),'-dpdf','-r0'); 
hold off




%% Theta and speed error
SS1=10000; SS2=11000; SS3=40000; SS4=41000;
t1=15000; t2=18000; t3=45000; t4=48000;
close all
LegFS=20;
AxLFS=15;

    legstr={'$\epsilon$=10','$\epsilon$=2.5'};

    figure(1)
    set(gcf,'Position', [10 10 1000 400]);

axes('position',[.1 .15 .85 .8])
j=1;
   for k=[6,8]
name=DataText(k+1,4)
       h(k)=plot(Data{1,k}(:)',thetaerr(k,1:end),'DisplayName',legstr{j});
       ErrNorm(k)=sum(abs(thetaerr(k,1:end)));
               grid on; box on; hold on;
               j=j+1;
   end
        ylabel(strcat('$\theta_{est} \,\,\, lagging \,\,\, \theta_{act}\,\,\, [deg]$'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'),'fontsize',AxLFS);
        legend('show','fontsize',LegFS);
set(h(6),'linewidth',0.5);
set(h(8),'linewidth',0.5);
ylim([-10 40])
xlim([0 8])

   pos = [10 10 1000 600];
set(gcf,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3)-300, pos(4)-300])
print(gcf,'Epsilon10nEpsilon2_5','-dpdf','-r0'); 
hold off

%%
%% Theta and speed error
SS1=10000; SS2=11000; SS3=40000; SS4=41000;
t1=15000; t2=18000; t3=45000; t4=48000;
close all
LegFS=20;
AxLFS=15;

    legstr={'$k_{add}=10$','$k_{add}=20$','$k_{add}=40$'};

    figure(1)
    set(gcf,'Position', [10 10 1000 400]);

axes('position',[.1 .15 .85 .8])
j=1;
   for k=[9,10,11]
name=DataText(k+1,4)
if k==9
     Data{1,k}(10000)=NaN;
     thetaerr(k,10000)=NaN;
     Data{1,k}(30000)=NaN;
     thetaerr(k,30000)=NaN;
     h(k)=plot(Data{1,k}([1:10000, 10000:15000, 30000:end])',thetaerr(k,[1:10000, 10000:15000, 30000:end]),'DisplayName',legstr{j});
end
if k==10
     Data{1,k}(17500)=NaN;
     thetaerr(k,17500)=NaN;
     Data{1,k}(30000)=NaN;
     thetaerr(k,30000)=NaN;
     h(k)=plot(Data{1,k}([1:10000, 17500:22500, 30000:end])',thetaerr(k,[1:10000, 17500:22500, 30000:end]),'DisplayName',legstr{j});
end
if k==11
     Data{1,k}(25000)=NaN;
     thetaerr(k,25000)=NaN;
          Data{1,k}(30000)=NaN;
     thetaerr(k,30000)=NaN;
     h(k)=plot(Data{1,k}([1:10000, 25000:30000, 30000:end])',thetaerr(k,[1:10000, 25000:30000, 30000:end]),'DisplayName',legstr{j});
end
      
       ErrNorm(k)=sum(abs(thetaerr(k,1:end)));
               grid on; box on; hold on;
               j=j+1;
   end
        ylabel(strcat('$\theta_{est} \,\,\, lagging \,\,\, \theta_{act}\,\,\, [deg]$'),'fontsize',AxLFS);
        xlabel(strcat('time',' ','[s]'),'fontsize',AxLFS);
        legend('show','fontsize',LegFS);
set(h(9),'linewidth',0.5);
set(h(10),'linewidth',0.5);
set(h(11),'linewidth',0.5);
ylim([-10 25])
xlim([0 8])

   pos = [10 10 1000 600];
set(gcf,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3)-300, pos(4)-300])
print(gcf,'k_add102040','-dpdf','-r0'); 
hold off



 



