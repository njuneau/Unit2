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
        var tests : List<Class<haxe.unit2.TestCase>> = new List<Class<haxe.unit2.TestCase>>();
        tests.add(MockTestCase1);
        tests.add(MockTestCase1);

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
        var okNum : Int = 0;

        while(i < tests.length && lastPos != -1) {
            lastPos = result.indexOf(successPattern, lastPos);
            if(lastPos != -1) {
                okNum++;
            }
            i++;
        }
        this.assertEquals(tests.length, okNum);

        Lib.println(result);

    }

}