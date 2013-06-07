namespace Machine.Specifications.Boo.Specs

import Machine.Specifications.Boo from "Machine.Specifications.Boo"

NUnitCompat

when "normalizing a name with spaces":
  input as string
  establish: input = "foo  bar\tbaz\nqux"
  because:   input = sanitize_text(input)
  it "should replace all spaces with an underscore":
    input.ShouldEqual("foo_bar_baz_qux")

when "normalizing a name with tildes":
  input as string
  establish: input = "Iván Barça Niño"
  because:   input = sanitize_text(input)
  it "should convert to ascii tildes":
    input.ShouldEqual('Ivan_Barca_Nino')

when "normalizing a name with unicode chars":
  input as string
  establish: input = "euro €"
  because:   input = sanitize_text(input)
  it "should remove them": 
    input.ShouldEqual('euro')

when "normalizing a name with non valid identifier chars":
  input as string
  establish: input = "dolar $ hyphen - percent %"
  because:   input = sanitize_text(input)
  it "should remove them": 
    input.ShouldEqual('dolar_hyphen_percent')
