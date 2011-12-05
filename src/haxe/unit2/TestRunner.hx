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

/**
 * A TestRunner is a TestCase composite. Add your tests to the test runner and
 * run the test runner in order to execute all the tests contained in it.
 * If a single test case fails, the testrunner's result will also fail.
 */
class TestRunner implements TestCase {

	private var tests  : List<TestCase>;
	private var status : TestStatus;

    /**
     * Constructs a new instance with an empty test case list
     */
    public function new() {
        this.tests = new List();
        this.status = new TestStatus();
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
        var success : Bool = true;
        var currentTest : TestCase;

        while(success && testIterator.hasNext()) {
            var currentTest : TestCase = testIterator.next();
            currentTest.run();
            this.status = currentTest.getStatus();
        }
	}

	public function getStatus() : TestStatus {
	   return this.status;
	}
}
