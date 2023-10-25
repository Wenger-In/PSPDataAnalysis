clear all; close all; clc
case1 = 0; % HCS 1          lambda21 = 13
case2 = 1; % HCS 2          lambda21 = 10
case3 = 0; % HCS 3          lambda21 = 11
case4 = 0; % partial HCS 1  lambda21 = 12
case5 = 0; % partial HCS 2                 poorly satisfied
case6 = 0; % partial HCS 3  lambda21 = 6.7 poorly satisfied
case7 = 0; % partial HCS 4  lambda21 = 9
case_index = 5;
%% step 1 load V and B data
if case_index == 1 %【HCS 1】2020/05/26 17:00-21:00
    fld_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020052612_v02.cdf');
    spc_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200526_v02.cdf');
    spe_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200526_v03.cdf');
    Brtn1 = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020052612_v02.cdf','variables','psp_fld_l2_mag_RTN');
    Brtn2 = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020052618_v02.cdf','variables','psp_fld_l2_mag_RTN');
    Brtn = cat(1,Brtn1,Brtn2);
    BEpoch1 = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020052612_v02.cdf','variables','epoch_mag_RTN');
    BEpoch2 = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020052618_v02.cdf','variables','epoch_mag_RTN');
    BEpoch = cat(1,BEpoch1,BEpoch2);
    Vrtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200526_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200526_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200526_v02.cdf','variables','Epoch');
    PA_eflux_all = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200526_v03.cdf','Variables','EFLUX_VS_PA_E');
    PAEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200526_v03.cdf','Variables','Epoch');
    general_flag = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200526_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-05-26 17:00:000.');
    time_data_end = datenum('2020-05-26 21:00:000.');
    time_plot_beg = datenum('2020-05-26 17:00:000.');
    time_plot_end = datenum('2020-05-26 21:00:000.');
    time_calc_beg = datenum('2020-05-26 18:22:000.');
    time_calc_end = datenum('2020-05-26 18:23:000.');
    time_lead_beg = datenum('2020-05-26 18:00:000.');
    time_lead_end = datenum('2020-05-26 18:20:000.');
    time_tral_beg = datenum('2020-05-26 20:15:000.');
    time_tral_end = datenum('2020-05-26 20:35:000.');
    
    dTime = 0.05;
    event = '2020/05/26 HCS 1';
end
if case_index == 2 %【HCS 2】2020/06/08 11:05-11:07
    fld_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060806_v02.cdf');
    spc_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200608_v02.cdf');
    spe_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200608_v03.cdf');
    Brtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060806_v02.cdf','variables','psp_fld_l2_mag_RTN');
    BEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060806_v02.cdf','variables','epoch_mag_RTN');
    Vrtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200608_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200608_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200608_v02.cdf','variables','Epoch');
    PA_eflux_all = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200608_v03.cdf','Variables','EFLUX_VS_PA_E');
    PAEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200608_v03.cdf','Variables','Epoch');
    general_flag = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200608_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-06-08 11:05:000.');
    time_data_end = datenum('2020-06-08 11:07:000.');
    time_plot_beg = datenum('2020-06-08 11:05:000.');
    time_plot_end = datenum('2020-06-08 11:07:000.');
    time_calc_beg = datenum('2020-06-08 11:05:050.');
    time_calc_end = datenum('2020-06-08 11:06:000.');
    time_lead_beg = datenum('2020-06-08 11:00:000.');
    time_lead_end = datenum('2020-06-08 11:20:000.');
    time_tral_beg = datenum('2020-06-08 11:10:000.');
    time_tral_end = datenum('2020-06-08 11:30:000.');
    
    dTime = 0.002;
    event = '2020/06/08 HCS 2';
