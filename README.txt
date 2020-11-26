This project is a simple app for Garmin watches, build using Garmin Connect IQ (CIQ).
It allows your watch to connect to a a Shimano STEPS e-bike using Bluetooth Low Energy (BLE) 
and displays ebike information like battery level, assist mode, gear number, but also time and heartbeat. 
Future updates will include changing the retail destination country (max. speed with motor support).

This project was derived from Mark.Ai's data field at https://github.com/markdotai/emtb which is released 
in the Garmin app store here: https://apps.garmin.com/en-US/apps/461743f9-b350-486f-bd87-613c7b0bab90.
Because Mark published his project (code) on GitHub and the data field app did not work on my VivoActive 4 I started to investigate his work. 
THE BUG: there is no bug in Mark's code. The bug is somewhere in Garmin's CIQ software on some watches.
An CIQ app using BluetoothLowEnergie (BLE) can register up to 3 Bluetooth Profile Definitions.On the VivoActive 4, and Venu watches, the registration fails for every 2nd and 3rd profile. The result is that the app connects over BLE with the ebike but data is not exchanged and that is mistaken by users as an app failure.
This app will display an error message "ErrPrf:-1" or "ErrPrf:-2" where -1 and -2 are the failed number of registreations.
See the bug report and status at: https://forums.garmin.com/developer/connect-iq/i/bug-reports/vivoactive-4-bledelegate-onprofileregister-returns-status-value-2-on-every-2nd-and-3rd-registerprofile

This app is released in the Garmin app store.

When you start developing for Garmin Connect IQ then don't forget to read this page:
https://forums.garmin.com/developer/connect-iq/w/wiki/4/new-developer-faq .

Icons from www.thenuonproject.com by Luis PradoLuis Prado..
