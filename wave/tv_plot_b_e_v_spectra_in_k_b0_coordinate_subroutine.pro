Pro TV_plot_B_E_V_spectra_in_k_B0_coordinate_subroutine, $
  JulDay_vect_wavelet, $
  period_vect, $
  PSD_Bpara_arr, PSD_Bperp1_arr, PSD_Bperp2_arr, $
  PSD_Epara_arr, PSD_Eperp1_arr, PSD_Eperp2_arr, $
  PSD_Vppara_arr, PSD_Vpperp1_arr, PSD_Vpperp2_arr, $
  JulDay_range_plot=JulDay_range_plot, $
  dir_fig=dir_fig, FileName=FileName, $
  is_png_eps=is_png_eps, calling_program=calling_program
 
  
Step1:
;===========================
;Step1:
;;--
sub_beg_TV = Where(JulDay_vect_wavelet ge JulDay_range_plot[0])
sub_end_TV = Where(JulDay_vect_wavelet le JulDay_range_plot[1])
sub_beg_TV = Min(sub_beg_TV)
sub_end_TV = Max(sub_end_TV)
JulDay_vect_TV = JulDay_vect_wavelet[sub_beg_TV:sub_end_TV]
CalDat, JulDay_range_plot[0], mon_beg, day_beg, year_beg, hour_beg_TV, min_beg_TV, sec_beg_TV
CalDat, JulDay_range_plot[1], mon_end, day_end, year_end, hour_end_TV, min_end_TV, sec_end_TV
timestr_beg_TV  = String(hour_beg_TV,format='(I2.2)')+String(min_beg_TV,format='(I2.2)')+String(sec_beg_TV,format='(I2.2)')
timestr_end_TV  = String(hour_end_TV,format='(I2.2)')+String(min_end_TV,format='(I2.2)')+String(sec_end_TV,format='(I2.2)')
timerange_str_TV= '(time='+timestr_beg_TV+'-'+timestr_end_TV+')'


PSD_Bpara_arr_TV = PSD_Bpara_arr[sub_beg_TV:sub_end_TV,*]
PSD_Bperp1_arr_TV = PSD_Bperp1_arr[sub_beg_TV:sub_end_TV,*]
PSD_Bperp2_arr_TV = PSD_Bperp2_arr[sub_beg_TV:sub_end_TV,*]
PSD_Epara_arr_TV = PSD_Epara_arr[sub_beg_TV:sub_end_TV,*]
PSD_Eperp1_arr_TV = PSD_Eperp1_arr[sub_beg_TV:sub_end_TV,*]
PSD_Eperp2_arr_TV = PSD_Eperp2_arr[sub_beg_TV:sub_end_TV,*]
PSD_Vppara_arr_TV = PSD_Vppara_arr[sub_beg_TV:sub_end_TV,*]
PSD_Vpperp1_arr_TV = PSD_Vpperp1_arr[sub_beg_TV:sub_end_TV,*]
PSD_Vpperp2_arr_TV = PSD_Vpperp2_arr[sub_beg_TV:sub_end_TV,*]

num_times_TV = sub_end_TV - sub_beg_TV + 1
PSD_Bpara_vect_plot = Total(PSD_Bpara_arr_TV,1,/NaN) / num_times_TV
PSD_Bperp1_vect_plot = Total(PSD_Bperp1_arr_TV,1,/NaN) / num_times_TV
PSD_Bperp2_vect_plot = Total(PSD_Bperp2_arr_TV,1,/NaN) / num_times_TV
PSD_Epara_vect_plot = Total(PSD_Epara_arr_TV,1,/NaN) / num_times_TV
PSD_Eperp1_vect_plot = Total(PSD_Eperp1_arr_TV,1,/NaN) / num_times_TV
PSD_Eperp2_vect_plot = Total(PSD_Eperp2_arr_TV,1,/NaN) / num_times_TV
PSD_Vppara_vect_plot = Total(PSD_Vppara_arr_TV,1,/NaN) / num_times_TV
PSD_Vpperp1_vect_plot = Total(PSD_Vpperp1_arr_TV,1,/NaN) / num_times_TV
PSD_Vpperp2_vect_plot = Total(PSD_Vpperp2_arr_TV,1,/NaN) / num_times_TV


Step2:
;===========================
;Step2:

