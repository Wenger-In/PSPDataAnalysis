;Pro Read_PSP_SPI_moms_L3_CDF_batching
suite_str = 'swp'
payload_str = 'spi'
descriptor_str = 'sf00';sf00
level_str = 'l3';l2;l3
If descriptor_str eq 'sf00' Then Begin
  des_plot_str = 'p'
Endif
If descriptor_str eq 'sf0a' Then Begin
  des_plot_str = '\alpha'
Endif
;;--
year_str = '2020'
;;--
PSP_spi_Data_Dir = 'E:\Research\Data\PSP\Encounter 5\'
;;--
is_timerange_automatic = 1
is_timerange_automatic_for_plot = 1


Step1:
;===========================
;Step1:
;;--
dir_read  = PSP_spi_Data_Dir
file_read = 'psp_'+suite_str+'_'+payload_str+'_'+descriptor_str+'_'+level_str+'_'+ $
  'mom_inst_'+year_str+'*_v03'+'.cdf'
file_array  = File_Search(dir_read+file_read, count=num_files)
For i_file=0,num_files-1 Do Begin
  Print, 'i_file, file: ', i_file, ': ', file_array[i_file]
Endfor
;;--
For i_file=0,num_files-1 Do Begin
  Print, 'i_file, file: ', i_file, ': ', file_array[i_file]
  file_read = file_array[i_file]
  file_read = StrMid(file_read, StrLen(dir_read),StrLen(file_read)-StrLen(dir_read))
  mon_str = StrMid(file_read, 33, 2)
  day_str = Strmid(file_read, 35, 2)
  ;;--
  CD, Current=wk_dir
  CD, dir_read
  cdf_id  = CDF_Open(file_read)
  ;;--
  CDF_Control, cdf_id, Variable='Epoch', Get_Var_Info=Info_Epoch
  ;a num_records  = Info_Epoch.MaxAllocRec
  num_records   = Info_Epoch.MaxRec + 1L
  CDF_VarGet, cdf_id, 'Epoch', Epoch_vect, Rec_Count=num_records
  var_name_Ni = 'DENS'
  CDF_VarGet, cdf_id, var_name_Ni, Ni_vect, Rec_Count=num_records
  var_name_Vi = 'VEL'
  CDF_VarGet, cdf_id, var_name_Vi, Vi_Inst_arr, Rec_Count=num_records
  var_name_T_tensor = 'T_TENSOR'
  CDF_VarGet, cdf_id, var_name_T_tensor, Ti_Inst_arr, Rec_Count=num_records
  var_name_Trace = 'TEMP'
  CDF_VarGet, cdf_id, var_name_Trace, Titrace_vect, Rec_Count=num_records
  var_name_Rmatrix = 'ROTMAT_SC_INST'
  CDF_VarGet, cdf_id, var_name_Rmatrix, Rot_matrix, Rec_Count=num_records
  Rot_matrix = Reform(Rot_matrix[*,*,0])
  ;;--
  CDF_Close, cdf_id
  CD, wk_dir
  ;;--
  Epoch_vect = Reform(Epoch_vect)
  epoch_beg   = Epoch_vect[0]
  CDF_Epoch, epoch_beg, year_beg, mon_beg, day_beg, hour_beg, min_beg, sec_beg, milli_beg, $
    /Breakdown_Epoch
  CalJulDay_method = 2
  If CalJulDay_method eq 1 Then Begin ;have some problem!!
    JulDay_beg    = JulDay(mon_beg,day_beg,year_beg,hour_beg,min_beg, sec_beg+milli_beg*1.e-3)
    JulDay_vect  = JulDay_beg+(Epoch_vect-Epoch_beg)/(1.e3*24.*60.*60.)
  EndIf Else Begin
    If CalJulDay_method eq 2 Then Begin
      CDF_Epoch, epoch_vect, year_vect, mon_vect, day_vect, hour_vect, min_vect, sec_vect, milli_vect, $
        /Breakdown_Epoch
      JulDay_vect = JulDay(mon_vect, day_vect, year_vect, hour_vect, min_vect, sec_vect+milli_vect/1.e3)
    EndIf
  EndElse


Step2_1:
;===========================
;Step2_1:
;;--
BadVal  = -1.e31
;;;---
sub_nan = Where(Ni_vect eq BadVal)
If (sub_nan[0] ne -1) Then Begin
  sub_val = Where(Ni_vect ne BadVal)
  JulDay_vect_v2 = JulDay_vect[sub_val]
  Ni_vect_v2 = Ni_vect[sub_val]
  Ni_vect  = Interpol(Ni_vect_v2, JulDay_vect_v2, JulDay_vect)
  ;  Ni_vect[sub_nan] = !values.f_nan
EndIf
sub_nan_Ni  = sub_nan
;;;---
Vix_Inst_vect  = Reform(Vi_Inst_arr[0,*])
sub_nan = Where(Vix_Inst_vect eq BadVal)
If (sub_nan[0] ne -1) Then Begin
  sub_val = Where(Vix_Inst_vect ne BadVal)
  JulDay_vect_v2 = JulDay_vect[sub_val]
  Vix_vect_v2 = Vix_Inst_vect[sub_val]
  Vix_Inst_vect  = Interpol(Vix_vect_v2, JulDay_vect_v2, JulDay_vect)
  ;  Vix_vect[sub_nan] = !values.f_nan
