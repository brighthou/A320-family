# A3XX PFD

# Copyright (c) 2020 Josh Davidson (Octal450)

var acconfig_mismatch = props.globals.getNode("/systems/acconfig/mismatch-code", 1);

# Fetch nodes:
var wow0 = props.globals.getNode("/gear/gear[0]/wow");
var wow1 = props.globals.getNode("/gear/gear[1]/wow");
var wow2 = props.globals.getNode("/gear/gear[2]/wow");
var acconfig = props.globals.getNode("/systems/acconfig/autoconfig-running", 1);
var alt_std_mode = props.globals.getNode("/instrumentation/altimeter/std", 1);
var alt_inhg_mode = props.globals.getNode("/instrumentation/altimeter/inhg", 1);
var target_altitude = props.globals.getNode("/autopilot/settings/target-altitude-ft", 1);
var altitude = props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft", 1);
var altitude_pfd = props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft-pfd", 1);
var ap_alt = props.globals.getNode("/it-autoflight/internal/alt", 1);
var vs_needle = props.globals.getNode("/instrumentation/pfd/vs-needle", 1);
var vs_digit = props.globals.getNode("/instrumentation/pfd/vs-digit-trans", 1);
var ap_vs_pfd = props.globals.getNode("/it-autoflight/internal/vert-speed-fpm-pfd", 1);
var ind_spd_kt = props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt", 1);
var ind_spd_mach = props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach", 1);
var at_mach_mode = props.globals.getNode("/it-autoflight/input/kts-mach", 1);
var at_input_spd_mach = props.globals.getNode("/it-autoflight/input/mach", 1);
var at_input_spd_kts = props.globals.getNode("/it-autoflight/input/kts", 1);
var decision = props.globals.getNode("/instrumentation/mk-viii/inputs/arinc429/decision-height", 1);
var loc = props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm", 1);
var gs = props.globals.getNode("/instrumentation/nav[0]/gs-needle-deflection-norm", 1);
var show_hdg = props.globals.getNode("/it-autoflight/custom/show-hdg", 1);
var ap_hdg = props.globals.getNode("/it-autoflight/input/hdg", 1);
var ap_trk_sw = props.globals.getNode("/it-autoflight/custom/trk-fpa", 1);
var loc_in_range = props.globals.getNode("/instrumentation/nav[0]/in-range", 1);
var gs_in_range = props.globals.getNode("/instrumentation/nav[0]/gs-in-range", 1);
var nav0_signalq = props.globals.getNode("/instrumentation/nav[0]/signal-quality-norm", 1);
var hasloc = props.globals.getNode("/instrumentation/nav[0]/nav-loc", 1);
var hasgs = props.globals.getNode("/instrumentation/nav[0]/has-gs", 1);
var pfdrate = props.globals.getNode("/systems/acconfig/options/pfd-rate", 1);
var managed_spd = props.globals.getNode("/it-autoflight/input/spd-managed", 1);
var at_tgt_ias = props.globals.getNode("/FMGC/internal/target-ias-pfd", 1);
var att_switch = props.globals.getNode("/controls/navigation/switching/att-hdg", 1);
var air_switch = props.globals.getNode("/controls/navigation/switching/air-data", 1);
var appr_enabled = props.globals.getNode("/it-autoflight/output/appr-armed/", 1);
var loc_enabled = props.globals.getNode("/it-autoflight/output/loc-armed/", 1);
var vert_gs = props.globals.getNode("/it-autoflight/output/vert/", 1);
var vert_state = props.globals.getNode("/it-autoflight/output/vert/", 1);
var ils_data1 = props.globals.getNode("/FMGC/internal/ils1-mcdu/", 1);
# Independent MCDU ILS not implemented yet, use MCDU1 in the meantime
# var ils_data2 = props.globals.getNode("/FMGC/internal/ils2-mcdu/", 1);
var dme_in_range = props.globals.getNode("/instrumentation/nav[0]/dme-in-range", 1);
var dme_data = props.globals.getNode("/instrumentation/dme[0]/indicated-distance-nm", 1);
var ils_crs = props.globals.getNode("/instrumentation/nav[0]/radials/selected-deg", 1);
var ils1_crs_set = props.globals.getNode("/FMGC/internal/ils1crs-set/", 1);
var flap_config = props.globals.getNode("/controls/flight/flaps-input", 1);
var hundredAbove = props.globals.getNode("/instrumentation/pfd/hundred-above", 1);
var minimum = props.globals.getNode("/instrumentation/pfd/minimums", 1);
var aoa_1 = props.globals.getNode("/systems/navigation/adr/output/aoa-1", 1);
var aoa_2 = props.globals.getNode("/systems/navigation/adr/output/aoa-2", 1);
var aoa_3 = props.globals.getNode("/systems/navigation/adr/output/aoa-3", 1);
var adr_1_switch = props.globals.getNode("/controls/navigation/adirscp/switches/adr-1", 1);
var adr_2_switch = props.globals.getNode("/controls/navigation/adirscp/switches/adr-2", 1);
var adr_3_switch = props.globals.getNode("/controls/navigation/adirscp/switches/adr-3", 1);
var adr_1_fault = props.globals.getNode("/controls/navigation/adirscp/lights/adr-1-fault", 1);
var adr_2_fault = props.globals.getNode("/controls/navigation/adirscp/lights/adr-2-fault", 1);
var adr_3_fault = props.globals.getNode("/controls/navigation/adirscp/lights/adr-3-fault", 1);
var air_data_switch = props.globals.getNode("/controls/navigation/switching/air-data", 1);

# Create nodes
var du1_test = props.globals.initNode("/instrumentation/du/du1-test", 0, "BOOL");
var du1_test_time = props.globals.initNode("/instrumentation/du/du1-test-time", 0.0, "DOUBLE");
var du1_offtime = props.globals.initNode("/instrumentation/du/du1-off-time", 0.0, "DOUBLE");
var du1_test_amount = props.globals.initNode("/instrumentation/du/du1-test-amount", 0.0, "DOUBLE");
var du2_test = props.globals.initNode("/instrumentation/du/du2-test", 0, "BOOL");
var du2_test_time = props.globals.initNode("/instrumentation/du/du2-test-time", 0.0, "DOUBLE");
var du2_test_amount = props.globals.initNode("/instrumentation/du/du2-test-amount", 0.0, "DOUBLE");
var du5_test = props.globals.initNode("/instrumentation/du/du5-test", 0, "BOOL");
var du5_test_time = props.globals.initNode("/instrumentation/du/du5-test-time", 0.0, "DOUBLE");
var du5_test_amount = props.globals.initNode("/instrumentation/du/du5-test-amount", 0.0, "DOUBLE");
var du6_test = props.globals.initNode("/instrumentation/du/du6-test", 0, "BOOL");
var du6_test_time = props.globals.initNode("/instrumentation/du/du6-test-time", 0.0, "DOUBLE");
var du6_test_amount = props.globals.initNode("/instrumentation/du/du6-test-amount", 0.0, "DOUBLE");
var du6_offtime = props.globals.initNode("/instrumentation/du/du6-off-time", 0.0, "DOUBLE");

