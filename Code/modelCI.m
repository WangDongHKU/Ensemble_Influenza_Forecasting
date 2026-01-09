function [fy,fx,Mean]= modelCI(day,X)

lims=[0.025,0.975];
 
for i=1:length(day)
b=mean(X(i,:)); % 计算均值
a1=sort(X(i,:)); % 排序
b_ci=[a1(ceil(length(a1)*0.025)); a1(floor(length(a1)*0.975))]; % 计算2.5%和97.5%的分位点，即95%置信区间
% b_ci = plims(a1,lims);
% b_ci=[a1(1); a1(end)]; % 计算2.5%和97.5%的分位点，即95%置信区间
Mean(i)=b;
meanci(:,i)=b_ci;
end

% meanci = plims(X,lims);
% Mean= mean(X,2);

f=zeros(length(Mean),2);
i=1;
for t = day
f(i,1)=max([meanci(1,i),meanci(2,i)]); 
f(i,2)=min([meanci(1,i),meanci(2,i)]);
i=i+1;
end
t = day;
fy=cat(2,f(:,1)',flipdim(f(:,2),1)');
fx=cat(2,t,flipdim(t',1)');