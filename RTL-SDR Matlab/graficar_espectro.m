load('datos_lab.mat'); % Cargamos lo que capturaste en el paso 1

% Llamamos a la función que creamos en el paso 2
[f, Sxx] = estimar_DEP(x, fs);

% Graficamos
figure;
plot(f, 10*log10(Sxx)); % En dB como se ve en SDR#
grid on;
title('Densidad Espectral de Potencia (DEP)');
xlabel('Frecuencia (Hz)');
ylabel('Potencia (dB/Hz)');