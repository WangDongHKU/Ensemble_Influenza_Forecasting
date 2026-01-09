function ss = f2_cross(theta,data)

%sum-of-squares function
COUNTRY=1;
time   = data.xdata;%modeling time period
ydata  = data.ydata;%observed data
xdata  = data.xdata;
ymodel = f3_cross(time,theta,ydata);%model results
% ss =sum((sqrt(ymodel+10^(-18)) - sqrt(ydata(1:length(xdata),1:COUNTRY)+10^(-18))).^2);%sum-of-squares function
ss =sum((log(ymodel+1) - log(ydata(1:length(xdata),1:COUNTRY)+1)).^2);%sum-of-squares function
