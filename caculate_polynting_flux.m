clear all; close all; clc
case1 = 1; % HCS 1          lambda21 = 13
case2 = 0; % HCS 2          lambda21 = 10
case3 = 0; % HCS 3          lambda21 = 11
case4 = 0; % partial HCS 1  lambda21 = 12
case5 = 0; % partial HCS 2                 poorly satisfied
case6 = 0; % partial HCS 3  lambda21 = 6.7 poorly satisfied
case7 = 0; % partial HCS 4  lambda21 = 9
%% step 1 load V and B data
if case1 %【HCS 1】2020/05/26 17:00-21:00
    fld_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020052612_v02.cdf');
    spc_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200526_v02.cdf');
    Brtn1 = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020052612_v02.cdf','variables','psp_fld_l2_mag_RTN');
    Brtn2 = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020052618_v02.cdf','variables','psp_fld_l2_mag_RTN');
    Brtn = cat(1,Brtn1,Brtn2);
    BEpoch1 = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020052612_v02.cdf','variables','epoch_mag_RTN');
    BEpoch2 = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020052618_v02.cdf','variables','epoch_mag_RTN');
    BEpoch = cat(1,BEpoch1,BEpoch2);
    Vrtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200526_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200526_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200526_v02.cdf','variables','Epoch');
    general_flag = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200526_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-05-26 17:00:000.');
    time_data_end = datenum('2020-05-26 21:00:000.');
    time_plot_beg = datenum('2020-05-26 17:00:000.');
    time_plot_end = datenum('2020-05-26 21:00:000.');
    time_calc_beg = datenum('2020-05-26 19:00:000.');
    time_calc_end = datenum('2020-05-26 20:00:000.');
    
    dTime = 0.05;
    event = '2020/05/26 HCS 1';
end
if case2 %【HCS 2】2020/06/08 11:05-11:07
    fld_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060806_v02.cdf');
    spc_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200608_v02.cdf');
    Brtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060806_v02.cdf','variables','psp_fld_l2_mag_RTN');
    BEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060806_v02.cdf','variables','epoch_mag_RTN');
    Vrtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200608_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200608_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200608_v02.cdf','variables','Epoch');
    general_flag = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200608_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-06-08 11:05:000.');
    time_data_end = datenum('2020-06-08 11:07:000.');
    time_plot_beg = datenum('2020-06-08 11:05:000.');
    time_plot_end = datenum('2020-06-08 11:07:000.');
    time_calc_beg = datenum('2020-06-08 11:05:000.');
    time_calc_end = datenum('2020-06-08 11:06:000.');
    
    dTime = 0.002;
    event = '2020/06/08 HCS 2';
end
if case3 %【HCS 3】2020/06/08 15:30-16:30
    fld_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060812_v02.cdf');
    spc_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200608_v02.cdf');
    Brtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060812_v02.cdf','variables','psp_fld_l2_mag_RTN');
    BEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060812_v02.cdf','variables','epoch_mag_RTN');
    Vrtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200608_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200608_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200608_v02.cdf','variables','Epoch');
    general_flag = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200608_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-06-08 15:30:000.');
    time_data_end = datenum('2020-06-08 16:30:000.');
    time_plot_beg = datenum('2020-06-08 15:30:000.');
    time_plot_end = datenum('2020-06-08 16:30:000.');
    time_calc_beg = datenum('2020-06-08 16:00:000.');
    time_calc_end = datenum('2020-06-08 16:30:000.');
    
    dTime = 0.05;
    event = '2020/06/08 HCS 3';
end
if case4 %【partial 1】2020/05/29 22:00-23:00 
    fld_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020052918_v02.cdf');
    spc_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200529_v02.cdf');
    Brtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020052918_v02.cdf','variables','psp_fld_l2_mag_RTN');
    BEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020052918_v02.cdf','variables','epoch_mag_RTN');
    Vrtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200529_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200529_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200529_v02.cdf','variables','Epoch');
    general_flag = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200529_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-05-29 22:00:000.');
    time_data_end = datenum('2020-05-29 23:00:000.');
    time_plot_beg = datenum('2020-05-29 22:00:000.');
    time_plot_end = datenum('2020-05-29 23:00:000.');
    time_calc_beg = datenum('2020-05-29 22:00:000.');
    time_calc_end = datenum('2020-05-29 22:20:000.');
    
    dTime = 0.05;
    event = '2020/05/29 partial HCS 1';
