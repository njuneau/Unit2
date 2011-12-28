/*
 * Copyright (c) 2005, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package haxe.unit2;

import haxe.rtti.Meta;

/**
 * A TestRunner is a TestCase composite. Add your tests to the test runner and
 * run the test runner in order to execute all the tests contained in it.
 * If a single test case fails, the testrunner's result will also fail.
 */
class TestRunner {

    private static var META_NAME = "Test";


    private var tests  : List<TestCase>;
    private var success : Bool;

    /**
     * Constructs a new instance with an empty test case list
     */
    public function new() {
        this.tests = new List();
        this.success = false;
    }

    /**
     * Adds a test case to the list
     */
    public function add( t:TestCase ) : Void{
        this.tests.add(t);
    }

    /**
     * Runs all the tests in the test runner
     */
    public function run() : Void {
        var testIterator : Iterator<TestCase> = this.tests.iterator();
        var currentTest : TestCase;
        this.success = true;

        // Run all the tests, and stop as soon as there's a error
        while(this.success && testIterator.hasNext()) {
            var currentTest : TestCase = testIterator.next();
            var cl : Class<TestCase> = Type.getClass(currentTest);
            var fields : Array<String> = Type.getInstanceFields(cl);
            var classMeta : Dynamic<Dynamic<Array<Dynamic>>> = Meta.getFields(cl);
            currentTest.prepare();

            // Iterate over all the TestCase's fields to look for test methods
            var fieldIterator : Iterator<String> = fields.iterator();

            while(this.success && fieldIterator.hasNext()) {
                var fieldName = fieldIterator.next();
                var meta : Dynamic<Array<Dynamic>> = Reflect.field(classMeta, fieldName);
                var field : Dynamic = Reflect.field(currentTest, fieldName);

                // If the current field is a method and has metadata
                if (Reflect.isFunction(field) && meta != null ) {

                    // If the current method has a "Test" metadata declaration
                    if(Reflect.hasField(meta, META_NAME)) {
                        var testStatus : TestStatus = new TestStatus();
                        testStatus.setClassName(Type.getClassName(cl));
                        testStatus.setMethod(fieldName);
                        currentTest.setStatus(testStatus);
                        currentTest.setup();

                        // Execute a test case
                        try {
                            Reflect.callMethod(this, field, new Array());
                        } catch (e : TestStatus) {
                            testStatus.setBackTrace(Stack.toString(Stack.exceptionStack()));
                        } catch (e : Dynamic) {
                            // Test fails if there's an error to catch
                            #if js
                            if(e.message != null) {
                                testStatus.setError("Exception thrown : " + e + " [" + e.message + "]");
                            } else {
                                testStatus.setError("Exception thrown : " + e);
                            }
                            #else
                            testStatus.setError("Exception thrown : " + e);
                            #end
                            testStatus.setBackTrace(Stack.toString(Stack.exceptionStack()));
                        }

                        currentTest.tearDown();
                        this.success = currentTest.getStatus().isSuccess();
                    }
                }
            }
        }
    }

    /**
     * Returns the tests that were added to this test runner
     */
    public function getTests() : List<TestCase> {
        return this.tests;
    }

    public function iterator() : Iterator<TestCase> {
        return this.tests.iterator();
    }

    /**
     * Commodity method that returns the success state of the last run test.
     * It will return true if all the tests were ran successfully.
     * It will return false if the tests were not ran (if the run method hasn't
     * been called) or if a test case failed.
     */
    public function isSuccess() : Bool {
        return this.success;
    }
}