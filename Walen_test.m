clear all; close all;
encounter = 8;
dTime = 0.1; % unit: s
save_or_not = 0;
data_store = ['C:\Users\22242\Documents\STUDY\Data\PSP\Encounter ',num2str(encounter),'\'];
data_save  = ['C:\Users\22242\Documents\STUDY\Work\current_sheet_flapping\Encounter ',num2str(encounter),'\flapping_events\'];
%% which encounter
if encounter == 5
    year = 2020;
    flap_num = 2;
    cross_num = [4,4];
    spc_or_spi = ['i';'i'];
    plot_beg_lst = ['2020-06-08 00:00:00';'2020-06-08 00:55:00']; % i_flap
    plot_end_lst = ['2020-06-08 04:00:00';'2020-06-08 01:05:00']; % i_flap
    fld_lst = ['00';'00'];
end
if encounter == 6
    year = 2020;
    flap_num = 2;
    cross_num = [7,7];
    spc_or_spi = ['c';'c'];
    plot_beg_lst  = ['2020-09-21 01:00:00';'2020-09-21 03:07:00']; % i_flap
    plot_end_lst  = ['2020-09-21 05:00:00';'2020-09-21 03:12:00']; % i_flap
    fld_lst = ['00';'00'];
end
if encounter == 7
    year = 2021;
    flap_num = 2;
    cross_num = [5,5];
    spc_or_spi = ['i';'i'];
    plot_beg_lst  = ['2021-01-17 13:00:00';'2021-01-17 13:00:00']; % i_flap
    plot_end_lst  = ['2021-01-17 15:00:00';'2021-01-17 15:00:00']; % i_flap
    fld_lst = ['12';'12'];
end
if encounter == 8
    year = 2021;
    flap_num = 2;
    cross_num = [5,5];
    spc_or_spi = ['i';'i'];
    plot_beg_lst  = ['2021-04-29 07:30:00';'2021-04-29 07:30:00']; % i_flap
    plot_end_lst  = ['2021-04-29 10:30:00';'2021-04-29 10:30:00']; % i_flap
    fld_lst = ['06';'06'];
end
for i_flap = 2:2%flap_num
    close all;
    %% which flapping
    if encounter == 5
        if i_flap == 1
            calc_form_beg_lst = ['2020-06-08 00:50:00';'2020-06-08 01:54:10';'2020-06-08 02:14:00';'2020-06-08 02:27:05']; % i_cross
            calc_form_end_lst = ['2020-06-08 00:52:00';'2020-06-08 01:54:30';'2020-06-08 02:14:20';'2020-06-08 02:27:25']; % i_cross
            calc_late_beg_lst = ['2020-06-08 01:08:00';'2020-06-08 01:58:40';'2020-06-08 02:19:30';'2020-06-08 02:28:50']; % i_cross
            calc_late_end_lst = ['2020-06-08 01:10:00';'2020-06-08 01:59:00';'2020-06-08 02:19:50';'2020-06-08 02:29:10']; % i_cross
        end
    end
    if encounter == 6
        if i_flap == 1 % for Walen Test
            calc_form_beg_lst = ['2020-09-21 01:29:30';'2020-09-21 01:54:10';'2020-09-21 02:14:00';'2020-09-21 02:27:05';'2020-09-21 02:30:00';'2020-09-21 03:08:55';'2020-09-21 03:58:40']; % i_cross
            calc_form_end_lst = ['2020-09-21 01:29:34';'2020-09-21 01:54:30';'2020-09-21 02:14:20';'2020-09-21 02:27:25';'2020-09-21 02:30:20';'2020-09-21 03:09:15';'2020-09-21 03:58:50']; % i_cross
            calc_late_beg_lst = ['2020-09-21 01:29:30';'2020-09-21 01:58:40';'2020-09-21 02:19:30';'2020-09-21 02:28:50';'2020-09-21 02:31:00';'2020-09-21 03:09:40';'2020-09-21 03:59:20']; % i_cross
            calc_late_end_lst = ['2020-09-21 01:29:34';'2020-09-21 01:59:00';'2020-09-21 02:19:50';'2020-09-21 02:29:10';'2020-09-21 02:31:20';'2020-09-21 03:10:00';'2020-09-21 03:59:30']; % i_cross
        end
        if i_flap == 2 % for Smith Test
            calc_form_beg_lst = ['2020-09-21 01:27:40';'2020-09-21 01:54:10';'2020-09-21 02:14:00';'2020-09-21 02:27:05';'2020-09-21 02:30:00';'2020-09-21 03:08:55';'2020-09-21 03:58:40']; % i_cross
            calc_form_end_lst = ['2020-09-21 01:28:00';'2020-09-21 01:54:30';'2020-09-21 02:14:20';'2020-09-21 02:27:25';'2020-09-21 02:30:20';'2020-09-21 03:09:15';'2020-09-21 03:58:50']; % i_cross
            calc_late_beg_lst = ['2020-09-21 01:28:50';'2020-09-21 01:58:40';'2020-09-21 02:19:30';'2020-09-21 02:28:50';'2020-09-21 02:31:00';'2020-09-21 03:09:40';'2020-09-21 03:59:20']; % i_cross
            calc_late_end_lst = ['2020-09-21 01:29:10';'2020-09-21 01:59:00';'2020-09-21 02:19:50';'2020-09-21 02:29:10';'2020-09-21 02:31:20';'2020-09-21 03:10:00';'2020-09-21 03:59:30']; % i_cross
        end
    end
    if encounter == 7
        if i_flap == 1 % for Walen Test
            calc_form_beg_lst = ['2021-01-17 13:27:30';'2021-01-17 14:03:00';'2021-01-17 14:03:39';'2021-01-17 14:12:00';'2021-01-17 14:37:00']; % i_cross
            calc_form_end_lst = ['2021-01-17 13:27:50';'2021-01-17 14:03:20';'2021-01-17 14:03:59';'2021-01-17 14:12:20';'2021-01-17 14:37:20']; % i_cross
            calc_late_beg_lst = ['2021-01-17 13:32:30';'2021-01-17 14:03:39';'2021-01-17 14:07:39';'2021-01-17 14:18:00';'2021-01-17 14:44:00']; % i_cross
            calc_late_end_lst = ['2021-01-17 13:32:50';'2021-01-17 14:03:59';'2021-01-17 14:07:59';'2021-01-17 14:18:20';'2021-01-17 14:44:20']; % i_cross
        end
        if i_flap == 2 % for Smith Test
            calc_form_beg_lst = ['2021-01-17 13:27:30';'2021-01-17 14:03:00';'2021-01-17 14:03:39';'2021-01-17 14:12:00';'2021-01-17 14:37:00']; % i_cross
            calc_form_end_lst = ['2021-01-17 13:27:50';'2021-01-17 14:03:20';'2021-01-17 14:03:59';'2021-01-17 14:12:20';'2021-01-17 14:37:20']; % i_cross
            calc_late_beg_lst = ['2021-01-17 13:32:30';'2021-01-17 14:03:39';'2021-01-17 14:07:39';'2021-01-17 14:18:00';'2021-01-17 14:44:00']; % i_cross
            calc_late_end_lst = ['2021-01-17 13:32:50';'2021-01-17 14:03:59';'2021-01-17 14:07:59';'2021-01-17 14:18:20';'2021-01-17 14:44:20']; % i_cross
        end
    end
    if encounter == 8
        if i_flap == 1 % for Walen Test
            calc_form_beg_lst = ['2021-04-29 08:26:00';'2021-04-29 09:12:00';'2021-04-29 09:14:30';'2021-04-29 09:23:00';'2021-04-29 09:30:00']; % i_cross
            calc_form_end_lst = ['2021-04-29 08:27:00';'2021-04-29 09:12:30';'2021-04-29 09:15:00';'2021-04-29 09:24:00';'2021-04-29 09:32:00']; % i_cross
            calc_late_beg_lst = ['2021-04-29 08:29:00';'2021-04-29 09:14:30';'2021-04-29 09:15:15';'2021-04-29 09:26:00';'2021-04-29 10:23:00']; % i_cross
            calc_late_end_lst = ['2021-04-29 08:30:00';'2021-04-29 09:15:00';'2021-04-29 09:15:45';'2021-04-29 09:27:00';'2021-04-29 10:25:00']; % i_cross
        end
        if i_flap == 2 % for Smith Test
            calc_form_beg_lst = ['2021-04-29 08:26:00';'2021-04-29 09:12:00';'2021-04-29 09:14:30';'2021-04-29 09:23:00';'2021-04-29 10:07:00']; % i_cross
            calc_form_end_lst = ['2021-04-29 08:27:00';'2021-04-29 09:12:30';'2021-04-29 09:15:00';'2021-04-29 09:24:00';'2021-04-29 10:08:00']; % i_cross
            calc_late_beg_lst = ['2021-04-29 08:29:00';'2021-04-29 09:14:30';'2021-04-29 09:15:15';'2021-04-29 09:26:00';'2021-04-29 10:12:00']; % i_cross
            calc_late_end_lst = ['2021-04-29 08:30:00';'2021-04-29 09:15:00';'2021-04-29 09:15:45';'2021-04-29 09:27:00';'2021-04-29 10:13:00']; % i_cross
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
    %% spc_data: sc_pos, sc_vel
    spc_file = ['psp_swp_spc_l3i_',plot_beg_lst(i_flap,1:4),plot_beg_lst(i_flap,6:7),plot_beg_lst(i_flap,9:10),'_v02.cdf'];
    spc_dir = [data_store,spc_file];
    spc_info = spdfcdfinfo(spc_dir);
    
    spc_Epoch = spdfcdfread(spc_dir,'Variables','Epoch');
    Vrtn_spc = spdfcdfread(spc_dir,'Variables','vp_moment_RTN');
    Np_spc = spdfcdfread(spc_dir,'Variables','np_moment');
    Tp_spc = spdfcdfread(spc_dir,'Variables','wp_moment');
    sc_pos_HCI = spdfcdfread(spc_dir,'Variables','sc_pos_HCI');
    sc_vel_HCI = spdfcdfread(spc_dir,'Variables','sc_vel_HCI');
    sc_pos_HCIx = sc_pos_HCI(:,1); sc_vel_HCIx = sc_vel_HCI(:,1);
    sc_pos_HCIy = sc_pos_HCI(:,2); sc_vel_HCIy = sc_vel_HCI(:,2);
    sc_pos_HCIz = sc_pos_HCI(:,3); sc_vel_HCIz = sc_vel_HCI(:,3);
    [sc_vel_RTNr,sc_vel_RTNt,sc_vel_RTNn] = calc_HCI2SCRTN(sc_vel_HCIx,sc_vel_HCIy,sc_vel_HCIz,sc_pos_HCIx,sc_pos_HCIy,sc_pos_HCIz);
    sc_vel_RTN = [sc_vel_RTNr,sc_vel_RTNt,sc_vel_RTNn];
    %% spi_data: quality_flag, Vrtn, Np, Tp
    spi_file = ['psp_swp_spi_sf00_l3_mom_inst_',plot_beg_lst(i_flap,1:4),plot_beg_lst(i_flap,6:7),plot_beg_lst(i_flap,9:10),'_v03.cdf'];
    spi_dir = [data_store,spi_file];
    spi_info = spdfcdfinfo(spi_dir);
    
    spi_Epoch = spdfcdfread(spi_dir,'Variables','Epoch');
    quality_flag = spdfcdfread(spi_dir,'Variables','QUALITY_FLAG');
    Vsc = spdfcdfread(spi_dir,'Variables','VEL');
    Vsc(abs(Vsc)>5e3) = nan;
    SC2RTN = spdfcdfread(spi_dir,'Variables','ROTMAT_SC_INST');
    Vrtn2sc = (SC2RTN) * Vsc';
    %% switch Vrtn to inertial RTN frame
    sc_vel_RTNr_interp = interp1(spc_Epoch,sc_vel_RTNr,spi_Epoch,'pchip');
    sc_vel_RTNt_interp = interp1(spc_Epoch,sc_vel_RTNt,spi_Epoch,'pchip');
    sc_vel_RTNn_interp = interp1(spc_Epoch,sc_vel_RTNn,spi_Epoch,'pchip');
    Vr2sc = -Vrtn2sc(3,:); Vr = Vr2sc + sc_vel_RTNr_interp'; Vr_mean = nanmean(Vr);
    Vt2sc =  Vrtn2sc(1,:); Vt = Vt2sc + sc_vel_RTNt_interp'; Vt_mean = nanmean(Vt);
    Vn2sc = -Vrtn2sc(2,:); Vn = Vn2sc + sc_vel_RTNn_interp'; Vn_mean = nanmean(Vn);
    Vrtn = [Vr;Vt;Vn];
    Np_spi = spdfcdfread(spi_dir,'Variables','DENS');
    Np_spi(abs(Np_spi)>5e3) = nan;
    Tp_spi = spdfcdfread(spi_dir,'Variables','TEMP');
    Tp_spi(abs(Tp_spi)>1e2) = nan;
    
    spi_plot_index = find(spi_Epoch >= time_plot_beg & spi_Epoch <= time_plot_end);
    spc_plot_index = find(spc_Epoch >= time_plot_beg & spc_Epoch <= time_plot_end);
    spi_Epoch_plot = spi_Epoch(spi_plot_index);
    Vr_spi_plot = Vr(spi_plot_index); Vt_spi_plot = Vt(spi_plot_index); Vn_spi_plot = Vn(spi_plot_index);
    Np_spi_plot = Np_spi(spi_plot_index); Tp_spi_plot = Tp_spi(spi_plot_index);
    
    spc_Epoch_plot = spc_Epoch(spc_plot_index);
    Vrtn_spc_plot = Vrtn_spc(spc_plot_index,:);
    Vr_spc_plot = Vrtn_spc_plot(:,1); Vt_spc_plot = Vrtn_spc_plot(:,2); Vn_spc_plot = Vrtn_spc_plot(:,3);
    Vr_spc_plot(abs(Vr_spc_plot)>1e3) = nan; Vt_spc_plot(abs(Vt_spc_plot)>1e3) = nan; Vn_spc_plot(abs(Vn_spc_plot)>1e3) = nan; 
    Np_spc_plot = Np_spc(spc_plot_index); Tp_spc_plot = Tp_spc(spc_plot_index);
    %% interpolation
    nTime = floor((time_plot_end - time_plot_beg)*86400/dTime);
    std_time = linspace(time_plot_beg, time_plot_end, nTime);
    
    std_Epoch = interp1(fld_Epoch_plot,fld_Epoch_plot,std_time,'pchip');
    Br_interp = interp1(fld_Epoch_plot,Br_plot,std_time,'linear'); Br_interp(isnan(Br_interp)) = nanmean(Br_interp);
    Bt_interp = interp1(fld_Epoch_plot,Bt_plot,std_time,'linear'); Bt_interp(isnan(Bt_interp)) = nanmean(Bt_interp);
    Bn_interp = interp1(fld_Epoch_plot,Bn_plot,std_time,'linear'); Bn_interp(isnan(Bn_interp)) = nanmean(Bn_interp);
    Vr_spc_interp = interp1(spc_Epoch_plot,Vr_spc_plot,std_time,'linear'); Vr_spc_interp(isnan(Vr_spc_interp)) = nanmean(Vr_spc_interp);
    Vt_spc_interp = interp1(spc_Epoch_plot,Vt_spc_plot,std_time,'linear'); Vt_spc_interp(isnan(Vt_spc_interp)) = nanmean(Vt_spc_interp);
    Vn_spc_interp = interp1(spc_Epoch_plot,Vn_spc_plot,std_time,'linear'); Vn_spc_interp(isnan(Vn_spc_interp)) = nanmean(Vn_spc_interp);
    Vr_spi_interp = interp1(spi_Epoch_plot,Vr_spi_plot,std_time,'linear'); Vr_spi_interp(isnan(Vr_spi_interp)) = nanmean(Vr_spi_interp);
    Vt_spi_interp = interp1(spi_Epoch_plot,Vt_spi_plot,std_time,'linear'); Vt_spi_interp(isnan(Vt_spi_interp)) = nanmean(Vt_spi_interp);
    Vn_spi_interp = interp1(spi_Epoch_plot,Vn_spi_plot,std_time,'linear'); Vn_spi_interp(isnan(Vn_spi_interp)) = nanmean(Vn_spi_interp);
    Np_spc_interp = interp1(spc_Epoch_plot,Np_spc_plot,std_time,'linear'); Np_spc_interp(isnan(Np_spc_interp)) = nanmean(Np_spc_interp);
    Tp_spc_interp = interp1(spc_Epoch_plot,Tp_spc_plot,std_time,'linear'); Tp_spc_interp(isnan(Tp_spc_interp)) = nanmean(Tp_spc_interp);
    Np_spi_interp = interp1(spi_Epoch_plot,Np_spi_plot,std_time,'linear'); Np_spi_interp(isnan(Np_spi_interp)) = nanmean(Np_spi_interp);
    Tp_spi_interp = interp1(spi_Epoch_plot,Tp_spi_plot,std_time,'linear'); Tp_spi_interp(isnan(Tp_spi_interp)) = nanmean(Tp_spi_interp);
    Brtn_interp = cat(2,Br_interp',Bt_interp',Bn_interp'); B_mod_interp = sqrt(Br_interp.^2 + Bt_interp.^2 + Bn_interp.^2);
    Vrtn_spc_interp = cat(2,Vr_spc_interp',Vt_spc_interp',Vn_spc_interp');
    Vrtn_spi_interp = cat(2,Vr_spi_interp',Vt_spi_interp',Vn_spi_interp');
    
    e_LMN_arr = importdata([data_save,'e_LMN.csv']);
    e_L_arr = e_LMN_arr(:,1:cross_num);
    e_M_arr = e_LMN_arr(:,cross_num+1:2*cross_num);
    e_N_arr = e_LMN_arr(:,2*cross_num+1:3*cross_num);
    Smith_P1_arr = zeros(1,cross_num(i_flap));
    Smith_P2_arr = zeros(1,cross_num(i_flap));
    
    for i_cross = 1:cross_num(i_flap)
        close all;
        
        time_form_beg = datenum(calc_form_beg_lst(i_cross,:));
        time_form_end = datenum(calc_form_end_lst(i_cross,:));
        time_late_beg = datenum(calc_late_beg_lst(i_cross,:));
        time_late_end = datenum(calc_late_end_lst(i_cross,:));
        
        form_index = find(std_Epoch >= time_form_beg & std_Epoch <= time_form_end);
        late_index = find(std_Epoch >= time_late_beg & std_Epoch <= time_late_end);
        Vrtn_spi_form = Vrtn_spi_interp(form_index,:); Vrtn_spi_late = Vrtn_spi_interp(late_index,:);
        Vrtn_spc_form = Vrtn_spc_interp(form_index,:); Vrtn_spc_late = Vrtn_spc_interp(late_index,:);
        Brtn_form = Brtn_interp(form_index,:); Brtn_late = Brtn_interp(late_index,:);
        Np_spc_form = Np_spc_interp(form_index); Np_spc_late = Np_spc_interp(late_index);
        Np_spi_form = Np_spi_interp(form_index); Np_spi_late = Np_spi_interp(late_index);
        Vrtn_spi_calc = cat(1,Vrtn_spi_form,Vrtn_spi_late);
        Vrtn_spc_calc = cat(1,Vrtn_spc_form,Vrtn_spc_late);
        Brtn_calc = cat(1,Brtn_form,Brtn_late);
        Np_spc_calc = cat(2,Np_spc_form,Np_spc_late);
        Np_spi_calc = cat(2,Np_spi_form,Np_spi_late);
        %% Smith Test
        % P1>0.40 & P2<0.22: RD
        % P1<0.22 & P2>0.22: TD
        % P1>0.22 & P2>0.22: ND
        % P1<0.40 & P2<0.22: ED
        
        V = cat(2,e_N_arr(:,i_cross),e_M_arr(:,i_cross),e_L_arr(:,i_cross));
        
        Bnml_form = Brtn_form * V; Bnml_late = Brtn_late * V;
        BL_form = Bnml_form(:,3); BM_form = Bnml_form(:,2); BN_form = Bnml_form(:,1);
        BL_late = Bnml_late(:,3); BM_late = Bnml_late(:,2); BN_late = Bnml_late(:,1);
        B_module_form = sqrt(BL_form.^2 + BM_form.^2 + BN_form.^2);
        B_module_late = sqrt(BL_late.^2 + BM_late.^2 + BN_late.^2);
        BN_module_mean = mean(cat(1,BN_form,BN_late));
        B_module_form_mean = mean(B_module_form); B_module_late_mean = mean(B_module_late);
        
        Smith_P1_arr(i_cross) = abs(BN_module_mean) / max(B_module_form_mean,B_module_late_mean);
        Smith_P2_arr(i_cross) = abs(B_module_form_mean - B_module_late_mean) / max(B_module_form_mean,B_module_late_mean);
        %% get V_HT
        if spc_or_spi(i_flap,:) == 'c'
            Vrtn_calc = Vrtn_spc_calc;
            Np_calc = Np_spc_calc;
        end
        if spc_or_spi(i_flap,:) == 'i'
            Vrtn_calc = Vrtn_spi_calc;
            Np_calc = Np_spi_calc;
        end
        V_HT = get_V_HT(Vrtn_calc,Brtn_calc); % spc or spi
        Vrtn2HT = Vrtn_calc - V_HT; % spc or spi
        %% Walen analysis
        mu0 = 4*3.1415926535 *10^-7; mp = 1.67 * 10^-27;
        Vr_Alf = Brtn_calc(:,1) ./ sqrt(mu0 * mp * Np_calc) * 1e-15;
        Vt_Alf = Brtn_calc(:,2) ./ sqrt(mu0 * mp * Np_calc) * 1e-15;
        Vn_Alf = Brtn_calc(:,3) ./ sqrt(mu0 * mp * Np_calc) * 1e-15;
        Vrtn_Alf = cat(2,Vr_Alf,Vt_Alf,Vn_Alf);
        %% H-T frame quality
        E_id = zeros(length(form_index) + length(late_index),3);
        E_HT = zeros(length(form_index) + length(late_index),3);
        for i_time = 1:length(form_index) + length(late_index)
            E_id(i_time,:) = cross(Vrtn_calc(i_time,:),Brtn_calc(i_time,:));
            E_HT(i_time,:) = cross(Vrtn2HT(i_time,:),Brtn_calc(i_time,:));
        end
        %% plot figures
        LineWidth = 1.5;
        FontSize = 8;
        PointSize = 10;
        fig_num = 3;
        
        subplot(1,2,1)
        scatter(Vrtn_Alf(:,1), Vrtn2HT(:,1), PointSize); hold on
        scatter(Vrtn_Alf(:,2), Vrtn2HT(:,2), PointSize); hold on
        scatter(Vrtn_Alf(:,3), Vrtn2HT(:,3), PointSize); grid on
        legend('R','T','N')
        xlabel('V_A [km/s]'); ylabel('V - V_{HT} [km/s]');
        subtitle('Walen Analysis');
        
        subplot(1,2,2)
        scatter(E_id(:,1),E_HT(:,1),PointSize); hold on
        scatter(E_id(:,2),E_HT(:,2),PointSize); hold on
        scatter(E_id(:,3),E_HT(:,3),PointSize); grid on
        legend('R','T','N')
        xlabel('V_{HT} \times B [km/s*nT]'); ylabel('V \times B [km/s*nT]');
        xlim([-1000 1000]);
        subtitle('H-T Frame Quality');
        
        sgtitle(['PSP enounter ',num2str(encounter),' ',plot_beg_lst(i_flap,1:4),plot_beg_lst(i_flap,6:7),plot_beg_lst(i_flap,9:10),' crossing ',num2str(i_cross)]);
        if save_or_not == 1
            saveas(gcf,['C:\Users\22242\Documents\STUDY\Work\current_sheet_flapping\Encounter ',num2str(encounter),'\flapping_events\',plot_beg_lst(i_flap,1:4),plot_beg_lst(i_flap,6:7),plot_beg_lst(i_flap,9:10),'\crossing_',num2str(i_cross),'_Walen_Test.png']);
        end
    end
end

%% functions
function [x_RTN,y_RTN,z_RTN] = calc_HCI2SCRTN(x_HCI,y_HCI,z_HCI,SC_HCIx,SC_HCIy,SC_HCIz)
%Change the coordiantes xyz in HCI frame to xyz in spacecraft RTN frame
%   input: x_HCI, y_HCI, z_HCI, the velocity in HCI frame (km/s)
%          SC_HCIx, SC_HCIy, SC_HCIz, the sapcecraft position in HCI frame (km)
%   output: x_RTN, y_RTN, z_RTN,the velocity in SC RTN frame (km/s)
%   This function does not consider the move of the origin (using for velocity conversion)
    num = length(x_HCI);
    xyz_RTN = zeros(num,3);
    for i = 1:num
        Q = zeros(3,3);
        x1 = [1 0 0];
        y1 = [0 1 0];
        z1 = [0 0 1];
        x2 = [SC_HCIx(i),SC_HCIy(i),SC_HCIz(i)];
        if norm(x2)~= 0
            x2 = x2/norm(x2);
        end
        y2 = cross(z1,x2);
        if norm(y2)~= 0
            y2 = y2/norm(y2);
        end
        z2 = cross(x2,y2);
        if norm(z2)~= 0
            z2 = z2/norm(z2);
        end
        Q(1,1) = dot(x2,x1); Q(1,2) = dot(x2,y1); Q(1,3) = dot(x2,z1);
        Q(2,1) = dot(y2,x1); Q(2,2) = dot(y2,y1); Q(2,3) = dot(y2,z1);
        Q(3,1) = dot(z2,x1); Q(3,2) = dot(z2,y1); Q(3,3) = dot(z2,z1);
        xyz_RTN(i,:) = Q*[x_HCI(i);y_HCI(i);z_HCI(i)];
    end
    x_RTN = xyz_RTN(:,1); y_RTN = xyz_RTN(:,2); z_RTN = xyz_RTN(:,3);
end
function V_HT = get_V_HT(v,B)
%Get velocity of deHoffmann-Tellor frame
%   input: v(n*3), time series of velocity vectors
%          B(n*3), time series of magnetic field vectors
%   output: v_HT, velocity of deHoffmann-Tellor frame
    norm_B = sqrt(sum(B.^2,2));
    K = zeros(3,3);
    K_dot_v = zeros(3,3);
    for i = 1:3
        for j= 1:3
           K(i,j) = mean(norm_B.^2.*kroneckerDelta(sym(i),sym(j))-B(:,i).*B(:,j));
           K_dot_v(i,j) = mean((norm_B.^2.*kroneckerDelta(sym(i),sym(j))-B(:,i).*B(:,j)).*v(:,j));
        end
    end
    K_dot_v = sum(K_dot_v,2);
    V_HT = K^(-1)*K_dot_v;
    V_HT = [double(V_HT(1)), double(V_HT(2)), double(V_HT(3))];
end