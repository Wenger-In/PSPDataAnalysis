Pro get_WavePara_BasedOn_SVD_of_MagF_Sequence, $
      wavlet_Bx_arr, wavlet_By_arr, wavlet_Bz_arr, $
      time_vect, period_vect, $
      Bxyz_LBG_GSE_arr, $
      EigVal_arr, EigVect_arr, $
      PlanarityPolarization_arr=PlanPolar_arr, $
      EplipticPolarization_arr=ElipPolar_arr, $
      SensePolarization_arr=SensePolar_arr, $
      DegreePolarization_arr=DegreePolar_arr
      
       
;;--
num_times   = N_Elements(time_vect)
num_periods = N_Elements(period_vect) 

EigVect_arr  = Fltarr(3, 3, num_times, num_periods)  ;eigvect_time_scale_arr(*,i_eigen,i_time,i_scale)=Reform(V_v2)
EigVal_arr   = Fltarr(3, num_times, num_periods) ;ascending order
PlanPolar_arr = Fltarr(num_times,num_periods)
ElipPolar_arr = Fltarr(num_times,num_periods)
SensePolar_arr= Fltarr(num_times,num_periods)
DegreePolar_arr = Fltarr(num_times,num_periods)
 

;;--
For i_time=0L,num_times-1 Do Begin
For i_scale=0,num_periods-1 Do Begin
  A_arr = Fltarr(3,6)
  A_arr(0,0)  = Real_Part(wavlet_Bx_arr[i_time,i_scale]*ConJ(wavlet_Bx_arr[i_time,i_scale]))  ;R_S11   A_ij=A(j,i)=Real(Bi*ConJ(Bj))
  A_arr(1,0)  = Real_Part(wavlet_Bx_arr[i_time,i_scale]*ConJ(wavlet_By_arr[i_time,i_scale]))  ;R_S12
  A_arr(2,0)  = Real_Part(wavlet_Bx_arr[i_time,i_scale]*ConJ(wavlet_Bz_arr[i_time,i_scale]))  ;R_S13
  A_arr(0,1)  = Real_Part(wavlet_Bx_arr[i_time,i_scale]*ConJ(wavlet_By_arr[i_time,i_scale]))  ;R_S12
  A_arr(1,1)  = Real_Part(wavlet_By_arr[i_time,i_scale]*ConJ(wavlet_By_arr[i_time,i_scale]))  ;R_S22
  A_arr(2,1)  = Real_Part(wavlet_By_arr[i_time,i_scale]*ConJ(wavlet_Bz_arr[i_time,i_scale]))  ;R_S23
  A_arr(0,2)  = Real_Part(wavlet_Bx_arr[i_time,i_scale]*ConJ(wavlet_Bz_arr[i_time,i_scale]))  ;R_S13
  A_arr(1,2)  = Real_Part(wavlet_By_arr[i_time,i_scale]*ConJ(wavlet_Bz_arr[i_time,i_scale]))  ;R_S23
  A_arr(2,2)  = Real_Part(wavlet_Bz_arr[i_time,i_scale]*ConJ(wavlet_Bz_arr[i_time,i_scale]))  ;R_S33
  A_arr(0,3)  = 0.0
  A_arr(1,3)  = -Imaginary(wavlet_Bx_arr[i_time,i_scale]*ConJ(wavlet_By_arr[i_time,i_scale])) ;-I_S12   A_ij=A(j,i)=-Imag(Bi*ConJ(Bj))
  A_arr(2,3)  = -Imaginary(wavlet_Bx_arr[i_time,i_scale]*ConJ(wavlet_Bz_arr[i_time,i_scale])) ;-I_S13
  A_arr(0,4)  = +Imaginary(wavlet_Bx_arr[i_time,i_scale]*ConJ(wavlet_By_arr[i_time,i_scale])) ;+I_S12
  A_arr(1,4)  = 0.0
  A_arr(2,4)  = -Imaginary(wavlet_By_arr[i_time,i_scale]*ConJ(wavlet_Bz_arr[i_time,i_scale])) ;-I_S23
  A_arr(0,5)  = +Imaginary(wavlet_Bx_arr[i_time,i_scale]*ConJ(wavlet_Bz_arr[i_time,i_scale])) ;+I_S13
  A_arr(1,5)  = +Imaginary(wavlet_By_arr[i_time,i_scale]*ConJ(wavlet_Bz_arr[i_time,i_scale])) ;+I_S23
  A_arr(2,5)  = 0.0
  ;;;---
  LA_SVD, A_arr, W, U, V
  ascend_order  = Sort(W)
  W_v2  = W[ascend_order]
  V_v2  = Fltarr((Size(V))[1],(Size(V))[2]) ;3x3
  For i=0,2 Do Begin
    V_v2[i,*] = V[ascend_order[i],*]
  EndFor  
  ;;;---
  For i=0,2 Do Begin
    EigVal_arr[i,i_time,i_scale]    = W_v2[i]
    EigVect_arr[*,i,i_time,i_scale]  = Reform(V_v2[i,*]) 
  EndFor
  ;;;---
  PlanPolar_arr[i_time,i_scale] = 1 - Sqrt(W_v2[0]/W_v2[2])
  ElipPolar_arr[i_time,i_scale] = W_v2[1] / W_v2[2]
  ;;;---calculate the sense of polarity in the plane perpendicular to B0, value above 3 or below -3 indicates high confidence level
  Bxyz_LBG_GSE_vect = Reform(Bxyz_LBG_GSE_arr[*,i_time,i_scale])
  unit_B0_vect  = Bxyz_LBG_GSE_vect / Norm(Bxyz_LBG_GSE_vect)
  unit_x_GSE_vect = [1.,0.,0.]
  unit_x_FAC_vect = CrossP(unit_B0_vect,unit_x_GSE_vect)
  unit_x_FAC_vect = unit_x_FAC_vect / Norm(unit_x_FAC_vect)
  unit_y_FAC_vect = CrossP(unit_B0_vect, unit_x_FAC_vect)
  unit_y_FAC_vect = unit_y_FAC_vect / Norm(unit_y_FAC_vect)
  unit_z_FAC_vect = unit_B0_vect
  wavlet_Bx_FAC_tmp = wavlet_Bx_arr[i_time,i_scale]*unit_x_FAC_vect[0] + $
                      wavlet_By_arr[i_time,i_scale]*unit_x_FAC_vect[1] + $
                      wavlet_Bz_arr[i_time,i_scale]*unit_x_FAC_vect[2]
  wavlet_By_FAC_tmp = wavlet_Bx_arr[i_time,i_scale]*unit_y_FAC_vect[0] + $
                      wavlet_By_arr[i_time,i_scale]*unit_y_FAC_vect[1] + $
                      wavlet_Bz_arr[i_time,i_scale]*unit_y_FAC_vect[2]
  wavlet_Bz_FAC_tmp = wavlet_Bx_arr[i_time,i_scale]*unit_z_FAC_vect[0] + $
                      wavlet_By_arr[i_time,i_scale]*unit_z_FAC_vect[1] + $
                      wavlet_Bz_arr[i_time,i_scale]*unit_z_FAC_vect[2]                      
  Sxx_FAC_tmp = ConJ(wavlet_Bx_FAC_tmp) * wavlet_Bx_FAC_tmp
  Sxy_FAC_tmp = ConJ(wavlet_Bx_FAC_tmp) * wavlet_By_FAC_tmp
  Syy_FAC_tmp = ConJ(wavlet_By_FAC_tmp) * wavlet_By_FAC_tmp
  Szz_FAC_tmp = ConJ(wavlet_Bz_FAC_tmp) * wavlet_Bz_FAC_tmp
  I_Sxy_tmp = Imaginary(Sxy_FAC_tmp)
  M         = 1.
  sigma_I_Sxy_tmp = Sqrt(Sxx_FAC_tmp*Syy_FAC_tmp - Real_Part(Sxy_FAC_tmp)^2 + Imaginary(Sxy_FAC_tmp)^2) / $
                    Sqrt(2*M)
;  SensePolar_arr[i_time,i_scale]  = I_Sxy_tmp / sigma_I_Sxy_tmp
  SensePolar_arr[i_time,i_scale]  = 2*I_Sxy_tmp / (Sxx_FAC_tmp+Syy_FAC_tmp)
  ;;;---presence of a single plane wave will be tested by an estimator of the degree of polarization 
  DegreePolar_arr[i_time,i_scale] = W_v2[2] / (W_v2[0]+W_v2[1]+W_v2[2])
  
EndFor
EndFor


Return

End  
                    
  
  
  

  
  