EndIf
sub_nan_Vix  = sub_nan
;;;---
Viy_Inst_vect  = Reform(Vi_Inst_arr[1,*])
sub_nan = Where(Viy_Inst_vect eq BadVal)
If (sub_nan[0] ne -1) Then Begin
  sub_val = Where(Viy_vect ne BadVal)
  JulDay_vect_v2 = JulDay_vect[sub_val]
  Viy_vect_v2 = Viy_Inst_vect[sub_val]
  Viy_Inst_vect  = Interpol(Viy_vect_v2, JulDay_vect_v2, JulDay_vect)
  ;  Viy_vect[sub_nan] = !values.f_nan
EndIf
sub_nan_Viy  = sub_nan
;;;---
Viz_Inst_vect  = Reform(Vi_Inst_arr[2,*])
sub_nan = Where(Viz_Inst_vect eq BadVal)
If (sub_nan[0] ne -1) Then Begin
  sub_val = Where(Viz_Inst_vect ne BadVal)
  JulDay_vect_v2 = JulDay_vect[sub_val]
  Viz_vect_v2 = Viz_Inst_vect[sub_val]
  Viz_Inst_vect  = Interpol(Viz_vect_v2, JulDay_vect_v2, JulDay_vect)
  ;  Viz_vect[sub_nan] = !values.f_nan
EndIf
sub_nan_Viz  = sub_nan
;;;---
Tixx_Inst_vect  = Reform(Ti_Inst_arr[0,*])
sub_nan = Where(Tixx_Inst_vect eq BadVal)
If (sub_nan[0] ne -1) Then Begin
  sub_val = Where(Tixx_Inst_vect ne BadVal)
  JulDay_vect_v2 = JulDay_vect[sub_val]
  Tixx_vect_v2 = Tixx_Inst_vect[sub_val]
  Tixx_Inst_vect  = Interpol(Tixx_vect_v2, JulDay_vect_v2, JulDay_vect)
  ;  Tixx_vect[sub_nan] = !values.f_nan
EndIf
sub_nan_Tixx  = sub_nan
;;;---
Tiyy_Inst_vect  = Reform(Ti_Inst_arr[1,*])
sub_nan = Where(Tiyy_Inst_vect eq BadVal)
If (sub_nan[0] ne -1) Then Begin
  sub_val = Where(Tiyy_Inst_vect ne BadVal)
  JulDay_vect_v2 = JulDay_vect[sub_val]
  Tiyy_vect_v2 = Tiyy_Inst_vect[sub_val]
  Tiyy_Inst_vect  = Interpol(Tiyy_vect_v2, JulDay_vect_v2, JulDay_vect)
  ;  Tiyy_vect[sub_nan] = !values.f_nan
EndIf
sub_nan_Tiyy  = sub_nan
;;;---
Tizz_Inst_vect  = Reform(Ti_Inst_arr[2,*])
sub_nan = Where(Tizz_Inst_vect eq BadVal)
If (sub_nan[0] ne -1) Then Begin
  sub_val = Where(Tizz_Inst_vect ne BadVal)
  JulDay_vect_v2 = JulDay_vect[sub_val]
  Tizz_vect_v2 = Tizz_Inst_vect[sub_val]
  Tizz_Inst_vect  = Interpol(Tizz_vect_v2, JulDay_vect_v2, JulDay_vect)
  ;  Tizz_vect[sub_nan] = !values.f_nan
EndIf
sub_nan_Tizz  = sub_nan
;;;---
Tixy_Inst_vect  = Reform(Ti_Inst_arr[3,*])
sub_nan = Where(Tixy_Inst_vect eq BadVal)
If (sub_nan[0] ne -1) Then Begin
  sub_val = Where(Tixy_Inst_vect ne BadVal)
  JulDay_vect_v2 = JulDay_vect[sub_val]
  Tixy_vect_v2 = Tixy_Inst_vect[sub_val]
  Tixy_Inst_vect  = Interpol(Tixy_vect_v2, JulDay_vect_v2, JulDay_vect)
  ;  Tixy_vect[sub_nan] = !values.f_nan
EndIf
sub_nan_Tixy  = sub_nan
;;;---
Tixz_Inst_vect  = Reform(Ti_Inst_arr[4,*])
sub_nan = Where(Tixz_Inst_vect eq BadVal)
If (sub_nan[0] ne -1) Then Begin
  sub_val = Where(Tixz_Inst_vect ne BadVal)
  JulDay_vect_v2 = JulDay_vect[sub_val]
  Tixz_vect_v2 = Tixz_Inst_vect[sub_val]
  Tixz_Inst_vect  = Interpol(Tixz_vect_v2, JulDay_vect_v2, JulDay_vect)
  ;  Tixz_vect[sub_nan] = !values.f_nan
EndIf
sub_nan_Tixz  = sub_nan
;;;---
Tiyz_Inst_vect  = Reform(Ti_Inst_arr[5,*])
sub_nan = Where(Tiyz_Inst_vect eq BadVal)
If (sub_nan[0] ne -1) Then Begin
  sub_val = Where(Tiyz_Inst_vect ne BadVal)
  JulDay_vect_v2 = JulDay_vect[sub_val]
  Tiyz_vect_v2 = Tiyz_Inst_vect[sub_val]
  Tiyz_Inst_vect  = Interpol(Tiyz_vect_v2, JulDay_vect_v2, JulDay_vect)
  ;  Tiyz_vect[sub_nan] = !values.f_nan
