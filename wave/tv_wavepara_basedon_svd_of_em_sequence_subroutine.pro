Pro TV_WavePara_BasedOn_SVD_of_EM_sequence_subroutine, $ ;all variables are input
	JulDay_vect_wavelet, period_vect, $
	PlanarityPolarization_arr=PlanPolar_arr, $
	EplipticPolarization_arr=ElipPolar_arr, $
	SensePolarization_arr=SensePolar_arr, $
	SensePolar_E_arr=SensePolar_E_arr, $
	DegreePolarization_arr=DegreePolar_arr, $
	Vphase_arr=Vphase_arr, $	;in the frame of plasma bulk flow
	theta_k_db_arr=theta_k_db_arr, $
	theta_k_b0_arr=theta_k_b0_arr, $
	theta_db_b0_arr=theta_db_b0_arr, $
	AbsVphase_arr=AbsVphase_arr, $
	theta_Vph_b0_arr=theta_Vph_b0_arr, $
	JulDay_range_plot=JulDay_range_plot,$
	dir_fig=dir_fig, file_fig=file_fig, is_png_eps=is_png_eps, calling_program=calling_program


Step1:
;===================
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
daterange_str_TV= '('+String(year_beg,format='(I4)')+String(mon_beg,format='(I2)')+String(day_beg,format='(I2)')+')'


PlanarityPolar_arr_TV = PlanPolar_arr[sub_beg_TV:sub_end_TV,*]
ElipPolar_arr_TV = ElipPolar_arr[sub_beg_TV:sub_end_TV,*]
SensePolar_arr_TV = SensePolar_arr[sub_beg_TV:sub_end_TV,*]
SensePolar_E_arr_TV = SensePolar_E_arr[sub_beg_TV:sub_end_TV,*]
DegreePolar_arr_TV = DegreePolar_arr[sub_beg_TV:sub_end_TV,*]
;Vphase_arr_TV = Vphase_arr[sub_beg_TV:sub_end_TV,*]
theta_k_db_arr_TV = theta_k_db_arr[sub_beg_TV:sub_end_TV,*]
theta_k_b0_arr_TV = theta_k_b0_arr[sub_beg_TV:sub_end_TV,*]
theta_db_b0_arr_TV = theta_db_b0_arr[sub_beg_TV:sub_end_TV,*]
AbsVphase_arr_TV = AbsVphase_arr[sub_beg_TV:sub_end_TV,*]
theta_Vph_b0_arr_TV = theta_Vph_b0_arr[sub_beg_TV:sub_end_TV,*]

;;--
Caldat, JulDay_vect_TV[0], mon_plot, day_plot, year_plot, hour_plot, min_plot, sec_plot
year_str = String(year_plot, format='(I04)')
mon_str = String(mon_plot, format='(I02)')
day_str = String(day_plot, format='(I02)')
; theta_k_b0_arr = 90.0 - Abs(theta_k_b0_arr-90)

;;--
If is_png_eps eq 1 Then Begin
  file_version  = '.png'
EndIf Else Begin
  file_version  = '.eps'
EndElse
FileName  = dir_fig + file_fig + file_version


;;--
If is_png_eps eq 2 Then Begin
  Set_Plot,'PS'
  xsize = 20.0
  ysize = 20.0
  Device, FileName=FileName, XSize=xsize,YSize=ysize,/Color,Bits=8,/Encapsul
EndIf Else Begin
If is_png_eps eq 1 Then Begin
  Set_Plot,'WIN'
  Device,DeComposed=0;, /Retain
  xsize=1000.0 & ysize=1200.0
  Window,2,XSize=xsize,YSize=ysize,Retain=2,/pixmap
EndIf
EndElse


LoadCT,33
TVLCT,R,G,B,/Get

;n_colors	= 256
;EggPlant, R, G, B, n_colors

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

color_bg    = color_white
!p.background = color_bg
Plot,[0,1],[0,1],XStyle=1+4,YStyle=1+4,/NoData  ;change the background

;a !P.Multi=[0,1,4]

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
charsize  = 1.1
EndIf

is_contour_or_TV = 1

;;--
position_img  = [0.05,0.10,0.95,0.95]
num_subimgs_x = 1
num_subimgs_y = 7
panel_str_arr	= StrArr(num_subimgs_y)
panel_str_arr	= ['a','b','c','d','e','f','g']
panel_str_arr = Reverse(panel_str_arr)
dx_subimg   = (position_img(2)-position_img[0])/num_subimgs_x
dy_subimg   = (position_img(3)-position_img[1])/num_subimgs_y

