function [Xo,Yo,Zo,Uo,Vo,Wo] = read_input1(input_filename,sat_id)
%READ_INPUT is meant to read the user's folder, see if the satellite data
%file is present, take in the preferred sat_id, and initialize variables
%for satellite trajectory input.
%  call format: [Xo,Yo,Zo,Uo,Vo,Wo] = read_input(input_filename,sat_id)



dat = readtable('satellite_data.txt');


fld_read = ls;
if ~any(fld_read == 'satellite_data.txt')
    disp('Data not in folder.')
    return
else
 
end

ol = intersect(dat{:,1},[sat_id]);
if isempty(ol)
    Xo=NaN;
    Yo=NaN;
    Zo=NaN;
    Uo=NaN;
    Vo=NaN;
    Zo=NaN;
    return
else 
    Xo=dat{sat_id,2} ;
    Yo=dat{sat_id,3};
    Zo=dat{sat_id,4};
    Uo=dat{sat_id,5};
    Vo=dat{sat_id,6};
    Wo=dat{sat_id,7};

end

end