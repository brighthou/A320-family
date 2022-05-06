# A3XX Electronic Centralised Aircraft Monitoring System
# Copyright (c) 2021 Jonathan Redpath (legoboyvdlp)

var FWC = {
	Btn: {
		clr: props.globals.initNode("/ECAM/buttons/clear-btn", 0, "BOOL"),
		recall: props.globals.initNode("/ECAM/buttons/recall-btn", 0, "BOOL"),
		recallStsNormal: props.globals.initNode("/ECAM/buttons/recall-status-normal", 0, "BOOL"),
		recallStsNormalOutput: props.globals.initNode("/ECAM/buttons/recall-status-normal-output", 0, "BOOL"),
	},
	Monostable: {
		phase1: props.globals.initNode("/ECAM/phases/monostable/phase-1-300", 0, "BOOL"),
		phase5: props.globals.initNode("/ECAM/phases/monostable/phase-5", 0, "BOOL"),
		phase5Temp: 0,
		phase7: props.globals.initNode("/ECAM/phases/monostable/phase-7", 0, "BOOL"),
		phase7Temp: 0,
		phase9: props.globals.initNode("/ECAM/phases/monostable/phase-9", 0, "BOOL"),
		phase1Output: props.globals.initNode("/ECAM/phases/monostable/phase-1-300-output"),
		phase1OutputTemp: 0,
		phase5Output: props.globals.initNode("/ECAM/phases/monostable/phase-5-output"),
		phase5OutputTemp: 0,
		phase7Output: props.globals.initNode("/ECAM/phases/monostable/phase-7-output"),
		phase7OutputTemp: 0,
		phase9Output: props.globals.initNode("/ECAM/phases/monostable/phase-9-output"),
		toPowerOutput: props.globals.getNode("/ECAM/phases/monostable/to-power-set-output"),
		m80kt: props.globals.getNode("/ECAM/phases/monostable-80kt"),
		altAlert1: props.globals.initNode("/ECAM/altitude-alert-monostable-set", 0, "BOOL"),
		altAlert1Output: props.globals.initNode("/ECAM/altitude-alert-monostable-output"),
		altAlert2: props.globals.initNode("/ECAM/flipflop/altitude-alert-rs-set", 0, "BOOL"),
	},
	Flipflop: {
		phase2Set: props.globals.initNode("/ECAM/phases/flipflop/phase-2-set", 0, "BOOL"),
		phase2Reset: props.globals.initNode("/ECAM/phases/flipflop/phase-2-reset", 0, "BOOL"),
		phase2Output: props.globals.initNode("/ECAM/phases/flipflop/phase-2-output", 0, "BOOL"),
		phase2OutputTemp: 0,
		phase10Set: props.globals.initNode("/ECAM/phases/flipflop/phase-10-set", 0, "BOOL"),
		phase10Reset: props.globals.initNode("/ECAM/phases/flipflop/phase-10-reset", 0, "BOOL"),
		phase10Output: props.globals.initNode("/ECAM/phases/flipflop/phase-10-output", 0, "BOOL"),
		recallSet: props.globals.initNode("/ECAM/flipflop/recall-set", 0, "BOOL"),
		recallReset: props.globals.initNode("/ECAM/flipflop/recall-reset", 0, "BOOL"),
		recallOutput: props.globals.initNode("/ECAM/flipflop/recall-output", 0, "BOOL"),
		recallOutputTemp: 0,
	},
	Logic: {
		gnd: props.globals.getNode("/ECAM/logic/ground-calc-immediate"),
		IRSinAlign: props.globals.initNode("/ECAM/irs-in-align", 0, "BOOL"),
		feet1500: props.globals.getNode("/ECAM/phases/phase-calculation/altitude-ge-1500"),
		feet800: props.globals.getNode("/ECAM/phases/phase-calculation/altitude-ge-800"),
	},
	Timer: {
		eng1idle: props.globals.getNode("/ECAM/phases/timer/eng1idle"),
		eng2idle: props.globals.getNode("/ECAM/phases/timer/eng2idle"),
		eng1or2: props.globals.getNode("/ECAM/phases/phase-calculation/one-engine-running"),
		toInhibit: props.globals.initNode("/ECAM/phases/timer/to-inhibit", 0, "INT"),
		ldgInhibit: props.globals.initNode("/ECAM/phases/timer/ldg-inhibit", 0, "INT"),
		eng1idleOutput: props.globals.getNode("/ECAM/phases/timer/eng1idle-output"),
		eng2idleOutput: props.globals.getNode("/ECAM/phases/timer/eng2idle-output"),
		eng1and2Off: props.globals.getNode("/ECAM/phases/phase-calculation/engines-1-2-not-running"),
		eng1and2OffTemp: 0,
		eng1or2Output: props.globals.getNode("/ECAM/phases/phase-calculation/engine-1-or-2-running"),
		eng1or2OutputTemp: 0,
		toInhibitOutput: props.globals.getNode("/ECAM/phases/timer/to-inhibit-output"),
		ldgInhibitOutput: props.globals.getNode("/ECAM/phases/timer/ldg-inhibit-output"),
		gnd: props.globals.getNode("/ECAM/timer/ground-calc"), # ZGND
		gnd2Sec: props.globals.getNode("/ECAM/phases/monostable/gnd-output"),
		gnd2SecHalf: props.globals.getNode("/ECAM/phases/monostable/gnd-output-2"), # hack to prevent getting confused between phase 5 / 6
	},
	speed80: props.globals.initNode("/ECAM/phases/speed-gt-80", 0, "BOOL"),
	speed80Temp: 0,
	toPower: props.globals.getNode("/ECAM/phases/phase-calculation/takeoff-power"),
	toPowerTemp: 0,
	altChg: props.globals.getNode("/it-autoflight/input/alt-is-changing", 1),
};

