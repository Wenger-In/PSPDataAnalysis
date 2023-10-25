%% event time
close all;
% time_available: 0310; 0312-0315, 0317-0331; 0401-0411, 0416, 0421-0423, 0428, 0430
day_num = 20190408; date_str = '20190408';
mag_dir00 = ['D:\STUDY\PSP\Reconnection\DATA\psp_fld_l2_mag_rtn_2019040800_v01.cdf'];
mag_dir06 = ['D:\STUDY\PSP\Reconnection\DATA\psp_fld_l2_mag_rtn_2019040806_v01.cdf'];
mag_dir12 = ['D:\STUDY\PSP\Reconnection\DATA\psp_fld_l2_mag_rtn_2019040812_v01.cdf'];
mag_dir18 = ['D:\STUDY\PSP\Reconnection\DATA\psp_fld_l2_mag_rtn_2019040818_v01.cdf'];
     spc_dir = ['D:\STUDY\PSP\Reconnection\DATA\psp_swp_spc_l3i_20190408_v01.cdf'];
% spe_dir = ['D:\STUDY\PSP\Reconnection\DATA\psp_swp_spe_sf0_l3_pad_20190313_v02.cdf'];
%% select time periods
is_sb_or_edge = 2; is_lead_or_trail = 1; save_or_not = 0; which_time = 0; % divided into 6 periods(every 4-hour): 00 - 04; 04 - 08; 08 - 12; 12 - 16; 16 - 20; 20 - 24;
if which_time == 0 % stare at
    hour_beg = 12; min_beg = 48; sec_beg = 40;
    hour_end = hour_beg; min_end = min_beg + 1; sec_end = sec_beg;
    which_time_period = '1249-1253';
end
if which_time == 1 % look through 00:00 - 04:00
    hour_beg = 00; min_beg = 00; sec_beg = 00;
    hour_end = 04; min_end = 00; sec_end = 00;
    which_time_period = '00-04';
end
if which_time == 2 % look through 04:00 - 08:00
    hour_beg = 04; min_beg = 00; sec_beg = 00;
    hour_end = 08; min_end = 00; sec_end = 00;
    which_time_period = '04-08';
end
if which_time == 3 % look through 08:00 - 12:00
    hour_beg = 08; min_beg = 00; sec_beg = 00;
    hour_end = 12; min_end = 00; sec_end = 00;
    which_time_period = '08-12';
end
if which_time == 4 % look through 12:00 - 16:00
    hour_beg = 12; min_beg = 00; sec_beg = 00;
    hour_end = 16; min_end = 00; sec_end = 00;
    which_time_period = '12-16';
end
if which_time == 5 % look through 16:00 - 20:00
    hour_beg = 16; min_beg = 00; sec_beg = 00;
    hour_end = 20; min_end = 00; sec_end = 00;
    which_time_period = '16-20';
end
if which_time == 6 % look through 20:00 - 24:00
    hour_beg = 20; min_beg = 00; sec_beg = 00;
    hour_end = 24; min_end = 00; sec_end = 00;
    which_time_period = '20-24';
end
year_str = date_str(1:4); mon_str = date_str(5:6); day_str = date_str(7:8);
year = str2double(year_str); month = str2double(mon_str); day = str2double(day_str);
time_beg = datenum(year,month,day,hour_beg,min_beg,sec_beg);
time_end = datenum(year,month,day,hour_end,min_end,sec_end);
%% load data
mag_info00 = spdfcdfinfo(mag_dir00);
mag_info06 = spdfcdfinfo(mag_dir06);
mag_info12 = spdfcdfinfo(mag_dir12);
mag_info18 = spdfcdfinfo(mag_dir18);
spc_info = spdfcdfinfo(spc_dir);
% spe_info = spdfcdfinfo(spe_dir);

mag_epoch00 = spdfcdfread(mag_dir00,'Variables','epoch_mag_RTN');
mag_epoch06 = spdfcdfread(mag_dir06,'Variables','epoch_mag_RTN');
mag_epoch12 = spdfcdfread(mag_dir12,'Variables','epoch_mag_RTN');
mag_epoch18 = spdfcdfread(mag_dir18,'Variables','epoch_mag_RTN');
mag_epoch = [[mag_epoch00;mag_epoch06];[mag_epoch12;mag_epoch18]];
spc_epoch = spdfcdfread(spc_dir,'Variables','Epoch');
% spe_epoch = spdfcdfread(spe_dir,'Variables','Epoch');

B_RTN00 = spdfcdfread(mag_dir00,'Variables','psp_fld_l2_mag_RTN');
B_RTN06 = spdfcdfread(mag_dir06,'Variables','psp_fld_l2_mag_RTN');
B_RTN12 = spdfcdfread(mag_dir12,'Variables','psp_fld_l2_mag_RTN');
B_RTN18 = spdfcdfread(mag_dir18,'Variables','psp_fld_l2_mag_RTN');
B_RTN = [[B_RTN00;B_RTN06];[B_RTN12;B_RTN18]];
Br = B_RTN(:,1);  Bt = B_RTN(:,2);  Bn = B_RTN(:,3); 
B_magni = sqrt(Br.^2 + Bt.^2 + Bn.^2);

