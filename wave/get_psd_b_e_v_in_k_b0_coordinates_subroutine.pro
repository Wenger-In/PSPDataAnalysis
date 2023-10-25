Pro get_PSD_B_E_V_in_k_B0_coordinates_subroutine, $
  time_vect, period_vect, $
  wavlet_Bx_arr, wavlet_By_arr, wavlet_Bz_arr, $
  wavlet_Ex_arr, wavlet_Ey_arr, wavlet_Ez_arr, $
  wavlet_Vpx_arr, wavlet_Vpy_arr, wavlet_Vpz_arr, $
  k_over_omega_arr, Bxyz_LBG_RTN_arr,$
  wavlet_Bpara_arr, wavlet_Bperp1_arr, wavlet_Bperp2_arr, $
  wavlet_Epara_arr, wavlet_Eperp1_arr, wavlet_Eperp2_arr, $
  wavlet_Vppara_arr, wavlet_Vpperp1_arr, wavlet_Vpperp2_arr, $
  PSD_Bpara_arr, PSD_Bperp1_arr, PSD_Bperp2_arr, $
  PSD_Epara_arr, PSD_Eperp1_arr, PSD_Eperp2_arr, $
  PSD_Vppara_arr, PSD_Vpperp1_arr, PSD_Vpperp2_arr
  

num_times = N_Elements(time_vect)
num_periods = N_Elements(period_vect)
dtime     = time_vect[1] - time_vect[0]
;;--
ebx_LBG_RTN_arr = Reform(Bxyz_LBG_RTN_arr[0,*,*]) / $
Sqrt(Total(Bxyz_LBG_RTN_arr^2,1))
eby_LBG_RTN_arr = Reform(Bxyz_LBG_RTN_arr[1,*,*]) / $
  Sqrt(Total(Bxyz_LBG_RTN_arr^2,1))
ebz_LBG_RTN_arr = Reform(Bxyz_LBG_RTN_arr[2,*,*]) / $
  Sqrt(Total(Bxyz_LBG_RTN_arr^2,1))
;;--
ekx_RTN_arr = Reform(k_over_omega_arr[0,*,*]) / $
  Sqrt(Total(k_over_omega_arr^2,1))
eky_RTN_arr = Reform(k_over_omega_arr[1,*,*]) / $
  Sqrt(Total(k_over_omega_arr^2,1))
ekz_RTN_arr = Reform(k_over_omega_arr[2,*,*]) / $
  Sqrt(Total(k_over_omega_arr^2,1))
;;--
eperp1x_RTN_arr = Findgen(num_times,num_periods)
eperp1y_RTN_arr = Findgen(num_times,num_periods)
eperp1z_RTN_arr = Findgen(num_times,num_periods)
eperp2x_RTN_arr = Findgen(num_times,num_periods)
eperp2y_RTN_arr = Findgen(num_times,num_periods)
eperp2z_RTN_arr = Findgen(num_times,num_periods)
For i_time=0,num_times-1 Do Begin
  For i_period=0,num_periods-1 Do Begin
    eb_vect = [ebx_LBG_RTN_arr[i_time,i_period],eby_LBG_RTN_arr[i_time,i_period],ebz_LBG_RTN_arr[i_time,i_period]]
    ek_vect = [ekx_RTN_arr[i_time,i_period],eky_RTN_arr[i_time,i_period],ekz_RTN_arr[i_time,i_period]]
    eperp2_vect = Crossp(eb_vect, ek_vect)
    eperp2_vect = eperp2_vect/Norm(eperp2_vect)
    eperp1_vect = Crossp(eperp2_vect,eb_vect)
    eperp1_vect = eperp1_vect/Norm(eperp1_vect)
    eperp1x_RTN_arr[i_time,i_period] = eperp1_vect[0]
    eperp1y_RTN_arr[i_time,i_period] = eperp1_vect[1]
    eperp1z_RTN_arr[i_time,i_period] = eperp1_vect[2]
    eperp2x_RTN_arr[i_time,i_period] = eperp2_vect[0]
    eperp2y_RTN_arr[i_time,i_period] = eperp2_vect[1]
    eperp2z_RTN_arr[i_time,i_period] = eperp2_vect[2]
  Endfor
Endfor


;;--
wavlet_Bpara_arr = wavlet_Bx_arr * ebx_LBG_RTN_arr + $
  wavlet_By_arr * eby_LBG_RTN_arr + $
  wavlet_Bz_arr * ebz_LBG_RTN_arr
wavlet_Bperp1_arr = wavlet_Bx_arr * eperp1x_RTN_arr + $
  wavlet_By_arr * eperp1y_RTN_arr + $
  wavlet_Bz_arr * eperp1z_RTN_arr
wavlet_Bperp2_arr = wavlet_Bx_arr * eperp2x_RTN_arr + $
  wavlet_By_arr * eperp2y_RTN_arr + $
  wavlet_Bz_arr * eperp2z_RTN_arr
;;--
wavlet_Epara_arr = wavlet_Ex_arr * ebx_LBG_RTN_arr + $
  wavlet_Ey_arr * eby_LBG_RTN_arr + $
  wavlet_Ez_arr * ebz_LBG_RTN_arr
wavlet_Eperp1_arr = wavlet_Ex_arr * eperp1x_RTN_arr + $
  wavlet_Ey_arr * eperp1y_RTN_arr + $
  wavlet_Ez_arr * eperp1z_RTN_arr
wavlet_Eperp2_arr = wavlet_Ex_arr * eperp2x_RTN_arr + $
  wavlet_Ey_arr * eperp2y_RTN_arr + $
  wavlet_Ez_arr * eperp2z_RTN_arr
;;--
wavlet_Vppara_arr = wavlet_Vpx_arr * ebx_LBG_RTN_arr + $
  wavlet_Vpy_arr * eby_LBG_RTN_arr + $
  wavlet_Vpz_arr * ebz_LBG_RTN_arr
wavlet_Vpperp1_arr = wavlet_Vpx_arr * eperp1x_RTN_arr + $
  wavlet_Vpy_arr * eperp1y_RTN_arr + $
  wavlet_Vpz_arr * eperp1z_RTN_arr
wavlet_Vpperp2_arr = wavlet_Vpx_arr * eperp2x_RTN_arr + $
  wavlet_Vpy_arr * eperp2y_RTN_arr + $
  wavlet_Vpz_arr * eperp2z_RTN_arr  

;;--
PSD_Bpara_arr = Abs(wavlet_Bpara_arr)^2 * dtime *2
PSD_Bperp1_arr = Abs(wavlet_Bperp1_arr)^2 * dtime *2
PSD_Bperp2_arr = Abs(wavlet_Bperp2_arr)^2 * dtime *2
PSD_Epara_arr = Abs(wavlet_Epara_arr)^2 * dtime *2
PSD_Eperp1_arr = Abs(wavlet_Eperp1_arr)^2 * dtime *2
PSD_Eperp2_arr = Abs(wavlet_Eperp2_arr)^2 * dtime *2
PSD_Vppara_arr = Abs(wavlet_Vppara_arr)^2 * dtime *2
PSD_Vpperp1_arr = Abs(wavlet_Vpperp1_arr)^2 * dtime *2
PSD_Vpperp2_arr = Abs(wavlet_Vpperp2_arr)^2 * dtime *2
End