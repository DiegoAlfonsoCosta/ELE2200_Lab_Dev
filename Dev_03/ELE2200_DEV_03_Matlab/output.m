%% export

% ========= Export MATLAB variables to LaTeX =========

projectRoot = pwd;  % current working directory
latexDir = fullfile(projectRoot, '..', 'ELE2200_DEV_03_Latex');

if ~exist(latexDir, "dir")
    mkdir(latexDir);
end


% Tex file writing


format= '%.3g';

filename = fullfile(latexDir,'output.tex');
fid = fopen(filename,'w');

vars = whos;                  % list all workspace variables

exclude = { ...
    'ans','fid','i','j','k','idx','index','tmp', 'value','L','dh','num', ...
    'u'
};

for k = 1:numel(vars)



    class = vars(k).class;
    size = vars(k).size;
    name = vars(k).name  % Get the variable name
    value = eval(name);    % Evaluate the variable to get its value
    
    if ismember(name, exclude)
        continue
    end

    % --- safe command name ---
    latexName = regexprep(name,'[^A-Za-z0-9]','');
    
    % replace digits with words
    latexName = strrep(latexName,'0','Zero');
    latexName = strrep(latexName,'1','One');
    latexName = strrep(latexName,'2','Two');
    latexName = strrep(latexName,'3','Three');
    latexName = strrep(latexName,'4','Four');
    latexName = strrep(latexName,'5','Five');
    latexName = strrep(latexName,'6','Six');
    latexName = strrep(latexName,'7','Seven');
    latexName = strrep(latexName,'8','Eight');
    latexName = strrep(latexName,'9','Nine');

    % -------------------------
    % NUMERIC SCALARS
    % -------------------------
    if strcmp(class,'double') && isequal(size,[1 1])

        fprintf(fid,'\\newcommand*{\\%s}{%s}\n', ...
            latexName, num2str(value,format));
    end
    % -------------------------
    % SYMBOLIC EXPRESSIONS
    % -------------------------
    if strcmp(vars(k).class,'sym')
    
        name  = vars(k).name;
        value = eval(name);
    
        latexExpr = latex(value);
    
        % --- clean matrix style ---
        latexExpr = strrep(latexExpr,'\left(\begin{array}','\begin{bmatrix}');
        latexExpr = regexprep(latexExpr,'\\begin{bmatrix}\{[clr]+\}','\\begin{bmatrix}');
        latexExpr = strrep(latexExpr,'\end{array}\right)','\end{bmatrix}');
    
        % --- optional cleanups ---
        latexExpr = strrep(latexExpr,'\mathrm{kf}','k_f');
    

        latexName
    
        % --- detect if matrix ---
        if contains(latexExpr,'bmatrix') || contains(latexExpr,'array')
    
            % matrix → NO math mode wrapper
            fprintf(fid,'\\newcommand{\\%s}{%s}\n', latexName, latexExpr);
    
        else
    
            % scalar / equation → wrap in math mode
            % fprintf(fid,'\\newcommand{\\%s}{$%s$}\n', latexName, latexExpr);
            fprintf(fid,'\\newcommand{\\%s}{%s}\n', latexName, latexExpr);

    
        end
    
    end
   
end

fclose(fid);