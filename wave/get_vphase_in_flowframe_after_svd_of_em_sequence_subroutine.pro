Pro get_Vphase_in_FlowFrame_after_SVD_of_EM_sequence_subroutine, $
  time_vect, period_vect, $
  k_over_omega_in_PL_frame_s2m_arr, $
  Vxyz_aver_in_SC_frame_kmps_vect=Vxyz_aver_in_SC_frame_kmps_vect, $
  Vphase_In_FLowFrame_kmps_arr=Vphase_In_FLowFrame_kmps_arr, $
  Omega_in_FLowFrame_rad2s_arr=Omega_in_FLowFrame_rad2s_arr, $
  kx_arr=kx_arr, ky_arr=ky_arr, kz_arr=kz_arr
  
  
  ;;--
  num_times = N_Elements(time_vect)
  num_periods = N_ELements(period_vect)

  ;;--
  omega_SC_rad2s_vect = 1./period_vect * (2*!pi)
  omega_SC_rad2s_arr = (Fltarr(num_times)+1.) # Transpose(omega_SC_rad2s_vect)
  
  ;;--
  Vx_kmps_aver = Vxyz_aver_in_SC_frame_kmps_vect[0]
  Vy_kmps_aver = Vxyz_aver_in_SC_frame_kmps_vect[1]
  Vz_kmps_aver = Vxyz_aver_in_SC_frame_kmps_vect[2]
  Vx_mps_arr = Fltarr(num_times, num_periods) + Vx_kmps_aver * 1.e3
  Vy_mps_arr = Fltarr(num_times, num_periods) + Vy_kmps_aver * 1.e3
  Vz_mps_arr = Fltarr(num_times, num_periods) + Vz_kmps_aver * 1.e3

  ;;--
  kx_over_omega_PL_s2m_arr = Reform(k_over_omega_in_PL_frame_s2m_arr[0,*,*])
  ky_over_omega_PL_s2m_arr = Reform(k_over_omega_in_PL_frame_s2m_arr[1,*,*])
  kz_over_omega_PL_s2m_arr = Reform(k_over_omega_in_PL_frame_s2m_arr[2,*,*])

  ;;--
  Omega_Flow_rad2s_arr = Vx_mps_arr * kx_over_omega_PL_s2m_arr +$
                         Vy_mps_arr * ky_over_omega_PL_s2m_arr +$
                         Vz_mps_arr * kz_over_omega_PL_s2m_arr
  
  ;;--
  Omega_in_FLowFrame_rad2s_arr = omega_SC_rad2s_arr/(1.0+Omega_Flow_rad2s_arr)
  
  ;;--get kx/ky/kz in unit of 1/m ( = k/omega_SC * omega_SC)
  kx_arr = kx_over_omega_PL_s2m_arr * Omega_in_FLowFrame_rad2s_arr ;unit: 1/m
  ky_arr = ky_over_omega_PL_s2m_arr * Omega_in_FLowFrame_rad2s_arr ;unit: 1/m
  kz_arr = kz_over_omega_PL_s2m_arr * Omega_in_FLowFrame_rad2s_arr ;unit: 1/m
  AbsK_arr = Sqrt(kx_arr^2 + ky_arr^2 + kz_arr^2)


  ;;--get phase-speed of the wave in the flow frame
  Vphx_mps_arr = Omega_in_FlowFrame_rad2s_arr / AbsK_arr^2 * kx_arr
  Vphy_mps_arr = Omega_in_FlowFrame_rad2s_arr / AbsK_arr^2 * ky_arr
  Vphz_mps_arr = Omega_in_FlowFrame_rad2s_arr / AbsK_arr^2 * kz_arr

  Vphase_in_FlowFrame_kmps_arr = Fltarr(3, num_times, num_periods)
  Vphase_in_FlowFrame_kmps_arr[0,*,*] = Vphx_mps_arr * 1.e-3
  Vphase_in_FlowFrame_kmps_arr[1,*,*] = Vphy_mps_arr * 1.e-3
  Vphase_in_FlowFrame_kmps_arr[2,*,*] = Vphz_mps_arr * 1.e-3

End