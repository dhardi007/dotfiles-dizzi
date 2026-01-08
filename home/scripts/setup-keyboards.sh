# ~/scripts/setup-keyboards.sh
#!/bin/bash
input-remapper-control --command start --device "Compx 2.4G Wireless Receiver" --preset "teclado-Bluetooth"
sleep 1
input-remapper-control --command start --device "AT Translated Set 2 keyboard" --preset "teclado-classmate"
