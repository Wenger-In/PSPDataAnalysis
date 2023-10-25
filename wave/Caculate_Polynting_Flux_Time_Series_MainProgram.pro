;Pro Caculate_Polynting_flux_Time_Series_MainProgram
mag_suite_str = 'fld'
mag_level_str = 'l2'
mag_payload_str = 'mag'
mag_coord_str = 'rtn'
mag_cadence_str = ''
dfb_suite_str = 'fld'
dfb_level_str = 'l2'
dfb_payload_str = 'dfb'
dfb_payload_str_v2 = 'wf_dvdc'
dfb_cadence_str = ''
spc_suite_str = 'swp'
spc_level_str = 'l3i'
spc_pre_level_str = StrMid(spc_level_str,0,2)
spc_payload_str = 'spc'
spi_suite_str = 'swp'
spi_payload_str = 'spi'
spi_descriptor_str = 'sf00'
spi_level_str = 'l3'
;;--
is_timerange_automatic_for_cal = 1
is_timerange_automatic_for_plot = 1
;;--
PSP_savData_Dir = 'C:\STUDY\PSP\Encounter 5\RESULT\SaveData\'
PSP_Figure_Dir = 'C:\STUDY\PSP\Encounter 5\RESULT\Figures\'
;;--
is_use_spc_or_spi = 1 ; 1 for spc 2 for spi
is_use_optimazation_spc = 1
spc_v_str = is_use_optimazation_spc eq 1 ? '(optimized)':''

is_rtn_or_sc = 1
is_rtn_or_sc_str = is_rtn_or_sc eq 1 ? 'RTN':'SC'
Step1:
;========================================
;;--read the electric field and magnetic field data and calculate the poynting flux
dir_data = PSP_savData_Dir
Data_Restore_Str = '(????????)'
TimeRange_Restore_Str = '(time=??????-??????)'
If is_use_spc_or_spi eq 1 Then Begin
  file_restore = 'Electric_Field_Offset_in_'+is_rtn_or_sc_str+'_Frame'+$
    '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
    '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
    '(psp_'+spc_suite_str+'_'+spc_payload_str+'_'+spc_level_str+')'+$
    Data_Restore_Str+TimeRange_Restore_Str+'.sav'
Endif
If is_use_spc_or_spi eq 2 Then Begin
  file_restore = 'Electric_Field_Offset_in_'+is_rtn_or_sc_str+'_Frame'+$
    '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
    '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
    '(psp_'+spi_suite_str+'_'+spi_payload_str+'_'+spi_descriptor_str+'_'+spi_level_str+')'+$
    Data_Restore_Str+TimeRange_Restore_Str+'.sav'
Endif
file_array  = File_Search(dir_data, file_restore, count=num_files)
For i_file=0,num_files-1 Do Begin
  Print, 'i_file, file: ', i_file, ': ', file_array[i_file]
