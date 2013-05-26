namespace Machine.Specifications.Boo

import Boo.Lang.Compiler.Ast


macro it:
    title = it.Arguments[0]
    if title.NodeType not in (NodeType.ReferenceExpression, NodeType.StringLiteralExpression):
        raise "Only a string or an identifier name is allowed... ex: 'it \"foo\"' or 'it foo'"

    field = field_factory('FIELD', 'Machine.Specifications.It', it.Body)
    name = title.ToCodeString()
    field.Name = sanitize_text(name)
    field.LexicalInfo = it.LexicalInfo

    yield field