;;--
If is_png_eps eq 1 Then Begin
  file_version  = '.png'
EndIf Else Begin
  file_version  = '.eps'
EndElse
fig_note_str = '(WaveletSpectra_freq)'
FileName_v3  = FileName+fig_note_str+file_version
FileName_v3  = dir_fig + FileName_v3

perp_symbol_oct = "170 ;"
perp_symbol_str = String(Byte(perp_symbol_oct))
perp_symbol_str = '{!9' + perp_symbol_str + '!X}'

;;--
If is_png_eps eq 2 Then Begin
  Set_Plot,'PS'
  xsize = 28.0
  ysize = 24.0
  Device, FileName=FileName_v3, XSize=xsize,YSize=ysize,/Color,Bits=8,/Encapsul
EndIf Else Begin
  If is_png_eps eq 1 Then Begin
    Set_Plot,'WIN'
    Device,DeComposed=0;, /Retain
    xsize=1200.0 & ysize=400.0
    Window,2,XSize=xsize,YSize=ysize,Retain=2,/pixmap
  EndIf
EndElse


;;--
LoadCT,16;4
TVLCT,R,G,B,/Get
;Restore, '/Work/Data Analysis/Programs/RainBow(reset).sav', /Verbose
;a n_colors  = 256
;a RainBow_Matlab, R,G,B, n_colors
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
color_badval = 4
;a num_CB_colors_gt0 = num_CB_color / 2
;a num_CB_colors_lt0 = num_CB_color - num_CB_colors_gt0
;a i_beg_CB_lt0 = 5
;a i_beg_CB_gt0 = i_beg_CB_lt0 + num_CB_colors_lt0


;;--
If is_png_eps eq 1 Then Begin
  color_bg    = color_white
  !p.background = color_bg
  Plot,[0,1],[0,1],XStyle=1+4,YStyle=1+4,/NoData  ;change the background
EndIf

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
  charsize  = 1.2
EndIf



Step3_2:
;===========================
;Step3_2:

;;--
position_img  = [0.05,0.05,0.95,0.95]
num_subimgs_x = 3
num_subimgs_y = 1
panel_str_arr = StrArr(num_subimgs_y)
panel_str_arr = ['a','b','c']
dx_subimg   = (position_img[2]-position_img[0])/num_subimgs_x
dy_subimg   = (position_img[3]-position_img[1])/num_subimgs_y
;;--
x_margin_left = 0.10
x_margin_right= 0.90
y_margin_bot  = 0.10
y_margin_top  = 0.90

perp_symbol_oct = "170 ;"
perp_symbol_str = String(Byte(perp_symbol_oct))
perp_symbol_str = '{!9' + perp_symbol_str + '!X}'

is_contour_or_TV  = 1

freq_vect = 1./period_vect  ;from high to low frequencies
xplot_vect= freq_vect

