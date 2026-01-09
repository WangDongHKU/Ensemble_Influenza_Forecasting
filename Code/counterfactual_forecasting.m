function counterfactual_forecasting(scripts)
close all;
warning('off');load ili_proxy_2010_2020.mat %data 
modelfun = @(d,th) f3(d(:,1),th,d);
load(sprintf('ABase_%d.mat',scripts));
chain1 = chain2; chain1(:,11)=0;PIdataCF_Fore=[];
[outCF,PIdataCF_Fore,CIdataCF]= mcmcpred(results2,chain1,s2chain2,[start:774]',modelfun,nsample);%data.ydata-->data
%% plot
time=774-start+1; %model period
for ith =1:1
ohighfengPICF(1:time,ith)=outCF.obslims{1,1}{1,ith}(2,:);% 95%PI-high limit
obsfengPICF(1:time,ith)=outCF.obslims{1,1}{1,ith}(12,:);%posterior median
olowfengPICF(1:time,ith)=outCF.obslims{1,1}{1,ith}(22,:);% 95%PI-low limit
ohighfengCICF(1:time,ith)=outCF.predlims{1,1}{1,ith}(2,:);% 95%PI-high limit
obsfengCICF(1:time,ith)=outCF.predlims{1,1}{1,ith}(12,:);%posterior median
olowfengCICF(1:time,ith)=outCF.predlims{1,1}{1,ith}(22,:);% 95%PI-low limit
end
ohighfengPICF(1)=A(start);obsfengPICF(1)=A(start);olowfengPICF(1)=A(start);
ohighfengCICF(1)=A(start);obsfengCICF(1)=A(start);olowfengCICF(1)=A(start);
%national cases
yobsfengPICF=sum(obsfengPICF,2);%obs 95CI-median
yobsfenghighPICF=sum(ohighfengPICF,2);%obs 95CI-high
yobsfenglowPICF=sum(olowfengPICF,2);%obs 95CI-low
yobsfengCICF=sum(obsfengCICF,2);%obs 95CI-median
yobsfenghighCICF=sum(ohighfengCICF,2);%obs 95CI-high
yobsfenglowCICF=sum(olowfengCICF,2);%obs 95CI-low
PICF = (out.obslims{1,1}{1,1})';PICF=PICF(1:length(yreal),:);
figure;fillyy(start:774,yobsfenghighPICF,yobsfenglowPICF,[1 0 0],0.12); %obs 95CI
hold on;fillyy(start:774,yobsfenghighCICF,yobsfenglowCICF,[1 0 0],0.2); %obs 95CI
plot(start:722,yreal,'LineStyle','none','color',[0 0.5 0],'Marker','o');%observation
plot(start:774,yobsfengCICF,'LineWidth',1.5);%obs 95CI-median
savefig(sprintf('ABaseCF_Fore_ave_%d',scripts))
save(sprintf('PICF_Fore_ave_%d.mat',scripts),'PIdataCF_Fore')