EndIf
sub_nan_Tiyz  = sub_nan
;;;---
sub_nan = Where(Titrace_vect eq BadVal)
If (sub_nan[0] ne -1) Then Begin
  sub_val = Where(Titrace_vect ne BadVal)
  JulDay_vect_v2 = JulDay_vect[sub_val]
  Titrace_vect_v2 = Titrace_vect[sub_val]
  Titrace_vect  = Interpol(Titrace_vect_v2, JulDay_vect_v2, JulDay_vect)
  ;  Titrace_vect[sub_nan] = !values.f_nan
EndIf
sub_nan_Titrace  = sub_nan

;;;---
num_times = N_Elements(JulDay_vect)
flag_GoodVal_vect = Fltarr(num_times)+1.0
If (sub_nan_Ni[0]  ne -1) Then flag_GoodVal_vect[sub_nan_Ni]=0.0
If (sub_nan_Vix[0] ne -1) Then flag_GoodVal_vect[sub_nan_Vix]=0.0
If (sub_nan_Viy[0] ne -1) Then flag_GoodVal_vect[sub_nan_Viy]=0.0
If (sub_nan_Viz[0] ne -1) Then flag_GoodVal_vect[sub_nan_Viz]=0.0
If (sub_nan_Tixx[0] ne -1) Then flag_GoodVal_vect[sub_nan_Tixx]=0.0
If (sub_nan_Tiyy[0] ne -1) Then flag_GoodVal_vect[sub_nan_Tiyy]=0.0
If (sub_nan_Tizz[0] ne -1) Then flag_GoodVal_vect[sub_nan_Tizz]=0.0
If (sub_nan_Tixy[0] ne -1) Then flag_GoodVal_vect[sub_nan_Tixy]=0.0
If (sub_nan_Tixz[0] ne -1) Then flag_GoodVal_vect[sub_nan_Tixz]=0.0
If (sub_nan_Tiyz[0] ne -1) Then flag_GoodVal_vect[sub_nan_Tiyz]=0.0
If (sub_nan_Titrace[0] ne -1) Then flag_GoodVal_vect[sub_nan_Titrace]=0.0
flag_GoodVal_vect = [1.0, flag_GoodVal_vect]
diff_flag_vect = flag_GoodVal_vect[1:num_times] - flag_GoodVal_vect[0:num_times-1]
;;;;----
sub_diff_eq_m1  = Where(diff_flag_vect eq -1)
sub_diff_eq_p1  = Where(diff_flag_vect eq +1)
If (sub_diff_eq_m1[0] ne -1 and sub_diff_eq_p1[0] ne -1) Then Begin
  num_BadBins = N_Elements(sub_diff_eq_m1)
  sub_beg_BadBins_vect  = Lonarr(num_BadBins)
  sub_end_BadBins_vect  = Lonarr(num_BadBins)
  sub_beg_BadBins_vect  = sub_diff_eq_m1
  sub_end_BadBins_vect  = sub_diff_eq_p1
  JulDay_beg_BadBins_vect = JulDay_vect(sub_beg_BadBins_vect)
  JulDay_end_BadBins_vect = JulDay_vect(sub_end_BadBins_vect)
EndIf Else Begin
  sub_beg_BadBins_vect  = -1
  sub_end_BadBins_vect  = -1
  JulDay_beg_BadBins_vect = -1.0
  JulDay_end_BadBins_vect = -1.0
EndElse

Step2_2:
;===========================
;Step2_2:
;;--convert to Spacecraft frame and further RTN frame
Vxyz_Inst_arr = [[Vix_Inst_vect],[Viy_Inst_vect],[Viz_Inst_vect]]
Vxyz_SC_arr = Transpose(Rot_matrix[*,*,0])##Vxyz_Inst_arr
Vx_SC_vect = Reform(Vxyz_SC_arr[*,0])
Vy_SC_vect = Reform(Vxyz_SC_arr[*,1])
Vz_SC_vect = Reform(Vxyz_SC_arr[*,2])
Vx_RTN_vect = -Vz_SC_vect
Vy_RTN_vect = +Vx_SC_vect
Vz_RTN_vect = -Vy_SC_vect


Step3:
;===========================
;Step3:
Print, 'is_timerange_automatic (0 for defined by user, 1 for automatically inherited from original data): '
Print, is_timerange_automatic
If is_timerange_automatic eq 0 Then Begin
  hh_beg_save_str = StrMid(hms_beg_save_str,0,2) & hour_beg=Float(hh_beg_save_str)
  mm_beg_save_str = StrMid(hms_beg_save_str,3,2) & min_beg=Float(mm_beg_save_str)
  ss_beg_save_str = StrMid(hms_beg_save_str,6,2) & sec_beg=Float(ss_beg_save_str)
  hh_end_save_str = StrMid(hms_end_save_str,0,2) & hour_end=Float(hh_end_save_str)
  mm_end_save_str = StrMid(hms_end_save_str,3,2) & min_end=Float(mm_end_save_str)
  ss_end_save_str = StrMid(hms_end_save_str,6,2) & sec_end=Float(ss_end_save_str)
  year_beg_save=Float(year_str) & mon_beg_save=Float(mon_str) & day_beg_save=Float(day_str)
  year_end_save=Float(year_str) & mon_end_save=Float(mon_str) & day_end_save=Float(day_str)
  hour_beg_save=Float(hh_beg_save_str) & min_beg_save=Float(mm_beg_save_str) & sec_beg_save=Float(ss_beg_save_str)
  hour_end_save=Float(hh_end_save_str) & min_end_save=Float(mm_end_save_str) & sec_end_save=Float(ss_end_save_str)
  JulDay_beg_save = JulDay(mon_beg_save,day_beg_save,year_beg_save, hour_beg_save,min_beg_save,sec_beg_save)
  JulDay_end_save = JulDay(mon_end_save,day_end_save,year_end_save, hour_end_save,min_end_save,sec_end_save)
