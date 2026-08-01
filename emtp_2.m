clc;
clear;
close all;

f = 1.356e7;              % Frequency (13.56 MHz)
w = 2*pi*f;               % Angular frequency

% Complex voltage and current from COMSOL
Vcoil = 0.0011581 + 0.073146i;
Icoil = -1.1581e-5 - 7.3146e-4i;

% 2. Magnitudes and Phases
Vmag = abs(Vcoil);
Imag = abs(Icoil);
Vphase = angle(Vcoil);
Iphase = angle(Icoil);

disp("Voltage magnitude = " + Vmag + " V")
disp("Current magnitude = " + Imag + " A")

% 3. Time Domain Waveforms
T = 1/f;                          % Signal period
t = linspace(0, 3*T, 1000);       % Plot 3 cycles

Vt = Vmag*cos(w*t + Vphase);
It = Imag*cos(w*t + Iphase);

figure
plot(t*1e6, Vt, 'b', 'LineWidth', 2)
hold on
plot(t*1e6, 100*It, 'r', 'LineWidth', 2)
grid on
xlabel('Time (\mus)')
ylabel('Amplitude')
legend('Voltage', '100 \times Current')
title('Receiver Coil Voltage and Current Waveforms')

% 4. Instantaneous Power
Pt = Vt .* It;

figure
plot(t*1e6, Pt, 'LineWidth', 2)
grid on
xlabel('Time (\mus)')
ylabel('Power (W)')
title('Instantaneous Power Delivered to Load')

% 5. Average Power
Pavg = mean(Pt);
hold on
yline(Pavg, 'r--', 'Average Power')
legend('Instantaneous Power', 'Average Power')

disp("Average Power = " + Pavg + " W")

% 6. Complex Power
S = Vcoil * conj(Icoil);
P_real = real(S);
Q_reactive = imag(S);

disp("Real Power delivered = " + P_real + " W")
disp("Reactive Power = " + Q_reactive + " VAR")

% 7. Power Transfer Efficiency
P_tx = 0.1;                       % Example transmitted power (100 mW)
efficiency = (P_real / P_tx) * 100;

disp("Power Transfer Efficiency = " + efficiency + " %")

% 8. Phase Difference
phase_diff = Vphase - Iphase;

disp("Phase difference (rad) = " + phase_diff)
disp("Phase difference (deg) = " + rad2deg(phase_diff))

figure
bar(rad2deg(phase_diff))
ylabel('Phase (degrees)')
title('Phase Difference Between Voltage and Current')
grid on

% 9. Phasor Diagram
scale = 100;

figure
quiver(0, 0, real(Vcoil), imag(Vcoil), 'b', 'LineWidth', 2)
hold on
quiver(0, 0, scale*real(Icoil), scale*imag(Icoil), 'r', 'LineWidth', 2)
xlabel('Real')
ylabel('Imaginary')
legend('Voltage Phasor', '100 \times Current Phasor')
title('Phasor Representation of Voltage and Current')
grid on
axis equal

% 10. Frequency Response
f_range = linspace(1e6, 20e6, 500);
f0 = 13.56e6;                     % Resonant frequency
Q = 20;                           % Quality factor

V_response = Vmag ./ sqrt(1 + Q^2 * ((f_range/f0 - f0./f_range).^2));

figure
plot(f_range/1e6, V_response, 'LineWidth', 2)
grid on
xlabel('Frequency (MHz)')
ylabel('Voltage Magnitude (V)')
title('Receiver Coil Voltage vs Frequency')

% 11. Efficiency Plot
figure
efficiency = abs(P_real / P_tx) * 100;
bar(efficiency)
ylabel('Efficiency (%)')
title('Wireless Power Transfer Efficiency')
grid on

set(gca, 'FontSize', 12)
set(gcf, 'Color', 'w')