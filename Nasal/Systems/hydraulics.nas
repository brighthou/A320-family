# A3XX Hydraulic System
# Jonathan Redpath

# Copyright (c) 2019 Jonathan Redpath
var lcont = 0;
var rcont = 0;

var HYD = {
	Brakes: {
		accumPressPsi: props.globals.initNode("/systems/hydraulic/yellow-accumulator-psi-cmd", 0, "INT"),
		leftPressPsi: props.globals.initNode("/systems/hydraulic/brakes/pressure-left-psi", 0, "INT"),
		rightPressPsi: props.globals.initNode("/systems/hydraulic/brakes/pressure-right-psi", 0, "INT"),
		mode: props.globals.initNode("/systems/hydraulic/brakes/mode", 0, "INT"),
		leftbrake: props.globals.getNode("/controls/gear/brake-left"),
		rightbrake: props.globals.getNode("/controls/gear/brake-right"),
		noserubber: props.globals.initNode("/systems/hydraulic/brakes/nose-rubber", 0, "INT"),
	},
	Fail: {
		blueElec: props.globals.getNode("/systems/failures/hydraulic/blue-elec"),
		blueLeak: props.globals.getNode("/systems/failures/hydraulic/blue-leak"),
		greenEng: props.globals.getNode("/systems/failures/hydraulic/green-edp"),
		greenLeak: props.globals.getNode("/systems/failures/hydraulic/green-leak"),
		ptuFault: props.globals.getNode("/systems/failures/hydraulic/ptu"),
		yellowEng: props.globals.getNode("/systems/failures/hydraulic/yellow-edp"),
		yellowElec: props.globals.getNode("/systems/failures/hydraulic/yellow-elec"),
		yellowLeak: props.globals.getNode("/systems/failures/hydraulic/yellow-leak"),
	},
	Psi: {
		blue: props.globals.getNode("/systems/hydraulic/blue-psi"),
		green: props.globals.getNode("/systems/hydraulic/green-psi"),
		yellow: props.globals.getNode("/systems/hydraulic/yellow-psi"),
	},
	Ptu: {
		active: props.globals.getNode("/systems/hydraulic/sources/ptu/ptu-hydraulic-condition"),
		diff: props.globals.getNode("/systems/hydraulic/yellow-psi-diff"),
	},
	Pump: {
		yellowElec: props.globals.getNode("/systems/hydraulic/sources/yellow-elec/pump-operate"),
	},
	Qty: {
		blueInput: props.globals.initNode("/systems/hydraulic/blue-qty-input", 0, "INT"),
		blue: props.globals.getNode("/systems/hydraulic/blue-qty"),
		greenInput: props.globals.initNode("/systems/hydraulic/green-qty-input", 0, "INT"),
		green: props.globals.getNode("/systems/hydraulic/green-qty"),
		yellowInput: props.globals.initNode("/systems/hydraulic/yellow-qty-input", 0, "INT"),
		yellow: props.globals.getNode("/systems/hydraulic/yellow-qty"),
	},
	Rat: {
		position: props.globals.getNode("/systems/hydraulic/sources/rat/position"),
	},
	Switch: {
		blueElec: props.globals.getNode("/controls/hydraulic/switches/blue-elec"),
		blueElecOvrd: props.globals.getNode("/controls/hydraulic/switches/blue-elec-ovrd"),
		greenEDP: props.globals.getNode("/controls/hydraulic/switches/green-edp"),
		ptu: props.globals.getNode("/controls/hydraulic/switches/ptu"),
		rat: props.globals.getNode("/controls/hydraulic/switches/rat-man"),
		yellowEDP: props.globals.getNode("/controls/hydraulic/switches/yellow-edp"),
		yellowElec: props.globals.getNode("/controls/hydraulic/switches/yellow-elec"),
		nwsSwitch: props.globals.getNode("/controls/gear/nws-switch"),
	},
	Valve: {
		yellowFire: props.globals.getNode("/systems/hydraulic/sources/yellow-edp/fire-valve"),
		greenFire: props.globals.getNode("/systems/hydraulic/sources/green-edp/fire-valve"),
	},
	init: func() {
		me.resetFail();
		me.Qty.blueInput.setValue(math.round((rand() * 4) + 8 , 0.1)); # Random between 8 and 12
		me.Qty.greenInput.setValue(math.round((rand() * 4) + 8 , 0.1)); # Random between 8 and 12
		me.Qty.yellowInput.setValue(math.round((rand() * 4) + 8 , 0.1)); # Random between 8 and 12
		me.Switch.blueElec.setValue(1);
		me.Switch.blueElecOvrd.setValue(0);
		me.Switch.greenEDP.setValue(1);
		me.Switch.ptu.setValue(1);
		me.Switch.rat.setValue(0);
		me.Switch.yellowEDP.setValue(1);
		me.Switch.yellowElec.setValue(0);
	},
	resetFail: func() {
		me.Fail.blueElec.setBoolValue(0);
		me.Fail.blueLeak.setBoolValue(0);
		me.Fail.greenEng.setBoolValue(0);
		me.Fail.greenLeak.setBoolValue(0);
		me.Fail.ptuFault.setBoolValue(0);
		me.Fail.yellowEng.setBoolValue(0);
		me.Fail.yellowElec.setBoolValue(0);
		me.Fail.yellowLeak.setBoolValue(0);
	},
	loop: func(notification) {
		# Decrease accumPressPsi when green and yellow hydraulic's aren't pressurized
		if (me.Brakes.leftbrake.getValue() > 0 or notification.brakesMode == 0) {
			lcont = lcont + 1;
		} else {
			lcont = 0;
		}
		if (me.Brakes.rightbrake.getValue() > 0 or notification.brakesMode == 0) {
			rcont = rcont + 1;
		} else {
			rcont = 0;
		}
		if (notification.yellow < notification.accumPressPsi and notification.accumPressPsi > 0) {
			if  (lcont == 1) {
					me.Brakes.accumPressPsi.setValue(notification.accumPressPsi - 200);
			}
			if  (rcont == 1) {
					me.Brakes.accumPressPsi.setValue(notification.accumPressPsi - 200);
			}
			if (notification.accumPressPsi < 0) {
				me.Brakes.accumPressPsi.setValue(0);
			}
		}

		# Braking Pressure
		if (notification.brakesMode == 1 or (notification.brakesMode == 2 and notification.green >= 2500)) {
			# Normal braking - Green OK
			if (notification.leftBrake > 0) {
				me.Brakes.leftPressPsi.setValue(notification.green * notification.leftBrakeFCS);
			} else {
				me.Brakes.leftPressPsi.setValue(0);
			}
			if (notification.rightBrake > 0) {
				me.Brakes.rightPressPsi.setValue(notification.green * notification.rightBrakeFCS);
			} else {
				me.Brakes.rightPressPsi.setValue(0);
			}
		} else {
			if ((notification.brakesMode == 2 and notification.green < 2500) or notification.brakesMode == 0) {
				# Alternate Braking (Yellow OK + Antiskid ON + electric OK) - missing condition: BSCU OK-KO
				if (notification.yellow >= 2500 and notification.NWSSwitch and (notification.dc1 >= 24 or notification.dc2 >= 24 or notification.dcEss >= 24)) {
					if (notification.leftBrake > 0 or notification.brakesMode == 0) {
						me.Brakes.leftPressPsi.setValue(notification.yellow * notification.leftBrakeFCS);
					} else {
						me.Brakes.leftPressPsi.setValue(0);
					}
					if (notification.rightBrake > 0 or notification.brakesMode == 0) {
						me.Brakes.rightPressPsi.setValue(notification.yellow * notification.rightBrakeFCS);
					} else {
						me.Brakes.rightPressPsi.setValue(0);
					}
				} else {
					# Alternate Braking (Yellow OK + Antiskid OFF + electric OK) - missing condition: BSCU OK-KO
					if (notification.yellow >= 2500 and !notification.NWSSwitch and (notification.dc1 >= 24 or notification.dc2 >= 24 or notification.dcEss >= 24)) {
						if (notification.leftBrake > 0 or notification.brakesMode == 0) {
							me.Brakes.leftPressPsi.setValue(1000 * notification.leftBrakeFCS);
						} else {
							me.Brakes.leftPressPsi.setValue(0);
						}
						if (notification.rightBrake > 0 or notification.brakesMode == 0) {
							me.Brakes.rightPressPsi.setValue(1000 * notification.rightBrakeFCS);
						}  else {
							me.Brakes.rightPressPsi.setValue(0);
						}
					} else {
						# Alternate Braking (Yellow KO or Antiskid KO or electric KO) - missing condition: BSCU OK-KO
						if (notification.accumPressPsi < 1000 and (notification.yellow < 2500 or !notification.NWSSwitch or (notification.dc1 < 24 and notification.dc2 < 24 and notification.dcEss < 24))) {
							if (notification.leftBrake > 0 or notification.brakesMode == 0) {
								me.Brakes.leftPressPsi.setValue(notification.accumPressPsi * notification.leftBrakeFCS);
							} else {
								me.Brakes.leftPressPsi.setValue(0);
							}
							if (notification.rightBrake > 0 or notification.brakesMode == 0) {
								me.Brakes.rightPressPsi.setValue(notification.accumPressPsi * notification.rightBrakeFCS);
							}  else {
								me.Brakes.rightPressPsi.setValue(0);
							}
						} else {
							if (notification.leftBrake > 0 or notification.brakesMode == 0) {
								me.Brakes.leftPressPsi.setValue(1000 * notification.leftBrakeFCS);
							} else {
								me.Brakes.leftPressPsi.setValue(0);
							}
							if (notification.rightBrake > 0 or notification.brakesMode == 0) {
								me.Brakes.rightPressPsi.setValue(1000 * notification.rightBrakeFCS);
							}  else {
								me.Brakes.rightPressPsi.setValue(0);
							}
						}
					}
				} 
			}
		}
	},
};

