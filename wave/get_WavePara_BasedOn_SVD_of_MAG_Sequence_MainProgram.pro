;Pro get_WavePara_BasedOn_SVD_of_MAG_Sequence_MainProgram
mag_suite_str = 'fld'
mag_level_str = 'l2'
mag_payload_str = 'mag'
mag_coord_str = 'rtn'
mag_cadence_str = '';'_1min'; '', '_1min'
;;--
ymd_str = '20200526'
year_str = StrMid(ymd_str,0,4)
mon_str  = StrMid(ymd_str,4,2)
day_str  = StrMid(ymd_str,6,2)
;;--
is_timerange_automatic_for_cal = 0
is_timerange_automatic_for_plot = 0
If is_timerange_automatic_for_cal eq 0 Then Begin
  If StrCmp(ymd_str, '20200526') eq 1 Then Begin
    hms_beg_cal_str = '17:00:00'
    hms_end_cal_str = '21:00:00'
  Endif
Endif
If is_timerange_automatic_for_plot eq 0 Then Begin
  If StrCmp(ymd_str, '20200131') eq 1 Then Begin
    hms_beg_plot_str = '18:20:00'
    hms_end_plot_str = '20:10:00'
  Endif
Endif
;;--
PSP_Data_Dir = 'C:\STUDY\PSP\Encounter 5\RESULT\SaveData\'
PSP_Figure_Dir = 'C:\STUDY\PSP\Encounter 5\RESULT\Figures\'

;goto,Step5
Step1:
;=====================
;Step1:
dir_data = PSP_Data_Dir
;;--
TimeRange_Restore_Str = '(time=??????-??????)'
file_restore  = 'Bxyz_RTN_arr'+$
  '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
  '('+year_str+mon_str+day_str+')'+$
  TimeRange_Restore_Str+$
  '.sav'
file_array  = File_Search(dir_data+file_restore, count=num_files)
For i_file=0,num_files-1 Do Begin
  Print, 'i_file, file: ', i_file, ': ', file_array(i_file)
EndFor
i_select  = 0
Read, 'i_select: ', i_select
file_restore  = file_array[i_select]
file_restore  = StrMid(file_restore, StrLen(dir_data), StrLen(file_restore)-StrLen(dir_data))
;;;---
Restore, dir_data+file_restore, /verbose
;data_descrip  = 'got from "Read_PSP_MAG_L2_CDF.pro"'
;Save, FileName=dir_save+file_save, $
;  data_descrip, $
;  TimeRange_str, $
;  JulDay_vect_save, Bx_RTN_vect_save, By_RTN_vect_save, Bz_RTN_vect_save, $
;  JulDay_vect_interp, Bx_RTN_vect_interp, By_RTN_vect_interp, Bz_RTN_vect_interp, $
;  sub_beg_BadBins_vect, sub_end_BadBins_vect, $
;  num_DataGaps, JulDay_beg_DataGap_vect, JulDay_end_DataGap_vect
JulDay_vect_mag = JulDay_vect_interp
Bx_RTN_vect = Bx_RTN_vect_interp
By_RTN_vect = By_RTN_vect_interp
Bz_RTN_vect = Bz_RTN_vect_interp


