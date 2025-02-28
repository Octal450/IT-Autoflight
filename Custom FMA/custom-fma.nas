# IT Autoflight V4.1.0 Custom FMA File
# Make sure you enable custom-fma in the config
# Copyright (c) 2025 Josh Davidson (Octal450)

var UpdateFma = {
	latText: "T/O",
	spdText: "PITCH",
	thrText: "THR LIM",
	vertText: "T/O CLB",
	thr: func() { # Called when speed/thrust modes change
		me.spdText = Text.spd.getValue();
		me.thrText = Text.thr.getValue();
	},
	arm: func() { # Called when armed modes change
		Output.lnavArm.getBoolValue();
		Output.locArm.getBoolValue();
		Output.gsArm.getBoolValue();
	},
	lat: func() { # Called when lateral mode changes
		me.latText = Text.lat.getValue();
	},
	vert: func() { # Called when vertical mode changes
		me.vertText = Text.vert.getValue();
	},
};
