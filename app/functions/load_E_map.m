function data = load_E_map(filepath)
    % Ignore the first line

    % Create a temp file
    tempFile = 'tempfile.tsv';
    fid_temp = fopen(tempFile, 'w');

    fid = fopen(filepath, 'r');
    % Assure that it is not empty
    if feof(fid)
        return
    end

    % Read the first line without saving it
    fgetl(fid);

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
    data = load(tempFile);
end

