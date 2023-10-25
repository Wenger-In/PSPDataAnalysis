import python_utils_JSHEPT
from python_utils_JSHEPT import get_plot_WaveletAnalysis_of_var_vect
from python_utils_JSHEPT import get_local_mean_variable
from python_utils_JSHEPT import dE_from_FaradayLaw
from python_utils_JSHEPT import wavelet_reconstruction
from python_utils_JSHEPT import get_PhaseAngle_and_PoyntingFlux_from_E_and_B
from python_utils_JSHEPT import get_PoyntingFlux_r_arr
from python_utils_JSHEPT import get_AlfvenSpeed
from python_utils_JSHEPT import get_ComplexOmega2k_arr

from spacepy import pycdf
import os
import stat
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import matplotlib
import datetime
from mpl_toolkits.mplot3d import Axes3D
import math
from scipy.io import readsav
import julian
from scipy.optimize import least_squares
import sys
from itertools import chain
# a from goto import with_goto
from wavelets import WaveletAnalysis
from wavelets import cwt, Morlet
from pandas.plotting import register_matplotlib_converters
register_matplotlib_converters()

import python_utils_JSHEPT
from python_utils_JSHEPT import get_plot_WaveletAnalysis_of_var_vect
from python_utils_JSHEPT import get_local_mean_variable
from python_utils_JSHEPT import dE_from_FaradayLaw
from python_utils_JSHEPT import wavelet_reconstruction
from python_utils_JSHEPT import get_PhaseAngle_and_PoyntingFlux_from_E_and_B
from python_utils_JSHEPT import get_PoyntingFlux_r_arr
from python_utils_JSHEPT import get_AlfvenSpeed
from python_utils_JSHEPT import get_ComplexOmega2k_arr

# a @with_goto

data_day_str = '20200529'
is_rtn_or_sc_str = '(is_rtn_or_sc=1)'
time_period = '(time=180002-000001)'

#<editor-fold desc="readsav(mag_file)">
dir_fig = 'C:/Users/22242/Documents/STUDY/PSP/Encounter 5/RESULT/Figures/'
dir_data = 'C:/Users/22242/Documents/STUDY/PSP/Encounter 5/RESULT/SaveData/'
# d os.chmod(dir_fig,stat.S_IRWXO+stat.S_IRWXG)
file_data = 'Bxyz_RTN_arr(psp_fld_l2_mag_rtn)' + '(' + data_day_str + ')' + time_period + '.sav'
mag_dict = readsav(dir_data + file_data, idict=None, python_dict=True, uncompressed_file_name=None, verbose=True)
print(mag_dict.keys())
JulDay_B_vect = np.array(mag_dict['julday_vect_save'])
Br_vect = np.array(mag_dict['bx_rtn_vect_save'])
Bt_vect = np.array(mag_dict['by_rtn_vect_save'])
Bn_vect = np.array(mag_dict['bz_rtn_vect_save'])
# Brtn_arr = np.vstack(Br_vect, Bt_vect, Bn_vect)
Bmag_vect = np.sqrt(Br_vect ** 2 + Bt_vect ** 2 + Bn_vect ** 2)
# Bmag_vect= np.linalg.norm(Brtn_arr,axis=-1)
date_B_vect = matplotlib.dates.julian2num(JulDay_B_vect)
#</editor-fold>


"""
i_beg = 0
i_end = len(JulDay_vect)-1
fig,axes = plt.subplots(4,figsize=(14,8))
_ = axes[0].plot_date(date_vect[i_beg:i_end],Br_vect[i_beg:i_end],linewidth=0.5,label='B_R',color='black')
_ = axes[1].plot_date(date_vect[i_beg:i_end],Bt_vect[i_beg:i_end],linewidth=0.5,label='B_T',color='red')
_ = axes[2].plot_date(date_vect[i_beg:i_end],Bn_vect[i_beg:i_end],linewidth=0.5,label='B_N',color='blue')
_ = axes[3].plot_date(date_vect[i_beg:i_end],Bmag_vect[i_beg:i_end],linewidth=0.5,label='B_mag',color='green')
for ax in axes:
    _ = ax.legend()
"""

#<editor-fold desc="readsav(ele_offset_file)">
dir_data = 'C:/Users/22242/Documents/STUDY/PSP/Encounter 5/RESULT/SaveData/'
file_data = 'Electric_Field_Offset_in_RTN_Frame(psp_fld_l2_mag_rtn)(psp_fld_l2_dfb_wf_dvdc_)(psp_swp_spc_l3i)' + '(' + data_day_str + ')' + time_period + '.sav'
ele_dict = readsav(dir_data + file_data, idict=None, python_dict=True, uncompressed_file_name=None, verbose=True)
print(ele_dict.keys())
JulDay_E_vect = np.array(ele_dict['julday_e_offset_vect'])
Et_vect = np.array(ele_dict['et_offset_solar_vect'])
En_vect = np.array(ele_dict['en_offset_solar_vect'])
date_E_vect = matplotlib.dates.julian2num(JulDay_E_vect)
print('len(JulDay_E_vect): ', len(JulDay_E_vect))
#</editor-fold>

#<editor-fold desc="readsav(ele_fitting_file)">
dir_data = 'C:/Users/22242/Documents/STUDY/PSP/Encounter 5/RESULT/SaveData/'
file_data = 'Electric_Field_Fitting_in_RTN_Frame(psp_fld_l2_mag_rtn)(psp_fld_l2_dfb_wf_dvdc_)(psp_swp_spc_l3i)' + '(' + data_day_str + ')' + time_period + '.sav'
ele_dict = readsav(dir_data + file_data, idict=None, python_dict=True, uncompressed_file_name=None, verbose=True)
print(ele_dict.keys())
JulDay_E_fit_vect = np.array(ele_dict['julday_e_vect'])
Et_fit_vect = np.array(ele_dict['et_solar_vect'])
En_fit_vect = np.array(ele_dict['en_solar_vect'])
JulDay_V_vect = np.array(ele_dict['julday_v_vect'])
minus_VxB_T_vect = np.array(ele_dict['minus_vxb_t_solar_vect'])
minus_VxB_N_vect = np.array(ele_dict['minus_vxb_n_solar_vect'])
minus_VxB_T_vect = np.interp(JulDay_E_fit_vect, JulDay_V_vect, minus_VxB_T_vect)
minus_VxB_N_vect = np.interp(JulDay_E_fit_vect, JulDay_V_vect, minus_VxB_N_vect)
date_E_fit_vect = matplotlib.dates.julian2num(JulDay_E_fit_vect)
print('len(JulDay_E_fit_vecct): ', len(JulDay_E_fit_vect))
#</editor-fold>

#<editor-fold desc="readsav(ion_file)">
dir_data = 'C:/Users/22242/Documents/STUDY/PSP/Encounter 5/RESULT/SaveData/'
file_data = 'Np_Wp_Vp_RTN_arr(optimized)(psp_swp_spc_l3i)(20200529)(time=000002-000000).sav'
ion_dict = readsav(dir_data + file_data, idict=None, python_dict=True, uncompressed_file_name=None, verbose=True)
print(ion_dict.keys())
JulDay_ion_vect = np.array(ion_dict['julday_vect_save'])
Np_vect = np.array(ion_dict['np_rtn_vect_save'])
Np_vect = np.reshape(Np_vect, len(Np_vect))
Vr_vect = np.array(ion_dict['vpx_rtn_vect_save'])
Vt_vect = np.array(ion_dict['vpy_rtn_vect_save'])
Vn_vect = np.array(ion_dict['vpz_rtn_vect_save'])
date_ion_vect = matplotlib.dates.julian2num(JulDay_ion_vect)
print('np.shape(Np_vect),np.shape(Vr_vect): ')
print(np.shape(Np_vect), np.shape(Vr_vect))
# a input('Press any key to continue...')
#</editor-fold>

#<editor-fold desc="define 'coeff_for_VxB', 'from_VxB_in_kmpsxnT_to_E_in_mVpm', 'from_E2B_in_mVpm2nT_to_V_in_mps'.">
# {VxB}[km/s].[nT] --> {VxB}*1.e3*1.e-9 [m/s][T]
# --> {VxB}*1.e-6 [V/m] --> {VxB}*1.e-3 [mV/m]
# for comparison with {E} [mV/m]
# therefore, {VxB} should be multiplied with 1.e-3
# on the other hand, dE/dB [mV/m]/[nT] --> 1.e+3[m/s]
coeff_for_VxB = 1.e-3
from_VxB_in_kmpsxnT_to_E_in_mVpm = 1.e-3
from_E2B_in_mVpm2nT_to_V_in_mps = 1.e+6
#</editor-fold>

##
AverNp = np.mean(Np_vect)
AverBmag = np.mean(Bmag_vect)
VA_kmps = get_AlfvenSpeed(AverNp, AverBmag)
print('Np_cm3, Bmag_nT, VA_kmps: ', AverNp, AverBmag, VA_kmps)
input('Press any key to continue...')

#<editor-fold desc="define 'datetime_beg/end', and get 'julday_beg/end'">
##define and set the datetime_beg & datetime_end for analysis and plot
datetime_beg = datetime.datetime(2020, 5, 29, 22, 0, 0)
datetime_end = datetime.datetime(2020, 5, 29, 23, 0, 0)
# datetime_beg = datetime.datetime(2018, 11, 4, 13, 8, 0)
# datetime_end = datetime.datetime(2018, 11, 4, 13, 12, 0)
# datetime_beg = datetime.datetime(2018,11,4,13,22,0)
# datetime_end = datetime.datetime(2018,11,4,13,26,0)
# datetime_beg = datetime.datetime(2018,11,4,17,56,0)
# datetime_end = datetime.datetime(2018,11,4,17,59,0)
# datetime_beg = datetime.datetime(2018,11,4,17,40,0)
# datetime_end = datetime.datetime(2018,11,4,18,0,0)
# datetime_beg = datetime.datetime(2018,11,4,17,51,0)
# datetime_end = datetime.datetime(2018,11,4,17,52,15)
# datetime_beg = datetime.datetime(2018,11,4,22,32,30)
# datetime_end = datetime.datetime(2018,11,4,22,33,30)
# datetime_beg = datetime.datetime(2018, 11, 4, 18, 27, 0)
# datetime_end = datetime.datetime(2018, 11, 4, 18, 31, 0)
# datetime_beg = datetime.datetime(2018,11,4,18,40,0)
# datetime_end = datetime.datetime(2018,11,4,18,50,0)


# print(datetime_beg,datetime_end)
julday_beg = julian.to_jd(datetime_beg)
julday_end = julian.to_jd(datetime_end)
# print(julday_beg,julday_end, np.max(JulDay_vect), np.min(JulDay_vect))
###get 'TimeInterval_str' & 'date_str' to be as parts of the figure file names
year_str = "{0:04d}".format(datetime_beg.year)
month_str = "{0:02d}".format(datetime_beg.month)
day_str = "{0:02d}".format(datetime_beg.day)
hour_beg_str = "{0:02d}".format(datetime_beg.hour)
minute_beg_str = "{0:02d}".format(datetime_beg.minute)
second_beg_str = "{0:02d}".format(datetime_beg.second)
hour_end_str = "{0:02d}".format(datetime_end.hour)
minute_end_str = "{0:02d}".format(datetime_end.minute)
second_end_str = "{0:02d}".format(datetime_end.second)
TimeInterval_str = '(hhmmss=' + hour_beg_str + minute_beg_str + second_beg_str + '-' + \
                   hour_end_str + minute_end_str + second_end_str + ')'
