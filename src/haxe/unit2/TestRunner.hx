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

    private var tests  : Array<TestCase>;
    private var testStatuses : Array<TestStatus>;
    private var success : Bool;

    /**
     * Constructs a new instance with an empty test case list
     */
    public function new() {
        this.tests = new Array<TestCase>();
        this.testStatuses = new Array<TestStatus>();
        this.success = false;
    }

    /**
     * Adds a test case to the list
     */
    public function add(t : TestCase) : Void{
        this.tests.push(t);
        this.testStatuses.push(new TestStatus(Type.getClassName(Type.getClass(t)), ""));
    }

    /**
     * Runs all the tests in the test runner
     */
    public function run() : Void {
        this.success = true;

        var i : Int = 0;
        // Run all the tests, and stop as soon as there's a error
        while(this.success && i < this.tests.length) {
            var cl : Class<TestCase> = Type.getClass(this.tests[i]);
            var fields : Array<String> = Type.getInstanceFields(cl);
            var classMeta : Dynamic<Dynamic<Array<Dynamic>>> = Meta.getFields(cl);

            this.tests[i].prepare();

            // Iterate over all the TestCase's fields to look for test methods
            var fieldIterator : Iterator<String> = fields.iterator();

            while(this.success && fieldIterator.hasNext()) {
                var fieldName = fieldIterator.next();
                var meta : Dynamic<Array<Dynamic>> = Reflect.field(classMeta, fieldName);
                var field : Dynamic = Reflect.field(this.tests[i], fieldName);

                // If the current field is a method and has metadata
                if (Reflect.isFunction(field) && meta != null) {

                    // If the current method has a "Test" metadata declaration
                    if(Reflect.hasField(meta, META_NAME)) {

                        this.testStatuses[i] = new TestStatus(Type.getClassName(cl), fieldName);

                        // Execute a test case
                        try {
                            this.tests[i].setup();
                            Reflect.callMethod(this.tests[i], field, new Array());
                            this.tests[i].tearDown();
                            this.testStatuses[i].setSuccess(true);
                        } catch (e : AssertionException) {
                            this.testStatuses[i].setError(e.getMessage());
                            this.testStatuses[i].setBackTrace(Stack.toString(Stack.exceptionStack()));
                            this.testStatuses[i].setSuccess(false);
                        } catch (e : Dynamic) {
                            // Test fails if there's an error to catch
                            #if js
                            if(e.message != null) {
                                this.testStatuses[i].setError(e + " [" + e.message + "]");
                            } else {
                                this.testStatuses[i].setError(e);
                            }
                            #else
                            this.testStatuses[i].setError(e);
                            #end

                            this.testStatuses[i].setBackTrace(Stack.toString(Stack.exceptionStack()));
                            this.testStatuses[i].setSuccess(false);
                        }

                        this.testStatuses[i].setDone(true);
                        this.success = this.testStatuses[i].isSuccess();
                    }
                }
            }

            i++;
        }
    }

    /**
     * Returns the tests that were added to this test runner
     */
    public function getTests() : Array<TestCase> {
        return this.tests;
    }

    /**
     * Returns the tests' statuses. The indexes of the statuses corresponds
     * to the indexes of the tests.
     */
    public function getTestStatuses() : Array<TestStatus> {
        return this.testStatuses;
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