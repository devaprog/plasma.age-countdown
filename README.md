# Desktop Widget: age-countdown
A KDE Plasma 6 widget Shows time lived since a chosen date/time, updating every second.

<img width="1002" height="671" alt="image" src="https://github.com/user-attachments/assets/481f87dd-1398-469e-94a2-5306f37ab4c7" />

#Follow:
clone repository
open terminal in downloads
##cmds:
cd source
zip -r ../agefrombirth.plasmoid . 
cd ..
kpackagetool6 --type Plasma/Applet -i agefrombirth.plasmoid 

###in above cmd:
-i to install
-u to update
-r to remove