date_str = '(ymd=' + year_str + month_str + day_str + ')'
title_datetime_str = hour_beg_str + ':' + minute_beg_str + ':' + second_beg_str + '-' + \
                     hour_end_str + ':' + minute_end_str + ':' + second_end_str + ' on ' + \
                     year_str + '-' + month_str + '-' + day_str
print('TimeInterval_str: ', TimeInterval_str)
print('date_str: ', date_str)
input('Press any key to continue...')
#</editor-fold>

#<editor-fold desc="get 'Julday_B/E/E_fit/ion_vect_interval', 'Br/Bt/Bn/Et/En/Np/Vr/Vt/Vn_vect_interval'">
sub_B_interval = (JulDay_B_vect >= julday_beg) & (JulDay_B_vect <= julday_end)
JulDay_B_vect_interval = JulDay_B_vect[sub_B_interval]
Br_vect_interval = Br_vect[sub_B_interval]
Bt_vect_interval = Bt_vect[sub_B_interval]
Bn_vect_interval = Bn_vect[sub_B_interval]
print('len(JulDay_B_vect_interval):', len(JulDay_B_vect_interval))
del JulDay_B_vect, date_B_vect, Br_vect, Bt_vect, Bn_vect

sub_E_interval = (JulDay_E_vect >= julday_beg) & (JulDay_E_vect <= julday_end)
JulDay_E_vect_interval = JulDay_E_vect[sub_E_interval]
Et_vect_interval = Et_vect[sub_E_interval]
En_vect_interval = En_vect[sub_E_interval]
print('len(JulDay_E_vect_interval):', len(JulDay_E_vect_interval))
del JulDay_E_vect, date_E_vect, Et_vect, En_vect

sub_E_fit_interval = (JulDay_E_fit_vect >= julday_beg) & (JulDay_E_fit_vect <= julday_end)
JulDay_E_fit_vect_interval = JulDay_E_fit_vect[sub_E_fit_interval]
datenum_E_fit_vect_interval = matplotlib.dates.julian2num(JulDay_E_fit_vect_interval)
Et_fit_vect_interval = Et_fit_vect[sub_E_fit_interval]
En_fit_vect_interval = En_fit_vect[sub_E_fit_interval]
minus_VxB_T_vect_interval = minus_VxB_T_vect[sub_E_fit_interval]
minus_VxB_N_vect_interval = minus_VxB_N_vect[sub_E_fit_interval]
print('len(JulDay_E_fit_vect_interval):', len(JulDay_E_fit_vect_interval))
del JulDay_E_fit_vect, date_E_fit_vect, Et_fit_vect, En_fit_vect, minus_VxB_T_vect, minus_VxB_N_vect

sub_ion_interval = (JulDay_ion_vect >= julday_beg) & (JulDay_ion_vect <= julday_end)
JulDay_ion_vect_interval = JulDay_ion_vect[sub_ion_interval]
Np_vect_interval = Np_vect[sub_ion_interval]
Vr_vect_interval = Vr_vect[sub_ion_interval]
Vt_vect_interval = Vt_vect[sub_ion_interval]
Vn_vect_interval = Vn_vect[sub_ion_interval]
print('len(JulDay_ion_vect_interval):', len(JulDay_ion_vect_interval), len(Np_vect_interval))
del JulDay_ion_vect, date_ion_vect, Np_vect, Vr_vect, Vt_vect, Vn_vect
#</editor-fold>

#<editor-fold desc="get 'julday/datenum_vect_common', 'Br/Bt/Bn/Et/En/Np/Vr/Vt/Vn_vect_interval'.">
dtime_common = 0.01  # unit: s

num_times_common = int((julday_end - julday_beg) / (dtime_common / (24. * 60 * 60))) + 1
# a print('num_times_common: ', num_times_common)
julday_vect_common = np.linspace(julday_beg, julday_end, num_times_common)
datenum_vect_common = matplotlib.dates.julian2num(julday_vect_common)
# a print('np.shape(julday_vect_common, JulDay_B_vect_interval, Br_vect_interval, Np_vect_interval):  ')
# a print(np.shape(julday_vect_common), np.shape(JulDay_B_vect_interval), np.shape(Br_vect_interval), np.shape(Np_vect_interval))

Br_vect_interval = np.interp(julday_vect_common, JulDay_B_vect_interval, Br_vect_interval)
Bt_vect_interval = np.interp(julday_vect_common, JulDay_B_vect_interval, Bt_vect_interval)
Bn_vect_interval = np.interp(julday_vect_common, JulDay_B_vect_interval, Bn_vect_interval)
Et_vect_interval = np.interp(julday_vect_common, JulDay_E_vect_interval, Et_vect_interval)
En_vect_interval = np.interp(julday_vect_common, JulDay_E_vect_interval, En_vect_interval)
Np_vect_interval = np.interp(julday_vect_common, JulDay_ion_vect_interval, Np_vect_interval)
Vr_vect_interval = np.interp(julday_vect_common, JulDay_ion_vect_interval, Vr_vect_interval)
Vt_vect_interval = np.interp(julday_vect_common, JulDay_ion_vect_interval, Vt_vect_interval)
Vn_vect_interval = np.interp(julday_vect_common, JulDay_ion_vect_interval, Vn_vect_interval)
#</editor-fold>

#<editor-fold desc="get 'Et/En_in_SW_vect_interval'.">
##get Et/En_in_SW_vect_interval
Vr_mean = np.mean(Vr_vect_interval)
Vt_mean = np.mean(Vt_vect_interval)
Vn_mean = np.mean(Vn_vect_interval)
Et_in_SW_vect_interval = Et_vect_interval + \
                         ((-Vr_mean * Bn_vect_interval) + (
                                     +Vn_mean * Br_vect_interval)) * from_VxB_in_kmpsxnT_to_E_in_mVpm
En_in_SW_vect_interval = En_vect_interval + \
                         ((+Vr_mean * Bt_vect_interval) + (
                                     -Vt_mean * Br_vect_interval)) * from_VxB_in_kmpsxnT_to_E_in_mVpm
#</editor-fold>

#<editor-fold desc="get 'WaveletCoeff_Br/Bt/Bn_arr', 'SubWave_Br/Bt/Bn_arr', 'sigma_m_arr'.">
time_vect = (julday_vect_common - julday_vect_common[0]) * (24. * 60. * 60)
period_range = [0.1, 5]  # unit: s
num_periods = 16
##get 'WaveletCoeff_Br_arr' & 'SubWave_Br_arr'
var_vect = Br_vect_interval
time_vect, period_vect, wavelet_obj_arr, WaveletCoeff_var_arr, sub_wave_var_arr = get_plot_WaveletAnalysis_of_var_vect( \
    time_vect, var_vect, period_range=period_range, num_periods=num_periods)
WaveletCoeff_Br_arr = WaveletCoeff_var_arr
SubWave_Br_arr = sub_wave_var_arr
##get 'WaveletCoeff_Bt_arr' & 'SubWave_Bt_arr'
var_vect = Bt_vect_interval
time_vect, period_vect, wavelet_obj_arr, WaveletCoeff_var_arr, sub_wave_var_arr = get_plot_WaveletAnalysis_of_var_vect( \
    time_vect, var_vect, period_range=period_range, num_periods=num_periods)
WaveletCoeff_Bt_arr = WaveletCoeff_var_arr
SubWave_Bt_arr = sub_wave_var_arr
##get 'WaveletCoeff_Bn_arr' & 'SubWave_Bn_arr'
var_vect = Bn_vect_interval
time_vect, period_vect, wavelet_obj_arr, WaveletCoeff_var_arr, sub_wave_var_arr = get_plot_WaveletAnalysis_of_var_vect( \
    time_vect, var_vect, period_range=period_range, num_periods=num_periods)
WaveletCoeff_Bn_arr = WaveletCoeff_var_arr
SubWave_Bn_arr = sub_wave_var_arr
##get magnetic helicity
sigma_m_arr = 2 * np.imag(WaveletCoeff_Bt_arr * np.conj(WaveletCoeff_Bn_arr)) / \
              (np.abs(WaveletCoeff_Bt_arr) ** 2 + np.abs(WaveletCoeff_Bn_arr) ** 2)
#</editor-fold>

#<editor-fold desc="get 'WaveletCoeff_Et_arr' & 'SubWave_Et_arr' in the spacecraft (SC) reference frame.">
##get 'WaveletCoeff_Et_arr' & 'SubWave_Et_arr' in the spacecraft (SC) reference frame
var_vect = Et_vect_interval
time_vect, period_vect, wavelet_obj_arr, WaveletCoeff_var_arr, sub_wave_var_arr = get_plot_WaveletAnalysis_of_var_vect( \
    time_vect, var_vect, period_range=period_range, num_periods=num_periods)
wavelet_obj_Et_arr = wavelet_obj_arr
WaveletCoeff_Et_arr = WaveletCoeff_var_arr
SubWave_Et_arr = sub_wave_var_arr
print('scales, periods: ', wavelet_obj_Et_arr.scales, wavelet_obj_Et_arr.fourier_periods)
input('Press any key to continue...')
##get 'WaveletCoeff_En_arr' & 'SubWave_En_arr' in the spacecraft (SC) reference frame
var_vect = En_vect_interval
time_vect, period_vect, wavelet_obj_arr, WaveletCoeff_var_arr, sub_wave_var_arr = get_plot_WaveletAnalysis_of_var_vect( \
    time_vect, var_vect, period_range=period_range, num_periods=num_periods)
wavelet_obj_En_arr = wavelet_obj_arr
WaveletCoeff_En_arr = WaveletCoeff_var_arr
SubWave_En_arr = sub_wave_var_arr
#</editor-fold>

#<editor-fold desc="get 'Br/Bt/Bn/Vr/Vt/Vn_LocalBG_arr'.">
##get 'Br_LocalBG_arr'
var_vect = Br_vect_interval
width2period = 10.0
time_vect, period_vect, var_LocalBG_arr = get_local_mean_variable( \
    time_vect, var_vect, period_range=period_range, num_periods=num_periods, width2period=width2period)
Br_LocalBG_arr = var_LocalBG_arr

##get 'Bt_LocalBG_arr'
var_vect = Bt_vect_interval
width2period = 10.0
time_vect, period_vect, var_LocalBG_arr = get_local_mean_variable( \
    time_vect, var_vect, period_range=period_range, num_periods=num_periods, width2period=width2period)
Bt_LocalBG_arr = var_LocalBG_arr

##get 'Bn_LocalBG_arr'
var_vect = Bn_vect_interval
width2period = 10.0
time_vect, period_vect, var_LocalBG_arr = get_local_mean_variable( \
    time_vect, var_vect, period_range=period_range, num_periods=num_periods, width2period=width2period)
Bn_LocalBG_arr = var_LocalBG_arr

##get 'Vr_LocalBG_arr'
var_vect = Vr_vect_interval
width2period = 10.0
time_vect, period_vect, var_LocalBG_arr = get_local_mean_variable( \
    time_vect, var_vect, period_range=period_range, num_periods=num_periods, width2period=width2period)
Vr_LocalBG_arr = var_LocalBG_arr

##get 'Vt_LocalBG_arr'
var_vect = Vt_vect_interval
width2period = 10.0
time_vect, period_vect, var_LocalBG_arr = get_local_mean_variable( \
    time_vect, var_vect, period_range=period_range, num_periods=num_periods, width2period=width2period)
