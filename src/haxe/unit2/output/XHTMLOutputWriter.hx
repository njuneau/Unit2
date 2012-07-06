/*
 * Copyright (c) 2012, Nicolas Juneau
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

/**
 * The XHTML output writer will output the test results in an encapsulated
 * XHTML 1.0 Strict page.
 */
class XHTMLOutputWriter implements OutputWriter {

    // Messages
    private static inline var STATUS_OK : String = "OK";
    private static inline var STATUS_FAIL : String = "Fail";
    private static inline var STATUS_DNR : String = "Did not run";

    // HTML classes
    private static inline var STATUS_OK_CLASS : String = "ok";
    private static inline var STATUS_FAIL_CLASS : String = "fail";
    private static inline var STATUS_DNR_CLASS : String = "dnr";
    private static inline var ERROR_DETAILS_CLASS : String = "errorDetails";
    private static inline var TEST_TITLE_CLASS : String = "testTitle";
    private static inline var TEST_RESULT_CLASS : String = "testResult";
    private static inline var TEST_METRICS_STATUS_CLASS : String = "testMetricsStatus";
    private static inline var TEST_METRICS_TOTAL_CLASS : String = "testMetricsTotal";

    /**
     * Default constructor
     */
    public function new() {}

    /**
     * Write the results of a test suite
     */
    public function writeResults(testRunner : TestRunner) : String {
        var document : Xml = Xml.createDocument();
        var docType : Xml = Xml.createDocType("html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\"");
        document.addChild(docType);

        // Create HTML skeleton and head zone
        var html : Xml = Xml.createElement("html");
        html.set("xmlns", "http://www.w3.org/1999/xhtml");
        html.set("lang", "en");
        document.addChild(html);
        var head : Xml = Xml.createElement("head");
        html.addChild(head);
        var metaContentType : Xml = Xml.createElement("meta");
        metaContentType.set("http-equiv", "Content-Type");
        metaContentType.set("content", "text/html; charset=UTF-8");
        head.addChild(metaContentType);

        // Page title
        var titleBuf : StringBuf = new StringBuf();
        titleBuf.add("Test report - ");
        titleBuf.add(Date.now().toString());
        var title : String = titleBuf.toString();
        var titleElement : Xml = Xml.createElement("title");
        titleElement.addChild(Xml.createPCData(title));
        head.addChild(titleElement);

        // Body
        var body : Xml = Xml.createElement("body");

        // Page title
        var pageTitleElement : Xml = Xml.createElement("h1");
        pageTitleElement.addChild(Xml.createPCData(title));
        body.addChild(pageTitleElement);

        // Test suite body
        var testTable : Xml = Xml.createElement("table");

        // Table head
        var testTableHead : Xml = Xml.createElement("thead");
        var testTableHeadTR : Xml = Xml.createElement("tr");
        var testTableHeadTRTH1 : Xml = Xml.createElement("th");
        testTableHeadTRTH1.addChild(Xml.createPCData("Test name"));
        testTableHeadTR.addChild(testTableHeadTRTH1);
        var testTableHeadTRTH2 : Xml = Xml.createElement("th");
        testTableHeadTRTH2.addChild(Xml.createPCData("Test status"));
        testTableHeadTR.addChild(testTableHeadTRTH2);
        testTableHead.addChild(testTableHeadTR);
        testTable.addChild(testTableHead);

        // Table body
        var testTableBody : Xml = Xml.createElement("tbody");
        var tests : Array<Class<TestCase>> = testRunner.getTests();
        var statuses : Array<TestStatus> = testRunner.getTestStatuses();

        var total : Int = tests.length;
        var succeeded : Int = 0;
        var failed : Int = 0;
        var unfinished : Int = 0;

        var i : Int = 0;
        while(i < tests.length) {

            var testTR : Xml = Xml.createElement("tr");
            var testTitleCell : Xml = Xml.createElement("td");
            testTitleCell.set("class", TEST_TITLE_CLASS);
            testTitleCell.addChild(Xml.createPCData(Type.getClassName(tests[i])));
            testTR.addChild(testTitleCell);

            var testResultCell : Xml = Xml.createElement("td");
            testResultCell.set("class", TEST_RESULT_CLASS);

            var testStatusString : String;
            var testErrorString : StringBuf = new StringBuf();
            var testStatusClass : String;

            var testErrorDetails : Xml = null;

            // Write status string according to test status
            if(statuses[i].isDone()) {
                if(statuses[i].isSuccess()) {
                    testStatusString = STATUS_OK;
                    testStatusClass = STATUS_OK_CLASS;
                    succeeded++;
                } else {
                    testStatusString = STATUS_FAIL;
                    testStatusClass = STATUS_FAIL_CLASS;
                    failed++;

                    // Build the test error string
                    testErrorDetails = Xml.createElement("div");
                    testErrorDetails.set("class", ERROR_DETAILS_CLASS);
                    var testErrorDetailsHead : Xml = Xml.createElement("p");
                    var testErrorDetailsHeadContainer : Xml = Xml.createElement("em");
                    testErrorDetailsHeadContainer.addChild(Xml.createPCData("Caught exception :"));
                    testErrorDetailsHead.addChild(testErrorDetailsHeadContainer);
                    testErrorDetails.addChild(testErrorDetailsHead);

                    var testErrorDetailsError : Xml = Xml.createElement("p");
                    testErrorDetailsError.addChild(Xml.createPCData(statuses[i].getError()));
                    testErrorDetails.addChild(testErrorDetailsError);
                    var testErrorDetailsBackTrace : Xml = Xml.createElement("pre");
                    testErrorDetailsBackTrace.addChild(Xml.createPCData(statuses[i].getBackTrace()));
                    testErrorDetails.addChild(testErrorDetailsBackTrace);
                }
            } else {
                testStatusString = STATUS_DNR;
                testStatusClass = STATUS_DNR_CLASS;
                unfinished++;
            }

            testTR.set("class", testStatusClass);

            // Add test status
            var testStatusMessage : Xml = Xml.createElement("p");
            var testStatusMessageContainer : Xml = Xml.createElement("em");
            testStatusMessageContainer.addChild(Xml.createPCData(testStatusString));
            testStatusMessage.addChild(testStatusMessageContainer);
            testResultCell.addChild(testStatusMessage);

            // Add test error, if any.
            if(testErrorDetails != null) {
                testResultCell.addChild(testErrorDetails);
            }

            testTR.addChild(testResultCell);
            testTableBody.addChild(testTR);

            i++;
        }

        testTable.addChild(testTableBody);

        // Add test metrics
        var testTableFooter : Xml = Xml.createElement("tfoot");

        // Metrics header
        var testTableFooterHeadTR : Xml = Xml.createElement("tr");

        var testTableFooterHeadTRTH1 : Xml = Xml.createElement("th");
        testTableFooterHeadTRTH1.addChild(Xml.createPCData("Status"));
        testTableFooterHeadTR.addChild(testTableFooterHeadTRTH1);

        var testTableFooterHeadTRTH2 : Xml = Xml.createElement("th");
        testTableFooterHeadTRTH2.addChild(Xml.createPCData("Total"));
        testTableFooterHeadTR.addChild(testTableFooterHeadTRTH2);

        testTableFooter.addChild(testTableFooterHeadTR);

        // Metrics

        // Succeeded
        var succeededTR : Xml = Xml.createElement("tr");
        var succeededStatusCell : Xml = Xml.createElement("td");
        succeededStatusCell.set("class", TEST_METRICS_STATUS_CLASS);
        succeededStatusCell.addChild(Xml.createPCData("Succeeded"));
        succeededTR.addChild(succeededStatusCell);
        var succeededTotalCell : Xml = Xml.createElement("td");
        succeededTotalCell.set("class", TEST_METRICS_TOTAL_CLASS);
        succeededTotalCell.addChild(Xml.createPCData(Std.string(succeeded)));
        succeededTR.addChild(succeededTotalCell);
        testTableFooter.addChild(succeededTR);

        // Failed
        var failedTR : Xml = Xml.createElement("tr");
        var failedStatusCell : Xml = Xml.createElement("td");
        failedStatusCell.set("class", TEST_METRICS_STATUS_CLASS);
        failedStatusCell.addChild(Xml.createPCData("Failed"));
        failedTR.addChild(failedStatusCell);
        var failedTotalCell : Xml = Xml.createElement("td");
        failedTotalCell.set("class", TEST_METRICS_TOTAL_CLASS);
        failedTotalCell.addChild(Xml.createPCData(Std.string(failed)));
        failedTR.addChild(failedTotalCell);
        testTableFooter.addChild(failedTR);

        // Did not run
        var dnrTR : Xml = Xml.createElement("tr");
        var dnrStatusCell : Xml = Xml.createElement("td");
        dnrStatusCell.set("class", TEST_METRICS_STATUS_CLASS);
        dnrStatusCell.addChild(Xml.createPCData("Did not run"));
        dnrTR.addChild(dnrStatusCell);
        var dnrTotalCell : Xml = Xml.createElement("td");
        dnrTotalCell.set("class", TEST_METRICS_TOTAL_CLASS);
        dnrTotalCell.addChild(Xml.createPCData(Std.string(unfinished)));
        dnrTR.addChild(dnrTotalCell);
        testTableFooter.addChild(dnrTR);

        // Total
        var totalTR : Xml = Xml.createElement("tr");
        var totalStatusCell : Xml = Xml.createElement("td");
        totalStatusCell.set("class", TEST_METRICS_STATUS_CLASS);
        totalStatusCell.addChild(Xml.createPCData("Total"));
        totalTR.addChild(totalStatusCell);
        var totalTotalCell : Xml = Xml.createElement("td");
        totalTotalCell.set("class", TEST_METRICS_TOTAL_CLASS);
        totalTotalCell.addChild(Xml.createPCData(Std.string(total)));
        totalTR.addChild(totalTotalCell);
        testTableFooter.addChild(totalTR);

        testTable.addChild(testTableFooter);

        body.addChild(testTable);
        document.addChild(body);

        return document.toString();
    }

}