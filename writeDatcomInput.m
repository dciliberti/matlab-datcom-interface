function writeDatcomInput(s)

disp('Writing DATCOM input file...')

% Namelists pre-process
varindent = '         ';    % 9 spaces

% Intro
declar1 = 'DIM %s\n';     % M or FT
declar2 = 'DERIV %s\n\n';   % DEG or RAD

% Flight Conditions
fconopen = ' $FLTCON WT=%.1f, LOOP=%.1f,\n';
nmach = [varindent,'NMACH=%.1f,\n'];
mach1 = ['MACH(1)=',num2str(s.mach,'%.1f, ')];
mach1 = dcmArraySplit(mach1,varindent); % split char array within FORTRAN limit
nalt = [varindent,'NALT=%.1f,\n'];
altitude1 = ['ALT(1)=',num2str(s.alt,'%.1f, ')];
altitude1 = dcmArraySplit(altitude1,varindent); % split char array within FORTRAN limit
nalpha = [varindent,'NALPHA=%.2f,\n'];
alpha1 = ['ALSCHD(1)=',num2str(s.aoa,'%.2f, ')];
alpha1 = dcmArraySplit(alpha1,varindent); % split char array within FORTRAN limit
fconclose = [varindent,'STMACH=%.2f, TSMACH=%.2f, TR=%.2f$\n\n'];

% Reference Values
optins = ' $OPTINS SREF=%.2f, CBARR=%.2f, BLREF=%.2f$\n\n';
synths = ' $SYNTHS XCG=%.2f, ZCG=%.2f, XW=%.2f, ZW=%.2f$\n\n';

% Wing Planform
wingopen = ' $WGPLNF CHRDR=%.2f, CHRDTP=%.2f,\n';
halfspan = [varindent,'SSPN=%.2f, SSPNE=%.2f,\n'];
sweeptwist = [varindent,'SAVSI=%.2f, CHSTAT=%.2f, TWISTA=%.1f,\n'];
wingclose = [varindent,'DHDADI=%.2f, TYPE=%.2f$\n\n'];

% Airfoil
wingprof = 'NACA W %s %s\n\n';

% Write Digital Datcom input file
fid = fopen([s.name,'.dcm'],'w');
fprintf(fid,'*\n');
fprintf(fid,'*   %s\n',s.name);
fprintf(fid,'*\n\n');
fprintf(fid,declar1,s.dim);
fprintf(fid,declar2,s.deriv);
fprintf(fid,fconopen,s.mtow,s.loop);

fprintf(fid,nmach,length(s.mach));
if iscell(mach1)
    for idx = 1:length(mach1)
        fprintf(fid,mach1{idx});
    end
else
    fprintf(fid,mach1);
end

fprintf(fid,nalt,length(s.alt));
if iscell(altitude1)
    for idx = 1:length(altitude1)
        fprintf(fid,altitude1{idx});
    end
else
    fprintf(fid,altitude1);
end

fprintf(fid,nalpha,length(s.aoa));
if iscell(alpha1)
    for idx = 1:length(alpha1)
        fprintf(fid,alpha1{idx});
    end
else
    fprintf(fid,alpha1);
end

fprintf(fid,fconclose,s.stmach,s.tsmach,s.tr);
fprintf(fid,optins,s.sref,s.cbarr,s.blref);
fprintf(fid,synths,s.xcg,s.zcg,s.xw,s.zw);
fprintf(fid,wingopen,s.croot,s.ctip);
fprintf(fid,halfspan,s.semispan,s.expsemispan);
fprintf(fid,sweeptwist,s.sweep,s.sweepx,s.twist);
fprintf(fid,wingclose,s.dihedral,s.type);
fprintf(fid,wingprof,s.airfoiltype,s.airfoilname);
fprintf(fid,s.caseid);
fclose(fid);

disp(['DATCOM input file written into: ', s.name,'.dcm'])




function splitArray = dcmArraySplit(myArray,varindent)
% Split char array within FORTRAN limit

chunk = 72-length(varindent); % original indentation
rows = ceil((length(myArray)+length(varindent))/chunk);
if rows > 1
    c = 1;
    for i = 1:rows-1
        chunk = 72-length(varindent); % restore original indentation
        
        % change index where to split array if last char is not a delimiter
        while ~strcmp(myArray(c+chunk),',') && ~strcmp(myArray(c+chunk),' ')
            chunk = chunk - 1;
        end
        
        splitArray{i} = myArray(c:c+chunk-1);
        c = c + chunk;
    end
    splitArray{i+1} = myArray(c:end);
    
    % Concatenate char arrays to include initial indentation
    for i = 1:rows
        splitArray{i} = [varindent, splitArray{i},'\n'];
    end
    
else
    splitArray = [varindent,myArray,'\n'];
end

end

end