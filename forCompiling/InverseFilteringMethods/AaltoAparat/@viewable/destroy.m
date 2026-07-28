function destroy(c)

if c.fig ~= 0
  delete(c.fig);
end

detach(deref(c.model),c.this);

free(c.this);

