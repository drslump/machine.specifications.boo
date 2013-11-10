namespace Machine.Specifications.Boo

import Boo.Lang.Compiler.Ast


// TODO: Convert this to an assembly/module attribute
macro NUnitCompat:
    if not len(NUnitCompat.Arguments):
        arg = BoolLiteralExpression(true)
    else:
        arg = NUnitCompat.Arguments[0] as BoolLiteralExpression

    if not arg:
        raise 'Usage: NUnitCompat true|false'

    mod = NUnitCompat.GetAncestor[of Module]()
    mod['NUnitCompat'] = true