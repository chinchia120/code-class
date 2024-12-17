classdef RcvrDataReader
    properties
        FileName                % Name of the .dat file (optional)
        Data                    % Matrix loaded from the .dat file or provided directly

        rcvr_tow                % Column 1: Receiver time of week (s)
        svid                    % Column 2: Satellite PRN number (1–32)
        pr                      % Column 3: Pseudorange (m)
        carrier_phase           % Column 4: Carrier phase (cycles)
        doppler_frequency       % Column 5: Doppler frequency (Hz)
        snr_dbhz                % Column 6: Signal-to-noise ratio (dB-Hz)
    end
    
    methods
        % ===== Constructor: Accept file name or matrix input
        function obj = RcvrDataReader(input)
            if nargin > 0
                if ischar(input) || isstring(input)
                    obj.FileName = input;
                    obj = obj.loadData();      % Load data from file
                elseif isnumeric(input) && ismatrix(input)
                    obj.Data = input;          % Directly assign matrix
                end
                obj = obj.extractColumns();    % Extract columns to properties
            end
        end
        
        % ===== Method to load the .dat file
        function obj = loadData(obj)
            if isfile(obj.FileName)
                obj.Data = readmatrix(obj.FileName); % Load file content
                obj.Data = sortrows(obj.Data, [1, 2]); % Sort by rcvr_tow and svid
            end
        end
        
        % ===== Method to extract columns into class properties
        function obj = extractColumns(obj)
            obj.rcvr_tow = obj.Data(:, 1);              % Column 1
            obj.svid = obj.Data(:, 2);                  % Column 2
            obj.pr = obj.Data(:, 3);                    % Column 3
            obj.carrier_phase = obj.Data(:, 4);         % Column 4
            obj.doppler_frequency = obj.Data(:, 5);     % Column 5
            obj.snr_dbhz = obj.Data(:, 6);              % Column 6
        end
    end
end