var alt_diff = props.globals.initNode("/instrumentation/pfd/alt-diff", 0.0, "DOUBLE");
var heading = props.globals.initNode("/instrumentation/pfd/heading-deg", 0.0, "DOUBLE");
var horizon_pitch = props.globals.initNode("/instrumentation/pfd/horizon-pitch", 0.0, "DOUBLE");
var horizon_ground = props.globals.initNode("/instrumentation/pfd/horizon-ground", 0.0, "DOUBLE");
var hdg_diff = props.globals.initNode("/instrumentation/pfd/hdg-diff", 0.0, "DOUBLE");
var hdg_scale = props.globals.initNode("/instrumentation/pfd/heading-scale", 0.0, "DOUBLE");
var track = props.globals.initNode("/instrumentation/pfd/track-deg", 0.0, "DOUBLE");
#var track_diff = props.globals.initNode("/instrumentation/pfd/track-hdg-diff", 0.0, "DOUBLE"); # returns incorrect value
var ilsFlash1 = props.globals.initNode("/instrumentation/pfd/flash-indicators/ils-flash-1", 0, "BOOL");
var ilsFlash2 = props.globals.initNode("/instrumentation/pfd/flash-indicators/ils-flash-2", 0, "BOOL");
var qnhFlash = props.globals.initNode("/instrumentation/pfd/flash-indicators/qnh-flash", 0, "BOOL");
var altFlash1 = props.globals.initNode("/instrumentation/pfd/flash-indicators/alt-flash-1", 0, "BOOL");
var altFlash2 = props.globals.initNode("/instrumentation/pfd/flash-indicators/alt-flash-2", 0, "BOOL");
var amberFlash1 = props.globals.initNode("/instrumentation/pfd/flash-indicators/amber-flash-1", 0, "BOOL");
var amberFlash2 = props.globals.initNode("/instrumentation/pfd/flash-indicators/amber-flash-2", 0, "BOOL");
var dhFlash = props.globals.initNode("/instrumentation/pfd/flash-indicators/dh-flash", 0, "BOOL");