Vt_LocalBG_arr = var_LocalBG_arr

##get 'Vn_LocalBG_arr'
var_vect = Vn_vect_interval
width2period = 10.0
time_vect, period_vect, var_LocalBG_arr = get_local_mean_variable( \
    time_vect, var_vect, period_range=period_range, num_periods=num_periods, width2period=width2period)
Vn_LocalBG_arr = var_LocalBG_arr
#</editor-fold>

#<editor-fold desc="get 'lambda_arr' (=Vsw_LocalBG_arr*period_arr).">
##get 'lambda_arr' (=Vsw_LocalBG_arr*period_arr)
AbsV_LocalBG_arr = np.sqrt(Vr_LocalBG_arr ** 2 + Vt_LocalBG_arr ** 2 + Vn_LocalBG_arr ** 2)
x_vect = datenum_vect_common
y_vect = period_vect
x_arr, y_arr = np.meshgrid(x_vect, y_vect)
period_arr = np.transpose(y_arr)
lambda_arr = AbsV_LocalBG_arr * period_arr
lambda_vect = np.mean(lambda_arr, axis=0)  # unit: km
#</editor-fold>

#<editor-fold desc="get 'WaveletCoeff_Et/En_in_SW_arr', 'SubWave_Et/En_in_SW_arr'.">
is_LocalBG_or_GlobalBG_flow = 1
is_LocalBG_or_GlobalBG_flow_str = "{0:01d}".format(is_LocalBG_or_GlobalBG_flow)
sub_file_str_for_BG_flow = '(is_LocalBG_or_GlobalBG_flow=' + is_LocalBG_or_GlobalBG_flow_str + ')'
print('is_LocalBG_or_GlobalBG_flow: ', is_LocalBG_or_GlobalBG_flow)
input('Press any key to continue...')
if (is_LocalBG_or_GlobalBG_flow == 1):
    ##get 'WaveletCoeff_Et/En_in_SW_arr', the wavelet coefficients for electric field fluctuations in the solar wind reference frame
    WaveletCoeff_Et_in_SW_arr = WaveletCoeff_Et_arr + \
                                (
                                            -Vr_LocalBG_arr * WaveletCoeff_Bn_arr + Vn_LocalBG_arr * WaveletCoeff_Br_arr) * from_VxB_in_kmpsxnT_to_E_in_mVpm
    WaveletCoeff_En_in_SW_arr = WaveletCoeff_En_arr + \
                                (
                                            +Vr_LocalBG_arr * WaveletCoeff_Bt_arr - Vt_LocalBG_arr * WaveletCoeff_Br_arr) * from_VxB_in_kmpsxnT_to_E_in_mVpm
    ##get 'SubWave_Et_in_SW_arr' through reconstruction based on
    ##the object 'wavelet_obj_Et_arr' & 'WaveletCoeff_Et_in_SW_arr' (the e-field wavelet coefficient in the solar wind reference frame
    wavelet_obj_Et_arr.fourier_periods = period_vect
    wavelet_obj_arr = wavelet_obj_Et_arr
    WaveletCoeff_var_arr = WaveletCoeff_Et_in_SW_arr  # in_SW_arr
    sub_wave_var_arr = wavelet_reconstruction(wavelet_obj_arr, WaveletCoeff_var_arr)
    SubWave_Et_in_SW_arr = sub_wave_var_arr
    ##get 'SubWave_En_in_SW_arr' through reconstruction based on
    ##the object 'wavelet_obj_En_arr' & 'WaveletCoeff_En_in_SW_arr' (the e-field wavelet coefficient in the solar wind reference frame
    wavelet_obj_En_arr.fourier_periods = period_vect
    wavelet_obj_arr = wavelet_obj_En_arr
    WaveletCoeff_var_arr = WaveletCoeff_En_in_SW_arr  # in_SW_arr
    sub_wave_var_arr = wavelet_reconstruction(wavelet_obj_arr, WaveletCoeff_var_arr)
    SubWave_En_in_SW_arr = sub_wave_var_arr
elif (is_LocalBG_or_GlobalBG_flow == 2):
    ###get scalar values 'Vr/Vt/Vn_GlobalBG_scalar'
    Vr_GlobalBG_scalar = np.mean(Vr_vect_interval)
    Vt_GlobalBG_scalar = np.mean(Vt_vect_interval)
    Vn_GlobalBG_scalar = np.mean(Vn_vect_interval)
    ###get 'Et/En_in_SW_vect'
    Et_in_SW_vect = Et_vect_interval + \
                    (
                                -Vr_GlobalBG_scalar * Bn_vect_interval + Vn_GlobalBG_scalar * Br_vect_interval) * from_VxB_in_kmpsxnT_to_E_in_mVpm
    En_in_SW_vect = En_vect_interval + \
                    (
                                +Vr_GlobalBG_scalar * Bt_vect_interval - Vt_GlobalBG_scalar * Br_vect_interval) * from_VxB_in_kmpsxnT_to_E_in_mVpm
    ###get 'WaveletCoeff_En/Et_in_SW_arr' & 'SubWave_Et/En_in_SW_arr'
    var_vect = Et_in_SW_vect
    time_vect, period_vect, wavelet_obj_arr, WaveletCoeff_var_arr, sub_wave_var_arr = get_plot_WaveletAnalysis_of_var_vect( \
        time_vect, var_vect, period_range=period_range, num_periods=num_periods)
    wavelet_obj_Et_arr = wavelet_obj_arr
    WaveletCoeff_Et_in_SW_arr = WaveletCoeff_var_arr
    SubWave_Et_in_SW_arr = sub_wave_var_arr
    var_vect = En_in_SW_vect
    time_vect, period_vect, wavelet_obj_arr, WaveletCoeff_var_arr, sub_wave_var_arr = get_plot_WaveletAnalysis_of_var_vect( \
        time_vect, var_vect, period_range=period_range, num_periods=num_periods)
    wavelet_obj_En_arr = wavelet_obj_arr
    WaveletCoeff_En_in_SW_arr = WaveletCoeff_var_arr
    SubWave_En_in_SW_arr = sub_wave_var_arr
#</editor-fold>

#<editor-fold desc="get 'polarization_E_in_SW_arr' & 'polarization_E_in_SC_arr'.">
##get electric field polarization 'polarization_E_in_SW_arr' & 'polarization_E_in_SC_arr'
polarization_E_in_SW_arr = 2 * np.imag(WaveletCoeff_Et_in_SW_arr * np.conj(WaveletCoeff_En_in_SW_arr)) / \
                           (np.abs(WaveletCoeff_Et_in_SW_arr) ** 2 + np.abs(WaveletCoeff_En_in_SW_arr) ** 2)
polarization_E_in_SC_arr = 2 * np.imag(WaveletCoeff_Et_arr * np.conj(WaveletCoeff_En_arr)) / \
                           (np.abs(WaveletCoeff_Et_arr) ** 2 + np.abs(WaveletCoeff_En_arr) ** 2)
#</editor-fold>

#<editor-fold desc="get 'PhaseAngle_EtEn_in_SW_arr' & 'PhaseAngle_BtBn_arr'.">
###get 'PhaseAngle_EtEn_in_SW_arr' & 'PhaseAngle_BtBn_arr'
PhaseAngle_EtEn_in_SW_arr = np.arctan2(SubWave_Et_in_SW_arr, SubWave_En_in_SW_arr) / np.pi * 180.
PhaseAngle_BtBn_arr = np.arctan2(SubWave_Bt_arr, SubWave_Bn_arr) / np.pi * 180.
#</editor-fold>

#<editor-fold desc="get 'PhaseAngle_from_E_to_B_arr', "PoyntingFlux_r_arr".">
##get the phase angle between dE_in_SW and dB
##According to wave theory, ICW is growing when (ExB.e_r >0 & |phi(dE, dB)|<90) or (ExB.e_r <0 & |phi(dE, dB)|>90)
##According to wave theory, ICW is damping when (ExB.e_r >0 & |phi(dE, dB)|>90) or (ExB.e_r <0 & |phi(dE, dB)|<90)
PhaseAngle_from_E_to_B_arr, PoyntingFlux_r_arr, sub_dJidE_gt_0, sub_dJidE_lt_0, sub_dJedE_gt_0, sub_dJedE_lt_0 = \
    get_PhaseAngle_and_PoyntingFlux_from_E_and_B(SubWave_Et_in_SW_arr, SubWave_En_in_SW_arr, SubWave_Bt_arr,
                                                 SubWave_Bn_arr, Br_LocalBG_arr)
PoyntingFlux_r_arr_from_SubWaves = PoyntingFlux_r_arr
##get 'PoyntingFlux_r_arr'
PoyntingFlux_r_arr = get_PoyntingFlux_r_arr(time_vect, \
                                            WaveletCoeff_Et_in_SW_arr, WaveletCoeff_En_in_SW_arr, \
                                            WaveletCoeff_Bt_arr, WaveletCoeff_Bn_arr)
#</editor-fold>

#<editor-fold desc="get 'omega2k/gamma2k/gamma2omega/omega/gamma_arr'.">
##get 'omega2k/gamma2k_time_period_arr'
ComplexOmega2k_time_period_arr_from_dEn2dBt = -WaveletCoeff_En_in_SW_arr / WaveletCoeff_Bt_arr
ComplexOmega2k_time_period_arr_from_dEt2dBn = +WaveletCoeff_Et_in_SW_arr / WaveletCoeff_Bn_arr
ComplexOmega2k_time_period_arr_from_dEn2dBt *= from_E2B_in_mVpm2nT_to_V_in_mps * 1.e-3  # unit: km/s
ComplexOmega2k_time_period_arr_from_dEt2dBn *= from_E2B_in_mVpm2nT_to_V_in_mps * 1.e-3  # unit: km/s
###revise 'omega2k' & 'gamma2k' to be their opposite ones at the time & period when Poynting Flux is negative
sub_PoyntingFlux_lt_0 = (PoyntingFlux_r_arr < 0)
ComplexOmega2k_time_period_arr_from_dEn2dBt[sub_PoyntingFlux_lt_0] *= -1.
ComplexOmega2k_time_period_arr_from_dEt2dBn[sub_PoyntingFlux_lt_0] *= -1.
###get 'omega2k/gamma2k/gamma2omega'
omega2k_arr_from_dEn2dBt = np.real(ComplexOmega2k_time_period_arr_from_dEn2dBt)
gamma2k_arr_from_dEn2dBt = np.imag(ComplexOmega2k_time_period_arr_from_dEn2dBt)
omega2k_arr_from_dEt2dBn = np.real(ComplexOmega2k_time_period_arr_from_dEt2dBn)
gamma2k_arr_from_dEt2dBn = np.imag(ComplexOmega2k_time_period_arr_from_dEt2dBn)
gamma2omega_arr_from_dEn2dBt = gamma2k_arr_from_dEn2dBt / np.abs(omega2k_arr_from_dEn2dBt)
gamma2omega_arr_from_dEt2dBn = gamma2k_arr_from_dEt2dBn / np.abs(omega2k_arr_from_dEt2dBn)
print('max(omega2k), min(omega2k): ', np.max(omega2k_arr_from_dEn2dBt), np.min(omega2k_arr_from_dEn2dBt))
gamma_arr_from_dEn2dBt = gamma2k_arr_from_dEn2dBt / lambda_arr  # unit: 1/s
gamma_arr_from_dEt2dBn = gamma2k_arr_from_dEt2dBn / lambda_arr  # unit: 1/s
print('period_vect: ', period_vect)
input('Press any key to continue...')

