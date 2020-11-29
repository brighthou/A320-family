# A3XX Lower ECAM Canvas

# Copyright (c) 2020 Josh Davidson (Octal450)

var lowerECAM_apu = nil;
var lowerECAM_bleed = nil;
var lowerECAM_cond = nil;
var lowerECAM_crz = nil;
var lowerECAM_door = nil;
var lowerECAM_elec = nil;
var lowerECAM_eng = nil;
var lowerECAM_fctl = nil;
var lowerECAM_fuel = nil;
var lowerECAM_hyd = nil;
var lowerECAM_press = nil;
var lowerECAM_status = nil;
var lowerECAM_wheel = nil;
var lowerECAM_test = nil;
var lowerECAM_display = nil;
var page = "fctl";
var blue_psi = 0;
var green_psi = 0;
var yellow_psi = 0;
var autobrakemode = 0;
var nosegear = 0;
var leftgear = 0;
var rightgear = 0;
var leftdoor = 0;
var rightdoor = 0;
var nosedoor = 0;
var gearlvr = 0;
var elapsedtime = 0;
var tr1_v = 0;
var tr1_a = 0;
var tr2_v = 0;
var tr2_a = 0;
var essTramps = 0;
var essTrvolts = 0;
var elac1Node = 0;
var elac2Node = 0;
var sec1Node = 0;
var sec2Node = 0;
var eng_valve_state = 0;
var bleed_valve_cur = 0;
var hp_valve_state = 0;
var xbleedcmdstate = 0;
var ramAirState = 0;

# Conversion factor pounds to kilogram
LBS2KGS = 0.4535924;

