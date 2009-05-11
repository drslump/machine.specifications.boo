namespace Machine.Specifications.Boo.Specs

import System
import Machine.Specifications.Boo
import Boo.Lang.Compiler
import Boo.Lang.Compiler.Ast

public class TestModuleHandler(ModuleHandler):
  public def constructor():
    pass

  public override def GetModuleFromNode(node as Node) as Module:
    return Module()