Step2:
;=====================
;Step2
;;--use default time range or reset another small time interval to calculate wavelet and local background
;;--smaller interval is suggested for large size of burst data set (e.g., > 100 MB for x&E&B...sav and J&divB...sav)
Print, 'use default time range or reset another small time interval to calculate wavelet and local background'
Print, 'smaller interval is suggested for large size of burst data set (e.g., > 100 MB for x&E&B...sav and J&divB...sav)'
Print, 'is_timerange_automatic_for_cal (0 for defined by user, 1 for automatically inherited from original data): '
Print, is_timerange_automatic_for_cal
is_continue = ' '
Read, 'is_continue: ', is_continue
If is_timerange_automatic_for_cal eq 0 Then Begin
  hh_beg_cal_str = StrMid(hms_beg_cal_str,0,2) & mm_beg_cal_str = StrMid(hms_beg_cal_str,3,2) & ss_beg_cal_str = StrMid(hms_beg_cal_str,6,2)
  hh_end_cal_str = StrMid(hms_end_cal_str,0,2) & mm_end_cal_str = StrMid(hms_end_cal_str,3,2) & ss_end_cal_str = StrMid(hms_end_cal_str,6,2)
  year_beg_cal=Float(year_str) & mon_beg_cal=Float(mon_str) & day_beg_cal=Float(day_str)
  year_end_cal=Float(year_str) & mon_end_cal=Float(mon_str) & day_end_cal=Float(day_str)
  hour_beg_cal=Float(hh_beg_cal_str) & min_beg_cal=Float(mm_beg_cal_str) & sec_beg_cal=Float(ss_beg_cal_str)
  hour_end_cal=Float(hh_end_cal_str) & min_end_cal=Float(mm_end_cal_str) & sec_end_cal=Float(ss_end_cal_str)
  JulDay_beg_cal = JulDay(mon_beg_cal,day_beg_cal,year_beg_cal, hour_beg_cal,min_beg_cal,sec_beg_cal)
  JulDay_end_cal = JulDay(mon_end_cal,day_end_cal,year_end_cal, hour_end_cal,min_end_cal,sec_end_cal)
EndIf Else Begin
  If is_timerange_automatic_for_cal eq 1 Then Begin
    JulDay_beg_cal = Min(JulDay_vect_mag)
    JulDay_end_cal = Max(JulDay_vect_mag)
    CalDat, JulDay_beg_cal, mon_beg_cal, day_beg_cal, year_beg_cal, hour_beg_cal, min_beg_cal, sec_beg_cal
    CalDat, JulDay_end_cal, mon_end_cal, day_end_cal, year_end_cal, hour_end_cal, min_end_cal, sec_end_cal
  EndIf
EndElse
TimeRange_cal_str  = '(time='+$
  String(hour_beg_cal,format='(I2.2)')+String(min_beg_cal,format='(I2.2)')+String(sec_beg_cal,format='(I2.2)')+'-'+$
  String(hour_end_cal,format='(I2.2)')+String(min_end_cal,format='(I2.2)')+String(sec_end_cal,format='(I2.2)')+')'

;;--
sub_tmp = Where(JulDay_vect_mag ge JulDay_beg_cal and JulDay_vect_mag le JulDay_end_cal)
JulDay_vect_cal  = JulDay_vect_mag[sub_tmp]
Bx_RTN_vect_cal  = Bx_RTN_vect[sub_tmp]
By_RTN_vect_cal  = By_RTN_vect[sub_tmp]
Bz_RTN_vect_cal  = Bz_RTN_vect[sub_tmp]


Step3:
;=====================
;Step3:
;;--
time_vect = (JulDay_vect_cal - JulDay_vect_cal[0])*(24.*60*60)
dtime     = time_vect[1] - time_vect[0]
time_interval = Max(time_vect) - Min(time_vect)
period_min= dtime*3
period_max= time_interval/7
period_range  = [period_min, period_max]
period_range  = [0.2, 10]
num_periods = 16L
num_times   = N_Elements(time_vect)

;;--
For i=0,2 Do Begin
  If i eq 0 Then wave_vect = Bx_RTN_vect_cal
  If i eq 1 Then wave_vect = By_RTN_vect_cal
  If i eq 2 Then wave_vect = Bz_RTN_vect_cal
  get_Wavelet_Transform_of_BComp_vect_STEREO_v3, $
    time_vect, wave_vect, $    ;input
    period_range=period_range, $  ;input
    num_periods=num_periods, $
    Wavlet_arr, $       ;output
    time_vect_v2=time_vect_v2, $
    period_vect=period_vect
  PSD_arr  = Abs(wavlet_arr)^2 * dtime
  If i eq 0 Then Begin
    wavlet_Bx_arr=wavlet_arr & PSD_Bx_arr=PSD_arr
  EndIf
  If i eq 1 Then Begin
    wavlet_By_arr=wavlet_arr & PSD_By_arr=PSD_arr
  EndIf
  If i eq 2 Then Begin
    wavlet_Bz_arr=wavlet_arr & PSD_Bz_arr=PSD_arr
  EndIf

EndFor


