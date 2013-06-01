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
package unit2.tests;

import haxe.unit.TestCase;
import unit2.TestRunner;
import unit2.tests.mocks.MockTestCase1;
import unit2.tests.mocks.MockTestCase2;
import unit2.output.XHTMLOutputWriter;

import neko.Lib;

/**
 * This class tests the XHTML output writer
 */
class XHTMLOutputWriterTest extends TestCase {

    // Messages
    private static inline var STATUS_OK : String = "Succeeded";
    private static inline var STATUS_FAIL : String = "Failed";
    private static inline var STATUS_DNR : String = "Did not run";

    // HTML classes
    private static inline var STATUS_OK_CLASS : String = "ok";
    private static inline var STATUS_FAIL_CLASS : String = "fail";
    private static inline var STATUS_DNR_CLASS : String = "dnr";

    /**
     * Test the output writer
     */
    public function testXHTMLOutputWriterInitial() : Void {
        var testRunner : TestRunner = new TestRunner();
        var outputWriter : XHTMLOutputWriter = new XHTMLOutputWriter();

        var tests : List<Class<unit2.TestCase>> = new List<Class<unit2.TestCase>>();
        tests.add(MockTestCase1);
        tests.add(MockTestCase2);

        // Add all the tests
        for(test in tests) {
            testRunner.add(test);
        }

        // Output tests - all tests shouldn't have run
        var result : String = outputWriter.writeResults(testRunner);

        // The result should parse as XML;
        var xmlResult : Xml = Xml.parse(result);

        // Check header presence and content
        var html : Xml = xmlResult.elementsNamed("html").next();
        var body : Xml = html.elementsNamed("body").next();
        var titleTag : Xml = html.elementsNamed("head").next().elementsNamed("title").next();
        var h1 : Xml = body.elementsNamed("h1").next();

        this.assertTrue(StringTools.startsWith(titleTag.firstChild().nodeValue, "Test report - "));
        this.assertEquals(titleTag.firstChild().nodeValue, h1.firstChild().nodeValue);

        // Get the test table
        var testTable : Xml = body.elementsNamed("table").next();

        // Loop through all the tests, verify validity of information (should be all "did not run")
        var testIterator : Iterator<Class<unit2.TestCase>> = tests.iterator();
        for(testTR in testTable.elementsNamed("tbody").next().elementsNamed("tr")) {
            var currentTest : Class<unit2.TestCase> = testIterator.next();
            var testStatus : String = testTR.get("class");
            this.assertEquals(testStatus, STATUS_DNR_CLASS);

            // Get cell information
            var testCells : Iterator<Xml> = testTR.elementsNamed("td");
            var titleCell : Xml = testCells.next();

            // Make sure class name is OK
            this.assertEquals(titleCell.firstChild().nodeValue, Type.getClassName(currentTest));

            // Make sure result is OK
            var resultCell : Xml = testCells.next();
            this.assertEquals(resultCell.elementsNamed("p").next().elementsNamed("em").next().firstChild().nodeValue, STATUS_DNR);
        }

        this.assertFalse(testIterator.hasNext());

        // Check test metrics
        for(metricsTR in testTable.elementsNamed("tfoot").next().elementsNamed("tr")) {
            // Skip header
            if(!metricsTR.elementsNamed("th").hasNext()) {
                var cells : Iterator<Xml> = metricsTR.elementsNamed("td");
                var metricStatus : Xml = cells.next();
                var metricsCount : Xml = cells.next();

                switch(metricStatus.firstChild().nodeValue) {
                    case STATUS_OK:
                        this.assertEquals(Std.parseInt(metricsCount.firstChild().nodeValue), 0);
                    case STATUS_FAIL:
                        this.assertEquals(Std.parseInt(metricsCount.firstChild().nodeValue), 0);
                    case STATUS_DNR:
                        this.assertEquals(Std.parseInt(metricsCount.firstChild().nodeValue), tests.length);
                    case "Total":
                        this.assertEquals(Std.parseInt(metricsCount.firstChild().nodeValue), tests.length);
                    default:
                        // Force test failure - unhandled case!
                        this.assertTrue(false);
                }
            }
        }
    }

