namespace Machine.Specifications.Boo.Specs

import Machine.Specifications.Boo

/*
# If reference given translate to typeof(Boo), if string use it, slicing sets tags
subject 'Account' [foo]:

  # Tags can be defined via attribute or by using hashtags in the string
  when 'I call a method' [bar]:

    establish:  # context:
      foo = 10

    it 'should return the argument given':
      foo.ShouldEqual(10)
      print foo

    foo as int

  when 'I call a prop':
    foo as int = 20

    # context:
    #   foo = 20

    it 'should return 20': foo.ShouldEqual(20)

*/


when a_context_has_a_base_contexts_name_as_the_second_argument, InheritanceSpecs:
  establish:
    bar = 20

  because_of:
    foo = bar
    
  it "set the context's base class as being the base context":
    GetFoo().ShouldEqual(20)

  bar as int

class InheritanceSpecs:
  foo as int

  def GetFoo():
    return foo




