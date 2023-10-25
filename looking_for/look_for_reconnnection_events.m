clear; close all;
encounter = 8;
save_or_not = 0;
data_store = ['E:\Research\Data\PSP\Encounter ',num2str(encounter),'\'];
if encounter == 5
    year = 2020;
    date_list = ['0520';'0521';'0522';'0523';'0524';'0525';'0526';'0527';'0528';'0529';'0530';'0531';'0601';'0602';'0603';'0604';'0605';'0606';'0607';'0608';'0609';'0610';'0611';'0612';'0613';'0614';'0615'];
end
if encounter == 6
    year = 2020;
    date_list = ['0918';'0919';'0920';'0921';'0922';'0923';'0924';'0925';'0926';'0927';'0928';'0929';'0930';'1001';'1002'];
end
if encounter == 7
    year = 2021;
    date_list = ['0109';'0110';'0111';'0112';'0113';'0114';'0115';'0116';'0117';'0118';'0119';'0120';'0121';'0122';'0123'];    
end
if encounter == 8
    year = 2021;
    date_list = ['0420';'0421';'0422';'0423';'0424';'0425';'0426';'0427';'0428';'0429';'0430';'0501';'0502';'0503';'0504'];
end
for i_date = 1 : 1%length(date_list)
    close all;
    %% fld_data：Brtn
    fld_list = ['00';'06';'12';'18'];
    fld_file = ['psp_fld_l2_mag_rtn_',num2str(year),date_list(i_date,:),fld_list(1,:),'_v02.cdf'];
    fld_dir = [data_store,fld_file];
    fld_info = spdfcdfinfo(fld_dir);
    
    fld_Epoch = spdfcdfread(fld_dir,'Variables','epoch_mag_RTN');
    Brtn = spdfcdfread(fld_dir,'Variables','psp_fld_l2_mag_RTN');
    for i_fld = 2 : length(fld_list)
        fld_file_sub = ['psp_fld_l2_mag_rtn_',num2str(year),date_list(i_date,:),fld_list(i_fld,:),'_v02.cdf'];
        fld_dir_sub = [data_store,fld_file_sub];
        fld_Epoch_sub = spdfcdfread(fld_dir_sub,'Variables','epoch_mag_RTN');
        Brtn_sub = spdfcdfread(fld_dir_sub,'Variables','psp_fld_l2_mag_RTN');
        fld_Epoch = cat(1,fld_Epoch,fld_Epoch_sub);
        Brtn = cat(1,Brtn,Brtn_sub);
    end
    Brtn(abs(Brtn)>1e3) = nan;
    Br = Brtn(:,1); Bt = Brtn(:,2); Bn = Brtn(:,3);
    B_mod = sqrt(Br.^2 + Bt.^2 + Bn.^2);
    %% spc_data: Vrtn_spc, Np_spc, Tp_spc
    spc_file = ['psp_swp_spc_l3i_',num2str(year),date_list(i_date,:),'_v02.cdf'];
    spc_dir = [data_store,spc_file];
    spc_info = spdfcdfinfo(spc_dir);
    
    spc_Epoch = spdfcdfread(spc_dir,'Variables','Epoch');
    general_flag = spdfcdfread(spc_dir,'Variables','general_flag');
    Vrtn_spc = spdfcdfread(spc_dir,'Variables','vp_moment_RTN');
    Vr_spc = Vrtn_spc(:,1)'; Vr_spc(abs(Vr_spc)>2e3) = nan;
    Vt_spc = Vrtn_spc(:,2)'; Vt_spc(abs(Vt_spc)>2e3) = nan;
    Vn_spc = Vrtn_spc(:,3)'; Vn_spc(abs(Vn_spc)>2e3) = nan;
    Np_spc = spdfcdfread(spc_dir,'Variables','np_moment');
    Np_spc(abs(Np_spc)>5e3) = nan;
    Tp_spc = spdfcdfread(spc_dir,'Variables','wp_moment');
    Tp_spc(abs(Tp_spc)>1e3) = nan;
    sc_pos_HCI = spdfcdfread(spc_dir,'Variables','sc_pos_HCI');
    sc_vel_HCI = spdfcdfread(spc_dir,'Variables','sc_vel_HCI');
    sc_pos_HCIx = sc_pos_HCI(:,1); sc_vel_HCIx = sc_vel_HCI(:,1);
    sc_pos_HCIy = sc_pos_HCI(:,2); sc_vel_HCIy = sc_vel_HCI(:,2);
    sc_pos_HCIz = sc_pos_HCI(:,3); sc_vel_HCIz = sc_vel_HCI(:,3);
    [sc_vel_RTNr,sc_vel_RTNt,sc_vel_RTNn] = calc_HCI2SCRTN(sc_vel_HCIx,sc_vel_HCIy,sc_vel_HCIz,sc_pos_HCIx,sc_pos_HCIy,sc_pos_HCIz);
    sc_vel_RTN = [sc_vel_RTNr,sc_vel_RTNt,sc_vel_RTNn];
        %% get rid of general_flag ~= 0
        bad = find(general_flag ~= 0);
        badr = find(isnan(Vr_spc)); badt = find(isnan(Vt_spc)); badn = find(isnan(Vn_spc));
        badN = find(isnan(Np_spc)); badT = find(isnan(Tp_spc));
        
        spc_Epoch_good = spc_Epoch; spc_Epoch_good(cat(2,bad',badr)) = [];
        Vr_spc_good = Vr_spc; Vr_spc_good(cat(2,bad',badr)) = [];
        if isempty(Vr_spc_good) == 0
            Vr_spc = interp1(spc_Epoch_good,Vr_spc_good,spc_Epoch)';
        end
        
        spc_Epoch_good = spc_Epoch; spc_Epoch_good(cat(2,bad',badt)) = [];
        Vt_spc_good = Vt_spc; Vt_spc_good(cat(2,bad',badt)) = [];
        if isempty(Vt_spc_good) == 0
            Vt_spc = interp1(spc_Epoch_good,Vt_spc_good,spc_Epoch)';
        end
        
        spc_Epoch_good = spc_Epoch; spc_Epoch_good(cat(2,bad',badn)) = [];
        Vn_spc_good = Vn_spc; Vn_spc_good(cat(2,bad',badn)) = [];
        if isempty(Vn_spc_good) == 0
            Vn_spc = interp1(spc_Epoch_good,Vn_spc_good,spc_Epoch)';
        end
        
        spc_Epoch_good = spc_Epoch; spc_Epoch_good(cat(2,bad',badN')) = [];
        Np_spc_good = Np_spc; Np_spc_good(cat(2,bad',badN')) = [];
        if isempty(Np_spc_good) == 0
            Np_spc = interp1(spc_Epoch_good,Np_spc_good,spc_Epoch)';
        end
        
        spc_Epoch_good = spc_Epoch; spc_Epoch_good(cat(2,bad',badT')) = [];
        Tp_spc_good = Np_spc; Tp_spc_good(cat(2,bad',badT')) = [];
        if isempty(Tp_spc_good) == 0
            Tp_spc = interp1(spc_Epoch_good,Tp_spc_good,spc_Epoch)';
        end
    %% spi_data: Vsc_spi, Np_spi, Tp_spi
    spi_file = ['psp_swp_spi_sf00_l3_mom_inst_',num2str(year),date_list(i_date,:),'_v03.cdf'];
    spi_dir = [data_store,spi_file];
    spi_info = spdfcdfinfo(spi_dir);
    
    spi_Epoch = spdfcdfread(spi_dir,'Variables','Epoch');
    quality_flag = spdfcdfread(spi_dir,'Variables','QUALITY_FLAG');
    Vsc_spi = spdfcdfread(spi_dir,'Variables','VEL');
    Vsc_spi(abs(Vsc_spi)>1e3) = nan;
    SC2RTN = spdfcdfread(spi_dir,'Variables','ROTMAT_SC_INST');
    Vrtn2sc_spi = (SC2RTN) * Vsc_spi';
    Np_spi = spdfcdfread(spi_dir,'Variables','DENS');
    Np_spi(abs(Np_spi)>5e3) = nan;
    Tp_spi = spdfcdfread(spi_dir,'Variables','TEMP');
    Tp_spi(abs(Tp_spi)>1e3) = nan;
        %% switch Vrtn_spi to inertial RTN frame
    sc_vel_RTNr_interp = interp1(spc_Epoch,sc_vel_RTNr,spi_Epoch,'pchip');
    sc_vel_RTNt_interp = interp1(spc_Epoch,sc_vel_RTNt,spi_Epoch,'pchip');
    sc_vel_RTNn_interp = interp1(spc_Epoch,sc_vel_RTNn,spi_Epoch,'pchip');
    Vr2sc_spi = -Vrtn2sc_spi(3,:); Vr_spi = Vr2sc_spi + sc_vel_RTNr_interp';
    Vt2sc_spi =  Vrtn2sc_spi(1,:); Vt_spi = Vt2sc_spi + sc_vel_RTNt_interp';
    Vn2sc_Spi = -Vrtn2sc_spi(2,:); Vn_spi = Vn2sc_Spi + sc_vel_RTNn_interp';
    %% spe_data
    spe_file = ['psp_swp_spe_sf0_l3_pad_',num2str(year),date_list(i_date,:),'_v03.cdf'];
    spe_dir = [data_store,spe_file];
    spe_Epoch = spdfcdfread(spe_dir,'Variables','Epoch');
    PA_bins = spdfcdfread(spe_dir,'Variables','PITCHANGLE');
    PA_bins = PA_bins(1,:);
    EGY_bins = spdfcdfread(spe_dir,'Variables','ENERGY_VALS');
    EGY_bins = EGY_bins(1,:);
    PA_eflux_all = spdfcdfread(spe_dir,'Variables','EFLUX_VS_PA_E');
    PA_eflux = squeeze(PA_eflux_all(:,9,:)); % row 9: 314 eV
%     PA_eflux1 = squeeze(PA_eflux_all(:,1,:)); % row 1
%     PA_eflux3 = squeeze(PA_eflux_all(:,3,:)); % row 3
%     PA_eflux4 = squeeze(PA_eflux_all(:,4,:)); % row 4
%     PA_eflux6 = squeeze(PA_eflux_all(:,6,:)); % row 6
%     PA_eflux9 = squeeze(PA_eflux_all(:,9,:)); % row 9
%     PA_eflux11 = squeeze(PA_eflux_all(:,11,:)); % row 11
%     PA_eflux14 = squeeze(PA_eflux_all(:,14,:)); % row 14
%     PA_eflux15 = squeeze(PA_eflux_all(:,15,:)); % row 15
%     PA_eflux24 = squeeze(PA_eflux_all(:,24,:)); % row 24
%     PA_eflux29 = squeeze(PA_eflux_all(:,29,:)); % row 30: 
    %% plot figures
    figure();
    LineWidth = 1;
    FontSize = 6;
    fig_num = 6;
    
    subplot(fig_num,1,1)
    plot(fld_Epoch,Br,'r','LineWidth',LineWidth); hold on
    plot(fld_Epoch,Bt,'g','LineWidth',LineWidth); hold on
    plot(fld_Epoch,Bn,'b','LineWidth',LineWidth); hold on
    plot(fld_Epoch,B_mod,'k','LineWidth',LineWidth); grid on
    ylabel('Brtn [nT]')
    legend('Br','Bt','Bn','|B|','Location','eastoutside')
    xlim([min(fld_Epoch) max(fld_Epoch)]);
    datetick('x','HH:MM');
    set(gca,'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
    
    subplot(fig_num,1,2)
    plot(spi_Epoch,Vr_spi-nanmean(Vr_spi),'r','LineWidth',LineWidth); hold on
    plot(spi_Epoch,Vt_spi-nanmean(Vt_spi),'g','LineWidth',LineWidth); hold on
    plot(spi_Epoch,Vn_spi-nanmean(Vn_spi),'b','LineWidth',LineWidth); grid on
    ylabel('Vspi [km/s]')
    legend('Vr','Vt','Vn','Location','eastoutside')
    xlim([min(fld_Epoch) max(fld_Epoch)]);
    datetick('x','HH:MM');
    set(gca,'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
    
    subplot(fig_num,1,3)
    plot(spc_Epoch,Vr_spc-nanmean(Vr_spc),'r','LineWidth',LineWidth); hold on
    plot(spc_Epoch,Vt_spc-nanmean(Vt_spc),'g','LineWidth',LineWidth); hold on
    plot(spc_Epoch,Vn_spc-nanmean(Vn_spc),'b','LineWidth',LineWidth); hold on
%     scatter(spc_Epoch,double(general_flag)*20,'k','LineWidth',LineWidth);
    grid on
    ylabel('Vspc [km/s]')
    legend('Vr','Vt','Vn','Location','eastoutside')
    xlim([min(fld_Epoch) max(fld_Epoch)]);
    datetick('x','HH:MM');
    set(gca,'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
    
    subplot(fig_num,1,4)
    plot(spi_Epoch,Np_spi,'r','LineWidth',LineWidth); hold on
    plot(spc_Epoch,Np_spc,'b','LineWidth',LineWidth); grid on
    ylabel('Np [cm^{-3}]')
    legend('spi','spc','Location','eastoutside')
    xlim([min(fld_Epoch) max(fld_Epoch)]);
    datetick('x','HH:MM');
    set(gca,'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
    
    subplot(fig_num,1,5)
    plot(spi_Epoch,Tp_spi,'r','LineWidth',LineWidth); hold on
    plot(spc_Epoch,Tp_spc,'b','LineWidth',LineWidth); grid on
    ylabel('Tp [eV]')
    legend('spi','spc','Location','eastoutside')
    xlim([min(fld_Epoch) max(fld_Epoch)]);
    datetick('x','HH:MM');
    set(gca,'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
    
    subplot(fig_num,1,6)
    spe_x = spe_Epoch; spe_y = PA_bins;
    [spe_X,spe_Y] = meshgrid(spe_x,spe_y);
    h = pcolor(spe_X,spe_Y,log10(PA_eflux));
    set(h,'Linestyle','none');
    ylabel('PA [deg.]')
    legend('314','Location','eastoutside')
    xlim([min(spe_Epoch) max(spe_Epoch)]);
    datetick('x','HH:MM');
    colormap jet; colorbar('off');
    set(gca,'tickdir','out','LineWidth',LineWidth,'FontSize',FontSize);
    
    sgtitle(['PSP enounter ',num2str(encounter),' ',num2str(year),num2str(date_list(i_date,:))]);
    %% plot Pitch Angle of different energy bins
%     spe_x = spe_Epoch; spe_y = PA_bins;
%     [spe_X,spe_Y] = meshgrid(spe_x,spe_y);
%     
%     subplot(fig_num,1,1)
%     h = pcolor(spe_X,spe_Y,log(PA_eflux1));
%     set(h,'Linestyle','none');
%     ylabel(num2str(fix(EGY_bins(1))))
%     xlim([min(spe_Epoch) max(spe_Epoch)]);
%     datetick('x','HH:MM');
%     colormap jet; colorbar('off');
%     set(gca,'xticklabel',[],'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
%     
%     subplot(fig_num,1,2)
%     h = pcolor(spe_X,spe_Y,log(PA_eflux3));
%     set(h,'Linestyle','none');
%     ylabel(num2str(fix(EGY_bins(3))))
%     xlim([min(spe_Epoch) max(spe_Epoch)]);
%     datetick('x','HH:MM');
%     colormap jet; colorbar('off');
%     set(gca,'xticklabel',[],'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
%     
%     subplot(fig_num,1,3)
%     h = pcolor(spe_X,spe_Y,log(PA_eflux4));
%     set(h,'Linestyle','none');
%     ylabel(num2str(fix(EGY_bins(4))))
%     xlim([min(spe_Epoch) max(spe_Epoch)]);
%     datetick('x','HH:MM');
%     colormap jet; colorbar('off');
%     set(gca,'xticklabel',[],'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
%     
%     subplot(fig_num,1,4)
%     h = pcolor(spe_X,spe_Y,log(PA_eflux6));
%     set(h,'Linestyle','none');
%     ylabel(num2str(fix(EGY_bins(6))))
%     xlim([min(spe_Epoch) max(spe_Epoch)]);
%     datetick('x','HH:MM');
%     colormap jet; colorbar('off');
%     set(gca,'xticklabel',[],'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
%     
%     subplot(fig_num,1,5)
%     h = pcolor(spe_X,spe_Y,log(PA_eflux9));
%     set(h,'Linestyle','none');
%     ylabel(num2str(fix(EGY_bins(9))))
%     xlim([min(spe_Epoch) max(spe_Epoch)]);
%     datetick('x','HH:MM');
%     colormap jet; colorbar('off');
%     set(gca,'xticklabel',[],'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
%     
%     subplot(fig_num,1,6)
%     h = pcolor(spe_X,spe_Y,log(PA_eflux11));
%     set(h,'Linestyle','none');
%     ylabel(num2str(fix(EGY_bins(11))))
%     xlim([min(spe_Epoch) max(spe_Epoch)]);
%     datetick('x','HH:MM');
%     colormap jet; colorbar('off');
%     set(gca,'xticklabel',[],'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
%     
%     subplot(fig_num,1,7)
%     h = pcolor(spe_X,spe_Y,log(PA_eflux14));
%     set(h,'Linestyle','none');
%     ylabel(num2str(fix(EGY_bins(14))))
%     xlim([min(spe_Epoch) max(spe_Epoch)]);
%     datetick('x','HH:MM');
%     colormap jet; colorbar('off');
%     set(gca,'xticklabel',[],'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
%     
%     subplot(fig_num,1,8)
%     h = pcolor(spe_X,spe_Y,log(PA_eflux15));
%     set(h,'Linestyle','none');
%     ylabel(num2str(fix(EGY_bins(15))))
%     xlim([min(spe_Epoch) max(spe_Epoch)]);
%     datetick('x','HH:MM');
%     colormap jet; colorbar('off');
%     set(gca,'xticklabel',[],'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
%     
%     subplot(fig_num,1,9)
%     h = pcolor(spe_X,spe_Y,log(PA_eflux24));
%     set(h,'Linestyle','none');
%     ylabel(num2str(fix(EGY_bins(24))))
%     xlim([min(spe_Epoch) max(spe_Epoch)]);
%     datetick('x','HH:MM');
%     colormap jet; colorbar('off');
%     set(gca,'xticklabel',[],'tickdir','in','LineWidth',LineWidth,'FontSize',FontSize);
%     
%     subplot(fig_num,1,10)
%     h = pcolor(spe_X,spe_Y,log(PA_eflux29));
%     set(h,'Linestyle','none');
%     xlabel(['Time [HH:MM]']); ylabel(num2str(fix(EGY_bins(29))))
%     xlim([min(spe_Epoch) max(spe_Epoch)]);
%     datetick('x','HH:MM');
%     colormap jet; colorbar('off');
%     set(gca,'tickdir','out','LineWidth',LineWidth,'FontSize',FontSize);
%     
%     sgtitle(['PSP enounter ',num2str(encounter),' ',num2str(year),num2str(date_list(i_date,:))]);
    %% save figures
    if save_or_not == 1
        saveas(gcf,['C:\Users\22242\Documents\STUDY\Work\current_sheet_flapping\Encounter ',num2str(encounter),'\days\',num2str(year),num2str(date_list(i_date,:)),'_norm.png']);
    end
    %     saveas(gcf,['C:\Users\22242\Documents\STUDY\Work\current_sheet_flapping\Encounter ',num2str(encounter),'\',num2str(year),num2str(date_list(i_date,:)),'_different_energy_pitch_angle.png']);
end
%% fuctions
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