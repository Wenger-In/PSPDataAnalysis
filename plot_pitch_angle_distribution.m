clear all; close all;
encounter = 7;
data_store = ['C:\Users\22242\Documents\STUDY\Data\PSP\Encounter ',num2str(encounter),'\'];
if encounter == 5
    year = 2020;
    encounter_mouth = '2020/05 - 2020/06';
    date_list = ['0520';'0521';'0522';'0523';'0524';'0525';'0526';'0527';'0528';'0529';'0530';'0531';'0601';'0602';'0603';'0604';'0605';'0606';'0607';'0608';'0609';'0610';'0611';'0612';'0613';'0614';'0615'];
end
if encounter == 6
    year = 2020;
    encounter_mouth = '2020/09 - 2020/10';
    date_list = ['0918';'0919';'0920';'0921';'0922';'0923';'0924';'0925';'0926';'0927';'0928';'0929';'0930';'1001';'1002'];
end
if encounter == 7
    year = 2021;
    encounter_mouth = '2021/01';
    date_list = ['0109';'0110';'0111';'0112';'0113';'0114';'0115';'0116';'0117';'0118';'0119';'0120';'0121';'0122';'0123'];    
end
%% first day
data_file = ['psp_swp_spe_sf0_l3_pad_',num2str(year),date_list(1,:),'_v03.cdf'];
data_dir = [data_store,data_file];
info = spdfcdfinfo(data_dir);
Epoch = spdfcdfread(data_dir,'Variables','Epoch');
PA_bins = spdfcdfread(data_dir,'Variables','PITCHANGLE'); PA_bins = PA_bins(1,:);
EGY_bins = spdfcdfread(data_dir,'Variables','ENERGY_VALS'); EGY_bins = EGY_bins(1,:);
PA_eflux_all = spdfcdfread(data_dir,'Variables','EFLUX_VS_PA_E');
PA_eflux = squeeze(PA_eflux_all(:,9,:)); % row 9: 314 eV
%% following days
for i_date = 2 : length(date_list)   
    data_file_sub = ['psp_swp_spe_sf0_l3_pad_',num2str(year),date_list(i_date,:),'_v03.cdf'];
    data_dir_sub = [data_store,data_file_sub];
    Epoch_sub = spdfcdfread(data_dir_sub,'Variables','Epoch');
    PA_eflux_all_sub = spdfcdfread(data_dir_sub,'Variables','EFLUX_VS_PA_E');
    PA_eflux_sub = squeeze(PA_eflux_all_sub(:,9,:)); % row 9: 314 eV
    
    Epoch = cat(1,Epoch,Epoch_sub);
    PA_eflux = cat(2,PA_eflux,PA_eflux_sub);    
end
%% plot figure
LineWidth = 2;
FontSize = 15;
x = Epoch; y = PA_bins;
[X,Y] = meshgrid(x,y);
h = pcolor(X,Y,log(PA_eflux));
set(h,'Linestyle','none');
xlabel(['Time [dd]']); ylabel('PA [deg.]')
xlim([min(Epoch) max(Epoch)]);
datetick('x','dd');
colormap jet; colorbar;
title(['PSP enounter ',num2str(encounter),' (',encounter_mouth,')']);
set(gca,'tickdir','out','LineWidth',LineWidth,'FontSize',FontSize);