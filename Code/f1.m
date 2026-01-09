function f1(year)
warning('off');addpath('E:\Dong\SPH Dropbox\Wang Dong\Shared Flu Forecast\Programme\mechanistic\mcmcstat-master'); load ili_proxy_2010_2020.mat %data 
%%  % The model sum of squares given in the model structure.
model.ssfun = @f2;
switch(year)
   case 2010
      start=1;load('chain2_2010.mat');k0=mean(chain2);
   case 2011
      start=50;load('chain2_2011.mat');k0=mean(chain2);
    case 2012
      start=100;load('chain2_2012.mat');k0=mean(chain2);
    case 2013
      start=150;load('chain2_2013.mat');k0=mean(chain2); 
    case 2014
      start=204;load('chain2_2014.mat');k0=mean(chain2);  
    case 2015
      start=252;load('chain2_2015.mat');k0=mean(chain2);   
    case 2016
      start=337;load('chain2_2016.mat');k0=mean(chain2);  
    case 2017
      start=381;load('chain2_2017.mat');k0=mean(chain2);   
    case 2018
      start=412;load('chain2_2018.mat');k0=mean(chain2);
    case 2019
      start=461;load('chain2_2019.mat');k0=mean(chain2);
    case 2020
      start=513;load('chain2_2020.mat');k0=mean(chain2);
    case 2021
      start=565;load('chain2_2021.mat');k0=mean(chain2);
    case 2022
      start=617;load('chain2_2022.mat');k0=mean(chain2);
    case 2023
      start=688;load('chain2_2023.mat');k0=mean(chain2); % 2023,3
     case 2024
      start=703;load('chain2_2024.mat');k0=mean(chain2);
end

%%
% All parameters are constrained to be positive. The initial
% concentrations are also unknown and are treated as extra parameters.

% k0=[0.081841, 0.136087, -0.0264524, 0.501004, 0.340489, 0.00230347, 0.213921, 0.000955222, 0.000187365, 0.176221, 0.000672248, 1.82628, 0.592522, 0.0000122782, 1.70245, 0.00186821, -0.0000522361, 22.0442, 0.330513]


% china_north, [0.276553, 0.155792, 1.65697, 0.00477706, 0.421986, 0.0182068, 0.0192189, 0.0710137];
% china_south, [0.654947, 0.0472383, 6.90344, 0.00301558, 0.124661, 0.0213464, 0.0243519, 0.300362];
% German, [0.365791, 0.410967, 6.67305, 0.0031712, 0.020461, 0.221786, 0.546095, 0.0252451]
% korea,[0.258035, 0.275418, 7.90954, 0.00144435, 0.483631, 0.00464956, 0.00379855, 0.696484]
% sigpore, [0.514191, 0.048196, 8.71376, 0.00340261, 0.141941, 0.022692, 0.0260283, 0.0670715]
% uk, [0.282473, 0.243957, 2.05449, 0.00292768, 0.167218, 0.0123386, 0.0156139, 0.0466187]
% newyork,[0.269916, 0.379948, 1.48367, 0.00281583, 0.402223, 0.0060987, 0.0050792, 0.0342694]
% hk, [0.224925, 0.136418, 0.706765, 0.00674611, 0.0799187, 0.00711283, 0.00866487, 0.858787]
% taiwan,[0.299217, 0.0245319, 0.117985, 0.0135146, 0.428813, 0.00727751, 0.00747045, 0.0246991]
% k0=[0.273548, 0.762019, 0.345556, 0.274901, 0.536848, 0.283493, 0.2673, 0.180337, 0.146883, 0.0518926, 0.364469, 0.200096, 0.0460618, 0.288257, 0.346198, 0.152913, 1.69793, 6.46206, 7.54708, 7.78846, 8.45203, 2.11681, 1.46556, 0.816707, 0.00482647, 0.0028686, 0.0037143, 0.00132064, 0.00321602, 0.00298694, 0.00284306, 0.0109962, 0.413081, 0.121447, 0.0213856, 0.512957, 0.143661, 0.161904, 0.416238, 0.0696411, 0.0158351, 0.01803, 0.20145, 0.00549613, 0.0218208, 0.0108314, 0.0051333, 0.00827618, 0.0225152, 0.0218048, 0.410681, 0.00246011, 0.0273281, 0.0179129, 0.00600773, 0.0119805, 0.077154, 0.312059, 0.0230977, 0.684063, 0.0744099, 0.0419365, 0.0334201, 0.910777];
% k0=reshape(k0',[8,8]);
COUNTRY=1;
for ith=1:5
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('\\beta_{%d}',(ith-1)*COUNTRY+country), k0(ith), -10, 10};
    end
end
for ith=6:6
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('acer1',(ith-1)*COUNTRY+country), k0(ith), 0, 0.1};
    end
end
for ith=7:7
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('S0',(ith-1)*COUNTRY+country), k0(ith), 0.2, 0.9};
    end
end
for ith=8:9
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('p_{%d}',(ith-1)*COUNTRY+country), k0(ith), 0, 0.1};
    end
end
for ith=10:10
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('V0',(ith-1)*COUNTRY+country), k0(ith), 0, 0.3};
    end
end
for ith=11:11
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('NPI_1',(ith-1)*COUNTRY+country), k0(ith), 0, 0.1};% npi effect
    end
end
for ith=12:12
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('Seed_2',(ith-1)*COUNTRY+country), k0(ith), 0, 10^(-3)};% post-pandemic-era
    end
