clear all; close all;
%% time period: E2 2019.03.25-2019.04.11
ic_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 2\DATA\psp_isois-epilo_l2-ic_20190330_v08.cdf');
Epoch = spdfcdfread('C:\STUDY\PSP\Encounter 2\DATA\psp_isois-epilo_l2-ic_20190330_v08.cdf','Variables','Epoch_ChanT');
% 1039-epoch; 47-energy; 3-componments; 80-direction
H_ChanT_Energy = spdfcdfread('C:\STUDY\PSP\Encounter 2\DATA\psp_isois-epilo_l2-ic_20190330_v08.cdf','Variables','H_ChanT_Energy');
% H_ChanT_Energy(80*47*1039,first 31 bins): second-direction 21st:93.6, 25th:45.7 (Unit:keV)
RTN_ChanT = spdfcdfread('C:\STUDY\PSP\Encounter 2\DATA\psp_isois-epilo_l2-ic_20190330_v08.cdf','Variables','RTN_ChanT');
H_Flux_ChanT = spdfcdfread('C:\STUDY\PSP\Encounter 2\DATA\psp_isois-epilo_l2-ic_20190330_v08.cdf','Variables','H_Flux_ChanT');
% first-direction: 17,27,68,70,80; which are from-sun and toward-sun?
dir_eg = squeeze(RTN_ChanT(:,:,1));

temp = zeros(1039,1);
for i = 21:25
    temp = temp + squeeze(H_Flux_ChanT(68,i,:));
end
temp(find(abs(temp)>1e10)) = 1; temp(find(temp<0.1)) = 1;
semilogy(Epoch,temp)
hold on
grid on
datetick('x','mm/dd HH:MM')