end
if case5 %【partial 2】2020/06/01 14:00-17:00
    fld_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060112_v02.cdf');
    spc_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200601_v02.cdf');
    Brtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060112_v02.cdf','variables','psp_fld_l2_mag_RTN');
    BEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060112_v02.cdf','variables','epoch_mag_RTN');
    Vrtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200601_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200601_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200601_v02.cdf','variables','Epoch');
    general_flag = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200601_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-06-01 14:00:000.');
    time_data_end = datenum('2020-06-01 17:00:000.');
    time_plot_beg = datenum('2020-06-01 14:00:000.');
    time_plot_end = datenum('2020-06-01 17:00:000.');
    time_calc_beg = datenum('2020-06-01 14:20:000.');
    time_calc_end = datenum('2020-06-01 14:40:000.');
    
    dTime = 0.05;
    event = '2020/06/01 partial HCS 2';
end
if case6 %【partial 3】2020/06/04 03:00-07:00
    fld_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060400_v02.cdf');
    spc_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200604_v02.cdf');
    Brtn1 = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060400_v02.cdf','variables','psp_fld_l2_mag_RTN');
    Brtn2 = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060406_v02.cdf','variables','psp_fld_l2_mag_RTN');
    Brtn = cat(1,Brtn1,Brtn2);
    BEpoch1 = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060400_v02.cdf','variables','epoch_mag_RTN');
    BEpoch2 = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020060406_v02.cdf','variables','epoch_mag_RTN');
    BEpoch = cat(1,BEpoch1,BEpoch2);
    Vrtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200604_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200604_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200604_v02.cdf','variables','Epoch');
    general_flag = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200604_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-06-04 03:00:000.');
    time_data_end = datenum('2020-06-04 07:00:000.');
    time_plot_beg = datenum('2020-06-04 03:00:000.');
    time_plot_end = datenum('2020-06-04 07:00:000.');
    time_calc_beg = datenum('2020-06-04 06:00:000.');
    time_calc_end = datenum('2020-06-04 07:00:000.');
    
    dTime = 0.05;
    event = '2020/06/04 partial HCS 3';
end
if case7 %【partial 4】2020/06/10 03:00-05:00
    fld_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020061000_v02.cdf');
    spc_info = spdfcdfinfo('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200610_v02.cdf');
    Brtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020061000_v02.cdf','variables','psp_fld_l2_mag_RTN');
    BEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_fld_l2_mag_rtn_2020061000_v02.cdf','variables','epoch_mag_RTN');
    Vrtn = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200610_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200610_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200610_v02.cdf','variables','Epoch');
    general_flag = spdfcdfread('C:\STUDY\PSP\Encounter 5\DATA\psp_swp_spc_l3i_20200610_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-06-10 03:00:000.');
    time_data_end = datenum('2020-06-10 05:00:000.');
    time_plot_beg = datenum('2020-06-10 03:00:000.');
    time_plot_end = datenum('2020-06-10 05:00:000.');
    time_calc_beg = datenum('2020-06-10 04:40:000.');
    time_calc_end = datenum('2020-06-10 05:00:000.');
    
    dTime = 0.05;
    event = '2020/06/10 partial HCS 4';
end
Brtn(abs(Brtn)>1e3)=nan;
Vrtn(abs(Vrtn)>1e3)=nan; 
%% interpolation into spc time sequence
Vr = Vrtn(:,1); Vt = Vrtn(:,2); Vn = Vrtn(:,3);
Br = Brtn(:,1); Bt = Brtn(:,2); Bn = Brtn(:,3);
nTime = length(VEpoch);
std_time = linspace(time_plot_beg - time_data_beg, time_plot_end - time_data_beg, nTime);
std_epoch = interp1(VEpoch - time_data_beg,VEpoch,std_time,'pchip');
Brtn_interp_vec = zeros(length(VEpoch),3);
Brtn_interp_vec(:,1) = interp1(BEpoch - time_data_beg,Br,std_time,'pchip');
Brtn_interp_vec(:,2) = interp1(BEpoch - time_data_beg,Bt,std_time,'pchip');
Brtn_interp_vec(:,3) = interp1(BEpoch - time_data_beg,Bn,std_time,'pchip');
Br_interp = Brtn_interp_vec(:,1); Bt_interp = Brtn_interp_vec(:,2); Bn_interp = Brtn_interp_vec(:,3);
B_magni_interp = sqrt(Br_interp.^2 + Bt_interp.^2 + Bn_interp.^2);
%% calculate Poynting-flux: S=E×H=-V×B×B/mu0
mu0 = 1.2566370614e-6;
Ertn_vec = zeros(length(VEpoch),3);
for i = 1 : length(VEpoch)
    Ertn_vec(i,:) = cross(-Vrtn(i,:),Brtn_interp_vec(i,:));
