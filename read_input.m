function [Xo, Yo, Zo, Uo, Vo, Wo] = read_input(input_filename, sat_id)
% READ_INPUT : Obtains file name, and the satellite id to output the
% initial conditions of each component. Also tests if there is a
% 'satellite_data.txt' file in the user's folder.
% call format:[Xo, Yo, Zo, Uo, Vo, Wo] = read_input(input_filename, sat_id)

data_input = importdata(input_filename,',',2);

row = find(data_input.data(:,1) == sat_id);
reader = ls;
if ~any(reader == 'satellite_data.txt')
    disp('Data not in file folder.')
    return
end

if isempty(row)
    Xo = NaN;
    Yo = NaN;
    Zo = NaN;
    Uo = NaN;
    Vo = NaN;
    Wo = Nan;
else
    Xo = data_input.data(row,2);
    Yo = data_input.data(row,3);
    Zo = data_input.data(row,4);
    Uo = data_input.data(row,5);
    Vo = data_input.data(row,6);
    Wo = data_input.data(row,7);
end

end % function importdata