Endfor
;;--
For i_file=0,num_files-1 Do Begin
  file_restore  = file_array[i_file]
  file_restore  = StrMid(file_restore, StrLen(dir_data)+0, StrLen(file_restore)-StrLen(dir_data)-0)
  If is_use_spc_or_spi eq 1 Then Begin
    year_str = StrMid(file_restore, 97, 4)
    mon_str  = StrMid(file_restore, 101, 2)
    day_str  = Strmid(file_restore, 103, 2)
  Endif
  If is_use_spc_or_spi eq 2 Then Begin
    year_str = StrMid(file_restore, 47, 4)
    mon_str  = StrMid(file_restore, 51, 2)
    day_str  = Strmid(file_restore, 53, 2)
  Endif
  dir_restore = dir_data
  dir_save = dir_restore
  dir_fig = PSP_Figure_Dir
  ;;--
  Restore, FileName=dir_restore+file_restore, /Verbose
  ;  data_descrip  = 'got from "Calculate_electric_field_from_the_Voltage_BasedOn_PSP_MainProgram"'
  ;  Save, FileName=dir_save+file_save, $
  ;    data_descrip, $
  ;    JulDay_E_offset_vect, Et_offset_Solar_vect, En_offset_Solar_vect
  JulDay_E_vect = JulDay_E_offset_vect
  Et_Solar_vect = Et_offset_Solar_vect
  En_Solar_vect = En_offset_Solar_vect
  JulDay_B_vect = []
  Br_Solar_vect = [] & Bt_Solar_vect = [] & Bn_Solar_vect = []
  mag_file_restore  = 'Bxyz_RTN_arr'+$
    '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
    '('+year_str+mon_str+day_str+')'+'*.sav'
  mag_file_array  = File_Search(dir_restore, mag_file_restore, count=num_files)
  For h=0,3 Do Begin
    mag_file_restore  = mag_file_array[h]
    mag_file_restore  = StrMid(mag_file_restore, StrLen(dir_restore), StrLen(mag_file_restore)-StrLen(dir_restore))
    Restore, dir_restore+mag_file_restore, /verbose
    ;data_descrip  = 'got from "Read_PSP_MAG_L2_CDF.pro"'
    ;Save, FileName=dir_save+file_save, $
    ;  data_descrip, $
    ;  TimeRange_str, $
    ;  JulDay_vect_save, Bx_SC_vect_save, By_SC_vect_save, Bz_SC_vect_save, $
    ;  JulDay_vect_interp, Bx_SC_vect_interp, By_SC_vect_interp, Bz_SC_vect_interp, $
    ;  sub_beg_BadBins_vect, sub_end_BadBins_vect, $
    ;  num_DataGaps, JulDay_beg_DataGap_vect, JulDay_end_DataGap_vect
    JulDay_B_vect = [JulDay_B_vect, JulDay_vect_save]
    Br_Solar_vect = [Br_Solar_vect, -Bz_RTN_vect_save]
    Bt_Solar_vect = [Bt_Solar_vect, +Bx_RTN_vect_save]
    Bn_Solar_vect = [Bn_Solar_vect, -By_RTN_vect_save]
  Endfor

  ;;--
  JulDay_vect_min = min(JulDay_B_vect) < min(JulDay_E_vect)
  JulDay_vect_max = max(JulDay_B_vect) > max(JulDay_E_vect)
  dTime_Pol = 0.034
  n_times = floor((JulDay_vect_max-JulDay_vect_min)*(24.0*60.0*60.0)/dTime_Pol)
  ;;--
  JulDay_P_vect = JulDay_vect_min + dTime_Pol*findgen(n_times)/(24.0*60.0*60.0)
  ;Pol B to Poynting
  Pol_Br_Solar_vect = INTERPOL(Br_Solar_vect, JulDay_B_vect, JulDay_P_vect)
  Pol_Bt_Solar_vect = INTERPOL(Bt_Solar_vect, JulDay_B_vect, JulDay_P_vect)
  Pol_Bn_Solar_vect = INTERPOL(Bn_Solar_vect, JulDay_B_vect, JulDay_P_vect)
  ;Pol E to Poynting
  Pol_Et_Solar_vect = INTERPOL(Et_Solar_vect, JulDay_E_vect, JulDay_P_vect)
  Pol_En_Solar_vect = INTERPOL(En_Solar_vect, JulDay_E_vect, JulDay_P_vect)
  ;Caculate Poynting R direction
  from_nT_to_T = 1.e-9
  from_mV_to_V = 1.e-3
  Poynting_r_vect = (Pol_Et_Solar_vect*Pol_Bn_Solar_vect - Pol_Bt_Solar_vect*Pol_En_Solar_vect)/!const.mu0 * from_nT_to_T * from_mV_to_V
  
  ;=============================================================================================================================
  Step2:
  ;========================================
  ;do smooth or window_mean
  slide_window_length = 200
  slide_devided = 1.0
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  num_times = N_elements(JulDay_P_vect)
  dT_P = mean(JulDay_P_vect[1:num_times-1]-JulDay_P_vect[0:num_times-2])*(24.*60.*60)
  num_window = round(slide_window_length/dT_P)
  num_slide = round(num_window/slide_devided)
  head_i = 0
  tail_i = head_i+num_window
  JulDay_P_window_vect = []
  Poynting_r_window_plot = []
  Pol_Br_window_plot = []
  Pol_Bt_window_plot = []
  Pol_Bn_window_plot = []
  Pol_Et_window_plot = []
  Pol_En_window_plot = []
  ;--
  rate_progress = 0.0
  print,'=================='
  print,'Begin Poynting_r_vect smoothing'
  while (tail_i lt num_times) do begin
    JulDay_P_window_vect = [JulDay_P_window_vect,JulDay_P_vect[round((head_i+tail_i)/2.0)]]
    ;--
    list_para = Poynting_r_vect[head_i:tail_i]
    list_para = list_para[where(Finite(list_para))]
    Poynting_r_window_plot = [Poynting_r_window_plot,mean(list_para)]
    ;--
    list_para = Pol_Br_Solar_vect[head_i:tail_i]
    list_para = list_para[where(Finite(list_para))]
    Pol_Br_window_plot = [Pol_Br_window_plot,mean(list_para)]
    ;--
    list_para = Pol_Bt_Solar_vect[head_i:tail_i]
    list_para = list_para[where(Finite(list_para))]
    Pol_Bt_window_plot = [Pol_Bt_window_plot,mean(list_para)]
    ;--
    list_para = Pol_Bn_Solar_vect[head_i:tail_i]
    list_para = list_para[where(Finite(list_para))]
    Pol_Bn_window_plot = [Pol_Bn_window_plot,mean(list_para)]
    ;--
    list_para = Pol_Et_Solar_vect[head_i:tail_i]
    list_para = list_para[where(Finite(list_para))]
    Pol_Et_window_plot = [Pol_Et_window_plot,mean(list_para)]
    ;--
    list_para = Pol_En_Solar_vect[head_i:tail_i]
    list_para = list_para[where(Finite(list_para))]
    Pol_En_window_plot = [Pol_En_window_plot,mean(list_para)]
    ;--
    head_i = head_i+num_slide
    tail_i = head_i+num_window
    if ((tail_i-0.0)/num_times-rate_progress ge 0.01) then begin
      print,strcompress(string(rate_progress*100),/remove_all),'%'
      rate_progress = (tail_i-0.0)/num_times
    endif
  endwhile
  print,'Done!'
  print,'=================='

  Step3:
  ;========================================
  ;;--plot the PSDs of E and VxB
  dir_fig = 'C:\STUDY\PSP\Encounter 5\RESULT\Figures\'
  If is_use_spc_or_spi eq 1 Then Begin
    file_fig = 'Poynting_Flux_Time_Series'+$
      '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
      '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
      '(psp_'+spc_suite_str+'_'+spc_payload_str+'_'+spc_level_str+')'+$
      '('+year_str+mon_str+day_str+')'+Strmid(file_restore, 106, 20)
  Endif
  If is_use_spc_or_spi eq 2 Then Begin
    file_fig = 'Poynting_Flux_Time_Series'+$
      '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
      '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
      '(psp_'+spi_suite_str+'_'+spi_payload_str+'_'+spi_descriptor_str+'_'+spi_level_str+')'+$
      '('+year_str+mon_str+day_str+')'+Strmid(file_restore, 106, 20)
  Endif
  ;;--
  is_png_eps = 1
  If is_png_eps eq 1 Then Begin
    file_version  = '.png'
  EndIf Else Begin
    file_version  = '.eps'
  EndElse
  FileName  = dir_fig + file_fig + file_version
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
      xsize=1600.0 & ysize=1600.0
      Window,2,XSize=xsize,YSize=ysize,Retain=2,/pixmap
    EndIf
  EndElse
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
  ;--
  legend_charsize = 2.0
  legend_charthick = 2.0
  axis_chatthick = 2.0
  axislegend_charsize = 2.0
  axislegend_charthick = 2.0
  plot_charthick = 2.0
  yline_plot_begin = 0.06
  yline_plot_end = 0.95
  xline_plot_begin = 0.04
  xline_plot_end = 0.96
  ;--
  y_line_all_num = 6
  x_line_all_num = 1
  ;--
  x_line_interval = (xline_plot_end - xline_plot_begin)/x_line_all_num
  y_line_interval = (yline_plot_end - yline_plot_begin)/y_line_all_num
  x_interval_ratio = 0.9
  y_interval_ratio = 1.0
  ;;--
  yline_plot_num = 1
  xline_plot_num = 1
  position_x_begin = xline_plot_begin+x_line_interval*(xline_plot_num-1)+x_line_interval*(1-x_interval_ratio)
  position_x_end   = xline_plot_begin+x_line_interval*xline_plot_num
  position_y_begin = yline_plot_begin+y_line_interval*(yline_plot_num-1)+y_line_interval*(1-y_interval_ratio)
  position_y_end   = yline_plot_begin+y_line_interval*yline_plot_num
  position_SubImg  = [position_x_begin,position_y_begin,position_x_end,position_y_end]
  xplot_vect  = JulDay_P_window_vect
  yplot_vect  = Poynting_r_window_plot
  xrange  = [JulDay_vect_min, JulDay_vect_max]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  ;xticknames  = xticknames_time
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  yrange_min = Min(yplot_vect)
  yrange_max = Max(yplot_vect)
  yrange    = [yrange_min-0.05*(yrange_max-yrange_min),yrange_max+0.05*(yrange_max-yrange_min)]
  xtitle    = ''
  ytitle    = TextoIDL('S [J/(s\cdotm)]')
  plot,xplot_vect,yplot_vect,Position=position_SubImg,color=0,xrange=xrange,xstyle=1,xlog=0,yrange=yrange,ystyle=1,ylog=0,xtitle=xtitle,ytitle=ytitle,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames_time,XMinor=xminor,XTickLen=0.04,$
    xthick=axis_chatthick,ythick=axis_chatthick,charsize=axislegend_charsize,charthick=axislegend_charthick,background=color_white,/nodata,/NoErase
  ;--
  oplot,xplot_vect,yplot_vect,color=color_black,thick=plot_charthick*1.0
  oplot,xplot_vect,fltarr(N_elements(yplot_vect)),color=color_green,thick=plot_charthick*0.5
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  ;;--
  yline_plot_num = 2
  xline_plot_num = 1
  position_x_begin = xline_plot_begin+x_line_interval*(xline_plot_num-1)+x_line_interval*(1-x_interval_ratio)
  position_x_end   = xline_plot_begin+x_line_interval*xline_plot_num
  position_y_begin = yline_plot_begin+y_line_interval*(yline_plot_num-1)+y_line_interval*(1-y_interval_ratio)
  position_y_end   = yline_plot_begin+y_line_interval*yline_plot_num
  position_SubImg  = [position_x_begin,position_y_begin,position_x_end,position_y_end]
  xplot_vect  = JulDay_P_window_vect
  yplot_vect  = Pol_En_window_plot
  xrange  = [JulDay_vect_min, JulDay_vect_max]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  ;xticknames  = xticknames_time
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  yrange_min = Min(yplot_vect)
  yrange_max = Max(yplot_vect)
  yrange    = [yrange_min-0.05*(yrange_max-yrange_min),yrange_max+0.05*(yrange_max-yrange_min)]
  xtitle    = ''
  ytitle    = TextoIDL('E_N [mV m^{-1}]')
  plot,xplot_vect,yplot_vect,Position=position_SubImg,color=0,xrange=xrange,xstyle=1,xlog=0,yrange=yrange,ystyle=1,ylog=0,xtitle=xtitle,ytitle=ytitle,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    xthick=axis_chatthick,ythick=axis_chatthick,charsize=axislegend_charsize,charthick=axislegend_charthick,background=color_white,/nodata,/NoErase
  ;--
  oplot,xplot_vect,yplot_vect,color=color_black,thick=plot_charthick*1.0
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  ;;--
  yline_plot_num = 3
  xline_plot_num = 1
  position_x_begin = xline_plot_begin+x_line_interval*(xline_plot_num-1)+x_line_interval*(1-x_interval_ratio)
  position_x_end   = xline_plot_begin+x_line_interval*xline_plot_num
  position_y_begin = yline_plot_begin+y_line_interval*(yline_plot_num-1)+y_line_interval*(1-y_interval_ratio)
  position_y_end   = yline_plot_begin+y_line_interval*yline_plot_num
  position_SubImg  = [position_x_begin,position_y_begin,position_x_end,position_y_end]
  xplot_vect  = JulDay_P_window_vect
  yplot_vect  = Pol_Et_window_plot
  xrange  = [JulDay_vect_min, JulDay_vect_max]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  ;xticknames  = xticknames_time
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  yrange_min = Min(yplot_vect)
  yrange_max = Max(yplot_vect)
  yrange    = [yrange_min-0.05*(yrange_max-yrange_min),yrange_max+0.05*(yrange_max-yrange_min)]
  xtitle    = ''
  ytitle    = TextoIDL('E_T [mV m^{-1}]')
  plot,xplot_vect,yplot_vect,Position=position_SubImg,color=0,xrange=xrange,xstyle=1,xlog=0,yrange=yrange,ystyle=1,ylog=0,xtitle=xtitle,ytitle=ytitle,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    xthick=axis_chatthick,ythick=axis_chatthick,charsize=axislegend_charsize,charthick=axislegend_charthick,background=color_white,/nodata,/NoErase
  ;--
  oplot,xplot_vect,yplot_vect,color=color_black,thick=plot_charthick*1.0
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  ;;--
  yline_plot_num = 4
  xline_plot_num = 1
  position_x_begin = xline_plot_begin+x_line_interval*(xline_plot_num-1)+x_line_interval*(1-x_interval_ratio)
  position_x_end   = xline_plot_begin+x_line_interval*xline_plot_num
  position_y_begin = yline_plot_begin+y_line_interval*(yline_plot_num-1)+y_line_interval*(1-y_interval_ratio)
  position_y_end   = yline_plot_begin+y_line_interval*yline_plot_num
  position_SubImg  = [position_x_begin,position_y_begin,position_x_end,position_y_end]
  xplot_vect  = JulDay_P_window_vect
  yplot_vect  = Pol_Bn_window_plot
  xrange  = [JulDay_vect_min, JulDay_vect_max]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  ;xticknames  = xticknames_time
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  yrange_min = Min(yplot_vect)
  yrange_max = Max(yplot_vect)
  yrange    = [yrange_min-0.05*(yrange_max-yrange_min),yrange_max+0.05*(yrange_max-yrange_min)]
  xtitle    = ''
  ytitle    = TextoIDL('B_N [nT]')
  plot,xplot_vect,yplot_vect,Position=position_SubImg,color=0,xrange=xrange,xstyle=1,xlog=0,yrange=yrange,ystyle=1,ylog=0,xtitle=xtitle,ytitle=ytitle,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    xthick=axis_chatthick,ythick=axis_chatthick,charsize=axislegend_charsize,charthick=axislegend_charthick,background=color_white,/nodata,/NoErase
  ;--
  oplot,xplot_vect,yplot_vect,color=color_black,thick=plot_charthick*1.0
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  ;;--
  yline_plot_num = 5
  xline_plot_num = 1
  position_x_begin = xline_plot_begin+x_line_interval*(xline_plot_num-1)+x_line_interval*(1-x_interval_ratio)
  position_x_end   = xline_plot_begin+x_line_interval*xline_plot_num
  position_y_begin = yline_plot_begin+y_line_interval*(yline_plot_num-1)+y_line_interval*(1-y_interval_ratio)
  position_y_end   = yline_plot_begin+y_line_interval*yline_plot_num
  position_SubImg  = [position_x_begin,position_y_begin,position_x_end,position_y_end]
  xplot_vect  = JulDay_P_window_vect
  yplot_vect  = Pol_Bt_window_plot
  xrange  = [JulDay_vect_min, JulDay_vect_max]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  ;xticknames  = xticknames_time
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  yrange_min = Min(yplot_vect)
  yrange_max = Max(yplot_vect)
  yrange    = [yrange_min-0.05*(yrange_max-yrange_min),yrange_max+0.05*(yrange_max-yrange_min)]
  xtitle    = ''
  ytitle    = TextoIDL('B_T [nT]')
  plot,xplot_vect,yplot_vect,Position=position_SubImg,color=0,xrange=xrange,xstyle=1,xlog=0,yrange=yrange,ystyle=1,ylog=0,xtitle=xtitle,ytitle=ytitle,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    xthick=axis_chatthick,ythick=axis_chatthick,charsize=axislegend_charsize,charthick=axislegend_charthick,background=color_white,/nodata,/NoErase
  ;--
  oplot,xplot_vect,yplot_vect,color=color_black,thick=plot_charthick*1.0
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  ;;--
  yline_plot_num = 6
  xline_plot_num = 1
  position_x_begin = xline_plot_begin+x_line_interval*(xline_plot_num-1)+x_line_interval*(1-x_interval_ratio)
  position_x_end   = xline_plot_begin+x_line_interval*xline_plot_num
  position_y_begin = yline_plot_begin+y_line_interval*(yline_plot_num-1)+y_line_interval*(1-y_interval_ratio)
  position_y_end   = yline_plot_begin+y_line_interval*yline_plot_num
  position_SubImg  = [position_x_begin,position_y_begin,position_x_end,position_y_end]
  xplot_vect  = JulDay_P_window_vect
  yplot_vect  = Pol_Br_window_plot
  xrange  = [JulDay_vect_min, JulDay_vect_max]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  ;xticknames  = xticknames_time
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  yrange_min = Min(yplot_vect)
  yrange_max = Max(yplot_vect)
  yrange    = [yrange_min-0.05*(yrange_max-yrange_min),yrange_max+0.05*(yrange_max-yrange_min)]
  xtitle    = ''
  ytitle    = TextoIDL('B_R [nT]')
  plot,xplot_vect,yplot_vect,Position=position_SubImg,color=0,xrange=xrange,xstyle=1,xlog=0,yrange=yrange,ystyle=1,ylog=0,xtitle=xtitle,ytitle=ytitle,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    xthick=axis_chatthick,ythick=axis_chatthick,charsize=axislegend_charsize,charthick=axislegend_charthick,background=color_white,/nodata,/NoErase
  ;;--
  oplot,xplot_vect,yplot_vect,color=color_black,thick=plot_charthick*1.0
  ;----------------------------------------------------------------------------------
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
end