##get 'ComplexOmega2k' based on 'omega/k=dExdB*/dB.dB*' under the  assumption that ek//dExdB
ComplexOmega2k_time_period_arr = get_ComplexOmega2k_arr(time_vect, \
                                                        WaveletCoeff_Et_in_SW_arr, WaveletCoeff_En_in_SW_arr, \
                                                        WaveletCoeff_Bt_arr, WaveletCoeff_Bn_arr)
omega2k_arr = np.real(ComplexOmega2k_time_period_arr)  # unit: km/s
gamma2k_arr = np.imag(ComplexOmega2k_time_period_arr)
lambda_arr_v2 = (AbsV_LocalBG_arr + omega2k_arr) * period_arr
is_add_omega2k_to_lambda = 2
print('is_add_omega2k_to_lambda:', is_add_omega2k_to_lambda)
input('Press any key to continue...')
if (is_add_omega2k_to_lambda == 1):
    lambda_arr = lambda_arr_v2
else:
    lambda_arr = lambda_arr
lambda_vect = np.mean(lambda_arr, axis=0) # update 'lambda_vect'
omega_arr = omega2k_arr / lambda_arr  # unit: 1/s
gamma_arr = gamma2k_arr / lambda_arr  # unit: 1/s
gamma2omega_arr = gamma2k_arr / np.abs(omega2k_arr)
#</editor-fold>

#<editor-foldd desc="get 'theta_BR_arr', 'PSD_Btrace/Bperp/Bpara/_arr', 'PSD_Et/En_in_SW/SC_arr'.">
theta_BR_arr = np.arctan2(np.sqrt(Bt_LocalBG_arr ** 2 + Bn_LocalBG_arr ** 2), Br_LocalBG_arr) * 180 / np.pi
AbsB_LocalBG_arr = np.sqrt(Br_LocalBG_arr ** 2 + Bt_LocalBG_arr ** 2 + Bn_LocalBG_arr ** 2)
ebr_LocalBG_arr = Br_LocalBG_arr / AbsB_LocalBG_arr
ebt_LocalBG_arr = Bt_LocalBG_arr / AbsB_LocalBG_arr
ebn_LocalBG_arr = Bn_LocalBG_arr / AbsB_LocalBG_arr
WaveletCoeff_Bpara_arr = WaveletCoeff_Br_arr * ebr_LocalBG_arr + \
                         WaveletCoeff_Bt_arr * ebt_LocalBG_arr + \
                         WaveletCoeff_Bn_arr * ebn_LocalBG_arr
dtime = np.diff(time_vect).mean()
PSD_Bpara_arr = np.abs(WaveletCoeff_Bpara_arr) ** 2 * (2 * dtime)
PSD_Btrace_arr = (np.abs(WaveletCoeff_Br_arr) ** 2 + np.abs(WaveletCoeff_Bt_arr) ** 2 + np.abs(
    WaveletCoeff_Bn_arr) ** 2) * (2 * dtime)
PSD_Bperp_arr = PSD_Btrace_arr - PSD_Bpara_arr
##
PSD_Et_in_SC_arr = np.abs(WaveletCoeff_Et_arr) ** 2 * (2 * dtime)
PSD_En_in_SC_arr = np.abs(WaveletCoeff_En_arr) ** 2 * (2 * dtime)
PSD_Et_in_SW_arr = np.abs(WaveletCoeff_Et_in_SW_arr) ** 2 * (2 * dtime)
PSD_En_in_SW_arr = np.abs(WaveletCoeff_En_in_SW_arr) ** 2 * (2 * dtime)
PSD_Etn_in_SC_arr = PSD_Et_in_SC_arr + PSD_En_in_SC_arr
PSD_Etn_in_SW_arr = PSD_Et_in_SW_arr + PSD_En_in_SW_arr
#</editor-fold>

#<editor-fold desc="get omega2k & gamma2k & gamma2omega using scipy.optimize.least_squares">
## get omega2k & gamma2k & gamma2omega using scipy.optimize.least_squares
"""
(omega/k+i*gamma/k)*[dBt_complex_obs, dBn_complex_obs]^T = [-dEn_complex_obs, +dEt_complex_obs]^T
[[dBt_complex_obs, 0],[0, dBn_compllex_obs]]x[omega/k+i*gamma/k,omega/k+i*gamma/k]^T = [-dEn_complex_obs, +dEt_compllex_obs]^T
"""
omega2k_kmps_vect = np.zeros(num_periods)
gamma2k_kmps_vect = np.zeros(num_periods)
gamma2omega_vect = np.zeros(num_periods)
for i_period in range(0, num_periods):
    dEt_complex_observe = WaveletCoeff_Et_in_SW_arr[:, i_period]
    dEn_complex_observe = WaveletCoeff_En_in_SW_arr[:, i_period]
    dBt_complex_observe = WaveletCoeff_Bt_arr[:, i_period]
    dBn_complex_observe = WaveletCoeff_Bn_arr[:, i_period]
    VA_kmps = 200.
    omega2k_gamma2k_ini = [VA_kmps, VA_kmps * 0.1]


    def residual_between_dE_obs_and_dE_from_FaradayLaw(omega2k_gamma2k):
        dEt_complex_predict, dEn_complex_predict = dE_from_FaradayLaw(omega2k_gamma2k, dBt_complex_observe,
                                                                      dBn_complex_observe)
        residual_Re_En = np.real(dEn_complex_predict - dEn_complex_observe)
        residual_Im_En = np.imag(dEn_complex_predict - dEn_complex_observe)
        residual_Re_Et = np.real(dEt_complex_predict - dEt_complex_observe)
        residual_Im_Et = np.imag(dEt_complex_predict - dEt_complex_observe)
        residual_vect_tmp = [residual_Re_En, residual_Im_En, residual_Re_Et, residual_Im_Et]
        # a print(type(residual_vect_tmp), np.shape(residual_vect_tmp))
        residual_vect = list(chain.from_iterable(residual_vect_tmp))
        # a print(np.shape(residual_vect))
        return residual_vect


    result_LeastSquares = least_squares(residual_between_dE_obs_and_dE_from_FaradayLaw, omega2k_gamma2k_ini)
    omega2k_gamma2k_fit = result_LeastSquares.x
    omega2k_mps = omega2k_gamma2k_fit[0] * from_E2B_in_mVpm2nT_to_V_in_mps
    gamma2k_mps = omega2k_gamma2k_fit[1] * from_E2B_in_mVpm2nT_to_V_in_mps
    gamma2omega = omega2k_gamma2k_fit[1] / np.abs(omega2k_gamma2k_fit[0])
    # a print('type(omega2k_mps), omega2k_mps: ',type(omega2k_mps), omega2k_mps)
    omega2k_kmps_vect[i_period] = omega2k_mps * 1.e-3
    gamma2k_kmps_vect[i_period] = gamma2k_mps * 1.e-3
    gamma2omega_vect[i_period] = gamma2omega
gamma_s_vect = gamma2k_kmps_vect / lambda_vect
print('omega2k_kmps_vect [km/s]: ', omega2k_kmps_vect)
print('gamma2omega_vect: ', gamma2omega_vect)
print('gamma_s_vect: ', gamma_s_vect)
#</editor-fold>

#<editor-fold desc="plot 'Et/En_fit_vect' & 'minus_VxB_T/N_vect' & 'SubWaves_Et/En_in_SW_vect' & 'SubWaves_Bt/Bn_vect">
###plot 'SubWaves_Et/En_in_SW_vect' & 'SubWaves_Bt/Bn_vect'
file_fig = 'sub-waves of dE & dB' + \
           date_str + TimeInterval_str + sub_file_str_for_BG_flow + '.png'
SubWaves_Et_in_SW_vect = np.sum(SubWave_Et_in_SW_arr, axis=1)
SubWaves_En_in_SW_vect = np.sum(SubWave_En_in_SW_arr, axis=1)
SubWave_Et_in_SW_vect = SubWave_Et_in_SW_arr[:, 0]
SubWave_En_in_SW_vect = SubWave_En_in_SW_arr[:, 0]
SubWaves_Bt_vect = np.sum(SubWave_Bt_arr, axis=1)
SubWaves_Bn_vect = np.sum(SubWave_Bn_arr, axis=1)

cc_Et_Bn = np.corrcoef(SubWaves_Et_in_SW_vect, SubWaves_Bn_vect)
cc_En_Bt = np.corrcoef(SubWaves_En_in_SW_vect, SubWaves_Bt_vect)
print('cc_Et_Bn: ', cc_Et_Bn)
print('cc_En_Bt: ', cc_En_Bt)
input('Press any key to continue...')

fig, axs = plt.subplots(6, 1, figsize=[14, 8], sharex=True)
ax = axs[1 - 1]
ax.plot_date(datenum_E_fit_vect_interval, Et_fit_vect_interval, ls='-', marker='None', color='red')
ax.set_ylabel("$E_T$ [mV/m]")
ax.set_ylim([np.min(Et_fit_vect_interval), np.max(Et_fit_vect_interval)])
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax2 = ax.twinx()  # this is the important function
ax2.plot_date(datenum_E_fit_vect_interval, minus_VxB_T_vect_interval, ls='-', marker='None', color='black')
ax2.set_ylabel(r"$-({\mathrm{V}} \times {\mathrm{B}})_T$ [mV/m]")
ax2.set_ylim([np.min(Et_fit_vect_interval), np.max(Et_fit_vect_interval)])

ax = axs[2 - 1]
ax.plot_date(datenum_E_fit_vect_interval, En_fit_vect_interval, ls='-', marker='None', color='green')
ax.set_ylabel("$E_N$ [mV/m]")
ax.set_ylim([np.min(En_fit_vect_interval), np.max(En_fit_vect_interval)])
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax2 = ax.twinx()  # this is the important function
ax2.plot_date(datenum_E_fit_vect_interval, minus_VxB_N_vect_interval, ls='-', marker='None', color='black')
ax2.set_ylabel(r"$-({\mathrm{V}} \times {\mathrm{B}})_N$ [mV/m]")
ax2.set_ylim([np.min(En_fit_vect_interval), np.max(En_fit_vect_interval)])

ax = axs[3 - 1]
ax.plot_date(datenum_vect_common, SubWaves_Et_in_SW_vect, ls='-', marker='None', color='red', label='$E_t$')
# a ax.plot_date(datenum_vect_common,Et_in_SW_vect_interval,ls='-',marker='None', color='red',label='$E_t$')
ax.set_ylabel("$\delta E_T'$ [mV/m]")
ax.set_ylim([np.percentile(SubWaves_Et_in_SW_vect, 0.1), np.percentile(SubWaves_Et_in_SW_vect, 99.9)])
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax = axs[4 - 1]
ax.plot_date(datenum_vect_common, SubWaves_En_in_SW_vect, ls='-', marker='None', color='blue', label='$E_n$')
# a ax.plot_date(datenum_vect_common,En_in_SW_vect_interval,ls='-',marker='None', color='red',label='$E_n$')
ax.set_ylabel("$\delta E_N'$ [mV/m]")
ax.set_ylim([np.percentile(SubWaves_En_in_SW_vect, 0.1), np.percentile(SubWaves_En_in_SW_vect, 99.9)])
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax = axs[5 - 1]
ax.plot_date(datenum_vect_common, SubWaves_Bt_vect, ls='-', marker='None', color='red', label='$B_t$')
# a ax.plot_date(datenum_vect_common,Bt_vect_interval,ls='-',marker='None',color='red',label='$B_t$')
ax.set_ylabel('$\delta B_T$ [nT]')
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
ax = axs[6 - 1]
ax.plot_date(datenum_vect_common, SubWaves_Bn_vect, ls='-', marker='None', color='blue', label='$B_n$')
# a ax.plot_date(datenum_vect_common,Bn_vect_interval,ls='-',marker='None',color='blue',label='$B_n$')
ax.set_ylabel('$\delta B_N$ [nT]')
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
plt.show()
fig.savefig(dir_fig + file_fig, dpi=150)
#a sys.exit(0)
#</editor-fold>


