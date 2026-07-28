function val = get(c,prop)

switch prop
 case 'this'
  val = c.this;
 otherwise
  error(['"' prop '" is not a valid property name']);
end