EndIf Else Begin
  If is_timerange_automatic eq 1 Then Begin
    JulDay_beg_save = Min(JulDay_vect)
    JulDay_end_save = Max(JulDay_vect)
    CalDat, JulDay_beg_save, mon_beg_save, day_beg_save, year_beg_save, hour_beg_save, min_beg_save, sec_beg_save
    CalDat, JulDay_end_save, mon_end_save, day_end_save, year_end_save, hour_end_save, min_end_save, sec_end_save
  EndIf
EndElse
;;;---
TimeRange_save_str  = '(time='+$
  String(hour_beg_save,format='(I2.2)')+String(min_beg_save,format='(I2.2)')+String(sec_beg_save,format='(I2.2)')+'-'+$
  String(hour_end_save,format='(I2.2)')+String(min_end_save,format='(I2.2)')+String(sec_end_save,format='(I2.2)')+')'

;;--
sub_beg_save = Where(JulDay_vect ge JulDay_beg_save)
sub_end_save = Where(JulDay_vect le JulDay_end_save)
sub_beg_save = sub_beg_save[0]
sub_end_save = sub_end_save(N_Elements(sub_end_save)-1)
;;--
JulDay_vect_save  = JulDay_vect[sub_beg_save:sub_end_save]
Ni_vect_save  = Ni_vect[sub_beg_save:sub_end_save]
Vix_RTN_vect_save  = Vx_RTN_vect[sub_beg_save:sub_end_save]
Viy_RTN_vect_save  = Vy_RTN_vect[sub_beg_save:sub_end_save]
Viz_RTN_vect_save  = Vz_RTN_vect[sub_beg_save:sub_end_save]
Vix_SC_vect_save  = Vx_SC_vect[sub_beg_save:sub_end_save]
Viy_SC_vect_save  = Vy_SC_vect[sub_beg_save:sub_end_save]
Viz_SC_vect_save  = Vz_SC_vect[sub_beg_save:sub_end_save]
Tixx_vect_save = Tixx_Inst_vect[sub_beg_save:sub_end_save]
Tiyy_vect_save = Tiyy_Inst_vect[sub_beg_save:sub_end_save]
Tizz_vect_save = Tizz_Inst_vect[sub_beg_save:sub_end_save]
Tixy_vect_save = Tixy_Inst_vect[sub_beg_save:sub_end_save]
Tixz_vect_save = Tixz_Inst_vect[sub_beg_save:sub_end_save]
Tiyz_vect_save = Tiyz_Inst_vect[sub_beg_save:sub_end_save]
Titrace_vect_save = Titrace_vect[sub_beg_save:sub_end_save]

;;--
dJulDay_vect  = JulDay_vect_save[1:num_times-1] - JulDay_vect_save[0:num_times-2]
dTime_vect    = dJulDay_vect * (24.*60.*60)
dTime_median  = Median(dTime_vect)
sub_DataGaps  = Where(dTime_vect ge 4*dTime_median)
If (sub_DataGaps[0] ne -1) Then Begin
  num_DataGaps  = N_Elements(sub_DataGaps)
  JulDay_beg_DataGap_vect = Dblarr(num_DataGaps)
  JulDay_end_DataGap_vect = Dblarr(num_DataGaps)
  For i_DataGap=0,num_DataGaps-1 Do Begin
    JulDay_beg_DataGap_vect[i_DataGap] = JulDay_vect_save[sub_DataGaps[i_DataGap]]
    JulDay_end_DataGap_vect[i_DataGap] = JulDay_vect_save[sub_DataGaps[i_DataGap]+1]
  EndFor
EndIf Else Begin
  num_DataGaps  = 0L
  JulDay_beg_DataGap_vect = -1.0
  JulDay_end_DataGap_vect = -1.0
EndElse
;;--
PSP_Data_Dir = 'E:\Research\Work\waves_in_exhaust_region\SavData\'
File_MkDir, PSP_Data_Dir
;;--
dir_save  = PSP_Data_Dir
file_save = 'Ni_Vi_Ti_tensor_InstFrame'+$
  '(psp_'+suite_str+'_'+payload_str+'_'+descriptor_str+'_'+level_str+')'+$
  '('+year_str+mon_str+day_str+')'+$
  TimeRange_save_str+$
  '.sav'
TimeRange_str = TimeRange_save_str
data_descrip  = 'got from "Read_PSP_SPI_moms_L3_CDF.pro"'
Save, FileName=dir_save+file_save, $
  data_descrip, $
  TimeRange_str, $
  JulDay_vect_save, Ni_vect_save, Vix_RTN_vect_save, Viy_RTN_vect_save, Viz_RTN_vect_save, $
  Vix_SC_vect_save, Viy_SC_vect_save, Viz_SC_vect_save, $
  Tixx_vect_save, Tiyy_vect_save, Tizz_vect_save, $
  Tixy_vect_save, Tixz_vect_save, Tiyz_vect_save, $
  Titrace_vect_save, $
  sub_beg_BadBins_vect, sub_end_BadBins_vect, $
  num_DataGaps, JulDay_beg_DataGap_vect, JulDay_end_DataGap_vect

