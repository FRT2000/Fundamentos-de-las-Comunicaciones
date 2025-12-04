%% Script de Captura de Datos SDR
% Alumno: Ramirez Tolentino
% Descripción: Captura muestras I/Q de una estación FM y las guarda en disco.

% 1. Configuración del objeto SDR
fs = 2.048e6;       % Frecuencia de muestreo (2.048 MSPS)
fc = 103.5e6;       % Frecuencia de la estación (Radio Cielo)
spf = 256*64;       % Muestras por frame

% Crear objeto receptor
hSDR = comm.SDRRTLReceiver('CenterFrequency', fc, ...
    'SampleRate', fs, ...
    'OutputDataType', 'double', ...
    'SamplesPerFrame', spf, ...
    'FrequencyCorrection', 0);

% 2. Captura de muestras usando SignalSink (Método Cátedra)
dur = 15;                       % Duración en segundos
frames = floor(dur*fs/spf);     % Cantidad de frames

hLogger = dsp.SignalSink;       % Objeto buffer optimizado

disp('Iniciando captura...');
for counter = 1:frames
    data = step(hSDR);          % Toma un frame
    step(hLogger, data);        % Lo guarda en el logger
end
disp('Captura finalizada.');

% Extraer datos y liberar hardware
x = hLogger.Buffer;             
release(hSDR);

% Guardar archivo de datos
save('datos_lab.mat', 'x', 'fs', 'fc');
disp('Archivo datos_lab.mat generado exitosamente.');