# Fetch Nodes
var acconfig_weight_kgs = props.globals.getNode("/systems/acconfig/options/weight-kgs", 1);
var rate = props.globals.getNode("/systems/acconfig/options/lecam-rate", 1);
var autoconfig_running = props.globals.getNode("/systems/acconfig/autoconfig-running", 1);
var lighting_du4 = props.globals.getNode("/controls/lighting/DU/du4", 1);
var ecam_page = props.globals.getNode("/ECAM/Lower/page", 1);
var hour = props.globals.getNode("/sim/time/utc/hour", 1);
var minute = props.globals.getNode("/sim/time/utc/minute", 1);
var apu_flap = props.globals.getNode("/controls/apu/inlet-flap/position-norm", 1);
var apu_rpm = props.globals.getNode("/engines/engine[2]/n1", 1);
var apu_egt = props.globals.getNode("/systems/apu/egt-degC", 1);
var door_left = props.globals.getNode("/ECAM/Lower/door-left", 1);
var door_right = props.globals.getNode("/ECAM/Lower/door-right", 1);
var door_nose_left = props.globals.getNode("/ECAM/Lower/door-nose-left", 1);
var door_nose_right = props.globals.getNode("/ECAM/Lower/door-nose-right", 1);
var apu_rpm_rot = props.globals.getNode("/ECAM/Lower/APU-N", 1);
var apu_egt_rot = props.globals.getNode("/ECAM/Lower/APU-EGT", 1);
var oil_qt1 = props.globals.getNode("/ECAM/Lower/Oil-QT[0]", 1);
var oil_qt2 = props.globals.getNode("/ECAM/Lower/Oil-QT[1]", 1);
var oil_psi1 = props.globals.getNode("/ECAM/Lower/Oil-PSI[0]", 1);
var oil_psi2 = props.globals.getNode("/ECAM/Lower/Oil-PSI[1]", 1);
var bleedapu = props.globals.getNode("/systems/pneumatics/source/apu-psi", 1);
var aileron_ind_left = props.globals.getNode("/ECAM/Lower/aileron-ind-left", 1);
var aileron_ind_right = props.globals.getNode("/ECAM/Lower/aileron-ind-right", 1);
var elevator_ind_left = props.globals.getNode("/ECAM/Lower/elevator-ind-left", 1);
var elevator_ind_right = props.globals.getNode("/ECAM/Lower/elevator-ind-right", 1);
var elevator_trim_deg = props.globals.getNode("/ECAM/Lower/elevator-trim-deg", 1);
var final_deg = props.globals.getNode("/fdm/jsbsim/hydraulics/rudder/final-deg", 1);
var temperature_degc = props.globals.getNode("/environment/temperature-degc", 1);
var tank3_content_lbs = props.globals.getNode("/fdm/jsbsim/propulsion/tank[2]/contents-lbs", 1);
var ir2_knob = props.globals.getNode("/controls/adirs/ir[1]/knob", 1);
var apuBleedNotOn = props.globals.getNode("/systems/pneumatics/warnings/apu-bleed-not-on", 1);
var apu_valve = props.globals.getNode("/systems/pneumatics/valves/apu-bleed-valve-cmd", 1);
var apu_valve_state = props.globals.getNode("/systems/pneumatics/valves/apu-bleed-valve", 1);
var xbleedcmd = props.globals.getNode("/systems/pneumatics/valves/crossbleed-valve-cmd", 1);
var xbleed = props.globals.getNode("/systems/pneumatics/valves/crossbleed-valve", 1);
var xbleedstate = nil;
var hp_valve1_state = props.globals.getNode("/systems/pneumatics/valves/engine-1-hp-valve", 1);
var hp_valve2_state = props.globals.getNode("/systems/pneumatics/valves/engine-2-hp-valve", 1);
var hp_valve1 = props.globals.getNode("/systems/pneumatics/valves/engine-1-hp-valve-cmd", 1);
var hp_valve2 = props.globals.getNode("/systems/pneumatics/valves/engine-2-hp-valve-cmd", 1);
var eng_valve1 = props.globals.getNode("/systems/pneumatics/valves/engine-1-prv-valve", 1);
var eng_valve2 = props.globals.getNode("/systems/pneumatics/valves/engine-2-prv-valve", 1);
var precooler1_psi = props.globals.getNode("/systems/pneumatics/psi/engine-1-psi", 1);
var precooler2_psi = props.globals.getNode("/systems/pneumatics/psi/engine-2-psi", 1);
var precooler1_temp = props.globals.getNode("/systems/pneumatics/precooler/temp-1", 1);
var precooler2_temp = props.globals.getNode("/systems/pneumatics/precooler/temp-2", 1);
var precooler1_ovht = props.globals.getNode("/systems/pneumatics/precooler/ovht-1", 1);
var precooler2_ovht = props.globals.getNode("/systems/pneumatics/precooler/ovht-2", 1);
var bmc1working = props.globals.getNode("/systems/pneumatics/indicating/bmc1-working", 1);
var bmc2working = props.globals.getNode("/systems/pneumatics/indicating/bmc2-working", 1);
var bmc1 = 0;
var bmc2 = 0;
var gs_kt = props.globals.getNode("/velocities/groundspeed-kt", 1);
var switch_wing_aice = props.globals.getNode("/controls/ice-protection/wing", 1);
var pack1_bypass = props.globals.getNode("/systems/pneumatics/pack-1-bypass", 1);
var pack2_bypass = props.globals.getNode("/systems/pneumatics/pack-2-bypass", 1);
var oil_qt1_actual = props.globals.getNode("/engines/engine[0]/oil-qt-actual", 1);
var oil_qt2_actual = props.globals.getNode("/engines/engine[1]/oil-qt-actual", 1);
var fuel_used_lbs1 = props.globals.getNode("/systems/fuel/fuel-used-1", 1);
var fuel_used_lbs2 = props.globals.getNode("/systems/fuel/fuel-used-2", 1);
var doorL1_pos = props.globals.getNode("/sim/model/door-positions/doorl1/position-norm", 1);
var doorR1_pos = props.globals.getNode("/sim/model/door-positions/doorr1/position-norm", 1);
var doorL4_pos = props.globals.getNode("/sim/model/door-positions/doorl4/position-norm", 1);
var doorR4_pos = props.globals.getNode("/sim/model/door-positions/doorr4/position-norm", 1);
var cargobulk_pos = props.globals.getNode("/sim/model/door-positions/cargobulk/position-norm", 1);
var cargofwd_pos = props.globals.getNode("/sim/model/door-positions/cargofwd/position-norm", 1);
var cargoaft_pos = props.globals.getNode("/sim/model/door-positions/cargoaft/position-norm", 1);
var gLoad = props.globals.getNode("/ECAM/Lower/g-force-display", 1);

