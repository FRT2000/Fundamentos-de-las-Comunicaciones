function [z_out, z_N2, z_B2, z_dis, y_N1, y_B1] = demodulador_digital(x, B1, N1, B2, N2, fs)
% demodulador_digital.m Implementación del receptor FM Digital
% Según diagrama de bloques Fig. 2 del Laboratorio.
%
% INPUTS:
%   x: Señal compleja de entrada
%   B1: Ancho de banda filtro RF (Carson)
%   N1: Primer factor de diezmado
%   B2: Ancho de banda filtro Audio
%   N2: Segundo factor de diezmado
%   fs: Frecuencia de muestreo original
%
% OUTPUTS:
%   z_out: Audio final normalizado
%   z_dis: Señal a la salida del discriminador (MPX)
%   y_N1:  Señal RF filtrada y diezmada

    %% 1. Filtrado Pasa-Bajos de RF (LPF B1)
    % Diseñamos filtro Butterworth Orden 5
    fc_rf = B1 / 2;          % Frecuencia de corte (unilateral)
    wn_rf = fc_rf / (fs/2);  % Frecuencia normalizada
    [b1, a1] = butter(5, wn_rf);
    
    y_B1 = filter(b1, a1, x);

    %% 2. Primer Diezmado (Bloque N1)
    % Baja la tasa de muestreo de fs a fs1
    y_N1 = decimate(y_B1, N1, 'fir');
    fs1 = fs / N1; % Nueva frecuencia intermedia

    %% 3. Discriminador de Frecuencia
    % Obtiene la fase y la deriva para recuperar el mensaje
    fase = angle(y_N1);
    fase_unwrap = unwrap(fase);
    
    % Derivada discreta (Ec. 2 de la guía)
    % Multiplicamos por fs1 para mantener la escala correcta
    z_dis = diff(fase_unwrap) * fs1;
    
    % Ajuste de dimensión: diff reduce el vector en 1 muestra
    z_dis = [z_dis; 0];

    %% 4. Filtrado de Audio (LPF B2)
    % Elimina piloto y componentes ultrasónicas
    wn_audio = B2 / (fs1/2);
    [b2, a2] = butter(5, wn_audio);
    z_B2 = filter(b2, a2, z_dis);

    %% 5. Segundo Diezmado (Bloque N2) y Salida
    % Baja la tasa de fs1 a fs2 (audio)
    z_N2 = decimate(z_B2, N2, 'fir');
    
    % Normalización de amplitud (para evitar saturar parlantes)
    z_out = z_N2 / max(abs(z_N2));
end