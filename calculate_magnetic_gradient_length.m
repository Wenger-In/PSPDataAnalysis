clear all; close all;
encounter = 7;
dTime = 0.02; % unit:s
save_or_not = 0;
data_store = ['C:\Users\22242\Documents\STUDY\Data\PSP\Encounter ',num2str(encounter),'\'];
%% which encounter
if encounter == 5
end
if encounter == 6
end
if encounter == 7
    year = 2021;
    flap_num = 2;
    cross_num = [3,3];
    plot_beg_lst  = ['2021-01-17 13:00:00';'2021-01-17 14:30:00']; % i_flap
    plot_end_lst  = ['2021-01-17 15:00:00';'2021-01-17 14:50:00']; % i_flap
    fld_lst = ['12';'12'];
end
for i_flap = 1:1%flap_num
    close all;
    %% which flapping
    if encounter == 5
    end
    if encounter == 6
    end
    if encounter == 7
        if i_flap == 1
            cross_beg_lst = ['2021-01-17 13:27:50';'2021-01-17 14:14:30';'2021-01-17 14:40:33']; % i_cross
            cross_end_lst = ['2021-01-17 13:27:53';'2021-01-17 14:17:00';'2021-01-17 14:40:37']; % i_cross
            calc_beg_lst = ['2021-01-17 13:24:30';'2021-01-17 14:14:05';'2021-01-17 14:40:20']; % i_cross
            calc_ctr_lst = ['2021-01-17 13:30:10';'2021-01-17 14:16:30';'2021-01-17 14:40:30']; % i_cross
            calc_end_lst = ['2021-01-17 13:31:00';'2021-01-17 14:18:50';'2021-01-17 14:40:50']; % i_cross
        end
        if i_flap == 2
            cross_beg_lst = ['2021-01-17 13:27:45';'2021-01-17 14:10:00';'2021-01-17 14:40:30']; % i_cross
            cross_end_lst = ['2021-01-17 13:27:55';'2021-01-17 14:20:00';'2021-01-17 14:40:45']; % i_cross
            calc_beg_lst = ['2021-01-17 13:24:30';'2021-01-17 14:14:05';'2021-01-17 14:40:20']; % i_cross
            calc_ctr_lst = ['2021-01-17 13:30:10';'2021-01-17 14:16:30';'2021-01-17 14:40:30']; % i_cross
            calc_end_lst = ['2021-01-17 13:31:00';'2021-01-17 14:18:50';'2021-01-17 14:40:50']; % i_cross
        end
    end
    %% begin time and end time
    time_plot_beg = datenum(plot_beg_lst(i_flap,:));
    time_plot_end = datenum(plot_end_lst(i_flap,:));
    %% fld_data: Brtn
    fld_file = ['psp_fld_l2_mag_rtn_',plot_beg_lst(i_flap,1:4),plot_beg_lst(i_flap,6:7),plot_beg_lst(i_flap,9:10),fld_lst(i_flap,:),'_v02.cdf'];
    fld_dir = [data_store,fld_file];
    fld_info = spdfcdfinfo(fld_dir);
    
    fld_Epoch = spdfcdfread(fld_dir,'Variables','epoch_mag_RTN');
    Brtn = spdfcdfread(fld_dir,'Variables','psp_fld_l2_mag_RTN');
    Brtn(abs(Brtn)>1e3) = nan;
    Br = Brtn(:,1); Bt = Brtn(:,2); Bn = Brtn(:,3); B_mod = sqrt(Br.^2 + Bt.^2 + Bn.^2);
    
    fld_plot_index = find(fld_Epoch >= time_plot_beg & fld_Epoch <= time_plot_end);
    fld_Epoch_plot = fld_Epoch(fld_plot_index);
    Br_plot = Br(fld_plot_index); Bt_plot = Bt(fld_plot_index); Bn_plot = Bn(fld_plot_index); B_mod_plot = B_mod(fld_plot_index);
    %% spi_data: quality_flag, Vrtn
    spi_file = ['psp_swp_spi_sf00_l3_mom_inst_',plot_beg_lst(i_flap,1:4),plot_beg_lst(i_flap,6:7),plot_beg_lst(i_flap,9:10),'_v03.cdf'];
    spi_dir = [data_store,spi_file];
    spi_info = spdfcdfinfo(spi_dir);
    
    spi_Epoch = spdfcdfread(spi_dir,'Variables','Epoch');
    quality_flag = spdfcdfread(spi_dir,'Variables','QUALITY_FLAG');
    Vsc = spdfcdfread(spi_dir,'Variables','VEL');
    Vsc(abs(Vsc)>5e3) = nan;
    rot_mat = spdfcdfread(spi_dir,'Variables','ROTMAT_SC_INST');
    Vrtn = (rot_mat) * Vsc';
    Vr = -Vrtn(3,:); Vr_mean = nanmean(Vr);
    Vt =  Vrtn(1,:); Vt_mean = nanmean(Vt);
    Vn = -Vrtn(2,:); Vn_mean = nanmean(Vn);
    
    spi_plot_index = find(spi_Epoch >= time_plot_beg & spi_Epoch <= time_plot_end);
    spi_Epoch_plot = spi_Epoch(spi_plot_index);
    Vr_plot = Vr(spi_plot_index); Vt_plot = Vt(spi_plot_index); Vn_plot = Vn(spi_plot_index);
    Vrtn = [Vr;Vt;Vn];
    %% LMN coordinate
    ratio21_arr = zeros(1,cross_num(i_flap));
    ratio32_arr = zeros(1,cross_num(i_flap));
    e_L_arr = zeros(3,cross_num(i_flap));
    e_M_arr = zeros(3,cross_num(i_flap));
    e_N_arr = zeros(3,cross_num(i_flap));
    e_L_sum = zeros(3,1);
    
    for i_cross = 1:cross_num(i_flap)
        time_calc_beg = datenum(calc_beg_lst(i_cross,:));
        time_calc_end = datenum(calc_end_lst(i_cross,:));
        [V_sub, D_sub,ratio21,ratio32] = get_LMN(Br,Bt,Bn,fld_Epoch,time_calc_beg,time_calc_end); % ratio21 >= 3 is needed
        ratio21_arr(i_cross) = ratio21;
        ratio32_arr(i_cross) = ratio32;
        e_L_sub = V_sub(:,3)/(sqrt(dot(V_sub(:,3), V_sub(:,3))));
        e_M_sub = V_sub(:,2)/(sqrt(dot(V_sub(:,2), V_sub(:,2))));
        e_N_sub = V_sub(:,1)/(sqrt(dot(V_sub(:,1), V_sub(:,1))));
        e_L_arr(:,i_cross) = e_L_sub;
        e_M_arr(:,i_cross) = e_M_sub;
        e_N_arr(:,i_cross) = e_N_sub;
        e_L_sum = e_L_sum + e_L_sub;
    end
    
    e_L = e_L_sum/sqrt(dot(e_L_sum,e_L_sum)); % size 3*1
    e_M = cross([0,0,1],e_L); % size 1*3
    e_N = cross(e_L,e_M); % size 1*3
    V = cat(2,e_N',e_M',e_L);
    %% interpolation
    nTime = floor((time_plot_end - time_plot_beg)*86400/dTime);
    std_time = linspace(time_plot_beg, time_plot_end, nTime);
    std_Epoch = interp1(fld_Epoch_plot,fld_Epoch_plot,std_time,'pchip');
    Br_interp = interp1(fld_Epoch_plot,Br_plot,std_time,'linear'); Br_interp(isnan(Br_interp)) = nanmean(Br_interp);
    Bt_interp = interp1(fld_Epoch_plot,Bt_plot,std_time,'linear'); Bt_interp(isnan(Bt_interp)) = nanmean(Bt_interp);
    Bn_interp = interp1(fld_Epoch_plot,Bn_plot,std_time,'linear'); Bn_interp(isnan(Bn_interp)) = nanmean(Bn_interp);
    Vr_interp = interp1(spi_Epoch_plot,Vr_plot,std_time,'linear'); Vr_interp(isnan(Vr_interp)) = nanmean(Vr_interp);
    Vt_interp = interp1(spi_Epoch_plot,Vt_plot,std_time,'linear'); Vt_interp(isnan(Vt_interp)) = nanmean(Vt_interp);
    Vn_interp = interp1(spi_Epoch_plot,Vn_plot,std_time,'linear'); Vn_interp(isnan(Vn_interp)) = nanmean(Vn_interp);
    Brtn_interp = cat(2,Br_interp',Bt_interp',Bn_interp');
    Vrtn_interp = cat(2,Vr_interp',Vt_interp',Vn_interp');
    
    Bnml_interp = Brtn_interp * V; Vnml_interp = Vrtn_interp * V;
    BL_interp = Bnml_interp(:,3);
    BM_interp = Bnml_interp(:,2);
    BN_interp = Bnml_interp(:,1);
    VL_interp = Vnml_interp(:,3);
    VM_interp = Vnml_interp(:,2);
    VN_interp = Vnml_interp(:,1);
    %% calculate gradient length
    fit_arr = zeros(2,cross_num(i_flap));
    cc_arr = zeros(1,cross_num(i_flap));
    H_arr = zeros(1,cross_num(i_flap));
    for i_cross = 1:cross_num(i_flap)
        time_cross_beg = datenum(cross_beg_lst(i_cross,:)); 
        time_cross_end = datenum(cross_end_lst(i_cross,:));
        std_cross_index = find(std_Epoch >= time_cross_beg & std_Epoch <= time_cross_end);
        BL_cross = BL_interp(std_cross_index); BM_cross = BM_interp(std_cross_index); BN_cross = Bn_interp(std_cross_index);
        VL_cross = VL_interp(std_cross_index); VM_cross = VM_interp(std_cross_index); VN_cross = Vn_interp(std_cross_index);
        %% calculate dBL/dt
        dBL = diff(BL_cross); % unit:nT, size: size(BL_interp-1)
        dBL = [dBL(1),dBL'];
        dBLdt = dBL / dTime; % unit:nT/s
        %% linear fitting
        fit = polyfit(dBLdt,VN_cross,1);
        cc = corrcoef(dBLdt,VN_cross);
        fit_arr(:,i_cross) = fit';
        cc_arr(i_cross) = cc(1,2);
        
        fitX = linspace(min(dBLdt),max(dBLdt));
        fitY = polyval(fit,fitX);
        %% calculate gradient length
        BL_delta = BL_cross(length(BL_cross)-1) - BL_cross(2);
        H = abs(fit(1) * BL_delta); % unit:km
        H_arr(i_cross) = H;
        %% plot figures
        LineWidth = 2;
        FontSize = 8;
        PointSize = 10;
        row_num = ceil(cross_num(i_flap)/2);
        
        subplot(2,row_num,i_cross)
        scatter(dBLdt,VN_cross,PointSize,'filled')
        hold on
        plot(fitX,fitY,'LineWidth',LineWidth)
        grid on
        xlabel('dB_L/dt [nT/s]'); ylabel('V_N [km/s]');
        subtitle(['crossing ',num2str(i_cross)])
        set(gca,'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
    end
    
    sgtitle(['PSP enounter ',num2str(encounter),' ',plot_beg_lst(i_flap,1:4),plot_beg_lst(i_flap,6:7),plot_beg_lst(i_flap,9:10)]);
    
    if save_or_not == 1
        saveas(gcf,['C:\Users\22242\Documents\STUDY\Work\current_sheet_flapping\Encounter ',num2str(encounter),'\flapping_events\',plot_beg_lst(i_flap,1:4),plot_beg_lst(i_flap,6:7),plot_beg_lst(i_flap,9:10),'_',plot_beg_lst(i_flap,12:13),plot_beg_lst(i_flap,15:16),plot_beg_lst(i_flap,18:19),'-',plot_end_lst(i_flap,12:13),plot_end_lst(i_flap,15:16),plot_end_lst(i_flap,18:19),'.png']);
    end
end
%% function
function [V,D,ratio21,ratio32] = get_LMN(Br,Bt,Bn,fld_Epoch,time_calc_beg,time_calc_end)
    Br_calc = Br(find(fld_Epoch >= time_calc_beg & fld_Epoch <= time_calc_end)); Br_calc(isnan(Br_calc)) = nanmean(Br_calc);
    Bt_calc = Bt(find(fld_Epoch >= time_calc_beg & fld_Epoch <= time_calc_end)); Bt_calc(isnan(Bt_calc)) = nanmean(Bt_calc);
    Bn_calc = Bn(find(fld_Epoch >= time_calc_beg & fld_Epoch <= time_calc_end)); Bn_calc(isnan(Bn_calc)) = nanmean(Bn_calc);
    M = [mean(Br_calc.*Br_calc) - mean(Br_calc)*mean(Br_calc), mean(Br_calc.*Bt_calc) - mean(Br_calc)*mean(Bt_calc), mean(Br_calc.*Bn_calc) - mean(Br_calc)*mean(Bn_calc);
         mean(Bt_calc.*Br_calc) - mean(Bt_calc)*mean(Br_calc), mean(Bt_calc.*Bt_calc) - mean(Bt_calc)*mean(Bt_calc), mean(Bt_calc.*Bn_calc) - mean(Bt_calc)*mean(Bn_calc);
         mean(Bn_calc.*Br_calc) - mean(Bn_calc)*mean(Br_calc), mean(Bn_calc.*Bt_calc) - mean(Bn_calc)*mean(Bt_calc), mean(Bn_calc.*Bn_calc) - mean(Bn_calc)*mean(Bn_calc)];
    [V, D] = eig(M);
    lambda1 = D(1,1);lambda2 = D(2,2); lambda3 = D(3,3);% lambda1 < lambda2 < lambda3; order: N, M, L
    ratio21 = lambda2 / lambda1; ratio32 = lambda3 / lambda2;
end