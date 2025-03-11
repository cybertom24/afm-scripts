function Hmap = load_height_map(filename)
    % Loads the height map exported by AIST-NT software.
    % ----
    % Arguments:
    % filename = name of the file which contains the curve to load 
    %
    % Returns:
    % Hmap = matrix containing the z coordinate for every point
    
    %{
    % Open the file in order to read from it
    fid = fopen(filename, 'r');

    % Read and discard the first line (which contains 
    fgetl(fid);

    % Read the file as numbers and place them in a vector
    data = fscanf(fid, '%f');

    % Close the file
    fclose(fid);

    % Create a 2 column matrix
    data = reshape(data, 2, []).';
    %}

    % Ignore the first 11 lines

    % Create a temp file
    tempFile = 'tempfile.tsv';
    fid_temp = fopen(tempFile, 'w');

    fid = fopen(filename, 'r');
    % Assure that it is not empty
    if feof(fid)
        return
    end

    % Read the first lines without saving it
    for i = 1:11
        fgetl(fid);
    end

    % Now read the rest and save it to the temp file
    while ~feof(fid)
        line = fgetl(fid);
        if ischar(line)
            fprintf(fid_temp, '%s\n', line);
        end
    end

    % Close the files
    fclose(fid_temp);
    fclose(fid);

    % Load the temp file (which now contains only the data
    % we want to read)
    heigth_data = load(tempFile);
    heigth_data_x = heigth_data(:, 1);
    heigth_data_y = heigth_data(:, 2);
    heigth_data_z = heigth_data(:, 3);

    l = round( sqrt(length(heigth_data_z)) );
    Hmap = zeros([l l]);

    for i = 1:1:length(heigth_data_x)
        x = heigth_data_x(i) + 1;
        y = heigth_data_y(i) + 1;
        z = heigth_data_z(i);
        Hmap(y, x) = z;
    end
end