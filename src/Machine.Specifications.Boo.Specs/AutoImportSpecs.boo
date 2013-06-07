namespace Foo

import Machine.Specifications.Boo

NUnitCompat true


when "having imported MSpec.Boo and defining a when block":

  it "should auto-import the mspec should extension":
    10.ShouldEqual(10)
    "foo".ShouldEqual('foo')
  
