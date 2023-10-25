clear all; close all;
encounter = 8;
cross_num = 4;
data_save  = ['D:\STUDY\Work\current_sheet_flapping\Encounter ',num2str(encounter),'\flapping_events\'];

e_LMN_arr = importdata([data_save,'e_LMN.csv']);
e_L_arr = e_LMN_arr(:,1:cross_num);
e_M_arr = e_LMN_arr(:,cross_num+1:2*cross_num);
e_N_arr = e_LMN_arr(:,2*cross_num+1:3*cross_num);
%% correct 180° direction
e_L_arr(:,3) = -e_L_arr(:,3);
e_M_arr(:,3) = -e_M_arr(:,3);
e_N_arr(:,3) = -e_N_arr(:,3);
%% orbit: 
if encounter == 7 % roughly along T direction
    rr = zeros(1,cross_num);
    tt = 2 * [1:1:cross_num];
    nn = zeros(1,cross_num);
    rr_min = -1; rr_max = 1;
    tt_min =  0; tt_max = 2 * (cross_num + 1);
    nn_min = -1; nn_max = 1;
end
if encounter == 8 % roughly along T direction
    rr = zeros(1,cross_num);
    tt = 2 * [1:1:cross_num];
    nn = zeros(1,cross_num);
    rr_min = -1; rr_max = 1;
    tt_min =  0; tt_max = 2 * (cross_num + 1);
    nn_min = -1; nn_max = 1;
end
%% calculate included angles between e_N vectors
IA = zeros(cross_num,cross_num);
for c_index = 1:cross_num - 1 % column circulation
    for r_index = c_index + 1:cross_num % row circulation
        IA(c_index,r_index) = acosd(abs(dot(e_N_arr(:,c_index),e_N_arr(:,r_index))));
    end
end
%% plot vectors
LineWidth = 2;

subplot(2,2,1)
quiver3(rr(1),tt(1),nn(1),rr(cross_num)-rr(1),tt(cross_num)-tt(1),nn(cross_num)-nn(1),'off',':k','LineWidth',LineWidth); hold on;
% quiver3(rr,tt,nn,e_L_arr(1,:),e_L_arr(2,:),e_L_arr(3,:),'off','r','LineWidth',LineWidth); hold on
% quiver3(rr,tt,nn,e_M_arr(1,:),e_M_arr(2,:),e_M_arr(3,:),'off','g','LineWidth',LineWidth); hold on
quiver3(rr,tt,nn,e_N_arr(1,:),e_N_arr(2,:),e_N_arr(3,:),'off','b','LineWidth',LineWidth); grid on
xlabel('R'); ylabel('T'); zlabel('N');
axis equal
xlim([rr_min rr_max]); ylim([tt_min tt_max]); zlim([nn_min nn_max]);
% legend('e_L','e_M','e_N')
subtitle('3-D vector')

subplot(2,2,2)
quiver(tt(1),rr(1),tt(cross_num)-tt(1),rr(cross_num)-rr(1),'off',':k','LineWidth',LineWidth); hold on;
% quiver(rr,tt,e_L_arr(1,:),e_L_arr(2,:),'off','r','LineWidth',LineWidth); hold on
% quiver(rr,tt,e_M_arr(1,:),e_M_arr(2,:),'off','g','LineWidth',LineWidth); hold on
quiver(tt,rr,e_N_arr(2,:),e_N_arr(1,:),'off','b','LineWidth',LineWidth); grid on
xlabel('T'); ylabel('R');
axis equal
xlim([tt_min tt_max]); ylim([rr_min rr_max]);
% legend('e_L','e_M','e_N')
subtitle('T-R projection')

subplot(2,2,3)
quiver(tt(1),nn(1),tt(cross_num)-tt(1),nn(cross_num)-nn(1),'off',':k','LineWidth',LineWidth); hold on;
% quiver(tt,nn,e_L_arr(2,:),e_L_arr(3,:),'off','r','LineWidth',LineWidth); hold on
% quiver(tt,nn,e_M_arr(2,:),e_M_arr(3,:),'off','g','LineWidth',LineWidth); hold on
quiver(tt,nn,e_N_arr(2,:),e_N_arr(3,:),'off','b','LineWidth',LineWidth); grid on
xlabel('T'); ylabel('N');
axis equal
xlim([tt_min tt_max]); ylim([nn_min nn_max]);
% legend('e_L','e_M','e_N')
subtitle('T-N projection')

subplot(2,2,4)
quiver(rr(1),nn(1),rr(cross_num)-rr(1),nn(cross_num)-nn(1),'off',':k','LineWidth',LineWidth); hold on;
% quiver(rr,nn,e_L_arr(1,:),e_L_arr(3,:),'off','r','LineWidth',LineWidth); hold on
% quiver(rr,nn,e_M_arr(1,:),e_M_arr(3,:),'off','g','LineWidth',LineWidth); hold on
quiver(rr,nn,e_N_arr(1,:),e_N_arr(3,:),'off','b','LineWidth',LineWidth); grid on
xlabel('R'); ylabel('N');
axis equal
xlim([rr_min rr_max]); ylim([nn_min nn_max]);
% legend('e_L','e_M','e_N')
subtitle('R-N projection')

sgtitle('e_N in RTN coordinate');