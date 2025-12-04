% 1. Configuración del objeto SDR
fs = 2.048e6;       % Frecuencia de muestreo
fc = 103.5e6;       % Frecuencia de la estación (Radio Cielo)
spf = 256*64;       % Muestras por frame

hSDR = comm.SDRRTLReceiver('CenterFrequency', fc, ...
    'SampleRate', fs, ...
    'OutputDataType', 'double', ...
    'SamplesPerFrame', spf, ...
    'FrequencyCorrection', 0);

% 2. Captura de muestras
dur = 15;                       % Duración en segundos
frames = floor(dur*fs/spf);     % Cantidad de frames

hLogger = dsp.SignalSink;       % Objeto para guardar datos


disp('Iniciando captura...');
for counter = 1:frames
    data = step(hSDR);          % Toma un frame
    step(hLogger, data);        % Lo guarda en el logger
end
disp('Captura finalizada.');

x = hLogger.Buffer;             % Vector de muestras (complejo)

% Liberar hardware
release(hSDR);
    
% Guardamos
save('datos_lab.mat', 'x', 'fs', 'fc');