# A3XX PFD

# Copyright (c) 2020 Josh Davidson (Octal450)

var PFD_1 = nil;
var PFD_2 = nil;
var PFD_1_test = nil;
var PFD_2_test = nil;
var PFD_1_mismatch = nil;
var PFD_2_mismatch = nil;
var PFD1_display = nil;
var PFD2_display = nil;
var updateL = 0;
var updateR = 0;
var elapsedtime = 0;
var altTens = 0;
var track_diff = 0;
var AICenter = nil;

	updateCommonFast: func() {
		
		if (fmgc.FMGCInternal.phase < 3 or fmgc.flightPlanController.arrivalDist >= 250) {
			me["FMA_dh_box"].hide();
			me["FMA_dh"].hide();
			me["FMA_dhn"].hide();
			me["FMA_nodh"].hide();
			#me["dhReached"].hide();
			if (gear_agl_cur <= 2500) {
				me["AI_agl"].show();
				if (gear_agl_cur <= decision.getValue()) {
					me["AI_agl"].setColor(0.7333,0.3803,0);
				} else {
					me["AI_agl"].setColor(0.0509,0.7529,0.2941);
				}
			} else {
				me["AI_agl"].hide();
			}
		} else {
			if (gear_agl_cur <= 2500) {
				me["AI_agl"].show();
				me["FMA_dh_box"].hide(); #not implemented
				if (int(getprop("/FMGC/internal/radio")) != 99999) {
					me["FMA_dh"].setText("RADIO");
					me["FMA_dh"].show();
					me["FMA_dhn"].setText(sprintf("%.0f", getprop("/FMGC/internal/radio")));
					me["FMA_dhn"].show();
					me["FMA_nodh"].hide();
					hundredAbove.setValue(getprop("/FMGC/internal/radio") + 100);
					minimum.setValue(getprop("/FMGC/internal/radio"));
					if (gear_agl_cur <= getprop("/FMGC/internal/radio") + 100) {
						me["AI_agl"].setColor(0.7333,0.3803,0);
					} else {
						me["AI_agl"].setColor(0.0509,0.7529,0.2941);
					}
				} else if (int(getprop("/FMGC/internal/baro")) != 99999) {
					me["FMA_dh"].setText("BARO");
					me["FMA_dh"].show();
					me["FMA_dhn"].setText(sprintf("%.0f", getprop("/FMGC/internal/baro")));
					me["FMA_dhn"].show();
					me["FMA_nodh"].hide();
					hundredAbove.setValue(getprop("/FMGC/internal/baro") + 100);
					minimum.setValue(getprop("/FMGC/internal/baro"));
					if (gear_agl_cur <= getprop("/FMGC/internal/baro") + 100) {
						me["AI_agl"].setColor(0.7333,0.3803,0);
					} else {
						me["AI_agl"].setColor(0.0509,0.7529,0.2941);
					}
				} else if (fmgc.FMGCInternal.radioNo) {
					me["FMA_dh"].setText("BARO");
					me["FMA_dh"].show();
					me["FMA_dhn"].setText("100");
					me["FMA_dhn"].show();
					me["FMA_nodh"].hide();
					hundredAbove.setValue(100);
					minimum.setValue(0);
					if (gear_agl_cur <= 100) {
						me["AI_agl"].setColor(0.7333,0.3803,0);
					} else {
						me["AI_agl"].setColor(0.0509,0.7529,0.2941);
					}
				} else {
					me["FMA_dh"].hide();
					me["FMA_dhn"].hide();
					me["FMA_nodh"].show();
					hundredAbove.setValue(400);
					minimum.setValue(300);
					if (gear_agl_cur <= 400) {
						me["AI_agl"].setColor(0.7333,0.3803,0);
					} else {
						me["AI_agl"].setColor(0.0509,0.7529,0.2941);
					}
				}
			} else {
				me["AI_agl"].hide();
				me["FMA_nodh"].hide();
				me["FMA_dh_box"].hide(); #not implemented
				if (int(getprop("/FMGC/internal/radio")) != 99999) {
					me["FMA_dh"].setText("RADIO");
					me["FMA_dh"].show();
					me["FMA_dhn"].setText(sprintf("%.0f", getprop("/FMGC/internal/radio")));
					me["FMA_dhn"].show();
					me["FMA_nodh"].hide();
				} else if (int(getprop("/FMGC/internal/baro")) != 99999) {
					me["FMA_dh"].setText("BARO");
					me["FMA_dh"].show();
					me["FMA_dhn"].setText(sprintf("%.0f", getprop("/FMGC/internal/baro")));
					me["FMA_dhn"].show();
					me["FMA_nodh"].hide();
				} else if (fmgc.FMGCInternal.radioNo) {
					me["FMA_dh"].setText("BARO");
					me["FMA_dh"].show();
					me["FMA_dhn"].setText("100");
					me["FMA_dhn"].show();
					me["FMA_nodh"].hide();
				} else {
					me["FMA_dh"].hide();
					me["FMA_dhn"].hide();
					me["FMA_nodh"].show();
				}
			}
		}
		
		# Vertical Speed
		me["VS_pointer"].setRotation(vs_needle.getValue() * D2R);
		
		me["VS_box"].setTranslation(0, vs_digit.getValue());
		
		var vs_pfd_cur = ap_vs_pfd.getValue();
		if (vs_pfd_cur < 2) {
			me["VS_box"].hide();
		} else {
			me["VS_box"].show();
		}
		
		if (vs_pfd_cur < 10) {
			me["VS_digit"].setText(sprintf("%02d", "0" ~ vs_pfd_cur));
		} else {
			me["VS_digit"].setText(sprintf("%02d", vs_pfd_cur));
		}
		
		var vs_itaf = fmgc.Internal.vs.getValue();
		var gearAgl = gear_agl.getValue();
		
		if (abs(vs_itaf) >= 6000 or (vs_itaf <= -2000 and gearAgl <= 2500) or (vs_itaf <= -1200 and gearAgl <= 1000)) {
			me["VS_digit"].setColor(0.7333,0.3803,0);
			me["VS_pointer"].setColor(0.7333,0.3803,0);
			me["VS_pointer"].setColorFill(0.7333,0.3803,0);
		} else {
			me["VS_digit"].setColor(0.0509,0.7529,0.2941);
			me["VS_pointer"].setColor(0.0509,0.7529,0.2941);
			me["VS_pointer"].setColorFill(0.0509,0.7529,0.2941);
		}
		
		# ILS		
		me["LOC_pointer"].setTranslation(loc.getValue() * 197, 0);	
		me["GS_pointer"].setTranslation(0, gs.getValue() * -197);
		
		# Heading
		me.heading = hdg_scale.getValue();
		me.headOffset = me.heading / 10 - int(me.heading / 10);
		me.middleText = roundabout(me.heading / 10);
		me.middleOffset = nil;
		if(me.middleText == 36) {
			me.middleText = 0;
		}
		me.leftText1 = me.middleText == 0?35:me.middleText - 1;
		me.rightText1 = me.middleText == 35?0:me.middleText + 1;
		me.leftText2 = me.leftText1 == 0?35:me.leftText1 - 1;
		me.rightText2 = me.rightText1 == 35?0:me.rightText1 + 1;
		me.leftText3 = me.leftText2 == 0?35:me.leftText2 - 1;
		me.rightText3 = me.rightText2 == 35?0:me.rightText2 + 1;
		if (me.headOffset > 0.5) {
			me.middleOffset = -(me.headOffset - 1) * 98.5416;
		} else {
			me.middleOffset = -me.headOffset * 98.5416;
		}
		me["HDG_scale"].setTranslation(me.middleOffset, 0);
		me["HDG_scale"].update();
		me["HDG_four"].setText(sprintf("%d", me.middleText));
		me["HDG_five"].setText(sprintf("%d", me.rightText1));
		me["HDG_three"].setText(sprintf("%d", me.leftText1));
		me["HDG_six"].setText(sprintf("%d", me.rightText2));
		me["HDG_two"].setText(sprintf("%d", me.leftText2));
		me["HDG_seven"].setText(sprintf("%d", me.rightText3));
		me["HDG_one"].setText(sprintf("%d", me.leftText3));
		
		me["HDG_four"].setFontSize(fontSizeHDG(me.middleText), 1);
		me["HDG_five"].setFontSize(fontSizeHDG(me.rightText1), 1);
		me["HDG_three"].setFontSize(fontSizeHDG(me.leftText1), 1);
		me["HDG_six"].setFontSize(fontSizeHDG(me.rightText2), 1);
		me["HDG_two"].setFontSize(fontSizeHDG(me.leftText2), 1);
		me["HDG_seven"].setFontSize(fontSizeHDG(me.rightText3), 1);
		me["HDG_one"].setFontSize(fontSizeHDG(me.leftText3), 1);
		
		show_hdg_act = show_hdg.getValue();
		hdg_diff_act = hdg_diff.getValue();
		if (show_hdg_act == 1 and hdg_diff_act >= -23.62 and hdg_diff_act <= 23.62) {
			me["HDG_target"].setTranslation((hdg_diff_act / 10) * 98.5416, 0);
			me["HDG_digit_L"].hide();
			me["HDG_digit_R"].hide();
			me["HDG_target"].show();
		} else if (show_hdg_act == 1 and hdg_diff_act < -23.62 and hdg_diff_act >= -180) {
			me["HDG_digit_L"].setText(sprintf("%3.0f", ap_hdg.getValue()));
			me["HDG_digit_L"].show();
			me["HDG_digit_R"].hide();
			me["HDG_target"].hide();
		} else if (show_hdg_act == 1 and hdg_diff_act > 23.62 and hdg_diff_act <= 180) {
			me["HDG_digit_R"].setText(sprintf("%3.0f", ap_hdg.getValue()));
			me["HDG_digit_R"].show();
			me["HDG_digit_L"].hide();
			me["HDG_target"].hide();
		} else {
			me["HDG_digit_L"].hide();
			me["HDG_digit_R"].hide();
			me["HDG_target"].hide();
		}
		

		var heading_deg = heading.getValue();
		track_diff = geo.normdeg180(track.getValue() - heading_deg);
		me["TRK_pointer"].setTranslation(me.getTrackDiffPixels(track_diff),0);
		split_ils = split("/", ils_data1.getValue());
		
		if (ap_ils_mode.getValue() == 1 and size(split_ils) == 2) {
			magnetic_hdg = ils_crs.getValue();
			magnetic_hdg_dif = geo.normdeg180(magnetic_hdg - heading_deg);
			if (magnetic_hdg_dif >= -23.62 and magnetic_hdg_dif <= 23.62) {
				me["CRS_pointer"].setTranslation((magnetic_hdg_dif / 10) * 98.5416, 0);
				me["ILS_HDG_R"].hide();
				me["ILS_HDG_L"].hide();
				me["CRS_pointer"].show();
			} else if (magnetic_hdg_dif < -23.62 and magnetic_hdg_dif >= -180) {
				if (int(magnetic_hdg) < 10) {
					me["ILS_left"].setText(sprintf("00%1.0f", int(magnetic_hdg)));
				} else if (int(magnetic_hdg) < 100) {
					me["ILS_left"].setText(sprintf("0%2.0f", int(magnetic_hdg)));
				} else {
					me["ILS_left"].setText(sprintf("%3.0f", int(magnetic_hdg)));
				}
				me["ILS_HDG_L"].show();
				me["ILS_HDG_R"].hide();
				me["CRS_pointer"].hide();
			} else if (magnetic_hdg_dif > 23.62 and magnetic_hdg_dif <= 180) {
				if (int(magnetic_hdg) < 10) {
					me["ILS_right"].setText(sprintf("00%1.0f", int(magnetic_hdg)));
				} else if (int(magnetic_hdg) < 100) {
					me["ILS_right"].setText(sprintf("0%2.0f", int(magnetic_hdg)));
				} else {
					me["ILS_right"].setText(sprintf("%3.0f", int(magnetic_hdg)));
				}
				me["ILS_HDG_R"].show();
				me["ILS_HDG_L"].hide();
				me["CRS_pointer"].hide();
			} else {
				me["ILS_HDG_R"].hide();
				me["ILS_HDG_L"].hide();
				me["CRS_pointer"].hide();
			}
		} else {
			me["ILS_HDG_R"].hide();
			me["ILS_HDG_L"].hide();
			me["CRS_pointer"].hide();
		}

		# AI HDG
		me.AI_horizon_hdg_trans.setTranslation(me.middleOffset, horizon_pitch.getValue() * 11.825);
		me.AI_horizon_hdg_rot.setRotation(-roll_cur * D2R, me["AI_center"].getCenter());
		me["AI_heading"].update();
	},

};

