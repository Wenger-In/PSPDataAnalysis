%% load data
clear all;close all;
day_num = 20201015; %date
V_info = spdfcdfinfo('D:\Reconnection\DATA\solo_l2_swa-pas-grnd-mom_20201015_v01.cdf');
B_info = spdfcdfinfo('D:\Reconnection\DATA\solo_l2_mag-rtn-normal_20201015_v01.cdf');
V_epoch = spdfcdfread('D:\Reconnection\DATA\solo_l2_swa-pas-grnd-mom_20201015_v01.cdf','Variables','Epoch');
B_epoch = spdfcdfread('D:\Reconnection\DATA\solo_l2_mag-rtn-normal_20201015_v01.cdf','Variables','EPOCH');
V_RTN = spdfcdfread('D:\Reconnection\DATA\solo_l2_swa-pas-grnd-mom_20201015_v01.cdf','Variables','V_RTN');
B_RTN = spdfcdfread('D:\Reconnection\DATA\solo_l2_mag-rtn-normal_20201015_v01.cdf','Variables','B_RTN');
%% interpolation
B_time_seq = B_epoch - V_epoch(1);
V_time_seq = V_epoch - V_epoch(1);
% V_RTN = interp1(V_time_seq, V_RTN, B_time_seq);
%% data components
V_R = V_RTN(:,1);  V_T = V_RTN(:,2);  V_N = V_RTN(:,3); %v-RTN components
V_R = interp1(V_time_seq, V_R, B_time_seq);
V_T = interp1(V_time_seq, V_T, B_time_seq);
V_N = interp1(V_time_seq, V_N, B_time_seq);
B_R = B_RTN(:,1);  B_T = B_RTN(:,2);  B_N = B_RTN(:,3); %B-RTN components
V = sqrt(V_R.^2 + V_T.^2 + V_N.^2);
B_magnitude = sqrt(B_R.^2 + B_T.^2 + B_N.^2);
%% LMN coordinate
% t_beg = 10439; t_mid = 20812; t_end = 35639; 
t_beg = 17474; t_mid = 20812; t_end = 28659; % 00:36-01:00
B_R_be = B_R(t_beg:t_end); B_T_be = B_T(t_beg:t_end); B_N_be = B_N(t_beg:t_end); 
B_bm = B_magnitude(t_beg:t_mid); B_me = B_magnitude(t_mid:t_end);
B_bm_bar = mean(B_bm); B_me_bar = mean(B_me);
B_L = max(B_bm_bar, B_me_bar); B_delta = abs(B_bm_bar - B_me_bar);
M = [mean(B_R_be.*B_R_be) - mean(B_R_be)*mean(B_R_be), mean(B_R_be.*B_T_be) - mean(B_R_be)*mean(B_T_be), mean(B_R_be.*B_N_be) - mean(B_R_be)*mean(B_N_be);
     mean(B_T_be.*B_R_be) - mean(B_T_be)*mean(B_R_be), mean(B_T_be.*B_T_be) - mean(B_T_be)*mean(B_T_be), mean(B_T_be.*B_N_be) - mean(B_T_be)*mean(B_N_be);
     mean(B_N_be.*B_R_be) - mean(B_N_be)*mean(B_R_be), mean(B_N_be.*B_T_be) - mean(B_N_be)*mean(B_T_be), mean(B_N_be.*B_N_be) - mean(B_N_be)*mean(B_N_be)];
[V, D] = eig(M);
e_L= V(:,3)/(sqrt(dot(V(:,3), V(:,3)))); e_M = V(:,2)/(sqrt(dot(V(:,2), V(:,2)))); e_N = V(:,1)/(sqrt(dot(V(:,1), V(:,1))));
%% Result: P1 = 0.0287; P2 = 0.3454;
B_R_bm_bar = mean(B_R(t_beg:t_mid)); B_T_bm_bar = mean(B_T(t_beg:t_mid)); B_N_bm_bar = mean(B_N(t_beg:t_mid)); 
B_RTN_bm = [B_R_bm_bar, B_T_bm_bar, B_N_bm_bar]; B_n = abs(dot(B_RTN_bm, e_N));
P1 = B_n/B_L; P2 = B_delta/B_L;