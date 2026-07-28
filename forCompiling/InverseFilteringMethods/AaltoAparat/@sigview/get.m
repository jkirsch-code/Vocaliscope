function val = get(c,prop)

switch prop
 otherwise
  val = get(c.viewable,prop);
end
