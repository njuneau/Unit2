package haxe.unit2.output;

import haxe.unit2.TestCase;
import haxe.unit2.TestRunner;
import haxe.unit2.TestStatus;

import StringTools;
import Date;
import Type;

/**
 * The text output writer will write a simple text representation of the
 * test runner's inner tests statuses.
 */
class TextOutputWriter implements OutputWriter {

    private static var H1_LINE : String = "================================================================================\r\n";
    private static var H2_LINE : String = "--------------------------------------------------------------------------------\r\n";
    private static var STATUS_OK : String = "[ OK ]";
    private static var STATUS_FAIL : String = "[ FAIL ]";
    private static var STATUS_DNR : String = "[ DID NOT RUN ]";

    private static var TOTAL : String = "Total";
    private static var TOTAL_SUCCEEDED : String = "Succeeded";
    private static var TOTAL_FAILED : String = "Failed";
    private static var TOTAL_DNR : String = "Did not run";

    /**
     * Default constructor
     */
    public function new() {}

    /**
     * This will write the results of the test runner's test cases in a simple
     * text representation
     */
    public function writeResults( testRunner : TestRunner ) : String {
        var output : StringBuf = new StringBuf();
        var total : Int = testRunner.getTests().length;
        var succeeded : Int = 0;
        var failed : Int = 0;
        var unfinished : Int = 0;

        // Build the header
        output.add("\r\n");
        output.add(H1_LINE);
        output.add("Test report - ");
        output.add(Date.now().toString());
        output.add("\r\n");

        // Loop through all the flags
        output.add(H2_LINE);

        var tests : Array<TestCase> = testRunner.getTests();
        var statuses : Array<TestStatus> = testRunner.getTestStatuses();

        var i : Int = 0;
        while(i < tests.length) {

            output.add(Type.getClassName(Type.getClass(tests[i])));
            output.add("\t");

            var testStatusString : String;
            var testErrorString : StringBuf = new StringBuf();

            // Write status string according to test status
            if(statuses[i].isDone()) {
                if(statuses[i].isSuccess()) {
                    testStatusString = STATUS_OK;
                    succeeded++;
                } else {
                    testStatusString = STATUS_FAIL;
                    failed++;

                    // Build the test error string
                    testErrorString.add("\r\n");
                    testErrorString.add(statuses[i].getError());
                    testErrorString.add("\r\n");
                    testErrorString.add(statuses[i].getBackTrace());
                }
            } else {
                testStatusString = STATUS_DNR;
                unfinished++;
            }

            output.add(testStatusString);
            output.add(testErrorString);
            output.add("\r\n");
            output.add(H2_LINE);

            i++;
        }

        output.add(H2_LINE);
        output.add(TOTAL);
        output.add("\t\t");
        output.add(total);
        output.add("\r\n");

        output.add(TOTAL_SUCCEEDED);
        output.add("\t");
        output.add(succeeded);
        output.add("\r\n");

        output.add(TOTAL_FAILED);
        output.add("\t\t");
        output.add(failed);
        output.add("\r\n");

        output.add(TOTAL_DNR);
        output.add("\t");
        output.add(unfinished);
        output.add("\r\n");

        output.add(H1_LINE);

        return output.toString();
    }

}