    /**
     * Test the output writer
     */
    public function testXHTMLOutputWriterExecuted() : Void {
        var testRunner : TestRunner = new TestRunner();
        var outputWriter : XHTMLOutputWriter = new XHTMLOutputWriter();

        var tests : List<Class<unit2.TestCase>> = new List<Class<unit2.TestCase>>();
        tests.add(MockTestCase1);
        tests.add(MockTestCase2);

        // Add all the tests
        for(test in tests) {
            testRunner.add(test);
        }

        testRunner.run();

        // Output tests - all tests should have run
        var result : String = outputWriter.writeResults(testRunner);

        // The result should parse as XML;
        var xmlResult : Xml = Xml.parse(result);

        // Check header presence and content
        var html : Xml = xmlResult.elementsNamed("html").next();
        var body : Xml = html.elementsNamed("body").next();
        var titleTag : Xml = html.elementsNamed("head").next().elementsNamed("title").next();
        var h1 : Xml = body.elementsNamed("h1").next();

        this.assertTrue(StringTools.startsWith(titleTag.firstChild().nodeValue, "Test report - "));
        this.assertEquals(titleTag.firstChild().nodeValue, h1.firstChild().nodeValue);

        // Get the test table
        var testTable : Xml = body.elementsNamed("table").next();

        // Loop through all the tests, verify validity of information
        var successes : Int = 0;
        var failures : Int = 0;
        var noRuns : Int = 0;

        var testIterator : Iterator<Class<unit2.TestCase>> = tests.iterator();
        for(testTR in testTable.elementsNamed("tbody").next().elementsNamed("tr")) {
            var currentTest : Class<unit2.TestCase> = testIterator.next();
            var testStatus : String = testTR.get("class");

            // Get cell information
            var testCells : Iterator<Xml> = testTR.elementsNamed("td");
            var titleCell : Xml = testCells.next();

            // Make sure class name is OK
            this.assertEquals(titleCell.firstChild().nodeValue, Type.getClassName(currentTest));

            // Make sure result is OK
            var resultCell : Xml = testCells.next();
            switch(testStatus) {
                case STATUS_OK_CLASS:
                    successes++;
                    this.assertEquals(resultCell.elementsNamed("p").next().elementsNamed("em").next().firstChild().nodeValue, STATUS_OK);
                case STATUS_FAIL_CLASS:
                    failures++;
                    this.assertEquals(resultCell.elementsNamed("p").next().elementsNamed("em").next().firstChild().nodeValue, STATUS_FAIL);

                    // In case of failure, make sure trace is there
                    var traceDiv : Xml = resultCell.elementsNamed("div").next();
                    this.assertTrue(traceDiv != null);
                    var errorDetails : Iterator<Xml> = traceDiv.elementsNamed("p");
                    this.assertTrue(errorDetails.next().elementsNamed("em").next().firstChild().nodeValue.length > 0);
                    this.assertTrue(errorDetails.next().firstChild().nodeValue.length > 0);

                    var trace : Xml = traceDiv.elementsNamed("pre").next();
                    this.assertTrue(trace.firstChild().nodeValue.length > 0);

                case STATUS_DNR_CLASS:
                    noRuns++;
                    this.assertEquals(resultCell.elementsNamed("p").next().elementsNamed("em").next().firstChild().nodeValue, STATUS_DNR);
                default:
                    // Force failure of the test - unhandled case!
                    this.assertFalse(true);
            }

        }

        this.assertFalse(testIterator.hasNext());

        // Check test metrics
        for(metricsTR in testTable.elementsNamed("tfoot").next().elementsNamed("tr")) {
            // Skip header
            if(!metricsTR.elementsNamed("th").hasNext()) {
                var cells : Iterator<Xml> = metricsTR.elementsNamed("td");
                var metricStatus : Xml = cells.next();
                var metricsCount : Xml = cells.next();

                switch(metricStatus.firstChild().nodeValue) {
                    case STATUS_OK:
                        this.assertEquals(Std.parseInt(metricsCount.firstChild().nodeValue), successes);
                    case STATUS_FAIL:
                        this.assertEquals(Std.parseInt(metricsCount.firstChild().nodeValue), failures);
                    case STATUS_DNR:
                        this.assertEquals(Std.parseInt(metricsCount.firstChild().nodeValue), noRuns);
                    case "Total":
                        this.assertEquals(Std.parseInt(metricsCount.firstChild().nodeValue), tests.length);
                    default:
                        // Force test failure - unhandled case!
                        this.assertTrue(false);
                }
            }
        }
    }

}