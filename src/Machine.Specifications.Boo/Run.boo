namespace Machine.Specifications.Boo

import Machine.Specifications
import Machine.Specifications.Runner
import Machine.Specifications.Runner.Impl
import System.Reflection
import System


internal class SimpleConsoleListener(RunListenerBase):

    _passing as int = 0
    _specs as int = 0

    override def OnSpecificationEnd(spec as SpecificationInfo, result as Result):
        _specs++
        if result.Passed:
            _passing++
        else:
            preserving Console.ForegroundColor:
                Console.ForegroundColor = ConsoleColor.Red
                print ">>> FAIL: $(spec.ContainingType), $(spec.Leader) $(spec.Name) <<<"
            print result.Exception
            print ""

    override def OnRunEnd():
        preserving Console.ForegroundColor:
            if _passing == _specs:
                Console.ForegroundColor = ConsoleColor.Green
            else:
                Console.ForegroundColor = ConsoleColor.Yellow
            print "Passed $(_passing) / $(_specs) specs"

    override def OnFatalError(exception as ExceptionResult):
        print exception

    AllPassed:
        get: return _passing == _specs


def RunSpecs() as bool:
    return RunSpecs(Assembly.GetCallingAssembly())

def RunSpecs(asm as Assembly) as bool:
    listener = SimpleConsoleListener()
    runner = DefaultRunner(listener, RunOptions.Default)
    runner.RunAssembly(asm)

    return listener.AllPassed
