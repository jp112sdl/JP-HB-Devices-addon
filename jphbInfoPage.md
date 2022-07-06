## Informationen / "Known Bugs"

#### ℹ️ Die künftige Wartung des Addons für das OCCU-Derivat "BusMatic" erfolgt direkt vom "BusMatic"-Maintainer. Downloads sind auch von dort zu beziehen.
Das unter der Quelle https://github.com/jp112sdl/JP-HB-Devices-addon in den Releases bereitgestellte Addon wird in BusMatic nicht unterstützt.

#### ❗ 06.07.2022 Addon Versionen < 6.0 nicht kompatibel zur CCU Firmware 3.65.6
- **Vor** dem Update der CCU- bzw. RaspberryMatic Version auf **3.65.6** muss Addon Version 6.0 (oder höher) installiert werden


#### ❗ 14.11.2021 Update auf Addon Version 5.8 dringend empfohlen
Aufgrund 2 schwerwiegender Bugs in früheren Versionen, die nun in der 5.7 / 5.8 behoben sind, empfehle ich, das [Update](https://github.com/jp112sdl/JP-HB-Devices-addon/releases/latest) unbedingt zu installieren.
- behobene Fehler: 
  - Die Deinstallationsroutine löschte auch Werks-Icons von Geräten _(betroffene Nutzer installieren die aktuelle verwendete RaspberryMatic/CCU Firmware einfach noch mal drüber)_
  - benutzerdefinierte XML Dateien in `customized_firmware` wurden bei einem Addon Update nicht übernommen

#### ❗ Addon Versionen < 5.4 sind aufgrund von Dateikonflikten nicht kompatibel zur CCU Firmware 3.59.x 
- **Vor** dem Update der CCU- bzw. RaspberryMatic Version muss Addon Version 5.4 (oder höher) installiert werden
- erst anschließend ist das Upgrade der CCU Firmware durchzuführen


#### 💡 Addon Version 5.0
- Unter "Einstellungen->Systemsteuerung->Zusatzsoftware" fehlen das Icon sowie die verfügbare Version
  - https://homematic-forum.de/forum/viewtopic.php?f=76&t=66890#p659185
  - ist mit der nächsten Version 5.1 gefixt


#### 💡 CCU FW Version 3.57.4 
- "Einstellungen"->"Geräte"
  - das Setzen des Wertes `0` bei einer Geräteeinstellung führt dazu, dass der Minimalwert gesetzt wird
    - siehe auch [Github](https://github.com/jens-maus/RaspberryMatic/issues/1058#issuecomment-791913360)

- **neue Firmware für das RPI-RF-MOD (4.2.14)**
  - durch Anpassung der Frequenz sind evtl. mit dem `FreqTest` abgeglichene Geräte nicht mehr (zuverlässig) erreichbar
    - siehe auch [Homematic Forum](https://homematic-forum.de/forum/viewtopic.php?f=76&t=63125&p=648643#p648640)

#### 💡 CCU FW Version 3.55.10 / 2.55.10
- "Einstellungen"->"Geräte"
  - das Setzen einiger Geräteparameter (mit Dezimalstellen) ist weiterhin nicht möglich
    - siehe [Homematic Forum](https://homematic-forum.de/forum/viewtopic.php?p=638789#p638780)
  
#### 💡 CCU FW Version 3.55.5 / 2.55.5
- "Einstellungen"->"Geräte"
  - Das Setzen von Geräteparametern ist nicht möglich
- "Status und Bedienung" -> "Räume" / "Gewerke" / "Geräte"
  - u.U. wird der Gerätetyp dem Namen vorangestellt
