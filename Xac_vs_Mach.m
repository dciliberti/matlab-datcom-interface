% Set an input file, exceute Digital Datcom, and plot lift curve slope vs
% Mach number for several wings.
% Tip: for a faster, non-interactive execution, comment lines 128 and 130 
% in your datcom.bat file
%
% NEEDS Digital Datcom installed and added to the path of your system
% http://www.holycows.net/datcom/

close all; clearvars; clc

%% Input Section
s.name = 'NACA 64_1412';

s.dim = 'M';
s.deriv = 'RAD';
s.mtow = 1000;
s.loop = 2.0;
% s.mach = 0.1:0.1:2; % mach > 0
s.alt = 0.0;
s.aoa = 0.0;
s.stmach = 0.8;
s.tsmach = 1.2;
s.tr = 0.0;
s.mach = [0.1:0.1:s.stmach, s.tsmach:0.1:2.0];

s.sref = 100.0;
s.cbarr = 1.0;
s.blref = 100.0;
s.xcg = 0.25;
s.zcg = 0.0;
s.xw = 0.0;
s.zw = 0.0;

s.croot = 1.0;
s.ctip = 1.0;
s.semispan = s.blref/2;
s.expsemispan = s.semispan;
s.sweep = 0;
s.sweepx = 0;
s.twist = 0;
s.dihedral = 0;
s.type = 1.0;

s.airfoiltype = '6';
s.airfoilname = '641412';

s.caseid = ['CASEID ',s.name];

%% Digital Datcom execution and output retrieval
wing1 = callDatcom(s);
wing1.name = s.name;

s.name = 'Supersonic';
s.airfoiltype = 'S';
s.airfoilname = '2-30.0-1.0';
s.caseid = ['CASEID ',s.name];
wing2 = callDatcom(s);
wing2.name = s.name;

AR = s.blref^2/s.sref;
Lambda = s.sweep;
taper = s.ctip/s.croot;
xref = s.xcg;

%% Plot section
figure
hold on

clearvars s appo lista
lista = whos;
c = 0;  % counter
for idx = 1:length(lista) % cycle over struct variables in the workspace
    if strcmp(lista(idx).class,'struct')
        c = c + 1;
        appo = eval(lista(idx).name);
        xx = linspace(appo.mach(1),appo.mach(end));
        deltax = - appo.cma ./ appo.cla;
        xac = xref + deltax;
        yy = spline(appo.mach,xac,xx);
        plot(xx,yy,'LineWidth',2)
        legendnames{c} = appo.name; %#ok<SAGROW>
    end
end

hold off
grid on
xlabel('Mach number')
ylabel('x_{ac}')
legend(legendnames,'interpreter','tex')
ylim([0,0.6])

disp('END')