var canvas_PFD = {
	new: func(svg, name, placement, number) {
		var obj = {parents: [canvas_PFD] };
		obj.canvas = canvas.new({
			"name": name,
			"size": [1024, 1024],
			"view": [1024, 1024],
			"mipmapping": 1,
		});
		
		obj.canvas.addPlacement({"node": placement});
        obj.group = obj.canvas.createGroup();
        obj.group_test = obj.canvas.createGroup();
        obj.group_mismatch = obj.canvas.createGroup();
		
		obj.number = number;
		
		obj.font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(obj.group, svg, {"font-mapper": obj.font_mapper} );
		canvas.parsesvg(obj.group_test, "Aircraft/A320-family/Models/Instruments/Common/res/du-test.svg", {"font-mapper": obj.font_mapper} );
		canvas.parsesvg(obj.group_mismatch, "Aircraft/A320-family/Models/Instruments/Common/res/mismatch.svg", {"font-mapper": obj.font_mapper} );
		
		if (acconfig_mismatch.getValue() != "0x000") {
			obj.group.hide();
			obj.group_test.hide();
			obj.group_mismatch.show();
			obj.updateMismatch(nil);
			return obj;
		}
		obj.group_mismatch.hide();
		
 		foreach(var key; obj.getKeys()) {
			obj[key] = obj.group.getElementById(key);
			
			var clip_el = obj.group.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tran_rect = clip_el.getTransformedBounds();

				var clip_rect = sprintf("rect(%d,%d, %d,%d)", 
				tran_rect[1],
				tran_rect[2],
				tran_rect[3],
				tran_rect[0]);
				obj[key].set("clip", clip_rect);
				obj[key].set("clip-frame", canvas.Element.PARENT);
			}
		};
		
		obj["FMA_catmode"].hide();
		obj["FMA_cattype"].hide();
		obj["FMA_catmode_box"].hide();
		obj["FMA_cattype_box"].hide();
		obj["FMA_cat_box"].hide();
		
		foreach(var key; obj.getKeysTest()) {
			obj[key] = obj.group_test.getElementById(key);
		};
		obj.AI_horizon_trans = obj["AI_horizon"].createTransform();
		obj.AI_horizon_rot = obj["AI_horizon"].createTransform();
		
		obj.AI_horizon_ground_trans = obj["AI_horizon_ground"].createTransform();
		obj.AI_horizon_ground_rot = obj["AI_horizon_ground"].createTransform();
		
		obj.AI_horizon_sky_rot = obj["AI_horizon_sky"].createTransform();
		
		obj.AI_horizon_hdg_trans = obj["AI_heading"].createTransform();
		obj.AI_horizon_hdg_rot = obj["AI_heading"].createTransform();

		obj.AI_fpv_trans = obj["FPV"].createTransform();
		obj.AI_fpv_rot = obj["FPV"].createTransform();
		
		obj.page = obj.group;
		
		obj.update_items_fast = [
			props.UpdateManager.FromHashValue("pitchPFD", nil, func(val) {
				obj.AI_horizon_trans.setTranslation(0, val * 11.825);
			}),
			props.UpdateManager.FromHashValue("fdPitch", nil, func(val) {
				if (val != nil) {
					obj["FD_pitch"].setTranslation(val * 2.2, 0);
				}
			}),
			props.UpdateManager.FromHashValue("roll", nil, func(val) {
				obj.AI_horizon_rot.setRotation(-val * D2R, obj["AI_center"].getCenter());
				obj.AI_horizon_ground_rot.setRotation(-val * D2R, obj["AI_center"].getCenter());
				obj.AI_horizon_sky_rot.setRotation(-val * D2R, obj["AI_center"].getCenter());
				obj["AI_bank"].setRotation(-val * D2R);
				obj["AI_agl_g"].setRotation(-val * D2R);
			}),
			props.UpdateManager.FromHashValue("fdRoll", nil, func(val) {
				if (val != nil) {
					obj["FD_pitch"].setTranslation(0, -val * 3.8);
				}
			}),
			props.UpdateManager.FromHashValue("horizonGround", nil, func(val) {
				obj.AI_horizon_ground_trans.setTranslation(0, val * 11.825);
			}),
			props.UpdateManager.FromHashValue("slipSkid", nil, func(val) {
				obj["AI_slipskid"].setTranslation(math.clamp(val, -15, 15) * 7, 0);
			}),
			props.UpdateManager.FromHashList(["alt_inhg_mode","alt_hpa","alt_inhg"], nil, func(val) {
				if (val.alt_inhg_mode == 0) {
					obj["QNH_setting"].setText(sprintf("%4.0f", val.alt_hpa));
				} else {
					obj["QNH_setting"].setText(sprintf("%2.2f", val.alt_inhg));
				}
			}),
			props.UpdateManager.FromHashValue("gearAglFt", 1, func(val) {
				obj["AI_agl"].setText(sprintf("%s", math.round(math.clamp(val, 0, 2500))));
			}),
		];
		
		obj.update_items_ground = [
			props.UpdateManager.FromHashList(["aileronInput","elevatorInput"], nil, func(val) {
				obj["AI_stick_pos"].setTranslation(val.aileronInput * 196.8, val.elevatorInput * 151.5);
			}),
		];
		
		obj.update_items = [
			props.UpdateManager.FromHashValue("pitch_mode", nil, func(val) {
				obj["FMA_pitch"].setText(sprintf("%s", val));
				obj["FMA_combined"].setText(sprintf("%s", val));
				
				if (val == "LAND" or val == "FLARE" or val == "ROLL OUT") {
					obj["FMA_pitch"].hide();
					obj["FMA_roll"].hide();
					obj["FMA_pitch_box"].hide();
					obj["FMA_roll_box"].hide();
					obj["FMA_pitcharm_box"].hide();
					obj["FMA_rollarm_box"].hide();
					obj["FMA_Middle1"].hide();
					obj["FMA_Middle2"].hide();
					obj["FMA_combined"].show();
				} else {
					obj["FMA_combined"].hide();
				}
			}),
			props.UpdateManager.FromHashList(["ap1","ap2","fd1","fd2","roll_mode_box","roll_mode_armed_box","roll_mode","roll_mode_armed","pitch_mode", "pitch_mode_box","pitch_mode_armed","pitch_mode2_armed","pitch_mode_armed_box","pitch_mode_armed_box"], nil, func(val) {
				if (val.pitch_mode == "LAND" or val.pitch_mode == "FLARE" or val.pitch_mode == "ROLL OUT") {
					if (val.pitch_mode_box == 1) {
						obj["FMA_combined_box"].show();
					} else {
						obj["FMA_combined_box"].hide();
					}
				} else {
					obj["FMA_combined_box"].hide();
					
					if (val.pitch_mode_box == 1 and val.pitch_mode != " " and (val.ap1 or val.ap2 or val.fd1 or val.fd2)) {
						obj["FMA_pitch_box"].show();
					} else {
						obj["FMA_pitch_box"].hide();
					}
					
					if (val.pitch_mode_armed == " " and val.pitch_mode2_armed == " ") {
						obj["FMA_pitcharm_box"].hide();
					} else {
						if ((val.pitch_mode_armed_box or val.pitch_mode2_armed_box) and (val.ap1 or val.ap2 or val.fd1 or val.fd2)) {
							obj["FMA_pitcharm_box"].show();
						} else {
							obj["FMA_pitcharm_box"].hide();
						}
					}
					
					if (val.roll_mode_box == 1 and val.roll_mode != " " and (val.ap1 or val.ap2 or val.fd1 or val.fd2)) {
						obj["FMA_roll_box"].show();
					} else {
						obj["FMA_roll_box"].hide();
					}
					
					if (val.roll_mode_armed_box == 1 and val.roll_mode_armed != " " and (val.ap1 or val.ap2 or val.fd1 or val.fd2)) {
						obj["FMA_rollarm_box"].show();
					} else {
						obj["FMA_rollarm_box"].hide();
					}
				}
			}),
			props.UpdateManager.FromHashValue("pitch_mode_armed", nil, func(val) {
				obj["FMA_pitcharm"].setText(sprintf("%s", val));
			}),
			props.UpdateManager.FromHashValue("pitch_mode2_armed", nil, func(val) {
				obj["FMA_pitcharm2"].setText(sprintf("%s", val));
			}),
			props.UpdateManager.FromHashValue("roll_mode", nil, func(val) {
				obj["FMA_roll"].setText(sprintf("%s", val));
			}),
			props.UpdateManager.FromHashValue("roll_mode_armed", nil, func(val) {
				obj["FMA_rollarm"].setText(sprintf("%s", val));
			}),
			props.UpdateManager.FromHashValue("ap_mode", nil, func(val) {
				obj["FMA_ap"].setText(sprintf("%s", val));
			}),
			props.UpdateManager.FromHashValue("at_mode", nil, func(val) {
				obj["FMA_athr"].setText(sprintf("%s", val));
			}),
			props.UpdateManager.FromHashValue("athr_arm", nil, func(val) {
				if (val != 1) {
					obj["FMA_athr"].setColor(0.8078,0.8039,0.8078);
				} else {
					obj["FMA_athr"].setColor(0.0901,0.6039,0.7176);
				}
			}),
			props.UpdateManager.FromHashValue("fd_mode", nil, func(val) {
				obj["FMA_fd"].setText(sprintf("%s", val));
			}),
			props.UpdateManager.FromHashList(["ap_box","ap_mode"], nil, func(val) {
				if (val.ap_box and val.ap_mode != " ") {
					obj["FMA_ap_box"].show();
				} else {
					obj["FMA_ap_box"].hide();
				}
			}),
			props.UpdateManager.FromHashList(["at_box","at_mode"], nil, func(val) {
				if (val.at_box and val.at_mode != " ") {
					obj["FMA_athr_box"].show();
				} else {
					obj["FMA_athr_box"].hide();
				}
			}),
			props.UpdateManager.FromHashList(["fd_box","fd_mode"], nil, func(val) {
				if (val.fd_box and val.fd_mode != " ") {
					obj["FMA_fd_box"].show();
				} else {
					obj["FMA_fd_box"].hide();
				}
			}),
			props.UpdateManager.FromHashList(["ap1","ap2","fd1","fd2"], nil, func(val) {
				if (val.ap1 or val.ap2 or val.fd1 or val.fd2) {
					obj["FMA_pitch"].show();
					obj["FMA_roll"].show();
					obj["FMA_pitcharm"].show();
					obj["FMA_pitcharm2"].show();
					obj["FMA_rollarm"].show();
				} else {
					obj["FMA_pitch"].hide();
					obj["FMA_roll"].hide();
					obj["FMA_pitcharm"].hide();
					obj["FMA_pitcharm2"].hide();
					obj["FMA_rollarm"].hide();
				}
			}),
			props.UpdateManager.FromHashList(["alphaFloor","engOut","state1","state2","togaLk","throttleBox","throttleMode"], nil, func(val) {
				if (val.alphaFloor != 1 and val.togaLk != 1) {
					if (val.athr == 1 and val.engOut != 1 and (val.state1 == "MAN" or val.state1 == "CL") and (val.state2 == "MAN" or val.state2 == "CL")) {
						obj["FMA_thrust"].show();
						if (val.throttleBox and val.throttleMode != " ") {
							obj["FMA_thrust_box"].show();
						} else {
							obj["FMA_thrust_box"].hide();
						}
					} else if (val.athr == 1 and val.engOut == 1 and (val.state1 == "MAN" or val.state1 == "CL" or (val.state1 == "MAN THR" and val.thr1 < 0.83) or (val.state1 == "MCT" and val.thrustLimit != "FLX")) and 
					(val.state2 == "MAN" or val.state2 == "CL" or (val.state2 == "MAN THR" and val.thr2 < 0.83) or (val.state2 == "MCT" and val.thrustLimit != "FLX"))) {
						obj["FMA_thrust"].show();
						if (val.throttleBox == 1 and val.throttleMode != " ") {
							obj["FMA_thrust_box"].show();
						} else {
							obj["FMA_thrust_box"].hide();
						}
					} else {
						obj["FMA_thrust"].hide();
						obj["FMA_thrust_box"].hide();
					}
				} else {
					obj["FMA_thrust"].show();
					obj["FMA_thrust_box"].show();
				}
				
				if ((val.state1 == "CL" and val.state2 != "CL") or (val.state1 != "CL" and val.state2 == "CL") and val.engOut != 1) {
					obj["FMA_lvrclb"].setText("LVR ASYM");
				} else {
					if (val.engOut) {
						obj["FMA_lvrclb"].setText("LVR MCT");
					} else {
						obj["FMA_lvrclb"].setText("LVR CLB");
					}
				}
			}),
			props.UpdateManager.FromHashList(["alphaFloor","togaLk","throttleMode"], nil, func(val) {
				if (val.alphaFloor == 1) {
					obj["FMA_thrust"].setText("A.FLOOR");
					obj["FMA_thrust_box"].setColor(0.7333,0.3803,0);
				} elsif (val.togaLk == 1) {
					obj["FMA_thrust"].setText("TOGA LK");
					obj["FMA_thrust_box"].setColor(0.7333,0.3803,0);
				} else {
					obj["FMA_thrust"].setText(sprintf("%s", val.throttleMode));
					obj["FMA_thrust_box"].setColor(0.8078,0.8039,0.8078);
				}
			}),
			props.UpdateManager.FromHashList(["athr","lvrClb"], nil, func(val) {
				if (val.athr and val.lvrClb) {
					obj["FMA_lvrclb"].show();
				} else {
					obj["FMA_lvrclb"].hide();
				}
			}),
			props.UpdateManager.FromHashValue("fbwLaw", nil, func(val) {
				if (val == 0) {
					obj["AI_bank_lim"].show();
					obj["AI_pitch_lim"].show();
					obj["AI_bank_lim_X"].hide();
					obj["AI_pitch_lim_X"].hide();
				} else {
					obj["AI_bank_lim"].hide();
					obj["AI_pitch_lim"].hide();
					obj["AI_bank_lim_X"].show();
					obj["AI_pitch_lim_X"].show();
				}
			}),
			props.UpdateManager.FromHashList(["athr","state1","state2","flex","engOut","alphaFloor","thrustLimit","togaLk","thr1","thr2"], nil, func(val) {
				if (val.athr and (val.state1 == "TOGA" or val.state1 == "MCT" or val.state1 == "MAN THR" or val.state2 == "TOGA" or val.state2 == "MCT" or val.state2 == "MAN THR") and val.engOut != 1 and val.alphaFloor != 1 and val.togaLk != 1) {
					obj["FMA_man"].show();
					if (val.state1 == "TOGA" or val.state2 == "TOGA") {
						obj["FMA_flx_box"].hide();
						obj["FMA_flxtemp"].hide();
						obj["FMA_man_box"].show();
						obj["FMA_manmode"].show();
						obj["FMA_flxmode"].hide();
						obj["FMA_manmode"].setText("TOGA");
						obj["FMA_man_box"].setColor(0.8078,0.8039,0.8078);
					} else if ((val.state1 == "MAN THR" and val.thr1 >= 0.83) or (val.state2 == "MAN THR" and val.thr2 >= 0.83)) {
						obj["FMA_flx_box"].hide();
						obj["FMA_flxtemp"].hide();
						obj["FMA_man_box"].show();
						obj["FMA_manmode"].show();
						obj["FMA_flxmode"].hide();
						obj["FMA_manmode"].setText("THR");
						obj["FMA_man_box"].setColor(0.7333,0.3803,0);
					} else if ((val.state1 == "MCT" or val.state2 == "MCT") and val.thrustLimit != "FLX") {
						obj["FMA_flx_box"].hide();
						obj["FMA_flxtemp"].hide();
						obj["FMA_man_box"].show();
						obj["FMA_manmode"].show();
						obj["FMA_flxmode"].hide();
						obj["FMA_manmode"].setText("MCT");
						obj["FMA_man_box"].setColor(0.8078,0.8039,0.8078);
					} else if ((val.state1 == "MCT" or val.state2 == "MCT") and val.thrustLimit == "FLX") {
						obj["FMA_flxtemp"].setText(sprintf("%s", "+" ~ val.flexTemp));
						obj["FMA_man_box"].hide();
						obj["FMA_flx_box"].show();
						obj["FMA_flxtemp"].show();
						obj["FMA_manmode"].hide();
						obj["FMA_flxmode"].show();
						obj["FMA_man_box"].setColor(0.8078,0.8039,0.8078);
					} else if ((val.state1 == "MAN THR" and val.thr1 < 0.83) or (val.state2 == "MAN THR" and val.thr2 < 0.83)) {
						obj["FMA_flx_box"].hide();
						obj["FMA_flxtemp"].hide();
						obj["FMA_man_box"].show();
						obj["FMA_manmode"].show();
						obj["FMA_flxmode"].hide();
						obj["FMA_manmode"].setText("THR");
						obj["FMA_man_box"].setColor(0.7333,0.3803,0);
					}
				} else if (val.athr and (val.state1 == "TOGA" or (val.state1 == "MCT" and val.thrustLimit == "FLX") or (val.state1 == "MAN THR" and val.thr1 >= 0.83) or val.state2 == "TOGA" or (val.state2 == "MCT" and 
				val.thrustLimit == "FLX") or (val.state2 == "MAN THR" and val.thr2 >= 0.83)) and val.engOut and val.alphaFloor != 1 and val.togaLk != 1) {
					obj["FMA_man"].show();
					if (val.state1 == "TOGA" or val.state2 == "TOGA") {
						obj["FMA_flx_box"].hide();
						obj["FMA_flxtemp"].hide();
						obj["FMA_man_box"].show();
						obj["FMA_manmode"].show();
						obj["FMA_flxmode"].hide();
						obj["FMA_manmode"].setText("TOGA");
						obj["FMA_man_box"].setColor(0.8078,0.8039,0.8078);
					} else if ((val.state1 == "MAN THR" and val.thr1 >= 0.83) or (val.state2 == "MAN THR" and val.thr2 >= 0.83)) {
						obj["FMA_flx_box"].hide();
						obj["FMA_flxtemp"].hide();
						obj["FMA_man_box"].show();
						obj["FMA_manmode"].show();
						obj["FMA_flxmode"].hide();
						obj["FMA_manmode"].setText("THR");
						obj["FMA_man_box"].setColor(0.7333,0.3803,0);
					} else if ((val.state1 == "MCT" or val.state2 == "MCT") and val.thrustLimit == "FLX") {
						obj["FMA_flxtemp"].setText(sprintf("%s", "+" ~ val.flexTemp));
						obj["FMA_man_box"].hide();
						obj["FMA_flx_box"].show();
						obj["FMA_flxtemp"].show();
						obj["FMA_manmode"].hide();
						obj["FMA_flxmode"].show();
						obj["FMA_man_box"].setColor(0.8078,0.8039,0.8078);
					}
				} else {
					obj["FMA_man"].hide();
					obj["FMA_manmode"].hide();
					obj["FMA_man_box"].hide();
					obj["FMA_flx_box"].hide();
					obj["FMA_flxtemp"].hide();
					obj["FMA_flxmode"].hide();
				}
			}),
			props.UpdateManager.FromHashList(["outerMarker","ap_ils_mode1","ap_ils_mode2"], nil, func(val) {
				if (val.outerMarker and ((obj.number == 1 and val.ap_ils_mode) or (obj.number == 2 and val.ap_ils_mode2))) {
					obj["outerMarker"].show();
				} else {
					obj["outerMarker"].hide();
				}
			}),
			props.UpdateManager.FromHashList(["middleMarker","ap_ils_mode1","ap_ils_mode2"], nil, func(val) {
				if (val.middleMarker and ((obj.number == 1 and val.ap_ils_mode) or (obj.number == 2 and val.ap_ils_mode2))) {
					obj["middleMarker"].show();
				} else {
					obj["middleMarker"].hide();
				}
			}),
			props.UpdateManager.FromHashList(["innerMarker","ap_ils_mode1","ap_ils_mode2"], nil, func(val) {
				if (val.innerMarker and ((obj.number == 1 and val.ap_ils_mode) or (obj.number == 2 and val.ap_ils_mode2))) {
					obj["innerMarker"].show();
				} else {
					obj["innerMarker"].hide();
				}
			}),
			props.UpdateManager.FromHashList(["fac1","fac2"], nil, func(val) {
				# Apparently SPD LIM only on captains PFD
				if (obj.number == 1 and (val.fac1 == 0 and val.fac2 == 0)) {
					obj["spdLimError"].show();
				} else {
					obj["spdLimError"].hide();
				}
			}),
		];
		
		return obj;
	},
	getKeys: func() {
		return ["FMA_man","FMA_manmode","FMA_flxmode","FMA_flxtemp","FMA_thrust","FMA_lvrclb","FMA_pitch","FMA_pitcharm","FMA_pitcharm2","FMA_roll","FMA_rollarm","FMA_combined","FMA_ctr_msg","FMA_catmode","FMA_cattype","FMA_nodh","FMA_dh","FMA_dhn","FMA_ap",
		"FMA_fd","FMA_athr","FMA_man_box","FMA_flx_box","FMA_thrust_box","FMA_pitch_box","FMA_pitcharm_box","FMA_roll_box","FMA_rollarm_box","FMA_combined_box","FMA_catmode_box","FMA_cattype_box","FMA_cat_box","FMA_dh_box","FMA_ap_box","FMA_fd_box",
		"FMA_athr_box","FMA_Middle1","FMA_Middle2","ALPHA_MAX","ALPHA_PROT","ALPHA_SW","ALPHA_bars","VLS_min","ASI_max","ASI_scale","ASI_target","ASI_mach","ASI_mach_decimal","ASI_trend_up","ASI_trend_down","ASI_digit_UP","ASI_digit_DN","ASI_decimal_UP",
		"ASI_decimal_DN","ASI_index","ASI_error","ASI_group","ASI_frame","AI_center","AI_bank","AI_bank_lim","AI_bank_lim_X","AI_pitch_lim","AI_pitch_lim_X","AI_slipskid","AI_horizon","AI_horizon_ground","AI_horizon_sky","AI_stick","AI_stick_pos","AI_heading",
		"AI_agl_g","AI_agl","AI_error","AI_group","FD_roll","FD_pitch","ALT_box_flash","ALT_box","ALT_box_amber","ALT_scale","ALT_target","ALT_target_digit","ALT_one","ALT_two","ALT_three","ALT_four","ALT_five","ALT_digits","ALT_tens","ALT_digit_UP",
		"ALT_digit_DN","ALT_error","ALT_neg","ALT_group","ALT_group2","ALT_frame","VS_pointer","VS_box","VS_digit","VS_error","VS_group","QNH","QNH_setting","QNH_std","QNH_box","LOC_pointer","LOC_scale","GS_scale","GS_pointer","CRS_pointer","HDG_target","HDG_scale",
		"HDG_one","HDG_two","HDG_three","HDG_four","HDG_five","HDG_six","HDG_seven","HDG_digit_L","HDG_digit_R","HDG_error","HDG_group","HDG_frame","TRK_pointer","machError","ilsError","ils_code","ils_freq","dme_dist","dme_dist_legend","ILS_HDG_R","ILS_HDG_L",
		"ILS_right","ILS_left","outerMarker","middleMarker","innerMarker","v1_group","v1_text","vr_speed","F_target","S_target","FS_targets","flap_max","clean_speed","ground","ground_ref","FPV","spdLimError"];
	},
	getKeysTest: func() {
		return ["Test_white", "Test_text"];
	},
	
	runAIStickPosUpdate: 0,
	update: func(notification) {
		me.updatePower(notification);
		
		if (me.group_test.getVisible() == 1) {
			me.updateTest(notification);
		}
		
		if (me.group.getVisible() == 0) {
			return;
		}
		
		foreach(var update_item; me.update_items)
        {
            update_item.update(notification);
        }
		
		if (notification.pitch_mode == "LAND" or notification.pitch_mode == "FLARE" or notification.pitch_mode == "ROLL OUT") {
			if (ecam.directLaw.active) {
				me["FMA_Middle1"].hide();
				me["FMA_Middle2"].show();
			} else if (fbw_curlaw == 3) {
				me["FMA_Middle1"].hide();
				me["FMA_Middle2"].show();
			} else {
				me["FMA_Middle1"].show();
				me["FMA_Middle2"].hide();
			}
		}
		
		if (ecam.directLaw.active) {
			me["FMA_ctr_msg"].setText("USE MAN PITCH TRIM");
			me["FMA_ctr_msg"].setColor(0.7333,0.3803,0);
			me["FMA_ctr_msg"].show();
		} else if (notification.fbwLaw == 3) {
			me["FMA_ctr_msg"].setText("MAN PITCH TRIM ONLY");
			me["FMA_ctr_msg"].setColor(1,0,0);
			me["FMA_ctr_msg"].show();
		} else {
			me["FMA_ctr_msg"].hide();
		}
		
		if (notification.gear1Wow or notification.gear2Wow and ((fmgc.FMGCInternal.phase != 1 and fmgc.FMGCInternal.phase != 2) or notification.engine1State == 3 or notification.engine3State == 3)) {
			me["AI_stick"].show();
			me["AI_stick_pos"].show();
			me.runAIStickPosUpdate = 1;
		} else {
			me["AI_stick"].hide();
			me["AI_stick_pos"].hide();
			me.runAIStickPosUpdate = 0;
		}
		
		# QNH
		if (alt_std_mode.getValue() == 1) {
			me["QNH"].hide();
			me["QNH_setting"].hide();
			
			if (altitude.getValue() < fmgc.FMGCInternal.transAlt and fmgc.FMGCInternal.phase == 4) {
				if (qnh_going == 0) {
					qnh_going = 1;
				}
				if (qnh_going == 1) {
					qnhTimer.start();
					if (qnhFlash.getValue() == 1) {
						me["QNH_std"].show();
						me["QNH_box"].show();
					} else {
						me["QNH_std"].hide();
						me["QNH_box"].hide();
					}
				}
			} else {
				qnhTimer.stop();
				qnh_going = 0;
				me["QNH_std"].show();
				me["QNH_box"].show();
			}
		} elsif (alt_inhg_mode.getValue() == 0) {
			me["QNH_std"].hide();
			me["QNH_box"].hide();
		
			if (altitude.getValue() >= fmgc.FMGCInternal.transAlt and fmgc.FMGCInternal.phase == 2) {
				if (qnh_going == 0) {
					qnh_going = 1;
				}
				if (qnh_going == 1) {
					qnhTimer.start();
					if (qnhFlash.getValue() == 1) {
						me["QNH"].show();
						me["QNH_setting"].show();
					} else {
						me["QNH"].hide();
						me["QNH_setting"].hide();
					}
				}
			} else {
				qnhTimer.stop();
				qnh_going = 0;
				me["QNH"].show();
				me["QNH_setting"].show();
			}

		} elsif (alt_inhg_mode.getValue() == 1) {
			if (altitude.getValue() >= fmgc.FMGCInternal.transAlt and fmgc.FMGCInternal.phase == 2) {
				if (qnh_going == 0) {
					qnh_going = 1;
				}
				if (qnh_going == 1) {
					qnhTimer.start();
					if (qnhFlash.getValue() == 1) {
						me["QNH"].show();
						me["QNH_setting"].show();
					} else {
						me["QNH"].hide();
						me["QNH_setting"].hide();
					}
				}
			} else {
				qnhTimer.stop();
				qnh_going = 0;
				me["QNH"].show();
				me["QNH_setting"].show();
			}
			
			me["QNH_std"].hide();
			me["QNH_box"].hide();
		}
	},
	updateFast: func(notification) {
		foreach(var update_item; me.update_items_fast)
        {
            update_item.update(notification);
        }
		
		if (me.runAIStickPosUpdate) {
			foreach(var update_item; me.update_items_ground)
			{
				update_item.update(notification);
			}
		}
	},
	updateTest: func(notification) {
		if (me.number == 1) {
			me._testTimeNodes = [du1_test_time,du2_test_time];
			me._xfr = notification.cpt_du_xfr;
		} else {
			me._testTimeNodes = [du6_test_time,du5_test_time];
			me._xfr = notification.fo_du_xfr;
		}
		
		if ((me._testTimeNodes[0].getValue() + 1 >= notification.elapsedTime) and me._xfr != 1) {
			me["Test_white"].show();
			me["Test_text"].hide();
		} elsif ((me._testTimeNodes[1].getValue() + 1 >= notification.elapsedTime) and me._xfr != 0) {
			me["Test_white"].show();
			me["Test_text"].hide();
		} else {
			me["Test_white"].hide();
			me["Test_text"].show();
		}
	},
	updateMismatch: func(notification) {
		me.group_mismatch.getElementById("ERRCODE").setText(acconfig_mismatch.getValue());
	},
	
	powerTransient1: func() {
		var elapsedtime_act = pts.Sim.Time.elapsedSec.getValue();
		if (systems.ELEC.Bus.acEss.getValue() >= 110) {
			if (du1_offtime.getValue() + 3 < elapsedtime_act) { 
				if (wow0.getValue() == 1) {
					if (acconfig.getValue() != 1 and du1_test.getValue() != 1) {
						du1_test.setValue(1);
						du1_test_amount.setValue(math.round((rand() * 5 ) + 35, 0.1));
						du1_test_time.setValue(elapsedtime_act);
					} else if (acconfig.getValue() == 1 and du1_test.getValue() != 1) {
						du1_test.setValue(1);
						du1_test_amount.setValue(math.round((rand() * 5 ) + 35, 0.1));
						du1_test_time.setValue(elapsedtime_act - 30);
					}
				} else {
					du1_test.setValue(1);
					du1_test_amount.setValue(0);
					du1_test_time.setValue(-100);
				}
			}
		} else {
			du1_test.setValue(0);
			du1_offtime.setValue(elapsedtime_act);
		}
	},
	powerTransient2: func() {
		var elapsedtime_act = pts.Sim.Time.elapsedSec.getValue();
		if (systems.ELEC.Bus.ac2.getValue() >= 110) {
			if (du6_offtime.getValue() + 3 < elapsedtime_act) { 
				if (wow0.getValue() == 1) {
					if (acconfig.getValue() != 1 and du6_test.getValue() != 1) {
						du6_test.setValue(1);
						du6_test_amount.setValue(math.round((rand() * 5 ) + 35, 0.1));
						du6_test_time.setValue(elapsedtime_act);
					} else if (acconfig.getValue() == 1 and du6_test.getValue() != 1) {
						du6_test.setValue(1);
						du6_test_amount.setValue(math.round((rand() * 5 ) + 35, 0.1));
						du6_test_time.setValue(elapsedtime_act - 30);
					}
				} else {
					du6_test.setValue(1);
					du6_test_amount.setValue(0);
					du6_test_time.setValue(-100);
				}
			}
		} else {
			du6_test.setValue(0);
			du6_offtime.setValue(elapsedtime_act);
		}
	},
	_update: 0,
	updatePower: func(notification) {
		if (me.number == 1) {
			if (notification.du1Light > 0.01 and notification.elecACEss >= 110) {
				if (du1_test_time.getValue() + du1_test_amount.getValue() >= notification.elapsedTime and notification.cpt_du_xfr != 1) {
					me._update = 0;
					me.group.setVisible(0);
					me.group_test.setVisible(1);
				} elsif (du2_test_time.getValue() + du2_test_amount.getValue() >= notification.elapsedTime and notification.cpt_du_xfr == 1) {
					me._update = 0;
					me.group.setVisible(0);
					me.group_test.setVisible(1);
				} else {
					me.updateFast(notification);
					if (!me._update) { # Update slow here once so that no flicker if timers don't perfectly align
						me._update = 1;
						me.update(notification);
					}
					me.group.setVisible(1);
					me.group_test.setVisible(0);
				}
			} else {
				me.group.setVisible(0);
				me.group_test.setVisible(0);
			}
		} else {
			if (notification.du6Light > 0.01 and notification.elecAC2 >= 110) {
				if (du6_test_time.getValue() + du6_test_amount.getValue() >= notification.elapsedTime and notification.fo_du_xfr != 1) {
					me._update = 0;
					me.group.setVisible(0);
					me.group_test.setVisible(1);
				} elsif (du6_test_time.getValue() + du6_test_amount.getValue() >= notification.elapsedTime and notification.fo_du_xfr == 1) {
					me._update = 0;
					me.group.setVisible(0);
					me.group_test.setVisible(1);
				} else {
					me.updateFast(notification);
					if (!me._update) { # Update slow here once so that no flicker if timers don't perfectly align
						me._update = 1;
						me.update(notification);
					}
					me.group.setVisible(1);
					me.group_test.setVisible(0);
				}
			} else {
				me.group.setVisible(0);
				me.group_test.setVisible(0);
			}
		}
	},

	# Get Angle of Attack from ADR1 or, depending on Switching panel, ADR3
	getAOAForPFD1: func() {
		if (air_data_switch.getValue() != -1 and adr_1_switch.getValue() and !adr_1_fault.getValue()) return aoa_1.getValue();
		if (air_data_switch.getValue() == -1 and adr_3_switch.getValue() and !adr_3_fault.getValue()) return aoa_3.getValue();
		return nil;
	},
	
	# Get Angle of Attack from ADR2 or, depending on Switching panel, ADR3
	getAOAForPFD2: func() {
		if (air_data_switch.getValue() != 1 and adr_2_switch.getValue() and !adr_2_fault.getValue()) return aoa_2.getValue();
		if (air_data_switch.getValue() == 1 and adr_3_switch.getValue() and !adr_3_fault.getValue()) return aoa_3.getValue();
		return nil;
	},

	# Convert difference between magnetic heading and track measured in degrees to pixel for display on PFDs
	# And set max and minimum values
	getTrackDiffPixels: func(track_diff_deg) {
		return ((math.clamp(track_diff_deg, -23.62, 23.62) / 10) * 98.5416);
	},
};