# Hydraulic
var blue_psi = 0;
var green_psi = 0;
var yellow_psi = 0;
var y_resv_lo_air_press = props.globals.getNode("/systems/hydraulic/yellow-resv-lo-air-press", 1);
var b_resv_lo_air_press = props.globals.getNode("/systems/hydraulic/blue-resv-lo-air-press", 1);
var g_resv_lo_air_press = props.globals.getNode("/systems/hydraulic/green-resv-lo-air-press", 1);
var elec_pump_y_ovht = props.globals.getNode("/systems/hydraulic/elec-pump-yellow-ovht", 1);
var elec_pump_b_ovht = props.globals.getNode("/systems/hydraulic/elec-pump-blue-ovht", 1);
var rat_deployed = props.globals.getNode("/controls/hydraulic/rat-deployed", 1);
var y_resv_ovht = props.globals.getNode("/systems/hydraulic/yellow-resv-ovht", 1);
var b_resv_ovht = props.globals.getNode("/systems/hydraulic/blue-resv-ovht", 1);
var g_resv_ovht = props.globals.getNode("/systems/hydraulic/green-resv-ovht", 1);
var askidsw = 0;
var brakemode = 0;
var accum = 0;
var L1BrakeTempc = props.globals.getNode("/gear/gear[1]/L1brake-temp-degc", 1);
var L2BrakeTempc = props.globals.getNode("/gear/gear[1]/L2brake-temp-degc", 1);
var R3BrakeTempc = props.globals.getNode("/gear/gear[2]/R3brake-temp-degc", 1);
var R4BrakeTempc = props.globals.getNode("/gear/gear[2]/R4brake-temp-degc", 1);

var eng1_running = props.globals.getNode("/engines/engine[0]/running", 1);
var eng2_running = props.globals.getNode("/engines/engine[1]/running", 1);
var switch_cart = props.globals.getNode("/controls/electrical/ground-cart", 1);
var spoiler_L1 = props.globals.getNode("/fdm/jsbsim/hydraulics/spoiler-l1/final-deg", 1);
var spoiler_L2 = props.globals.getNode("/fdm/jsbsim/hydraulics/spoiler-l2/final-deg", 1);
var spoiler_L3 = props.globals.getNode("/fdm/jsbsim/hydraulics/spoiler-l3/final-deg", 1);
var spoiler_L4 = props.globals.getNode("/fdm/jsbsim/hydraulics/spoiler-l4/final-deg", 1);
var spoiler_L5 = props.globals.getNode("/fdm/jsbsim/hydraulics/spoiler-l5/final-deg", 1);
var spoiler_R1 = props.globals.getNode("/fdm/jsbsim/hydraulics/spoiler-r1/final-deg", 1);
var spoiler_R2 = props.globals.getNode("/fdm/jsbsim/hydraulics/spoiler-r2/final-deg", 1);
var spoiler_R3 = props.globals.getNode("/fdm/jsbsim/hydraulics/spoiler-r3/final-deg", 1);
var spoiler_R4 = props.globals.getNode("/fdm/jsbsim/hydraulics/spoiler-r4/final-deg", 1);
var spoiler_R5 = props.globals.getNode("/fdm/jsbsim/hydraulics/spoiler-r5/final-deg", 1);
var total_fuel_lbs = props.globals.getNode("/consumables/fuel/total-fuel-lbs", 1);
var fuel_flow1 = props.globals.getNode("/engines/engine[0]/fuel-flow_actual", 1);
var fuel_flow2 = props.globals.getNode("/engines/engine[1]/fuel-flow_actual", 1);
var fuel_left_outer_temp = props.globals.getNode("/consumables/fuel/tank[0]/temperature_degC", 1);
var fuel_left_inner_temp = props.globals.getNode("/consumables/fuel/tank[1]/temperature_degC", 1);
var fuel_right_outer_temp = props.globals.getNode("/consumables/fuel/tank[4]/temperature_degC", 1);
var fuel_right_inner_temp = props.globals.getNode("/consumables/fuel/tank[3]/temperature_degC", 1);
var cutoff_switch1 = props.globals.getNode("/controls/engines/engine[0]/cutoff-switch", 1);
var cutoff_switch2 = props.globals.getNode("/controls/engines/engine[1]/cutoff-switch", 1);
var autobreak_mode = props.globals.getNode("/controls/autobrake/mode", 1);
var gear1_pos = props.globals.getNode("/gear/gear[0]/position-norm", 1);
var gear2_pos = props.globals.getNode("/gear/gear[1]/position-norm", 1);
var gear3_pos = props.globals.getNode("/gear/gear[2]/position-norm", 1);
var gear_door_L = props.globals.getNode("/systems/hydraulic/gear/door-left", 1);
var gear_door_R = props.globals.getNode("/systems/hydraulic/gear/door-right", 1);
var gear_door_N = props.globals.getNode("/systems/hydraulic/gear/door-nose", 1);
var gear_down = props.globals.getNode("/controls/gear/gear-down", 1);
var press_vs_norm = props.globals.getNode("/systems/pressurization/vs-norm", 1);
var cabinalt = props.globals.getNode("/systems/pressurization/cabinalt-norm", 1);
var gear0_wow = props.globals.getNode("/gear/gear[0]/wow", 1);