;;;---
dir_save  = PSP_Data_Dir
file_save = 'Bins_BadVal_DataGap'+$
  '(psp_'+suite_str+'_'+payload_str+'_'+descriptor_str+'_'+level_str+')'+$
  '('+year_str+mon_str+day_str+')'+$
  TimeRange_save_str+$
  '.sav'
TimeRange_str = TimeRange_save_str
data_descrip  = 'got from "Read_PSP_SPI_moms_L3_CDF.pro"'
Save, FileName=dir_save+file_save, $
  data_descrip, $
  TimeRange_str, $
  JulDay_beg_BadBins_vect, JulDay_end_BadBins_vect, $
  num_DataGaps, JulDay_beg_DataGap_vect, JulDay_end_DataGap_vect

;;;---
Ni_aver = Mean(Ni_vect,/nan)
Vi_aver = Mean(Sqrt(Vx_RTN_vect^2 + Vy_RTN_vect^2 + Vz_RTN_vect^2),/nan)
Titrace_aver = Mean(Titrace_vect,/nan)
Print, 'Ni_aver [cm^-3], Vi_aver [km/s], Titrace_aver [eV]'
Print, Ni_aver, Vi_aver, Titrace_aver


Step4:
;===========================
;Step4:
num_times = N_Elements(JulDay_vect)
dJulDay_vect  = JulDay_vect[1:num_times-1] - JulDay_vect[0:num_times-2]
dTime_vect    = dJulDay_vect * (24.*60.*60)
;;--
is_timerange_automatic_for_plot = 1
Print, 'is_timerange_automatic_for_plot (0 for defined by user, 1 for automatically inherited from original data): '
Print, is_timerange_automatic_for_plot
is_continue = ' '
;Read, 'is_continue: ', is_continue
If is_timerange_automatic_for_plot eq 0 Then Begin
  hh_beg_plot_str = StrMid(hms_beg_plot_str,0,2) & hour_beg=Float(hh_beg_plot_str)
  mm_beg_plot_str = StrMid(hms_beg_plot_str,3,2) & min_beg=Float(mm_beg_plot_str)
  ss_beg_plot_str = StrMid(hms_beg_plot_str,6,2) & sec_beg=Float(ss_beg_plot_str)
  hh_end_plot_str = StrMid(hms_end_plot_str,0,2) & hour_end=Float(hh_end_plot_str)
  mm_end_plot_str = StrMid(hms_end_plot_str,3,2) & min_end=Float(mm_end_plot_str)
  ss_end_plot_str = StrMid(hms_end_plot_str,6,2) & sec_end=Float(ss_end_plot_str)
  year_beg_plot=Float(year_str) & mon_beg_plot=Float(mon_str) & day_beg_plot=Float(day_str)
  year_end_plot=Float(year_str) & mon_end_plot=Float(mon_str) & day_end_plot=Float(day_str)
  hour_beg_plot=Float(hh_beg_plot_str) & min_beg_plot=Float(mm_beg_plot_str) & sec_beg_plot=Float(ss_beg_plot_str)
  hour_end_plot=Float(hh_end_plot_str) & min_end_plot=Float(mm_end_plot_str) & sec_end_plot=Float(ss_end_plot_str)
  JulDay_beg_plot = JulDay(mon_beg_plot,day_beg_plot,year_beg_plot, hour_beg_plot,min_beg_plot,sec_beg_plot)
  JulDay_end_plot = JulDay(mon_end_plot,day_end_plot,year_end_plot, hour_end_plot,min_end_plot,sec_end_plot)
EndIf Else Begin
  If is_timerange_automatic_for_plot eq 1 Then Begin
    JulDay_beg_plot = Min(JulDay_vect)
    JulDay_end_plot = Max(JulDay_vect)
    CalDat, JulDay_beg_plot, mon_beg_plot, day_beg_plot, year_beg_plot, hour_beg_plot, min_beg_plot, sec_beg_plot
    CalDat, JulDay_end_plot, mon_end_plot, day_end_plot, year_end_plot, hour_end_plot, min_end_plot, sec_end_plot
  EndIf
EndElse
;;--
TimeRange_plot_str  = '(time='+$
  String(hour_beg_plot,format='(I2.2)')+String(min_beg_plot,format='(I2.2)')+String(sec_beg_plot,format='(I2.2)')+'-'+$
  String(hour_end_plot,format='(I2.2)')+String(min_end_plot,format='(I2.2)')+String(sec_end_plot,format='(I2.2)')+')'
