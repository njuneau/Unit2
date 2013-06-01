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
package haxe.unit2.tests;

import haxe.unit.TestCase;
import haxe.unit2.TestRunner;
import haxe.unit2.tests.mocks.MockTestCase1;
import haxe.unit2.tests.mocks.MockTestCase2;
import haxe.unit2.output.TextOutputWriter;

import neko.Lib;

class TextOutputWriterTest extends TestCase {

    /**
     * Tests the output writer. Do some basic check of the outputted string.
     */
    public function testTextOutputWriter() : Void {
        var testRunner : TestRunner = new TestRunner();
        var outputWriter : TextOutputWriter = new TextOutputWriter();
        var testCase1Pattern : String = "haxe.unit2.tests.mocks.MockTestCase1";
        var testCase2Pattern : String = "haxe.unit2.tests.mocks.MockTestCase2";
        var successPattern : String = "[ OK ]";
        var failPattern : String = "[ FAIL ]";
        var dnrPattern : String = "[ DID NOT RUN ]";
        var tests : List<Class<haxe.unit2.TestCase>> = new List<Class<haxe.unit2.TestCase>>();
        tests.add(MockTestCase1);
        tests.add(MockTestCase2);
        tests.add(MockTestCase1);

        // Add all tests in test runner
        for(test in tests) {
            testRunner.add(test);
        }

        // After running the outputwriter, we should see all the tests as not
        // finished
        var result : String = outputWriter.writeResults(testRunner);
        var lines : Array<String> = result.split("\r\n");

        assertEquals(lines[4].indexOf(testCase1Pattern), 0);
        assertEquals(lines[4].lastIndexOf(dnrPattern), testCase1Pattern.length + 1);
        assertEquals(lines[6].indexOf(testCase2Pattern), 0);
        assertEquals(lines[6].lastIndexOf(dnrPattern), testCase2Pattern.length + 1);
        assertEquals(lines[8].indexOf(testCase1Pattern), 0);
        assertEquals(lines[8].lastIndexOf(dnrPattern), testCase1Pattern.length + 1);

        assertEquals(lines[11].indexOf("Total"), 0);
        assertEquals(lines[11].lastIndexOf("3"), lines[11].length - 1);
        assertEquals(lines[12].indexOf("Succeeded"), 0);
        assertEquals(lines[12].lastIndexOf("0"), lines[12].length - 1);
        assertEquals(lines[13].indexOf("Failed"), 0);
        assertEquals(lines[13].lastIndexOf("0"), lines[13].length - 1);
        assertEquals(lines[14].indexOf("Did not run"), 0);
        assertEquals(lines[14].lastIndexOf("3"), lines[14].length - 1);

        testRunner.run();

        // After running the tests and the output writer, we should see all the
        // following results
        result = outputWriter.writeResults(testRunner);
        lines = result.split("\r\n");

        assertEquals(lines[4].indexOf(testCase1Pattern), 0);
        assertEquals(lines[4].lastIndexOf(successPattern), testCase1Pattern.length + 1);
        assertEquals(lines[6].indexOf(testCase2Pattern), 0);
        assertEquals(lines[6].lastIndexOf(failPattern), testCase2Pattern.length + 1);
        assertEquals(lines[10].indexOf(testCase1Pattern), 0);
        assertEquals(lines[10].lastIndexOf(dnrPattern), testCase1Pattern.length + 1);

        // Exception should be there at line 7 and stack trace after it
        assertEquals(lines[7].indexOf("Caught exception : \t"), 0);
        assertTrue(lines[7].length > "Caught exception : \t".length);
        assertEquals(lines[8].indexOf("Called"), 1);

        assertEquals(lines[13].indexOf("Total"), 0);
        assertEquals(lines[13].lastIndexOf("3"), lines[13].length - 1);
        assertEquals(lines[14].indexOf("Succeeded"), 0);
        assertEquals(lines[14].lastIndexOf("1"), lines[14].length - 1);
        assertEquals(lines[15].indexOf("Failed"), 0);
        assertEquals(lines[15].lastIndexOf("1"), lines[15].length - 1);
        assertEquals(lines[16].indexOf("Did not run"), 0);
        assertEquals(lines[16].lastIndexOf("1"), lines[16].length - 1);
    }

}