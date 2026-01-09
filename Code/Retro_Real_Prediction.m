function Retro_Real_Prediction(scripts)
close all;
warning('off');load ili_proxy_2010_2020.mat %data 
modelfun = @(d,th) f3(d(:,1),th,d);
load(sprintf('ABase_%d.mat',scripts));
results2.sstype = 2;
chain1 = chain2; chain1(:,11)=0;PIdataCF_Fore=[];
[out,PIdata,CIdata]= mcmcpred(results2,chain2,s2chain2,[start:end1+52]',modelfun,nsample);%data.ydata-->data
[outCF,PIdataCF,CIdataCF]= mcmcpred(results2,chain1,s2chain2,[start:774]',modelfun,nsample);%data.ydata-->data
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
savefig(sprintf('ABaseCF_%d',scripts))


time=end1+52-start+1; %model period
m=1;  % the number of city
for ith =1:m
ohighfengPI(1:time,ith)=out.obslims{1,1}{1,ith}(2,:);% 95%PI-high limit
obsfengPI(1:time,ith)=out.obslims{1,1}{1,ith}(12,:);%posterior median
olowfengPI(1:time,ith)=out.obslims{1,1}{1,ith}(22,:);% 95%PI-low limit
ohighfengCI(1:time,ith)=out.predlims{1,1}{1,ith}(2,:);% 95%PI-high limit
obsfengCI(1:time,ith)=out.predlims{1,1}{1,ith}(12,:);%posterior median
olowfengCI(1:time,ith)=out.predlims{1,1}{1,ith}(22,:);% 95%PI-low limit
end
ohighfengPI(1)=A(start);obsfengPI(1)=A(start);olowfengPI(1)=A(start);
ohighfengCI(1)=A(start);obsfengCI(1)=A(start);olowfengCI(1)=A(start);
%national cases
yobsfengPI=sum(obsfengPI,2);%obs 95CI-median
yobsfenghighPI=sum(ohighfengPI,2);%obs 95CI-high
yobsfenglowPI=sum(olowfengPI,2);%obs 95CI-low
yobsfengCI=sum(obsfengCI,2);%obs 95CI-median
yobsfenghighCI=sum(ohighfengCI,2);%obs 95CI-high
yobsfenglowCI=sum(olowfengCI,2);%obs 95CI-low
figure;fillyy(start:end1+52,yobsfenghighPI,yobsfenglowPI,[1 0 0],0.12); %obs 95CI
hold on;fillyy(start:end1+52,yobsfenghighCI,yobsfenglowCI,[1 0 0],0.2); %obs 95CI
plot(start:start+length(yreal)-1,yreal,'LineStyle','none','color',[0 0.5 0],'Marker','o');%observation
plot(start:end1+52,yobsfengCI,'LineWidth',1.5);%obs 95CI-median
savefig(sprintf('ABaseNPI_%d',scripts))

save(sprintf('ABase_%d.mat',scripts))