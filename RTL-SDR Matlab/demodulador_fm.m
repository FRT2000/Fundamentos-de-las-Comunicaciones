%% Cargar datos previos (del paso anterior)
load('datos_lab.mat'); 

%% 1. Filtrado Pasa-Bajos Inicial (Bloque "LPF B1" de Fig. 2)
% Diseñamos el filtro para aislar la estación (como hicimos en el paso 4)
orden = 5;
bw_carson = 180e3;       % 180 kHz (Ancho de banda FM)
fc_filtro = bw_carson/2; % 90 kHz (Unilateral)
wn = fc_filtro / (fs/2);
[b, a] = butter(orden, wn);

% Aplicamos el filtro
y_B1 = filter(b, a, x); 

%% 2. Diezmado (Bloque "N1" de Fig. 2)
% La guía pide usar 'decimate' con 'fir' [cite: 3669]
% Elegimos N1 para bajar de 2.048 MHz a algo cercano a 250 kHz
N1 = 8; 
fs1 = fs / N1; % Nueva frecuencia de muestreo = 256 kHz

% Ejecución del comando textual de la guía:
y_N1 = decimate(y_B1, N1, 'fir');

%% 3. Discriminador (Bloque "Discriminador" de Fig. 2)
% La guía pide usar angle, unwrap y diff [cite: 3683-3686]

% a) Obtener fase
fase = angle(y_N1);

% b) Desenroscar fase (unwrap)
fase_unwrap = unwrap(fase);

% c) Derivar fase (diff) para obtener frecuencia (mensaje)
% Ecuación (2) de la guía: m[n] aprox (phi[n] - phi[n-1])/T
% Multiplicamos por fs1 porque dividir por T es multiplicar por fs
z_dis = diff(fase_unwrap) * fs1; 

%% 4. Visualización del Espectro Demodulado (Pedido en el texto)
% "Dibuje el espectro de esta señal... vea un tono piloto en 19 kHz" [cite: 3689]

[f_audio, S_audio] = estimar_DEP(z_dis, fs1);

figure;
plot(f_audio, 10*log10(S_audio));
grid on;
title('Espectro de la Señal Demodulada (MPX)');
xlabel('Frecuencia (Hz)');
ylabel('Potencia (dB)');
xlim([0 60e3]); % Zoom en 0 a 60 kHz para ver audio y piloto

%% 5. Filtrado de Audio Final y Segundo Diezmado (Bloque "LPF B2" y "N2")
% Diseñamos un filtro pasa-bajos de audio (corte en 15 kHz)
% para eliminar el piloto y el ruido estéreo antes de escuchar.
fc_audio = 15000; % 15 kHz
wn_audio = fc_audio / (fs1/2);
[b_audio, a_audio] = butter(5, wn_audio);

% Filtramos la señal demodulada
z_B2 = filter(b_audio, a_audio, z_dis);

% Segundo Diezmado (N2)
% Bajamos de 256 kHz a algo que la placa de audio acepte (~50 kHz)
N2 = 5;
fs2 = fs1 / N2; 

% Diezmamos
z_N2 = decimate(z_B2, N2, 'fir');

% Normalización (Importante para no romper los parlantes)
% Hacemos que el volumen máximo sea 1
z_out = z_N2 / max(abs(z_N2));

%% 6. ¡Reproducir!
disp(['Reproduciendo audio a ' num2str(fs2) ' Hz...']);
sound(z_out, fs2);

% Graficar el audio final en el tiempo
figure;
plot(z_out);
title('Señal de Audio Final Recuperada');
xlabel('Muestras');
ylabel('Amplitud Normalizada');