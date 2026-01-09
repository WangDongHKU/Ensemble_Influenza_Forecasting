function f1_cross_main()
Tfrom=[1:52:365];
k0=[];
scripts = [2010:2017];
for job = 1:length(scripts)
    load (sprintf('chain2_%d',scripts(job)));
    chain2(:,11)=[];
    k0(job,:)=mean(chain2);
end

WIS1=zeros(14,8);WIS2=zeros(14,8);WIS3=zeros(14,8);WIS4=zeros(14,8);

parfor window = 1:14
    for j=1:8
        [WIS1(window,j),WIS2(window,j),WIS3(window,j),WIS4(window,j)]=f1_cross(k0(j,:),Tfrom(j)+7*(window-1),417+7*(window-1));
    end
end

save cross_WIS.mat
