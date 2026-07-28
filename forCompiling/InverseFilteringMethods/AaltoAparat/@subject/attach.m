function c = attach(c,obshnd)

obs = obshnd;
c.observers{end+1} = obs;

store(c); % save myself after modifying the object