end
Er = Ertn_vec(:,1); Et = Ertn_vec(:,2); En = Ertn_vec(:,3);
E_magni = sqrt(Er.^2 + Et.^2 + En.^2);

Srtn_vec = zeros(length(VEpoch),3);
for i = 1 : length(VEpoch)
    Srtn_vec(i,:) = cross(Ertn_vec(i,:),Brtn_interp_vec(i,:)./mu0);
end
Sr = Srtn_vec(:,1); St = Srtn_vec(:,2); Sn = Srtn_vec(:,3);
S_magni = sqrt(Sr.^2 + St.^2 + Sn.^2);
%% calculate B0, theta_{Vphase,B0}
Br0 = nanmean(Br(find(BEpoch >= time_calc_beg & BEpoch <= time_calc_end)));
Bt0 = nanmean(Bt(find(BEpoch >= time_calc_beg & BEpoch <= time_calc_end)));
Bn0 = nanmean(Bn(find(BEpoch >= time_calc_beg & BEpoch <= time_calc_end)));
B0_vec = [Br0, Bt0, Bn0];
B_magni0 = sqrt(Br0^2 + Bt0^2 + Bn0^2);

theta_SB0 = zeros(length(VEpoch),1);
for i = 1 : length(VEpoch)
    theta_SB0(i) = acosd(dot(Srtn_vec(i,:),B0_vec)/S_magni(i)/B_magni0);
end
%% plot E and S
w_base = 0.15; h_base  = 0.10;
height = 0.10; width1 = 0.7; width2 = 0.765; space = 0.002;
linewidth = 1.2; fontsize = 8;
x_std = std_epoch; step_std = length(std_time);

subplot('position',[w_base,h_base+height*7+space*7,width1,height])
plot(x_std,Er);
grid on
xlim([1 step_std]);
ylabel('E_r [\muV/m]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'linewidth',linewidth,'fontsize',fontsize);

subplot('position',[w_base,h_base+height*6+space*6,width1,height])
plot(x_std,Et);
grid on
xlim([1 step_std]);
ylabel('E_t [\muV/m]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'linewidth',linewidth,'fontsize',fontsize);

subplot('position',[w_base,h_base+height*5+space*5,width1,height])
plot(x_std,En);
grid on
xlim([1 step_std]);
ylabel('E_n [\muV/m]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'linewidth',linewidth,'fontsize',fontsize);

subplot('position',[w_base,h_base+height*4+space*4,width1,height])
plot(x_std,Sr);
grid on
xlim([1 step_std]);
ylabel('S_r [\muV/m]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'linewidth',linewidth,'fontsize',fontsize);

subplot('position',[w_base,h_base+height*3+space*3,width1,height])
plot(x_std,St);
grid on
xlim([1 step_std]);
ylabel('S_t [\muV/m]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'linewidth',linewidth,'fontsize',fontsize);

subplot('position',[w_base,h_base+height*2+space*2,width1,height])
plot(x_std,Sn);
grid on
xlim([1 step_std]);
ylabel('S_n [\muV/m]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'linewidth',linewidth,'fontsize',fontsize);

subplot('position',[w_base,h_base+height*1+space*1,width1,height])
plot(x_std,S_magni);
grid on
xlim([1 step_std]);
ylabel('|S| [fW/m^2]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'linewidth',linewidth,'fontsize',fontsize);

subplot('position',[w_base,h_base+height*0+space*0,width1,height])
plot(x_std,theta_SB0);
grid on
xlim([1 step_std]); ylim([1 180]);
ylabel('\theta_{S,B_0} [deg.]')
datetick('x','HH:MM') % set xtick as date
set(gca,'linewidth',linewidth,'fontsize',fontsize);

sgtitle(event);