;Pro Read_PSP_fld_Volt_cdf_batching
suite_str = 'fld'
level_str = 'l2'
payload_str = 'dfb'
payload_str_v2 = 'wf_dvdc'
cadence_str = '';'_1min'; '', '_1min'
;;--
year_str = '2020'
;;--
PSP_dfb_Data_Dir = 'E:\Research\Data\PSP\Encounter 5\'
;;--
is_timerange_automatic = 1
is_timerange_automatic_for_plot = 1

Step1:
;===========================
;Step1:
;;--
dir_read  = PSP_dfb_Data_Dir
file_read = 'psp_'+suite_str+'_'+level_str+'_'+payload_str+'_'+payload_str_v2+'_'+ $
  '*_v**'+'.cdf'
file_array  = File_Search(dir_read+file_read, count=num_files)
For i_file=0,num_files-1 Do Begin
  Print, 'i_file, file: ', i_file, ': ', file_array[i_file]
Endfor
For i_file=0,num_files-1 Do Begin
  file_read = file_array[i_file]
  file_read = StrMid(file_read, StrLen(dir_read),StrLen(file_read)-StrLen(dir_read))
  mon_str = StrMid(file_read, 27, 2)
  day_str = Strmid(file_read, 29, 2)
  ;;--
  CD, Current=wk_dir
  CD, dir_read
  cdf_id  = CDF_Open(file_read)
  ;;--
  CDF_Control, cdf_id, Variable='epoch', Get_Var_Info=Info_Epoch
  num_records   = Info_Epoch.MaxRec + 1L
  CDF_VarGet, cdf_id, 'epoch', Epoch_vect, Rec_Count=num_records
  CDF_VarGet, cdf_id, 'psp_fld_l2_dfb_wf_dVdc_sc', Uij_Solar_arr, Rec_Count=num_records
  CDF_VarGet, cdf_id, 'psp_fld_l2_quality_flags', U_quality_flags, Rec_Count=num_records
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
  
  
  Step2:
  ;===========================
  ;Step2:
  Ui_Solar_vect  = Reform(Uij_Solar_arr[0,*])
  Uj_Solar_vect  = Reform(Uij_Solar_arr[1,*])
  U_quality_flags = Reform(U_quality_flags)
  ;--
  ;method 1
  Ui_mean_num =  mean(Ui_Solar_vect[where(abs(Ui_Solar_vect) lt 0.2)])
  Uj_mean_num =  mean(Uj_Solar_vect[where(abs(Uj_Solar_vect) lt 0.2)])
  Ui_Solar_vect[where(abs(Ui_Solar_vect-Ui_mean_num) ge 0.1)] = Ui_mean_num
  Uj_Solar_vect[where(abs(Uj_Solar_vect-Uj_mean_num) ge 0.1)] = Uj_mean_num
  
  
  Step3:
  ;===========================
  ;Step3:
  ;Print, 'is_timerange_automatic (0 for defined by user, 1 for automatically inherited from original data): '
  ;Print, is_timerange_automatic
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
  Ui_Solar_vect_save  = Ui_Solar_vect[sub_beg_save:sub_end_save]
  Uj_Solar_vect_save  = Uj_Solar_vect[sub_beg_save:sub_end_save]
  U_quality_flags_save = U_quality_flags[sub_beg_save:sub_end_save]

  ;;--
  PSP_Data_Dir = 'E:\Research\Work\waves_in_exhaust_region\Figures\'
  File_MkDir, PSP_Data_Dir
  ;;--
  dir_save  = PSP_Data_Dir
  file_save = 'Voltage_Uij_'+$
    '(psp_'+suite_str+'_'+level_str+'_'+payload_str+'_'+payload_str_v2+'_'+cadence_str+')'+$
    '('+year_str+mon_str+day_str+')'+$
    TimeRange_save_str+$
    '.sav'
  TimeRange_str = TimeRange_save_str
  data_descrip  = 'got from "Read_PSP_fld_Volt_cdf.pro"'
  Save, FileName=dir_save+file_save, $
      data_descrip, $
      JulDay_vect_save, Ui_Solar_vect_save, Uj_Solar_vect_save
      
  Step4:
  ;===========================
  ;Step4:
  num_times = N_Elements(JulDay_vect)
  dJulDay_vect  = JulDay_vect[1:num_times-1] - JulDay_vect[0:num_times-2]
  dTime_vect    = dJulDay_vect * (24.*60.*60)
  ;;--
  ;Print, 'is_timerange_automatic_for_plot (0 for defined by user, 1 for automatically inherited from original data): '
  ;Print, is_timerange_automatic_for_plot
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
  Ui_Solar_vect_plot = Ui_Solar_vect[sub_beg_plot:sub_end_plot]
  Uj_Solar_vect_plot = Uj_Solar_vect[sub_beg_plot:sub_end_plot]
  U_quality_flags_plot = U_quality_flags[sub_beg_plot:sub_end_plot]
  dTime_vect    = dJulDay_vect[sub_beg_plot:sub_end_plot-1]*(24.*60*60)


  Step5:
  ;===========================
  ;Step5:
  ;;--
  PSP_Figure_Dir = 'C:\STUDY\PSP\Encounter 5\RESULT\Figures\'
  File_MkDir, PSP_Figure_Dir
  ;;--
  is_png_eps = 1
  If is_png_eps eq 2 Then Begin
    Set_Plot,'PS'
    xsize = 25.0
    ysize = 25.0
    Device, FileName=FileName_v2, XSize=xsize,YSize=ysize,/Color,Bits=8,/Encapsul
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
  num_subimgs_y = 5
  dx_subimg   = (position_img[2]-position_img[0])/num_subimgs_x
  dy_subimg   = (position_img[3]-position_img[1])/num_subimgs_y
  ;---------------------------------------------------------------------------
  i_subimg_x  = 0
  i_subimg_y  = 0
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_vect_plot
  yplot_vect  = U_quality_flags_plot-4294967295
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  xticknames  = xticknames_time
  xminor  = xminor_time
  print,'------------------------------------'
  print,xticknames_time
  print,'------------------------------------'
  ;xminor    = 6
  yrange    = [-2,2]
  ;yrange    = [0.,0.05*20]
  xtitle    = 'Time'
  ytitle    = 'Quality Num'
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle=xtitle,YTitle=ytitle,$
    Color=color_black,$
    /NoErase,Font=-1
  ;---------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 1
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_vect_plot
  yplot_vect  = dTime_vect
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  ;xticknames  = xticknames_time
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  yrange    = [0.0,0.1]
  ;yrange    = [0.,0.05*20]
  xtitle    = ''
  ytitle    = 'dTime [s]'
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle=xtitle,YTitle=ytitle,$
    Color=color_black,$
    /NoErase,Font=-1
  ;;--
  ;---------------------------------------------------------------------------
  i_subimg_x  = 0
  i_subimg_y  = 2
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_vect_plot
  yplot_vect  = Uj_Solar_vect_plot
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  ;xticknames  = xticknames_time
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  yrange    = [Min(yplot_vect)-0.01,Max(yplot_vect)+0.01]
  xtitle    = ' '
  ytitle    = 'Uj (mV)'
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle=xtitle,YTitle=ytitle,$
    Color=color_black,$
    /NoErase,Font=-1
  ;;--
  ;---------------------------------------------------------------------------
  i_subimg_x  = 0
  i_subimg_y  = 3
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_vect_plot
  yplot_vect  = Ui_Solar_vect_plot
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  ;xticknames  = xticknames_time
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  yrange    = [Min(yplot_vect)-0.01,Max(yplot_vect)+0.01]
  xtitle    = ' '
  ytitle    = 'Ui (mV)'
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle=xtitle,YTitle=ytitle,$
    Color=color_black,$
    /NoErase,Font=-1
  ;;--
  ;---------------------------------------------------------------------------
  i_subimg_x  = 0
  i_subimg_y  = 4
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.10*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.90*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_vect_plot
  yplot_vect  = Sqrt(Ui_Solar_vect_plot^2+Uj_Solar_vect_plot^2)
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  ;xticknames  = xticknames_time
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  yrange    = [Min(yplot_vect)-0.01,Max(yplot_vect)+0.01]
  xtitle    = ' '
  ytitle    = '|U| in TN flat (nT)'
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle=xtitle,YTitle=ytitle,$
    Color=color_black,$
    /NoErase,Font=-1
  ;;--
  AnnotStr_tmp  = 'got from "A_step_ele_read_cdf"'
  AnnotStr_arr  = [AnnotStr_tmp]
  num_strings     = N_Elements(AnnotStr_arr)
  For i_str=0,num_strings-1 Do Begin
    position_v1   = [position_img[0],position_img[1]/(num_strings+2)*(i_str+1)]
    CharSize    = 0.95
    XYOuts,position_v1[0],position_v1[1],AnnotStr_arr[i_str],/Normal,$
      CharSize=charsize,color=color_black,Font=-1
  EndFor

  ;;--
  image_tvrd  = TVRD(true=1)
  dir_fig   = PSP_Figure_Dir
  file_fig  = 'Ui_and_Uj_in_SC_Frame'+$
    '(psp_'+suite_str+'_'+level_str+'_'+payload_str+'_'+payload_str_v2+'_'+cadence_str+')'+$
    '('+year_str+mon_str+day_str+')'+$
    TimeRange_plot_str+$
    '.png'
  Write_PNG, dir_fig+file_fig, image_tvrd; tvrd(/true), r,g,b
Endfor
End_Program:
End