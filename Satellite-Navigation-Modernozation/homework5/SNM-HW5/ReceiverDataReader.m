classdef ReceiverDataReader
    properties
        FileName        % Name of the file (optional)
        Data            % Matrix loaded from file or provided directly

        Time            % Column 1: Time
        X               % Column 2: X
        Y               % Column 3: Y
        Z               % Column 4: Z
        Lat             % Column 5: Latitude
        Lon             % Column 6: Longitude
        Alt             % Column 7: Altitude
        Clock_Bias      % Column 8: Clock Bias
    end
    
    methods
        % ===== Constructor to accept file name or matrix
        function obj = ReceiverDataReader(input)
            if nargin > 0
                if ischar(input) || isstring(input)
                    obj.FileName = input;
                    obj = obj.loadData();  % Load data from file
                elseif isnumeric(input) && ismatrix(input)
                    obj.Data = input;      % Assign matrix directly
                end
                obj = obj.extractColumns(); % Extract columns to properties
            end
        end
        
        % ===== Method to load the file
        function obj = loadData(obj)
            [~, ~, ext] = fileparts(obj.FileName);

            switch lower(ext)
                case '.dat' % Read .dat file
                    obj.Data = readmatrix(obj.FileName); 
                case '.mat' % Load .mat file
                    loadedData = load(obj.FileName); 
                    fieldNames = fieldnames(loadedData);
                    if length(fieldNames) == 1
                        obj.Data = loadedData.(fieldNames{1});
                    end
            end
        end
        
        % ===== Method to extract columns into class properties
        function obj = extractColumns(obj)
            obj.Time = obj.Data(:, 1);         % Column 1: Time
            obj.X = obj.Data(:, 2);            % Column 2: X
            obj.Y = obj.Data(:, 3);            % Column 3: Y
            obj.Z = obj.Data(:, 4);            % Column 4: Z
            obj.Lat = obj.Data(:, 5);          % Column 5: Latitude
            obj.Lon = obj.Data(:, 6);          % Column 6: Longitude
            obj.Alt = obj.Data(:, 7);          % Column 7: Altitude
            obj.Clock_Bias = obj.Data(:, 8);   % Column 8: Clock Bias
        end
    end
end