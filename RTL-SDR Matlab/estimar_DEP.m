function [f, Sxx] = estimar_DEP(x, fs)
    % Implementación estricta de la Ecuación 5 del Apunte de DEP
    
    N = length(x);
    T = 1/fs;
    
    % Calculo de la TDF (FFT)
    X_f = fft(x);
    
    % Centrado (fftshift) para ver frecuencias negativas y positivas
    X_f = fftshift(X_f);
    
    % Ecuación (5) del apunte: (T/N) * |X|^2
    Sxx = (T/N) * abs(X_f).^2;
    
    % Eje de frecuencias
    f = linspace(-fs/2, fs/2, N);
end