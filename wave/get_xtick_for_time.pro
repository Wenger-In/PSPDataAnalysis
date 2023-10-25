Pro get_xtick_for_time, xrange_time, $
			xtickv=xtickv_time, xticknames=xticknames_time, xminor=xminor_time

JulDay_beg	= xrange_time(0)
JulDay_end	= xrange_time(1)
JulDay_range= JulDay_end-JulDay_beg	; xrange_time is julday, 1 is for one-day

CalDat, JulDay_beg, mon_beg, day_beg, year_beg, hour_beg, min_beg, sec_beg
CalDat, JulDay_end, mon_end, day_end, year_end, hour_end, min_end, sec_end
JulDay_beg_v1	= JulDay(mon_beg, day_beg, year_beg, 0.0, 0.0, 0.0)
JulDay_end_v1	= JulDay(mon_end, day_end+1, year_end, 0.0, 0.0, 0.0)

If JulDay_range gt 5.0 Then Begin
	dJulDay_tick	= 1.0
	xminor_time		= 4
EndIf Else Begin
If JulDay_range gt 12*(1./24) Then Begin
	dJulDay_tick	= Double(4.)/24
	xminor_time		= 4
EndIf Else Begin
If JulDay_range gt 2*(1./24) Then Begin
	dJulDay_tick	= Double(1./2)/24
	xminor_time		= 3
EndIf Else Begin
If JulDay_range gt 1./(24*60)*10. Then Begin
	dJulDay_tick	= Double(1.)/(24*60)*10.
	xminor_time		= 10
EndIf Else Begin
If JulDay_range gt 1./(24*60) Then Begin
	dJulDay_tick	= Double(1.)/(24*60)
	xminor_time		= 6
EndIf Else Begin
If JulDay_range gt 10./(24.*60.*60) Then Begin
	dJulDay_tick	= Double(1.)/(24L*60*60)*5
	xminor_time		= 5
EndIf Else Begin
	dJulDay_tick	= Double(1.)/(24L*60*60)*2
	xminor_time		= 2
EndElse
EndElse
EndElse
EndElse
EndElse
EndElse
num_JulDay_v1	= Floor((JulDay_end_v1 - JulDay_beg_v1)/dJulDay_tick,/L64)
JulDay_vect_v1	= JulDay_beg_v1 + Dindgen(num_JulDay_v1)*dJulDay_tick

sub_tmp			= Where(JulDay_vect_v1 ge JulDay_beg and JulDay_vect_v1 le JulDay_end)
JulDay_vect_v2	= JulDay_vect_v1(sub_tmp)
xtickv_time		= JulDay_vect_v2
num_ticks		= N_Elements(xtickv_time)-1
xticknames_time	= Strarr(num_ticks+1)
For i_tick=0,num_ticks Do Begin
	xtick_tmp		= xtickv_time(i_tick)
	CalDat, xtick_tmp, mon_tmp, day_tmp, year_tmp, hour_tmp, min_tmp, sec_tmp
	If dJulDay_tick ge 1.0 Then Begin
		xtickname_tmp	= String(mon_tmp, Format='(I2.2)')+'/'+$
							String(day_tmp, Format='(I2.2)')
	EndIf Else Begin
	If dJulDay_tick gt 1./(24*60) Then Begin
		xtickname_tmp	= String(hour_tmp, Format='(I2.2)')+':'+$
							String(min_tmp, Format='(I2.2)')
	EndIf Else Begin
		xtickname_tmp	= String(hour_tmp, Format='(I2.2)')+':'+$
							String(min_tmp, Format='(I2.2)')+':'+$
							String(sec_tmp, Format='(I2.2)')
	EndElse
	EndElse
	xticknames_time(i_tick)	= xtickname_tmp
EndFor

;If JulDay_range gt 2*(1./24) Then Begin
;	xminor_time		= 6
;EndIf Else Begin
;	xminor_time		= 12
;EndElse


End_Program:
Return
End
