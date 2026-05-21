function versionStr=getVersionFromMlapp(mlappFullPath)

tmpfolder=[tempdir 'getVersionTmp\'];
unzip(mlappFullPath,tmpfolder);

fileID = fopen(fullfile(tmpfolder,'metadata','coreProperties.xml'),"r");
out=textscan(fileID,'%s');
fclose(fileID);

rmdir(tmpfolder,"s");

out=out{1}(contains(out{1},'<cp:version>'));

versionCell=extractBetween(out{1},'<cp:version>','</cp:version>');

versionStr=versionCell{1};

end