;;--
title_SensePolar = ' '
title_ElipPolar = ' '
title_PlanPolar = ' '
title_SensePolar_E = ' '
title_theta_kB = ' '
title_theta_dBB0 = ' '
title_theta_VphB0 = ' '
title_Vph = ' '

i_subimg_x  = 0
For i_subimg_y=0,num_subimgs_y-1 Do Begin
win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
        position_img[1]+dy_subimg*i_subimg_y+0.05*dy_subimg,$
        position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
        position_img[1]+dy_subimg*i_subimg_y+0.95*dy_subimg]
position_subimg   = win_position
position_subplot  = position_subimg

If i_subimg_y eq 7-1 Then Begin
  xplot_vect = JulDay_vect_TV
  yplot_vect = period_vect
  image_TV = SensePolar_arr_TV
  xtitle = ' '
  ytitle = 'period (s)'
  title = TexToIDL('Sense of Polarization for dB (about B_0 in SC frame)' )
  title_SensePolar = title  
  xrange = [Min(xplot_vect), Max(xplot_vect)]
  lg_yplot_vect = Alog10(yplot_vect)
  lg_yrange = [Min(lg_yplot_vect-0.5*(lg_yplot_vect[1]-lg_yplot_vect[0])), Max(lg_yplot_vect+0.5*(lg_yplot_vect[1]-lg_yplot_vect[0]))]
  yrange = 10.^lg_yrange
EndIf
If i_subimg_y eq 7-2 Then Begin
  xplot_vect = JulDay_vect_TV
  yplot_vect = period_vect
  image_TV = ElipPolar_arr_TV
  xtitle = ' '
  ytitle = 'period (s)'  
  title = TexToIDL('Elipticity of Polarization')  
  title_ElipPolar = title
  xrange = [Min(xplot_vect), Max(xplot_vect)]
  lg_yplot_vect = Alog10(yplot_vect)
  lg_yrange = [Min(lg_yplot_vect-0.5*(lg_yplot_vect[1]-lg_yplot_vect[0])), Max(lg_yplot_vect+0.5*(lg_yplot_vect[1]-lg_yplot_vect[0]))]
  yrange = 10.^lg_yrange
EndIf
If i_subimg_y eq 7-3 Then Begin
  xplot_vect = JulDay_vect_TV
  yplot_vect = period_vect
  image_TV = SensePolar_E_arr_TV
  xtitle = ' '
  ytitle = 'period (s)'  
  title = TexToIDL('Sense of Polarization for dE (about B_0)(PL frame)')  
;a  title_PlanPolar = title
  title_SensePolar_E=title
  xrange = [Min(xplot_vect), Max(xplot_vect)]
  lg_yplot_vect = Alog10(yplot_vect)
  lg_yrange = [Min(lg_yplot_vect-0.5*(lg_yplot_vect[1]-lg_yplot_vect[0])), Max(lg_yplot_vect+0.5*(lg_yplot_vect[1]-lg_yplot_vect[0]))]
  yrange = 10.^lg_yrange
EndIf
If i_subimg_y eq 7-4 Then Begin
  xplot_vect = JulDay_vect_TV
  yplot_vect = period_vect
  image_TV = theta_k_b0_arr_TV
  xtitle = ' '
  ytitle = 'period (s)'  
  title = TexToIDL('\theta_{k,B0}')  
  title_theta_KB = title
  xrange = [Min(xplot_vect), Max(xplot_vect)]
  lg_yplot_vect = Alog10(yplot_vect)
  lg_yrange = [Min(lg_yplot_vect-0.5*(lg_yplot_vect[1]-lg_yplot_vect[0])), Max(lg_yplot_vect+0.5*(lg_yplot_vect[1]-lg_yplot_vect[0]))]
  yrange = 10.^lg_yrange
EndIf
If i_subimg_y eq 7-5 Then Begin
  xplot_vect = JulDay_vect_TV
  yplot_vect = period_vect
  image_TV = theta_db_b0_arr_TV
  xtitle = ' '
  ytitle = 'period (s)'  
  title = TexToIDL('\theta_{dB,B0}')  
  title_theta_dBB0 = title
  xrange = [Min(xplot_vect), Max(xplot_vect)]
  lg_yplot_vect = Alog10(yplot_vect)
  lg_yrange = [Min(lg_yplot_vect-0.5*(lg_yplot_vect[1]-lg_yplot_vect[0])), Max(lg_yplot_vect+0.5*(lg_yplot_vect[1]-lg_yplot_vect[0]))]
  yrange = 10.^lg_yrange