var PFDRecipient =
{
	new: func(_ident, placement, number)
	{
		var NewPFDRecipient = emesary.Recipient.new(_ident);
		NewPFDRecipient.MainScreen = nil;
		NewPFDRecipient.Receive = func(notification)
		{
			if (notification.NotificationType == "FrameNotification")
			{
				if (NewPFDRecipient.MainScreen == nil) {
						NewPFDRecipient.MainScreen = canvas_PFD.new("Aircraft/A320-family/Models/Instruments/PFD/res/pfd.svg", _ident, placement, number);
				}
				NewPFDRecipient.MainScreen.updateFast(notification);
				
				if (math.mod(notifications.frameNotification.FrameCount,4) == 0) {
					NewPFDRecipient.MainScreen.update(notification);
				}
				return emesary.Transmitter.ReceiptStatus_OK;
			}
			return emesary.Transmitter.ReceiptStatus_NotProcessed;
		};
		return NewPFDRecipient;
	},
};

var A320PFD1 = PFDRecipient.new("A320 PFD L","pfd1.screen", 1);
emesary.GlobalTransmitter.Register(A320PFD1);

var A320PFD2 = PFDRecipient.new("A320 PFD R","pfd2.screen", 2);
emesary.GlobalTransmitter.Register(A320PFD2);

