%% event time
clear all; close all;
save_or_not = 0; 
%% select time periods
% time_available: 20181031-20181116 totally 17days
day_num = 20181106; date_str = '20181106'; year_str = '2018';
month_beg = 11; day_beg = 11; hour_beg = 00; min_beg = 00; sec_beg = 00;
month_end = 11; day_end = 12; hour_end = 24; min_end = 00; sec_end = 00;
year = str2double(year_str);
time_beg = datenum(year,month_beg,day_beg,hour_beg,min_beg,sec_beg);
time_end = datenum(year,month_end,day_end,hour_end,min_end,sec_end);
date_list = ['1031','1101','1102','1103','1104','1105','1106','1107','1108','1109','1110','1111','1112','1113','1114','1115','1116'];
%% mag_dir every-67
mag_dir103100 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018103100_v01.cdf'];
mag_dir103106 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018103106_v01.cdf'];
mag_dir103112 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018103112_v01.cdf'];
mag_dir103118 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018103118_v01.cdf'];
mag_dir110100 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110100_v01.cdf'];
mag_dir110106 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110106_v01.cdf'];
mag_dir110112 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110112_v01.cdf'];
mag_dir110118 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110118_v01.cdf'];
mag_dir110200 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110200_v01.cdf'];
mag_dir110206 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110206_v01.cdf'];
mag_dir110212 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110212_v01.cdf'];
mag_dir110218 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110218_v01.cdf'];
mag_dir110300 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110300_v01.cdf'];
mag_dir110306 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110306_v01.cdf'];
mag_dir110312 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110312_v01.cdf'];
mag_dir110318 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110318_v01.cdf'];
mag_dir110400 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110400_v01.cdf'];
mag_dir110406 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110406_v01.cdf'];
mag_dir110412 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110412_v01.cdf'];
mag_dir110418 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110418_v01.cdf'];
mag_dir110500 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110500_v01.cdf'];
mag_dir110506 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110506_v01.cdf'];
mag_dir110512 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110512_v01.cdf'];
mag_dir110518 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110518_v01.cdf'];
mag_dir110600 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110600_v01.cdf'];
mag_dir110606 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110606_v01.cdf'];
mag_dir110612 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110612_v01.cdf'];
mag_dir110618 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110618_v01.cdf'];
mag_dir110700 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110700_v01.cdf'];
mag_dir110706 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110706_v01.cdf'];
mag_dir110712 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110712_v01.cdf'];
mag_dir110718 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110718_v01.cdf'];
mag_dir110800 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110800_v01.cdf'];
mag_dir110806 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110806_v01.cdf'];
mag_dir110812 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110812_v01.cdf'];
mag_dir110818 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110818_v01.cdf'];
mag_dir110900 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110900_v01.cdf'];
mag_dir110906 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110906_v01.cdf'];
mag_dir110912 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110912_v01.cdf'];
mag_dir110918 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018110918_v01.cdf'];
mag_dir111000 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111000_v01.cdf'];
mag_dir111006 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111006_v01.cdf'];
mag_dir111012 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111012_v01.cdf'];
mag_dir111018 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111018_v01.cdf'];
mag_dir111100 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111100_v01.cdf'];
mag_dir111106 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111106_v01.cdf'];
mag_dir111112 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111112_v01.cdf'];
mag_dir111118 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111118_v01.cdf'];
mag_dir111200 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111200_v01.cdf'];
mag_dir111206 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111206_v01.cdf'];
mag_dir111212 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111212_v01.cdf'];
mag_dir111218 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111218_v01.cdf'];
mag_dir111300 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111300_v01.cdf'];
mag_dir111306 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111306_v01.cdf'];
mag_dir111312 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111312_v01.cdf'];
mag_dir111318 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111318_v01.cdf'];
mag_dir111400 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111400_v01.cdf'];
mag_dir111406 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111406_v01.cdf'];
mag_dir111412 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111412_v01.cdf'];
mag_dir111418 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111418_v01.cdf'];
mag_dir111500 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111500_v01.cdf'];
mag_dir111506 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111506_v01.cdf'];
mag_dir111512 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111512_v01.cdf'];
mag_dir111518 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111518_v01.cdf'];
mag_dir111600 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111600_v01.cdf'];
mag_dir111606 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111606_v01.cdf'];
mag_dir111612 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111612_v01.cdf'];
mag_dir111618 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_fld_l2_mag_rtn_2018111618_v01.cdf'];
mag_dir_list = [mag_dir103100,mag_dir103106,mag_dir103112,mag_dir103118,mag_dir110100,mag_dir110106,mag_dir110112,mag_dir110118,mag_dir110200,mag_dir110206,mag_dir110212,mag_dir110218,mag_dir110300,mag_dir110306,mag_dir110312,mag_dir110318,mag_dir110400,mag_dir110406,mag_dir110412,mag_dir110418,mag_dir110500,mag_dir110506,mag_dir110512,mag_dir110518,mag_dir110600,mag_dir110606,mag_dir110612,mag_dir110618,mag_dir110700,mag_dir110706,mag_dir110712,mag_dir110718,mag_dir110800,mag_dir110806,mag_dir110812,mag_dir110818,mag_dir110900,mag_dir110906,mag_dir110912,mag_dir110918,mag_dir111000,mag_dir111006,mag_dir111012,mag_dir111018,mag_dir111100,mag_dir111106,mag_dir111112,mag_dir111118,mag_dir111200,mag_dir111206,mag_dir111212,mag_dir111218,mag_dir111300,mag_dir111306,mag_dir111312,mag_dir111318,mag_dir111400,mag_dir111406,mag_dir111412,mag_dir111418,mag_dir111500,mag_dir111506,mag_dir111512,mag_dir111518,mag_dir111600,mag_dir111606,mag_dir111612,mag_dir111618];
%% spc_dir every-62
spc_dir1031 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181031_v01.cdf'];
spc_dir1101 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181101_v01.cdf'];
spc_dir1102 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181102_v01.cdf'];
spc_dir1103 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181103_v01.cdf'];
spc_dir1104 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181104_v01.cdf'];
spc_dir1105 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181105_v01.cdf'];
spc_dir1106 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181106_v01.cdf'];
spc_dir1107 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181107_v01.cdf'];
spc_dir1108 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181108_v01.cdf'];
spc_dir1109 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181109_v01.cdf'];
spc_dir1110 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181110_v01.cdf'];
spc_dir1111 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181111_v01.cdf'];
spc_dir1112 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181112_v01.cdf'];
spc_dir1113 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181113_v01.cdf'];
spc_dir1114 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181114_v01.cdf'];
spc_dir1115 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181115_v01.cdf'];
spc_dir1116 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spc_l3i_20181116_v01.cdf'];
spc_dir_list = [spc_dir1031,spc_dir1101,spc_dir1102,spc_dir1103,spc_dir1104,spc_dir1105,spc_dir1106,spc_dir1107,spc_dir1108,spc_dir1109,spc_dir1110,spc_dir1111,spc_dir1112,spc_dir1113,spc_dir1114,spc_dir1115,spc_dir1116];
%% spe_dir every-69
spe_dir1031 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181031_v02.cdf'];
spe_dir1101 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181101_v02.cdf'];
spe_dir1102 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181102_v02.cdf'];
spe_dir1103 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181103_v02.cdf'];
spe_dir1104 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181104_v02.cdf'];
spe_dir1105 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181105_v02.cdf'];
spe_dir1106 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181106_v02.cdf'];
spe_dir1107 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181107_v02.cdf'];
spe_dir1108 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181108_v02.cdf'];
spe_dir1109 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181109_v02.cdf'];
spe_dir1110 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181110_v02.cdf'];
spe_dir1111 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181111_v02.cdf'];
spe_dir1112 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181112_v02.cdf'];
spe_dir1113 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181113_v02.cdf'];
spe_dir1114 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181114_v02.cdf'];
spe_dir1115 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181115_v02.cdf'];
spe_dir1116 = ['D:\STUDY\PSP\Encounter 1\DATA\psp_swp_spe_sf0_l3_pad_20181116_v02.cdf'];
spe_dir_list = [spe_dir1031,spe_dir1101,spe_dir1102,spe_dir1103,spe_dir1104,spe_dir1105,spe_dir1106,spe_dir1107,spe_dir1108,spe_dir1109,spe_dir1110,spe_dir1111,spe_dir1112,spe_dir1113,spe_dir1114,spe_dir1115,spe_dir1116];
%% load data
mag_info = spdfcdfinfo(mag_dir110606);
spc_info = spdfcdfinfo(spc_dir1106);
spe_info = spdfcdfinfo(spe_dir1106);
%% interp
dTime = 10;
nTime = floor((time_end - time_beg)*86400/dTime);
std_seq = linspace(time_beg,time_end,nTime);
mag_epoch = []; spc_epoch = [];
Br_interp = []; Bt_interp = []; Bn_interp = [];
Vr = []; Vt = []; Vn = [];
for i = 12:13
    mag_epoch00 = spdfcdfread(mag_dir_list(67*(4*i-4)+1 : 67*(4*i-3)),'Variables','epoch_mag_RTN');
    mag_epoch06 = spdfcdfread(mag_dir_list(67*(4*i-3)+1 : 67*(4*i-2)),'Variables','epoch_mag_RTN');
    mag_epoch12 = spdfcdfread(mag_dir_list(67*(4*i-2)+1 : 67*(4*i-1)),'Variables','epoch_mag_RTN');
    mag_epoch18 = spdfcdfread(mag_dir_list(67*(4*i-1)+1 : 67*(4*i-0)),'Variables','epoch_mag_RTN');
    mag_epoch_sub = cat(1,mag_epoch00,mag_epoch06,mag_epoch12,mag_epoch18);
    
    B_RTN00 = spdfcdfread(mag_dir_list(67*(4*i-4)+1 : 67*(4*i-3)),'Variables','psp_fld_l2_mag_RTN');
    B_RTN06 = spdfcdfread(mag_dir_list(67*(4*i-3)+1 : 67*(4*i-2)),'Variables','psp_fld_l2_mag_RTN');
    B_RTN12 = spdfcdfread(mag_dir_list(67*(4*i-2)+1 : 67*(4*i-1)),'Variables','psp_fld_l2_mag_RTN');
    B_RTN18 = spdfcdfread(mag_dir_list(67*(4*i-1)+1 : 67*(4*i-0)),'Variables','psp_fld_l2_mag_RTN');
    B_RTN_sub = cat(1,B_RTN00,B_RTN06,B_RTN12,B_RTN18);
    B_R_sub = B_RTN_sub(:,1); B_T_sub = B_RTN_sub(:,2); B_N_sub = B_RTN_sub(:,3);
    
    spc_epoch_sub = spdfcdfread(spc_dir_list(62*(i-1)+1 : 62*i),'Variables','Epoch');
    V_RTN_sub = spdfcdfread(spc_dir_list(62*(i-1)+1 : 62*i),'Variables','vp1_fit_RTN');
    V_R_sub = V_RTN_sub(:,1);  V_T_sub = V_RTN_sub(:,2);  V_N_sub = V_RTN_sub(:,3);
    
    date_str_sub = date_list(4*(i-1)+1 : 4*i);
    month_sub = str2double(date_str_sub(1:2)); day_sub = str2double(date_str_sub(3:4));
    time_beg_sub = datenum(year,month_sub,day_sub,hour_beg,min_beg,sec_beg);
    time_end_sub = datenum(year,month_sub,day_sub,hour_end,min_end,sec_end);
    nTime_sub = floor((time_end_sub - time_beg_sub)*86400/dTime);
    std_seq_sub = linspace(time_beg_sub,time_end_sub,nTime_sub);
    Brtn_interp_sub = zeros(nTime_sub,3);
    
    Brtn_interp_sub(:,1) = interp1(mag_epoch_sub,B_R_sub,std_seq_sub); Br_interp_sub = Brtn_interp_sub(:,1); Br_interp_sub(1) = Br_interp_sub(2); Br_interp_sub(length(Br_interp_sub)) = Br_interp_sub(length(Br_interp_sub)-1); 
    Brtn_interp_sub(:,2) = interp1(mag_epoch_sub,B_T_sub,std_seq_sub); Bt_interp_sub = Brtn_interp_sub(:,2); Bt_interp_sub(1) = Bt_interp_sub(2); Bt_interp_sub(length(Bt_interp_sub)) = Bt_interp_sub(length(Bt_interp_sub)-1); 
    Brtn_interp_sub(:,3) = interp1(mag_epoch_sub,B_N_sub,std_seq_sub); Bn_interp_sub = Brtn_interp_sub(:,3); Bn_interp_sub(1) = Bn_interp_sub(2); Bn_interp_sub(length(Bn_interp_sub)) = Bn_interp_sub(length(Bn_interp_sub)-1); 