end
if case_index == 3 %【HCS 3】2020/06/08 15:30-16:30
    fld_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060812_v02.cdf');
    spc_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200608_v02.cdf');
    spe_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200608_v03.cdf');
    Brtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060812_v02.cdf','variables','psp_fld_l2_mag_RTN');
    BEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060812_v02.cdf','variables','epoch_mag_RTN');
    Vrtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200608_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200608_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200608_v02.cdf','variables','Epoch');
    PA_eflux_all = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200608_v03.cdf','Variables','EFLUX_VS_PA_E');
    PAEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200608_v03.cdf','Variables','Epoch');
    general_flag = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200608_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-06-08 15:30:000.');
    time_data_end = datenum('2020-06-08 16:30:000.');
    time_plot_beg = datenum('2020-06-08 15:30:000.');
    time_plot_end = datenum('2020-06-08 16:30:000.');
    time_calc_beg = datenum('2020-06-08 15:59:000.');
    time_calc_end = datenum('2020-06-08 16:00:000.');
    time_lead_beg = datenum('2020-06-08 15:00:000.');
    time_lead_end = datenum('2020-06-08 15:20:000.');
    time_tral_beg = datenum('2020-06-08 15:10:000.');
    time_tral_end = datenum('2020-06-08 15:30:000.');
    
    dTime = 0.05;
    event = '2020/06/08 HCS 3';
end
if case_index == 4 %【partial 1】2020/05/29 22:00-23:00 
    fld_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020052918_v02.cdf');
    spc_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200529_v02.cdf');
    spe_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200529_v03.cdf');
    Brtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020052918_v02.cdf','variables','psp_fld_l2_mag_RTN');
    BEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020052918_v02.cdf','variables','epoch_mag_RTN');
    Vrtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200529_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200529_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200529_v02.cdf','variables','Epoch');
    PA_eflux_all = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200529_v03.cdf','Variables','EFLUX_VS_PA_E');
    PAEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200529_v03.cdf','Variables','Epoch');
    general_flag = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200529_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-05-29 22:00:01');
    time_data_end = datenum('2020-05-29 22:59:59');
    time_plot_beg = datenum('2020-05-29 22:00:01');
    time_plot_end = datenum('2020-05-29 22:59:59');
    time_calc_beg = datenum('2020-05-29 22:00:01');
    time_calc_end = datenum('2020-05-29 22:59:59');
    exht_beg = datenum('2020-05-29 22:24:45');
    exht_end = datenum('2020-05-29 22:51:40');
    
    dTime = 0.05;
    event = '2020/05/29 partial HCS 1';
end
if case_index == 5 %【partial 2】2020/06/01 14:00-17:00
    fld_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060112_v02.cdf');
    spc_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200601_v02.cdf');
    spe_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200601_v03.cdf');
    Brtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060112_v02.cdf','variables','psp_fld_l2_mag_RTN');
    BEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060112_v02.cdf','variables','epoch_mag_RTN');
    Vrtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200601_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200601_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200601_v02.cdf','variables','Epoch');
    PA_eflux_all = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200601_v03.cdf','Variables','EFLUX_VS_PA_E');
    PAEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200601_v03.cdf','Variables','Epoch');
    general_flag = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200601_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-06-01 14:00:000.');
    time_data_end = datenum('2020-06-01 17:00:000.');
    time_plot_beg = datenum('2020-06-01 14:00:000.');
    time_plot_end = datenum('2020-06-01 17:00:000.');
    time_calc_beg = datenum('2020-06-01 14:45:000.');
    time_calc_end = datenum('2020-06-01 15:15:000.');
    
    dTime = 0.05;
    event = '2020/06/01 partial HCS 2';
end
if case_index == 6 %【partial 3】2020/06/04 03:00-07:00
    fld_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060400_v02.cdf');
    spc_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200604_v02.cdf');
    spe_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200604_v03.cdf');
    Brtn1 = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060400_v02.cdf','variables','psp_fld_l2_mag_RTN');
    Brtn2 = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060406_v02.cdf','variables','psp_fld_l2_mag_RTN');
    Brtn = cat(1,Brtn1,Brtn2);
    BEpoch1 = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060400_v02.cdf','variables','epoch_mag_RTN');
    BEpoch2 = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020060406_v02.cdf','variables','epoch_mag_RTN');
    BEpoch = cat(1,BEpoch1,BEpoch2);
    Vrtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200604_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200604_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200604_v02.cdf','variables','Epoch');
    PA_eflux_all = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200604_v03.cdf','Variables','EFLUX_VS_PA_E');
    PAEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200604_v03.cdf','Variables','Epoch');
    general_flag = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200604_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-06-04 03:00:000.');
    time_data_end = datenum('2020-06-04 07:00:000.');
    time_plot_beg = datenum('2020-06-04 03:00:000.');
    time_plot_end = datenum('2020-06-04 07:00:000.');
    time_calc_beg = datenum('2020-06-04 05:22:025.');
    time_calc_end = datenum('2020-06-04 05:24:030.');
    
    dTime = 0.05;
    event = '2020/06/04 partial HCS 3';