V_RTN = spdfcdfread(spc_dir,'Variables','vp1_fit_RTN');
Vr = V_RTN(:,1);  Vt = V_RTN(:,2);  Vn = V_RTN(:,3); 
Np = spdfcdfread(spc_dir,'Variables','np1_fit');
Tp = spdfcdfread(spc_dir,'Variables','wp1_fit');

% PA_bin = spdfcdfread(spe_dir,'Variables','PITCHANGLE');
% PA_eflux_ori = spdfcdfread(spe_dir,'Variables','EFLUX_VS_PA_E');
% PA_eflux_uninterp = squeeze(PA_eflux_ori(:,9,:)); % row 9: 314.45 eV
%% 去除坏点
Br(abs(Br)>1e3) = nan; Bt(abs(Bt)>1e3) = nan; Bn(abs(Bn)>1e3) = nan;
Vr(abs(Vr)>5e3) = nan; Vt(abs(Vt)>5e3) = nan; Vn(abs(Vn)>5e3) = nan;
Np(abs(Np)>1e3) = nan; Tp(abs(Tp)>5e2) = nan;
%% interp 将粒子数据插值到磁场数据的时间序列
mag_time_seq = mag_epoch - mag_epoch(1);
spc_time_seq = spc_epoch - mag_epoch(1);
% spe_time_seq = spe_epoch - mag_epoch(1);
Vr = interp1(spc_time_seq, Vr, mag_time_seq);
Vt = interp1(spc_time_seq, Vt, mag_time_seq);
Vn = interp1(spc_time_seq, Vn, mag_time_seq);
Np = interp1(spc_time_seq, Np, mag_time_seq);
Tp = interp1(spc_time_seq, Tp, mag_time_seq);
% PA_eflux = ones(12,length(mag_epoch));
% for i= 1:12
%     PA_eflux(i,:) = interp1(spe_time_seq,PA_eflux_uninterp(i,:),mag_time_seq);
% end
%% a more detailing look: time_begin to time_end
sub_plot = find(mag_epoch >= time_beg & mag_epoch <= time_end);
Br = Br(sub_plot); Bt = Bt(sub_plot); Bn = Bn(sub_plot); B_magni = B_magni(sub_plot);
Vr = Vr(sub_plot); Vt = Vt(sub_plot); Vn = Vn(sub_plot);
Np = Np(sub_plot); Tp = Tp(sub_plot);
% PA_eflux = PA_eflux(:,sub_plot);
%% plot data
height = 0.15; space = 0.05;
x = mag_epoch(sub_plot);
step = length(x);
fi = figure; fontsize = 13;
set(gcf,'unit','normalized','position',[0.2,0.2,0.5,0.7]);

if is_sb_or_edge == 1 % in RTN coordiate
    Vr_notNan=Vr(~isnan(Vr));
    Vr_mean=sum(Vr_notNan)./length(Vr_notNan);
    Vr = Vr - Vr_mean;

    subplot('position',[0.15,0.15+height*3+space*3,0.7,height])
    plot(x,Br,'r');
    hold on
    plot(x,Bt,'g');
    hold on
    plot(x,Bn,'b');
    hold on
    plot(x,B_magni,'k');
    grid on
    xlim([1 step]);
    ylabel('B_{MAG} [nT]');
%     legend('B_R','B_T','B_N','|B|');
    datetick('x','mm/dd HH:MM:SS') % set ytick as date
    title([date_str],'fontsize', fontsize);
    
    subplot('position',[0.15,0.15+height*2+space*2,0.7,height])
    plot(x,Vr,'r');
    hold on
    plot(x,Vt,'g');
    hold on
    plot(x,Vn,'b');
    grid on
    xlim([1 step]);
    ylabel('V_p [km/s]');
%     legend('V_R','V_T','V_N');
    datetick('x','mm/dd HH:MM:SS') % set xtick as date
    
    subplot('position',[0.15,0.15+height*1+space*1,0.7,height])
    plot(x,Np);
    xlim([1 step]);
    ylabel('N_p [cm^{-3}]')
    datetick('x','mm/dd HH:MM:SS') % set xtick as date
    
    subplot('position',[0.15,0.15+height*0+space*0,0.7,height])
    plot(x,Tp);
    xlim([1 step]);
    ylabel('T_p [eV]')
    datetick('x','mm/dd HH:MM:SS') % set xtick as date
    
