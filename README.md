# Sonic-zoom

Electronics part list
- 4 x Arduino UNO's
- 4 x Rotaty encoder LPD3806
- 1 x Raspberry Pi 4 (4 GB ram)
- 1 x Zoom recorder
- Microphones: 2 x contact mic, 1 x voice mic, 1 x clip-on mic or 1x voice mic.
- 1 x Wirelsee sender/receiver for voice mic. 

Software list
- PureData : sound mixing
- Arduino : Encoder input
- Processing : Serial to OSC bridge


Starting the project on the Raspberry Pi
- 1 Start the Pi
- 2 Open the Processing sketch found at:
    /Home/Pi/Documents/Byhaven_setup/serial_to_OSC/serial_to_OSC.pde
- 3 Open the Pure Data patch found at:
    /Home/Pi/Documents/Byhaven_setup/pd_v2.pd
- 4 Enable the DSP in Pure Data

Now the project should be running!!!