;;--
sub_beg_plot = Where(JulDay_vect ge JulDay_beg_plot)
sub_end_plot = Where(JulDay_vect le JulDay_end_plot)
sub_beg_plot = Min(sub_beg_plot)
sub_end_plot = Max(sub_end_plot)
JulDay_vect_plot = JulDay_vect[sub_beg_plot:sub_end_plot]
Ni_vect_plot  = Ni_vect[sub_beg_plot:sub_end_plot]
Vix_vect_plot = Vx_RTN_vect[sub_beg_plot:sub_end_plot]
Viy_vect_plot = Vy_RTN_vect[sub_beg_plot:sub_end_plot]
Viz_vect_plot = Vz_RTN_vect[sub_beg_plot:sub_end_plot]
Tixx_vect_plot = Tixx_Inst_vect[sub_beg_plot:sub_end_plot]
Tiyy_vect_plot = Tiyy_Inst_vect[sub_beg_plot:sub_end_plot]
Tizz_vect_plot = Tizz_Inst_vect[sub_beg_plot:sub_end_plot]
Tixy_vect_plot = Tixy_Inst_vect[sub_beg_plot:sub_end_plot]
Tixz_vect_plot = Tixz_Inst_vect[sub_beg_plot:sub_end_plot]
Tiyz_vect_plot = Tiyz_Inst_vect[sub_beg_plot:sub_end_plot]
Titrace_vect_plot = Titrace_vect[sub_beg_plot:sub_end_plot]
dTime_vect_plot = dJulDay_vect[sub_beg_plot:sub_end_plot-1]*(24.*60*60)


Step5:
;===========================
;Step5:
;;--
PSP_Figure_Dir = 'E:\Research\Work\waves_in_exhaust_region\Figures\'
File_MkDir, PSP_Figure_Dir
;;--
is_png_eps = 1
;;--
If is_png_eps eq 1 Then Begin
  file_version  = '.png'
EndIf Else Begin
  file_version  = '.eps'
EndElse
FileName  = 'Ni_Vi_Ti_tensor_InstFrame'+$
  '(psp_'+suite_str+'_'+payload_str+'_'+descriptor_str+'_'+level_str+')'+$
  '('+year_str+mon_str+day_str+')'+$
  TimeRange_plot_str
FileName = PSP_Figure_Dir + FileName + file_version

;;--
If is_png_eps eq 2 Then Begin
  Set_Plot,'PS'
  xsize = 25.0
  ysize = 25.0
  Device, FileName=FileName, XSize=xsize,YSize=ysize,/Color,Bits=8,/Encapsul
EndIf Else Begin
  If is_png_eps eq 1 Then Begin
    Set_Plot, 'WIN'
    Device,DeComposed=0;, /Retain
    xsize=1000.0 & ysize=900.0
    Window,2,XSize=xsize,YSize=ysize,Retain=2,/pixmap
  EndIf
EndElse

;;--
LoadCT,13
TVLCT,R,G,B,/Get
color_red = 255L
TVLCT,255L,0L,0L,color_red
color_green = 254L
TVLCT,0L,255L,0L,color_green
color_blue  = 253L
TVLCT,0L,0L,255L,color_blue
color_white = 252L
TVLCT,255L,255L,255L,color_white
color_black = 251L
TVLCT,0L,0L,0L,color_black
num_CB_color= 256-5
R=Congrid(R,num_CB_color)
G=Congrid(G,num_CB_color)
B=Congrid(B,num_CB_color)
TVLCT,R,G,B

;;--
color_bg    = color_white
!p.background = color_bg
Plot,[0,1],[0,1],XStyle=1+4,YStyle=1+4,/NoData  ;change the background

;;--
If is_png_eps eq 2 Then Begin
  thick   = 2.5
  xthick  = 2.5
  ythick  = 2.5
  charthick = 2.5
  charsize  = 1.2
EndIf
If is_png_eps eq 1 Then Begin
  thick   = 1.2
  xthick  = 1.2
  ythick  = 1.2
  charthick = 1.2
  charsize  = 1.5
EndIf

;;--
position_img  = [0.05,0.05,0.95,0.95]
num_subimgs_x = 1
num_subimgs_y = 7
dx_subimg   = (position_img[2]-position_img[0])/num_subimgs_x
dy_subimg   = (position_img[3]-position_img[1])/num_subimgs_y

;;--
i_subimg_x  = 0
i_subimg_y  = 0
win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
  position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
position_subplot  = win_position
num_times = N_Elements(JulDay_vect_plot)
xplot_vect  = 0.5*(JulDay_vect_plot(0:num_times-2) + JulDay_vect_plot(1:num_times-1))
yplot_vect  = dTime_vect
xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
xrange_time = xrange
get_xtick_for_time_MacOS, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
xtickv    = xtickv_time
xticks    = N_Elements(xtickv)-1
xticknames  = xticknames_time
xminor  = xminor_time
;xminor    = 6
yrange    = [Min(yplot_vect,/nan)-0.1*(Max(yplot_vect,/nan)-Min(yplot_vect,/nan)), $
             Max(yplot_vect,/nan)+0.1*(Max(yplot_vect,/nan)-Min(yplot_vect,/nan))]
yrange    = [0.,500]
xtitle    = year_str+'/'+mon_str+'/'+day_str
ytitle    = 'dTime (s)'
Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
  Position=position_subplot,$
  XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
  Charsize=charsize,Charthick=charthick,Thick=thick,xthick=xthick,ythick=ythick,$
  XTitle=xtitle,YTitle=ytitle,$
  Color=color_black,$
  /NoErase,Font=-1
