namespace Machine.Specifications.Boo

import Boo.Lang.Compiler.Ast
import Boo.Lang.Compiler.TypeSystem
import Boo.Lang.PatternMatching
import Boo.Lang.Compiler


macro when:
    if len(when.Arguments) < 1 or len(when.Arguments) > 2:
        raise "Only one or two arguments are allowed to a when/context block.. ex: 'when foo, bar' or 'when \"foo\"'" 
    if len(when.Arguments) > 1 and not when.Arguments[1] isa ReferenceExpression:
        raise "Only a safe identifier name is valid as the second argument to a when block. ex: 'when \"foo\", bar' or 'when foo, bar'"

    title = when.Arguments[0]
    
    # TODO: This breaks if the macro body contains attributes
    # classDef = [|
    #     class CLS:
    #         pass #$(when.Body)
    # |]

    cls = ClassDefinition(when.LexicalInfo)

    def process(statements as StatementCollection):
        for st in statements:
            match st:
                case ExpressionStatement(Expression: be=BinaryExpression(
                    Operator: BinaryOperatorType.Assign,
                    Left: re=ReferenceExpression()
                )):
                    f = Field(be.LexicalInfo, Name: re.Name, Initializer: be.Right)
                    cls.Members.Add(f)
                
                case dst=DeclarationStatement(Declaration: dc=Declaration()):
                    f = Field(dc.LexicalInfo, Name: dc.Name, Type: dc.Type, Initializer: dst.Initializer)
                    cls.Members.Add(f)

                case tm=TypeMember():
                    cls.Members.Add(tm)
                case TypeMemberStatement(TypeMember: tm=TypeMember()):
                    cls.Members.Add(tm)

                case blk=Block():
                    process(blk.Statements)

                otherwise:
                    print 'ERROR', st.NodeType, st

    process(when.Body.Statements)

    # Apply tags
    if se = title as SlicingExpression:
        tags = Attribute(when.LexicalInfo)
        tags.Name = 'Machine.Specifications.TagsAttribute'
        for idx in se.Indices:
            tags.Arguments.Add(
                StringLiteralExpression(Value: idx.Begin.ToCodeString())
            )
        cls.Attributes.Add(tags)
        title = se.Target 

    if title.NodeType not in (NodeType.ReferenceExpression, NodeType.StringLiteralExpression):
        raise "Only a string or safe identifier name is allowed for names of 'when/context' blocks.. ex: 'when \"foo\"' or 'when foo'"

    # Normalize the title
    name = title.ToCodeString()
    cls.Name = sanitize_text(name)
    if not cls.Name.StartsWith('when_'):
        cls.Name = 'when_' + cls.Name
    cls.LexicalInfo = when.LexicalInfo
  
    if len(when.Arguments) > 1:
        cls.BaseTypes.Add([| typeof($(when.Arguments[1])) |].Type)

    # Any field which is not part of the DSL should be static and protected
    fields = [f for f in cls.Members if f.NodeType == NodeType.Field]
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

    if mod['NUnitCompat'] or Parameters.Defines.ContainsKey('NUnitCompat'):
        # Make sure we can find the NUnit reference
        imp = Import()
        imp.Expression = ReferenceExpression('NUnit.Framework')
        imp.Entity = NameResolutionService.ResolveQualifiedName('NUnit.Framework')
        imp.AssemblyReference = ReferenceExpression('NUnit.Framework')
        ImportAnnotations.MarkAsUsed(imp)
        mod.Imports.Add(imp)

        nunit = Attribute(when.LexicalInfo)
        nunit.Name = 'TestFixtureAttribute'
        cls.Attributes.Add(nunit)

        def typename(member as TypeMember):
            field = member as Field
            if field and field.Type isa SimpleTypeReference:
                return (field.Type as SimpleTypeReference).Name
            return null

        method = [|
            [TestFixtureSetUp]
            def Establish_and_Because():
                pass
        |]
        cls.Members.Add(method)

        members = [m for m in cls.Members if typename(m) == 'Machine.Specifications.Establish']
        for member as TypeMember in members:
            method.Body.Statements.Add(ExpressionStatement([| self.$(member.Name)() |]))
        members = [m for m in cls.Members if typename(m) == 'Machine.Specifications.Because']
        for member as TypeMember in members:
            method.Body.Statements.Add(ExpressionStatement([| self.$(member.Name)() |]))

        method = [|
            [NUnit.Framework.TestFixtureTearDownAttribute]
            def Cleanup():
                pass
        |]
        members = [m for m in cls.Members if typename(m) == 'Machine.Specifications.Cleanup']
        for member as TypeMember in members:
            method.Body.Statements.Add(ExpressionStatement([| self.$(member.Name)() |]))

        members = [m for m in cls.Members if typename(m) == 'Machine.Specifications.It']
        for member as TypeMember in members:
            method = [|
                [Test]
                def $('it_' + member.Name)():
                    self.$(member.Name)()
            |]
            cls.Members.Add(method)

        # print cls.ToCodeString()

    yield cls
