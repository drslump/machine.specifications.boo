namespace Machine.Specifications.Boo

import Boo.Lang.Compiler.Ast
import Boo.Lang.Compiler.TypeSystem


macro when:
    if len(when.Arguments) < 1 or len(when.Arguments) > 2:
        raise "Only one or two arguments are allowed to a when/context block.. ex: 'when foo, bar' or 'when \"foo\"'" 
    if len(when.Arguments) > 1 and not when.Arguments[1] isa ReferenceExpression:
        raise "Only a safe identifier name is valid as the second argument to a when block. ex: 'when \"foo\", bar' or 'when foo, bar'"

    title = when.Arguments[0]
    
    # TODO: This breaks if the macro body contains attributes
    classDef = [|
        class CLS:
            $(when.Body)
    |]

    # Apply tags
    if se = title as SlicingExpression:
        tags = Attribute(when.LexicalInfo)
        tags.Name = 'Machine.Specifications.TagsAttribute'
        for idx in se.Indices:
            tags.Arguments.Add(
                StringLiteralExpression(Value: idx.Begin.ToCodeString())
            )
        classDef.Attributes.Add(tags)
        title = se.Target 

    if title.NodeType not in (NodeType.ReferenceExpression, NodeType.StringLiteralExpression):
        raise "Only a string or safe identifier name is allowed for names of 'when/context' blocks.. ex: 'when \"foo\"' or 'when foo'"

    # Configure based on the title
    name = title.ToCodeString()
    classDef.Name = sanitize_text(name)
    if not classDef.Name.StartsWith('when_'):
        classDef.Name = 'when_' + classDef.Name
    classDef.LexicalInfo = when.LexicalInfo
  
    if len(when.Arguments) > 1:
        classDef.BaseTypes.Add([| typeof($(when.Arguments[1])) |].Type)

    # Any field which is not part of the DSL should be static and protected
    fields = [f for f in classDef.Members if f.NodeType == NodeType.Field]
    for field as Field in fields:
        if tr = field.Type as SimpleTypeReference:
            continue if tr.Name.StartsWith('Machine.Specifications.')
        field.Modifiers |= TypeMemberModifiers.Static | TypeMemberModifiers.Protected

    # Make sure MSpec is referenced
    asm = Parameters.FindAssembly('Machine.Specifications')
    if not asm:
        asm = Parameters.LoadAssembly('Machine.Specifications', false)
        if asm:
            Parameters.References.Add(asm)
        else:
            raise 'Machine.Specifications assembly not found'

    # We need to explicitly import the namespace for extension ShouldX methods to work
    mod = when.GetAncestor[of Module]()
    if not mod.Imports.Contains({ _ as Import | _.Namespace == 'Machine.Specifications' }):
        imp = Import()

        # Work around Boo compiler changes to the AST model (>0.9.6 uses an expression)
        if imp.GetType().GetProperty('Expression'):
            (imp as duck).Expression = ReferenceExpression('Machine.Specifications')
        else:
            (imp as duck).Namespace = 'Machine.Specifications'

        imp.Entity = NameResolutionService.ResolveQualifiedName('Machine.Specifications')
        ImportAnnotations.MarkAsUsed(imp)
        mod.Imports.Add(imp)

    yield classDef
