function [ydot, CS, CV, CR]  = f4_cross(week,theta,ydata)
% t=1:56; %time period 2020/1.11-3.6
COUNTRY = 1;  %number of city 
N = 1;
weeklength = length(ydata);
d = 1*0.00918/365;
Lambda = N*d;%;1518
q1 = 1/450;% 
sigma = 1/2;% 
gamma = 1/7;% 
m = 0.97;%0.97;
q2 = 1/274;
vcf = 0.59;
vc=0;
mu=1;
% seedings = 5*10^(-6);
timeNPI = 4820; % 1 mar 2023 fixed
timeSeeding =4755; % ~  8 jan 2023
postera = 4748; % ~  1 jan 2023

load('NPI.mat');
%NPI(4808:end)=20;
load('AH.mat');
load('Temp.mat');
load('ozone.mat');
load('Ho.mat');
for i = 1:length(theta)/COUNTRY
    for country = 1:COUNTRY
        p(i,country) = theta((i-1)*COUNTRY+country);%
    end
end

for country = 1:COUNTRY
    seedings(country) = p(11,country);
    delay(country) =  3;% 0;%
    ah1(country) =  p(12,country);
    ah2(country) =  p(13,country);
    Texp(country) =  p(14,country);
    o31(country) =  p(15,country);
    Ho1(country) =  p(16,country);
end

%% initialize
CS(week(1)*7-6,:) = p(7,:);
CE(week(1)*7-6,:) = p(8,:);
CI(week(1)*7-6,:) = p(9,:);
CV(week(1)*7-6,:) = p(10,:);
CR(week(1)*7-6,:) = (1-CS(week(1)*7-6,:)-CI(week(1)*7-6,:)-CE(week(1)*7-6,:)-CV(week(1)*7-6,:));

if CR(week(1)*7-6,:)<0
    CR(week(1)*7-6,:)=0;
    total=CS(week(1)*7-6,:)+CE(week(1)*7-6,:)+CI(week(1)*7-6,:)+CV(week(1)*7-6,:)+CR(week(1)*7-6,:);
    CS(week(1)*7-6,:)=CS(week(1)*7-6,:)./total;
    CE(week(1)*7-6,:)=CE(week(1)*7-6,:)./total;
    CI(week(1)*7-6,:)=CI(week(1)*7-6,:)./total;
    CV(week(1)*7-6,:)=CV(week(1)*7-6,:)./total;
end
   
newI0(week(1)*7-6,:) = ydata(1)/7000000.*ones(1,COUNTRY)./p(6,:);
%% iteration 
for day = week(1)*7-5:week(end)*7 %
    if day>5054
        a0 =17.55; a1 =-5.888;b1 =-3.252;w = 0.0172;
        AH(round(day+7-delay),country) = a0 + a1*cos(round((day-delay))*w) + b1*sin(round((day-delay))*w);
        a0 =23.8517; a1 =-5.2062;b1 =-3.9522;w = 0.0172;
        Temp(round(day+7-delay),country) = a0 + a1*cos(round((day-delay))*w) + b1*sin(round((day-delay))*w);
        a0= 43.8700;a1=8.4785; b1=-1.0058;a2=-6.2410;b2=-10.6493;w=0.0172;
        ozone(round(day+7-delay),country) = a0 + a1*cos(round((day-delay))*w) + b1*sin(round((day-delay))*w)+ ...
        a2*cos(2*round((day-delay))*w) + b2*sin(2*round((day-delay))*w);

        daytime = mod(day,365.25)+1;
        AH(round(day+7-delay),country) = mean(AH(round(daytime:365.25:4900)));
        Temp(round(day+7-delay),country) = mean(Temp(round(daytime:365.25:4900)));
        ozone(round(day+7-delay),country) = mean(ozone(round(daytime:365.25:4900)));
    end

    betabase = exp(p(1,:)+p(2,:)*cos(4*pi*day/365.25)+ p(3,:)*sin(4*pi*day/365.25)+p(4,:)*cos(2*pi*day/365.25)+ p(5,:)*sin(2*pi*day/365.25));
    beta_AH = exp(ah1*AH(round(day+7-delay))^2 + ah2*AH(round(day+7-delay)));
    beta_T = exp(-Texp*Temp(round(day+7-delay)));
    beta_O = ozone(round(day+7-delay))^(-o31);
    beta_H = exp(-Ho1*Ho(round(day+7-delay)));
    beta= betabase* beta_AH *beta_T*beta_O*beta_H;
 
if day> 3677 
    mu = exp(-p(11,country)*NPI(round(day-delay)));
end
% if day>3677 && day<4749
% seedings = seedings*mu;
% end

beta=beta*mu;