;;--
For i_subimg_x=0,num_subimgs_x-1 Do Begin
  For i_subimg_y=0,num_subimgs_y-1 Do Begin
    If (i_subimg_x eq 0 and i_subimg_y eq 0) Then Begin
      yplot_vect_v1  = PSD_Bpara_vect_plot
      yplot_vect_v2  = PSD_Bperp1_vect_plot
      yplot_vect_v3  = PSD_Bperp2_vect_plot
      title = TexToIDL('PSD(B)')
      ytitle = TexToIDL('PSD [(nT)^2/Hz]')
    EndIf
    If (i_subimg_x eq 1 and i_subimg_y eq 0) Then Begin
      yplot_vect_v1  = PSD_Epara_vect_plot
      yplot_vect_v2  = PSD_Eperp1_vect_plot
      yplot_vect_v3  = PSD_Eperp2_vect_plot
      title = TexToIDL('PSD(E)')
      ytitle = TexToIDL('PSD [(mV/m)^2/Hz]')
    EndIf
    If (i_subimg_x eq 2 and i_subimg_y eq 0) Then Begin
      yplot_vect_v1  = PSD_Vppara_vect_plot
      yplot_vect_v2  = PSD_Vpperp1_vect_plot
      yplot_vect_v3  = PSD_Vpperp2_vect_plot
      title = TexToIDL('PSD(Vp)')
      ytitle = TexToIDL('PSD [(km/s)^2/Hz]')
    EndIf

    ;;--
    lg_xplot_vect = Alog10(xplot_vect)
    lg_xrange = [Min(lg_xplot_vect), Max(lg_xplot_vect)]
    lg_xrange = [lg_xrange[0]-0.1*(lg_xrange[1]-lg_xrange[0]), lg_xrange[1]+0.1*(lg_xrange[1]-lg_xrange[0])]
    xrange = 10.^lg_xrange

    lg_yplot_vect_v1 = ALog10(yplot_vect_v1)
    lg_yplot_vect_v2 = ALog10(yplot_vect_v2)
    lg_yplot_vect_v3 = ALog10(yplot_vect_v3)
    lg_yrange = [Min([lg_yplot_vect_v1,lg_yplot_vect_v2,lg_yplot_vect_v3]),$
       Max([lg_yplot_vect_v1,lg_yplot_vect_v2,lg_yplot_vect_v3])]
    lg_yrange = [lg_yrange[0]-0.1*(lg_yrange[1]-lg_yrange[0]), lg_yrange[1]+0.1*(lg_yrange[1]-lg_yrange[0])]
    yrange = 10.^lg_yrange

    xtitle  = 'freq [Hz]'

    ;;--
    win_position= [position_img[0]+dx_subimg*i_subimg_x+x_margin_left*dx_subimg,$
      position_img[1]+dy_subimg*i_subimg_y+y_margin_bot*dy_subimg,$
      position_img[0]+dx_subimg*i_subimg_x+x_margin_right*dx_subimg,$
      position_img[1]+dy_subimg*i_subimg_y+y_margin_top*dy_subimg]
    position_subplot  = win_position
    position_SubImg   = position_SubPlot

    ;;--
    Plot, xplot_vect, yplot_vect_v1, XRange=xrange, YRange=yrange, Position=position_subplot, $
      XStyle=1, YStyle=1, XTitle=xtitle, YTitle=ytitle, Title=title, Color=color_black, /NoErase, $
      XLog=1, YLog=1, $
      Thick=thick, XThick=xthick, YThick=ythick, CharThick=charthick, CharSize=charsize,/NoData
    Plots, xplot_vect, yplot_vect_v1, Thick=thick, Color=color_black
    Plots, xplot_vect, yplot_vect_v2, Thick=thick, Color=color_blue
    Plots, xplot_vect, yplot_vect_v3, Thick=thick, Color=color_red
  EndFor
EndFor
xpos_tmp = position_img[2]-0.02
ypos_tmp_v1 = position_img[3]-0.05
ypos_tmp_v2 = position_img[3]-0.13
ypos_tmp_v3 = position_img[3]-0.21
XYOuts,xpos_tmp,ypos_tmp_v1,'B0',Color=color_black,Charsize=charsize,/Normal
XYOuts,xpos_tmp,ypos_tmp_v2,TexToIDL('k\timesB0'),Color=color_red,Charsize=charsize,/Normal
XYOuts,xpos_tmp,ypos_tmp_v3,TexToIDL('(k\timesB0)\timesB0'),Color=color_blue,Charsize=charsize,/Normal


;;--
AnnotStr_tmp  = 'got from "TV_plot_B_E_V_spectra_in_k_B0_coordinate_subroutine.pro"'
AnnotStr_arr  = [AnnotStr_tmp]
AnnotStr_tmp  = 'calling program: '+calling_program
AnnotStr_arr  = [AnnotStr_arr, AnnotStr_tmp]
AnnotStr_tmp  = TimeRange_str_TV
AnnotStr_arr  = [AnnotStr_arr, AnnotStr_tmp]
num_strings     = N_Elements(AnnotStr_arr)
For i_str=0,num_strings-1 Do Begin
  position_v1   = [position_img[0],position_img[1]/(num_strings+2)*(i_str+1)]
  CharSize    = 0.95
  XYOuts,position_v1[0],position_v1[1],AnnotStr_arr(i_str),/Normal,$
    CharSize=charsize,color=color_black,Font=-1
EndFor

;;--
If is_png_eps eq 1 Then Begin
  image_tvrd  = TVRD(true=1)
  Write_PNG, FileName_v3, image_tvrd; tvrd(/true), r,g,b
EndIf Else Begin
  If is_png_eps eq 2 Then Begin
    ;;;--
    Device,/Close
  EndIf
EndElse

End_Program:
Return
End