setlistener("/controls/gear/gear-down", func {
	if (!pts.Controls.Gear.gearDown.getValue() and (pts.Gear.wow[0].getValue() or pts.Gear.wow[1].getValue() or pts.Gear.wow[2].getValue())) {
		pts.Controls.Gear.gearDown.setValue(1);
	}
});

# Emesary
var A320Hydraulic = notifications.SystemRecipient.new("A320 Hydraulic",HYD.loop,HYD);
emesary.GlobalTransmitter.Register(A320Hydraulic);

var input = {
	"blue": "/systems/hydraulic/blue-psi",
	"green": "/systems/hydraulic/green-psi",
	"yellow": "/systems/hydraulic/yellow-psi",
	
	"brakesMode": "/systems/hydraulic/brakes/mode",
	"accumPressPsi": "/systems/hydraulic/yellow-accumulator-psi-cmd",
	"leftBrake": "/controls/gear/brake-left",
	"rightBrake": "/controls/gear/brake-right",
	"leftBrakeFCS": "/fdm/jsbsim/fcs/left-brake-cmd-norm",
	"rightBrakeFCS": "/fdm/jsbsim/fcs/right-brake-cmd-norm",
	"NWSSwitch": "/controls/gear/nws-switch",
};

foreach (var name; keys(input)) {
	emesary.GlobalTransmitter.NotifyAll(notifications.FrameNotificationAddProperty.new("A320 Hydraulic", name, input[name]));
}