Vacc_Sea=7+[45*7:57*7,97*7:109*7,144*7:156*7,197*7:209*7,254*7:266*7,306*7:318*7,357*7:369*7,408*7:420*7,459*7:471*7,511*7:523*7,...     
    564*7:576*7,616*7:628*7,668*7:680*7,720*7:733*7];
if ismember(round(day),Vacc_Sea) 
    vc=0.17/91; 
else
    vc=0; 
end

% if day>3661 && day < 3948
%     vc=0;
% end

%% MODELLING 
newS = -(Lambda + q2.*CV(day-1,:)+q1.*CR(day-1,:) - beta.*CS(day-1,:).*CI(day-1,:).^m - (d+vc).*CS(day-1,:) - 0.00);
newS = min(CS(day-1,:),newS);
CS(day,:) = CS(day-1,:) - newS;

newE = -(beta.*(CS(day-1,:)+(1-vcf)*CV(day-1,:)).*CI(day-1,:).^m  - (d+sigma).*CE(day-1,:));
newE = min(CE(day-1,:),newE);
CE(day,:) = CE(day-1,:) - newE;

newI = -(sigma.*CE(day-1,:) - (d+gamma).*CI(day-1,:) + seedings);
newI = min(CI(day-1,:),newI);
CI(day,:) = CI(day-1,:) - newI;

newR = -(gamma.*CI(day-1,:)-(q1+d).*CR(day-1,:));
newR = min(CR(day-1,:),newR);
CR(day,:) = CR(day-1,:) - newR;

newV = -(vc.*CS(day-1,:) - (1-vcf).*beta.*CV(day-1,:).*CI(day-1,:).^m - (q2+d).*CV(day-1,:));
newV = min(CV(day-1,:),newV);
CV(day,:) = CV(day-1,:) - newV;

%% NORMALIZATION
newtotal=CS(day,:)+CE(day,:)+CI(day,:)+CR(day,:)+CV(day,:);
CS(day,:)=CS(day,:)./newtotal;
CE(day,:)=CE(day,:)./newtotal;
CI(day,:)=CI(day,:)./newtotal;
CR(day,:)=CR(day,:)./newtotal;
CV(day,:)=CV(day,:)./newtotal;

% newI0(day,:) = acertainment_rate(country).*sigma.*CE(day-1,:);
newI0(day,:) = sigma.*CE(day,:);

end

%
% newILI(week(1),:)=newI0(week(1)*7-6,:);
newILI(week(1):week(end),:)=0;
for weekind = 1:length(week)
    for day = week(weekind)*7-6:week(weekind)*7
        newILI(week(weekind),:) = newILI(week(weekind),:) + newI0(day,:).*p(6,:);     
    end
end

ydot=[newILI(week(1):week(end),:)];






% %% model
% %suspecitble population
% HS(i,:)=HS(i-1,:)-(afa*beta.*HIa(i-1,:)+beta.*HI(i-1,:)+beta_s*beta.*HLp(i-1,:)).*HS(i-1,:)./HN(i-1,:)+imcity_s'-imcityout_s;
% %asymptomatic population
% HLa(i,:)=HLa(i-1,:)+p*((afa*beta.*HIa(i-1,:)+beta.*HI(i-1,:)+beta_s*beta.*HLp(i-1,:)).*HS(i-1,:)./HN(i-1,:)+importI)-imcityout_la+imcity_la'-sigma_a*HLa(i-1,:); %latent
% HIa(i,:)=HIa(i-1,:)+sigma_a*HLa(i-1,:)-gamma.*HIa(i-1,:)-imcityout_ia+imcity_ia';%infectious
% %symptomatic population
% HLs(i,:)=HLs(i-1,:)+(1-p)*((afa*beta.*HIa(i-1,:)+beta.*HI(i-1,:)+beta_s*beta.*HLp(i-1,:)).*HS(i-1,:)./HN(i-1,:)+importI)-imcityout_ls+imcity_ls'-sigma_s*HLs(i-1,:);%latent
% HLp(i,:)=HLp(i-1,:)+sigma_s*HLs(i-1,:)-sigma_pre*HLp(i-1,:)-imcityout_lp+imcity_lp';%presymtomatic
% HI(i,:)=HI(i-1,:)+sigma_pre*HLp(i-1,:)-gamma_s.*HI(i-1,:); %infectious
% % removed population
% HR(i,:)=HR(i-1,:)+gamma_s.*HI(i-1,:)+gamma.*HIa(i-1,:);
% %all population
% HN(i,:)=HS(i,:)+HLa(i,:)+HIa(i,:)+HLs(i,:)+HLp(i,:)+HI(i,:)+HR(i,:); 
% %daily confirmed cases
% I(i,:)=gamma_s.*HI(i-1,:);
% 
% end
% 
% ydot=[I(:,:)];
 

