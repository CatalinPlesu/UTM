Command for configuring recurrence over Bluetooth implemented as a state machine:

States/Commands
0x00      -> Idle
0xF1      -> Recurrence
    int   -> Select parameter index
    int   -> New recurrence value
    int   <- Current value
           - Idle
0xF2      -> Write default recurrence
    int   -> Select parameter index
           - Idle
0xA{0..2} - Alarm setting
    int   -> Select parameter index
    int   -> Write interval type
    int   <- Read interval type
    float -> Write lower limit
    float <- Read lower limit
    float -> Write upper limit
    float <- Read upper limit
           - Idle
0xB{0..2} - Disable alarm by index
           - Idle
0xD{0..2} - Delete alarm by index
           - Idle
0xE{0..2} - Enable alarm by index
           - Idle
0xEE      - Unixtime
    int64 -> Write unixtime
    int64 -> Read unixtime
           - Idle
0xFF       - Reset
           - Idle