;;--
Bxyz_RTN_arr_cal = [[Bx_RTN_vect_cal],[By_RTN_vect_cal],[Bz_RTN_vect_cal]]
Bxyz_RTN_arr_cal = Transpose(Bxyz_RTN_arr_cal)
is_convol_smooth = 2
get_LocalBG_of_MagField_at_Scales_WIND_MFI, $
  time_vect, Bxyz_RTN_arr_cal, $  ;input
  period_range=period_range, $  ;input
  num_periods=num_periods, $ ;input
  is_convol_smooth=is_convol_smooth, $ ;input
  Bxyz_LBG_RTN_arr, $   ;output
  time_vect_v2=time_vect_v2, $  ;output
  period_vect=period_vect     ;output



Step4:
;=====================
;Step4

;;--
get_WavePara_BasedOn_SVD_of_MagF_Sequence, $
  wavlet_Bx_arr, wavlet_By_arr, wavlet_Bz_arr, $
  time_vect, period_vect, $
  Bxyz_LBG_RTN_arr, $
  EigVal_arr, EigVect_arr, $
  PlanarityPolarization_arr=PlanPolar_arr, $
  EplipticPolarization_arr=ElipPolar_arr, $
  SensePolarization_arr=SensePolar_arr, $
  DegreePolarization_arr=DegreePolar_arr



Step4_2:
;=====================
;Step4_2

;;--
i_eigenval_min  = 0
i_eigenval_mid  = 1
i_eigenval_max  = 2


;;--
theta_k_db_arr  = Fltarr(num_times,num_periods)
theta_k_b0_arr  = Fltarr(num_times,num_periods)
theta_db_b0_arr = Fltarr(num_times,num_periods)

