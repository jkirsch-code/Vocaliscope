function pathsOut=fileListApp()
% FILELISTAPP  Small UIFigure-based interface to collect .mat file paths.

fig = uifigure("Name","File List",'Theme','light','Units','normalized','OuterPosition',[0.1 0.2 0.8 0.6]);

%fig.Position(3:4) = [700 400];

% Layout: two rows: table area and buttons row
gl = uigridlayout(fig, [4,6]);
gl.RowHeight = {'1x', 'fit','fit','fit'};   
gl.Padding = [10 10 10 10];
gl.RowSpacing = 10;

% Table container (gives a fixed area so table shows scrollbars when data large)
tblPanel = uipanel(gl,"BorderType","none",'Title',[]);
tblPanel.Layout.Row = 1;
tblPanel.Layout.Column = [1 6];

drawnow;

% Create the uitable inside panel
uit = uitable(tblPanel, ...
    "ColumnName",{"file path","file name"}, ...
    "ColumnEditable",false, ...
    "ColumnSortable",true, ...
    "MultiSelect","on", ...        % allow multiple row selection
    'Units','normalized',...
    "Position",[0 0 1 1],...
    "SelectionType","row");


filterTextEditField = uieditfield(gl,'Placeholder','type here to filter the displayed rows','ValueChangingFcn',@filterDisplayedTable);
filterTextEditField.Layout.Row=2;
filterTextEditField.Layout.Column=[1 6];

displayedEntriesLabel=uilabel(gl,'Text',sprintf('showing 0 of 0 entries'));
displayedEntriesLabel.Layout.Row=3;
displayedEntriesLabel.Layout.Column=[1 6];


btnAdd = uibutton(gl, "Text","add files", "ButtonPushedFcn", @(~,~)onAdd(0),'WordWrap','on');
btnAddAllInFolder = uibutton(gl, "Text","add files in folder", "ButtonPushedFcn", @(~,~)onAdd(1),'WordWrap','on');
btnAddAllInFolderAndAllSubfolders = uibutton(gl, "Text","add files in folder and all subfolders", "ButtonPushedFcn", @(~,~)onAdd(2),'WordWrap','on');
btnSelectAll = uibutton(gl, "Text","select all entries", "ButtonPushedFcn", @(~,~) selectAllFcn,'WordWrap','on');
btnDelete = uibutton(gl, "Text","delete selected entries", "ButtonPushedFcn", @(~,~)onDelete(),'WordWrap','on','BackgroundColor',[1 0.58 0.19]);
btnProcess = uibutton(gl, "Text","process listed files and continue to parameter selection", "ButtonPushedFcn", @(~,~)onProcess(),'WordWrap','on','BackgroundColor',[0 0.7 0]);

% set the layout row to 3 for all buttons
btnAdd.Layout.Row=4;
btnAddAllInFolder.Layout.Row=4;
btnAddAllInFolderAndAllSubfolders.Layout.Row=4;
btnSelectAll.Layout.Row=4;
btnDelete.Layout.Row=4;
btnProcess.Layout.Row=4;


% Store data in app-like struct
data.store = cell(0,2);    % cell array of full paths
data.uit = uit;
data.fig = fig;
guidata(fig, data);

% Ensure table initially empty and sorted
updateTable();

drawnow;


uiwait(fig);
%waitfor(fig.UserData,'filepaths');

if isvalid(fig)
    pathsOut=fig.UserData.filepaths;
    close(fig);
else
    pathsOut=[];
end



%% Nested/callback functions



    function onAdd(addUsingDirectory)
        % Allow selecting multiple .mat files only

        persistent lastFolder

        fakefig=uifigure('Units','pixels','Position',[-1000 -1000 1 1]);
        drawnow;

        if addUsingDirectory==0
            [files, folder] = uigetfile("*.mat", "Select .mat files",lastFolder, "MultiSelect", "on");
            
            if isequal(files,0)
                delete(fakefig);
                return
            end
            if ischar(files)
                files = {files};
            end
    
            fullPaths = fullfile(folder, files);
        else
            [folder] = uigetdir(lastFolder, "Select folder containing .mat files");
            if isequal(folder,0)
                delete(fakefig);
                return
            end
            if addUsingDirectory==1
                filesStruct=dir([folder filesep '*.mat']);
            else
                filesStruct=SUBDIR.subdir([folder filesep '*.mat']);
            end
            fullPaths = fullfile({filesStruct.folder},{filesStruct.name});

            % if no files found, display an uialert and stop using return
            if isempty(fullPaths)
                uialert(fig, "No .mat files found in the selected folder.", "Warning");
                return;
            end
        end

        drawnow;
        delete(fakefig);

        figure(fig);

        lastFolder=folder;

        % Normalize files to cell array
        
        d = guidata(fig);
        % combine, make unique, sort alphabetically

        [~,filenamesOnly]=fileparts(fullPaths);

        if ~isempty(d.store)
            combined = [d.store; fullPaths(:) filenamesOnly(:)];
        else
            combined = [fullPaths(:) filenamesOnly(:)];
        end

        [~,idx]=unique(combined(:,1));
        combined = combined(idx, :);  % Keep only unique entries
        
        
        d.store = combined;
        guidata(fig, d);
        updateTable();
    end

    function selectAllFcn
        if ~isempty(uit.Data)
            uit.Selection=1:size(uit.Data,1);
        end
    end

    function onDelete()
        d = guidata(fig);
        selection = d.uit.Selection;  % n-by-2 array [row col]
        if isempty(selection)
            return
        end
        
        
        d.store(ismember(d.store(:,1),d.uit.Data(selection,1)),:)=[];

        if isequal(selection,1:size(d.uit.Data,1))
            filterTextEditField.Value='';
        end


        guidata(fig, d);
        updateTable();
    end

    function onProcess()
        d = guidata(fig);
        % Placeholder: replace with actual processing code
        if isempty(d.store)
            uialert(d.fig, "No files to process.", "Info");
            return
        end
        
        fig.UserData.filepaths=d.store;

        uiresume(fig);


    end

    function updateTable()
        d = guidata(fig);
        if isempty(d.store)
            d.uit.Data = cell(0,1);
        else
            % Ensure unique + sorted (defensive)
            % d.store = unique(d.store,'rows');
            % d.store = sortrows(d.store,1);
            d.uit.Data = d.store;
        end
        % Make sure selection cleared after update
        d.uit.Selection = [];
        guidata(fig, d);

        tmp.Value=filterTextEditField.Value;
        filterDisplayedTable([],tmp);
    end

    function filterDisplayedTable(src,evt)
        % remove row from displayed table when the string does not match in
        % any of the row entries

        filtertext=evt.Value;

        d = guidata(fig);
        if isempty(d.store)
            d.uit.Data = cell(0,2);
            return;            
        end

        if ~isempty(filtertext) && ~strcmp(filtertext(1),'~')

            if numel(filtertext)>1 && filtertext(1)=='~'
                filtertext(1)=[];
                doNot=1;
            else
                doNot=0;
            end

            % i want that * can be used as wildcard in regexpi
            rowsToShow=any(~cellfun(@isempty,regexpi(d.store,replace(filtertext,'*','.*'),'once')),2);

            if doNot
                rowsToShow=~rowsToShow;
            end
        else
            rowsToShow=true(size(d.store,1),1);
        end
        
        
        d.uit.Data=d.store(rowsToShow,:);

        displayedEntriesLabel.Text=sprintf('showing %i of %i entries',sum(rowsToShow),size(d.store,1));


    end

end
