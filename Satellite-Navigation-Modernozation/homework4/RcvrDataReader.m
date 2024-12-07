classdef RcvrDataReader
    properties
        FileName            % Name of the .dat file
        Data                % Matrix loaded from the .dat file
        RcvrTow             % Column 1: Receiver time of week (s)
        Svid                % Column 2: Satellite PRN number (1–32)
        Pr                  % Column 3: Pseudorange (m)
        CarrierPhase        % Column 4: Carrier phase (cycles)
        DopplerFrequency    % Column 5: Doppler frequency (Hz)
        SnrDbhz             % Column 6: Signal-to-noise ratio (dB-Hz)
    end
    
    methods
        % ===== Constructor to initialize the file name and load data
        function obj = RcvrDataReader(fileName)
            if nargin > 0
                obj.FileName = fileName;
                obj = obj.loadData(); % Automatically load data
                obj = obj.extractColumns(); % Extract columns to properties
            end
        end
        
        % ===== Method to load the .dat file
        function obj = loadData(obj)
            if isfile(obj.FileName)
                obj.Data = readmatrix(obj.FileName);
                fprintf('File %s loaded successfully.\n', obj.FileName);
            else
                error('File %s does not exist.', obj.FileName);
            end
        end
        
        % ===== Method to extract columns into class properties
        function obj = extractColumns(obj)
            if isempty(obj.Data)
                error('No data loaded. Use the loadData method first.');
            end
            obj.RcvrTow = obj.Data(:, 1);           % Column 1
            obj.Svid = obj.Data(:, 2);              % Column 2
            obj.Pr = obj.Data(:, 3);                % Column 3
            obj.CarrierPhase = obj.Data(:, 4);      % Column 4
            obj.DopplerFrequency = obj.Data(:, 5);  % Column 5
            obj.SnrDbhz = obj.Data(:, 6);           % Column 6
            fprintf('Columns extracted successfully.\n');
        end
    end
end