# Create Nodes:
var apu_load = props.globals.initNode("/systems/electrical/extra/apu-load", 0, "DOUBLE");
var gen1_load = props.globals.initNode("/systems/electrical/extra/gen1-load", 0, "DOUBLE");
var gen2_load = props.globals.initNode("/systems/electrical/extra/gen2-load", 0, "DOUBLE");
var du4_test = props.globals.initNode("/instrumentation/du/du4-test", 0, "BOOL");
var du4_test_time = props.globals.initNode("/instrumentation/du/du4-test-time", 0, "DOUBLE");
var du4_test_amount = props.globals.initNode("/instrumentation/du/du4-test-amount", 0, "DOUBLE");
var du4_offtime = props.globals.initNode("/instrumentation/du/du4-off-time", 0.0, "DOUBLE");

var canvas_lowerECAM = {
	new: func(name) {
		var obj = {parents: [canvas_lowerECAM] };
		obj.canvas = canvas.new({
			"name": "lowerECAM",
			"size": [1024, 1024],
			"view": [1024, 1024],
			"mipmapping": 1,
		});
		
		obj.canvas.addPlacement({"node": "lecam.screen"});
        obj.group = obj.canvas.createGroup();
        obj.test = obj.canvas.createGroup();
		
		
		obj.font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(obj.group, svg, {"font-mapper": obj.font_mapper} );
		obj.keysHash = obj.getKeys();
 		foreach(var key; obj.keysHash) {
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
		
		canvas.parsesvg(obj.test, "Aircraft/A320-family/Models/Instruments/Common/res/du-test.svg", {"font-mapper": obj.font_mapper} );
		foreach(var key; obj.getKeysTest()) {
			obj[key] = obj.test.getElementById(key);
		};
		
		obj.units = acconfig_weight_kgs.getValue();
		
		obj.update_items = [
		
		];
		return obj;
	},
	getKeys: func() {
	
	},
	displayedGForce: 0,
	updateBottomStatus: func() {
		if (dmc.DMController.DMCs[1].outputs[4] != nil) {
			me["SAT"].setText(sprintf("%2.0f", dmc.DMController.DMCs[1].outputs[4].getValue()));
			me["SAT"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["SAT"].setText(sprintf("%s", "XX"));
			me["SAT"].setColor(0.7333,0.3803,0);
		}
		
		if (dmc.DMController.DMCs[1].outputs[5] != nil) {
			me["TAT"].setText(sprintf("%2.0f", dmc.DMController.DMCs[1].outputs[5].getValue()));
			me["TAT"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["TAT"].setText(sprintf("%s", "XX"));
			me["TAT"].setColor(0.7333,0.3803,0);
		}
		
		me.gloadStore = gLoad.getValue();
		if ((me.gloadStore == 1 and !me.displayedGForce) or (me.gloadStore != 0 and me.displayedGForce)) {
			me.displayedGForce = 1;
			me["GLoad"].setText("G.LOAD " ~ sprintf("%3.1f", pts.Accelerations.pilotGDamped.getValue()));
			me["GLoad"].show();
		} else {
			me.displayedGForce = 0;
			me["GLoad"].hide();
		}
		
		me["UTCh"].setText(sprintf("%02d", hour.getValue()));
		me["UTCm"].setText(sprintf("%02d", minute.getValue()));
		
		me.gwStore = pts.Fdm.JSBsim.Inertia.weightLbs.getValue();
		if (acconfig_weight_kgs.getValue()) {
			me["GW"].setText(sprintf("%s", math.round(math.round(me.gwStore * LBS2KGS, 100))));
			me["GW-weight-unit"].setText("KG");
		} else {
			me["GW"].setText(sprintf("%s", math.round(me.gwStore, 100)));
			me["GW-weight-unit"].setText("LBS");
		}
	},
	updateTest: func(notification) {
		if (du3_test_time.getValue() + 1 >= notification.elapsedTime) {
			me["Test_white"].show();
			me["Test_text"].hide();
		} else {
			me["Test_white"].hide();
			me["Test_text"].show();
		}
	},
	update: func() {
		me.updatePower();
		
		if (me.test.getVisible() == 1) {
			me.updateTest(notification);
		}
		
		if (me.group.getVisible() == 0) {
			return;
		}
		
		foreach(var update_item; me.update_items)
        {
            update_item.update(notification);
        }
	},
	
	powerTransient: func() {
		if (systems.ELEC.Bus.ac2.getValue() >= 110) {
			if (du4_offtime.getValue() + 3 < pts.Sim.Time.elapsedSec.getValue()) {
				if (gear0_wow.getValue()) {
					if (autoconfig_running.getValue() != 1 and du4_test.getValue() != 1) {
						du4_test.setValue(1);
						du4_test_amount.setValue(math.round((rand() * 5 ) + 35, 0.1));
						du4_test_time.setValue(pts.Sim.Time.elapsedSec.getValue());
					} else if (autoconfig_running.getValue() and du4_test.getValue() != 1) {
						du4_test.setValue(1);
						du4_test_amount.setValue(math.round((rand() * 5 ) + 35, 0.1));
						du4_test_time.setValue(pts.Sim.Time.elapsedSec.getValue() - 30);
					}
				} else {
					du4_test.setValue(1);
					du4_test_amount.setValue(0);
					du4_test_time.setValue(-100);
				}
			}
		} else {
			du4_test.setValue(0);
			du4_offtime.setValue(pts.Sim.Time.elapsedSec.getValue());
		}
	},
	updatePower: func() {
		if (du4_lgt.getValue() > 0.01 and systems.ELEC.Bus.ac2.getValue() >= 110) {
			if (du4_test_time.getValue() + du4_test_amount.getValue() >= pts.Sim.Time.elapsedSec.getValue()) {
				me.group.setVisible(0);
				me.test.setVisible(1);
			} else {
				me.group.setVisible(1);
				me.test.setVisible(0);
			}
		} else {
			me.group.setVisible(0);
			me.test.setVisible(0);
		}
	},
};

var UpperECAMRecipient =
{
	new: func(_ident)
	{
		var SDRecipient = emesary.Recipient.new(_ident);
		SDRecipient.MainScreen = nil;
		SDRecipient.Receive = func(notification)
		{
			if (notification.NotificationType == "FrameNotification")
			{
				if (SDRecipient.MainScreen == nil) {
					SDRecipient.MainScreen = canvas_upperECAM.new("A320 SD");
				}
				if (math.mod(notifications.frameNotification.FrameCount,2) == 0) {
					SDRecipient.MainScreen.update(notification);
				}
				return emesary.Transmitter.ReceiptStatus_OK;
			}
			return emesary.Transmitter.ReceiptStatus_NotProcessed;
		};
		return SDRecipient;
	},
};

var A320SD = UpperECAMRecipient.new("A320 SD");
emesary.GlobalTransmitter.Register(A320SD);

input = {

};

foreach (var name; keys(input)) {
	emesary.GlobalTransmitter.NotifyAll(notifications.FrameNotificationAddProperty.new("A320 System Display", name, input[name]));
}

var showLowerECAM = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(A320SD.MainScreen.canvas);
}

setlistener("/systems/electrical/bus/ac-2", func() {
	if (A320SD.MainScreen != nil) { A320SD.MainScreen.powerTransient() }
}, 0, 0);
