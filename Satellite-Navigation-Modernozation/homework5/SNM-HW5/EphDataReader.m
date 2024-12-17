classdef EphDataReader
    properties
        FileName        % Name of the .dat file (optional)
        Data            % Matrix loaded from file or provided directly

        rcvr_tow        % Column 1: Receiver time of week (s)
        svid            % Column 2: Satellite PRN number (1–32)
        toc             % Column 3: Reference time of clock parameters (s)
        toe             % Column 4: Reference time of ephemeris parameters (s)
        af0             % Column 5: Clock correction coefficient – group delay (s)
        af1             % Column 6: Clock correction coefficient (s/s)
        af2             % Column 7: Clock correction coefficient (s/s/s)
        ura             % Column 8: User range accuracy (m)
        e               % Column 9: Eccentricity (-)
        sqrta           % Column 10: Square root of semi-major axis a (m**1/2)
        dn              % Column 11: Mean motion correction (r/s)
        m0              % Column 12: Mean anomaly at reference time (r)
        w               % Column 13: Argument of perigee (r)
        omg0            % Column 14: Right ascension (r)
        i0              % Column 15: Inclination angle at reference time (r)
        odot            % Column 16: Rate of right ascension (r/s)
        idot            % Column 17: Rate of inclination angle (r/s)
        cus             % Column 18: Argument of latitude correction, sine (r)
        cuc             % Column 19: Argument of latitude correction, cosine (r)
        cis             % Column 20: Inclination correction, sine (r)
        cic             % Column 21: Inclination correction, cosine (r)
        crs             % Column 22: Radius correction, sine (m)
        crc             % Column 23: Radius correction, cosine (m)
        iod             % Column 24: Issue of data number
    end
    
    methods
        % ===== Constructor to accept file name or matrix
        function obj = EphDataReader(input)
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
        
        % ===== Method to load the .dat file
        function obj = loadData(obj)
            if isfile(obj.FileName)
                obj.Data = readmatrix(obj.FileName);
                obj.Data = sortrows(obj.Data, 2); % Sort by svid (Column 2)
            end
        end
        
        % ===== Method to extract columns into class properties
        function obj = extractColumns(obj)
            obj.rcvr_tow = obj.Data(:, 1);      % Column 1
            obj.svid = obj.Data(:, 2);          % Column 2
            obj.toc = obj.Data(:, 3);           % Column 3
            obj.toe = obj.Data(:, 4);           % Column 4
            obj.af0 = obj.Data(:, 5);           % Column 5
            obj.af1 = obj.Data(:, 6);           % Column 6
            obj.af2 = obj.Data(:, 7);           % Column 7
            obj.ura = obj.Data(:, 8);           % Column 8
            obj.e = obj.Data(:, 9);             % Column 9
            obj.sqrta = obj.Data(:, 10);        % Column 10
            obj.dn = obj.Data(:, 11);           % Column 11
            obj.m0 = obj.Data(:, 12);           % Column 12
            obj.w = obj.Data(:, 13);            % Column 13
            obj.omg0 = obj.Data(:, 14);         % Column 14
            obj.i0 = obj.Data(:, 15);           % Column 15
            obj.odot = obj.Data(:, 16);         % Column 16
            obj.idot = obj.Data(:, 17);         % Column 17
            obj.cus = obj.Data(:, 18);          % Column 18
            obj.cuc = obj.Data(:, 19);          % Column 19
            obj.cis = obj.Data(:, 20);          % Column 20
            obj.cic = obj.Data(:, 21);          % Column 21
            obj.crs = obj.Data(:, 22);          % Column 22
            obj.crc = obj.Data(:, 23);          % Column 23
            obj.iod = obj.Data(:, 24);          % Column 24
        end
    end
end