end
for ith=13:13
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('ah_{1}',(ith-1)*COUNTRY+country), k0(ith),0, 10};% post-pandemic-era
    end
end
for ith=14:14
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('ah_{2}',(ith-1)*COUNTRY+country), k0(ith), -10, 0};% post-pandemic-era
    end
end

for ith=15:15
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('T_{exp}',(ith-1)*COUNTRY+country), k0(ith), 0, 10};% post-pandemic-era
    end
end
for ith=16:16
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('O1',(ith-1)*COUNTRY+country), k0(ith), 0, 2};% post-pandemic-era
    end
end
for ith=17:17
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('Ho_{1}',(ith-1)*COUNTRY+country),k0(ith), -2,2};% post-pandemic-era
    end
end
% for ith=21:21
%     for country = 1:COUNTRY
%     params{(ith-1)*COUNTRY+country}={sprintf('ace2',(ith-1)*COUNTRY+country),0.5*k0(6), 0,1.2*k0(6)};% post-pandemic-era
%     end
% end
%%
% We assume having at least some prior information on the
% repeatability of the observation and assign rather non informational
% prior for the residual variances of the observed states. The default
% prior distribution is sigma2 ~ invchisq(S20,N0), the inverse chi
% squared distribution (see for example Gelman et al.). The 3
% components (_A_, _Z_, _P_) all have separate variances.
model.S20 = [4];
model.N0  = [1];

%%
% First generate an initial chain.
options.nsimu = 100000;options.stats = 50001;
% data(:,1)=1:56;
% load('reportedcases.mat')
% load('ili_proxy_2010_2020.mat')
% ILI_data=ILI;
end1=740;
data.ydata=A(start:end1);

data.xdata=[start:start+length(data.ydata)-1];
[results, ~, ~]= mcmcrun(model,data,params,options);
% figure;mcmcplot(chain,[],results); %,'pairs'

%regenerate chain to convergence
options.nsimu = 200000;options.stats = 100001;
[results2, chain2, s2chain2] = mcmcrun(model,data,params,options,results);
figure;mcmcplot(chain2,[],results2); %,'pairs'
savefig(sprintf('ABasePlot_%d',year))

chain2 = chain2(end-19999:end,:);save(sprintf('chain2_%d.mat',year),'chain2','year')

savex(sprintf('ABase_%d.mat',year), 'model', 'modelfun', 'options', 'params', 'results')
%%
% Chain plots should reveal that the chain has converged and we can
% % use the results for estimation and predictive inference.
% figure
% mcmcplot(chain2,[],results2,'denspanel',2);

%%
% Function |chainstats| calculates mean ans std from the chain and
% estimates the Monte Carlfigure
% the integrated autocorrelation time and |geweke| is a simple test
% for a null hypothesis that the chain has converged.

results2.sstype = 1; % needed for mcmcpred and sqrt transformation
chainstats(chain2,results2) %statistic results of parameter estimation

%%
% In order to use the |mcmcpred| function we need
% function |modelfun| with input arguments given as
% |modelfun(xdata,theta)|. We construct this as an anonymous function.
modelfun = @(d,th) f3(d(:,1),th,d);

% We sample 1000 parameter realizations from |chain| and |s2chain|
% and calculate the predictive plots.
nsample = 2000;
[out,PIdata,CIdata]= mcmcpred(results2,chain2,s2chain2,[start:end1+52]',modelfun,nsample);%data.ydata-->data

chain1 = chain2; chain1(:,11)=0;
[outCF,PIdataCF,CIdataCF]= mcmcpred(results2,chain1,s2chain2,[start:end1+52]',modelfun,nsample);%data.ydata-->data
%% plot
time=end1+52-start+1; %model period
m=COUNTRY;  % the number of city
for ith =1:m
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
yreal=data.ydata; %observation
PICF = (out.obslims{1,1}{1,1})';PICF=PICF(1:length(yreal),:);

figure;fillyy(start:end1+52,yobsfenghighPICF,yobsfenglowPICF,[1 0 0],0.12); %obs 95CI
hold on;fillyy(start:end1+52,yobsfenghighCICF,yobsfenglowCICF,[1 0 0],0.2); %obs 95CI
plot(start:start+length(yreal)-1,yreal,'LineStyle','none','color',[0 0.5 0],'Marker','o');%observation
plot(start:end1+52,yobsfengCICF,'LineWidth',1.5);%obs 95CI-median
savefig(sprintf('ABaseCF_%d',year))


%% plot 2 Ssave result data
time=end1+52-start+1; %model period
m=COUNTRY;  % the number of city
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


yreal=data.ydata; %observation
PI = (out.obslims{1,1}{1,1})';PI=PI(1:length(yreal),:);
WIS = weighted_interval_score(PI, yreal)

%% plot
figure;fillyy(start:end1+52,yobsfenghighPI,yobsfenglowPI,[1 0 0],0.12); %obs 95CI
hold on;fillyy(start:end1+52,yobsfenghighCI,yobsfenglowCI,[1 0 0],0.2); %obs 95CI
plot(start:start+length(yreal)-1,yreal,'LineStyle','none','color',[0 0.5 0],'Marker','o');%observation
plot(start:end1+52,yobsfengCI,'LineWidth',1.5);%obs 95CI-median
savefig(sprintf('ABaseNPI_%d',year))
savex(sprintf('ABase_%d.mat',year),  'model', 'modelfun', 'options', 'params', 'results')

hold on;
plot(A)