var input = {
	"du1Light": "/controls/lighting/DU/du1",
	"du6Light": "/controls/lighting/DU/du6",
	"cpt_du_xfr": "/modes/cpt-du-xfr",
	"fo_du_xfr": "/modes/fo-du-xfr",
	
	"aileronInput": "/controls/flight/aileron-input-fast",
	"elevatorInput": "/controls/flight/elevator-input-fast",
	"alt_hpa": "/instrumentation/altimeter/setting-hpa",
	"alt_inhg": "/instrumentation/altimeter/setting-inhg",
	"alt_inhg_mode": "/instrumentation/altimeter/inhg",
	"fac1": "/systems/fctl/fac1-healthy-signal",
	"fac2": "/systems/fctl/fac2-healthy-signal",
	"fbwLaw": "/it-fbw/law",
	"fdPitch": "/it-autoflight/fd/pitch-bar",
	"horizonGround": "/instrumentation/pfd/horizon-ground",
	"pitchPFD": "/instrumentation/pfd/pitch-deg-non-linear",
	"slipSkid": "/instrumentation/pfd/slip-skid",
	"roll": "orientation/roll-deg",
	"fdRoll": "/it-autoflight/fd/roll-bar",
	"outerMarker": "/instrumentation/marker-beacon/outer",
	"middleMarker": "/instrumentation/marker-beacon/middle",
	"innerMarker": "/instrumentation/marker-beacon/inner",
	
	# Autopilot
	"alphaFloor": "/systems/thrust/alpha-floor",
	"ap_ils_mode": "/modes/pfd/ILS1",
	"ap_ils_mode2": "/modes/pfd/ILS2",
	"ap1": "/it-autoflight/output/ap1",
	"ap2": "/it-autoflight/output/ap2",
	"athr": "/it-autoflight/output/athr",
	"engOut": "/systems/thrust/eng-out",
	"fd1": "/it-autoflight/output/fd1",
	"fd2": "/it-autoflight/output/fd2",
	"state1": "/systems/thrust/state1",
	"state2": "/systems/thrust/state2",
	"thrustLimit": "/controls/engines/thrust-limit",
	"thr1": "/controls/engines/engine[0]/throttle-pos",
	"thr2": "/controls/engines/engine[1]/throttle-pos",
	"lvrClb": "/systems/thrust/lvrclb",
	"togaLk": "/systems/thrust/toga-lk",
	
	# FMA
	"ap_box": "/modes/pfd/fma/ap-mode-box",
	"at_box": "/modes/pfd/fma/at-mode-box",
	"fd_box": "/modes/pfd/fma/fd-mode-box",
	"ap_mode": "/modes/pfd/fma/ap-mode",
	"at_mode": "/modes/pfd/fma/at-mode",
	"athr_arm": "/modes/pfd/fma/athr-armed",
	"fd_mode": "/modes/pfd/fma/fd-mode",
	"pitch_mode": "/modes/pfd/fma/pitch-mode",
	"pitch_mode_box": "/modes/pfd/fma/pitch-mode-box",
	"pitch_mode_armed": "/modes/pfd/fma/pitch-mode-armed",
	"pitch_mode2_armed": "/modes/pfd/fma/pitch-mode2-armed",
	"pitch_mode_armed_box": "/modes/pfd/fma/pitch-mode-armed-box",
	"pitch_mode2_armed_box": "/modes/pfd/fma/pitch-mode2-armed-box",
	"roll_mode": "/modes/pfd/fma/roll-mode",
	"roll_mode_armed": "/modes/pfd/fma/roll-mode-armed",
	"roll_mode_box": "/modes/pfd/fma/roll-mode-box",
	"roll_mode_armed_box": "/modes/pfd/fma/roll-mode-armed-box",
	"throttleBox": "/modes/pfd/fma/throttle-mode-box",
	"throttleMode": "/modes/pfd/fma/throttle-mode",
};

