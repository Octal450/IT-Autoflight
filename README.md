# IT Autoflight

The **IT Autoflight System** is a modular, light, and advanced airliner autoflight framework for FlightGear. The purpose of the system is to provide a system for other airliner developers to use as a stable base for their autopilots. Examples of custom IT Autoflight System installations are shown off in the [MD-11](https://github.com/Octal450/MD-11) amongst others. IT Autoflight is a component of [IntegratedSystems](https://wiki.flightgear.org/IntegratedSystems).

## Available Modes

* Heading Hold/Select (Magnetic or True)
* LNAV (Route Manager)
* VOR/LOC Arm/Capture
* Roll Angle
* Altitude Hold/Capture
* Vertical Speed
* Glideslope Arm/Capture
* IAS/Mach with Pitch (FLCH)
* IAS/Mach with Throttle
* Climb Thrust/Idle Thrust
* Retard Thrust
* Takeoff Go Around (TOGA)
* Flight Path Angle
* Autoland and Rollout
* Automatic Pitch Trim
* Dual/Triple APs
* Flight Director
* Blank modes (AP will not control the axis with a blank mode enabled)

## Mode Functionality

The following is an explanation of the control loop behavior in each mode. The mode names from the ITAF dialog and internal mode numbers are used as a reference. See the [Interface Reference](#interface-reference) for the properties used to read these values.

### Lateral Modes

The roll/yaw modes used by the autopilot.

* HDG: A set heading is being tracked. The behavior of the mode can be heading select or heading hold based on pilot selection and user configurable behavior.
* LNAV: A GPS route is being tracked.
* LOC: A VOR or ILS localizer is being tracked.
* ALIGN: Crab angle is removed to align with the runway and bank angle applied to maintain the ILS localizer.
* ROLLOUT: Crosswind aileron is applied, and the rudder is used to keep the aircraft on the centerline during rollout.
* T/O: A takeoff heading is being tracked, or the wings are being kept level, based on user configurable behavior.
* ROLL: A set bank angle is being held.
* Blank: No roll/yaw mode is active.

### Vertical Modes

The pitch modes used by the autopilot. Automatic Pitch Trim is also used.

* ALT HLD: Altitude is being held.
* ALT CAP: The pre-selected altitude is being captured.
* V/S: A set vertical speed is being tracked.
* G/S: A glideslope is being tracked.
* SPD CLB: A set indicated airspeed or mach number is being held by varying pitch angle in order to climb. The autothrottle is commanded to hold the thrust limit.
* SPD DES: A set indicated airspeed or mach number is being held by varying pitch angle in order to descend. The autothrottle is commanded to hold idle thrust.
* FPA: A set flight path angle is being tracked.
* FLARE: The aircraft is being flared for touchdown during an autoland.
* ROLLOUT: The nose is lowered at a user configurable rate and then held on the ground via light forward pressure during rollout.
* T/O CLB: The takeoff speed (should be set to V2+10 by the aircraft) is being held by varying pitch angle. The autothrottle is commanded to hold the thrust limit.
* G/A CLB: The set go around speed (takeoff speed or current speed, whichever is higher) is being held by varying pitch angle. The autothrottle is commanded to hold the thrust limit.
* PITCH: A set pitch angle is being held.
* Blank: No pitch mode is active.

### Throttle Modes

The modes used by the autothrottle. Autothrottle modes are coupled to the vertical modes.

* SPEED: The throttles are driven to maintain a set indicated airspeed.
* MACH: The throttles are driven to maintain a set mach number.
* IDLE: The throttles are slowly driven to the idle stop for speed on pitch descends.
* RETARD: The throttles are slowly driven to the idle stop for when under a user configurable radio altitude for the landing flare. On touchdown, they are driven to the idle stop at a faster speed.
* THR LIM: The throttles are slowly driven to the thrust limit for speed on pitch climbs. In takeoff or go around modes, the throttles are driven to the thrust limit at a faster speed.
* CLAMP: The throttle servos are not being moved and the levers can be adjusted by the pilot.

## Installation Instructions

### Installing

This guide will teach you how to install IT Autoflight to an aircraft.

### Before you Begin

Download the latest version of IT Autoflight from [here](https://github.com/Octal450/IT-Autoflight/releases/latest). Extract the Archive with WinRAR, 7Zip, or similar. If you are using a custom instrumentation file, make sure it contains the ``<gps>`` item, as IT Autoflight uses it to get an accurate and stable V/S signal. You also need the property ``/position/gear-agl-ft``. This property is automatically created by YAsim, but for JSBsim you need to add a calculation for it on your own. See instructions below.

### Installation

#### Steps
* Copy the gui, Systems, and Nasal folders from the IT Autoflight folder to the aircraft's folder. Overwrite any conflicts.
* You may need to remove old autopilot dialogs for the IT Autoflight dialog to appear. Look inside the Systems and gui/dialogs folders.
* Open the -set file of the aircraft, and find the ``<systems>`` area inside ``<sim></sim>``.
* Add the following inside ``<systems></systems>``

```xml
	<autopilot n="0">
		<name>IT Autoflight</name>
		<path>Systems/it-autoflight.xml</path>
	</autopilot>
```

If you wish to use the IT Autoflight default autothrottle, add the following inside ``<systems></systems>``:

```xml
	<autopilot>
		<name>IT Autothrust</name>
		<path>Systems/it-autothrust.xml</path>
	</autopilot>
```

* If you do not add this, the A/T button in the IT Autoflight GUI Dialog will do nothing, and in PITCH mode, the pilot must adjust the throttles accordingly. You do NOT need to add this if your aircraft uses a customized autothrottle, as long as that autothrottle is compatible with IT Autoflight. See the [Interface Reference](#interface-reference) section below for more information.

If you are using a JSBsim aircraft:

* This is only required if the aircraft DOES NOT already compute the property ``/position/gear-agl-ft``.
* Copy the Systems folder from inside the JSBsim Only folder in the IT Autoflight folder to the aircraft's folder. Overwrite any conflicts.
* Then, add the following inside ``<systems></systems>``:

```xml
	<autopilot>
		<name>Gear AGL FT</name>
		<path>Systems/gear-agl-ft.xml</path>
	</autopilot>
```

* Note: You may need to adjust the value inside the gear-agl-ft.xml to match your aircraft. You can find the value by looking at /position/altitude-agl-ft property.

Now to add the IT Autoflight controller:

* Find the ``<nasal>`` area, which is outside ``<sim></sim>``.
* Add the following inside ``<nasal></nasal>``:

```xml
	<itaf>
		<file>Nasal/it-autoflight.nas</file>
	</itaf>
```

#### Configuration Module
* Finally, add the following anywhere outside ``<sim></sim>``. This is the default IT Autoflight Configuration. We will be adjusting this later.

```xml
	<it-autoflight>
		<config>
			<roll>
				<kp-low>0.11</kp-low> <!-- Roll rate gain at low speed -->
				<kp-high>0.05</kp-high> <!-- Roll rate gain at high speed -->
			</roll>
			<pitch>
				<kp-low>-0.14</kp-low> <!-- Pitch rate gain at low speed -->
				<kp-high>-0.06</kp-high> <!-- Pitch rate gain at high speed -->
			</pitch>
			<yaw>
				<gain-factor>1.0</gain-factor> <!-- Yaw rate gain scaling factor for align/rollout -->
			</yaw>
			<cmd>
				<alt>-5</alt> <!-- Altitude deviation gain -->
				<flch-accel>1.5</flch-accel> <!-- Level change accel/decel limit -->
				<roll>1.6</roll> <!-- Roll heading deviation base gain -->
			</cmd>
			<rollout>
				<pitch-nose>0.1</pitch-nose> <!-- Forward pressure to keep nose gear on ground -->
				<pitch-rate>-2</pitch-rate> <!-- Rate to lower nose to ground after touchdown -->
				<roll-angle-gain>-0.2</roll-angle-gain> <!-- Roll angle weighing for aileron after touchdown -->
				<roll-cross-gain>-0.5</roll-cross-gain> <!-- Crossed controls weighing for aileron after touchdown -->
			</rollout>
		</config>
		<settings>
			<accel-agl type="bool">1</accel-agl> <!-- Use AGL altitude for acceleration, use if no FMS acceleration alt is computed -->
			<accel-ft type="double">3000</accel-ft> <!-- Acceleration AGL when T/O CLB changes to SPD CLB, 0 to disable -->
			<align-ft type="int">150</align-ft> <!-- AGL when ALIGN engages during autoland -->
			<auto-bank-limit-calc type="bool">1</auto-bank-limit-calc> <!-- Disable to add a custom auto bank limit schedule -->
			<auto-system-reset type="bool">1</auto-system-reset> <!-- Automatically reset the system after landing -->
			<autoland-without-ap type="bool">0</autoland-without-ap> <!-- Allows FLARE and ROLLOUT pitch modes to engage even if AP is off -->
			<autothrottle-max type="double">0.95</autothrottle-max> <!-- Thrust max limit normalized -->
			<autothrottle-min type="double">0.02</autothrottle-min> <!-- Thrust low limit normalized -->
			<bank-max-deg type="double">25</bank-max-deg> <!-- Maximum bank limit -->
			<custom-fma type="bool">0</custom-fma> <!-- Call functions when modes change for a custom FMA to be implemented --> 
			<disable-final type="bool">0</disable-final> <!-- Disable the Final Controllers for custom FCS integration -->
			<elevator-in-trim type="double">0.01</elevator-in-trim> <!-- Normalized elevator to stop trimming -->
			<elevator-out-of-trim type="double">0.02</elevator-out-of-trim> <!-- Normalized elevator to start trimming -->
			<fd-starts-on type="bool">1</fd-starts-on> <!-- Enable/Disable Flight Director being on by default -->
			<fd-takeoff-deg type="double">7.5</fd-takeoff-deg> <!-- Adjust Flight Director pitch bar in T/O CLB on ground -->
			<ground-mode-select type="bool">0</ground-mode-select> <!-- Allow modes to be selected when on ground -->
			<hdg-hld-separate type="bool">0</hdg-hld-separate> <!-- Separates HDG HLD mode from HDG SEL mode -->
			<land-enable type="bool">1</land-enable> <!-- Enable/Disable autoland -->
			<land-flap type="double">0.7</land-flap> <!-- Minimum Flap used for landing -->
			<lnav-ft type="double">100</lnav-ft> <!-- AGL when LNAV becomes active if armed -->
			<max-kts type="int">380</max-kts> <!-- Maxmimum target airspeed in knots -->
			<max-mach type="double">0.9</max-mach> <!-- Maxmimum target mach number -->
			<retard-enable type="bool">1</retard-enable> <!-- Enable Thrust Retard mode -->
			<retard-ft type="double">50</retard-ft> <!-- AGL to enter Thrust Retard mode -->
			<stall-aoa-deg type="double">15</stall-aoa-deg> <!-- Angle of attack where AP trips off -->
			<takeoff-hdg-cap type="double">5</takeoff-hdg-cap> <!-- Maximum bank to capture current hdg in T/O mode -->
			<toga-spd type="double">160</toga-spd> <!-- V2 + 10kts -->
			<use-controls-engines type="bool">1</use-controls-engines> <!-- Use /controls/engines properties -->
			<use-controls-flight type="bool">1</use-controls-flight> <!-- Use /controls/flight properties -->
		</settings>
	</it-autoflight>
```

#### Complete

You have finished installing IT Autoflight. However, I highly suggest to go over the Tuning and Configuration section below, to tune the PIDs to your aircraft, and set up the settings. If you want to connect IT Autoflight to a PFD or MCP, see SDK.

### Tuning and Configuration

Below is listed each area of the IT Autoflight Config Module, and what it is used for. We will also discuss how to tune IT Autoflight efficiently.

You can view the Config Module [here](#configuration-module).

This area is for the tuning of the control loops used. These are not hard coded, so users can update IT Autoflight without needing to edit any files. You can also adjust these in the property browser, and they take affect immediately, without needing to reload anything.

#### `config/roll`

These adjust the parameters for the Roll Rate PID Controller. It is not recommended to adjust the Ti or Td unless the aircraft is very unconventional.

* kp-low: Adjust the Kp at Approach Speed/Config
* kp-high: Adjust the Kp at Max Indicated Airspeed (Tune at low altitude for best results)

#### `config/pitch`

These adjust the parameters for the Pitch Rate PID Controller. It is not recommended to adjust the Ti or Td unless the aircraft is very unconventional. You cannot adjust the Automatic Elevator Trim Controller at this time.

* kp-low: Adjust the Kp at Approach Speed/Config
* kp-high: Adjust the Kp at Max Indicated Airspeed (Tune at low altitude for best results)

#### `config/yaw`

This adjusts the gain scaling factor for the Rudder ALIGN/ROLLOUT controller.

* gain-factor: Yaw rate gain scaling factor

#### `config/cmd`

These adjust the parameters for the Command Gains.

* alt: Adjust the gain for Altitude Controller.
* flch-accel: Adjust the knots per second acceleration/deceleration for the FLCH mode.
* roll: Adjust the base for Roll Command Controllers (HDG, LNAV, VOR/LOC). Used by ITAF logic to calculate final roll gain.

#### `config/autoland`

These adjust the parameters for the PIDs used for Autoland. Tune the Roll, Pitch, and CMD first.

* pitch-kp: Adjust the Kp for the V/S PID Controller in FLARE.
* yaw-kp: Adjust the Kp for the Rudder ALIGN Controller.

#### `config/rollout`

These adjust the parameters for the PIDs used for Autoland Rollout. Tune Roll, Pitch, CMD, and Autoland first.

* pitch-nose: Adjust the amount of downward elevator deflection once the nose gear has touched down.
* pitch-rate: Adjust the target pitch rate of the nose lowering controller after touchdown.
* roll-angle-gain: Adjust the bank angle weighing factor of the aileron command after touchdown for keeping aircraft wings level.
* roll-cross-gain: Adjust the crossed controls weighing factor of the aileron command after touchdown.

#### `settings`

* `accel-agl`: Define whether to use the altimeter (0) or AGL altitude (1) for acceleration altitude.
* `accel-ft`: Define the altitude when the pitch mode changes from T/O CLB to SPD CLB (known as acceleration altitude), set to 0 to disable.
* `align-ft`: Define the altitude when the ALIGN lateral mode engages during an autoland.
* `auto-bank-limit-calc`: Disable (0) or Enable (1) calculation of the auto bank limit, when disabled, you can drive `/it-autoflight/internal/bank-limit-auto` with your own.
* `auto-system-reset`: Disable (0) or Enable (1) the system automatically resetting after landing.
* `autoland-without-ap`: Allows autoland guidance modes to be armed and become active even if AP1 and AP2 are off.
* `autothrottle-max`: Maximum throttle limit for the autothrottle.
* `autothrottle-min`: Minimum throttle limit for the autothrottle.
* `bank-max-deg`: Adjust the maximum bank limit, can be any positive non-zero number.
* `custom-fma`: When Enabled (1), custom functions will be called when modes changed for custom FMA logic. See SDK.
* `disable-final`: Enable (0) or Disable (1) the Roll and Pitch Final Controllers. IT Autoflight will compute target rates and degrees, but not control aircraft.
* `elevator-in-trim`: Normalized elevator value to stop trimming the stabilizer.
* `elevator-out-of-trim`: Normalized elevator value to start trimming the stabilizer.
* `fd-starts-on`: Disable (0) or Enable (1) the Flight Director being on by default when IT Autoflight initializes.
* `fd-takeoff-deg`: Set a value that the Flight Director pitch bar should be at when the aircraft is on the ground and in T/O CLB mode.
* `ground-mode-select`: Disable (0) or Enable (1) the ability to select active modes on the ground.
* `hdg-hld-separate`: When Enabled (1), the HDG HLD and HDG SEL modes are separate, and the HDG HLD will capture current heading, instead of syncing the input.
* `land-enable`: Disable (0) or Enable (1) the autoland system.
* `land-flap`: This defines the landing flap for the aircraft. If the flaps are set to less than this, Autoland will not work. (0 - 1)
* `lnav-ft`: Define the altitude when the roll mode changes from T/O to LNAV, if armed.
* `max-kts`: Define the maximum indicated airspeed allowed.
* `mach-mach`: Define the maximum mach number allowed.
* `retard-enable`: Disable (0) or Enable (1) Autothrottle RETARD.
* `retard-ft`: Adjust the altitude for when the Autothrottle goes into RETARD mode.
* `stall-aoa-deg`: Define the angle of attack where the AP should trip off to avoid stalling.
* `takeoff-hdg-cap`: Define the maximum bank angle where heading is captured in T/O mode, wings level is commanded until below this value. Set 0 to disable heading capture. (0 - 35)
* `toga-spd`: Define the V2+10 Speed for T/O CLB SPD by Pitch.
* `use-controls-engines`: Disable (0) or Enable (1) output to the default `/controls/engines` properties for throttles.
* `use-controls-flight`: Disable (0) or Enable (1) output to the default `/controls/flight` properties for aileron, elevator, and rudder.

### How to Tune

So, now that IT Autoflight is installed, how do you tune it to the aircraft? IT Autoflight uses a config module, so you can drop in update to the system, with minor changes required. This also means you can tune IT Autoflight while FGFS is running, no need to reload anything! So lets get started!

* First, you need to adjust the area of the config module "settings". Once this is done, start FGFS.
* Takeoff and climb above 2000ft manually. Once above 2000ft, pause the sim (p)
* I highly recommend following this tuning guide in order, as IT Autoflight uses cascading controllers, tuning out of order may cause system instabilities.

#### Roll and Pitch

* Open the Property Browser (/), navigate to `/it-autoflight/config/`
* Set `tuning-mode` to 1.
* Now engage one of the APs.
* Now you can adjust `/it-autoflight/internal/roll-rate` and `/it-autoflight/internal/pitch-rate`.
* Navigate to `/it-autoflight/config` and tune roll, and pitch, using the "roll rate" and "pitch rate" properties to test the configuration. It should be able to handle pitch rate changes from 1 degps, to 3degps, and roll rate changes by 2 degps, and 5 degps. Once roll rate and pitch rate are stable, move on. (Adjust Kp values by -0.01/0.01, or -0.001/0.001, Do not adjust Ti and Td unless you know what they do.

#### CMD and Autoland

Important Note: Most of the time, CMD tuning is not required to be changed. They should only need changing if the FDM or aircraft is bizarre. Before you tweak the values, try to tune your Roll and Pitch Rate controllers better.

* Once those are all working, tune Autoland. Easy way to test: KNUQ RW32R, takeoff runway hdg, climb 2000ft. ILS: 109.55, course 284. ARM ILS once above 250ft. Aircraft should intercept ILS.
* The `autoland/pitch-kp` is for the FLARE mode. Do not change it unless needed. Lastly, `autoland/yaw-kp` is for the Rudder ALIGN/ROLLOUT modes.

#### Complete

The tuning is now complete. Remember to check the CHANGELOG.txt after each IT Autoflight Update, to make sure, nothing needs to be retuned.

## Interface Reference

This section will discuss the inputs and outputs of IT Autoflight. These can be used for PFD/MCP interfacing, or building a custom autothrottle, or any other need for communicating with IT Autoflight. Also listed are what types of inputs are allowed. (BOOL, INT, etc.)

#### FD: `/it-autoflight/fd`

* `pitch-bar`: The flight director pitch bar deflection in degrees.
* `roll-bar`: The flight director roll bar deflection in degrees.

#### Input: `/it-autoflight/input`

* `alt`: Adjusts the Target Altitude in feet (0 - 50000). INT. (Note: IT Autoflight can fly higher than 50,000 feet.)
* `ap1`: Switches the Autopilot 1 Off (0) and On (1). BOOL.
* `ap1-avail`: Sets whether the Autopilot 1 is Unavailable (0) or Available (1). BOOL.
* `ap2`: Switches the Autopilot 2 Off (0) and On (1). BOOL.
* `ap2-avail`: Sets whether the Autopilot 2 is Unavailable (0) or Available (1). BOOL.
* `ap3`: Switches the Autopilot 3 Off (0) and On (1). BOOL.
* `ap3-avail`: Sets whether the Autopilot 3 is Unavailable (0) or Available (1). BOOL.
* `athr`: Switches the Autothrottle Off (0) and On (1). BOOL.
* `athr-avail`: Sets whether the Autothrottle is Unavailable (0) or Available (1). BOOL.
* `athr-servo-clamp`: Clamps (1) or Unclamps (0) the Autothrottle servos, also known as THR HOLD. BOOL.
* `bank-limit-sw`: Adjust the bank limit mode: AUTO (0), 5 degrees (1), 10 degrees (2), 15 degrees (3), 20 degrees (4), 25 degrees (5), 30 degrees (6), 35 degrees (7). INT.
* `fd1`: Switches the Flight Director 1 Off (0) and On (1). BOOL.
* `fd2`: Switches the Flight Director 2 Off (0) and On (1). BOOL.
* `fpa`: Adjusts the Target Flight Path Angle in degrees (-9.9 - 9.9). DOUBLE. (Note: IT Autoflight can use higher/lower FPA.)
* `fpa-abs`: Automatically set by IT Autoflight. Absolute value of the fpa input, used for fixing problems when animating cockpit controls. DOUBLE.
* `hdg`: Adjusts the Target Heading in degrees (1 - 360, or 0 - 359). INT.
* `inhibit-alt-cap`: Allow (0) or disallow (1) altitude capture when in V/S or FPA modes. BOOL.
* `kts`: Adjusts the Target Airspeed in Knots (100 - 350 by default). INT. (Note: IT Autoflight can use higher/lower airspeed.)
* `kts-mach`: Switches between Speed (0) and Mach mode (1). BOOL.
* `lat`: Changes the lateral mode to HDG SEL (0), LNAV (1), VOR/LOC (2), HDG HLD (3), ROLL (6), Blank (9). INT. (Note: Mode 4 and 5 exist, but only engaged by the controller automatically, do not set to these values.)
* `mach`: Adjusts the Target Mach (0.5 - 0.9 by default). DOUBLE. (Note: IT Autoflight can use higher/lower mach.)
* `mach-x1000`: Automatically set by IT Autoflight. Value of mach input converted to an integer, used for fixing problems when animating cockpit controls. INT.
* `pitch`: Adjusts the Target Pitch Angle in degrees. INT.
* `pitch-abs`: Automatically set by IT Autoflight. Absolute value of the pitch input, used for fixing problems when animating cockpit controls. INT.
* `radio-sel`: Switches VOR/LOC and ILS functions between NAV1 (0), NAV2 (1), and NAV3 (2). INT.
* `roll`: Adjusts the Target Roll Angle in degrees. INT.
* `roll-abs`: Automatically set by IT Autoflight. Absolute value of the roll input, used for fixing problems when animating cockpit controls. INT.
* `toga`: Engage Takeoff or Go Around Mode (1). BOOL. (Note: Do not change this value back to (0), IT Autoflight will do this automatically once the modes engage correctly.)
* `trk`: Switches between Heading (0) and Track (1). BOOL.
* `true-course`: Switches between Magentic Heading (0) and True Heading (1). BOOL.
* `vert`: Changes the vertical mode to ALT HLD (0), V/S (1), ILS (2), FLCH (4), FPA (5), Blank (9), PITCH (10). INT. (Note: Mode 3, 6, 7, and 8 exist, but only engaged by the controller automatically, do not set to these values.)
* `vs`: Adjusts the Target Vertical Speed in feet per minute (-6000 -6000). INT (Note: IT Autoflight can use higher/lower FPM).
* `vs-abs`: Automatically set by IT Autoflight. Absolute value of the vs input, used for fixing problems when animating cockpit controls. INT.

#### Internal: `/it-autoflight/internal`

> Note: DO NOT set ANY of these values!!! This WILL cause a malfunction! Only read from them.

* `aileron`: Aileron servo output used when not using /controls/flight.
* `alt`: The captured target altitude in feet, captured by the system or updated from input depending on active mode.
* `elevator`: Elevator servo output used when not using /controls/flight.
* `rudder`: Rudder servo output used when not using /controls/flight.
* `throttle[n]`: Throttle servo output used when not using /controls/engines, where n is 0 through 7 (engines 1-8).
* `vert-speed-fpm`: IT Autoflight's internal vertical speed computer.

#### Output: `/it-autoflight/output`

> Note: DO NOT set ANY of these values!!! This WILL cause a malfunction! Only read from them. These values are the output of the logic controller, if a value you need is not here, then it does not go through the logic controller.

* `ap1`: Autopilot 1: Off (0), or On (1).
* `ap2`: Autopilot 2: Off (0), or On (1).
* `ap3`: Autopilot 3: Off (0), or On (1).
* `athr`: Autothrottle: Off (0), or On (1).
* `fd1`: Flight Director 1: Off (0), or On (1).
* `fd2`: Flight Director 2: Off (0), or On (1).
* `gs-arm`: ILS: Disarmed (0), or Armed (1).
* `hdg-in-hld`: For Boeing style FMAs, usage optional. When (1), heading is captured and in HLD mode. When (0), heading is in SEL mode and acquiring.
* `lat`: Active lateral mode: HDG HLD/SEL (0), LNAV (1), VOR/LOC (2), ALIGN/ROLLOUT (4), T/O (5), ROLL (6), Blank (9). (Note: Mode 3 is reserved and not used.)
* `lnav-arm`: LNAV: Disarmed (0), or Armed (1).
* `loc-arm`: VOR/LOC: Disarmed (0), or Armed (1).
* `vert`: Active vertical mode: ALT HLD/CAP (0), V/S (1), G/S (2), FLCH (4), FPA (5), FLARE/ROLLOUT (6), T/O CLB (7), G/A CLB (8), Blank (9), PITCH (10). (Note: Mode 3 is reserved and not used.)
* `thr-mode`: Thrust System Mode: THRUST (0), PITCH Idle/RETARD (1), or PITCH Thrust Limit (2). (Note: PITCH Idle/RETARD commands the Autothrottle to Idle limit thrust, and PITCH Thrust Limit commands the Autothrottle to use set the thrust to the active thrust limit, like CLB, MCT, TOGA, etc.)

#### Text Outputs: `/it-autoflight/text`

Blank modes will display a blank string as an annunciator.

* `lat`: Active lateral mode: [HDG - LNAV - LOC - ALIGN - ROLLOUT - T/O - ROLL]
* `vert`: Active vertical mode: [ALT HLD - V/S - G/S - ALT CAP - SPD DES - SPD CLB - FPA - FLARE - ROLLOUT - T/O CLB - G/A CLB - PITCH]
* `spd`: Speed method: [THRUST - PITCH - RETARD]
* `thr`: Thrust mode: [SPEED - MACH - IDLE - RETARD - THR LIM - CLAMP]

#### Flight Director

The following shows how to implement a flight director with ITAF.

The bars should be shown when `/it-autoflight/output/fd1` or `/it-autoflight/output/fd2` is true (1). When all autopilots and flight directors are off, some computations are turned off or synced. As a result, only display the bars when the flight director is enabled.

Dual Cue (Cross bars)
The pitch bar should be translated vertically based on `/it-autoflight/fd/pitch-bar`, which is in degrees. Positive is upwards.

The roll bar should be translated horizontally based on `/it-autoflight/fd/roll-bar`, which is in degrees. Positive is to the right.

Single Cue (V-bar)
The V-bar should be translated vertically based on `/it-autoflight/fd/pitch-bar`, which is in degrees. Positive is upwards.

The V-bar should be rotated based on `/it-autoflight/fd/roll-bar`, which is in degrees. Positive is to the right.

#### Custom FMA

ITAF supports calling custom functions for a custom FMA. That way you don't need to use listeners or such that worsens performance.

You need to enable the custom-fma setting in the config module. Then, add the Custom FMA nasal file in the itaf namespace:

ITAF includes an optional [custom-fma.nas](https://github.com/Octal450/IT-Autoflight/blob/master/Custom%20FMA/custom-fma.nas) file as an example. It is in the Custom FMA folder, copy it to the Nasal folder in your aircraft.
Find the `<nasal>` area, which is outside `<sim></sim>`.
Find where you added `<itaf></itaf>` to `<nasal></nasal>`
Add the custom-fma.nas as shown:

```xml
	<itaf>
		<file>Nasal/it-autoflight.nas</file>
		<file>Nasal/custom-fma.nas</file>
	</itaf>
```

The functions called are:

* `updateFma.lat()`: Called when the lateral mode changes
* `updateFma.vert()`: Called when the vertical mode changes
* `updateFma.thr()`: Called when the thrust mode changes
* `updateFma.arm()`: Called when LNAV, LOC, and G/S are armed/disarmed