var warningNodes = {
	Logic: {
		JE1TLAI: props.globals.initNode("/ECAM/warnings/logic/eng/eng-1-tla-idle"),
		JE2TLAI: props.globals.initNode("/ECAM/warnings/logic/eng/eng-1-tla-idle"),
		adr123Fault: props.globals.initNode("/ECAM/warnings/navigation/ADR123-fault"),
		eng1OilLoPr: props.globals.initNode("/ECAM/warnings/logic/eng/eng-1-oil-lo-pr"),
		eng2OilLoPr: props.globals.initNode("/ECAM/warnings/logic/eng/eng-2-oil-lo-pr"),
		altitudeAlert: props.globals.initNode("/ECAM/warnings/altitude-alert/c-chord"),
		altitudeAlertSteady: props.globals.initNode("/ECAM/warnings/altitude-alert/altitude-alert-steady"),
		altitudeAlertFlash: props.globals.initNode("/ECAM/warnings/altitude-alert/altitude-alert-flash"),
		crossbleedFault: props.globals.initNode("/ECAM/warnings/logic/crossbleed-fault"),
		crossbleedWai: props.globals.initNode("/ECAM/warnings/logic/crossbleed-wai"),
		bleed1LoTempUnsuc: props.globals.initNode("/ECAM/warnings/logic/bleed-1-lo-temp-unsucc"),
		bleed1LoTempXbleed: props.globals.initNode("/ECAM/warnings/logic/bleed-1-lo-temp-xbleed"),
		bleed1LoTempBleed: props.globals.initNode("/ECAM/warnings/logic/bleed-1-lo-temp-bleed"),
		bleed1LoTempPack: props.globals.initNode("/ECAM/warnings/logic/bleed-1-lo-temp-pack"),
		bleed1WaiAvail: props.globals.initNode("/ECAM/warnings/logic/bleed-1-wai-avail"),
		bleed2LoTempUnsuc: props.globals.initNode("/ECAM/warnings/logic/bleed-2-lo-temp-unsucc"),
		bleed2LoTempXbleed: props.globals.initNode("/ECAM/warnings/logic/bleed-2-lo-temp-xbleed"),
		bleed2LoTempBleed: props.globals.initNode("/ECAM/warnings/logic/bleed-2-lo-temp-bleed"),
		bleed2LoTempPack: props.globals.initNode("/ECAM/warnings/logic/bleed-2-lo-temp-pack"),
		bleed2WaiAvail: props.globals.initNode("/ECAM/warnings/logic/bleed-2-wai-avail"),
		waiSysfault: props.globals.initNode("/ECAM/warnings/logic/wing-anti-ice-sys-fault"),
		waiLopen: props.globals.initNode("/ECAM/warnings/flipflop/wing-anti-ice-left-open"),
		waiRopen: props.globals.initNode("/ECAM/warnings/flipflop/wing-anti-ice-right-open"),
		waiLclosed: props.globals.initNode("/ECAM/warnings/flipflop/wing-anti-ice-left-closed"),
		waiRclosed: props.globals.initNode("/ECAM/warnings/flipflop/wing-anti-ice-right-closed"),
		procWaiShutdown: props.globals.initNode("/ECAM/warnings/logic/proc-wai-shutdown-output"),
		waiGndFlight: props.globals.initNode("/ECAM/warnings/logic/wing-anti-ice-gnd-fault"),
		pack12Fault: props.globals.initNode("/ECAM/warnings/logic/pack-1-2-fault"),
		pack1ResetPb: props.globals.initNode("/ECAM/warnings/logic/reset-pack-1-switch-cmd"),
		pack2ResetPb: props.globals.initNode("/ECAM/warnings/logic/reset-pack-2-switch-cmd"),
		cabinFans: props.globals.initNode("/ECAM/warnings/logic/cabin-fans-fault"),
		rtlu1Fault: props.globals.initNode("/ECAM/warnings/logic/rud-trav-lim-sys-1-fault"),
		rtlu2Fault: props.globals.initNode("/ECAM/warnings/logic/rud-trav-lim-sys-2-fault"),
		rtlu12Fault: props.globals.initNode("/ECAM/warnings/logic/rud-trav-lim-sys-fault"),
		fac12Fault: props.globals.initNode("/ECAM/warnings/logic/fac-12-fault"),
		fac1Fault: props.globals.initNode("/ECAM/warnings/logic/fac-1-fault"),
		fac2Fault: props.globals.initNode("/ECAM/warnings/logic/fac-2-fault"),
		stallWarn: props.globals.initNode("/ECAM/warnings/logic/stall/stall-warn-on"),
		yawDamper12Fault: props.globals.initNode("/ECAM/warnings/logic/yaw-damper-12-fault"),
		gearNotDown1: props.globals.initNode("/ECAM/warnings/fctl/gear-not-down-not-cancellable"),
		gearNotDown2: props.globals.initNode("/ECAM/warnings/fctl/gear-not-down-cancellable"),
		gearNotDownLocked: props.globals.initNode("/ECAM/warnings/fctl/gear-not-down-locked"),
		gearNotDownLockedFlipflop: props.globals.initNode("/ECAM/warnings/fctl/gear-not-downlocked-output"),
		blueGreen: props.globals.initNode("/ECAM/warnings/hyd/blue-green-failure"),
		blueGreenFuel: props.globals.initNode("/ECAM/warnings/hyd/blue-green-fuel-consumpt"),
		blueYellow: props.globals.initNode("/ECAM/warnings/hyd/blue-yellow-failure"),
		blueYellowFuel: props.globals.initNode("/ECAM/warnings/hyd/blue-yellow-fuel-consumpt"),
		greenYellow: props.globals.initNode("/ECAM/warnings/hyd/green-yellow-failure"),
		greenYellowFuel: props.globals.initNode("/ECAM/warnings/hyd/green-yellow-fuel-consumpt"),
		leftElevFail: props.globals.initNode("/ECAM/warnings/fctl/leftElevFault"),
		leftElevNotAvail: props.globals.initNode("ECAM/warnings/fctl/leftElevFault-cond"),
		rightElevFail: props.globals.initNode("/ECAM/warnings/fctl/rightElevFault"),
		rightElevNotAvail: props.globals.initNode("ECAM/warnings/fctl/rightElevFault-cond"),
		flapNotZero: props.globals.initNode("/ECAM/warnings/fctl/flaps-not-zero"),
		slatsConfig: props.globals.initNode("/ECAM/warnings/fctl/slats-config-output"),
		flapsConfig: props.globals.initNode("/ECAM/warnings/fctl/flaps-config-output"),
		spdBrkConfig: props.globals.initNode("/ECAM/warnings/fctl/spd-brk-config-output"),
		pitchTrimConfig: props.globals.initNode("/ECAM/warnings/fctl/pitch-trim-config-output"),
		rudTrimConfig: props.globals.initNode("/ECAM/warnings/fctl/rudder-trim-config-output"),
		parkBrkConfig: props.globals.initNode("/ECAM/warnings/fctl/park-brk-config-output"),
		slatsConfig2: props.globals.initNode("/ECAM/warnings/fctl/slats-config-range"),
		flapsConfig2: props.globals.initNode("/ECAM/warnings/fctl/flaps-config-range"),
		spdBrkConfig2: props.globals.initNode("/ECAM/warnings/fctl/spd-brk-config-range"),
		pitchTrimConfig2: props.globals.initNode("/ECAM/warnings/fctl/pitch-trim-config-range"),
		rudTrimConfig2: props.globals.initNode("/ECAM/warnings/fctl/rudder-trim-config-range"),
		dcEssFuelConsumptionIncreased: props.globals.initNode("/ECAM/warnings/logic/dc-ess-fuel-consumption-increased"),
		dcEssFMSPredictions: props.globals.initNode("/ECAM/warnings/logic/dc-ess-fms-predictions-unreliable"),
		dc2FuelConsumptionIncreased: props.globals.initNode("/ECAM/warnings/logic/dc-2-fuel-consumption-increased"),
		dc2FMSPredictions: props.globals.initNode("/ECAM/warnings/logic/dc-2-fms-predictions-unreliable"),
		thrLeversNotSet: props.globals.initNode("/ECAM/warnings/logic/eng/thr-lever-not-set"),
		revSet: props.globals.initNode("/ECAM/warnings/logic/eng/reverse-set"),
		eng1Fail: props.globals.initNode("/ECAM/warnings/logic/eng/eng-1-fail"),
		eng2Fail: props.globals.initNode("/ECAM/warnings/logic/eng/eng-2-fail"),
		eng1FailFlipflop: props.globals.initNode("/ECAM/warnings/logic/eng/eng-1-fail-output"),
		eng2FailFlipflop: props.globals.initNode("/ECAM/warnings/logic/eng/eng-2-fail-output"),
		phase5Trans: props.globals.initNode("/ECAM/warnings/logic/eng/phase-5-output"),
		eng1Shutdown: props.globals.initNode("/ECAM/warnings/logic/eng/eng-1-shutdown"),
		eng2Shutdown: props.globals.initNode("/ECAM/warnings/logic/eng/eng-2-shutdown"),
		acEssBusAltn: props.globals.initNode("/ECAM/warnings/logic/ac-ess-bus-altn-feed"),
		gen1Off: props.globals.initNode("/ECAM/warnings/logic/elec/gen-1-off"),
		gen2Off: props.globals.initNode("/ECAM/warnings/logic/elec/gen-2-off"),
		spdBrkOut: props.globals.initNode("/ECAM/warnings/fctl/spd-brk-still-out"),
		excessPress: props.globals.initNode("/ECAM/warnings/press/exess-residual-pressure"),
		excessCabAlt: props.globals.initNode("/ECAM/warnings/logic/press/excess-cabin-alt"),
	},
	Timers: {
		apuFaultOutput: props.globals.initNode("/ECAM/warnings/timer/apu-fault-output"),
		bleed1Fault: props.globals.initNode("/ECAM/warnings/timer/bleed-1-fault"),
		bleed1FaultOutput: props.globals.initNode("/ECAM/warnings/timer/bleed-1-fault-output"),
		bleed2Fault: props.globals.initNode("/ECAM/warnings/timer/bleed-2-fault"),
		bleed2FaultOutput: props.globals.initNode("/ECAM/warnings/timer/bleed-2-fault-output"),
		bleed1NotShutOutput: props.globals.initNode("/ECAM/warnings/timer/prv-1-not-shut-output"),
		bleed2NotShutOutput: props.globals.initNode("/ECAM/warnings/timer/prv-2-not-shut-output"),
		bleed1And2LoTemp: props.globals.initNode("/ECAM/warnings/timer/bleed-1-and-2-low-temp"),
		bleed1And2LoTempOutput: props.globals.initNode("/ECAM/warnings/timer/bleed-1-and-2-low-temp-output"),
		bleed1Off60Output: props.globals.initNode("/ECAM/warnings/logic/bleed-1-off-60-output"),
		bleed1Off5Output: props.globals.initNode("/ECAM/warnings/logic/bleed-1-off-5-output"),
		bleed2Off60Output: props.globals.initNode("/ECAM/warnings/logic/bleed-2-off-60-output"),
		bleed2Off5Output: props.globals.initNode("/ECAM/warnings/logic/bleed-2-off-5-output"),
		eng1AiceNotClsd: props.globals.initNode("/ECAM/warnings/timer/eng-aice-1-open-output"),
		eng2AiceNotClsd: props.globals.initNode("/ECAM/warnings/timer/eng-aice-2-open-output"),
		eng1AiceNotOpen: props.globals.initNode("/ECAM/warnings/timer/eng-aice-1-closed-output"),
		eng2AiceNotOpen: props.globals.initNode("/ECAM/warnings/timer/eng-aice-2-closed-output"),
		LRElevFault: props.globals.initNode("/ECAM/warnings/fctl/lrElevFault-output"),
		altnLaw: props.globals.initNode("/ECAM/warnings/fctl/altn-law-output"),
		directLaw: props.globals.initNode("/ECAM/warnings/fctl/direct-law-output"),
		waiLhiPr: props.globals.initNode("/ECAM/warnings/timer/wing-hi-pr-left"),
		waiRhiPr: props.globals.initNode("/ECAM/warnings/timer/wing-hi-pr-right"),
		pack1Fault: props.globals.initNode("/ECAM/warnings/timer/pack-1-fault-2"),
		pack2Fault: props.globals.initNode("/ECAM/warnings/timer/pack-2-fault-2"),
		pack1Off: props.globals.initNode("/ECAM/warnings/timer/pack-1-off"),
		pack2Off: props.globals.initNode("/ECAM/warnings/timer/pack-2-off"),
		trimAirFault: props.globals.initNode("/ECAM/warnings/timer/trim-air-fault"),
		yawDamper1Fault: props.globals.initNode("/ECAM/warnings/timer/yaw-damper-1-fault"),
		yawDamper2Fault: props.globals.initNode("/ECAM/warnings/timer/yaw-damper-2-fault"),
		navTerrFault: props.globals.initNode("/ECAM/warnings/timer/nav-gpws-terr-fault"),
		leftElevFail: props.globals.initNode("/ECAM/warnings/fctl/leftElevFault-output"),
		rightElevFail: props.globals.initNode("/ECAM/warnings/fctl/rightElevFault-output"),
		staticInverter: props.globals.initNode("/systems/electrical/some-electric-thingie/static-inverter-timer"),
		dcEmerConfig: props.globals.initNode("/ECAM/warnings/logic/dc-emer-config-output"),
		dc12Fault: props.globals.initNode("/ECAM/warnings/logic/dc-1-2-output"),
		dcEssFault: props.globals.initNode("/ECAM/warnings/logic/dc-ess-output"),
		dc1Fault: props.globals.initNode("/ECAM/warnings/logic/dc-1-output"),
		dc2Fault: props.globals.initNode("/ECAM/warnings/logic/dc-2-output"),
		dcBatFault: props.globals.initNode("/ECAM/warnings/logic/dc-bat-output"),
		ac1Fault: props.globals.initNode("/ECAM/warnings/logic/ac-1-output"),
		ac2Fault: props.globals.initNode("/ECAM/warnings/logic/ac-2-output"),
		acEssFault: props.globals.initNode("/ECAM/warnings/logic/ac-ess-output"),
		dcEssShed: props.globals.initNode("/ECAM/warnings/logic/dc-ess-shed-output"),
		acEssShed: props.globals.initNode("/ECAM/warnings/logic/ac-ess-shed-output"),
		centerPumpsOff: props.globals.initNode("/ECAM/warnings/fuel/center-pumps-off-output"),
		lowLevelBoth: props.globals.initNode("/ECAM/warnings/fuel/lo-level-l-r-output"),
	},
	Flipflops: {
		apuGenFault: props.globals.initNode("/ECAM/warnings/flipflop/apu-gen-fault"),
		apuGenFaultOnOff: props.globals.initNode("/ECAM/warnings/flipflop/apu-gen-fault-on-off"),
		bleed1LowTemp: props.globals.initNode("/ECAM/warnings/logic/bleed-1-low-temp-flipflop-output"),
		bleed2LowTemp: props.globals.initNode("/ECAM/warnings/logic/bleed-2-low-temp-flipflop-output"),
		gen1Fault: props.globals.initNode("/ECAM/warnings/flipflop/gen-1-fault"),
		gen2Fault: props.globals.initNode("/ECAM/warnings/flipflop/gen-2-fault"),
		gen1FaultOnOff: props.globals.initNode("/ECAM/warnings/flipflop/gen-1-fault-on-off"),
		gen2FaultOnOff: props.globals.initNode("/ECAM/warnings/flipflop/gen-2-fault-on-off"),
		pack1Ovht: props.globals.initNode("/ECAM/warnings/flipflop/pack-1-ovht"),
		pack2Ovht: props.globals.initNode("/ECAM/warnings/flipflop/pack-2-ovht"),
		parkBrk: props.globals.initNode("/ECAM/warnings/config/park-brk/park-brk-output"),
		eng1ThrLvrAbvIdle: props.globals.initNode("/ECAM/warnings/logic/eng/eng-1-thr-lvr-abv-idle"),
		eng2ThrLvrAbvIdle: props.globals.initNode("/ECAM/warnings/logic/eng/eng-2-thr-lvr-abv-idle"),
		cabPressExcessFlipflopTop: props.globals.initNode("/ECAM/warnings/logic/press/excess-cabin-alt-flipflop-top"),
		cabPressExcessFlipflop: props.globals.initNode("/ECAM/warnings/logic/press/excess-cabin-alt-flipflop"),
	},
};