EndIf

If i_subimg_y eq 7-6 Then Begin
  xplot_vect = JulDay_vect_TV
  yplot_vect = period_vect
  image_TV = AbsVphase_arr_TV
  xtitle = ' '
  ytitle = 'period (s)'  
  title = TexToIDL('|V_{ph}|')  
  title_Vph = title
  xrange = [Min(xplot_vect), Max(xplot_vect)]
  lg_yplot_vect = Alog10(yplot_vect)
  lg_yrange = [Min(lg_yplot_vect-0.5*(lg_yplot_vect[1]-lg_yplot_vect[0])), Max(lg_yplot_vect+0.5*(lg_yplot_vect[1]-lg_yplot_vect[0]))]
  yrange = 10.^lg_yrange  
EndIf
If i_subimg_y eq 7-7 Then Begin
  xplot_vect = JulDay_vect_TV
  yplot_vect = period_vect
  image_TV = theta_Vph_b0_arr_TV
  xtitle = year_str+'/'+mon_str+'/'+day_str
  ytitle = 'period (s)'  
  title = TexToIDL('\theta_{Vph,B0}')  
  title_theta_VphB0 = title
  xrange = [Min(xplot_vect), Max(xplot_vect)]
  lg_yplot_vect = Alog10(yplot_vect)
  lg_yrange = [Min(lg_yplot_vect-0.5*(lg_yplot_vect[1]-lg_yplot_vect[0])), Max(lg_yplot_vect+0.5*(lg_yplot_vect[1]-lg_yplot_vect[0]))]
  yrange = 10.^lg_yrange  
EndIf

;;--
xrange_time = xrange
get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
xtickv    = xtickv_time
xticks    = N_Elements(xtickv)-1
xticknames  = xticknames_time
If (i_subimg_y ne 0) Then Begin
  xticknames  = Replicate(' ',N_Elements(xtickv))
EndIf  
xminor  = xminor_time
;xminor    = 6

;;;---
xpos_tmp  = position_subplot[0]-0.06 ; -0.02
ypos_tmp  = position_SubPlot(3)-0.02
xyouts_str= Panel_str_arr(i_subimg_y)
XYOuts, xpos_tmp,ypos_tmp, xyouts_str, Color=color_black,CharSize=charsize*1.1,CharThick=charthick*2.0,/Normal


;;;---
remainder = 1 ;(i_subimg_y+1) mod 2

If (remainder eq 1) Then Begin

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

If StrCmp(title, title_SensePolar) eq 1 Then Begin
  min_image=-1.0 & max_image=+1.0 ;-1 for left-polar, +1 for right-polar
EndIf
If StrCmp(title, title_ElipPolar) eq 1 Then Begin
  min_image=0.0 & max_image=1.0 ;1 for circular, 0 for linear
EndIf
If StrCmp(title, title_SensePolar_E) eq 1 Then Begin
  min_image=-1.0 & max_image=1.0 ;1 for planarity, 0 for sphere
EndIf
If StrCmp(title, title_theta_KB) eq 1 Then Begin
  min_image=0. & max_image=+90
EndIf  
If StrCmp(title, title_theta_dBB0) eq 1 Then Begin
  min_image=0. & max_image=+90
EndIf
If StrCmp(title, title_theta_VphB0) eq 1 Then Begin
  min_image=0. & max_image=+180
EndIf
If StrCmp(title, title_theta_VphB0) eq 1 Then Begin
  min_image=min_image & max_image=max_image
EndIf
If StrCmp(title, title_Vph) eq 1 Then Begin
  max_image=600
EndIf

byt_image_TV= BytSCL(image_TV,min=min_image,max=max_image, Top=num_CB_color-1)
byt_image_TV= byt_image_TV+(256-num_CB_color)
color_BadVal= color_white
If sub_BadVal[0] ne -1 Then $
byt_image_TV(sub_BadVal)  = color_BadVal

