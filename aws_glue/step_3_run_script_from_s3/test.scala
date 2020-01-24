import com.amazonaws.services.glue.ChoiceOption
import com.amazonaws.services.glue.GlueContext
import com.amazonaws.services.glue.MappingSpec
import com.amazonaws.services.glue.ResolveSpec
import com.amazonaws.services.glue.errors.CallSite
import com.amazonaws.services.glue.util.GlueArgParser
import com.amazonaws.services.glue.util.Job
import com.amazonaws.services.glue.util.JsonOptions
import org.apache.spark.SparkContext
import scala.collection.JavaConverters._

object GlueApp {
  def main(sysArgs: Array[String]) {
    val spark: SparkContext = new SparkContext()
    val glueContext: GlueContext = new GlueContext(spark)
    // @params: [JOB_NAME]
    val args = GlueArgParser.getResolvedOptions(sysArgs, Seq("JOB_NAME").toArray)
    Job.init(args("JOB_NAME"), glueContext, args.asJava)
    // @type: DataSource
    // @args: [database = "test-database2", table_name = "test-table2", transformation_ctx = "datasource0"]
    // @return: datasource0
    // @inputs: []
    val datasource0 = glueContext.getCatalogSource(database = "test-database2", tableName = "test-table2", redshiftTmpDir = "", transformationContext = "datasource0").getDynamicFrame()
    // @type: ApplyMapping
    // @args: [mapping = [("id", "short", "id", "short"), ("name", "string", "name", "string")], transformation_ctx = "applymapping1"]
    // @return: applymapping1
    // @inputs: [frame = datasource0]
    val applymapping1 = datasource0.applyMapping(mappings = Seq(("id", "short", "id", "short"), ("name", "string", "name", "string")), caseSensitive = false, transformationContext = "applymapping1")
    // @type: SelectFields
    // @args: [paths = ["id", "name"], transformation_ctx = "selectfields2"]
    // @return: selectfields2
    // @inputs: [frame = applymapping1]
    val selectfields2 = applymapping1.selectFields(paths = Seq("id", "name"), transformationContext = "selectfields2")
    // @type: ResolveChoice
    // @args: [choice = "MATCH_CATALOG", database = "test-database2", table_name = "test-table2", transformation_ctx = "resolvechoice3"]
    // @return: resolvechoice3
    // @inputs: [frame = selectfields2]
    val resolvechoice3 = selectfields2.resolveChoice(choiceOption = Some(ChoiceOption("MATCH_CATALOG")), database = Some("test-database2"), tableName = Some("test-table2"), transformationContext = "resolvechoice3")
    // @type: DataSink
    // @args: [database = "test-database2", table_name = "test-table2", transformation_ctx = "datasink4"]
    // @return: datasink4
    // @inputs: [frame = resolvechoice3]
    val datasink4 = glueContext.getCatalogSink(database = "test-database2", tableName = "test-table2", redshiftTmpDir = "", transformationContext = "datasink4").writeDynamicFrame(resolvechoice3)
    Job.commit()
  }
}