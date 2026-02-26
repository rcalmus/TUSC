function [ISPTA,ISPPA,assumptions] = estimateISPTA(acousticPressureAmplitudeMPa,dutyCycle,densityD,speedOfSoundInMediumC)    

    medium = 'unknown';

    if nargin < 3 || isempty(densityD)
        densityD = 1000; % density of medium (water) kg/m^3
    end
    if nargin < 4 || isempty(speedOfSoundInMediumC)
        speedOfSoundInMediumC = 1480; % speed of sound in medium (water) m/s
    end

    if ischar(densityD) && strcmpi(densityD,'water')
        medium = densityD;
        densityD = 1000;
        speedOfSoundInMediumC = 1480;
    end
    if ischar(densityD) && strcmpi(densityD,'brain')
        medium = densityD;
        densityD = 1046;
        speedOfSoundInMediumC = 1546.3;
    end

    acousticPressureAmplitudePa = acousticPressureAmplitudeMPa * 1000000;

    ISPPA = acousticPressureAmplitudePa^2/(2.0 * densityD * speedOfSoundInMediumC)/(100 * 100); % W/cm^2
    ISPTA = ISPPA * dutyCycle;

    assumptions = sprintf('Density of medium: %.0f kg/m^3; Speed of sound in medium: %.0f m/s',densityD,speedOfSoundInMediumC);
    assumptions = sprintf('Medium: %s; %s',medium,assumptions);
    assumptions = sprintf('%s; %s','Non-derated',assumptions);
end

