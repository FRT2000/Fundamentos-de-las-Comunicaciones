function [f, Sxx] = estimar_DEP(x, fs)
% ESTIMAR_DEP Calcula la Densidad Espectral de Potencia
% Basado en la Ecuación (5) del apunte de la Cátedra.

    N = length(x);
    T = 1/fs;
    
    % 1. Transformada de Fourier (FFT)
    X_f = fft(x);
    
    % 2. Centrar el espectro (frecuencias negativas a la izquierda)
    X_f = fftshift(X_f);
    
    % 3. Cálculo de Potencia (Ec. 5 del apunte)
    Sxx = (T/N) * abs(X_f).^2;
    
    % 4. Generar eje de frecuencias
    f = linspace(-fs/2, fs/2, N);
end