#<editor-fold desc="plot PSD_B(f), PSD_E(f), omega(f), gamma(f) through 'hexbin' method.">
##plot PSD_B(f), PSD_E(f), omega(f), gamma(f) through 'hexbin' method
x_vect = datenum_vect_common
y_vect = period_vect
num_periods = len(period_vect)
x_arr, y_arr = np.meshgrid(x_vect, y_vect)
period_arr = np.transpose(y_arr)
freq_arr = 1. / period_arr
period_LowerEdge = period_vect[0] ** 2 / period_vect[1]
period_UpperEdge = period_vect[num_periods - 1] ** 2 / period_vect[num_periods - 2]
freq_LowerEdge = 1. / period_UpperEdge
freq_UpperEdge = 1. / period_LowerEdge
###
file_fig = 'PSD_B & PSD_E & omega & gamma' + \
           date_str + TimeInterval_str + sub_file_str_for_BG_flow + '.png'
num_rows = 2
num_columns = 2
fig, axs = plt.subplots(num_rows, num_columns, figsize=[14, 12], sharex=False, sharey=False)
### add a big axis, hide frame
###  hide tick and tick label of the big axis
fig.add_subplot(111, frameon=False)
plt.tick_params(labelcolor='none', top=False, bottom=False, left=False, right=False)
plt.xlabel(title_datetime_str)  # "freq in SC-frame [Hz]")
plt.ylabel("$~$")
###
ax = axs[0, 0]
x_arr = freq_arr
y_arr = PSD_Bperp_arr
gridsize = [num_periods, 50]
cmap_str = 'inferno'
title_str = "$PDF(f,~PSD(B_\perp))$"
xlabel_str = "freq in SC-frame [Hz]"
ylabel_str = "$PSD(B_\perp)$"
xmin = freq_LowerEdge  # np.min(x_arr)
xmax = freq_UpperEdge  # np.max(x_arr)
ymin = np.min(y_arr)
ymax = np.max(y_arr)
extent = [np.log10(xmin), np.log10(xmax), np.log10(ymin), np.log10(ymax)]
hb = ax.hexbin(x_arr, y_arr, gridsize=gridsize, cmap=cmap_str, xscale='log', yscale='log', bins='log', extent=extent)
ax.axis([xmin, xmax, ymin, ymax])
ax.set_title(title_str)
ax.set_xscale('log')
ax.set_yscale('log')
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
cb = fig.colorbar(hb, ax=ax)
###
ax = axs[0, 1]
x_arr = freq_arr
y_arr = PSD_Etn_in_SW_arr
gridsize = [num_periods, 50]
cmap_str = 'inferno'
title_str = "$PDF(f,~PSD(E_{t,n}'))$"
xlabel_str = "freq in SC-frame [Hz]"
ylabel_str = "$PSD(E_{t,n}')$"
xmin = freq_LowerEdge  # np.min(x_arr)
xmax = freq_UpperEdge  # np.max(x_arr)
ymin = np.min(y_arr)
ymax = np.max(y_arr)
extent = [np.log10(xmin), np.log10(xmax), np.log10(ymin), np.log10(ymax)]
hb = ax.hexbin(x_arr, y_arr, gridsize=gridsize, cmap=cmap_str, xscale='log', yscale='log', bins='log', extent=extent)
ax.axis([xmin, xmax, ymin, ymax])
ax.set_title(title_str)
ax.set_xscale('log')
ax.set_yscale('log')
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
cb = fig.colorbar(hb, ax=ax)
###
ax = axs[1, 0]
x_arr = freq_arr
y_arr = omega_arr
gridsize = [num_periods, 50]
cmap_str = 'inferno'
title_str = "$PDF(f,~\omega)$"
xlabel_str = "freq in SC-frame [Hz]"
ylabel_str = "$\omega$ [1/s]"
xmin = freq_LowerEdge  # np.min(x_arr)
xmax = freq_UpperEdge  # np.max(x_arr)
ymin = np.percentile(y_arr, 1)
ymax = np.percentile(y_arr, 99)
extent = [np.log10(xmin), np.log10(xmax), ymin, ymax]
hb = ax.hexbin(x_arr, y_arr, gridsize=gridsize, cmap=cmap_str, xscale='log', yscale='linear', bins='log', extent=extent)
ax.axis([xmin, xmax, ymin, ymax])
ax.set_title(title_str)
ax.set_xscale('log')
ax.set_yscale('linear')
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
cb = fig.colorbar(hb, ax=ax)
###
ax = axs[1, 1]
x_arr = freq_arr
y_arr = gamma_arr
gridsize = [num_periods, 50]
cmap_str = 'inferno'
title_str = "$PDF(f,~\gamma)$"
xlabel_str = "freq in SC-frame [Hz]"
ylabel_str = "$\gamma$ [1/s]"
xmin = freq_LowerEdge  # np.min(x_arr)
xmax = freq_UpperEdge  # np.max(x_arr)
ymin = np.percentile(y_arr, 1)
ymax = np.percentile(y_arr, 99)
extent = [np.log10(xmin), np.log10(xmax), ymin, ymax]
hb = ax.hexbin(x_arr, y_arr, gridsize=gridsize, cmap=cmap_str, xscale='log', yscale='linear', bins='log', extent=extent)
ax.axis([xmin, xmax, ymin, ymax])
ax.set_title(title_str)
ax.set_xscale('log')
ax.set_yscale('linear')
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
cb = fig.colorbar(hb, ax=ax)
###
plt.show()
fig.savefig(dir_fig + file_fig, dpi=150)
# sys.exit(0)
#</editor-fold>


'''
#<editor-fold desc="plot 'omega2k_vect' & 'gamma_s_vect' & 'gamma2omega_vect', which are obtained using scipy.optimize.least_squares">
###plot 'omega2k_vect' & 'gamma_s_vect' & 'gamma2omega_vect'
file_fig = 'omega2k & gamma2k over period' + \
           date_str + TimeInterval_str + sub_file_str_for_BG_flow + '.png'
fig, axs = plt.subplots(3, figsize=[10, 15], sharex=True)
ax = axs[0]
ax.plot(period_vect, omega2k_kmps_vect, ls='-', marker='', color='black')
ax.set_xlabel("period [s]")
ax.set_xscale('log')
ax.set_ylabel("$\omega/k$ [km/s]")
ax = axs[1]
ax.plot(period_vect, gamma_s_vect, ls='-', marker='', color='black')
ax.set_xlabel("period [s]")
ax.set_xscale('log')
ax.set_ylabel("$\gamma$ [1/s]")
ax = axs[2]
ax.plot(period_vect, gamma2omega_vect, ls='-', marker='', color='black')
ax.set_xlabel("period [s]")
ax.set_xscale('log')
ax.set_ylabel("$\gamma/\omega$")
plt.show()
fig.savefig(dir_fig + file_fig, dpi=150)
# a sys.exit(0)
#</editor-fold>
'''

#<editor-fold desc="TV 'theta_BR_arr' &  'PSD_Btrace/Bperp/Bpara_arr' & ‘PSD_Et/En_arr’ & 'magnetic helicity' & 'electric field polarization'.">
print("TV 'theta_BR_arr' &  'PSD_Btrace/Bperp/Bpara_arr' & ‘PSD_Et/En_arr’ & 'magnetic helicity' & 'electric field polarization'.")
# a goto.get_omega2k_gamma2k
##TV 'theta_BR_arr' &  'PSD_Btrace/Bperp/Bpara_arr' & ‘PSD_Et/En_arr’ & 'magnetic helicity' & 'electric field polarization'

file_fig = 'PSD_B & PSD_E & B-helicity & E-polar & theta_BR' + \
           date_str + TimeInterval_str + sub_file_str_for_BG_flow + '.png'
num_rows = 5 + 2
num_columns = 1
fig, axs = plt.subplots(num_rows, num_columns, figsize=[14, 16], sharex=True, sharey=True)
### add a big axis, hide frame
###  hide tick and tick label of the big axis
fig.add_subplot(111, frameon=False)
plt.tick_params(labelcolor='none', top=False, bottom=False, left=False, right=False)
plt.xlabel("$~$")
plt.ylabel("period [s]")
###
x_vect = datenum_vect_common
y_vect = period_vect
x_arr, y_arr = np.meshgrid(x_vect, y_vect)
xlim = [np.min(x_vect), np.max(x_vect)]
ylim = [np.min(y_vect), np.max(y_vect)]
###TV 'theta_BR_arr'
i_row = 1 - 1
i_column = 0
img_arr = np.transpose(theta_BR_arr)
title_str = '$\\theta_{\mathrm{BR}}$'
cmap_str = 'jet'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, vmin=img_arr.min(), vmax=img_arr.max())
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, norm=colors.LogNorm(vmin=img_arr.min(), vmax=img_arr.max()), )
ax.set_yscale('log')

###TV 'PSD_En_arr'
i_row = 5 - 1
i_column = 0
img_arr = np.transpose(PSD_En_in_SW_arr)
title_str = "$PSD(E_n')$"
cmap_str = 'jet'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, norm=colors.LogNorm(vmin=img_arr.min(), vmax=img_arr.max()), )
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

###
i_row = 4 - 1
i_column = 0
img_arr = np.transpose(PSD_Et_in_SW_arr)
title_str = "$PSD(E_t')$"
cmap_str = 'jet'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, norm=colors.LogNorm(vmin=img_arr.min(), vmax=img_arr.max()), )
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

###TV 'PSD_Bpara_arr'
i_row = 3 - 1
i_column = 0
img_arr = np.transpose(PSD_Bpara_arr)
title_str = '$PSD(B_\parallel)$'
cmap_str = 'jet'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, norm=colors.LogNorm(vmin=img_arr.min(), vmax=img_arr.max()), )
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

###
i_row = 2 - 1
i_column = 0
img_arr = np.transpose(PSD_Bperp_arr)
title_str = '$PSD(B_\perp)$'
cmap_str = 'jet'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, norm=colors.LogNorm(vmin=img_arr.min(), vmax=img_arr.max()), )
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

###TV magnetic helicity 'sigma_m_arr'
i_row = 6 - 1
i_column = 0
img_arr = np.transpose(sigma_m_arr)
level_vect = [-0.7]
color_vect = ['white']
title_str = '$\sigma_m$'
cmap_str = 'jet'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str)
# a cs = ax.contour(x_arr,y_arr,img_arr,levels=level_vect,colors=color_vect,linestyle='solid')
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

###TV polarization of electric field
i_row = 7 - 1
i_column = 0
img_arr = np.transpose(polarization_E_in_SW_arr)
level_vect = [-0.7]
color_vect = ['white']
title_str = "$E'\mathrm{-polarization~about~R}$"
cmap_str = 'jet'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str)
# a cs = ax.contour(x_arr,y_arr,img_arr,levels=level_vect,colors=color_vect,linestyle='solid')
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

