function aero = callDatcom(s)
% Execute Digital Datcom. Input data is a MATLAB struct containing
% namelists to be written in a .dcm file. The output is read with the
% datcomimport function of the Aerospace Toolset and returned as a struct.

% Check on file names
if exist(s.name) == 2 %#ok<EXIST>
    warning(['The name ',s.name,' is not allowed', ...
       ' because it already exist as MATLAB file.', ...
       ' The file has been renamed as: ', s.name,'_foo']);
   s.name = [s.name,'_foo'];
   s.caseid = ['CASEID ',s.name];
end

% Digital Datcom execution and output retrieving
writeDatcomInput(s)
disp(['Executing DATCOM for ',s.name])
dos([s.name,'.dcm']);
aero = datcomimport([s.name,'.out']);

% Move datcom files into output folder
if ~exist('output','dir')
    mkdir output
end
movefile([s.name,'*.*'],'output')

% Return output
aero = aero{1};
end