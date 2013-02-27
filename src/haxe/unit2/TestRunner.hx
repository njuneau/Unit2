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

    private static var TEST_META_NAME = "Test";
    private static var BEFORE_META_NAME = "Before";
    private static var AFTER_META_NAME = "After";
    private static var BEFORECLASS_META_NAME = "BeforeClass";
    private static var AFTERCLASS_META_NAME = "AfterClass";

    private var tests  : Array<Class<TestCase>>;
    private var testStatuses : Array<TestStatus>;
    private var success : Bool;

    /**
     * Constructs a new instance with an empty test case list
     */
    public function new() {
        this.tests = new Array<Class<TestCase>>();
        this.testStatuses = new Array<TestStatus>();
        this.success = false;
    }

    /**
     * Adds a test case class to the list. Must be a TestCase, or subclass of
     * TestCase.
     */
    public function add(t : Class<TestCase>) : Void{
        this.tests.push(t);
        this.testStatuses.push(new TestStatus(Type.getClassName(t), ""));
    }

    /**
     * Runs all the tests in the test runner
     */
    public function run() : Void {
        this.success = true;

        var i : Int = 0;
        // Scan for a class' test fields and pre/post test operations
        while(this.success && i < this.tests.length) {
            var clFields : Array<String> = Type.getInstanceFields(this.tests[i]);
            var classMeta : Dynamic<Dynamic<Array<Dynamic>>> = Meta.getFields(this.tests[i]);

            // Create the TestCase instance
            var testInstance : TestCase = Type.createEmptyInstance(this.tests[i]);

            // Test fields and pre/post test operations
            var testFields : List<Array<Dynamic>> = new List<Array<Dynamic>>();
            var beforeField : Dynamic = null;
            var afterField : Dynamic = null;
            var beforeClassField : Dynamic = null;
            var afterClassField : Dynamic = null;

            // Iterate over all the TestCase's fields to look for test methods
            for(fieldName in clFields) {
                var meta : Dynamic<Array<Dynamic>> = Reflect.field(classMeta, fieldName);
                var field : Dynamic = Reflect.field(testInstance, fieldName);

                // If the current field is a method and has metadata
                if (Reflect.isFunction(field) && meta != null) {

                    // If the current method has relevant metadata declaration
                    if(Reflect.hasField(meta, TEST_META_NAME)) {
                        testFields.add([fieldName, field]);
                    } else if(Reflect.hasField(meta, BEFORE_META_NAME) && beforeField == null) {
                        beforeField = field;
                    } else if(Reflect.hasField(meta, AFTER_META_NAME) && afterField == null) {
                        afterField = field;
                    } else if(Reflect.hasField(meta, BEFORECLASS_META_NAME) && beforeClassField == null) {
                        beforeClassField = field;
                    } else if(Reflect.hasField(meta, AFTERCLASS_META_NAME) && afterClassField == null) {
                        afterClassField = field;
                    }
                }
            }

            // Execute @BeforeClass
            if(beforeClassField != null) {
                Reflect.callMethod(testInstance, beforeClassField, new Array());
            }

            // Execute all the test cases
            var fieldIterator : Iterator<Array<Dynamic>> = testFields.iterator();
            while(this.success && fieldIterator.hasNext()) {
                var testField : Array<Dynamic> = fieldIterator.next();

                this.testStatuses[i] = new TestStatus(Type.getClassName(this.tests[i]), testField[0]);

                // Execute @Before
                if(beforeField != null) {
                    Reflect.callMethod(testInstance, beforeField, new Array());
                }

                // Execute a test case
                try {
                    // Execute @Test
                    Reflect.callMethod(testInstance, testField[1], new Array());
                    this.testStatuses[i].setSuccess(true);

                } catch (e : AssertionException) {
                    this.testStatuses[i].setError(e.getMessage());
                    this.testStatuses[i].setBackTrace(CallStack.toString(CallStack.exceptionStack()));
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

                    this.testStatuses[i].setBackTrace(CallStack.toString(CallStack.exceptionStack()));
                    this.testStatuses[i].setSuccess(false);
                }

                // Execute @After
                if(afterField != null) {
                    Reflect.callMethod(testInstance, afterField, new Array());
                }

                this.testStatuses[i].setDone(true);
                this.success = this.testStatuses[i].isSuccess();
            }

            // Execute @AfterClass
            if(afterClassField != null) {
                Reflect.callMethod(testInstance, afterClassField, new Array());
            }

            i++;
        }
    }

    /**
     * Returns the tests that were added to this test runner
     */
    public function getTests() : Array<Class<TestCase>> {
        return this.tests;
    }

    /**
     * Returns the tests' statuses. The indexes of the statuses corresponds
     * to the indexes of the tests.
     */
    public function getTestStatuses() : Array<TestStatus> {
        return this.testStatuses;
    }

    /**
     * Returns an iterator that iterates on the test runner's list of test cases
     */
    public function iterator() : Iterator<Class<TestCase>> {
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