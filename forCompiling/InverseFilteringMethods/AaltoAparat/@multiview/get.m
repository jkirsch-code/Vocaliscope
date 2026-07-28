function val = get(c,prop)

switch prop
 case 'parname'
  val = c.parname;
 otherwise
  val = get(c.viewable,prop);
end
