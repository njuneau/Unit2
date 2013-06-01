/*
 * Copyright (c) 2012-2013, Nicolas Juneau
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
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

    private static inline var H1_LINE : String = "================================================================================\r\n";
    private static inline var H2_LINE : String = "--------------------------------------------------------------------------------\r\n";
    private static inline var STATUS_OK : String = "[ OK ]";
    private static inline var STATUS_FAIL : String = "[ FAIL ]";
    private static inline var STATUS_DNR : String = "[ DID NOT RUN ]";

    private static inline var TOTAL : String = "Total";
    private static inline var TOTAL_SUCCEEDED : String = "Succeeded";
    private static inline var TOTAL_FAILED : String = "Failed";
    private static inline var TOTAL_DNR : String = "Did not run";

    /**
     * Default constructor
     */
    public function new() {}

    /**
     * This will write the results of the test runner's test cases in a simple
     * text representation
     */
    public function writeResults(testRunner : TestRunner) : String {
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

        var tests : Array<Class<TestCase>> = testRunner.getTests();
        var statuses : Array<TestStatus> = testRunner.getTestStatuses();

        var i : Int = 0;
        while(i < tests.length) {

            output.add(Type.getClassName(tests[i]));
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
                    testErrorString.add("Caught exception : \t");
                    testErrorString.add(statuses[i].getError());
                    testErrorString.add("\r\n");
                    testErrorString.add(statuses[i].getBackTrace());
                }
            } else {
                testStatusString = STATUS_DNR;
                unfinished++;
            }

            // Add test status and error to output
            output.add(testStatusString);
            output.add(testErrorString.toString());
            output.add("\r\n");
            output.add(H2_LINE);

            i++;
        }

        // Write totals
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