%     subplot('position',[0.15,0.15+height*0,0.7,height])
%     hold on
%     h = pcolor(log10(PA_eflux));
%     set(h,'linestyle','none');
%     colormap jet
%     xlim([1 step]);
%     ylabel('PA [deg.]')
%     set(gca,'ytick',[0;4;8;12],'yticklabel',[0;60;120;180])
%     set(h,'displayname','314 eV')
%     legend
%     
%     col = colorbar;
%     set(col,'position',[0.88 0.15 0.02 0.08]);
%     ylabel(col,'cc*(cm/s)^3');
%     set(col,'fontsize',11)
%     box on
    
    if save_or_not == 1
        saveas(fi,['D:\STUDY\PSP\Reconnection\RESULT\event\' num2str(day_num),'_',which_time_period,'.png']);
    end
end
if is_sb_or_edge == 2  % in LMN coordiate
    M = [mean(Br.*Br)-mean(Br)*mean(Br),mean(Br.*Bt)-mean(Br)*mean(Bt),mean(Br.*Bn)-mean(Br)*mean(Bn);mean(Bt.*Br)-mean(Bt)*mean(Br),mean(Bt.*Bt)-mean(Bt)*mean(Bt),mean(Bt.*Bn)-mean(Bt)*mean(Bn);mean(Bn.*Br)-mean(Bn)*mean(Br),mean(Bn.*Bt)-mean(Bn)*mean(Bt),mean(Bn.*Bn)-mean(Bn)*mean(Bn)];
    [V, D] = eig(M);
    e_n = V(:,1)/(sqrt(dot(V(:,1), V(:,1))));
    e_m = V(:,2)/(sqrt(dot(V(:,2), V(:,2))));
    e_l = V(:,3)/(sqrt(dot(V(:,3), V(:,3))));
    B_L = [1:step]; B_M = [1:step]; B_N = [1:step];
    V_L = [1:step]; V_M = [1:step]; V_N = [1:step];
    for i = 1:step
        B_L(i) = Br(i)*e_l(1) + Bt(i)*e_l(2) + Bn(i)*e_l(3);
        B_M(i) = Br(i)*e_m(1) + Bt(i)*e_m(2) + Bn(i)*e_m(3);
        B_N(i) = Br(i)*e_n(1) + Bt(i)*e_n(2) + Bn(i)*e_n(3);
        V_L(i) = Vr(i)*e_l(1) + Vt(i)*e_l(2) + Vn(i)*e_l(3);
        V_M(i) = Vr(i)*e_m(1) + Vt(i)*e_m(2) + Vn(i)*e_m(3);
        V_N(i) = Vr(i)*e_n(1) + Vt(i)*e_n(2) + Vn(i)*e_n(3);
    end
    V_L_notNan=V_L(~isnan(V_L));
    V_L_mean=sum(V_L_notNan)./length(V_L_notNan);
    V_L= V_L - V_L_mean;
    V_M_notNan=V_M(~isnan(V_M));
    V_M_mean=sum(V_M_notNan)./length(V_M_notNan);
    V_M = V_M - V_M_mean;
    V_N_notNan=V_N(~isnan(V_N));
    V_N_mean=sum(V_N_notNan)./length(V_N_notNan);
    V_N = V_N - V_N_mean;
    
    subplot('position',[0.15,0.15+height*3+space*3,0.7,height])
    plot(x,B_L,'r');
    hold on
    plot(x,B_M,'g');
    hold on
    plot(x,B_N,'b');
    hold on
    plot(x,B_magni,'k');
    grid on
    xlim([1 step]);
    ylabel('B_{MAG} [nT]');
    legend('B_L','B_M','B_N','|B|');
    datetick('x','mm/dd HH:MM:SS') % set ytick as date
    if is_lead_or_trail ==1
        title('Leading edge','fontsize', fontsize);
    end
    if is_lead_or_trail ==2
        title('Trailing edge','fontsize', fontsize);
    end
    
    subplot('position',[0.15,0.15+height*2+space*2,0.7,height])
    plot(x,V_L,'r');
    hold on
    plot(x,V_M,'g');
    hold on
    plot(x,V_N,'b');
    grid on
    xlim([1 step]);
    ylabel('V_p [km/s]');
    legend('V_L','V_M','V_N');
    datetick('x','mm/dd HH:MM:SS') % set xtick as date
    
    subplot('position',[0.15,0.15+height*1+space*1,0.7,height])
    plot(x,Np);
    xlim([1 step]);
    ylabel('N_p [cm^{-3}]')
    datetick('x','mm/dd HH:MM:SS') % set xtick as date
    
    subplot('position',[0.15,0.15+height*0+space*0,0.7,height])
    plot(x,Tp);
    xlim([1 step]);
    ylabel('T_p [eV]')
    datetick('x','mm/dd HH:MM:SS') % set xtick as date
    
    if save_or_not == 1
        if is_lead_or_trail == 1
            saveas(fi,['D:\STUDY\PSP\Reconnection\RESULT\event\' num2str(day_num),'_',which_time_period,'_edge_leading.png']);
        end
        if is_lead_or_trail == 2
            saveas(fi,['D:\STUDY\PSP\Reconnection\RESULT\event\' num2str(day_num),'_',which_time_period,'_edge_trailing.png']);
        end
    end
end