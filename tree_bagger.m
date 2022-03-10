clear;clc;close all

%--------------------------------------------------------------------------
% load the data In (6 Environmental Variables) & Out (pollen)
% The names of the variables are stored in the cell array Names.

Time = [];
% Array to hold the PM data.
PM_1 = [];
PM2_5 = [];
PM10 = [];

% Array to hold sky color data.
SkyRed = [];
SkyBlue = [];
SkyGreen = [];

% Array to hold temperature and pressure data. 
Temperature = [];
Pressure = [];
Humidity = [];
% The currently working directory.
path = pwd;

% Year.
Year = 2019;

% Loop running over all months and all day and combines all data to a
% single array.
for month = 8:12
    for date = 1:30
        
        % If month < 10 and date < 10, we need to add a leading zero in front
        % of the month and date to get the correct file name.
        
        if month < 10 & date < 10
  
            % Creating the PM file name.
            PMFileName = string(path)+'/data/'+string(Year)+'/0'+string(month)+'/0'+string(date)+...
                '/MINTS_001e06305a61_OPCN2_'+string(Year)+'_0'+string(month)+...
                '_0'+string(date);   

            % Creating a table of the PM file just created / opened.
            Table_pm = readtable(PMFileName + '.csv');

            % Creating a Sky color file name.
            CamFileName = string(path)+'/data/'+string(Year)+'/0'+string(month)+'/0'+string(date)+...
                '/MINTS_001e06305a61_SKYCAM_002_'+string(Year)+'_0'+string(month)+...
                '_0'+string(date);

            % Creating a table of the sky color file just created / opened.
            Table_color = readtable(CamFileName + '.csv');


            TPFileName = string(path)+'/data/'+string(Year)+'/0'+string(month)+'/0'+string(date)+...
                '/MINTS_001e06305a61_BME280_'+string(Year)+'_0'+string(month)+...
                '_0'+string(date);
            Table_TP = readtable(TPFileName + '.csv');
                

        % If month < 10 and date > 10 then we do not need an a leading zero
        % in front of date.
        elseif month < 10 & date >= 10

            PMFileName = string(path)+'/data/'+string(Year)+'/0'+string(month)+'/'+string(date)+...
                '/MINTS_001e06305a61_OPCN2_'+string(Year)+'_0'+string(month)+...
                '_'+string(date);         

                % Converts the data file into a table.
            Table_pm = readtable(PMFileName + '.csv');

                % Sky cam file.
            CamFileName = string(path)+'/data/'+string(Year)+'/0'+string(month)+'/'+string(date)+...
                '/MINTS_001e06305a61_SKYCAM_002_'+string(Year)+'_0'+string(month)+...
                '_'+string(date);
            Table_color = readtable(CamFileName + '.csv');

            TPFileName = string(path)+'/data/'+string(Year)+'/0'+string(month)+'/'+string(date)+...
                '/MINTS_001e06305a61_BME280_'+string(Year)+'_0'+string(month)+...
                '_'+string(date);
            Table_TP = readtable(TPFileName + '.csv');
                
                
                
        elseif month >= 10 & date < 10
            % If the month > 10 and the date < 10, we need to add a leading zero in front
            % of the date to get the correct file name.
            
            % Creating the PM file name.
            PMFileName = string(path)+'/data/'+string(Year)+'/'+string(month)+'/0'+string(date)+...
                '/MINTS_001e06305a61_OPCN2_'+string(Year)+'_'+string(month)+...
                '_0'+string(date);   

            % Creating a table of the PM file just created / opened.
            Table_pm = readtable(PMFileName + '.csv');

            % Creating a Sky color file name.
            CamFileName = string(path)+'/data/'+string(Year)+'/'+string(month)+'/0'+string(date)+...
                '/MINTS_001e06305a61_SKYCAM_002_'+string(Year)+'_'+string(month)+...
                '_0'+string(date);

            % Creating a table of the sky color file just created / opened.
            Table_color = readtable(CamFileName + '.csv');


            TPFileName = string(path)+'/data/'+string(Year)+'/'+string(month)+'/0'+string(date)+...
                '/MINTS_001e06305a61_BME280_'+string(Year)+'_'+string(month)+...
                '_0'+string(date);
            Table_TP = readtable(TPFileName + '.csv');

            % If month > 10 and date > 10 then we do not need an a leading zero
            % in front.
        else

            PMFileName = string(path)+'/data/'+string(Year)+'/'+string(month)+'/'+string(date)+...
                '/MINTS_001e06305a61_OPCN2_'+string(Year)+'_'+string(month)+...
                '_'+string(date);         

            % Converts the data file into a table.
            Table_pm = readtable(PMFileName + '.csv');

            % Sky cam file.
            CamFileName = string(path)+'/data/'+string(Year)+'/'+string(month)+'/'+string(date)+...
                '/MINTS_001e06305a61_SKYCAM_002_'+string(Year)+'_'+string(month)+...
                '_'+string(date);
            Table_color = readtable(CamFileName + '.csv');

            TPFileName = string(path)+'/data/'+string(Year)+'/'+string(month)+'/'+string(date)+...
                '/MINTS_001e06305a61_BME280_'+string(Year)+'_'+string(month)+...
                '_'+string(date);
            
        Table_TP = readtable(TPFileName + '.csv');           
        % PM data.
        % Converting the table to time table.
        ttpm = table2timetable(Table_pm);

        Interval = 2;
        % Averaging the data every minutes defined in Interval.
        rtpm = retime(table2timetable(Table_pm),'regular',@nanmean,'TimeStep',minutes(Interval));  

        % Color data.
        ttcl = table2timetable(Table_color);

        % Averaging the data every minutes defined in Interval.
        rtcl = retime(table2timetable(Table_color),'regular',@nanmean,'TimeStep',minutes(Interval));


        % TP data.
        tttp = table2timetable(Table_TP);

        % Averaging the data every minutes defined in interval.
        rttp = retime(table2timetable(Table_TP),'regular',@nanmean,'TimeStep',minutes(Interval));

        % Synchronizing the tables.
        TT = synchronize(rtpm,rtcl,rttp);
        
        % Adding all time to a single array called Time.
        Time = [Time; TT.dateTime];
        
        % Adding the pm data of the array.
        PM_1 = [PM_1; TT.pm1];        
        PM2_5 = [PM2_5; TT.pm2_5];
        PM10 = [PM10; TT.pm10];

        % Adding the color data to an array.
        SkyRed = [SkyRed; TT.skyRed];
        SkyGreen = [SkyGreen; TT.skyGreen];
        SkyBlue = [SkyBlue; TT.skyBlue];

        % Adding the temperature, pressure and humidity into respective array.
        Temperature = [Temperature; TT.temperature];
        Pressure = [Pressure; TT.pressure];
        Humidity = [Humidity; TT.humidity];
        
        end
    end    
end      

%   p - input data.
%p = [SkyRed, SkyGreen, SkyBlue, Temperature, Pressure, Humidity]';
p = [SkyRed, SkyGreen, SkyBlue, Temperature, Pressure]';

%   t - target data.
% PM_1, PM10, PM2_5.
t = PM_1';

% A has R,G,B,T,P and PM levels.
A = [p;t];
% B has R,G,B,T,P.
B = [p];
% Converting the array A to a table T.
T = array2table(A');

% Converting the array B to a table test_T.
test_T = array2table(B');

t = templateTree('NumVariablesToSample','all',...
    'PredictorSelection','interaction-curvature','Surrogate','on');
rng(1); % For reproducibility
Mdl = fitrensemble(test_T,T.Var6,'Method','Bag','NumLearningCycles',200, ...
    'Learners',t);

yHat = oobPredict(Mdl);
R2 = corr(Mdl.Y,yHat)^2

impOOB = oobPermutedPredictorImportance(Mdl);
figure
bar(impOOB)
title('Unbiased Predictor Importance Estimates')
xlabel('Predictor variable')
ylabel('Importance')
h = gca;
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
