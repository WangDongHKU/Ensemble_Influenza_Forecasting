function [interval]= modelPI(newIC)
newIC=newIC';
sigma=std(newIC);
low=min(newIC)-1.96*sigma;
low=max(low,0);
upper=max(newIC)+1.96*sigma;

interval=cat(2,low,flipdim(upper,2));
