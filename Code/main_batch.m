clear;
% address={'_1Base','_2Base+AH','_2Base+H','_2Base+O','_2Base+T','_3Base+AH+H','_3Base+AH+O','_3Base+AH+T','_3Base+O+H','_3Base+T+H',...
%     '_3Base+T+O','_4Base+AH+O+H','_4Base+AH+T+H','_4Base+AH+T+O','_4Base+T+O+H','_5Base+AH+T+O+H'};
address={'_5Base+AH+T+O+H',}
scripts = [2010:2019];

i=0;
for number = 1:numel(address)
    cd ('F:\Dong\SPH Dropbox\Wang Dong\PC\_4_modeling_end_1')
    cd (address{number});
    for job = 1:length(scripts)
    addpath('F:\Dong\mcmcstat-master')
    batch(sprintf('f1(%d)',scripts(job)));  
    i=i+1
    end
end

%% 
clear;address={'_5Base+AH+T+O+H'};scripts = [2019:-1:2010];
for number = 1:numel(address)
   % cd ('F:\Dong\SPH Dropbox\Wang Dong\PC\_4_modeling_end')
    cd('C:\Users\Dong\SPH Dropbox\Wang Dong\PC\_4_modeling_end_1')
    cd (address{number}); % open('f1')
    for j=1:10
        close all
modelfun = @(d,th) f3(d(:,1),th,d);
load(sprintf('ABase_%d.mat',scripts(j)));
chain1 = chain2; chain1(:,11)=0;
[outCF,PIdataCF_Fore,CIdataCF]= mcmcpred(results2,chain1,s2chain2,[start:759]',modelfun,nsample);%data.ydata-->data
%% plot
time=759-start+1; %model period
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
figure;fillyy(start:759,yobsfenghighPICF,yobsfenglowPICF,[1 0 0],0.12); %obs 95CI
hold on;fillyy(start:759,yobsfenghighCICF,yobsfenglowCICF,[1 0 0],0.2); %obs 95CI
plot(start:707,yreal,'LineStyle','none','color',[0 0.5 0],'Marker','o');%observation
plot(start:759,yobsfengCICF,'LineWidth',1.5);%obs 95CI-median
savefig(sprintf('ABaseCF_Fore_%d',scripts(j)))
save(sprintf('PICF_Fore_%d.mat',scripts(j)),'PIdataCF_Fore')
    end
end


%% get transmission rate
scripts = [2010:2019];
for job = 1:length(scripts)
load(sprintf('chain2_%d.mat',scripts(job)))
F_effective_reproductive_number(chain2,scripts(job))
end

close all