end
if case_index == 7 %【partial 4】2020/06/10 03:00-05:00
    fld_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020061000_v02.cdf');
    spc_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200610_v02.cdf');
    spe_info = spdfcdfinfo('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200610_v03.cdf');
    Brtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020061000_v02.cdf','variables','psp_fld_l2_mag_RTN');
    BEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_fld_l2_mag_rtn_2020061000_v02.cdf','variables','epoch_mag_RTN');
    Vrtn = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200610_v02.cdf','variables','vp_moment_RTN');
    N = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200610_v02.cdf','variables','np_moment');
    VEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200610_v02.cdf','variables','Epoch');
    PA_eflux_all = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200610_v03.cdf','Variables','EFLUX_VS_PA_E');
    PAEpoch = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spe_sf0_l3_pad_20200610_v03.cdf','Variables','Epoch');
    general_flag = spdfcdfread('E:\Research\Data\PSP\Encounter 5\psp_swp_spc_l3i_20200610_v02.cdf','variables','general_flag');

    time_data_beg = datenum('2020-06-10 03:00:000.');
    time_data_end = datenum('2020-06-10 05:00:000.');
    time_plot_beg = datenum('2020-06-10 03:00:000.');
    time_plot_end = datenum('2020-06-10 05:00:000.');
    time_calc_beg = datenum('2020-06-10 04:31:000.');
    time_calc_end = datenum('2020-06-10 04:31:100.');
    
    dTime = 0.05;
    event = '2020/06/10 partial HCS 4';
