%% Cargar datos previos
load('datos_lab.mat'); 

%% 1. Diseño del Filtro
% El PDF sugiere Butterworth orden 5
orden = 5;
bw_carson = 180e3;      % 180 kHz según teoría
f_corte = bw_carson / 2; % 90 kHz (radio desde el centro)

% Normalizamos la frecuencia respecto a Nyquist (fs/2)
wn = f_corte / (fs/2); 

% Creamos los coeficientes del filtro
[b, a] = butter(orden, wn);

%% 2. Aplicación del Filtro
% Filtramos la señal 'x' capturada
y_filtrada = filter(b, a, x);

%% 3. Verificación Visual (Espectro antes y después)
% Estimamos DEP de la señal filtrada
[f, Sxx_orig] = estimar_DEP(x, fs);
[f, Sxx_filt] = estimar_DEP(y_filtrada, fs);

figure;
plot(f, 10*log10(Sxx_orig), 'Color', [0.7 0.7 0.7]); % Gris para la original
hold on;
plot(f, 10*log10(Sxx_filt), 'LineWidth', 1.5, 'Color', 'b'); % Azul para la filtrada
grid on;
legend('Señal Original (SDR)', 'Señal Filtrada (Butterworth)');
title('Efecto del Filtrado Digital (Inciso 4)');
xlabel('Frecuencia (Hz)');
ylabel('Potencia (dB)');
xlim([-500e3 500e3]); % Zoom para ver el corte
ylim([-150 -20]);