var canvas_PFD_1 = {
	ASI: 0,
	ASImax: 0,
	ASItrend: 0,
	ASItrgt: 0,
	ASItrgtdiff: 0,
	V1trgt: 0,
	VRtrgt: 0,
	V2trgt: 0,
	Strgt: 0,
	Ftrgt: 0,
	flaptrgt: 0,
	cleantrgt: 0,
	SPDv1trgtdiff: 0,
	SPDvrtrgtdiff: 0,
	SPDv2trgtdiff: 0,
	SPDstrgtdiff: 0,
	SPDftrgtdiff: 0,
	SPDflaptrgtdiff: 0,
	SPDcleantrgtdiff: 0,
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_1, canvas_PFD_base]};
		m.init(canvas_group, file);

		return m;
	},
	update: func() {
		fd1_act = fd1.getValue();
		pitch_mode_cur = pitch_mode.getValue();
		roll_mode_cur = roll_mode.getValue();
		pitch_cur = pitch.getValue();
		roll_cur = roll.getValue();
		wow1_act = wow1.getValue();
		wow2_act = wow2.getValue();
		
		# Errors
		if (systems.ADIRS.ADIRunits[0].operating == 1 or (systems.ADIRS.ADIRunits[2].operating == 1 and att_switch.getValue() == -1)) {
			me["AI_group"].show();
			me["HDG_group"].show();
			me["AI_error"].hide();
			me["HDG_error"].hide();
			me["HDG_frame"].setColor(1,1,1);
			me["VS_group"].show();
			me["VS_error"].hide(); # VS is inertial-sourced
		} else {
			me["AI_error"].show();
			me["HDG_error"].show();
			me["HDG_frame"].setColor(1,0,0);
			me["AI_group"].hide();
			me["HDG_group"].hide();
			me["VS_error"].show();
			me["VS_group"].hide();
		}
		# FD
		if (fd1_act == 1 and ((!wow1_act and !wow2_act and roll_mode_cur != " ") or roll_mode_cur != " ") and ap_trk_sw.getValue() == 0 and pitch_cur < 25 and pitch_cur > -13 and roll_cur < 45 and roll_cur > -45) {
			me["FD_roll"].show();
		} else {
			me["FD_roll"].hide();
		}
		
		if (fd1_act == 1 and ((!wow1_act and !wow2_act and pitch_mode_cur != " ") or pitch_mode_cur != " ") and ap_trk_sw.getValue() == 0 and pitch_cur < 25 and pitch_cur > -13 and roll_cur < 45 and roll_cur > -45) {
			me["FD_pitch"].show();
		} else {
			me["FD_pitch"].hide();
		}
		
		# If TRK FPA selected, display FPV on PFD1
		if (ap_trk_sw.getValue() == 0 ) {
			me["FPV"].hide();	
		} else {
			var aoa = me.getAOAForPFD1();	
			if (aoa == nil or (systems.ADIRS.ADIRunits[0].operating != 1 and att_switch.getValue() == 0) or (systems.ADIRS.ADIRunits[2].operating != 1 and att_switch.getValue() == -1)){
				me["FPV"].hide();	
			} else {
				var roll_deg = roll.getValue() or 0; 
				AICenter = me["AI_center"].getCenter();
				var track_x_translation = me.getTrackDiffPixels(track_diff); 

				me.AI_fpv_trans.setTranslation(track_x_translation, math.clamp(aoa, -20, 20) * 12.5); 
				me.AI_fpv_rot.setRotation(-roll_deg * D2R, AICenter);
				me["FPV"].setRotation(roll_deg * D2R); # It shouldn't be rotated, only the axis should be
				me["FPV"].show();
			}

		}

		# ILS
		if (ap_ils_mode.getValue() == 1) {
			me["LOC_scale"].show();
			me["GS_scale"].show();
			split_ils = split("/", ils_data1.getValue());
			
			if (size(split_ils) < 2) {
				me["ils_freq"].setText(split_ils[0]);
				me["ils_freq"].show();
				me["ils_code"].hide();
				me["dme_dist"].hide();
				me["dme_dist_legend"].hide();
			} else {
				me["ils_code"].setText(split_ils[0]);
				me["ils_freq"].setText(split_ils[1]);
				me["ils_code"].show();
				me["ils_freq"].show();
			}
			
			if (dme_in_range.getValue() == 1) {
				dme_dist_data = dme_data.getValue();
				if (dme_dist_data < 20.0) {
					me["dme_dist"].setText(sprintf("%1.1f", dme_dist_data));
				} else {
					me["dme_dist"].setText(sprintf("%2.0f", dme_dist_data));
				}
				me["dme_dist"].show(); 
				me["dme_dist_legend"].show();
			}
		} else {
			me["LOC_scale"].hide();
			me["GS_scale"].hide();
			me["ils_code"].hide();
			me["ils_freq"].hide();
			me["dme_dist"].hide();
			me["dme_dist_legend"].hide();
			me["outerMarker"].hide();
			me["middleMarker"].hide();
			me["innerMarker"].hide();	
		}
		
		if (ap_ils_mode.getValue() == 1 and loc_in_range.getValue() == 1 and hasloc.getValue() == 1 and nav0_signalq.getValue() > 0.99) {
			me["LOC_pointer"].show();
		} else {
			me["LOC_pointer"].hide();
		}
		if (ap_ils_mode.getValue() == 1 and gs_in_range.getValue() == 1 and hasgs.getValue() == 1 and nav0_signalq.getValue() > 0.99) {
			me["GS_pointer"].show();
		} else {
			me["GS_pointer"].hide();
		}

		if (ap_ils_mode.getValue() == 0 and (appr_enabled.getValue() == 1 or loc_enabled.getValue() == 1 or vert_gs.getValue() == 2)) {
			if (ils_going1 == 0) {
				ils_going1 = 1;
			}
			if (ils_going1 == 1) {
				ilsTimer1.start();
				if (ilsFlash1.getValue() == 1) {
					me["ilsError"].show();	
				} else {
					me["ilsError"].hide();	
				}
			}
		} else {
			ilsTimer1.stop();
			ils_going1 = 0;
			me["ilsError"].hide();
		}
			
		me.updateCommon();
	},
	updateFast: func() {
		# Airspeed
		# ind_spd = ind_spd_kt.getValue();
		# Subtract 30, since the scale starts at 30, but don"t allow less than 0, or more than 420 situations
		
		if (dmc.DMController.DMCs[0].outputs[0] != nil) {
			ind_spd = dmc.DMController.DMCs[0].outputs[0].getValue();
			me["ASI_error"].hide();
			me["ASI_frame"].setColor(1,1,1);
			me["ASI_group"].show();
			me["VLS_min"].hide();
			me["ALPHA_PROT"].hide();
			me["ALPHA_MAX"].hide();
			me["ALPHA_SW"].hide();
			
			if (ind_spd <= 30) {
				me.ASI = 0;
			} else if (ind_spd >= 420) {
				me.ASI = 390;
			} else {
				me.ASI = ind_spd - 30;
			}
			
			me.FMGC_max = fmgc.FMGCInternal.maxspeed;
			if (me.FMGC_max <= 30) {
				me.ASImax = 0 - me.ASI;
			} else if (me.FMGC_max >= 420) {
				me.ASImax = 390 - me.ASI;
			} else {
				me.ASImax = me.FMGC_max - 30 - me.ASI;
			}
			
			me["ASI_scale"].setTranslation(0, me.ASI * 6.6);
			if (fbw.FBW.Computers.fac1.getValue() or fbw.FBW.Computers.fac2.getValue()) {
				me["ASI_max"].setTranslation(0, me.ASImax * -6.6);
				me["ASI_max"].show();
			} else {
				me["ASI_max"].hide();
			}
			
			if (!fmgc.FMGCInternal.takeoffState and fmgc.FMGCInternal.phase >= 1 and !wow1.getValue() and !wow2.getValue()) {
				me.FMGC_vls = fmgc.FMGCInternal.vls_min;
				if (me.FMGC_vls <= 30) {
					me.VLSmin = 0 - me.ASI;
				} else if (me.FMGC_vls >= 420) {
					me.VLSmin = 390 - me.ASI;
				} else {
					me.VLSmin = me.FMGC_vls - 30 - me.ASI;
				}
				me.FMGC_prot = fmgc.FMGCInternal.alpha_prot;
				if (me.FMGC_prot <= 30) {
					me.ALPHAprot = 0 - me.ASI;
				} else if (me.FMGC_prot >= 420) {
					me.ALPHAprot = 390 - me.ASI;
				} else {
					me.ALPHAprot = me.FMGC_prot - 30 - me.ASI;
				}
				me.FMGC_max = fmgc.FMGCInternal.alpha_max;
				if (me.FMGC_max <= 30) {
					me.ALPHAmax = 0 - me.ASI;
				} else if (me.FMGC_max >= 420) {
					me.ALPHAmax = 390 - me.ASI;
				} else {
					me.ALPHAmax = me.FMGC_max - 30 - me.ASI;
				}
				me.FMGC_vsw = fmgc.FMGCInternal.vsw;
				if (me.FMGC_vsw <= 30) {
					me.ALPHAvsw = 0 - me.ASI;
				} else if (me.FMGC_vsw >= 420) {
					me.ALPHAvsw = 390 - me.ASI;
				} else {
					me.ALPHAvsw = me.FMGC_vsw - 30 - me.ASI;
				}
				
				if (fbw.FBW.Computers.fac1.getValue() or fbw.FBW.Computers.fac2.getValue()) {
					me["VLS_min"].setTranslation(0, me.VLSmin * -6.6);
					me["VLS_min"].show();
					if (getprop("/it-fbw/law") == 0) {
						me["ALPHA_PROT"].setTranslation(0, me.ALPHAprot * -6.6);
						me["ALPHA_MAX"].setTranslation(0, me.ALPHAmax * -6.6);
						me["ALPHA_PROT"].show();
						me["ALPHA_MAX"].show();
						me["ALPHA_SW"].hide();
					} else {
						me["ALPHA_PROT"].hide();
						me["ALPHA_MAX"].hide();
						me["ALPHA_SW"].setTranslation(0, me.ALPHAvsw * -6.6);
						me["ALPHA_SW"].show();
					}
				} else {
					me["VLS_min"].hide();
					me["ALPHA_PROT"].hide();
					me["ALPHA_MAX"].hide();
					me["ALPHA_SW"].hide();
				}
			}
			
			tgt_ias = at_tgt_ias.getValue();
			tgt_mach = at_input_spd_mach.getValue();
			tgt_kts = at_input_spd_kts.getValue();
			
			if (managed_spd.getValue() == 1) {
				if (getprop("/FMGC/internal/decel") == 1) {
					if (fmgc.FMGCInternal.vappSpeedSet) {
						vapp = fmgc.FMGCInternal.vapp_appr;
					} else {
						vapp = fmgc.FMGCInternal.vapp;
					}
					tgt_ias = vapp;
					tgt_kts = vapp;
				} else if (fmgc.FMGCInternal.phase == 6) {
					clean = fmgc.FMGCInternal.clean;
					tgt_ias = clean;
					tgt_kts = clean;
				}
				
				me["ASI_target"].setColor(0.6901,0.3333,0.7450);
				me["ASI_digit_UP"].setColor(0.6901,0.3333,0.7450);
				me["ASI_decimal_UP"].setColor(0.6901,0.3333,0.7450);
				me["ASI_digit_DN"].setColor(0.6901,0.3333,0.7450);
				me["ASI_decimal_DN"].setColor(0.6901,0.3333,0.7450);
			} else {
				me["ASI_target"].setColor(0.0901,0.6039,0.7176);
				me["ASI_digit_UP"].setColor(0.0901,0.6039,0.7176);
				me["ASI_decimal_UP"].setColor(0.0901,0.6039,0.7176);
				me["ASI_digit_DN"].setColor(0.0901,0.6039,0.7176);
				me["ASI_decimal_DN"].setColor(0.0901,0.6039,0.7176);
			}
			
			if (tgt_ias <= 30) {
				me.ASItrgt = 0 - me.ASI;
			} else if (tgt_ias >= 420) {
				me.ASItrgt = 390 - me.ASI;
			} else {
				me.ASItrgt = tgt_ias - 30 - me.ASI;
			}
			
			me.ASItrgtdiff = tgt_ias - ind_spd;
			
			if (me.ASItrgtdiff >= -42 and me.ASItrgtdiff <= 42) {
				me["ASI_target"].setTranslation(0, me.ASItrgt * -6.6);
				me["ASI_digit_UP"].hide();
				me["ASI_decimal_UP"].hide();
				me["ASI_digit_DN"].hide();
				me["ASI_decimal_DN"].hide();
				me["ASI_target"].show();
			} else if (me.ASItrgtdiff < -42) {
				if (at_mach_mode.getValue() == 1) {
					me["ASI_digit_DN"].setText(sprintf("%3.0f", tgt_mach * 1000));
					me["ASI_decimal_UP"].hide();
					me["ASI_decimal_DN"].show();
				} else {
					me["ASI_digit_DN"].setText(sprintf("%3.0f", tgt_kts));
					me["ASI_decimal_UP"].hide();
					me["ASI_decimal_DN"].hide();
				}
				me["ASI_digit_DN"].show();
				me["ASI_digit_UP"].hide();
				me["ASI_target"].hide();
			} else if (me.ASItrgtdiff > 42) {
				if (at_mach_mode.getValue() == 1) {
					me["ASI_digit_UP"].setText(sprintf("%3.0f", tgt_mach * 1000));
					me["ASI_decimal_UP"].show();
					me["ASI_decimal_DN"].hide();
				} else {
					me["ASI_digit_UP"].setText(sprintf("%3.0f", tgt_kts));
					me["ASI_decimal_UP"].hide();
					me["ASI_decimal_DN"].hide();
				}
				me["ASI_digit_UP"].show();
				me["ASI_digit_DN"].hide();
				me["ASI_target"].hide();
			}
			
			if (fmgc.FMGCInternal.v1set) {
				tgt_v1 = fmgc.FMGCInternal.v1;
				if (tgt_v1 <= 30) {
					me.V1trgt = 0 - me.ASI;
				} else if (tgt_v1 >= 420) {
					me.V1trgt = 390 - me.ASI;
				} else {
					me.V1trgt = tgt_v1 - 30 - me.ASI;
				}
			
				me.SPDv1trgtdiff = tgt_v1 - ind_spd;
			
				if (pts.Position.gearAglFt.getValue() < 55 and fmgc.FMGCInternal.phase <= 2 and me.SPDv1trgtdiff >= -42 and me.SPDv1trgtdiff <= 42) {
					me["v1_group"].show();
					me["v1_text"].hide();
					me["v1_group"].setTranslation(0, me.V1trgt * -6.6);
				} else if (pts.Position.gearAglFt.getValue() < 55 and fmgc.FMGCInternal.phase <= 2) {
					me["v1_group"].hide();
					me["v1_text"].show();
					me["v1_text"].setText(sprintf("%3.0f", fmgc.FMGCInternal.v1));
				} else {
					me["v1_group"].hide();
					me["v1_text"].hide();
				}
			} else {
				me["v1_group"].hide();
				me["v1_text"].hide();
			}
			
			if (fmgc.FMGCInternal.vrset) {
				tgt_vr = fmgc.FMGCInternal.vr;
				if (tgt_vr <= 30) {
					me.VRtrgt = 0 - me.ASI;
				} else if (tgt_vr >= 420) {
					me.VRtrgt = 390 - me.ASI;
				} else {
					me.VRtrgt = tgt_vr - 30 - me.ASI;
				}
			
				me.SPDvrtrgtdiff = tgt_vr - ind_spd;
			
				if (pts.Position.gearAglFt.getValue() < 55 and fmgc.FMGCInternal.phase <= 2 and me.SPDvrtrgtdiff >= -42 and me.SPDvrtrgtdiff <= 42) {
					me["vr_speed"].show();
					me["vr_speed"].setTranslation(0, me.VRtrgt * -6.6);
				} else {
					me["vr_speed"].hide();
				}
			} else {
				me["vr_speed"].hide();
			}
			
			if (fmgc.FMGCInternal.v2set) {
				tgt_v2 = fmgc.FMGCInternal.v2;
				if (tgt_v2 <= 30) {
					me.V2trgt = 0 - me.ASI;
				} else if (tgt_v2 >= 420) {
					me.V2trgt = 390 - me.ASI;
				} else {
					me.V2trgt = tgt_v2 - 30 - me.ASI;
				}
			
				me.SPDv2trgtdiff = tgt_v2 - ind_spd;
			
				if (pts.Position.gearAglFt.getValue() < 55 and fmgc.FMGCInternal.phase <= 2 and me.SPDv2trgtdiff >= -42 and me.SPDv2trgtdiff <= 42) {
					me["ASI_target"].show();
					me["ASI_target"].setTranslation(0, me.V2trgt * -6.6);
					me["ASI_digit_UP"].setText(sprintf("%3.0f", fmgc.FMGCInternal.v2));
				} else if (pts.Position.gearAglFt.getValue() < 55 and fmgc.FMGCInternal.phase <= 2) {
					me["ASI_target"].hide();
					me["ASI_digit_UP"].setText(sprintf("%3.0f", fmgc.FMGCInternal.v2));
				}
			}
			
			if (fbw.FBW.Computers.fac1.getValue() or fbw.FBW.Computers.fac2.getValue()) {
				if (flap_config.getValue() == '1') {
					me["F_target"].hide();
					me["clean_speed"].hide();
					
					tgt_S = fmgc.FMGCInternal.slat;
				
					if (tgt_S <= 30) {
						me.Strgt = 0 - me.ASI;
					} else if (tgt_S >= 420) {
						me.Strgt = 390 - me.ASI;
					} else {
						me.Strgt = tgt_S - 30 - me.ASI;
					}
				
					me.SPDstrgtdiff = tgt_S - ind_spd;
				
					if (me.SPDstrgtdiff >= -42 and me.SPDstrgtdiff <= 42 and gear_agl.getValue() >= 400) {
						me["S_target"].show();
						me["S_target"].setTranslation(0, me.Strgt * -6.6);
					} else {
						me["S_target"].hide();
					}
					
					tgt_flap = 200;
					me.flaptrgt = tgt_flap - 30 - me.ASI;
					
					me.SPDflaptrgtdiff = tgt_flap - ind_spd;
				
					if (me.SPDflaptrgtdiff >= -42 and me.SPDflaptrgtdiff <= 42) {
						me["flap_max"].show();
						me["flap_max"].setTranslation(0, me.flaptrgt * -6.6);
					} else {
						me["flap_max"].hide();
					}
				} else if (flap_config.getValue() == '2') {
					me["S_target"].hide();
					me["clean_speed"].hide();
					
					tgt_F = fmgc.FMGCInternal.flap2;
					
					if (tgt_F <= 30) {
						me.Ftrgt = 0 - me.ASI;
					} else if (tgt_F >= 420) {
						me.Ftrgt = 390 - me.ASI;
					} else {
						me.Ftrgt = tgt_F - 30 - me.ASI;
					}
				
					me.SPDftrgtdiff = tgt_F - ind_spd;
				
					if (me.SPDftrgtdiff >= -42 and me.SPDftrgtdiff <= 42 and gear_agl.getValue() >= 400) {
						me["F_target"].show();
						me["F_target"].setTranslation(0, me.Ftrgt * -6.6);
					} else {
						me["F_target"].hide();
					}
					
					tgt_flap = 185;
					me.flaptrgt = tgt_flap - 30 - me.ASI;
					
					me.SPDflaptrgtdiff = tgt_flap - ind_spd;
				
					if (me.SPDflaptrgtdiff >= -42 and me.SPDflaptrgtdiff <= 42) {
						me["flap_max"].show();
						me["flap_max"].setTranslation(0, me.flaptrgt * -6.6);
					} else {
						me["flap_max"].hide();
					}
				} else if (flap_config.getValue() == '3') {
					me["S_target"].hide();
					me["clean_speed"].hide();
					
					tgt_F = fmgc.FMGCInternal.flap3;
						
					if (tgt_F <= 30) {
						me.Ftrgt = 0 - me.ASI;
					} else if (tgt_F >= 420) {
						me.Ftrgt = 390 - me.ASI;
					} else {
						me.Ftrgt = tgt_F - 30 - me.ASI;
					}
				
					me.SPDftrgtdiff = tgt_F - ind_spd;
				
					if (me.SPDftrgtdiff >= -42 and me.SPDftrgtdiff <= 42 and gear_agl.getValue() >= 400) {
						me["F_target"].show();
						me["F_target"].setTranslation(0, me.Ftrgt * -6.6);
					} else {
						me["F_target"].hide();
					}
					
					tgt_flap = 177;
					me.flaptrgt = tgt_flap - 30 - me.ASI;
					
					me.SPDflaptrgtdiff = tgt_flap - ind_spd;
				
					if (me.SPDflaptrgtdiff >= -42 and me.SPDflaptrgtdiff <= 42) {
						me["flap_max"].show();
						me["flap_max"].setTranslation(0, me.flaptrgt * -6.6);
					} else {
						me["flap_max"].hide();
					}
				} else if (flap_config.getValue() == '4') {
					me["S_target"].hide();
					me["F_target"].hide();
					me["clean_speed"].hide();	
					me["flap_max"].hide();
				} else {
					me["S_target"].hide();
					me["F_target"].hide();
					
					tgt_clean = fmgc.FMGCInternal.clean;
					
					me.cleantrgt = tgt_clean - 30 - me.ASI;
					me.SPDcleantrgtdiff = tgt_clean - ind_spd;
				
					if (me.SPDcleantrgtdiff >= -42 and me.SPDcleantrgtdiff <= 42) {
						me["clean_speed"].show();
						me["clean_speed"].setTranslation(0, me.cleantrgt * -6.6);
					} else {
						me["clean_speed"].hide();
					}	
					
					tgt_flap = 230;
					me.flaptrgt = tgt_flap - 30 - me.ASI;
					
					me.SPDflaptrgtdiff = tgt_flap - ind_spd;
				
					if (me.SPDflaptrgtdiff >= -42 and me.SPDflaptrgtdiff <= 42) {
						me["flap_max"].show();
						me["flap_max"].setTranslation(0, me.flaptrgt * -6.6);
					} else {
						me["flap_max"].hide();
					}
				}
			} else {
				me["S_target"].hide();
				me["F_target"].hide();
				me["clean_speed"].hide();
				me["flap_max"].hide();
			}
			
			me.ASItrend = dmc.DMController.DMCs[0].outputs[6].getValue() - me.ASI;
			me["ASI_trend_up"].setTranslation(0, math.clamp(me.ASItrend, 0, 50) * -6.6);
			me["ASI_trend_down"].setTranslation(0, math.clamp(me.ASItrend, -50, 0) * -6.6);
			
			if (me.ASItrend >= 2) {
				me["ASI_trend_up"].show();
				me["ASI_trend_down"].hide();
			} else if (me.ASItrend <= -2) {
				me["ASI_trend_down"].show();
				me["ASI_trend_up"].hide();
			} else {
				me["ASI_trend_up"].hide();
				me["ASI_trend_down"].hide();
			}
		} else {
			me["ASI_group"].hide();
			me["ASI_error"].show();
			me["ASI_frame"].setColor(1,0,0);
			me["clean_speed"].hide();
			me["S_target"].hide();
			me["F_target"].hide();
			me["flap_max"].hide();
			me["v1_group"].hide();
			me["v1_text"].hide();
			me["vr_speed"].hide();
			me["ground"].hide();
			me["ground_ref"].hide();
			me["VLS_min"].hide();
			me["VLS_min"].hide();
			me["ALPHA_PROT"].hide();
			me["ALPHA_MAX"].hide();
			me["ALPHA_SW"].hide();
		}
		
		if (dmc.DMController.DMCs[0].outputs[2] != nil) {
			ind_mach = dmc.DMController.DMCs[0].outputs[2].getValue();
			me["machError"].hide();
			if (ind_mach >= 0.5) {
				me["ASI_mach_decimal"].show();
				me["ASI_mach"].show();
			} else {
				me["ASI_mach_decimal"].hide();
				me["ASI_mach"].hide();
			}
			
			if (ind_mach >= 0.999) {
				me["ASI_mach"].setText("999");
			} else {
				me["ASI_mach"].setText(sprintf("%3.0f", ind_mach * 1000));
			}
		} else {
			me["machError"].show();
		}
		
		# Altitude
		if (dmc.DMController.DMCs[0].outputs[1] != nil) {
			me["ALT_error"].hide();
			me["ALT_frame"].setColor(1,1,1);
			me["ALT_group"].show();
			me["ALT_tens"].show();
			me["ALT_box"].show();
			me["ALT_group2"].show();
			me["ALT_scale"].show();
			
			me.altitude = dmc.DMController.DMCs[0].outputs[1].getValue();
			me.altOffset = me.altitude / 500 - int(me.altitude / 500);
			me.middleAltText = roundaboutAlt(me.altitude / 100);
			me.middleAltOffset = nil;
			if (me.altOffset > 0.5) {
				me.middleAltOffset = -(me.altOffset - 1) * 243.3424;
			} else {
				me.middleAltOffset = -me.altOffset * 243.3424;
			}
			me["ALT_scale"].setTranslation(0, -me.middleAltOffset);
			me["ALT_scale"].update();
			me["ALT_five"].setText(sprintf("%03d", abs(me.middleAltText+10)));
			me["ALT_four"].setText(sprintf("%03d", abs(me.middleAltText+5)));
			me["ALT_three"].setText(sprintf("%03d", abs(me.middleAltText)));
			me["ALT_two"].setText(sprintf("%03d", abs(me.middleAltText-5)));
			me["ALT_one"].setText(sprintf("%03d", abs(me.middleAltText-10)));
			
			if (me.altitude < 0) {
				me["ALT_neg"].show();
			} else {
				me["ALT_neg"].hide();
			}
			
			me["ALT_digits"].setText(sprintf("%d", dmc.DMController.DMCs[0].outputs[3].getValue()));
			altTens = num(right(sprintf("%02d", me.altitude), 2));
			me["ALT_tens"].setTranslation(0, altTens * 1.392);
			
			ap_alt_cur = ap_alt.getValue();
			alt_diff_cur = alt_diff.getValue();
			if (alt_diff_cur >= -565 and alt_diff_cur <= 565) {
				me["ALT_target"].setTranslation(0, (alt_diff_cur / 100) * -48.66856);
				me["ALT_target_digit"].setText(sprintf("%03d", math.round(ap_alt_cur / 100)));
				me["ALT_digit_UP"].hide();
				me["ALT_digit_DN"].hide();
				me["ALT_target"].show();
			} else if (alt_diff_cur < -565) {
				if (alt_std_mode.getValue() == 1) {
					if (ap_alt_cur < 10000) {
						me["ALT_digit_DN"].setText(sprintf("%s", "FL   " ~ ap_alt_cur / 100));
					} else {
						me["ALT_digit_DN"].setText(sprintf("%s", "FL " ~ ap_alt_cur / 100));
					}
				} else {
					me["ALT_digit_DN"].setText(sprintf("%5.0f", ap_alt_cur));
				}
				me["ALT_digit_DN"].show();
				me["ALT_digit_UP"].hide();
				me["ALT_target"].hide();
			} else if (alt_diff_cur > 565) {
				if (alt_std_mode.getValue() == 1) {
					if (ap_alt_cur < 10000) {
						me["ALT_digit_UP"].setText(sprintf("%s", "FL   " ~ ap_alt_cur / 100));
					} else {
						me["ALT_digit_UP"].setText(sprintf("%s", "FL " ~ ap_alt_cur / 100));
					}
				} else {
					me["ALT_digit_UP"].setText(sprintf("%5.0f", ap_alt_cur));
				}
				me["ALT_digit_UP"].show();
				me["ALT_digit_DN"].hide();
				me["ALT_target"].hide();
			}
			
			ground_diff_cur = -gear_agl.getValue();
			if (ground_diff_cur >= -565 and ground_diff_cur <= 565) {
				me["ground_ref"].setTranslation(0, (ground_diff_cur / 100) * -48.66856);
				me["ground_ref"].show();
			} else {
				me["ground_ref"].hide();
			}
			
			if (ground_diff_cur >= -565 and ground_diff_cur <= 565) {
				if ((fmgc.FMGCInternal.phase == 5 or fmgc.FMGCInternal.phase == 6) and !wow1.getValue() and !wow2.getValue()) { #add std too
					me["ground"].setTranslation(0, (ground_diff_cur / 100) * -48.66856);
					me["ground"].show();
				} else {
					me["ground"].hide();
				}
			} else {
				me["ground"].hide();
			}
			
			if (!ecam.altAlertFlash and !ecam.altAlertSteady) {
				alt_going1 = 0;
				amber_going1 = 0;
				me["ALT_box_flash"].hide();
				me["ALT_box_amber"].hide();
			} else {
				if (ecam.altAlertFlash) {
					if (alt_going1 == 1) {
						me["ALT_box_flash"].hide(); 
						altTimer1.stop();
					}
					if (amber_going1 == 0) {
						amber_going1 = 1;
					}
					if (amber_going1 == 1) {
						me["ALT_box_amber"].show();
						me["ALT_box"].hide();
						amberTimer1.start();
					}
					if (amberFlash1.getValue() == 1) {
						me["ALT_box_amber"].hide(); 
					} else {
						me["ALT_box_amber"].show(); 
					}
				} elsif (ecam.altAlertSteady) {
					if (amber_going1 == 1) {
						me["ALT_box"].show();
						me["ALT_box_amber"].hide();
						amberTimer1.stop();
					}
					if (alt_going1 == 0) {
						alt_going1 = 1;
					}
					if (alt_going1 == 1) {
						me["ALT_box_flash"].show(); 
						altTimer1.start();
					}
					if (altFlash1.getValue() == 1) {
						me["ALT_box_flash"].show(); 
					} else {
						me["ALT_box_flash"].hide(); 
					}
				}
			}
		} else {
			me["ALT_error"].show();
			me["ALT_frame"].setColor(1,0,0);
			me["ALT_group"].hide();
			me["ALT_tens"].hide();
			me["ALT_neg"].hide();
			me["ALT_group2"].hide();
			me["ALT_scale"].hide();
			me["ALT_box_flash"].hide();
			me["ALT_box_amber"].hide();
			me["ALT_box"].hide();
		}
		
		me.updateCommonFast();
	},
};