end
Brtn(abs(Brtn)>1e3)=nan;
Vrtn(abs(Vrtn)>1e3)=nan; 
N(general_flag~=0)=nan;
%% get rid of general_flag~=0
Vr =  Vrtn(:,1)'; Vt = Vrtn(:,2)'; Vn = Vrtn(:,3)';
% bad = find(general_flag~=0); badr = find(isnan(Vr)); badt = find(isnan(Vt)); badn = find(isnan(Vn));
% 
% VEpoch_good = VEpoch; VEpoch_good(cat(2,bad',badr)) = [];
% Vr_good = Vr; Vr_good(cat(2,bad',badr)) = [];
% subplot(3,1,1);
% scatter(VEpoch_good,Vr_good);
% datetick('x','HH:MM')
% 
% VEpoch_good = VEpoch; VEpoch_good(cat(2,bad',badt)) = [];
% Vt_good = Vt; Vt_good(cat(2,bad',badt)) = [];
% subplot(3,1,2); 
% scatter(VEpoch_good,Vt_good);
% datetick('x','HH:MM')
% 
% VEpoch_good = VEpoch; VEpoch_good(cat(2,bad',badn)) = [];
% Vn_good = Vn; Vn_good(cat(2,bad',badn)) = [];
% subplot(3,1,3);
% scatter(VEpoch_good,Vn_good);
% datetick('x','HH:MM')
% 
% Vr = interp1(VEpoch_good,Vr_good,VEpoch)';
% Vt = interp1(VEpoch_good,Vt_good,VEpoch)';
% Vn = interp1(VEpoch_good,Vn_good,VEpoch)';
%% step 2 LMN coordinate
Br = Brtn(:,1); Bt = Brtn(:,2); Bn = Brtn(:,3);
B_magni = sqrt(Br.^2 + Bt.^2 + Bn.^2);
theta_BR = acosd(Br./B_magni); 

Br_calc = Br(BEpoch >= time_calc_beg & BEpoch <= time_calc_end); Br_calc(isnan(Br_calc)) = mean(Br_calc,'omitnan');
Bt_calc = Bt(BEpoch >= time_calc_beg & BEpoch <= time_calc_end); Bt_calc(isnan(Bt_calc)) = mean(Bt_calc,'omitnan');
Bn_calc = Bn(BEpoch >= time_calc_beg & BEpoch <= time_calc_end); Bn_calc(isnan(Bn_calc)) = mean(Bn_calc,'omitnan');
M = [mean(Br_calc.*Br_calc) - mean(Br_calc)*mean(Br_calc), mean(Br_calc.*Bt_calc) - mean(Br_calc)*mean(Bt_calc), mean(Br_calc.*Bn_calc) - mean(Br_calc)*mean(Bn_calc); mean(Bt_calc.*Br_calc) - mean(Bt_calc)*mean(Br_calc), mean(Bt_calc.*Bt_calc) - mean(Bt_calc)*mean(Bt_calc), mean(Bt_calc.*Bn_calc) - mean(Bt_calc)*mean(Bn_calc); mean(Bn_calc.*Br_calc) - mean(Bn_calc)*mean(Br_calc), mean(Bn_calc.*Bt_calc) - mean(Bn_calc)*mean(Bt_calc), mean(Bn_calc.*Bn_calc) - mean(Bn_calc)*mean(Bn_calc)];
[V, D] = eig(M); % lambda1 < lambda2 < lambda3; order: N, M, L
% need to satisfy lambda2 / lambda1 >= 8
e_L = V(:,3)/(sqrt(dot(V(:,3), V(:,3))));
e_M = V(:,2)/(sqrt(dot(V(:,2), V(:,2))));
e_N = V(:,1)/(sqrt(dot(V(:,1), V(:,1))));
%% step 3 interpolation into standard time sequence
nTime = floor((time_plot_end - time_plot_beg)*86400/dTime);
std_time = linspace(time_plot_beg - time_data_beg, time_plot_end - time_data_beg, nTime);
std_epoch = interp1(BEpoch - time_data_beg,BEpoch,std_time,'pchip');
Brtn_interp_vec = zeros(nTime,3);
Brtn_interp_vec(:,1) = interp1(BEpoch - time_data_beg,Br,std_time,'pchip');
Brtn_interp_vec(:,2) = interp1(BEpoch - time_data_beg,Bt,std_time,'pchip');
Brtn_interp_vec(:,3) = interp1(BEpoch - time_data_beg,Bn,std_time,'pchip');
theta_BR_interp = zeros(nTime,1);
theta_BR_interp(:,1) = interp1(BEpoch - time_data_beg,theta_BR,std_time,'pchip');

Vrtn_interp_vec = zeros(nTime,3);
Vrtn_interp_vec(:,1) = interp1(VEpoch - time_data_beg,Vr,std_time,'pchip');
Vrtn_interp_vec(:,2) = interp1(VEpoch - time_data_beg,Vt,std_time,'pchip');
Vrtn_interp_vec(:,3) = interp1(VEpoch - time_data_beg,Vn,std_time,'pchip');
N_interp = interp1(VEpoch - time_data_beg,N,std_time,'pchip');

Br_interp = Brtn_interp_vec(:,1); Bt_interp = Brtn_interp_vec(:,2); Bn_interp = Brtn_interp_vec(:,3);
Vr_interp = Vrtn_interp_vec(:,1); Vt_interp = Vrtn_interp_vec(:,2); Vn_interp = Vrtn_interp_vec(:,3);
%% filloutliers
% Vt_interp = filloutliers(Vt_interp,'center','movmedian',1000);
% Vn_interp = filloutliers(Vn_interp,'center','movmedian',1000);
%% step 4 calculate: |B| theta_BR B_L/M/N V_L/M/N Va
B_magni_interp = sqrt(Br_interp.^2 + Br_interp.^2 + Br_interp.^2);

Bnml_interp = Brtn_interp_vec * V;
B_L_interp = Bnml_interp(:,3); B_M_interp = Bnml_interp(:,2); B_N_interp = Bnml_interp(:,1);
Vnml_interp = Vrtn_interp_vec * V;
V_L_interp = Vnml_interp(:,3); V_M_interp = Vnml_interp(:,2); V_N_interp = Vnml_interp(:,1);

PA_eflux_ori = squeeze(PA_eflux_all(:,9,:));
PA_eflux = PA_eflux_ori(:,PAEpoch >= time_plot_beg & PAEpoch <= time_plot_end);

mu_0 = 1.2566370614e-6;
mp = 1.67262192e-27; % unit: kg
Va_interp = B_magni_interp' ./ sqrt(mu_0 .* mp .* N_interp) * 1e-15; % unit: km/s
%% filloutliers
V_L_interp = filloutliers(V_L_interp,'center','movmedian',1000);
V_M_interp = filloutliers(V_M_interp,'center','movmedian',1000);
V_N_interp = filloutliers(V_N_interp,'center','movmedian',1000);
%% calculate reconnection rate
% lead_index = find(std_epoch >= time_lead_beg & std_epoch <= time_lead_end);
% tral_index = find(std_epoch >= time_tral_beg & std_epoch <= time_tral_end);
% lead_epoch = std_epoch(lead_index);
% tral_epoch = std_epoch(tral_index);
% 
% V_N_lead = V_N_interp(lead_index);
% Va_lead = Va_interp(lead_index);
% V_N_tral = V_N_interp(tral_index);
% Va_tral = Va_interp(tral_index);
% V_N_inflow = (nanmean(V_N_tral) - nanmean(V_N_lead)) / 2;
% Va = nanmean([Va_lead, Va_tral]);
% Ma = abs(V_N_inflow / Va);

%% step 5 plot figure
w_base = 0.15; h_base  = 0.10;
height = 0.12; width1 = 0.7; width2 = 0.8; space = 0.002;
linewidth = 1.5; fontsize = 10;
x_interp = std_epoch;
step_std = length(std_time);
step_PA = length(find(PAEpoch >= time_plot_beg & PAEpoch <= time_plot_end));

% interpolate PA for case 2
if case2 == 1
    [PA_bin,step_PA] = size(PA_eflux);
    step_PA_interp = step_PA * 100;
    PA_eflux_interp = zeros(PA_bin,step_PA_interp);
    for i_bin = 1 : PA_bin
        PA_eflux_interp(i_bin,:) = interp1(1:step_PA,PA_eflux(i_bin,:),(1:step_PA_interp)./100);
    end
    step_PA = step_PA_interp;
    PA_eflux = PA_eflux_interp;
end

subplot('position',[w_base,h_base+height*5+space*5,width1,height])
plot(x_interp,Br_interp,'r');
hold on
plot(x_interp,Bt_interp,'g');
hold on
plot(x_interp,Bn_interp,'b');
hold on
plot(x_interp,B_magni_interp,'k');
grid off
% vertical_marks(exht_beg,exht_end);
% shadow_marks(exht_beg,exht_end);
legend('B_r','B_t','B_n','|B|');
xlim([1 step_std]);
ylabel('B_{rtn} [nT]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'XMinorTick','on','linewidth',linewidth,'fontsize',fontsize); % 不显示x坐标轴刻度

subplot('position',[w_base,h_base+height*4+space*4,width1,height])
plot(x_interp,Vr_interp - mean(Vr_interp,'omitnan'),'r');
hold on
plot(x_interp,Vt_interp - mean(Vt_interp,'omitnan'),'g');
hold on
plot(x_interp,Vn_interp - mean(Vn_interp,'omitnan'),'b');
grid off
% vertical_marks(exht_beg,exht_end);
% shadow_marks(exht_beg,exht_end);
legend('V_r','V_t','V_n');
xlim([1 step_std]);
ylabel('V_{rtn} [nT]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'XMinorTick','on','linewidth',linewidth,'fontsize',fontsize); % 不显示x坐标轴刻度

subplot('position',[w_base,h_base+height*3+space*3,width1,height])
plot(x_interp,B_L_interp,'r');
hold on
plot(x_interp,B_M_interp,'g');
hold on
plot(x_interp,B_N_interp,'b');
grid off
% vertical_marks(exht_beg,exht_end);
% shadow_marks(exht_beg,exht_end);
legend('B_L','B_M','B_N');
xlim([1 step_std]);
ylabel('B_{LMN} [nT]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'XMinorTick','on','linewidth',linewidth,'fontsize',fontsize); % 不显示x坐标轴刻度

subplot('position',[w_base,h_base+height*2+space*2,width1,height])
plot(x_interp,V_L_interp - mean(V_L_interp,'omitnan'),'r');
hold on
plot(x_interp,V_M_interp - mean(V_M_interp,'omitnan'),'g');
hold on
plot(x_interp,V_N_interp - mean(V_N_interp,'omitnan'),'b');
grid off
% vertical_marks(exht_beg,exht_end);
% shadow_marks(exht_beg,exht_end);
legend('V_L','V_M','V_N');
xlim([1 step_std]);
ylabel('V_{LMN} [nT]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'XMinorTick','on','linewidth',linewidth,'fontsize',fontsize); % 不显示x坐标轴刻度

subplot('position',[w_base,h_base+height*1+space*1,width1,height])
plot(x_interp,theta_BR_interp,'k');
grid off
% vertical_marks(exht_beg,exht_end);
% shadow_marks(exht_beg,exht_end);
xlim([1 step_std]); ylim([0 180]);
ylabel('\theta_{BR} [deg.]')
datetick('x','HH:MM') % set xtick as date
set(gca,'xticklabel',[],'XMinorTick','on','linewidth',linewidth,'fontsize',fontsize); % 不显示x坐标轴刻度

% subplot('position',[w_base,h_base+height*1+space*1,width1,height])
% V_N_pos = V_N_interp - nanmean(V_N_interp);
% V_N_pos(V_N_pos<0) = 0;
% V_N_neg = V_N_interp - nanmean(V_N_interp);
% V_N_neg(V_N_neg>0) = 0;
% area(x_interp,V_N_pos,'FaceColor','r','EdgeColor','none'); hold on;
% area(x_interp,V_N_neg,'FaceColor','b','EdgeColor','none'); grid on
% % xlim([1 step_std]);
% ylabel('V_N')
% datetick('x','HH:MM') % set xtick as date
% set(gca,'xticklabel',[],'linewidth',linewidth,'fontsize',fontsize); % 不显示x坐标轴刻度

subplot('position',[w_base,h_base+height*0+space*0,width2,height])
hold on
h = pcolor(PA_eflux);
set(h,'Linestyle','none');
colormap jet; colorbar;
yyaxis left
xlim([1 step_PA]); ylim([1 12]);
ylabel('PA [deg.]')
set(gca,'ytick',[1;4;8;12],'yticklabel',[0;60;120;180],'linewidth',linewidth,'fontsize',fontsize,'tickdir','out')
if case_index == 1
    set(gca,'xtick',[1;1/8*step_PA;2/8*step_PA;3/8*step_PA;4/8*step_PA;5/8*step_PA;6/8*step_PA;7/8*step_PA;step_PA],'xticklabel',['17:00';'17:30';'18:00';'18:30';'19:00';'19:30';'20:00';'20:30';'21:00']);
end
if case_index == 4
    set(gca,'xtick',[1;1/6*step_PA;2/6*step_PA;3/6*step_PA;4/6*step_PA;5/6*step_PA;step_PA],'xticklabel',['22:00';'22:10';'22:20';'22:30';'22:40';'22:50';'23:00']);
end
if case_index == 5
    set(gca,'xtick',[1;1/6*step_PA;2/6*step_PA;3/6*step_PA;4/6*step_PA;5/6*step_PA;step_PA],'xticklabel',['14:00';'14:30';'15:00';'15:30';'16:00';'16:30';'17:00']);
end
if case_index == 6
    set(gca,'xtick',[1;1/8*step_PA;2/8*step_PA;3/8*step_PA;4/8*step_PA;5/8*step_PA;6/8*step_PA;7/8*step_PA;step_PA],'xticklabel',['03:00';'03:30';'04:00';'04:30';'05:00';'05:30';'06:00';'06:30';'07:00']);
end
yyaxis right
ylabel('log{(eflux)}')
% vertical_marks(106.6,221.4);
set(gca,'XMinorTick','on','ytick',[],'yticklabel',[],'ycolor','k'); % 不显示y坐标轴刻度

% sgtitle(event);

%% functions
function vertical_marks(exht_beg,exht_end)
% Plot vertical lines
    LineWidth = 2;
    hold on;
    xline(exht_beg,'--k','LineWidth',LineWidth); hold on;
    xline(exht_end,'--k','LineWidth',LineWidth); hold on;
end
function shadow_marks(exht_beg,exht_end)
% Plot shadow blocks
    hold on
    yl = ylim;
    vert = [exht_beg,yl(1);exht_end,yl(1);exht_end,yl(2);exht_beg,yl(2)];
    face = [1 2 3 4];
    patch('Faces',face,'Vertices',vert,'FaceColor','black','FaceAlpha',0.2,'EdgeColor','none');
    hold on
end