foreach (var name; keys(input)) {
	emesary.GlobalTransmitter.NotifyAll(notifications.FrameNotificationAddProperty.new("A320 PFD", name, input[name]));
}

var showPFD1 = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(A320PFD1.MainScreen.canvas);
}

var showPFD2 = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(A320PFD2.MainScreen.canvas);
}

setlistener("/systems/electrical/bus/ac-ess", func() {
	if (A320PFD1.MainScreen != nil) { A320PFD1.MainScreen.powerTransient1() }
}, 0, 0);

setlistener("/systems/electrical/bus/ac-2", func() {
	if (A320PFD2.MainScreen != nil) { A320PFD2.MainScreen.powerTransient2() }
}, 0, 0);

var roundabout = func(x) {
	var y = x - int(x);
	return y < 0.5 ? int(x) : 1 + int(x);
};

var roundaboutAlt = func(x) {
	var y = x * 0.2 - int(x * 0.2);
	return y < 0.5 ? 5 * int(x * 0.2) : 5 + 5 * int(x * 0.2);
};

var fontSizeHDG = func(input) {
	var test = input / 3;
	if (test == int(test)) {
		return 42;
	} else {
		return 32;
	}
};

# Flash managers
var ils_going1 = 0;
var ilsTimer1 = maketimer(0.50, func {
	if (!ilsFlash1.getBoolValue()) {
		ilsFlash1.setBoolValue(1);
	} else {
		ilsFlash1.setBoolValue(0);
	}
});