%     Vr_interp_sub = interp1(spc_epoch_sub,V_R_sub,std_seq_sub); Vr_interp_sub(1) = Vr_interp_sub(2); Vr_interp_sub(length(Vr_interp_sub)) = Vr_interp_sub(length(Vr_interp_sub)-1);
    
    mag_epoch = cat(1,mag_epoch,std_seq_sub.');
    Br_interp = cat(1,Br_interp,Br_interp_sub);
    Bt_interp = cat(1,Bt_interp,Bt_interp_sub);
    Bn_interp = cat(1,Bn_interp,Bn_interp_sub);
    
    spc_epoch = cat(1,spc_epoch,spc_epoch_sub);
    Vr = cat(1,Vr,V_R_sub);
    Vt = cat(1,Vt,V_T_sub);
    Vn = cat(1,Vn,V_N_sub);
end
B_magni = sqrt(Br_interp.^2 + Bt_interp.^2 + Bn_interp.^2);
theta_BR = acosd(Br_interp./B_magni);
%% spe_epoch
spe_epoch1031 = spdfcdfread(spe_dir1031,'Variables','Epoch');
spe_epoch1101 = spdfcdfread(spe_dir1101,'Variables','Epoch');
spe_epoch1102 = spdfcdfread(spe_dir1102,'Variables','Epoch');
spe_epoch1103 = spdfcdfread(spe_dir1103,'Variables','Epoch');
spe_epoch1104 = spdfcdfread(spe_dir1104,'Variables','Epoch');
spe_epoch1105 = spdfcdfread(spe_dir1105,'Variables','Epoch');
spe_epoch1106 = spdfcdfread(spe_dir1106,'Variables','Epoch');
spe_epoch1107 = spdfcdfread(spe_dir1107,'Variables','Epoch');
spe_epoch1108 = spdfcdfread(spe_dir1108,'Variables','Epoch');
spe_epoch1109 = spdfcdfread(spe_dir1109,'Variables','Epoch');
spe_epoch1110 = spdfcdfread(spe_dir1110,'Variables','Epoch');
spe_epoch1111 = spdfcdfread(spe_dir1111,'Variables','Epoch');
spe_epoch1112 = spdfcdfread(spe_dir1112,'Variables','Epoch');
spe_epoch1113 = spdfcdfread(spe_dir1113,'Variables','Epoch');
spe_epoch1114 = spdfcdfread(spe_dir1114,'Variables','Epoch');
spe_epoch1115 = spdfcdfread(spe_dir1115,'Variables','Epoch');
spe_epoch1116 = spdfcdfread(spe_dir1116,'Variables','Epoch');
% spe_epoch = cat(1,spe_epoch1031,spe_epoch1101,spe_epoch1102,spe_epoch1103,spe_epoch1104,spe_epoch1105,spe_epoch1106,spe_epoch1107,spe_epoch1108,spe_epoch1109,spe_epoch1110,spe_epoch1111,spe_epoch1112,spe_epoch1113,spe_epoch1114,spe_epoch1115,spe_epoch1116);
% spe_epoch = spe_epoch1106;
spe_epoch = cat(1,spe_epoch1111,spe_epoch1112);
%% PitchAngle
PA_bin = spdfcdfread(spe_dir1106,'Variables','PITCHANGLE'); % row 9: 314.45 eV
PA_eflux_ori1031 = spdfcdfread(spe_dir1031,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1031 = squeeze(PA_eflux_ori1031(:,9,:));
PA_eflux_ori1101 = spdfcdfread(spe_dir1101,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1101 = squeeze(PA_eflux_ori1101(:,9,:));
PA_eflux_ori1102 = spdfcdfread(spe_dir1102,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1102 = squeeze(PA_eflux_ori1102(:,9,:));
PA_eflux_ori1103 = spdfcdfread(spe_dir1103,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1103 = squeeze(PA_eflux_ori1103(:,9,:));
PA_eflux_ori1104 = spdfcdfread(spe_dir1104,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1104 = squeeze(PA_eflux_ori1104(:,9,:));
PA_eflux_ori1105 = spdfcdfread(spe_dir1105,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1105 = squeeze(PA_eflux_ori1105(:,9,:));
PA_eflux_ori1106 = spdfcdfread(spe_dir1106,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1106 = squeeze(PA_eflux_ori1106(:,9,:));
PA_eflux_ori1107 = spdfcdfread(spe_dir1107,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1107 = squeeze(PA_eflux_ori1107(:,9,:));
PA_eflux_ori1108 = spdfcdfread(spe_dir1108,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1108 = squeeze(PA_eflux_ori1108(:,9,:));
PA_eflux_ori1109 = spdfcdfread(spe_dir1109,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1109 = squeeze(PA_eflux_ori1109(:,9,:));
PA_eflux_ori1110 = spdfcdfread(spe_dir1110,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1110 = squeeze(PA_eflux_ori1110(:,9,:));
PA_eflux_ori1111 = spdfcdfread(spe_dir1111,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1111 = squeeze(PA_eflux_ori1111(:,9,:));
PA_eflux_ori1112 = spdfcdfread(spe_dir1112,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1112 = squeeze(PA_eflux_ori1112(:,9,:));
PA_eflux_ori1113 = spdfcdfread(spe_dir1113,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1113 = squeeze(PA_eflux_ori1113(:,9,:));
PA_eflux_ori1114 = spdfcdfread(spe_dir1114,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1114 = squeeze(PA_eflux_ori1114(:,9,:));
PA_eflux_ori1115 = spdfcdfread(spe_dir1115,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1115 = squeeze(PA_eflux_ori1115(:,9,:));
PA_eflux_ori1116 = spdfcdfread(spe_dir1116,'Variables','EFLUX_VS_PA_E');
PA_eflux_uninterp1116 = squeeze(PA_eflux_ori1116(:,9,:));
% PA_eflux_uninterp =cat(2,PA_eflux_uninterp1031,PA_eflux_uninterp1101,PA_eflux_uninterp1102,PA_eflux_uninterp1103,PA_eflux_uninterp1104,PA_eflux_uninterp1105,PA_eflux_uninterp1106,PA_eflux_uninterp1107,PA_eflux_uninterp1108,PA_eflux_uninterp1109,PA_eflux_uninterp1110,PA_eflux_uninterp1111,PA_eflux_uninterp1112,PA_eflux_uninterp1113,PA_eflux_uninterp1114,PA_eflux_uninterp1115,PA_eflux_uninterp1116);
% PA_eflux_uninterp = PA_eflux_uninterp1106;
PA_eflux_uninterp =cat(2,PA_eflux_uninterp1111,PA_eflux_uninterp1112);
%% 去除坏点 和 处理速度平滑
Br_interp(abs(Br_interp)>1e3) = nan; Bt_interp(abs(Bt_interp)>1e3) = nan; Bn_interp(abs(Bn_interp)>1e3) = nan;
Vr(abs(Vr)>5e3) = nan; Vt(abs(Vt)>5e3) = nan; Vn(abs(Vn)>5e3) = nan;
%% plot data
height = 0.08; space = 0.01;
x_mag = mag_epoch; step_mag = length(x_mag);
x_spc = spc_epoch; step_spc = length(x_spc);
x_spe = spe_epoch; step_spe = length(x_spe);
fi = figure; fontsize = 13;
set(gcf,'unit','normalized','position',[0.2,0.2,0.5,0.7]);

subplot('position',[0.15,0.10+height*8+space*8,0.7,height])
plot(x_mag,B_magni);
xlim([1 step_mag]);
ylabel('|B| [nT]')
grid on
datetick('x','mm/dd HH:MM') % set xtick as date
set(gca,'xticklabel',[]); % 不显示x坐标轴刻度
title(['PSP Encounter 1 (~2018/11/06)'],'fontsize', fontsize);

subplot('position',[0.15,0.10+height*7+space*7,0.7,height])
plot(x_mag,theta_BR);
xlim([1 step_mag]); ylim([0 180]);
ylabel('theta_{BR}')
grid on
datetick('x','mm/dd HH:MM') % set xtick as date
set(gca,'xticklabel',[]); % 不显示x坐标轴刻度

subplot('position',[0.15,0.10+height*6+space*6,0.7,height])
plot(x_mag,Br_interp);
xlim([1 step_mag]);
ylabel('B_R [nT]')
grid on
datetick('x','mm/dd HH:MM') % set xtick as date
set(gca,'xticklabel',[]); % 不显示x坐标轴刻度

subplot('position',[0.15,0.10+height*5+space*5,0.7,height])
plot(x_mag,Bt_interp);
xlim([1 step_mag]);
ylabel('B_T [nT]')
grid on
datetick('x','mm/dd HH:MM') % set xtick as date
set(gca,'xticklabel',[]); % 不显示x坐标轴刻度

subplot('position',[0.15,0.10+height*4+space*4,0.7,height])
plot(x_mag,Bn_interp);
xlim([1 step_mag]);
ylabel('B_N [nT]')
grid on
datetick('x','mm/dd HH:MM') % set xtick as date
set(gca,'xticklabel',[]); % 不显示x坐标轴刻度

subplot('position',[0.15,0.10+height*3+space*3,0.7,height])
plot(x_spc,Vr);
xlim([1 step_spc]); ylim([200 500]);
ylabel('V_R [km/s]')
grid on
datetick('x','mm/dd HH:MM') % set xtick as date
set(gca,'xticklabel',[]); % 不显示x坐标轴刻度

subplot('position',[0.15,0.10+height*2+space*2,0.7,height])
plot(x_spc,Vt);
xlim([1 step_spc]);
ylabel('V_T [km/s]')
grid on
datetick('x','mm/dd HH:MM') % set xtick as date
set(gca,'xticklabel',[]); % 不显示x坐标轴刻度

subplot('position',[0.15,0.10+height*1+space*1,0.7,height])
plot(x_spc,Vn);
xlim([1 step_spc]);
ylabel('V_N [km/s]')
grid on
datetick('x','mm/dd HH:MM') % set xtick as date

subplot('position',[0.15,0.08+height*0,0.7,height])
hold on
h = pcolor(log10(PA_eflux_uninterp));
set(h,'linestyle','none');
colormap jet
xlim([1 step_spe]); ylim([1 12]);
ylabel('PA [deg.]')
% set(gca,'xtick',[1;17587;36126;54666;73205;91744;110284;128823;147363;163367],'xticklabel',['05/20';'05/23';'05/26';'05/29';'06/01';'06/04';'06/07';'06/10';'06/13';'06/16']) % 20200607 E5
% set(gca,'xtick',[1;1/6*step_spe;2/6*step_spe;3/6*step_spe;4/6*step_spe;5/6*step_spe;step_spe],'xticklabel',['00:00';'04:00';'08:00';'12:00';'16:00';'20:00';'24:00']) % 20200607 E5
set(gca,'ytick',[1;4;8;12],'yticklabel',[0;60;120;180])
set(gca,'xticklabel',[]); % 不显示x坐标轴刻度
% datetick('x','mm/dd HH:MM') % set xtick as date
set(h,'displayname','314 eV')
legend

col = colorbar;
set(col,'position',[0.88 0.08 0.02 0.08]);
ylabel(col,'log{(eflux)}');
set(col,'fontsize',11)
box on

if save_or_not == 1
    saveas(fi,['D:\STUDY\PSP\Encounter 1\RESULT\Look_through_for_CME.png']);
end