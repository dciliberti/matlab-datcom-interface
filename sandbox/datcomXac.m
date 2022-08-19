% function
% Tip: for a faster, non-interactive execution, comment lines 128 and 130 
% in your datcom.bat file
%
% NEEDS Digital Datcom installed and added to the path of your system
% http://www.holycows.net/datcom/

function [xac, wing] = datcomXac(s)

% Input Section
s.name = 'myWing';

s.dim = 'M';
s.deriv = 'RAD';
s.mtow = 1000;
s.loop = 2.0;
s.alt = 0.0;
s.aoa = 0.0;
s.stmach = 0.8;
s.tsmach = 1.2;
s.tr = 0.0;
% s.mach = [0.1:0.1:s.stmach, s.tsmach:0.1:2.0];
s.mach = 0.1;

% s.sref = 100.0;
% s.cbarr = 1.0;
% s.blref = 100.0;
s.xcg = 0.25;
s.zcg = 0.0;
s.xw = 0.0;
s.zw = 0.0;

% s.croot = 1.0;
% s.ctip = 1.0;
% s.semispan = s.blref/2;
% s.expsemispan = s.semispan;
% s.sweep = 0;
% s.sweepx = 0;
% s.twist = 0;
% s.dihedral = 0;
s.type = 1.0;

s.airfoiltype = '6';
s.airfoilname = '641412';

s.caseid = ['CASEID ',s.name];

% Digital Datcom execution and output retrieval
wing = callDatcom(s);
wing.name = s.name;
deltax = - wing.cma ./ wing.cla;
xac = s.xcg + deltax;

disp('END')
end