;;;---
dtime_aver = Mean(dTime_vect,/NaN) ;unit: s
xyouts_str = String(dtime_aver, format='(F10.5)')+' [s]'
xpos_xyouts= position_subplot[0]+0.2*(position_subplot[2]-position_subplot[0])
ypos_xyouts= position_subplot[1]+0.5*(position_subplot[3]-position_subplot[1])
xyouts, xpos_xyouts, ypos_xyouts, xyouts_str, CharSize=1.5, color=color_black, /Normal

;;--
i_subimg_x  = 0
i_subimg_y  = 1
win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
  position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
position_subplot  = win_position
xplot_vect  = JulDay_vect_plot
yplot_vect_v1  = Tixy_vect_plot
yplot_vect_v2  = Tixz_vect_plot
yplot_vect_v3  = Tiyz_vect_plot
xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
xrange_time = xrange
get_xtick_for_time_MacOS, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
xtickv    = xtickv_time
xticks    = N_Elements(xtickv)-1
;xticknames  = xticknames_time
xticknames  = Replicate(' ', xticks+1)
xminor  = xminor_time
;xminor    = 6
yrange_min = Min([yplot_vect_v1,yplot_vect_v2,yplot_vect_v3],/nan)
yrange_max = Max([yplot_vect_v1,yplot_vect_v2,yplot_vect_v3],/nan)
yrange    = [yrange_min-0.1*(yrange_max-yrange_min),yrange_max+0.1*(yrange_max-yrange_min)]
xtitle    = ' '
ytitle    = TexToIDL('T_'+des_plot_str+' (eV)')
Plot,xplot_vect, yplot_vect_v1,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
  Position=position_subplot,$
  XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
  Charsize=charsize,Charthick=charthick,Thick=thick,xthick=xthick,ythick=ythick,$
  XTitle=xtitle,YTitle=ytitle,$
  Color=color_black,$
  /NoErase,Font=-1
Plots,xplot_vect,yplot_vect_v1,Color=color_black,Thick=thick
Plots,xplot_vect,yplot_vect_v2,Color=color_red,Thick=thick
Plots,xplot_vect,yplot_vect_v3,Color=color_blue,Thick=thick
;;--
xyouts_vect = Reverse(TexToIDL(['T_{'+des_plot_str+',xy}','T_{'+des_plot_str+',xz}','T_{'+des_plot_str+',yz}']))
color_vect = Reverse([color_black, color_red, color_blue])
num_xyouts = N_Elements(xyouts_vect)
For i_xyout=0,num_xyouts-1 Do Begin
  xpos_tmp = position_subplot[2]+0.02
  ypos_tmp = position_subplot[1]+(position_subplot[3]-position_subplot[1])/(num_xyouts+1)*(i_xyout+1)
  color_tmp= color_vect[i_xyout]
  XYOuts, xpos_tmp, ypos_tmp, xyouts_vect[i_xyout], Color=color_tmp, /Normal, CharSize=charsize*1.2
EndFor

;;--
i_subimg_x  = 0
i_subimg_y  = 2
win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
  position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
position_subplot  = win_position
xplot_vect  = JulDay_vect_plot
yplot_vect_v1  = Tixx_vect_plot
yplot_vect_v2  = Tiyy_vect_plot
yplot_vect_v3  = Tizz_vect_plot
xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
xrange_time = xrange
get_xtick_for_time_MacOS, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
xtickv    = xtickv_time
xticks    = N_Elements(xtickv)-1
;xticknames  = xticknames_time
xticknames  = Replicate(' ', xticks+1)
xminor  = xminor_time
;xminor    = 6
yrange_min = Min([yplot_vect_v1,yplot_vect_v2,yplot_vect_v3],/nan)
yrange_max = Max([yplot_vect_v1,yplot_vect_v2,yplot_vect_v3],/nan)
yrange    = [yrange_min-0.1*(yrange_max-yrange_min),yrange_max+0.1*(yrange_max-yrange_min)]
xtitle    = ' '
ytitle    = TexToIDL('T_'+des_plot_str+' (eV)')
Plot,xplot_vect, yplot_vect_v1,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
  Position=position_subplot,$
  XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
  Charsize=charsize,Charthick=charthick,Thick=thick,xthick=xthick,ythick=ythick,$
  XTitle=xtitle,YTitle=ytitle,$
  Color=color_black,$
  /NoErase,Font=-1
Plots,xplot_vect,yplot_vect_v1,Color=color_black,Thick=thick
Plots,xplot_vect,yplot_vect_v2,Color=color_red,Thick=thick
Plots,xplot_vect,yplot_vect_v3,Color=color_blue,Thick=thick
;;--
xyouts_vect = Reverse(TexToIDL(['T_{'+des_plot_str+',xx}','T_{'+des_plot_str+',yy}','T_{'+des_plot_str+',zz}']))
color_vect = Reverse([color_black, color_red, color_blue])
num_xyouts = N_Elements(xyouts_vect)
For i_xyout=0,num_xyouts-1 Do Begin
  xpos_tmp = position_subplot[2]+0.02
  ypos_tmp = position_subplot[1]+(position_subplot[3]-position_subplot[1])/(num_xyouts+1)*(i_xyout+1)
  color_tmp= color_vect[i_xyout]
  XYOuts, xpos_tmp, ypos_tmp, xyouts_vect[i_xyout], Color=color_tmp, /Normal, CharSize=charsize*1.2
EndFor

;;--
i_subimg_x  = 0
i_subimg_y  = 3
win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
  position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
