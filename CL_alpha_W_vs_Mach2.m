% Set an input file, exceute Digital Datcom, and plot lift curve slope vs
% Mach number for several wings.
% Tip: for a faster, non-interactive execution, comment lines 128 and 130 
% in your datcom.bat file
%
% NEEDS Digital Datcom installed and added to the path of your system
% http://www.holycows.net/datcom/

close all; clearvars; clc

%% Input Section
s.name = 'NACA 0012';

s.dim = 'M';
s.deriv = 'RAD';
s.mtow = 1000;
s.loop = 2.0;
s.mach = 0.1:0.1:2; % mach > 0
s.alt = 0.0;
s.aoa = 0.0;
s.stmach = 0.6;
s.tsmach = 1.4;
s.tr = 0.0;

s.sref = 6.0;
s.cbarr = 1.0;
s.blref = 6.0;
s.xcg = 0.25;
s.zcg = 0.0;
s.xw = 0.0;
s.zw = 0.0;

s.croot = 1.0;
s.ctip = 1.0;
s.semispan = s.blref/2;
s.expsemispan = s.semispan;
s.sweep = 40;
s.sweepx = 0;
s.twist = 0;
s.dihedral = 0;
s.type = 1.0;

s.airfoiltype = '4';
s.airfoilname = '0012';

s.caseid = ['CASEID ',s.name];

%% Digital Datcom execution and output retrieval
wing1 = callDatcom(s);
wing1.name = s.name;

% Change some parameters, execute again and store data
s.name = 'Thin supersonic';
s.airfoiltype = 'S';
s.airfoilname = '2-30.0-1.0';
s.caseid = ['CASEID ',s.name];
wing2 = callDatcom(s);
wing2.name = s.name;

%% Plot section
AR = s.blref^2/s.sref;
Lambda = s.sweep;
taper = s.ctip/s.croot;

figure
hold on

% Test plot
% scatter(wing1.mach,wing1.cla)
% scatter(wing2.mach,wing2.cla)

clearvars s appo lista
lista = whos;
c = 0;  % counter
for idx = 1:length(lista) % cycle over struct variables in the workspace
    if strcmp(lista(idx).class,'struct')
        c = c + 1;
        appo = eval(lista(idx).name);
        xx = linspace(appo.mach(1),appo.mach(end));
        yy = spline(appo.mach,appo.cla,xx);
        plot(xx,yy,'LineWidth',2)
        legendnames{c} = appo.name; %#ok<SAGROW>
    end
end

% theoretical curves
z1 = linspace(0,0.6);
z2 = linspace(1.2,max(appo.mach));
w1 = 2*pi./(1-z1.^2);    % Prandtl-Glauert
w2 = 4./(z2.^2-1);       % Ackeret
plot(z1,w1,'k')
plot(z2,w2,'k')
text(0.46,8,'$$ C_{L_\alpha} = \frac{2 \pi}{\sqrt{1-M^2}} \rightarrow $$',...
    'interpreter','latex','HorizontalAlignment','right')
text(1.22,8,'$$ \leftarrow C_{L_\alpha} = \frac{4}{\sqrt{M^2-1}} $$',...
    'interpreter','latex','HorizontalAlignment','left')

hold off
grid on
xlabel('Mach number')
ylabel('Lift curve slope, /rad')
title(['AR = ',num2str(AR),...
    '    \Lambda = ',num2str(Lambda),'°',...
    '    \lambda = ',num2str(taper,'%.1f')])
legend(legendnames,'interpreter','tex')

disp('END')