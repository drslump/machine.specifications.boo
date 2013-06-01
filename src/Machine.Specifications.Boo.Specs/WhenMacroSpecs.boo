namespace Machine.Specifications.Boo.Specs

import Machine.Specifications.Boo


when a_context_has_a_reference_identifier_for_its_name:

  it "should use the provided identifier with the word when prepended as the class' name":
    self.GetType().Name.ShouldEqual('when_a_context_has_a_reference_identifier_for_its_name')
  

when "a context has a string for it's name":

  it "should convert the string to a boxcar reference identifier":
    self.GetType().Name.ShouldEqual('when_a_context_has_a_string_for_its_name')
  

when "when a context's name starts with the word 'when'":

  it "should not attempt to prepend 'when' and an underscore to the context's name":
    self.GetType().Name.ShouldEqual('when_a_contexts_name_starts_with_the_word_when')

when "context setup is not wrapped in a context macro":

  a = 10
  b = 20

  it "should initialize variables":
  	a.ShouldEqual(10)