position_subplot  = win_position
xplot_vect  = JulDay_vect_plot
yplot_vect  = Ni_vect_plot
xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
xrange_time = xrange
get_xtick_for_time_MacOS, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
xtickv    = xtickv_time
xticks    = N_Elements(xtickv)-1
;xticknames  = xticknames_time
xticknames  = Replicate(' ', xticks+1)
xminor  = xminor_time
;xminor    = 6
yrange    = [Min(yplot_vect)-0.1*(Max(yplot_vect)-Min(yplot_vect)),Max(yplot_vect)+0.1*(Max(yplot_vect)-Min(yplot_vect))]
xtitle    = ' '
ytitle    =  TexToIDL('N_'+des_plot_str+' (cm^{-3})')
Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
  Position=position_subplot,$
  XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
  Charsize=charsize,Charthick=charthick,Thick=thick,xthick=xthick,ythick=ythick,$
  XTitle=xtitle,YTitle=ytitle,$
  Color=color_black,$
  /NoErase,Font=-1

;;--
i_subimg_x  = 0
i_subimg_y  = 4
win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
  position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
position_subplot  = win_position
xplot_vect  = JulDay_vect_plot
yplot_vect  = Viz_vect_plot
xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
xrange_time = xrange
get_xtick_for_time_MacOS, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
xtickv    = xtickv_time
xticks    = N_Elements(xtickv)-1
;xticknames  = xticknames_time
xticknames  = Replicate(' ', xticks+1)
xminor  = xminor_time
;xminor    = 6
yrange    = [Min(yplot_vect,/nan)-0.1*(Max(yplot_vect,/nan)-Min(yplot_vect,/nan)), $
             Max(yplot_vect,/nan)+0.1*(Max(yplot_vect,/nan)-Min(yplot_vect,/nan))]
xtitle    = ' '
ytitle    = TexToIDL('V_{'+des_plot_str+',N} (km/s)')
Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
  Position=position_subplot,$
  XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
  Charsize=charsize,Charthick=charthick,Thick=thick,xthick=xthick,ythick=ythick,$
  XTitle=xtitle,YTitle=ytitle,$
  Color=color_black,$
  /NoErase,Font=-1

;;--
i_subimg_x  = 0
i_subimg_y  = 5
win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
  position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
position_subplot  = win_position
xplot_vect  = JulDay_vect_plot
yplot_vect  = Viy_vect_plot
xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
xrange_time = xrange
get_xtick_for_time_MacOS, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
xtickv    = xtickv_time
xticks    = N_Elements(xtickv)-1
;xticknames  = xticknames_time
xticknames  = Replicate(' ', xticks+1)
xminor  = xminor_time
;xminor    = 6
yrange    = [Min(yplot_vect,/nan)-0.1*(Max(yplot_vect,/nan)-Min(yplot_vect,/nan)), $
             Max(yplot_vect,/nan)+0.1*(Max(yplot_vect,/nan)-Min(yplot_vect,/nan))]
xtitle    = ' '
ytitle    = TexToIDL('V_{'+des_plot_str+',T} (km/s)')
Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
  Position=position_subplot,$
  XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
  Charsize=charsize,Charthick=charthick,Thick=thick,xthick=xthick,ythick=ythick,$
  XTitle=xtitle,YTitle=ytitle,$
  Color=color_black,$
  /NoErase,Font=-1

;;--
i_subimg_x  = 0
i_subimg_y  = 6
win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
  position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
  position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
position_subplot  = win_position
xplot_vect  = JulDay_vect_plot
yplot_vect  = Vix_vect_plot
xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
xrange_time = xrange
get_xtick_for_time_MacOS, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
xtickv    = xtickv_time
xticks    = N_Elements(xtickv)-1
;xticknames  = xticknames_time
xticknames  = Replicate(' ', xticks+1)
xminor  = xminor_time
;xminor    = 6
yrange    = [Min(yplot_vect,/nan)-0.1*(Max(yplot_vect,/nan)-Min(yplot_vect,/nan)), $
             Max(yplot_vect,/nan)+0.1*(Max(yplot_vect,/nan)-Min(yplot_vect,/nan))]
xtitle    = ' '
ytitle    = TexToIDL('V_{'+des_plot_str+',R} (km/s)')
Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
  Position=position_subplot,$
  XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
  Charsize=charsize,Charthick=charthick,Thick=thick,xthick=xthick,ythick=ythick,$
  XTitle=xtitle,YTitle=ytitle,$
  Color=color_black,$
  /NoErase,Font=-1

;;--
AnnotStr_tmp  = 'got from "Read_PSP_SPI_moms_L3_CDF.pro"'
AnnotStr_arr  = [AnnotStr_tmp]
num_strings     = N_Elements(AnnotStr_arr)
For i_str=0,num_strings-1 Do Begin
  position_v1   = [position_img[0],position_img[1]/(num_strings+2)*(i_str+1)]
  CharSize    = 0.95
  XYOuts,position_v1[0],position_v1[1],AnnotStr_arr[i_str],/Normal,$
    CharSize=charsize,color=color_black,Font=-1
EndFor

;;--
If is_png_eps eq 1 Then Begin
  image_tvrd  = TVRD(true=1)
  Write_PNG, FileName, image_tvrd; tvrd(/true), r,g,b
EndIf Else Begin
  If is_png_eps eq 2 Then Begin
    ;;;--
    Device,/Close
  EndIf
EndElse

Endfor
End_Program:
End