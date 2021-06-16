/**
 * @kind path-problem
 */

import csharp
import semmle.code.csharp.dataflow.ExternalFlow
import DataFlow::PathGraph
import CsvValidation

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "My.Qltest;D;false;StepArgRes;(System.Object);;Argument[0];ReturnValue;taint",
        "My.Qltest;D;false;StepArgArg;(System.Object,System.Object);;Argument[0];Argument[1];taint",
        "My.Qltest;D;false;StepArgQual;(System.Object);;Argument[0];Argument[-1];taint",
        "My.Qltest;D;false;StepFieldGetter;();;Field[My.Qltest.D.Field] of Argument[-1];ReturnValue;value",
        "My.Qltest;D;false;StepFieldSetter;(System.Object);;Argument[0];Field[My.Qltest.D.Field] of Argument[-1];value",
        "My.Qltest;D;false;StepPropertyGetter;();;Property[My.Qltest.D.Property] of Argument[-1];ReturnValue;value",
        "My.Qltest;D;false;StepPropertySetter;(System.Object);;Argument[0];Property[My.Qltest.D.Property] of Argument[-1];value",
        "My.Qltest;D;false;StepElementGetter;();;Element of Argument[-1];ReturnValue;value",
        "My.Qltest;D;false;StepElementSetter;(System.Object);;Argument[0];Element of Argument[-1];value",
        "My.Qltest;D;false;Apply;(System.Func<My.Qltest.D.Apply.<0>,My.Qltest.D.Apply.<1>>,My.Qltest.D.Apply.<1>);;Argument[1];Parameter[0] of Argument[0];value",
        "My.Qltest;D;false;Apply;(System.Func<My.Qltest.D.Apply.<0>,My.Qltest.D.Apply.<1>>,My.Qltest.D.Apply.<1>);;ReturnValue of Argument[0];ReturnValue;value",
        "My.Qltest;D;false;Map;(My.Qltest.D.Map.<0>[],System.Func<My.Qltest.D.Map.<0>,My.Qltest.D.Map.<1>>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "My.Qltest;D;false;Map;(My.Qltest.D.Map.<0>[],System.Func<My.Qltest.D.Map.<0>,My.Qltest.D.Map.<1>>);;ReturnValue of Argument[1];Element of ReturnValue;value"
      ]
  }
}

class Conf extends TaintTracking::Configuration {
  Conf() { this = "ExternalFlow" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ObjectCreation }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
