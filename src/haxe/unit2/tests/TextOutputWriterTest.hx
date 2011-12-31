package haxe.unit2.tests;

import haxe.unit.TestCase;
import haxe.unit2.TestRunner;
import haxe.unit2.tests.mocks.MockTestCase1;
import haxe.unit2.output.TextOutputWriter;

import neko.Lib;

class TextOutputWriterTest extends TestCase {

    /**
     * Tests the output writer. Do some basic check of the outputted string.
     */
    public function testTextOutputWriter() : Void {
        var testRunner : TestRunner = new TestRunner();
        var outputWriter : TextOutputWriter = new TextOutputWriter();
        var successPattern : String = "[ OK ]";
        var failPattern : String = "[ FAIL ]";
        var dnrPattern : String = "[ DID NOT RUN ]";
        var tests : List<haxe.unit2.TestCase> = new List<haxe.unit2.TestCase>();
        tests.add(new MockTestCase1());
        tests.add(new MockTestCase1());

        // Add all tests in test runner
        for(test in tests) {
            testRunner.add(test);
        }

        // After running the outputwriter, we should see all the tests as not
        // finished
        var result : String = outputWriter.writeResults(testRunner);
        var i : Int = 0;
        var lastPos :Int = 0;

        while(i < tests.length) {
            lastPos = result.indexOf(dnrPattern, lastPos);
            this.assertTrue(lastPos != -1);
            i++;
        }

        // Now that the test runner has ran, all the tests should mark OK.
        testRunner.run();
        i = 0;
        result = outputWriter.writeResults(testRunner);
        lastPos = 0;

        while(i < tests.length) {
            lastPos = result.indexOf(successPattern, lastPos);
            //this.assertTrue(lastPos != -1);
            i++;
        }

        Lib.println(result);

    }

}