namespace Machine.Specifications.Boo.Specs

import Machine.Specifications
import Machine.Specifications.Boo


# subject System.IO.File:
#     when a_subject_with_a_reference_as_param:
#         context:
#             attrs = GetType().GetCustomAttributes(SubjectAttribute, false)

#         it "should have a subject attribute set":
#             len(attrs).ShouldEqual(1)

#         attrs as (object)

#     when a_second_when_inside_a_subject:
#         context:
#             attrs = GetType().GetCustomAttributes(SubjectAttribute, false)

#         it "should have a subject attribute set":
#             len(attrs).ShouldEqual(1)

#         attrs as (object)


# subject "Description is a string":
#     when a_subject_is_defined_with_a_string:
#         it "should have a subject attribute":
#             attrs = GetType().GetCustomAttributes(SubjectAttribute, false)
#             len(attrs).ShouldEqual(1)