;For i_theta=0,4-1 Do Begin
For i_time=0L,num_times-1 Do Begin
  For i_scale=0,num_periods-1 Do Begin
    k_db_vect = Reform(EigVect_arr[*,i_eigenval_min,i_time,i_scale])  ;k_Zp
    e_db_vect = Reform(EigVect_arr[*,i_eigenval_max,i_time,i_scale])  ;e_Zp
    b0_vect   = Reform(Bxyz_LBG_RTN_arr[*,i_time,i_scale])
    k_db_vect = k_db_vect/Norm(k_db_vect)
    e_db_vect = e_db_vect/Norm(e_db_vect)
    b0_vect   = b0_vect/Norm(b0_vect)

    theta_k_db_arr[i_time,i_scale] = ACos(Abs(k_db_vect ## Transpose(e_db_vect))) * 180/!pi  ;angle between k_Zp with e_Zm
    theta_k_b0_arr[i_time,i_scale] = ACos(Abs(k_db_vect ## Transpose(b0_vect))) * 180/!pi
    theta_db_b0_arr[i_time,i_scale] = ACos(Abs(e_db_vect ## Transpose(b0_vect))) * 180/!pi

  EndFor
EndFor


Step5:
;=====================
;Step5
is_png_eps = 1
is_contour_or_TV = 1
FileName = 'WavePara_of_MAG(from SVD)'+$
  TimeRange_cal_str+$
  '('+year_str+mon_str+day_str+')'
;;--
If is_png_eps eq 1 Then Begin
  file_version  = '.png'
EndIf Else Begin
  file_version  = '.eps'
EndElse
If is_contour_or_TV eq 1 Then Begin
  fig_note_str='(contour)'
EndIf Else Begin
  fig_note_str  = '(TV)'
EndElse
FileName_v2  = FileName+fig_note_str+file_version
FileName_v2  = PSP_Figure_Dir + FileName_v2
perp_symbol_oct = "170 ;"
perp_symbol_str = String(Byte(perp_symbol_oct))
perp_symbol_str = '{!9' + perp_symbol_str + '!X}'
;;--
If is_png_eps eq 2 Then Begin
  Set_Plot,'PS'
  xsize = 28.0
  ysize = 24.0
  Device, FileName=FileName_v2, XSize=xsize,YSize=ysize,/Color,Bits=8,/Encapsul
EndIf Else Begin
  If is_png_eps eq 1 Then Begin
    Set_Plot,'WIN'
    Device,DeComposed=0;, /Retain
    xsize=1300.0 & ysize=800.0
    Window,2,XSize=xsize,YSize=ysize,Retain=2,/pixmap
  EndIf
EndElse

;;--
;LoadCT,13
;TVLCT,R,G,B,/Get
;Restore, '/Work/Data Analysis/Programs/RainBow(reset).sav', /Verbose
n_colors  = 256
RainBow_Matlab, R,G,B, n_colors
color_red = 0L
TVLCT,255L,0L,0L,color_red
R_red=255L & G_red=0L & B_red=0L
color_green = 1L
TVLCT,0L,255L,0L,color_green
R_green=0L & G_green=255L & B_green=0L
color_blue  = 2L
TVLCT,0L,0L,255L,color_blue
R_blue=0L & G_blue=0L & B_blue=255L
color_white = 4L
TVLCT,255L,255L,255L,color_white
R_white=255L & G_white=255L & B_white=255L
color_black = 3L
TVLCT,0L,0L,0L,color_black
R_black=0L & G_black=0L & B_black=0L
num_CB_color= 256-5
R=Congrid(R,num_CB_color)
G=Congrid(G,num_CB_color)
B=Congrid(B,num_CB_color)
TVLCT,R,G,B
R = [R_red,R_green,R_blue,R_black,R_white,R]
G = [G_red,G_green,G_blue,G_black,G_white,G]
B = [B_red,B_green,B_blue,B_black,B_white,B]
TVLCT,R,G,B

;;--
color_bg    = color_white
!p.background = color_bg
Plot,[0,1],[0,1],XStyle=1+4,YStyle=1+4,/NoData  ;change the background

;;--
position_img  = [0.02,0.03,0.96,0.98]

;;--
num_subimgs_x = 2
num_subimgs_y = 3
dx_subimg   = (position_img(2)-position_img[0])/num_subimgs_x
dy_subimg   = (position_img(3)-position_img[1])/num_subimgs_y

;;--
x_margin_left = 0.10
x_margin_right= 0.90
y_margin_bot  = 0.10
y_margin_top  = 0.88

is_contour_or_TV  = 1


;;--
For i_subimg_x=0,1 Do Begin
  For i_subimg_y=0,2 Do Begin
    If (i_subimg_x eq 0 and i_subimg_y eq 2) Then Begin ;kx for Zp with min eigen-value
      image_TV  = theta_k_b0_arr
      title = TexToIDL('\theta_{k,b0}')
    EndIf
    If (i_subimg_x eq 1 and i_subimg_y eq 2) Then Begin ;ky for Zp with min eigen-value
      image_TV  = theta_db_b0_arr
      title = TexToIDL('\theta_{db,b0}')
    EndIf
    If (i_subimg_x eq 0 and i_subimg_y eq 1) Then Begin ;kz for Zp with min eigen-value
      image_TV  = SensePolar_arr
      title = TexToIDL('2\timesIm{(\deltaB_x\deltaB_y^*)/(\deltaB_x^2+\deltaB_y^2)}')
    EndIf
    If (i_subimg_x eq 1 and i_subimg_y eq 1) Then Begin ;ky for Zp with min eigen-value
      image_TV  = ElipPolar_arr
      title = TexToIDL('\lambda_{mid}/\lambda_{max}')
    EndIf
    If (i_subimg_x eq 0 and i_subimg_y eq 0) Then Begin ;theta_kp_zm
      image_TV  = PlanPolar_arr
      title = TexToIDL('1-Sqrt(\lambda_{min}/\lambda_{max})')
    EndIf
    If (i_subimg_x eq 1 and i_subimg_y eq 0) Then Begin ;theta_kp_b0
      image_TV  = DegreePolar_arr
      title = TexToIDL('\lambda_{max}/(\lambda_{min}+\lambda_{mid}+\lambda_{max})')
    EndIf


    ;;--
    xplot_vect  = JulDay_vect_cal
    yplot_vect  = period_vect
    xrange  = [Min(xplot_vect)-0.5*(xplot_vect[1]-xplot_vect[0]), Max(xplot_vect)+0.5*(xplot_vect[1]-xplot_vect[0])]
    xrange_time = xrange
    get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
    xtickv    = xtickv_time
    xticks    = N_Elements(xtickv)-1
    xticknames  = xticknames_time
    xminor  = xminor_time
    ;xminor    = 6
    lg_yplot_vect = ALog10(yplot_vect)
    yrange    = 10^[Min(lg_yplot_vect)-0.5*(lg_yplot_vect[1]-lg_yplot_vect[0]),$
      Max(lg_yplot_vect)+0.5*(lg_yplot_vect[1]-lg_yplot_vect[0])]
    xtitle    = ' '
    If (i_subimg_x eq 0) Then Begin
      ytitle  = 'period [s]'
    EndIf Else Begin
      ytitle  = ' '
    EndElse

    image_TV  = Rebin(image_TV,(Size(image_TV))[1],(Size(image_TV))[2]*1, /Sample)
    yplot_vect= 10^Congrid(ALog10(yplot_vect), N_Elements(yplot_vect)*1, /Minus_One)

    ;;--
    win_position= [position_img[0]+dx_subimg*i_subimg_x+x_margin_left*dx_subimg,$
      position_img[1]+dy_subimg*i_subimg_y+y_margin_bot*dy_subimg,$
      position_img[0]+dx_subimg*i_subimg_x+x_margin_right*dx_subimg,$
      position_img[1]+dy_subimg*i_subimg_y+y_margin_top*dy_subimg]
    position_subplot  = win_position
    position_SubImg   = position_SubPlot

    ;;;---
    sub_BadVal  = Where(Finite(image_TV) eq 0)
    If sub_BadVal[0] ne -1 Then Begin
      num_BadVal  = N_Elements(sub_BadVal)
      image_TV(sub_BadVal)  = -9999.0
    EndIf Else Begin
      num_BadVal  = 0
    EndElse
    image_TV_v2 = image_TV(Sort(image_TV))
    min_image = image_TV_v2(Long(0.01*(N_Elements(image_TV)))+num_BadVal)
    max_image = image_TV_v2(Long(0.99*(N_Elements(image_TV))))
    byt_image_TV= BytSCL(image_TV,min=min_image,max=max_image, Top=num_CB_color-1)
    byt_image_TV= byt_image_TV+(256-num_CB_color)
    color_BadVal= color_white
    If sub_BadVal[0] ne -1 Then $
      byt_image_TV(sub_BadVal)  = color_BadVal

    If is_contour_or_TV eq 1 Then Begin
      num_levels  = 150
      levels_vect = Byte(Findgen(num_levels)*Float(num_CB_color-1)/(num_levels-1))
      level_val_vect= min_image + Float(levels_vect)/(num_CB_color-1)*(max_image-min_image)
      levels_vect   = [color_BadVal, levels_vect+(256-num_CB_color)]
      color_vect    = levels_vect
      contour_arr = byt_image_TV
      ;;;---congrid to reduce the size of the figure
      num_times  = N_Elements(xplot_vect)
      num_periods = N_Elements(yplot_vect)
      xplot_vect_v2 = Congrid(xplot_vect, num_times/60, /Interp)
      contour_arr_v2 = Congrid(contour_arr, num_times/60, num_periods, /Interp)
      ;;;---
      Contour, contour_arr_v2, xplot_vect_v2, yplot_vect, $
        XRange=xrange, YRange=yrange, Position=position_SubPlot, XStyle=1+4, YStyle=1+4, $
        /Cell_Fill, /NoErase, YLog=1, $
        Levels=levels_vect, C_Colors=color_vect, NoClip=0;, /OverPlot
    EndIf Else Begin
      TVImage, byt_image_TV,Position=position_SubPlot, NOINTERPOLATION=1
    EndElse

    Plot, xrange, yrange, XRange=xrange, YRange=yrange, XStyle=1+4, YStyle=1+4, CharSize=1.2, $
      Position=position_subimg, XTitle=' ', YTitle=' ', /NoData, /NoErase, Color=color_black, $
      XTickLen=-0.02,YTickLen=-0.02, YLog=1

    If is_contour_or_TV eq 3 Then Begin
      levels_vect_v2  = levels_vect(1:N_Elements(levels_vect)-1)
      c_annotate_vect = String(level_val_vect, format='(F5.2)')
      c_linestyle_vect= Intarr(N_Elements(levels_vect_v2))
      Contour, contour_arr, xplot_vect, yplot_vect, /noerase, $
        levels=levels_vect_v2,$
        C_ANNOTATION=c_annotate_vect,$
        C_LINESTYLE=c_linestyle_vect, NoClip=0, Color=color_white, /OverPlot
    EndIf

    ;;;---
    Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
      Position=position_subplot,$
      XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
      XTitle=xtitle,YTitle=ytitle,title=title,$
      Color=color_black,$
      /NoErase,/NoData, Font=-1, YLog=1,$
      XThick=1.5,YThick=1.5,CharSize=0.8,CharThick=1.8,Thick=1.5
      
    ;;;;;----Mark the switchback interval and upstream/downstream region
    JulDay_center = JulDay(11,06,2018,12,19,47)
    SB_duration = Double(325.0) ;unit: [s]
    UP_duration = Double(105.0) ;unit: [s]
    DOWN_duration = Double(30.0) ;unit: [s]
    JulDay_SB_beg = JulDay_center - SB_duration/2.0 / (24.*60*60)
    JulDay_SB_end = JulDay_center + SB_duration/2.0 / (24.*60*60)
    JulDay_UP_beg = JulDay_center - (SB_duration/2.0+UP_duration) / (24.*60*60)
    JulDay_DOWN_end = JulDay_center + (SB_duration/2.0+DOWN_duration) / (24.*60*60)
    Plots, [JulDay_UP_beg,JulDay_UP_beg],[yrange[0],yrange[1]],Color=color_black,Thick=2.0
    Plots, [JulDay_DOWN_end,JulDay_DOWN_end],[yrange[0],yrange[1]],Color=color_black,Thick=2.0
    Plots, [JulDay_SB_beg,JulDay_SB_beg],[yrange[0],yrange[1]],Color=color_black,Thick=2.0
    Plots, [JulDay_SB_end,JulDay_SB_end],[yrange[0],yrange[1]],Color=color_black,Thick=2.0
   
    ;;;---
    position_CB   = [position_SubImg(2)+0.04,position_SubImg[1],$
      position_SubImg(2)+0.05,position_SubImg(3)]
    num_ticks   = 5
    num_divisions = num_ticks-1
    max_tickn   = max_image
    min_tickn   = min_image
    interv_ints   = (max_tickn-min_tickn)/(num_ticks-1)
    tickn_CB    = String((Findgen(num_ticks)*interv_ints+min_tickn),format='(F5.1)');the tick-names of colorbar 15
    titleCB     = title
    bottom_color  = 256-num_CB_color  ;0B
    img_colorbar  = (Bytarr(20)+1B)#(Bindgen(num_CB_color)+bottom_color)
    TVImage, img_colorbar,Position=position_CB, NOINTERPOLATION=1
    ;;;;----draw the outline of the color-bar
    Plot,[1,2],[min_image,max_image],Position=position_CB,XStyle=1,YStyle=1,$
      XTicks=1,XTickName=[' ',' '],YTicks=num_ticks-1,YTickName=tickn_CB,CharSize=0.8, Font=-1,$
      /NoData,/NoErase,Color=color_black,$
      TickLen=0.02,Title=' ',YTitle='', Thick=1.5, XThick=1.5, YThick=1.5,CharThick=1.3

  EndFor
EndFor


;;--
AnnotStr_tmp  = 'got from "get_WavePara_BasedOn_SVD_of_MAG_Sequence_MainProgram.pro"'
AnnotStr_arr  = [AnnotStr_tmp]
Annotstr_tmp  = FileName
AnnotStr_arr  = [AnnotStr_arr, AnnotStr_tmp]
num_strings     = N_Elements(AnnotStr_arr)
For i_str=0,num_strings-1 Do Begin
  position_v1   = [position_img[0],position_img[1]/(num_strings+2)*(i_str+1)]
  CharSize    = 0.8
  XYOuts,position_v1[0],position_v1[1],AnnotStr_arr(i_str),/Normal,$
    CharSize=charsize,color=color_black,Font=-1
EndFor

;;--
If is_png_eps eq 1 Then Begin
  image_tvrd  = TVRD(true=1)
  Write_PNG, FileName_v2, image_tvrd; tvrd(/true), r,g,b
EndIf Else Begin
  If is_png_eps eq 2 Then Begin
    ;;;--
    Device,/Close
  EndIf
EndElse

End