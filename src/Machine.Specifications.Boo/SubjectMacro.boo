namespace Machine.Specifications.Boo

import Boo.Lang.Compiler.Ast


macro subject(expr as Expression):

    attrs = AttributeCollection()

    attr = Attribute(subject.LexicalInfo)
    attr.Name = 'Machine.Specifications.SubjectAttribute'
    attrs.Add(attr)

    # Apply tags
    if se = expr as SlicingExpression:
        tags = Attribute(subject.LexicalInfo)
        tags.Name = 'Machine.Specifications.TagsAttribute'
        for idx in se.Indices:
            tags.Arguments.Add(
                StringLiteralExpression(Value: idx.Begin.ToCodeString())
            )
        attrs.Add(tags)
        expr = se.Target

    if expr.NodeType in (ReferenceExpression, MemberReferenceExpression):
        tof = TypeofExpression()
        tof.Type = SimpleTypeReference(Name: expr.ToCodeString())
        attr.Arguments.Add(tof)
    else:
        attr.Arguments.Add(StringLiteralExpression(Value: expr.ToCodeString()))

    for st in subject.Body.Statements:
        if tms = st as TypeMemberStatement:
            for attr in attrs:
                tms.TypeMember.Attributes.Add(attr)
            yield tms