###
fig.autofmt_xdate()  # This simply sets the x-axis data to diagonal so it fits better.
plt.show()
fig.savefig(dir_fig + file_fig, dpi=150)
#</editor-fold>

'''
##plot the histogram of 'PhaseAngle_from_E_to_B_arr' before TV 'PhaseAngle_from_E_to_B_arr' in the time & period space
binwidth = 10.0
var_arr_for_hist = PhaseAngle_from_E_to_B_arr
xlabel_str = '$\phi(\delta E_{sw}, \delta B)$'
ylabel_str = 'counts #'
lim = np.ceil(np.abs(var_arr_for_hist).max() / binwidth) * binwidth
bins = np.arange(-lim, lim + binwidth, binwidth)
fig,ax=plt.subplots()
ax.hist(var_arr_for_hist[:,2:7], bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
plt.show()
'''


'''
#<editor-fold desc="plot the histograms of 'PhaseAngle_from_E_to_B_arr' & 'PoyntingFlux_r_arr'.">
"""
##plot the histograms of 'PhaseAngle_from_E_to_B_arr' & 'PoyntingFlux_r_arr'
file_fig = 'Histograms of Phi_EB & PoyntingFlux' + \
           date_str + TimeInterval_str + sub_file_str_for_BG_flow + '.png'
num_rows = 1
num_columns = 2
fig, axs = plt.subplots(num_rows, num_columns, figsize=[14, 7], sharex=False)
i_period_min_plot = 2
i_period_max_plot = 9
period_vect_plot = period_vect[i_period_min_plot:i_period_max_plot]
label_period_vect = list(map("{:.3f}".format, period_vect_plot))
###plot the histogram of 'PhaseAngle_from_E_to_B_arr'
ax = axs[0]
var_arr_for_hist = PhaseAngle_from_E_to_B_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\phi(\delta \mathbf{E}', \delta \mathbf{B})$"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = -180.  # np.percentile(var_arr_for_hist, 5)
var_max = +180.  # np.percentile(var_arr_for_hist, 95)
num_bins = 36
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)
###plot the histogram of 'PoyntingFlux_r_arr'
ax = axs[1]
var_arr_for_hist = PoyntingFlux_r_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\mathrm{Poynting-Flux}(\sim\delta \mathbf{E}' x \delta \mathbf{B})~~[\mathrm{watt/m^2}]$"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = np.percentile(var_arr_for_hist, 5)
var_max = np.percentile(var_arr_for_hist, 95)
num_bins = 20
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)

plt.show()
fig.savefig(dir_fig + file_fig, dpi=150)
"""
#</editor-fold>

#<editor-fold desc="TV Phi_EB & PoyntingFlux & Phi_EtEn & Phi_BtBn in time-period space.">
"""
##TV 'PhaseAngle_from_E_to_B_arr' & 'PoyntingFlux_r_arr'
###
file_fig = 'Phi_EB & PoyntingFlux & Phi_EtEn & Phi_BtBn in time-period space' + \
           date_str + TimeInterval_str + sub_file_str_for_BG_flow + '.png'
num_rows = 4
num_columns = 1
fig, axs = plt.subplots(num_rows, num_columns, figsize=[14, 10], sharex=True, sharey=True)
### add a big axis, hide frame
###  hide tick and tick label of the big axis
fig.add_subplot(111, frameon=False)
plt.tick_params(labelcolor='none', top=False, bottom=False, left=False, right=False)
plt.xlabel("$~$")
plt.ylabel("period [s]")
###
x_vect = datenum_vect_common
y_vect = period_vect
xlim = [np.min(x_vect), np.max(x_vect)]
ylim = [np.min(y_vect), np.max(y_vect)]

###TV 'PoyntingFlux_r_arr'
i_row = 1 - 1
i_column = 0
img_arr = np.transpose(PoyntingFlux_r_arr)
# a img_arr = np.transpose(PoyntingFlux_r_arr_from_SubWaves)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min, val_max]))
val_max = -val_min
val_linthresh = abs(val_max) / 1.e3
val_linscale = 0.1
title_str = '$\mathrm{Poynting-Flux~~[watt/m^2/Hz]}$'
cmap_str = 'seismic'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
# a img = ax.pcolormesh(x_arr,y_arr,img_arr,cmap=cmap_str,vmin=val_min,vmax=val_max)
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, \
                    norm=colors.SymLogNorm(linthresh=val_linthresh, linscale=val_linscale, \
                                           vmin=val_min, vmax=val_max))
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

###TV 'PhaseAngle_from_E_to_B_arr'
i_row = 1
i_column = 0
img_arr = np.transpose(PhaseAngle_from_E_to_B_arr)
level_vect = [90.]
color_vect = ['white']
title_str = "$\Phi(\delta \mathbf{E}', \delta \mathbf{B})$"
cmap_str = 'hsv'  # cyclic colormap
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str)
# a cs = ax.contour(x_arr,y_arr,img_arr,levels=level_vect,colors=color_vect)
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%Y-%m-%d %H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

###TV 'PhaseAngle_EtEn_in_SW_arr'
i_row = 3 - 1
i_column = 0
img_arr = np.transpose(PhaseAngle_EtEn_in_SW_arr)
title_str = "$\phi (\delta E_t',\delta E_n')$"
cmap_str = 'hsv'  # cyclic colormap
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str)
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%Y-%m-%d %H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

###TV 'PhaseAngle_BtBn_arr'
i_row = 4 - 1
i_column = 0
img_arr = np.transpose(PhaseAngle_BtBn_arr)
title_str = "$\phi (\delta B_t,\delta B_n)$"
cmap_str = 'hsv'  # cyclic colormap
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str)
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%Y-%m-%d %H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

###
fig.autofmt_xdate()  # This simply sets the x-axis data to diagonal so it fits better.
plt.show()
fig.savefig(dir_fig + file_fig, dpi=150)
"""
#</editor-fold>

# beg xx2
'''
is_skip = 1
if (is_skip == 0):
    ##plot the histogram of 'gamma2omega_arr' before TV it in the time & period space
    file_fig = 'histograms of omega2k & gamma2k & gamma2AbsOmega'+\
            date_str+TimeInterval_str+sub_file_str_for_BG_flow+'.png'
    num_rows = 3
    num_columns = 2
    fig, axs = plt.subplots(num_rows, num_columns,figsize=[14,20])
    i_period_min_plot = 2
    i_period_max_plot = 9
    period_vect_plot = period_vect[i_period_min_plot:i_period_max_plot]
    label_period_vect = list(map("{:.3f}".format,period_vect_plot))
    ###plot the histogrm of 'gamma2omega' from 'dEn2dBt'
    ax = axs[0,0]
    var_arr_for_hist = gamma2omega_arr_from_dEn2dBt[:,i_period_min_plot:i_period_max_plot]
    xlabel_str = "$\gamma/|\omega|~(\mathrm{from} -\delta \widetilde{E}_n'/\delta \widetilde{B}_t)$"
    ylabel_str = 'counts #'
    title_str = title_datetime_str
    var_min = np.percentile(var_arr_for_hist, 5)
    var_max = np.percentile(var_arr_for_hist, 95)
    num_bins = 20
    bins = np.linspace(var_min, var_max, num_bins)
    print('bins: ', bins)
    ax.hist(var_arr_for_hist, bins=bins)
    ax.set_xlabel(xlabel_str)
    ax.set_ylabel(ylabel_str)
    ax.set_title(title_str)
    ax.legend(label_period_vect)
    ###plot the histogrm of 'gamma2omega' from 'dEt2dBn'
    ax = axs[0,1]
    var_arr_for_hist = gamma2omega_arr_from_dEt2dBn[:,i_period_min_plot:i_period_max_plot]
    xlabel_str = "$\gamma/|\omega|~(\mathrm{from} +\delta \widetilde{E}_t'/\delta \widetilde{B}_n)$"
    ylabel_str = 'counts #'
    title_str = title_datetime_str
    var_min = np.percentile(var_arr_for_hist, 5)
    var_max = np.percentile(var_arr_for_hist, 95)
    num_bins = 20
    bins = np.linspace(var_min, var_max, num_bins)
    print('bins: ', bins)
    ax.hist(var_arr_for_hist, bins=bins)
    ax.set_xlabel(xlabel_str)
    ax.set_ylabel(ylabel_str)
    ax.set_title(title_str)
    ax.legend(label_period_vect)
    ###plot the histogrm of 'omega2k' from 'dEn2dBt'
    ax = axs[1,0]
    var_arr_for_hist = omega2k_arr_from_dEn2dBt[:,i_period_min_plot:i_period_max_plot]
    xlabel_str = "$\omega/k~(\mathrm{from} -\delta \widetilde{E}_n'/\delta \widetilde{B}_t)~~[\mathrm{km/s}]$"
    ylabel_str = 'counts #'
    title_str = title_datetime_str
    var_min = np.percentile(var_arr_for_hist, 5)
    var_max = np.percentile(var_arr_for_hist, 95)
    num_bins = 20
    bins = np.linspace(var_min, var_max, num_bins)
    print('bins: ', bins)
    ax.hist(var_arr_for_hist, bins=bins)
    ax.set_xlabel(xlabel_str)
    ax.set_ylabel(ylabel_str)
    ax.set_title(title_str)
    ax.legend(label_period_vect)
    ###plot the histogrm of 'omega2k' from 'dEt2dBn'
    ax = axs[1,1]
    var_arr_for_hist = omega2k_arr_from_dEt2dBn[:,i_period_min_plot:i_period_max_plot]
    xlabel_str = "$\omega/k~(\mathrm{from} +\delta \widetilde{E}_t'/\delta \widetilde{B}_n)~~[\mathrm{km/s}]$"
    ylabel_str = 'counts #'
    var_min = np.percentile(var_arr_for_hist, 5)
    var_max = np.percentile(var_arr_for_hist, 95)
    num_bins = 20
    bins = np.linspace(var_min, var_max, num_bins)
    print('bins: ', bins)
    ax.hist(var_arr_for_hist, bins=bins)
    ax.set_xlabel(xlabel_str)
    ax.set_ylabel(ylabel_str)
    ax.legend(label_period_vect)
    ###plot the histogrm of 'gamma2k' from 'dEn2dBt'
    ax = axs[2,0]
    var_arr_for_hist = gamma2k_arr_from_dEn2dBt[:,i_period_min_plot:i_period_max_plot]
    xlabel_str = "$\gamma/k~(\mathrm{from} -\delta \widetilde{E}_n'/\delta \widetilde{B}_t)$"
    ylabel_str = 'counts #'
    title_str = title_datetime_str
    var_min = np.percentile(var_arr_for_hist, 5)
    var_max = np.percentile(var_arr_for_hist, 95)
    num_bins = 20
    bins = np.linspace(var_min, var_max, num_bins)
    print('bins: ', bins)
    ax.hist(var_arr_for_hist, bins=bins)
    ax.set_xlabel(xlabel_str)
    ax.set_ylabel(ylabel_str)
    ax.set_title(title_str)
    ax.legend(label_period_vect)
    ###plot the histogrm of 'gamma2k' from 'dEt2dBn'
    ax = axs[2,1]
    var_arr_for_hist = gamma2k_arr_from_dEt2dBn[:,i_period_min_plot:i_period_max_plot]
    xlabel_str = "$\gamma/k~(\mathrm{from} +\delta \widetilde{E}_t'/\delta \widetilde{B}_n)$"
    ylabel_str = 'counts #'
    title_str = title_datetime_str
    var_min = np.percentile(var_arr_for_hist, 5)
    var_max = np.percentile(var_arr_for_hist, 95)
    num_bins = 20
    bins = np.linspace(var_min, var_max, num_bins)
    print('bins: ', bins)
    ax.hist(var_arr_for_hist, bins=bins)
    ax.set_xlabel(xlabel_str)
    ax.set_ylabel(ylabel_str)
    ax.set_title(title_str)
    ax.legend(label_period_vect)

    plt.show()
    fig.savefig(dir_fig+file_fig, dpi=150)