If is_contour_or_TV eq 1 Then Begin
num_levels  = 15
levels_vect = Byte(Findgen(num_levels)*Float(num_CB_color-1)/(num_levels-1))
level_val_vect= min_image + Float(levels_vect)/(num_CB_color-1)*(max_image-min_image)
levels_vect   = [color_BadVal, levels_vect+(256-num_CB_color)]
color_vect    = levels_vect
contour_arr = byt_image_TV
;;;---congrid to reduce the size of the figure
num_times  = N_Elements(xplot_vect)
num_periods = N_Elements(yplot_vect)
xplot_vect_v2 = Congrid(xplot_vect, num_times, /Interp)
contour_arr_v2 = Congrid(contour_arr, num_times, num_periods, /Interp)
;;;;;-----
Contour, contour_arr_v2, xplot_vect_v2, yplot_vect, $
  XRange=xrange, YRange=yrange, Position=position_SubPlot, XStyle=1+4, YStyle=1+4, $
  /Cell_Fill, /NoErase, YLog=1, $
  Levels=levels_vect, C_Colors=color_vect, NoClip=0;, /OverPlot
EndIf Else Begin
TVImage, byt_image_TV,Position=position_SubPlot, NOINTERPOLATION=1
EndElse

Plot, xrange, yrange, XRange=xrange, YRange=yrange, XStyle=1, YStyle=1, $
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,$;XTickLen=-0.04,$
    XThick=xthick,YThick=ythick,CharSize=charsize,CharThick=charthick,Thick=thick, $
    Position=position_subimg, XTitle=xtitle, YTitle=ytitle, /NoData, /NoErase, Color=color_black, $
    XTickLen=-0.04,YTickLen=-0.02, YLog=1

;;;---
xyouts_str_v1 = title
position_bar  = [position_SubImg[0]+0.002, position_SubImg[1]+0.002, $
                      position_SubImg[0]+0.002+0.22*(position_SubImg(2)-position_SubImg[0]), $
                      position_SubImg[1]+0.002+0.2*(position_SubImg(3)-position_SubImg[1])]
image_bar = (Bytarr(20)+1B)##(Bytarr(num_CB_color)+color_white)
TVImage,  image_bar, position=position_bar, NoInterpolation=1
xpos_xyouts = position_bar[0]+(position_bar(2)-position_bar[0])/2
ypos_xyouts = position_bar[1]+(position_bar(3)-position_bar[1])/3
XYOuts, xpos_xyouts, ypos_xyouts, xyouts_str_v1, /Normal, Alignment=0.5, Orientation=0, CharSize=charsize,Charthick=charthick,col=color_black

;;;---
If (i_subimg_y ne -1) Then Begin
position_CB   = [position_SubImg(2)+0.05,position_SubImg[1],$
                  position_SubImg(2)+0.06,position_SubImg(3)]
num_ticks   = 3
num_divisions = num_ticks-1
max_tickn   = max_image
min_tickn   = min_image
interv_ints = (max_tickn-min_tickn)/(num_ticks-1)
tickn_CB    = String((Findgen(num_ticks)*interv_ints+min_tickn),format='(F8.1)');the tick-names of colorbar 15
titleCB     = ' ';title
bottom_color  = 256-num_CB_color  ;0B
img_colorbar  = (Bytarr(20)+1B)#(Bindgen(num_CB_color)+bottom_color)
TVImage, img_colorbar,Position=position_CB, NOINTERPOLATION=1
;;;;----draw the outline of the color-bar
Plot,[min_image,max_image],[1,2],Position=position_CB,XStyle=1,YStyle=1,$
  XTicks=1,XTickName=[' ',' '],YTicks=num_ticks-1,YTickName=tickn_CB,Font=-1,$
  /NoData,/NoErase,Color=color_black, $
  TickLen=0.02,Title=' ',YTitle=titleCB, $
  XThick=xthick,YThick=ythick,CharSize=charsize,CharThick=charthick,Thick=thick
EndIf


EndIf ;If (remainder eq 1) Then Begin


EndFor ;For i_subimg_y=0,num_subimgs_y-1 Do Begin



;;--
AnnotStr_tmp  = 'got from "TV_WavePara_BasedOn_SVD_of_EM_sequence_subroutine.pro"'
AnnotStr_arr  = [AnnotStr_tmp]
AnnotStr_tmp  = 'calling program: '+calling_program
AnnotStr_arr  = [AnnotStr_arr, AnnotStr_tmp]
AnnotStr_tmp  = FileName
AnnotStr_arr  = [AnnotStr_arr, AnnotStr_tmp]
num_strings     = N_Elements(AnnotStr_arr)
For i_str=0,num_strings-1 Do Begin
  position_v1   = [position_img[0],position_img[1]/(num_strings+4)*(i_str+1)]
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

Return
End_Program:
End