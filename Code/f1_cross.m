function [WIS1,WIS2,WIS3,WIS4]=f1_cross(k0,Tfrom,Tto)
warning('off');addpath('F:\Dong\mcmcstat-master');load ili_proxy_2010_2020.mat;

COUNTRY=1;
for ith=1:5
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('\\beta_{%d}',(ith-1)*COUNTRY+country), k0(ith), -10, 10};
    end
end
for ith=6:6
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('acer1',(ith-1)*COUNTRY+country), k0(ith), 0, 1};
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
    params{(ith-1)*COUNTRY+country}={sprintf('Seed_2',(ith-1)*COUNTRY+country), k0(ith), 0, 1};% post-pandemic-era
    end
end
for ith=12:12
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('ah_{1}',(ith-1)*COUNTRY+country), 0.017, 0, 1};% post-pandemic-era
    end
end
for ith=13:13
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('ah_{2}',(ith-1)*COUNTRY+country), -0.3, -1, 0};% post-pandemic-era
    end
end
for ith=14:14
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('T_{exp}',(ith-1)*COUNTRY+country), 1, 0, 4};% post-pandemic-era
    end
end
for ith=15:15
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('O1',(ith-1)*COUNTRY+country), 0.15, 0, 1};% post-pandemic-era
    end
end
for ith=16:16
    for country = 1:COUNTRY
    params{(ith-1)*COUNTRY+country}={sprintf('Ho_{1}',(ith-1)*COUNTRY+country),0.3, -2, 2};% post-pandemic-era
    end
end
%%
model.S20 = [4];
model.N0  = [1];
model.ssfun = @f2_cross;

%%
% First generate an initial chain.
options.nsimu = 80000;options.stats = 60001;
load('ili_proxy_2010_2020.mat')
data.ydata=[A(Tfrom:Tto)];%,A(start:end)
data.xdata=[Tfrom:Tto];
[results, ~, ~]= mcmcrun(model,data,params,options);
options.nsimu = 200000;options.stats = 120001;
[results2, chain2, s2chain2] = mcmcrun(model,data,params,options,results);
% chain2 = chain2(end-9999:end,:);
results2.sstype = 1; % needed for mcmcpred and sqrt transformation
chainstats(chain2,results2); %statistic results of parameter estimation
%%
% In order to use the |mcmcpred| function we need
% function |modelfun| with input arguments given as
% |modelfun(xdata,theta)|. We construct this as an anonymous function.
modelfun = @(d,th) f3_cross(d(:,1),th,d);
% We sample 1000 parameter realizations from |chain| and |s2chain|
% and calculate the predictive plots.
nsample = 1000;
results2.sstype = 2;
[~,PIdata,~]= mcmcpred(results2,chain2,s2chain2,[Tfrom:521]',modelfun,nsample);%data.ydata-->data
WIS1=0;WIS2=0;WIS3=0;WIS4=0;
if Tto < (521-7)
WIS1 = weighted_interval_score(PIdata(:,Tto-Tfrom+1:Tto-Tfrom+7)', A(Tto+1:Tto+7));
end
if Tto < (521-13)
WIS2 = weighted_interval_score(PIdata(:,Tto-Tfrom+1:Tto-Tfrom+13)', A(Tto+1:Tto+13));
end
if Tto < (521-26)
WIS3 = weighted_interval_score(PIdata(:,Tto-Tfrom+1:Tto-Tfrom+26)', A(Tto+1:Tto+26));
end
if Tto < (521-52)
WIS4 = weighted_interval_score(PIdata(:,Tto-Tfrom+1:Tto-Tfrom+52)', A(Tto+1:Tto+52));
end


