namespace Machine.Specifications.Boo.Specs

import Machine.Specifications
import Machine.Specifications.Boo


when a_context_is_reference_and_has_tags [foo, bar]:
  it "should have a tags attribute":
    attrs = GetType().GetCustomAttributes(TagsAttribute, false)
    len(attrs).ShouldEqual(1)

when 'a_context_is_string_and_has_tags' [foo, bar]:
  it "should have a tags attribute":
    attrs = GetType().GetCustomAttributes(TagsAttribute, false)
    len(attrs).ShouldEqual(1)

subject 'Subject with tags' [foo, bar]:
  when 'a subject has tags':
    it "should have a tags attribute":
      attrs = GetType().GetCustomAttributes(TagsAttribute, false)
      len(attrs).ShouldEqual(1)

  when 'a second when macro':
    it 'should have a tags attribute':
      attrs = GetType().GetCustomAttributes(TagsAttribute, false)
      len(attrs).ShouldEqual(1)
