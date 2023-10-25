;Pro Calculate_electric_field_from_the_Voltage_BasedOn_PSP_MainProgram
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

is_use_spc_or_spi = 1 ; 1 for spc 2 for spi
is_use_optimazation_spc = 1
spc_v_str = is_use_optimazation_spc eq 1 ? '(optimized)':''
is_rtn_or_sc = 1 ; 1 for rtn 2 for sc
is_rtn_or_sc_str = is_rtn_or_sc eq 1 ? 'RTN':'SC'

Step1:
;===========================
;Step1:
;;--
dir_data = PSP_savData_Dir
Data_Restore_Str = '(????????)'
TimeRange_Restore_Str = '(time=??????-??????)'
If is_use_spc_or_spi eq 1 Then Begin
  file_restore  = 'Np_Wp_Vp_'+is_rtn_or_sc_str+'_arr'+spc_v_str+$
    '(psp_'+spc_suite_str+'_'+spc_payload_str+'_'+spc_level_str+')'+$
    Data_Restore_Str+TimeRange_Restore_Str+'.sav'
Endif
If is_use_spc_or_spi eq 2 Then Begin
  file_restore  = 'Ni_Vi_Ti_tensor_InstFrame'+$
    '(psp_'+spi_suite_str+'_'+spi_payload_str+'_'+spi_descriptor_str+'_'+spi_level_str+')'+$
    Data_Restore_Str+TimeRange_Restore_Str+'.sav'
Endif
file_array  = File_Search(dir_data, file_restore, count=num_files)
For i_file=0,num_files-1 Do Begin
  Print, 'i_file, file: ', i_file, ': ', file_array[i_file]
