function h = nexthandle(app)

objs = getappdata(app,'objects');
h = length(objs)+1;
