classdef RcvrDataReader
    properties
        FileName                % Name of the .dat file
        Data                    % Matrix loaded from the .dat file

        rcvr_tow                % Column 1: Receiver time of week (s)
        svid                    % Column 2: Satellite PRN number (1–32)
        pr                      % Column 3: Pseudorange (m)
        carrier_phase           % Column 4: Carrier phase (cycles)
        doppler_frequency       % Column 5: Doppler frequency (Hz)
        snr_dbhz                % Column 6: Signal-to-noise ratio (dB-Hz)
    end
    
    methods
        % ===== Constructor to initialize the file name and load data
        function obj = RcvrDataReader(fileName)
            if nargin > 0
                obj.FileName = fileName;
                obj = obj.loadData();
                obj = obj.extractColumns();
            end
        end
        
        % ===== Method to load the .dat file
        function obj = loadData(obj)
            if isfile(obj.FileName)
                obj.Data = readmatrix(obj.FileName);
                obj.Data = sortrows(obj.Data, 2);

                fprintf('%%%% ===== File %s loaded successfully ===== %%%%\n', obj.FileName);
            else
                error('%%%% ===== File %s does not exist  ===== %%%%\n', obj.FileName);
            end
        end
        
        % ===== Method to extract columns into class properties
        function obj = extractColumns(obj)
            if isempty(obj.Data)
                error('%%%% ===== No data loaded ===== %%%%\n\n');
            end

            obj.rcvr_tow = obj.Data(:, 1);              % Column 1
            obj.svid = obj.Data(:, 2);                  % Column 2
            obj.pr = obj.Data(:, 3);                    % Column 3
            obj.carrier_phase = obj.Data(:, 4);         % Column 4
            obj.doppler_frequency= obj.Data(:, 5);      % Column 5
            obj.snr_dbhz = obj.Data(:, 6);              % Column 6
            
            fprintf('%%%% ===== Columns extracted successfully ===== %%%%\n\n');
        end
    end
end