'''
# end xx2

#<editor-fold desc="plot the histograms of 'omega2k' & 'gamma2k' & 'gamma/|omega|' & 'gamma'.">
"""
##plot the histogram of 'gamma2omega_arr' before TV it in the time & period space
file_fig = 'histograms of omega2k & gamma2k & gamma2AbsOmega' + \
           date_str + TimeInterval_str + sub_file_str_for_BG_flow + '.png'
num_rows = 2
num_columns = 2
fig, axs = plt.subplots(num_rows, num_columns, figsize=[14, 14])
i_period_min_plot = 2
i_period_max_plot = 9
period_vect_plot = period_vect[i_period_min_plot:i_period_max_plot]
label_period_vect = list(map("{:.3f}".format, period_vect_plot))
###plot the histogrm of 'gamma2omega'
ax = axs[0, 0]
var_arr_for_hist = omega2k_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\omega/k$ [km/s]"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = np.percentile(var_arr_for_hist, 5)
var_max = np.percentile(var_arr_for_hist, 95)
num_bins = 20
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)
###plot the histogrm of 'gamma2omega'
ax = axs[0, 1]
var_arr_for_hist = gamma2k_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\gamma/k$ [km/s]"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = np.percentile(var_arr_for_hist, 5)
var_max = np.percentile(var_arr_for_hist, 95)
num_bins = 20
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)
###plot the histogrm of 'omega2k'
ax = axs[1, 0]
var_arr_for_hist = gamma2omega_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\gamma/|\omega|$"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = np.percentile(var_arr_for_hist, 5)
var_max = np.percentile(var_arr_for_hist, 95)
num_bins = 20
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)
###plot the histogrm of 'omega2k' from 'dEt2dBn'
ax = axs[1, 1]
var_arr_for_hist = gamma_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\gamma~~[\mathrm{1/s}]$"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = np.percentile(var_arr_for_hist, 5)
var_max = np.percentile(var_arr_for_hist, 95)
num_bins = 20
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)

plt.show()
fig.savefig(dir_fig + file_fig, dpi=150)
"""
#</editor-fold>
'''

#<editor-fold desc="plot the histograms of 'PoyntingFlux' & 'Phi_EB' & 'omega2k' & 'gamma2k' & 'gamma/|omega|' & 'gamma'.">
print("plot the histograms of 'PoyntingFlux' & 'Phi_EB' & 'omega2k' & 'gamma2k' & 'gamma/|omega|' & 'gamma'.")
##plot the histogram of 'gamma2omega_arr' before TV it in the time & period space
file_fig = 'histograms of omega2k & gamma2k & gamma2AbsOmega' + \
           date_str + TimeInterval_str + sub_file_str_for_BG_flow + '.png'
num_rows = 3
num_columns = 2
fig, axs = plt.subplots(num_rows, num_columns, figsize=[14, 21])
i_period_min_plot = 2
i_period_max_plot = 9
period_vect_plot = period_vect[i_period_min_plot:i_period_max_plot]
label_period_vect = list(map("{:.3f}".format, period_vect_plot))
###plot the histogram of 'PhaseAngle_from_E_to_B_arr'
ax = axs[0,1]
var_arr_for_hist = PhaseAngle_from_E_to_B_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\phi(\delta \mathbf{E}', \delta \mathbf{B})$"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = -180.  # np.percentile(var_arr_for_hist, 5)
var_max = +180.  # np.percentile(var_arr_for_hist, 95)
num_bins = 36
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)
###plot the histogram of 'PoyntingFlux_r_arr'
ax = axs[0,0]
var_arr_for_hist = PoyntingFlux_r_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\mathrm{Poynting-Flux}(\sim\delta \mathbf{E}' x \delta \mathbf{B})~~[\mathrm{watt/m^2}]$"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = np.percentile(var_arr_for_hist, 5)
var_max = np.percentile(var_arr_for_hist, 95)
num_bins = 20
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)
###plot the histogrm of 'omega2k'
ax = axs[1, 0]
var_arr_for_hist = omega2k_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\omega/k$ [km/s]"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = np.percentile(var_arr_for_hist, 5)
var_max = np.percentile(var_arr_for_hist, 95)
num_bins = 20
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)
###plot the histogrm of 'gamma2k'
ax = axs[1, 1]
var_arr_for_hist = gamma2k_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\gamma/k$ [km/s]"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = np.percentile(var_arr_for_hist, 5)
var_max = np.percentile(var_arr_for_hist, 95)
num_bins = 20
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)
###plot the histogrm of 'gamma2omega'
ax = axs[2, 0]
var_arr_for_hist = gamma2omega_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\gamma/|\omega|$"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = np.percentile(var_arr_for_hist, 5)
var_max = np.percentile(var_arr_for_hist, 95)
num_bins = 20
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)
###plot the histogrm of 'gamma'
ax = axs[2, 1]
var_arr_for_hist = gamma_arr[:, i_period_min_plot:i_period_max_plot]
xlabel_str = "$\gamma~~[\mathrm{1/s}]$"
ylabel_str = 'counts #'
title_str = title_datetime_str
var_min = np.percentile(var_arr_for_hist, 5)
var_max = np.percentile(var_arr_for_hist, 95)
num_bins = 20
bins = np.linspace(var_min, var_max, num_bins)
print('bins: ', bins)
ax.hist(var_arr_for_hist, bins=bins)
ax.set_xlabel(xlabel_str)
ax.set_ylabel(ylabel_str)
ax.set_title(title_str)
ax.legend(label_period_vect)

plt.show()
fig.savefig(dir_fig + file_fig, dpi=150)
#</editor-fold>

'''
#<editor-fold desc="TV 'omega2k/gamma2k/gamma2omega/gamma_arr'.">
"""
##TV 'omega2k/gamma2k/gamma2omega/gamma_arr'
file_fig = 'omega2k & gamma2k & gamma2AbsOmega in time-period' + \
           date_str + TimeInterval_str + sub_file_str_for_BG_flow + '.png'
num_rows = 4
num_columns = 1
fig, axs = plt.subplots(num_rows, num_columns, figsize=[14, 12], sharex=True, sharey=True)
### add a big axis, hide frame
###  hide tick and tick label of the big axis
fig.add_subplot(111, frameon=False)
plt.tick_params(labelcolor='none', top=False, bottom=False, left=False, right=False)
plt.xlabel("$~$")
plt.ylabel("period [s]")
###
x_vect = datenum_vect_common
y_vect = period_vect
x_arr, y_arr = np.meshgrid(x_vect, y_vect)
xlim = [np.min(x_vect), np.max(x_vect)]
ylim = [np.min(y_vect), np.max(y_vect)]

###TV 'omega2k_arr'
i_row = 0
i_column = 0
img_arr = np.transpose(omega2k_arr)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min, val_max]))
val_max = -val_min
title_str = "$\omega/k~~\mathrm{[km/s]}$"
cmap_str = 'PiYG'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, vmin=val_min, vmax=val_max)
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

# a fig.autofmt_xdate() # This simply sets the x-axis data to diagonal so it fits better.
# a  plt.show()

###TV 'gamma2k_arr'
i_row = 1
i_column = 0
img_arr = np.transpose(gamma2k_arr)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min, val_max]))
val_max = -val_min
title_str = "$\gamma/k~~\mathrm{[km/s]}$"
cmap_str = 'PiYG'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, vmin=val_min, vmax=val_max)
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

###TV 'gamma2omega_arr'
i_row = 2
i_column = 0
img_arr = np.transpose(gamma2omega_arr)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min,val_max]))
val_max = -val_min
title_str = "$\gamma/|\omega|$"
cmap_str = 'seismic'
ax = axs[i_row]
#a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr,y_arr,img_arr,cmap=cmap_str,vmin=val_min,vmax=val_max)
ax.set_xlim(xlim[0],xlim[1])
ax.set_ylim(ylim[0],ylim[1])
ax.xaxis_date() # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
#a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

###TV 'gamma_arr'
i_row = 3
i_column = 0
img_arr = np.transpose(gamma_arr)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min, val_max]))
val_max = -val_min
# a title_str = "$\gamma/k~(\sim -\delta \widetilde{E}_n'/\delta \widetilde{B}_t)~\mathrm{[km/s]}$'
title_str = "$\gamma~~\mathrm{[1/s]}$"
cmap_str = 'seismic'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, vmin=val_min, vmax=val_max)
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

fig.autofmt_xdate()  # This simply sets the x-axis data to diagonal so it fits better.
plt.show()
fig.savefig(dir_fig + file_fig, dpi=150)
"""
#</editor-fold>
'''

#<editor-fold desc="TV 'PoyntingFlux/Phi_EB/omega2k/gamma2k/gamma2omega/gamma_arr'.">
##TV 'omega2k/gamma2k/gamma2omega/gamma_arr'
file_fig = 'PoyntingFlux & Phi_EB & omega2k & gamma2k & gamma2AbsOmega in time-period' + \
           date_str + TimeInterval_str + sub_file_str_for_BG_flow + '.png'
num_rows = 6
num_columns = 1
fig, axs = plt.subplots(num_rows, num_columns, figsize=[14, 16], sharex=True, sharey=True)
### add a big axis, hide frame
###  hide tick and tick label of the big axis
fig.add_subplot(111, frameon=False)
plt.tick_params(labelcolor='none', top=False, bottom=False, left=False, right=False)
plt.xlabel("$~$")
plt.ylabel("period [s]")
###
x_vect = datenum_vect_common
y_vect = period_vect
x_arr, y_arr = np.meshgrid(x_vect, y_vect)
xlim = [np.min(x_vect), np.max(x_vect)]
ylim = [np.min(y_vect), np.max(y_vect)]

###TV 'PoyntingFlux_r_arr'
i_row = 1 - 1
i_column = 0
img_arr = np.transpose(PoyntingFlux_r_arr)
# a img_arr = np.transpose(PoyntingFlux_r_arr_from_SubWaves)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min, val_max]))
val_max = -val_min
val_linthresh = abs(val_max) / 1.e3
val_linscale = 0.1
title_str = '$\mathrm{Poynting-Flux~~[watt/m^2/Hz]}$'
cmap_str = 'seismic'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
# a img = ax.pcolormesh(x_arr,y_arr,img_arr,cmap=cmap_str,vmin=val_min,vmax=val_max)
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, \
                    norm=colors.SymLogNorm(linthresh=val_linthresh, linscale=val_linscale, \
                                           vmin=val_min, vmax=val_max))
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

