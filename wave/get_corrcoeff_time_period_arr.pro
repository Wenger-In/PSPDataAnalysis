Pro get_CorrCoeff_time_period_arr, $
        time_vect, signal_a_vect, signal_b_vect, $  ;input
        period_range=period_range, $  ;input
        num_periods=num_periods, $  ;input
        CorrCoeff_arr, $  ;output
        time_vect_v2=time_vect_v2, $  ;output
        period_vect=period_vect       ;output

;;--
;d time_vect = (JulDay_vect_plot - JulDay_vect_plot(0))*(24.*60*60)
dtime     = time_vect(1) - time_vect(0)
time_interval = Max(time_vect) - Min(time_vect)
;d period_min= dtime*3
;d period_max= time_interval/7
;d period_range  = [period_min, period_max]
;d num_periods = 16L
num_times   = N_Elements(time_vect)

;;--
wave_vect = signal_a_vect
get_Wavelet_Transform_of_BComp_vect_STEREO_v3, $
    time_vect, wave_vect, $    ;input
    period_range=period_range, $  ;input
    num_periods=num_periods, $
    Wavlet_arr, $       ;output
    time_vect_v2=time_vect_v2, $
    period_vect=period_vect
wavlet_a_arr  = wavlet_arr
PSD_a_arr  = Abs(wavlet_arr)^2 * dtime

wave_vect = signal_b_vect
get_Wavelet_Transform_of_BComp_vect_STEREO_v3, $
    time_vect, wave_vect, $    ;input
    period_range=period_range, $  ;input
    num_periods=num_periods, $
    Wavlet_arr, $       ;output
    time_vect_v2=time_vect_v2, $
    period_vect=period_vect
wavlet_b_arr  = wavlet_arr
PSD_b_arr  = Abs(wavlet_arr)^2 * dtime
    

;;--
signal_apb_vect  = signal_a_vect + signal_b_vect
signal_amb_vect  = signal_a_vect - signal_b_vect

wave_vect = signal_apb_vect
get_Wavelet_Transform_of_BComp_vect_STEREO_v3, $
    time_vect, wave_vect, $    ;input
    period_range=period_range, $  ;input
    num_periods=num_periods, $
    Wavlet_arr, $       ;output
    time_vect_v2=time_vect_v2, $
    period_vect=period_vect
wavlet_apb_arr  = wavlet_arr
PSD_apb_arr  = Abs(wavlet_arr)^2 * dtime

wave_vect = signal_amb_vect
get_Wavelet_Transform_of_BComp_vect_STEREO_v3, $
    time_vect, wave_vect, $    ;input
    period_range=period_range, $  ;input
    num_periods=num_periods, $
    Wavlet_arr, $       ;output
    time_vect_v2=time_vect_v2, $
    period_vect=period_vect
wavlet_amb_arr  = wavlet_arr
PSD_amb_arr  = Abs(wavlet_arr)^2 * dtime


;;--
SigmaC_arr  = (PSD_apb_arr - PSD_amb_arr) / (PSD_apb_arr + PSD_amb_arr)
SigmaA_arr  = (PSD_a_arr - PSD_b_arr) / (PSD_a_arr + PSD_b_arr)
CC_arr_v1  = Sqrt(SigmaC_arr^2/(1-SigmaA_arr^2)) * (SigmaC_arr/Abs(SigmaC_arr)) ;this is right


;;--
CC_arr_v2  = Real_Part(wavlet_a_arr*ConJ(wavlet_b_arr)) / $
              (Abs(wavlet_a_arr)*Abs(wavlet_b_arr))

              
CorrCoeff_arr = CC_arr_v1
;CorrCoeff_arr = CC_arr_v2


Return

End


;IDL> signal_a_vect=Vx_GSE_vect_plot
;IDL> signal_b_vect=Va_x_GSE_vect_plot
;IDL> get_CorrCoeff_time_period_arr, $
;IDL>         time_vect, signal_a_vect, signal_b_vect, $
;IDL>         period_range=period_range, $  ;input
;IDL>         num_periods=num_periods, $  ;input
;IDL>         CorrCoeff_arr, $  ;output
;IDL>         time_vect_v2=time_vect_v2, $  ;output
;IDL>         period_vect=period_vect       ;output
;% Breakpoint at: GET_CORRCOEFF_TIME_PERIOD_ARR   84 /Work/Data Analysis/MFI data process/Programs/1995-02/get_CorrCoeff_time_period_arr.pro
;IDL> dcc_arr=cc_arr_v1-cc_arr_v2
;IDL> print,max(dcc_arr),min(dcc_arr)
;   3.8759070e-06  -4.2833160e-06
              