%% Script Principal - Laboratorio 1: Demodulación digital de señal real de FM
% Alumno: Ramirez Tolentino, Fernando
% Legajo: 01964/8
% Materia: Fundamentos de las Comunicaciones

clear; clc; close all;

%% 1. Carga de la señal capturada
disp('Cargando datos del archivo datos_lab.mat...');
if exist('datos_lab.mat', 'file')
    load('datos_lab.mat'); % Carga x, fs, fc
else
    error('No se encuentra datos_lab.mat. Ejecute captura_de_datos.m primero.');
end

%% 2. Definición de Parámetros de Diseño
% Según Criterio de Carson: BW = 2(75k + 15k) = 180 kHz
B1 = 180e3;     
N1 = 8;         % 2.048 MHz / 8 = 256 kHz (fs1)
B2 = 15e3;      % Ancho de banda de audio mono (15 kHz)
N2 = 5;         % 256 kHz / 5 = 51.2 kHz (fs2 - Audio soportado por PC)

%% 3. Procesamiento (Llamada a la función)
disp('Procesando señal (Filtrado y Demodulación)...');
[z_out, z_N2, z_B2, z_dis, y_N1, y_B1] = demodulador_digital(x, B1, N1, B2, N2, fs);

% Recálculo de frecuencias de muestreo para los ejes de los gráficos
fs1 = fs / N1;
fs2 = fs1 / N2;

%% 4. Visualización de Resultados

% FIGURA 1: Espectro RF Filtrado
[f_rf, S_rf] = estimar_DEP(y_N1, fs1);
figure('Name', 'Análisis Espectral RF');
plot(f_rf/1e3, 10*log10(S_rf), 'b');
grid on;
title('Espectro de Señal RF (Filtrada y Diezmada)');
xlabel('Frecuencia (kHz)'); ylabel('Potencia (dB)');
xlim([-150 150]); % Zoom a +/- 150 kHz

% FIGURA 2: Espectro MPX (Salida Discriminador)
% Aquí se debe ver el Audio (<15k) y el Piloto (19k)
[f_mpx, S_mpx] = estimar_DEP(z_dis, fs1);
figure('Name', 'Espectro MPX Demodulado');
plot(f_mpx/1e3, 10*log10(S_mpx), 'r');
grid on;
title('Espectro de la Señal MPX Demodulada');
xlabel('Frecuencia (kHz)'); ylabel('Potencia (dB)');
xlim([0 60]); % Zoom 0 a 60 kHz
xline(19, '--k', 'Piloto 19kHz'); % Marca de referencia

% FIGURA 3: Señal de Audio Final
t = (0:length(z_out)-1) / fs2;
figure('Name', 'Señal de Audio en Tiempo');
plot(t, z_out);
grid on;
title('Señal de Audio Final Recuperada');
xlabel('Tiempo (s)'); ylabel('Amplitud Normalizada');
xlim([0 0.05]); % Zoom a 50 ms

%% 5. Reproducción
disp(['Reproduciendo audio resultante a ' num2str(fs2) ' Hz...']);
sound(z_out, fs2);