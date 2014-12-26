function midiReceiver = pickMidiReceiver()
% PICKMIDIRECEIVER Prompts the user to select a midi output device and
% returns an object representing it.

import javax.sound.midi.*;
info = MidiSystem.getMidiDeviceInfo;
for i=1:length(info)
    display([num2str(i) ' ' char(info(i))]);
end
index=input('Use which port? ');
port = MidiSystem.getMidiDevice(info(index));
port.open;
midiReceiver = port.getReceiver;
