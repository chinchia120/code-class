classdef EphDataReader
    properties
        FileName        % Name of the .dat file
        Data            % Matrix loaded from the .dat file
        RcvrTow         % Column 1: Receiver time of week (s)
        Svid            % Column 2: Satellite PRN number (1–32)
        Toc             % Column 3: Reference time of clock parameters (s)
        Toe             % Column 4: Reference time of ephemeris parameters (s)
        Af0             % Column 5: Clock correction coefficient – group delay (s)
        Af1             % Column 6: Clock correction coefficient (s/s)
        Af2             % Column 7: Clock correction coefficient (s/s/s)
        Ura             % Column 8: User range accuracy (m)
        E               % Column 9: Eccentricity (-)
        Sqrta           % Column 10: Square root of semi-major axis a (m**1/2)
        Dn              % Column 11: Mean motion correction (r/s)
        M0              % Column 12: Mean anomaly at reference time (r)
        W               % Column 13: Argument of perigee (r)
        Omg0            % Column 14: Right ascension (r)
        I0              % Column 15: Inclination angle at reference time (r)
        Odot            % Column 16: Rate of right ascension (r/s)
        Idot            % Column 17: Rate of inclination angle (r/s)
        Cus             % Column 18: Argument of latitude correction, sine (r)
        Cuc             % Column 19: Argument of latitude correction, cosine (r)
        Cis             % Column 20: Inclination correction, sine (r)
        Cic             % Column 21: Inclination correction, cosine (r)
        Crs             % Column 22: Radius correction, sine (m)
        Crc             % Column 23: Radius correction, cosine (m)
        Iod             % Column 24: Issue of data number
    end
    
    methods
        % ===== Constructor to initialize the file name and load data
        function obj = EphDataReader(fileName)
            if nargin > 0
                obj.FileName = fileName;
                obj = obj.loadData(); % Automatically load data
                obj = obj.extractColumns(); % Extract columns to properties
            end
        end
        
        % ===== Method to load the .dat file
        function obj = loadData(obj)
            if isfile(obj.FileName)
                obj.Data = readmatrix(obj.FileName); % Load data into matrix
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
            obj.RcvrTow = obj.Data(:, 1);       % Column 1
            obj.Svid = obj.Data(:, 2);          % Column 2
            obj.Toc = obj.Data(:, 3);           % Column 3
            obj.Toe = obj.Data(:, 4);           % Column 4
            obj.Af0 = obj.Data(:, 5);           % Column 5
            obj.Af1 = obj.Data(:, 6);           % Column 6
            obj.Af2 = obj.Data(:, 7);           % Column 7
            obj.Ura = obj.Data(:, 8);           % Column 8
            obj.E = obj.Data(:, 9);             % Column 9
            obj.Sqrta = obj.Data(:, 10);        % Column 10
            obj.Dn = obj.Data(:, 11);           % Column 11
            obj.M0 = obj.Data(:, 12);           % Column 12
            obj.W = obj.Data(:, 13);            % Column 13
            obj.Omg0 = obj.Data(:, 14);         % Column 14
            obj.I0 = obj.Data(:, 15);           % Column 15
            obj.Odot = obj.Data(:, 16);         % Column 16
            obj.Idot = obj.Data(:, 17);         % Column 17
            obj.Cus = obj.Data(:, 18);          % Column 18
            obj.Cuc = obj.Data(:, 19);          % Column 19
            obj.Cis = obj.Data(:, 20);          % Column 20
            obj.Cic = obj.Data(:, 21);          % Column 21
            obj.Crs = obj.Data(:, 22);          % Column 22
            obj.Crc = obj.Data(:, 23);          % Column 23
            obj.Iod = obj.Data(:, 24);          % Column 24
            fprintf('Columns extracted successfully.\n');
        end
    end
end