var canvas_PFD_2 = {
	ASI: 0,
	ASImax: 0,
	ASItrend: 0,
	ASItrgt: 0,
	ASItrgtdiff: 0,
	V1trgt: 0,
	VRtrgt: 0,
	V2trgt: 0,
	Strgt: 0,
	Ftrgt: 0,
	flaptrgt: 0,
	cleantrgt: 0,
	SPDv1trgtdiff: 0,
	SPDvrtrgtdiff: 0,
	SPDv2trgtdiff: 0,
	SPDstrgtdiff: 0,
	SPDftrgtdiff: 0,
	SPDflaptrgtdiff: 0,
	SPDcleantrgtdiff: 0,
	FMGC_max: 0,
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_2, canvas_PFD_base]};
		m.init(canvas_group, file);

		return m;
	},
	update: func() {
		fd2_act = fd2.getValue();
		pitch_mode_cur = pitch_mode.getValue();
		roll_mode_cur = roll_mode.getValue();
		pitch_cur = pitch.getValue();
		roll_cur = roll.getValue();
		wow1_act = wow1.getValue();
		wow2_act = wow2.getValue();
		
		# Errors
		if (systems.ADIRS.ADIRunits[1].operating == 1 or (systems.ADIRS.ADIRunits[2].operating == 1 and att_switch.getValue() == 1)) {
			me["AI_group"].show();
			me["HDG_group"].show();
			me["AI_error"].hide();
			me["HDG_error"].hide();
			me["HDG_frame"].setColor(1,1,1);
			me["VS_group"].show();
			me["VS_error"].hide(); # VS is inertial-sourced
		} else {
			me["AI_error"].show();
			me["HDG_error"].show();
			me["HDG_frame"].setColor(1,0,0);
			me["AI_group"].hide();
			me["HDG_group"].hide();
			me["VS_error"].show();
			me["VS_group"].hide();
		}
		me["spdLimError"].hide();
		
		# FD
		if (fd2_act == 1 and ((!wow1_act and !wow2_act and roll_mode_cur != " ") or roll_mode_cur != " ") and ap_trk_sw.getValue() == 0 and pitch_cur < 25 and pitch_cur > -13 and roll_cur < 45 and roll_cur > -45) {
			me["FD_roll"].show();
		} else {
			me["FD_roll"].hide();
		}
		
		if (fd2_act == 1 and ((!wow1_act and !wow2_act and pitch_mode_cur != " ") or pitch_mode_cur != " ") and ap_trk_sw.getValue() == 0 and pitch_cur < 25 and pitch_cur > -13 and roll_cur < 45 and roll_cur > -45) {
			me["FD_pitch"].show();
		} else {
			me["FD_pitch"].hide();
		}
		
		# If TRK FPA selected, display FPV on PFD2
		if (ap_trk_sw.getValue() == 0 ) {
			me["FPV"].hide();	
		} else {
			var aoa = me.getAOAForPFD2();
			if (aoa == nil or (systems.ADIRS.ADIRunits[1].operating != 1 and att_switch.getValue() == 0) or (systems.ADIRS.ADIRunits[2].operating != 1 and att_switch.getValue() == 1)) {
				me["FPV"].hide();	
			} else {
				var roll_deg = roll.getValue() or 0;	
				AICenter = me["AI_center"].getCenter();
				var track_x_translation = me.getTrackDiffPixels(track_diff);

				me.AI_fpv_trans.setTranslation(track_x_translation, math.clamp(aoa, -20, 20) * 12.5);
				me.AI_fpv_rot.setRotation(-roll_deg * D2R, AICenter);
				me["FPV"].setRotation(roll_deg * D2R); # It shouldn't be rotated, only the axis should be
				me["FPV"].show();
			}
		}

		# ILS
		if (ap_ils_mode2.getValue() == 1) {
			me["LOC_scale"].show();
			me["GS_scale"].show();
			split_ils = split("/", ils_data1.getValue());
			
			if (size(split_ils) < 2) {
				me["ils_freq"].setText(split_ils[0]);
				me["ils_freq"].show();
				me["ils_code"].hide();
				me["dme_dist"].hide();
				me["dme_dist_legend"].hide();
			} else {
				me["ils_code"].setText(split_ils[0]);
				me["ils_freq"].setText(split_ils[1]);
				me["ils_code"].show();
				me["ils_freq"].show();
			}
			
			if (dme_in_range.getValue() == 1) {
				dme_dist_data = dme_data.getValue();
				if (dme_dist_data < 20.0) {
					me["dme_dist"].setText(sprintf("%1.1f", dme_dist_data));
				} else {
					me["dme_dist"].setText(sprintf("%2.0f", dme_dist_data));
				}
				me["dme_dist"].show(); 
				me["dme_dist_legend"].show();
			}
		} else {
			me["LOC_scale"].hide();
			me["GS_scale"].hide();
			me["ils_code"].hide();
			me["ils_freq"].hide();
			me["dme_dist"].hide();
			me["dme_dist_legend"].hide();
			me["outerMarker"].hide();
			me["middleMarker"].hide();
			me["innerMarker"].hide();	
		}
		
		if (outer_marker.getValue() == 1) {
			me["outerMarker"].show();
			me["middleMarker"].hide();
			me["innerMarker"].hide();
		} else if (middle_marker.getValue()) {
			me["middleMarker"].show();
			me["outerMarker"].hide();
			me["innerMarker"].hide();
		} else if (inner_marker.getValue()) {
			me["innerMarker"].show();
			me["outerMarker"].hide();
			me["middleMarker"].hide();
		} else {
			me["outerMarker"].hide();
			me["middleMarker"].hide();
			me["innerMarker"].hide();	
		}
		
		if (ap_ils_mode2.getValue() == 1 and loc_in_range.getValue() == 1 and hasloc.getValue() == 1 and nav0_signalq.getValue() > 0.99) {
			me["LOC_pointer"].show();
		} else {
			me["LOC_pointer"].hide();
		}
		if (ap_ils_mode2.getValue() == 1 and gs_in_range.getValue() == 1 and hasgs.getValue() == 1 and nav0_signalq.getValue() > 0.99) {
			me["GS_pointer"].show();
		} else {
			me["GS_pointer"].hide();
		}
		
		if (ap_ils_mode2.getValue() == 0 and (appr_enabled.getValue() == 1 or loc_enabled.getValue() == 1 or vert_gs.getValue() == 2)) {
			if (ils_going2 == 0) {
				ils_going2 = 1;
			}
			if (ils_going2 == 1) {
				ilsTimer2.start();
				if (ilsFlash2.getValue() == 1) {
					me["ilsError"].show();	
				} else {
					me["ilsError"].hide();	
				}
			}
		} else {
			ilsTimer2.stop();
			ils_going2 = 0;
			me["ilsError"].hide();
		}
		
		me.updateCommon();
	},
	updateFast: func() {
		# Airspeed
		# ind_spd = ind_spd_kt.getValue();
		# Subtract 30, since the scale starts at 30, but don"t allow less than 0, or more than 420 situations
		
		if (dmc.DMController.DMCs[1].outputs[0] != nil) {
			ind_spd = dmc.DMController.DMCs[1].outputs[0].getValue();
			me["ASI_error"].hide();
			me["ASI_frame"].setColor(1,1,1);
			me["ASI_group"].show();
			me["VLS_min"].hide();
			me["ALPHA_PROT"].hide();
			me["ALPHA_MAX"].hide();
			me["ALPHA_SW"].hide();
			
			if (ind_spd <= 30) {
				me.ASI = 0;
			} else if (ind_spd >= 420) {
				me.ASI = 390;
			} else {
				me.ASI = ind_spd - 30;
			}
			
			me.FMGC_max = fmgc.FMGCInternal.maxspeed;
			if (me.FMGC_max <= 30) {
				me.ASImax = 0 - me.ASI;
			} else if (me.FMGC_max >= 420) {
				me.ASImax = 390 - me.ASI;
			} else {
				me.ASImax = me.FMGC_max - 30 - me.ASI;
			}
			
			me["ASI_scale"].setTranslation(0, me.ASI * 6.6);
			
			if (fbw.FBW.Computers.fac1.getValue() or fbw.FBW.Computers.fac2.getValue()) {
				me["ASI_max"].setTranslation(0, me.ASImax * -6.6);
				me["ASI_max"].show();
			} else {
				me["ASI_max"].hide();
			}
			
			if (!fmgc.FMGCInternal.takeoffState and fmgc.FMGCInternal.phase >= 1 and !wow1.getValue() and !wow2.getValue()) {
				me.FMGC_vls = fmgc.FMGCInternal.vls_min;
				if (me.FMGC_vls <= 30) {
					me.VLSmin = 0 - me.ASI;
				} else if (me.FMGC_vls >= 420) {
					me.VLSmin = 390 - me.ASI;
				} else {
					me.VLSmin = me.FMGC_vls - 30 - me.ASI;
				}
				me.FMGC_prot = fmgc.FMGCInternal.alpha_prot;
				if (me.FMGC_prot <= 30) {
					me.ALPHAprot = 0 - me.ASI;
				} else if (me.FMGC_prot >= 420) {
					me.ALPHAprot = 390 - me.ASI;
				} else {
					me.ALPHAprot = me.FMGC_prot - 30 - me.ASI;
				}
				me.FMGC_max = fmgc.FMGCInternal.alpha_max;
				if (me.FMGC_max <= 30) {
					me.ALPHAmax = 0 - me.ASI;
				} else if (me.FMGC_max >= 420) {
					me.ALPHAmax = 390 - me.ASI;
				} else {
					me.ALPHAmax = me.FMGC_max - 30 - me.ASI;
				}
				me.FMGC_vsw = fmgc.FMGCInternal.vsw;
				if (me.FMGC_vsw <= 30) {
					me.ALPHAvsw = 0 - me.ASI;
				} else if (me.FMGC_vsw >= 420) {
					me.ALPHAvsw = 390 - me.ASI;
				} else {
					me.ALPHAvsw = me.FMGC_vsw - 30 - me.ASI;
				}
				
				if (fbw.FBW.Computers.fac1.getValue() or fbw.FBW.Computers.fac2.getValue()) {
					me["VLS_min"].setTranslation(0, me.VLSmin * -6.6);
					me["VLS_min"].show();
					if (getprop("/it-fbw/law") == 0) {
						me["ALPHA_PROT"].setTranslation(0, me.ALPHAprot * -6.6);
						me["ALPHA_MAX"].setTranslation(0, me.ALPHAmax * -6.6);
						me["ALPHA_PROT"].show();
						me["ALPHA_MAX"].show();
						me["ALPHA_SW"].hide();
					} else {
						me["ALPHA_PROT"].hide();
						me["ALPHA_MAX"].hide();
						me["ALPHA_SW"].setTranslation(0, me.ALPHAvsw * -6.6);
						me["ALPHA_SW"].show();
					}
				} else {
					me["VLS_min"].hide();
					me["ALPHA_PROT"].hide();
					me["ALPHA_MAX"].hide();
					me["ALPHA_SW"].hide();
				}
			}
			
			tgt_ias = at_tgt_ias.getValue();
			tgt_mach = at_input_spd_mach.getValue();
			tgt_kts = at_input_spd_kts.getValue();
				
			if (managed_spd.getValue() == 1) {
				if (getprop("/FMGC/internal/decel") == 1) {
					if (fmgc.FMGCInternal.vappSpeedSet) {
						vapp = fmgc.FMGCInternal.vapp_appr;
					} else {
						vapp = fmgc.FMGCInternal.vapp;
					}
					tgt_ias = vapp;
					tgt_kts = vapp;
				} else if (fmgc.FMGCInternal.phase == 6) {
					clean = fmgc.FMGCInternal.clean;
					tgt_ias = clean;
					tgt_kts = clean;
				}
				
				me["ASI_target"].setColor(0.6901,0.3333,0.7450);
				me["ASI_digit_UP"].setColor(0.6901,0.3333,0.7450);
				me["ASI_decimal_UP"].setColor(0.6901,0.3333,0.7450);
				me["ASI_digit_DN"].setColor(0.6901,0.3333,0.7450);
				me["ASI_decimal_DN"].setColor(0.6901,0.3333,0.7450);
			} else {
				me["ASI_target"].setColor(0.0901,0.6039,0.7176);
				me["ASI_digit_UP"].setColor(0.0901,0.6039,0.7176);
				me["ASI_decimal_UP"].setColor(0.0901,0.6039,0.7176);
				me["ASI_digit_DN"].setColor(0.0901,0.6039,0.7176);
				me["ASI_decimal_DN"].setColor(0.0901,0.6039,0.7176);
			}
			
			if (tgt_ias <= 30) {
				me.ASItrgt = 0 - me.ASI;
			} else if (tgt_ias >= 420) {
				me.ASItrgt = 390 - me.ASI;
			} else {
				me.ASItrgt = tgt_ias - 30 - me.ASI;
			}
			
			me.ASItrgtdiff = tgt_ias - ind_spd;
			
			if (me.ASItrgtdiff >= -42 and me.ASItrgtdiff <= 42) {
				me["ASI_target"].setTranslation(0, me.ASItrgt * -6.6);
				me["ASI_digit_UP"].hide();
				me["ASI_decimal_UP"].hide();
				me["ASI_digit_DN"].hide();
				me["ASI_decimal_DN"].hide();
				me["ASI_target"].show();
			} else if (me.ASItrgtdiff < -42) {
				if (at_mach_mode.getValue() == 1) {
					me["ASI_digit_DN"].setText(sprintf("%3.0f", tgt_mach * 1000));
					me["ASI_decimal_UP"].hide();
					me["ASI_decimal_DN"].show();
				} else {
					me["ASI_digit_DN"].setText(sprintf("%3.0f", tgt_kts));
					me["ASI_decimal_UP"].hide();
					me["ASI_decimal_DN"].hide();
				}
				me["ASI_digit_DN"].show();
				me["ASI_digit_UP"].hide();
				me["ASI_target"].hide();
			} else if (me.ASItrgtdiff > 42) {
				if (at_mach_mode.getValue() == 1) {
					me["ASI_digit_UP"].setText(sprintf("%3.0f", tgt_mach * 1000));
					me["ASI_decimal_UP"].show();
					me["ASI_decimal_DN"].hide();
				} else {
					me["ASI_digit_UP"].setText(sprintf("%3.0f", tgt_kts));
					me["ASI_decimal_UP"].hide();
					me["ASI_decimal_DN"].hide();
				}
				me["ASI_digit_UP"].show();
				me["ASI_digit_DN"].hide();
				me["ASI_target"].hide();
			}
			
			if (fmgc.FMGCInternal.v1set) {
				tgt_v1 = fmgc.FMGCInternal.v1;
				if (tgt_v1 <= 30) {
					me.V1trgt = 0 - me.ASI;
				} else if (tgt_v1 >= 420) {
					me.V1trgt = 390 - me.ASI;
				} else {
					me.V1trgt = tgt_v1 - 30 - me.ASI;
				}
			
				me.SPDv1trgtdiff = tgt_v1 - ind_spd;
			
				if (pts.Position.gearAglFt.getValue() < 55 and fmgc.FMGCInternal.phase <= 2 and me.SPDv1trgtdiff >= -42 and me.SPDv1trgtdiff <= 42) {
					me["v1_group"].show();
					me["v1_text"].hide();
					me["v1_group"].setTranslation(0, me.V1trgt * -6.6);
				} else if (pts.Position.gearAglFt.getValue() < 55 and fmgc.FMGCInternal.phase <= 2) {
					me["v1_group"].hide();
					me["v1_text"].show();
					me["v1_text"].setText(sprintf("%3.0f", fmgc.FMGCInternal.v1));
				} else {
					me["v1_group"].hide();
					me["v1_text"].hide();
				}
			} else {
				me["v1_group"].hide();
				me["v1_text"].hide();
			}
			
			if (fmgc.FMGCInternal.vrset) {
				tgt_vr = fmgc.FMGCInternal.vr;
				if (tgt_vr <= 30) {
					me.VRtrgt = 0 - me.ASI;
				} else if (tgt_vr >= 420) {
					me.VRtrgt = 390 - me.ASI;
				} else {
					me.VRtrgt = tgt_vr - 30 - me.ASI;
				}
			
				me.SPDvrtrgtdiff = tgt_vr - ind_spd;
			
				if (pts.Position.gearAglFt.getValue() < 55 and fmgc.FMGCInternal.phase <= 2 and me.SPDvrtrgtdiff >= -42 and me.SPDvrtrgtdiff <= 42) {
					me["vr_speed"].show();
					me["vr_speed"].setTranslation(0, me.VRtrgt * -6.6);
				} else {
					me["vr_speed"].hide();
				}
			} else {
				me["vr_speed"].hide();
			}
			
			if (fmgc.FMGCInternal.v2set) {
				tgt_v2 = fmgc.FMGCInternal.v2;
				if (tgt_v2 <= 30) {
					me.V2trgt = 0 - me.ASI;
				} else if (tgt_v2 >= 420) {
					me.V2trgt = 390 - me.ASI;
				} else {
					me.V2trgt = tgt_v2 - 30 - me.ASI;
				}
			
				me.SPDv2trgtdiff = tgt_v2 - ind_spd;
			
				if (pts.Position.gearAglFt.getValue() < 55 and fmgc.FMGCInternal.phase <= 2 and me.SPDv2trgtdiff >= -42 and me.SPDv2trgtdiff <= 42) {
					me["ASI_target"].show();
					me["ASI_target"].setTranslation(0, me.V2trgt * -6.6);
					me["ASI_digit_UP"].setText(sprintf("%3.0f", fmgc.FMGCInternal.v2));
				} else if (pts.Position.gearAglFt.getValue() < 55 and fmgc.FMGCInternal.phase <= 2) {
					me["ASI_target"].hide();
					me["ASI_digit_UP"].setText(sprintf("%3.0f", fmgc.FMGCInternal.v2));
				}
			}
			
			if (fbw.FBW.Computers.fac1.getValue() or fbw.FBW.Computers.fac2.getValue()) {
				if (flap_config.getValue() == '1') {
					me["F_target"].hide();
					me["clean_speed"].hide();
					
					tgt_S = fmgc.FMGCInternal.slat;
				
					if (tgt_S <= 30) {
						me.Strgt = 0 - me.ASI;
					} else if (tgt_S >= 420) {
						me.Strgt = 390 - me.ASI;
					} else {
						me.Strgt = tgt_S - 30 - me.ASI;
					}
				
					me.SPDstrgtdiff = tgt_S - ind_spd;
				
					if (me.SPDstrgtdiff >= -42 and me.SPDstrgtdiff <= 42 and gear_agl.getValue() >= 400) {
						me["S_target"].show();
						me["S_target"].setTranslation(0, me.Strgt * -6.6);
					} else {
						me["S_target"].hide();
					}
					
					tgt_flap = 200;
					me.flaptrgt = tgt_flap - 30 - me.ASI;
					
					me.SPDflaptrgtdiff = tgt_flap - ind_spd;
				
					if (me.SPDflaptrgtdiff >= -42 and me.SPDflaptrgtdiff <= 42) {
						me["flap_max"].show();
						me["flap_max"].setTranslation(0, me.flaptrgt * -6.6);
					} else {
						me["flap_max"].hide();
					}
				} else if (flap_config.getValue() == '2') {
					me["S_target"].hide();
					me["clean_speed"].hide();
					
					tgt_F = fmgc.FMGCInternal.flap2;
					
					if (tgt_F <= 30) {
						me.Ftrgt = 0 - me.ASI;
					} else if (tgt_F >= 420) {
						me.Ftrgt = 390 - me.ASI;
					} else {
						me.Ftrgt = tgt_F - 30 - me.ASI;
					}
				
					me.SPDftrgtdiff = tgt_F - ind_spd;
				
					if (me.SPDftrgtdiff >= -42 and me.SPDftrgtdiff <= 42 and gear_agl.getValue() >= 400) {
						me["F_target"].show();
						me["F_target"].setTranslation(0, me.Ftrgt * -6.6);
					} else {
						me["F_target"].hide();
					}
					
					tgt_flap = 185;
					me.flaptrgt = tgt_flap - 30 - me.ASI;
					
					me.SPDflaptrgtdiff = tgt_flap - ind_spd;
				
					if (me.SPDflaptrgtdiff >= -42 and me.SPDflaptrgtdiff <= 42) {
						me["flap_max"].show();
						me["flap_max"].setTranslation(0, me.flaptrgt * -6.6);
					} else {
						me["flap_max"].hide();
					}
				} else if (flap_config.getValue() == '3') {
					me["S_target"].hide();
					me["clean_speed"].hide();
					
					tgt_F = fmgc.FMGCInternal.flap3;
						
					if (tgt_F <= 30) {
						me.Ftrgt = 0 - me.ASI;
					} else if (tgt_F >= 420) {
						me.Ftrgt = 390 - me.ASI;
					} else {
						me.Ftrgt = tgt_F - 30 - me.ASI;
					}
				
					me.SPDftrgtdiff = tgt_F - ind_spd;
				
					if (me.SPDftrgtdiff >= -42 and me.SPDftrgtdiff <= 42 and gear_agl.getValue() >= 400) {
						me["F_target"].show();
						me["F_target"].setTranslation(0, me.Ftrgt * -6.6);
					} else {
						me["F_target"].hide();
					}
					
					tgt_flap = 177;
					me.flaptrgt = tgt_flap - 30 - me.ASI;
					
					me.SPDflaptrgtdiff = tgt_flap - ind_spd;
				
					if (me.SPDflaptrgtdiff >= -42 and me.SPDflaptrgtdiff <= 42) {
						me["flap_max"].show();
						me["flap_max"].setTranslation(0, me.flaptrgt * -6.6);
					} else {
						me["flap_max"].hide();
					}
				} else if (flap_config.getValue() == '4') {
					me["S_target"].hide();
					me["F_target"].hide();
					me["clean_speed"].hide();	
					me["flap_max"].hide();
				} else {
					me["S_target"].hide();
					me["F_target"].hide();
					
					tgt_clean = fmgc.FMGCInternal.clean;
					
					me.cleantrgt = tgt_clean - 30 - me.ASI;
					me.SPDcleantrgtdiff = tgt_clean - ind_spd;
				
					if (me.SPDcleantrgtdiff >= -42 and me.SPDcleantrgtdiff <= 42) {
						me["clean_speed"].show();
						me["clean_speed"].setTranslation(0, me.cleantrgt * -6.6);
					} else {
						me["clean_speed"].hide();
					}	
					
					tgt_flap = 230;
					me.flaptrgt = tgt_flap - 30 - me.ASI;
					
					me.SPDflaptrgtdiff = tgt_flap - ind_spd;
				
					if (me.SPDflaptrgtdiff >= -42 and me.SPDflaptrgtdiff <= 42) {
						me["flap_max"].show();
						me["flap_max"].setTranslation(0, me.flaptrgt * -6.6);
					} else {
						me["flap_max"].hide();
					}
				}
			} else {
				me["S_target"].hide();
				me["F_target"].hide();
				me["clean_speed"].hide();
				me["flap_max"].hide();
			}
			
			me.ASItrend = dmc.DMController.DMCs[1].outputs[6].getValue() - me.ASI;
			me["ASI_trend_up"].setTranslation(0, math.clamp(me.ASItrend, 0, 50) * -6.6);
			me["ASI_trend_down"].setTranslation(0, math.clamp(me.ASItrend, -50, 0) * -6.6);
			
			if (me.ASItrend >= 2) {
				me["ASI_trend_up"].show();
				me["ASI_trend_down"].hide();
			} else if (me.ASItrend <= -2) {
				me["ASI_trend_down"].show();
				me["ASI_trend_up"].hide();
			} else {
				me["ASI_trend_up"].hide();
				me["ASI_trend_down"].hide();
			}
		} else {
			me["ASI_error"].show();
			me["ASI_group"].hide();
			me["ASI_frame"].setColor(1,0,0);
			me["clean_speed"].hide();
			me["S_target"].hide();
			me["F_target"].hide();
			me["flap_max"].hide();
			me["v1_group"].hide();
			me["v1_text"].hide();
			me["vr_speed"].hide();
			me["ground"].hide();
			me["ground_ref"].hide();
			me["VLS_min"].hide();
			me["VLS_min"].hide();
			me["ALPHA_PROT"].hide();
			me["ALPHA_MAX"].hide();
			me["ALPHA_SW"].hide();
		}
		
		if (dmc.DMController.DMCs[1].outputs[2] != nil) {
			ind_mach = dmc.DMController.DMCs[1].outputs[2].getValue();
			me["machError"].hide();
			if (ind_mach >= 0.5) {
				me["ASI_mach_decimal"].show();
				me["ASI_mach"].show();
			} else {
				me["ASI_mach_decimal"].hide();
				me["ASI_mach"].hide();
			}
			
			if (ind_mach >= 0.999) {
				me["ASI_mach"].setText("999");
			} else {
				me["ASI_mach"].setText(sprintf("%3.0f", ind_mach * 1000));
			}
		} else {
			me["machError"].show();
		}
		
		if (dmc.DMController.DMCs[1].outputs[1] != nil) {
			me["ALT_error"].hide();
			me["ALT_frame"].setColor(1,1,1);
			me["ALT_group"].show();
			me["ALT_tens"].show();
			me["ALT_box"].show();
			me["ALT_group2"].show();
			me["ALT_scale"].show();
			
			me.altitude = dmc.DMController.DMCs[1].outputs[1].getValue();
			me.altOffset = me.altitude / 500 - int(me.altitude / 500);
			me.middleAltText = roundaboutAlt(me.altitude / 100);
			me.middleAltOffset = nil;
			if (me.altOffset > 0.5) {
				me.middleAltOffset = -(me.altOffset - 1) * 243.3424;
			} else {
				me.middleAltOffset = -me.altOffset * 243.3424;
			}
			me["ALT_scale"].setTranslation(0, -me.middleAltOffset);
			me["ALT_scale"].update();
			me["ALT_five"].setText(sprintf("%03d", abs(me.middleAltText+10)));
			me["ALT_four"].setText(sprintf("%03d", abs(me.middleAltText+5)));
			me["ALT_three"].setText(sprintf("%03d", abs(me.middleAltText)));
			me["ALT_two"].setText(sprintf("%03d", abs(me.middleAltText-5)));
			me["ALT_one"].setText(sprintf("%03d", abs(me.middleAltText-10)));
			
			if (me.altitude < 0) {
				me["ALT_neg"].show();
			} else {
				me["ALT_neg"].hide();
			}
			
			me["ALT_digits"].setText(sprintf("%d", dmc.DMController.DMCs[1].outputs[3].getValue()));
			altTens = num(right(sprintf("%02d", me.altitude), 2));
			me["ALT_tens"].setTranslation(0, altTens * 1.392);
			
			ap_alt_cur = ap_alt.getValue();
			alt_diff_cur = alt_diff.getValue();
			if (alt_diff_cur >= -565 and alt_diff_cur <= 565) {
				me["ALT_target"].setTranslation(0, (alt_diff_cur / 100) * -48.66856);
				me["ALT_target_digit"].setText(sprintf("%03d", math.round(ap_alt_cur / 100)));
				me["ALT_digit_UP"].hide();
				me["ALT_digit_DN"].hide();
				me["ALT_target"].show();
			} else if (alt_diff_cur < -565) {
				if (alt_std_mode.getValue() == 1) {
					if (ap_alt_cur < 10000) {
						me["ALT_digit_DN"].setText(sprintf("%s", "FL   " ~ ap_alt_cur / 100));
					} else {
						me["ALT_digit_DN"].setText(sprintf("%s", "FL " ~ ap_alt_cur / 100));
					}
				} else {
					me["ALT_digit_DN"].setText(sprintf("%5.0f", ap_alt_cur));
				}
				me["ALT_digit_DN"].show();
				me["ALT_digit_UP"].hide();
				me["ALT_target"].hide();
			} else if (alt_diff_cur > 565) {
				if (alt_std_mode.getValue() == 1) {
					if (ap_alt_cur < 10000) {
						me["ALT_digit_UP"].setText(sprintf("%s", "FL   " ~ ap_alt_cur / 100));
					} else {
						me["ALT_digit_UP"].setText(sprintf("%s", "FL " ~ ap_alt_cur / 100));
					}
				} else {
					me["ALT_digit_UP"].setText(sprintf("%5.0f", ap_alt_cur));
				}
				me["ALT_digit_UP"].show();
				me["ALT_digit_DN"].hide();
				me["ALT_target"].hide();
			}
			
			ground_diff_cur = -gear_agl.getValue();
			if (ground_diff_cur >= -565 and ground_diff_cur <= 565) {
				me["ground_ref"].setTranslation(0, (ground_diff_cur / 100) * -48.66856);
				me["ground_ref"].show();
			} else {
				me["ground_ref"].hide();
			}
			
			if (ground_diff_cur >= -565 and ground_diff_cur <= 565) {
				if ((fmgc.FMGCInternal.phase == 5 or fmgc.FMGCInternal.phase == 6) and !wow1.getValue() and !wow2.getValue()) { #add std too
					me["ground"].setTranslation(0, (ground_diff_cur / 100) * -48.66856);
					me["ground"].show();
				} else {
					me["ground"].hide();
				}
			} else {
				me["ground"].hide();
			}
			
			if (!ecam.altAlertFlash and !ecam.altAlertSteady) {
				alt_going2 = 0;
				amber_going2 = 0;
				me["ALT_box_flash"].hide();
				me["ALT_box_amber"].hide();
			} else {
				if (ecam.altAlertFlash) {
					if (alt_going2 == 1) {
						me["ALT_box_flash"].hide(); 
						altTimer2.stop();
					}
					if (amber_going2 == 0) {
						amber_going2 = 1;
					}
					if (amber_going2 == 1) {
						me["ALT_box_amber"].show();
						me["ALT_box"].hide();
						amberTimer2.start();
					}
					if (amberFlash2.getValue() == 1) {
						me["ALT_box_amber"].show(); 
					} else {
						me["ALT_box_amber"].hide(); 
					}
				} elsif (ecam.altAlertSteady) {
					if (amber_going2 == 1) {
						me["ALT_box"].show();
						me["ALT_box_amber"].hide();
						amberTimer2.stop();
					}
					if (alt_going2 == 0) {
						alt_going2 = 1;
					}
					if (alt_going2 == 1) {
						me["ALT_box_flash"].show(); 
						altTimer2.start();
					}
					if (altFlash2.getValue() == 1) {
						me["ALT_box_flash"].show(); 
					} else {
						me["ALT_box_flash"].hide(); 
					}
				}
			}
		} else {
			me["ALT_error"].show();
			me["ALT_frame"].setColor(1,0,0);
			me["ALT_group"].hide();
			me["ALT_tens"].hide();
			me["ALT_neg"].hide();
			me["ALT_group2"].hide();
			me["ALT_scale"].hide();
			me["ALT_box_flash"].hide();
			me["ALT_box_amber"].hide();
			me["ALT_box"].hide();
		}
		
		me.updateCommonFast();
	},
};

var canvas_PFD_1_test = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_1_test]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["Test_white","Test_text"];
	},
	update: func() {
		et = elapsedtime.getValue() or 0;
		
	},
};

var canvas_PFD_2_test = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_2_test]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["Test_white","Test_text"];
	},
	update: func() {
		et = elapsedtime.getValue() or 0;
		if ((du6_test_time.getValue() + 1 >= et) and fo_du_xfr.getValue() != 1) {
			me["Test_white"].show();
			me["Test_text"].hide();
		} else if ((du5_test_time.getValue() + 1 >= et) and fo_du_xfr.getValue() != 0) {
			me["Test_white"].show();
			me["Test_text"].hide();
		} else {
			me["Test_white"].hide();
			me["Test_text"].show();
		}
	},
};

setlistener("/systems/electrical/bus/ac-ess", func() {
	canvas_PFD_base.updateDu1();
}, 0, 0);

setlistener("/systems/electrical/bus/ac-2", func() {
	canvas_PFD_base.updateDu6();
}, 0, 0);