var ils_going2 = 0;
var ilsTimer2 = maketimer(0.50, func {
	if (!ilsFlash2.getBoolValue()) {
		ilsFlash2.setBoolValue(1);
	} else {
		ilsFlash2.setBoolValue(0);
	}
});

var qnh_going = 0;
var qnhTimer = maketimer(0.50, func {
	if (!qnhFlash.getBoolValue()) {
		qnhFlash.setBoolValue(1);
	} else {
		qnhFlash.setBoolValue(0);
	}
});

var alt_going1 = 0;
var altTimer1 = maketimer(0.50, func {
	if (!altFlash1.getBoolValue()) {
		altFlash1.setBoolValue(1);
	} else {
		altFlash1.setBoolValue(0);
	}
});

var alt_going2 = 0;
var altTimer2 = maketimer(0.50, func {
	if (!altFlash2.getBoolValue()) {
		altFlash2.setBoolValue(1);
	} else {
		altFlash2.setBoolValue(0);
	}
});

var amber_going1 = 0;
var amberTimer1 = maketimer(0.50, func {
	if (!amberFlash1.getBoolValue()) {
		amberFlash1.setBoolValue(1);
	} else {
		amberFlash1.setBoolValue(0);
	}
});

var amber_going2 = 0;
var amberTimer2 = maketimer(0.50, func {
	if (!amberFlash2.getBoolValue()) {
		amberFlash2.setBoolValue(1);
	} else {
		amberFlash2.setBoolValue(0);
	}
});

var dh_going = 0;
var dh_count = 0;
var dhTimer = maketimer(0.50, func {
	if (!dhFlash.getBoolValue()) {
		dhFlash.setBoolValue(1);
	} else {
		dhFlash.setBoolValue(0);
	}
	if (dh_count == 18) {
		dh_count = 0;
	} else {
		dh_count = dh_count + 1;
	}
});