# PoyntingFlux_r_arr_save = np.ones((16, 36001))
# for i in range(0, 16):
#     PoyntingFlux_r_arr_save[i] = img_arr[i]
# dataframe = pd.DataFrame({'PoyntingFlux_r_arr0': PoyntingFlux_r_arr_save[0], \
#                          'PoyntingFlux_r_arr1': PoyntingFlux_r_arr_save[1], \
#                          'PoyntingFlux_r_arr2': PoyntingFlux_r_arr_save[2], \
#                          'PoyntingFlux_r_arr3': PoyntingFlux_r_arr_save[3], \
#                          'PoyntingFlux_r_arr4': PoyntingFlux_r_arr_save[4], \
#                          'PoyntingFlux_r_arr5': PoyntingFlux_r_arr_save[5], \
#                          'PoyntingFlux_r_arr6': PoyntingFlux_r_arr_save[6], \
#                          'PoyntingFlux_r_arr7': PoyntingFlux_r_arr_save[7], \
#                          'PoyntingFlux_r_arr8': PoyntingFlux_r_arr_save[8], \
#                          'PoyntingFlux_r_arr9': PoyntingFlux_r_arr_save[9], \
#                          'PoyntingFlux_r_arr10': PoyntingFlux_r_arr_save[10], \
#                          'PoyntingFlux_r_arr11': PoyntingFlux_r_arr_save[11], \
#                          'PoyntingFlux_r_arr12': PoyntingFlux_r_arr_save[12], \
#                          'PoyntingFlux_r_arr13': PoyntingFlux_r_arr_save[13], \
#                          'PoyntingFlux_r_arr14': PoyntingFlux_r_arr_save[14], \
#                          'PoyntingFlux_r_arr15': PoyntingFlux_r_arr_save[15]})
# print('img_arr.size:', img_arr.size)
# print('img_arr:', img_arr)
# dataframe.to_csv("PoyntingFlux_r_arr.csv", index=False, sep=',')

###TV 'PhaseAngle_from_E_to_B_arr'
i_row = 1
i_column = 0
img_arr = np.transpose(PhaseAngle_from_E_to_B_arr)
level_vect = [90.]
color_vect = ['white']
title_str = "$\Phi(\delta \mathbf{E}', \delta \mathbf{B})$"
cmap_str = 'hsv'  # cyclic colormap
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str)
# a cs = ax.contour(x_arr,y_arr,img_arr,levels=level_vect,colors=color_vect)
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%Y-%m-%d %H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax)

###TV 'omega2k_arr'
i_row = 2
i_column = 0
img_arr = np.transpose(omega2k_arr)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min, val_max]))
val_max = -val_min
title_str = "$\omega/k~~\mathrm{[km/s]}$"
cmap_str = 'PiYG'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, vmin=val_min, vmax=val_max)
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

# a fig.autofmt_xdate() # This simply sets the x-axis data to diagonal so it fits better.
# a  plt.show()

###TV 'gamma2k_arr'
i_row = 3
i_column = 0
img_arr = np.transpose(gamma2k_arr)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min, val_max]))
val_max = -val_min
title_str = "$\gamma/k~~\mathrm{[km/s]}$"
cmap_str = 'PiYG'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, vmin=val_min, vmax=val_max)
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

###TV 'gamma2omega_arr'
i_row = 4
i_column = 0
img_arr = np.transpose(gamma2omega_arr)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min,val_max]))
val_max = -val_min
title_str = "$\gamma/|\omega|$"
cmap_str = 'seismic'
ax = axs[i_row]
#a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr,y_arr,img_arr,cmap=cmap_str,vmin=val_min,vmax=val_max)
ax.set_xlim(xlim[0],xlim[1])
ax.set_ylim(ylim[0],ylim[1])
ax.xaxis_date() # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
#a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

###TV 'gamma_arr'
i_row = 5
i_column = 0
img_arr = np.transpose(gamma_arr)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min, val_max]))
val_max = -val_min
# a title_str = "$\gamma/k~(\sim -\delta \widetilde{E}_n'/\delta \widetilde{B}_t)~\mathrm{[km/s]}$'
title_str = "$\gamma~~\mathrm{[1/s]}$"
cmap_str = 'seismic'
ax = axs[i_row]
# a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr, y_arr, img_arr, cmap=cmap_str, vmin=val_min, vmax=val_max)
ax.set_xlim(xlim[0], xlim[1])
ax.set_ylim(ylim[0], ylim[1])
ax.xaxis_date()  # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
# a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

fig.autofmt_xdate()  # This simply sets the x-axis data to diagonal so it fits better.
plt.show()
fig.savefig(dir_fig + file_fig, dpi=150)
#</editor-fold>


# beg xx1
''' 
##TV 'omega2k/gamma2k/gamma2omega_arr_from_dEn2dBt/dEt2dBn'
file_fig = 'omega2k & gamma2k & gamma2AbsOmega in time-period'+\
            date_str+TimeInterval_str+sub_file_str_for_BG_flow+'.png'
num_rows = 6
num_columns = 1
fig, axs = plt.subplots(num_rows, num_columns,figsize=[14,12],sharex=True,sharey=True)
### add a big axis, hide frame
###  hide tick and tick label of the big axis
fig.add_subplot(111, frameon=False)
plt.tick_params(labelcolor='none', top=False, bottom=False, left=False, right=False)
plt.xlabel("$~$")
plt.ylabel("period [s]")
###
x_vect = datenum_vect_common
y_vect = period_vect
x_arr, y_arr = np.meshgrid(x_vect,y_vect)
xlim = [np.min(x_vect), np.max(x_vect)]
ylim = [np.min(y_vect), np.max(y_vect)]

###TV 'omega2k_arr_from_dEn2dBt'
i_row = 0
i_column = 0
img_arr = np.transpose(omega2k_arr_from_dEn2dBt)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min,val_max]))
val_max = -val_min
title_str = "$\omega/k~(\sim -\delta \widetilde{E}_n'/\delta \widetilde{B}_t)~\mathrm{[km/s]}$"
cmap_str = 'PiYG'
ax = axs[i_row]
#a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr,y_arr,img_arr,cmap=cmap_str,vmin=val_min,vmax=val_max)
ax.set_xlim(xlim[0],xlim[1])
ax.set_ylim(ylim[0],ylim[1])
ax.xaxis_date() # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
#a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax,extend='both')

#a fig.autofmt_xdate() # This simply sets the x-axis data to diagonal so it fits better.
#a  plt.show()

###TV 'omega2k_arr_from_dEt2dBn'
i_row = 1
i_column = 0
img_arr = np.transpose(omega2k_arr_from_dEt2dBn)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min,val_max]))
val_max = -val_min
title_str = "$\omega/k~(\sim +\delta \widetilde{E}_t'/\delta \widetilde{B}_n)~\mathrm{[m/s]}$"
cmap_str = 'PiYG'
ax = axs[i_row]
#a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr,y_arr,img_arr,cmap=cmap_str,vmin=val_min,vmax=val_max)
ax.set_xlim(xlim[0],xlim[1])
ax.set_ylim(ylim[0],ylim[1])
ax.xaxis_date() # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
#a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

###TV 'gamma2k_arr_from_dEn2dBt'
i_row = 2
i_column = 0
#a img_arr = np.transpose(gamma2k_arr_from_dEn2dBt)
img_arr = np.transpose(gamma_arr_from_dEn2dBt)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min,val_max]))
val_max = -val_min
#a title_str = "$\gamma/k~(\sim -\delta \widetilde{E}_n'/\delta \widetilde{B}_t)~\mathrm{[km/s]}$'
title_str = "$\gamma~(\sim -\delta \widetilde{E}_n'/\delta \widetilde{B}_t)~\mathrm{[1/s]}$"
cmap_str = 'seismic'
ax = axs[i_row]
#a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr,y_arr,img_arr,cmap=cmap_str,vmin=val_min,vmax=val_max)
ax.set_xlim(xlim[0],xlim[1])
ax.set_ylim(ylim[0],ylim[1])
ax.xaxis_date() # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
#a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

###TV 'gamma2k_arr_from_dEt2dBn'
i_row = 3
i_column = 0
#a img_arr = np.transpose(gamma2k_arr_from_dEt2dBn)
img_arr = np.transpose(gamma_arr_from_dEt2dBn)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min,val_max]))
val_max = -val_min
#a title_str = "$\gamma/k~(\sim +\delta \widetilde{E}_t/\delta \widetilde{B}_n)~\mathrm{[km/s]}$"
title_str = "$\gamma~(\sim +\delta \widetilde{E}_t/\delta \widetilde{B}_n)~\mathrm{[1/s]}$"
cmap_str = 'seismic'
ax = axs[i_row]
#a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr,y_arr,img_arr,cmap=cmap_str,vmin=val_min,vmax=val_max)
ax.set_xlim(xlim[0],xlim[1])
ax.set_ylim(ylim[0],ylim[1])
ax.xaxis_date() # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
#a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

###TV 'gamma2omega_arr_from_dEn2dBt'
i_row = 4
i_column = 0
img_arr = np.transpose(gamma2omega_arr_from_dEn2dBt)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min,val_max]))
val_max = -val_min
title_str = "$\gamma/|\omega|~(\mathrm{from}~\delta \widetilde{E}_n'/\delta \widetilde{B}_t)$"
cmap_str = 'seismic'
ax = axs[i_row]
#a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr,y_arr,img_arr,cmap=cmap_str,vmin=val_min,vmax=val_max)
ax.set_xlim(xlim[0],xlim[1])
ax.set_ylim(ylim[0],ylim[1])
ax.xaxis_date() # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
#a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

###TV 'gamma2omega_arr_from_dEt2dBn'
i_row = 5
i_column = 0
img_arr = np.transpose(gamma2omega_arr_from_dEt2dBn)
val_min = np.percentile(img_arr, 5)
val_max = np.percentile(img_arr, 95)
val_min = -np.max(np.abs([val_min,val_max]))
val_max = -val_min
title_str = "$\gamma/|\omega|~(\mathrm{from}~\delta \widetilde{E}_n'/\delta \widetilde{B}_t)$"
cmap_str = 'seismic'
ax = axs[i_row]
#a img= ax.imshow(img_arr,extent=[xlim[0],xlim[1],ylim[0],ylim[1]],cmap=cmap_str,aspect='auto') #or use ax.pcolormesh
img = ax.pcolormesh(x_arr,y_arr,img_arr,cmap=cmap_str,vmin=val_min,vmax=val_max)
ax.set_xlim(xlim[0],xlim[1])
ax.set_ylim(ylim[0],ylim[1])
ax.xaxis_date() # this converts it from a float (which is the output of date2num) into a nice datetime string.
locator = matplotlib.dates.AutoDateLocator()
date_format = matplotlib.dates.DateFormatter('%H:%M:%S')
#a date_format = matplotlib.dates.AutoDateFormatter(locator)
ax.xaxis.set_major_formatter(date_format)
ax.set_yscale('log')
ax.set_title(title_str)
ax.xaxis.set_minor_locator(matplotlib.ticker.AutoMinorLocator())
fig.colorbar(img, ax=ax, extend='both')

fig.autofmt_xdate() # This simply sets the x-axis data to diagonal so it fits better.
plt.show()
fig.savefig(dir_fig+file_fig, dpi=150)
'''
# end xx1

cc_Et_Bn = np.corrcoef(SubWaves_Et_in_SW_vect, SubWaves_Bn_vect)
cc_En_Bt = np.corrcoef(SubWaves_En_in_SW_vect, SubWaves_Bt_vect)
print('cc_Et_Bn: ', cc_Et_Bn)
print('cc_En_Bt: ', cc_En_Bt)
exit()

cc_Et_Bn = np.corrcoef(SubWaves_Et_in_SW_vect, SubWaves_Bn_vect)
cc_En_Bt = np.corrcoef(SubWaves_En_in_SW_vect, SubWaves_Bt_vect)
print('cc_Et_Bn: ', cc_Et_Bn)
print('cc_En_Bt: ', cc_En_Bt)