Endfor
;;--
For i_file=0,num_files-1 Do Begin
;For i_file=1,11 Do Begin
  file_restore  = file_array[i_file]
  file_restore  = StrMid(file_restore, StrLen(dir_data)+0, StrLen(file_restore)-StrLen(dir_data)-0)
  If is_use_spc_or_spi eq 1 Then Begin
    If is_rtn_or_sc eq 1 Then Begin
      year_str = StrMid(file_restore, 45, 4)
      mon_str  = StrMid(file_restore, 49, 2)
      day_str  = Strmid(file_restore, 51, 2)
    Endif
    If is_rtn_or_sc eq 2 Then Begin
      year_str = StrMid(file_restore, 44, 4)
      mon_str  = StrMid(file_restore, 48, 2)
      day_str  = Strmid(file_restore, 50, 2)
    Endif
  Endif
  If is_use_spc_or_spi eq 2 Then Begin
    year_str = StrMid(file_restore, 47, 4)
    mon_str  = StrMid(file_restore, 51, 2)
    day_str  = Strmid(file_restore, 53, 2)
  Endif
  dir_restore = 'C:\STUDY\PSP\Encounter 5\RESULT\SaveData\'
  dir_save = dir_restore
  dir_fig = 'C:\STUDY\PSP\Encounter 5\RESULT\Figures\'
  If is_use_spc_or_spi eq 1 Then Begin
    ;;;---
    Restore, dir_restore+file_restore, /verbose
    ;data_descrip  = 'got from "Read_PSP_SPC_L3_CDF.pro"'
    ;Save, FileName=dir_save+file_save, $
    ;  data_descrip, $
    ;  TimeRange_str, $
    ;  JulDay_vect_save, Np_RTN_vect_save, Wp_RTN_vect_save, $
    ;  Vpx_RTN_vect_save, Vpy_RTN_vect_save, Vpz_RTN_vect_save, $
    ;  sub_beg_BadBins_vect, sub_end_BadBins_vect, $
    ;  num_DataGaps, JulDay_beg_DataGap_vect, JulDay_end_DataGap_vect
    If is_rtn_or_sc eq 1 Then Begin
      JulDay_V_vect = JulDay_vect_save
      Vr_Solar_vect = Vpx_RTN_vect_save
      Vt_Solar_vect = Vpy_RTN_vect_save
      Vn_Solar_vect = Vpz_RTN_vect_save
    Endif
    If is_rtn_or_sc eq 2 Then Begin
      JulDay_V_vect = JulDay_vect_save
      Vr_Solar_vect = -Vpz_SC_vect_save
      Vt_Solar_vect = +Vpx_SC_vect_save
      Vn_Solar_vect = -Vpy_SC_vect_save
    Endif
  Endif
  If is_use_spc_or_spi eq 2 Then Begin
    ;;;---
    Restore, dir_restore+file_restore, /verbose
    ;    data_descrip  = 'got from "Read_PSP_SPI_moms_L3_CDF.pro"'
    ;    Save, FileName=dir_save+file_save, $
    ;      data_descrip, $
    ;      TimeRange_str, $
    ;      JulDay_vect_save, Ni_vect_save, Vix_RTN_vect_save, Viy_RTN_vect_save, Viz_RTN_vect_save, $
    ;      Vix_SC_vect_save, Viy_SC_vect_save, Viz_SC_vect_save, $
    ;      Tixx_vect_save, Tiyy_vect_save, Tizz_vect_save, $
    ;      Tixy_vect_save, Tixz_vect_save, Tiyz_vect_save, $
    ;      Titrace_vect_save, $
    ;      sub_beg_BadBins_vect, sub_end_BadBins_vect, $
    ;      num_DataGaps, JulDay_beg_DataGap_vect, JulDay_end_DataGap_vect
    JulDay_V_vect = JulDay_vect_save
    Np_RTN_vect = Ni_vect_save
    Vr_Solar_vect = -Viz_SC_vect_save
    Vt_Solar_vect = +Vix_SC_vect_save
    Vn_Solar_vect = -Viy_SC_vect_save
  Endif
  JulDay_B_vect = [] & JulDay_U_vect = []
  Br_Solar_vect = [] & Bt_Solar_vect = [] & Bn_Solar_vect = []
  Ui_Solar_vect = [] & Uj_Solar_vect = []
  ;;;---
  mag_file_restore  = 'Bxyz_'+is_rtn_or_sc_str+'_arr'+$
    '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
    '('+year_str+mon_str+day_str+')'+'*.sav'
  mag_file_array  = File_Search(dir_restore, mag_file_restore, count=num_files)
  ;;;---
  dfb_file_restore  = 'Voltage_Uij_'+$
    '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
    '('+year_str+mon_str+day_str+')'+'*.sav'
  dfb_file_array  = File_Search(dir_restore, dfb_file_restore, count=num_files)
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
    If is_rtn_or_sc eq 1 Then Begin
      JulDay_B_vect = [JulDay_B_vect, JulDay_vect_save]
      Br_Solar_vect = [Br_Solar_vect, Bx_RTN_vect_save]
      Bt_Solar_vect = [Bt_Solar_vect, By_RTN_vect_save]
      Bn_Solar_vect = [Bn_Solar_vect, Bz_RTN_vect_save]
    Endif
    If is_rtn_or_sc eq 2 Then Begin
      JulDay_B_vect = [JulDay_B_vect, JulDay_vect_save]
      Br_Solar_vect = [Br_Solar_vect, -Bz_SC_vect_save]
      Bt_Solar_vect = [Bt_Solar_vect, +Bx_SC_vect_save]
      Bn_Solar_vect = [Bn_Solar_vect, -By_SC_vect_save]
    Endif
    ;;;---
    dfb_file_restore  = dfb_file_array[h]
    dfb_file_restore  = StrMid(dfb_file_restore, StrLen(dir_restore), StrLen(dfb_file_restore)-StrLen(dir_restore))
    Restore, dir_restore+dfb_file_restore, /verbose
  ;  data_descrip  = 'got from "Read_PSP_fld_Volt_cdf.pro"'
  ;  Save, FileName=dir_save+file_save, $
  ;      data_descrip, $
  ;      JulDay_vect_save, Ui_Solar_vect_save, Uj_Solar_vect_save
    JulDay_U_vect = [JulDay_U_vect, JulDay_vect_save]
    Ui_Solar_vect = [Ui_Solar_vect, Ui_Solar_vect_save]
    Uj_Solar_vect = [Uj_Solar_vect, Uj_Solar_vect_save]
  End

  Step2:
  ;===========================
  ;Step2:
  ;Pol B to V
  Pol_Br_Solar_vect = INTERPOL(Br_Solar_vect, JulDay_B_vect, JulDay_V_vect)
  Pol_Bt_Solar_vect = INTERPOL(Bt_Solar_vect, JulDay_B_vect, JulDay_V_vect)
  Pol_Bn_Solar_vect = INTERPOL(Bn_Solar_vect, JulDay_B_vect, JulDay_V_vect)
  ;Pol U to V
  Pol_Ui_Solar_vect = INTERPOL(Ui_Solar_vect, JulDay_U_vect, JulDay_V_vect)
  Pol_Uj_Solar_vect = INTERPOL(Uj_Solar_vect, JulDay_U_vect, JulDay_V_vect)
  ;--
  Pol_Ui_Solar_vect = Pol_Ui_Solar_vect*1e3 ;from [V] to [mV]
  Pol_Uj_Solar_vect = Pol_Uj_Solar_vect*1e3
  ;caculate VXB; [km/s] x [nT] =  10^3[m/s]x10^(-9)[T] = 10^(-6) [V/m]
  ;equal 1e6 V/m
  VXB_T_Solar_vect = Vn_Solar_vect*Pol_Br_Solar_vect - Vr_Solar_vect*Pol_Bn_Solar_vect
  VXB_N_Solar_vect = Vr_Solar_vect*Pol_Bt_Solar_vect - Vt_Solar_vect*Pol_Br_Solar_vect
  ;--
  VXB_T_Solar_vect = VXB_T_Solar_vect*1e-3 ;from 10^(-6)[V/m] to 10^(-3)[V/m], i.e., [mV/m]
  VXB_N_Solar_vect = VXB_N_Solar_vect*1e-3
  minus_VxB_T_Solar_vect = - VxB_T_solar_vect ;added by JSHPET on 2021-02-15
  minus_VxB_N_solar_vect = - VxB_N_solar_vect ;added by JSHEPT on 2021-02-15
  
  
  Step3:
  ;========================================【根据速度和磁场作电场拟合】
  ;Regress to calculate electric fields
  time_vect = (JulDay_V_vect-JulDay_V_vect[0]) * (24.*60.*60)
  time_window = 24.0
  time_head = 0.0
  time_tail = time_head+time_window
  ;--
  JulDay_E_vect = []
  Et_Solar_vect = []
  En_Solar_vect = []
  ;--
  JulDay_E_parameters_vect = []
  JulDay_E_parameters_vect_begin = []
  JulDay_E_parameters_vect_end = []
  delta_Ui_list = []
  delta_Uj_list = []
  L_antenna_list = []
  theta_rotation_list = []
  ;--
  weight_i = 0.50
  weight_j = 1.0 - weight_i
  print,'Regress Begin!!!'
  while time_tail le time_vect[N_elements(time_vect)-1] do begin
    position_para = where(time_vect ge time_head and time_vect le time_tail)
    Ui_para = Pol_Ui_Solar_vect[position_para]
    Uj_para = Pol_Uj_Solar_vect[position_para]
    minus_VXB_T_para = minus_VXB_T_Solar_vect[position_para] ;added by JSHEPT on 2021-02-15
    minus_VXB_N_para = minus_VXB_N_Solar_vect[position_para] ;added by JSHEPT on 2021-02-15
    if N_elements(position_para) le 2 then begin
      time_head = time_tail
      time_tail = time_head+time_window
      continue
    endif
    ;Conjugate Gradient Fitting
    ;Initialization
    ;PDF_x_List=fltarr(1,m_size)
    ;PDF_b_List=transpose(PDF_List)
    ;PDF_a_List=fltarr(m_size,n_size)
    PDF_x_List = [[sqrt(0.75)],[0.5],[-20.0],[-20.0]]
    PDF_b_List = [[transpose(minus_VXB_T_para)],[transpose(minus_VXB_N_para)]] ;changed by JSHEPT on 2021-02-15
    PDF_a_List_1 = [transpose(Ui_para),transpose(Uj_para),0.5+fltarr(1,N_elements(position_para)),0.5+fltarr(1,N_elements(position_para))]
    PDF_a_List_2 = [transpose(-Uj_para),transpose(Ui_para),0.5+fltarr(1,N_elements(position_para)),-0.5+fltarr(1,N_elements(position_para))]
    PDF_a_List = [[PDF_a_List_1],[PDF_a_List_2]]
    ;------------
    ;Conjugate Gradient Fitting
    ;IDL (m,n) m is num of columns and n is num of lines
    ;itern is the depth of the iteration
    itern=100
    ;;--
    ;;if you need, you can add the damping matrix
    ;lam=0.3
    ;a_plus_List=fltarr(m_size,m_size)
    ;for i=0,m_size-1 do begin
    ;  a_plus_List(i,i)=lam
    ;endfor
    ;b_plus_List=fltarr(1,m_size)
    ;PDF_a_List=[[PDF_a_List],[a_plus_List]]
    ;PDF_b_List=[[PDF_b_List],[b_plus_List]]
    ;------------
    ;H wei hang,L wei lie
    ;PDF_a_List m+n lines m columns
    ;PDF_x_List m lines 1 columns
    ;PDF_b_List m+n lines 1 columns
    s_List=PDF_b_List-(PDF_x_List # PDF_a_List);m+n H 1 L
    r_List=s_List # transpose(PDF_a_List);m H 1 L
    p_List=r_List;m H 1 L
    q_List=p_List # PDF_a_List;m+n H 1 L
    for i=1,itern do begin
      aerfa_num=(p_List # transpose(r_List))/(q_List # transpose(q_List))
      PDF_x_List=PDF_x_List+aerfa_num[0]*p_List
      s_List=PDF_b_List-(PDF_x_List # PDF_a_List)
      r0_List=s_List # transpose(PDF_a_List)
      beita_num=((r0_List-r_List) # transpose(r0_List))/(r_List # transpose(r_List))
      r_List=r0_List
      p_List=p_List*beita_num[0]-r0_List
      q_List=p_List # PDF_a_List
    endfor
    PDF_x_List=transpose(PDF_x_List)
    ;print,'Gradient Fitting : ',PDF_x_List
    ;----------------------------------------------------------------------------------
    ;Et_Solar_vect_para = Ui_para*PDF_x_List[0] + Uj_para*PDF_x_List[1] + 0.5*(PDF_x_List[2]+PDF_x_List[3])
    ;En_Solar_vect_para = Ui_para*PDF_x_List[1] - Uj_para*PDF_x_List[0] + 0.5*(PDF_x_List[2]-PDF_x_List[3])
    ;----------------------------------------------------------------------------------
    cos_theta_L = PDF_x_List[0]
    sin_theta_L = PDF_x_List[1]
    ;------------
    const_T = 0.5*(PDF_x_List[2] + PDF_x_List[3])
    const_N = 0.5*(PDF_x_List[2] - PDF_x_List[3])
    ;------------
    delta_Ui = (const_T*cos_theta_L+const_N*sin_theta_L)/(cos_theta_L^2+sin_theta_L^2)
    delta_Uj = (const_T*sin_theta_L-const_N*cos_theta_L)/(cos_theta_L^2+sin_theta_L^2)
    ;------------
    L_antenna = sqrt(1.0/(cos_theta_L^2+sin_theta_L^2))
    ;------------
    ;theta_rotation = asin(sin_theta_L*L_antenna)*180.0/!pi
    if cos_theta_L ge 0.0 then begin
      theta_rotation = asin(sin_theta_L*L_antenna)*180.0/!pi
    endif else begin
      if sin_theta_L ge 0.0 then begin
        theta_rotation = 180.0 - asin(sin_theta_L*L_antenna)*180.0/!pi
      endif else begin
        theta_rotation = -180.0 - asin(sin_theta_L*L_antenna)*180.0/!pi
      endelse
    endelse
    ;----------------------------------------------------------------------------------
    Et_Solar_vect_para = ((Ui_para+delta_Ui)*cos(theta_rotation*!pi/180.0) + (Uj_para+delta_Uj)*sin(theta_rotation*!pi/180.0))/L_antenna
    En_Solar_vect_para = ((Ui_para+delta_Ui)*sin(theta_rotation*!pi/180.0) - (Uj_para+delta_Uj)*cos(theta_rotation*!pi/180.0))/L_antenna
    ;----------------------------------------------------------------------------------
    JulDay_E_parameters_vect = [JulDay_E_parameters_vect, mean(JulDay_V_vect[position_para])]
    JulDay_E_parameters_vect_begin = [JulDay_E_parameters_vect_begin, JulDay_V_vect[0] + time_head/(24.*60.*60)]
    JulDay_E_parameters_vect_end = [JulDay_E_parameters_vect_end, JulDay_V_vect[0] + time_tail/(24.*60.*60)]
    delta_Ui_list = [delta_Ui_list, delta_Ui]
    delta_Uj_list = [delta_Uj_list, delta_Uj]
    L_antenna_list = [L_antenna_list, L_antenna]
    theta_rotation_list = [theta_rotation_list, theta_rotation]
    ;;--
    Et_Solar_vect = [Et_Solar_vect, Et_Solar_vect_para]
    En_Solar_vect = [En_Solar_vect, En_Solar_vect_para]
    JulDay_E_vect = [JulDay_E_vect, JulDay_V_vect[position_para]]
    ;--
    time_head = time_tail
    time_tail = time_head+time_window
  endwhile
  print,'Regress End!'
  
  
  Step4:
  ;========================================
  ;;--
  If is_use_spc_or_spi eq 1 Then Begin
    file_save = 'Electric_Field_Fitting_in_'+is_rtn_or_sc_str+'_Frame'+$
      '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
      '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
      '(psp_'+spc_suite_str+'_'+spc_payload_str+'_'+spc_level_str+')'+$
      '('+year_str+mon_str+day_str+')'+$
      TimeRange_str+'.sav'
  Endif
  If is_use_spc_or_spi eq 2 Then Begin
    file_save = 'Electric_Field_Fitting_in_SC_Frame'+$
      '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
      '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
      '(psp_'+spi_suite_str+'_'+spi_payload_str+'_'+spi_descriptor_str+'_'+spi_level_str+')'+$
      '('+year_str+mon_str+day_str+')'+$
      TimeRange_str+'.sav'
  Endif
  dir_save  = PSP_savData_Dir
  data_descrip  = 'got from "Calculate_electric_field_from_the_Voltage_BasedOn_PSP_MainProgram"'
  Save, FileName=dir_save+file_save, $
    data_descrip, $
    JulDay_E_vect, Et_Solar_vect, En_Solar_vect, JulDay_E_parameters_vect,$
    JulDay_V_vect, minus_VxB_T_Solar_vect, minus_VxB_N_Solar_vect, $
    JulDay_E_parameters_vect_begin, JulDay_E_parameters_vect_end, delta_Ui_list, delta_Uj_list,L_antenna_list, theta_rotation_list
  
  
  Step5_1:
  ;========================================【单位转换】
  ;;--calculate the electric field time series
  rate_progress = 0.0
  Et_offset_Solar_vect = fltarr(N_elements(JulDay_U_vect))
  En_offset_Solar_vect = fltarr(N_elements(JulDay_U_vect))
  for i_time = 0,N_elements(JulDay_E_parameters_vect)-1 do begin
    position_para = where(JulDay_U_vect ge JulDay_E_parameters_vect_begin[i_time] and JulDay_U_vect le JulDay_E_parameters_vect_end[i_time])
    Et_offset_Solar_vect[position_para] = ((Ui_Solar_vect[position_para]*1000.0+delta_Ui_list[i_time])*cos(theta_rotation_list[i_time]*!pi/180.0)+(Uj_Solar_vect[position_para]*1000.0+delta_Uj_list[i_time])*sin(theta_rotation_list[i_time]*!pi/180.0))/L_antenna_list[i_time]
    En_offset_Solar_vect[position_para] = ((Ui_Solar_vect[position_para]*1000.0+delta_Ui_list[i_time])*sin(theta_rotation_list[i_time]*!pi/180.0)-(Uj_Solar_vect[position_para]*1000.0+delta_Uj_list[i_time])*cos(theta_rotation_list[i_time]*!pi/180.0))/L_antenna_list[i_time]
    if ((i_time-0.0)/N_elements(JulDay_E_parameters_vect)-rate_progress ge 0.01) then begin
      print,strcompress(string(rate_progress*100),/remove_all),'%'
      rate_progress = (i_time-0.0)/N_elements(JulDay_E_parameters_vect)
    endif
  endfor
  Et_offset_Solar_vect[where(abs(Et_offset_Solar_vect) ge 1e4)] = mean(Et_offset_Solar_vect[where(abs(Et_offset_Solar_vect) le 1e4)])
  En_offset_Solar_vect[where(abs(En_offset_Solar_vect) ge 1e4)] = mean(En_offset_Solar_vect[where(abs(En_offset_Solar_vect) le 1e4)])
  JulDay_E_offset_vect = JulDay_U_vect
  
  Step5_2:
  ;========================================
  ;;--save electric field data
  ;;--
  If is_use_spc_or_spi eq 1 Then Begin
    file_save = 'Electric_Field_Offset_in_'+is_rtn_or_sc_str+'_Frame'+$
      '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
      '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
      '(psp_'+spc_suite_str+'_'+spc_payload_str+'_'+spc_level_str+')'+$
      '('+year_str+mon_str+day_str+')'+$
      TimeRange_str+'.sav'
  Endif
  If is_use_spc_or_spi eq 2 Then Begin
    file_save = 'Electric_Field_Offset_in_SC_Frame'+$
      '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
      '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
      '(psp_'+spi_suite_str+'_'+spi_payload_str+'_'+spi_descriptor_str+'_'+spi_level_str+')'+$
      '('+year_str+mon_str+day_str+')'+$
      TimeRange_str+'.sav'
  Endif
  data_descrip  = 'got from "Calculate_electric_field_from_the_Voltage_BasedOn_PSP_MainProgram"'
  Save, FileName=dir_save+file_save, $
    data_descrip, $
    JulDay_E_offset_vect, Et_offset_Solar_vect, En_offset_Solar_vect


  Step6:
  ;========================================
  ;;--
  dir_fig = 'C:\STUDY\PSP\Encounter 5\RESULT\Figures\'
  If is_use_spc_or_spi eq 1 Then Begin
    file_fig = 'E_minusVxB_offset_Solar_'+is_rtn_or_sc_str+$
      '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
      '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
      '(psp_'+spc_suite_str+'_'+spc_payload_str+'_'+spc_level_str+')'+$
      '('+year_str+mon_str+day_str+')'+TimeRange_str
  Endif
  If is_use_spc_or_spi eq 2 Then Begin
    file_fig = 'E_minusVxB_offset_Solar_'+is_rtn_or_sc_str+$
      '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
      '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
      '(psp_'+spi_suite_str+'_'+spi_payload_str+'_'+spi_descriptor_str+'_'+spi_level_str+')'+$
      '('+year_str+mon_str+day_str+')'+TimeRange_str
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
  is_png_eps = 1
  If is_png_eps eq 2 Then Begin
    Set_Plot,'PS'
    xsize = 25.0
    ysize = 25.0
    Device, FileName=FileName, XSize=xsize,YSize=ysize,/Color,Bits=8,/Encapsul
  EndIf Else Begin
    If is_png_eps eq 1 Then Begin
      Set_Plot, 'WIN'
      Device,DeComposed=0;, /Retain
      xsize=1400.0 & ysize=1800.0
      Window,2,XSize=xsize,YSize=ysize,Retain=2,/pixmap
    EndIf
  EndElse
  ;;--
  LoadCT,13
  TVLCT,R,G,B,/Get
  color_black   = 255L
  TVLCT,0L,0L,0L,color_black
  color_dpurp   = 254L
  TVLCT,130L,0L,132L,color_dpurp
  color_purp    = 253L
  TVLCT,185L,0L,187L,color_purp
  color_udblue  = 252L
  TVLCT,81L,79L,131L,color_udblue
  color_sblue   = 251L
  TVLCT,181L,238L,238L,color_sblue
  color_blue    = 250L
  TVLCT,0L,0L,255L,color_blue
  color_udgreen = 249L
  TVLCT,16L,125L,0L,color_udgreen
  color_dgreen  = 248L
  TVLCT,133L,157L,5L,color_dgreen
  color_green   = 247L
  TVLCT,134L,192L,4L,color_green
  color_sgreen  = 246L
  TVLCT,50L,205L,50L,color_sgreen
  color_usgreen = 245L
  TVLCT,190L,255L,102L,color_usgreen
  color_yellow  = 244L
  TVLCT,255L,255L,9L,color_yellow
  color_dyellow = 243L
  TVLCT,254L,190L,10L,color_dyellow
  color_orange  = 242L
  TVLCT,253L,142L,8L,color_orange
  color_dorange = 241L
  TVLCT,252L,103L,8L,color_dorange
  color_pink    = 240L
  TVLCT,246L,192L,210L,color_pink
  color_dred    = 239L
  TVLCT,185L,27L,81L,color_dred
  color_red     = 238L
  TVLCT,255L,0L,0L,color_red
  color_white   = 237L
  TVLCT,255L,255L,255L,color_white
  num_CB_color= 256-19
  R=Congrid(R,num_CB_color)
  G=Congrid(G,num_CB_color)
  B=Congrid(B,num_CB_color)
  TVLCT,R,G,B
  ;--
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
  ;--
  color_list = [color_black,color_dpurp,color_purp,color_udblue,color_sblue,color_blue,color_udgreen,color_dgreen,color_green,$
    color_sgreen,color_usgreen,color_yellow,color_dyellow,color_orange,color_dorange,color_pink,color_dred,color_red]
  color_list = reverse(color_list)
  ;----------------------------------------------------------------------------------
  ;;--
  position_img  = [0.05,0.05,0.95,0.95]
  num_subimgs_x = 1
  num_subimgs_y = 6
  dx_subimg   = (position_img[2]-position_img[0])/num_subimgs_x
  dy_subimg   = (position_img[3]-position_img[1])/num_subimgs_y
  ;--
  JulDay_beg_plot = min(JulDay_V_vect)
  JulDay_end_plot = max(JulDay_V_vect)
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 5
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_E_vect
  yplot_vect  = Et_Solar_vect
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [-40.0,40.0]
  xtitle    = ''
  ytitle    = TextoIDL('E_T [mV/m]')
  title     = is_rtn_or_sc eq 1 ? 'rtn coordinate & inertial reference frame':'sc coordinate & sc reference frame'
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,title=title,charsize=axislegend_charsize,$
    XTitle=xtitle,YTitle=ytitle,xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize/2,ycharsize=axislegend_charsize/2,charthick=axislegend_charthick,$
    Color=color_black,thick=plot_charthick*0.8,$
    /NoErase,Font=-1
  ;--
  xplot_vect  = JulDay_V_vect
  yplot_vect  = Pol_Ui_Solar_vect
  ;oplot,xplot_vect,yplot_vect,color=color_blue,linestyle=0,thick=plot_charthick*0.1
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 5
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_V_vect
  ;d yplot_vect  = VXB_T_Solar_vect ;annotated by JSHEPT on 2021-02-15
  yplot_vect  = minus_VxB_T_Solar_vect ;added by JSHEPT on 2021-02-15
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [-40.0,40.0]
  xtitle    = ''
  ;a ytitle    = TextoIDL('VXB [mV/m]') ;annotated by JSHEPT on 2021-02-15
  ytitle = TextoIDL('-(VXB)_T [mV/m]') ; added by JSHEPT on 2021-02-15
  Axis, xrange[1], YAxis=1, /Save, YRange=yrange, YStyle=1, YTitle=ytitle, xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,Color=color_red
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1+4,YStyle=1+4,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle='',YTitle='',xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,$
    Color=color_red,thick=plot_charthick*0.2,$
    /NoErase,Font=-1
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 4
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_E_vect
  yplot_vect  = En_Solar_vect
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [-40.0,40.0]
  xtitle    = ''
  ytitle    = TextoIDL('E_N [mV/m]')
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle=xtitle,YTitle=ytitle,xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,$
    Color=color_black,thick=plot_charthick*0.8,$
    /NoErase,Font=-1
  ;--
  xplot_vect  = JulDay_V_vect
  yplot_vect  = Pol_Uj_Solar_vect
  ;oplot,xplot_vect,yplot_vect,color=color_blue,linestyle=0,thick=plot_charthick*0.1
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 4
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_V_vect
  ;d yplot_vect  = VXB_N_Solar_vect ;annotated by JSHPET on 2021-02-15
  yplot_vect = minus_VxB_N_Solar_vect ;added by JSHEPT on 2021-02-15
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [-40.0,40.0]
  xtitle    = ''
  ;a ytitle    = TextoIDL('VXB [mV/m]') ;annotated by JSHEPT on 2021-02-15
  ytitle = TextoIDL('-(VXB)_N [mV/m]') ;added by JSHEPT on 2021-02-15
  Axis, xrange[1], YAxis=1, /Save, YRange=yrange, YStyle=1, YTitle=ytitle, xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,Color=color_sgreen
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1+4,YStyle=1+4,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle='',YTitle='',xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,$
    Color=color_sgreen,thick=plot_charthick*0.2,$
    /NoErase,Font=-1
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 3
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_E_parameters_vect
  yplot_vect  = delta_Ui_list
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [-60.0,60.0]
  xtitle    = ''
  ytitle    = TextoIDL('OFFSET 1 [mV]')
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle=xtitle,YTitle=ytitle,xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,$
    Color=color_black,thick=plot_charthick*0.8,$
    /NoErase,Font=-1,/noData
  for i_choice=0,N_elements(JulDay_E_parameters_vect)-1 do begin
    xplot_tmp  = [xplot_vect[i_choice]]
    yplot_tmp  = [yplot_vect[i_choice]]
    color_tmp = color_black
    PlotSym, 0, 0.5, FILL=1,thick=4.0,Color=color_tmp
    Plots, xplot_tmp, yplot_tmp,Psym=-8,color=color_tmp,thick=plot_charthick*0.5,NoClip=0
  endfor
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 2
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_E_parameters_vect
  yplot_vect  = delta_Uj_list
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [-60.0,60.0]
  xtitle    = ''
  ytitle    = TextoIDL('OFFSET 2 [mV]')
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle=xtitle,YTitle=ytitle,xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,$
    Color=color_black,thick=plot_charthick*0.8,$
    /NoErase,Font=-1,/noData
  for i_choice=0,N_elements(JulDay_E_parameters_vect)-1 do begin
    xplot_tmp  = [xplot_vect[i_choice]]
    yplot_tmp  = [yplot_vect[i_choice]]
    color_tmp = color_black
    PlotSym, 0, 0.5, FILL=1,thick=4.0,Color=color_tmp
    Plots, xplot_tmp, yplot_tmp,Psym=-8,color=color_tmp,thick=plot_charthick*0.5,NoClip=0
  endfor
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 1
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_E_parameters_vect
  yplot_vect  = L_antenna_list
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [0.0,5.0]
  xtitle    = ''
  ytitle    = TextoIDL('LENGTH [m]')
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle=xtitle,YTitle=ytitle,xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,$
    Color=color_black,thick=plot_charthick*0.8,$
    /NoErase,Font=-1,/noData
  for i_choice=0,N_elements(JulDay_E_parameters_vect)-1 do begin
    xplot_tmp  = [xplot_vect[i_choice]]
    yplot_tmp  = [yplot_vect[i_choice]]
    color_tmp = color_black
    PlotSym, 0, 0.5, FILL=1,thick=4.0,Color=color_tmp
    Plots, xplot_tmp, yplot_tmp,Psym=-8,color=color_tmp,thick=plot_charthick*0.5,NoClip=0
  endfor
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 0
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_E_parameters_vect
  yplot_vect  = theta_rotation_list
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv = xtickv_time
  xticknames = xticknames_time
  xtickv    = [xtickv_time[0],xtickv_time[N_Elements(xtickv_time)/2],xtickv_time[N_Elements(xtickv_time)-1]]
  xticknames  = [xticknames_time[0],xticknames_time[N_Elements(xtickv_time)/2],xticknames_time[N_Elements(xtickv_time)-1]]
  xticks    = N_Elements(xtickv)-1
  ;xminor    = 6
  yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [-180.0,180.0]
  xtitle    = ''
  ytitle    = TextoIDL('ANGLE [degree]')
  title     = is_rtn_or_sc eq 1 ? 'rtn coordinate & inertial reference frame':'sc coordinate & sc reference frame'
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,title=title, $
    XTitle=xtitle,YTitle=ytitle,xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,$
    Color=color_black,thick=plot_charthick*0.8,$
    /NoErase,Font=-1,/noData
  for i_choice=0,N_elements(JulDay_E_parameters_vect)-1 do begin
    xplot_tmp  = [xplot_vect[i_choice]]
    yplot_tmp  = [yplot_vect[i_choice]]
    color_tmp = color_black
    PlotSym, 0, 0.5, FILL=1,thick=4.0,Color=color_tmp
    Plots, xplot_tmp, yplot_tmp,Psym=-8,color=color_tmp,thick=plot_charthick*0.5,NoClip=0
  endfor
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
;  goto,End_Program
  Step7:
  ;========================================
  ;;--
  ;;--
  dir_fig = 'C:\STUDY\PSP\Encounter 5\RESULT\Figures\'
  If is_use_spc_or_spi eq 1 Then Begin
    file_fig = 'E_offset_Compare_in_'+is_rtn_or_sc_str+'_Frame'+$
      '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
      '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
      '(psp_'+spc_suite_str+'_'+spc_payload_str+'_'+spc_level_str+')'+$
      '('+year_str+mon_str+day_str+')'+TimeRange_str
  Endif
  If is_use_spc_or_spi eq 2 Then Begin
    file_fig = 'E_offset_Compare_in_SC_Frame'+$
      '(psp_'+mag_suite_str+'_'+mag_level_str+'_'+mag_payload_str+'_'+mag_coord_str+mag_cadence_str+')'+$
      '(psp_'+dfb_suite_str+'_'+dfb_level_str+'_'+dfb_payload_str+'_'+dfb_payload_str_v2+'_'+dfb_cadence_str+')'+$
      '(psp_'+spi_suite_str+'_'+spi_payload_str+'_'+spi_descriptor_str+'_'+spi_level_str+')'+$
      '('+year_str+mon_str+day_str+')'+TimeRange_str
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
  is_png_eps = 1
  If is_png_eps eq 2 Then Begin
    Set_Plot,'PS'
    xsize = 25.0
    ysize = 25.0
    Device, FileName=FileName, XSize=xsize,YSize=ysize,/Color,Bits=8,/Encapsul
  EndIf Else Begin
    If is_png_eps eq 1 Then Begin
      Set_Plot, 'WIN'
      Device,DeComposed=0;, /Retain
      xsize=1200.0 & ysize=900.0
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
  ;--
  legend_charsize = 2.0
  legend_charthick = 2.0
  axis_chatthick = 2.0
  axislegend_charsize = 2.0
  axislegend_charthick = 2.0
  plot_charthick = 2.0
  ;;--
  position_img  = [0.05,0.05,0.95,0.95]
  num_subimgs_x = 1
  num_subimgs_y = 2
  dx_subimg   = (position_img[2]-position_img[0])/num_subimgs_x
  dy_subimg   = (position_img[3]-position_img[1])/num_subimgs_y
  ;--
  JulDay_beg_plot = min(JulDay_U_vect)
  JulDay_end_plot = max(JulDay_U_vect)
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 1
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_U_vect
  yplot_vect  = Et_offset_Solar_vect
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  ;yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [-40.0,40.0]
  xtitle    = ''
  ytitle    = TextoIDL('Et [mV/m]')
  title     = is_rtn_or_sc eq 1 ? 'rtn coordinate & inertial reference frame':'sc coordinate & sc reference frame'
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,title=title,charsize=axislegend_charsize,$
    XTitle=xtitle,YTitle=ytitle,xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,$
    Color=color_black,thick=plot_charthick*0.8,$
    /NoErase,Font=-1
  ;--
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 1
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_E_vect
  yplot_vect  = Et_Solar_vect
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  ;yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [-40.0,40.0]
  xtitle    = ''
  ytitle    = TextoIDL('-(VXB)t [mV/m]') ;changed by JSHEPT on 2021-02-15
  Axis, xrange[1], YAxis=1, /Save, YRange=yrange, YStyle=1, YTitle=ytitle, xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,Color=color_red
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1+4,YStyle=1+4,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle='',YTitle='',xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,$
    Color=color_red,thick=plot_charthick*0.2,$
    /NoErase,Font=-1
  ;----------------------------------------------------------------------------------
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 0
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_U_vect
  yplot_vect  = En_offset_Solar_vect
  ;xrange  = [Min(JulDay_vect_plot), Max(JulDay_vect_plot)]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv = xtickv_time
  xticknames = xticknames_time
  xtickv    = [xtickv_time[0],xtickv_time[N_Elements(xtickv_time)/2],xtickv_time[N_Elements(xtickv_time)-1]]
  xticknames  = [xticknames_time[0],xticknames_time[N_Elements(xtickv_time)/2],xticknames_time[N_Elements(xtickv_time)-1]]
  xticks    = N_Elements(xtickv)-1
  ;xminor    = 6
  ;yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [-40.0,40.0]
  xtitle    = ''
  ytitle    = TextoIDL('En [mV/m]')
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1,YStyle=1,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04,$
    XTitle=xtitle,YTitle=ytitle,xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,$
    Color=color_black,thick=plot_charthick*0.8,$
    /NoErase,Font=-1
  ;--
  ;----------------------------------------------------------------------------------
  ;;--
  i_subimg_x  = 0
  i_subimg_y  = 0
  win_position= [position_img[0]+dx_subimg*i_subimg_x+0.10*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+0.00*dy_subimg,$
    position_img[0]+dx_subimg*i_subimg_x+0.90*dx_subimg,$
    position_img[1]+dy_subimg*i_subimg_y+1.00*dy_subimg]
  position_subplot  = win_position
  xplot_vect  = JulDay_E_vect
  yplot_vect  = En_Solar_vect
  xrange  = [JulDay_beg_plot, JulDay_end_plot]
  xrange_time = xrange
  get_xtick_for_time, xrange_time, xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time
  xtickv    = xtickv_time
  xticks    = N_Elements(xtickv)-1
  xticknames  = Replicate(' ', xticks+1)
  xminor  = xminor_time
  ;xminor    = 6
  ;yrange    = [Min(yplot_vect)-0.1,Max(yplot_vect)+0.1]
  yrange    = [-40.0,40.0]
  xtitle    = ''
  ytitle    = TextoIDL('-(VXB)n [mV/m]') ;changed by JSHEPT on 2021-02-15
  Axis, xrange[1], YAxis=1, /Save, YRange=yrange, YStyle=1, YTitle=ytitle, xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,Color=color_sgreen
  Plot,xplot_vect, yplot_vect,XRange=xrange,YRange=yrange,XStyle=1+4,YStyle=1+4,$
    Position=position_subplot,$
    XTicks=xticks,XTickV=xtickv,XTickName=xticknames,XMinor=xminor,XTickLen=0.04, $
    XTitle='',YTitle='',xthick=axis_chatthick,ythick=axis_chatthick,xcharsize=axislegend_charsize,ycharsize=axislegend_charsize,charthick=axislegend_charthick,$
    Color=color_sgreen,thick=plot_charthick*0.2,$
    /NoErase,Font=-1
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

End