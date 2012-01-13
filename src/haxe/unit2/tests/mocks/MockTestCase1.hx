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
package haxe.unit2.tests.mocks;

import haxe.unit2.TestCase;

/**
 * This is a mock test case that tests the various functions of the TestCase class
 * This test should cover most basic functions of the TestCase implementation
 */
class MockTestCase1 extends TestCase {

    // The number of tests to run in this class. KEEP THIS UP TO DATE!
    public static var TEST_COUNT : Int = 2;

    private var setupCount : Int;
    private var tearDownCount : Int;
    private var ranFakeTest : Bool;
    private var testCount : Int;

    /**
     * Empty constructor
     */
    public function new() {
        super();
    }

    /**
     * Reset all values at each run.
     */
    public override function prepare() : Void {
        this.testCount = 0;
        this.setupCount = 0;
        this.tearDownCount = 0;
        this.ranFakeTest = false;
        super.prepare();
    }

    /**
     * Increases setup counts
     */
    public override function setup() : Void {
        this.setupCount++;
    }

    /**
     * Increases teardown counts
     */
    public override function tearDown() : Void {
        this.tearDownCount++;
    }

    /**************************************************************************/
    /*                               TESTING AREA                             */
    /**************************************************************************/

    /**
     * This is not a test. If the TestCase interprets this as a test case,
     * then the TestCase implementation is not working properly.
     */
    public function testFakeTest() {
        this.ranFakeTest = true;
    }

    /**
     * This is not a test. If the TestCase interprets this as a test case,
     * then the TestCase implementation is not working properly.
     */
    @NotATest
    public function testAnotherFakeTest() {
        this.ranFakeTest = true;
    }

    /**
     * This is a real test that should be ran. It does nothing.
     */
    @Test
    public function emptyTest() : Void {
        this.testCount++;
    }

    /**
     * This test is used to verify if the "assert" methods yield valid results
     */
    @Test
    public function testValidAssertions() : Void {
        this.assertEquals(3, 3);
        this.assertEquals("blah", "blah");
        this.assertFalse(false);
        this.assertTrue(true);
        this.assertTrue(3 > 1);
        this.assertFalse(1 > 3);

        var caught : Bool = false;

        try {
            this.assertEquals(1, 2);
        } catch (e : AssertionException) {
            caught = true;
        }

        this.assertTrue(caught);

        caught = false;

        try {
            this.assertFalse(true);
        } catch(e : AssertionException) {
            caught = true;
        }

        this.assertTrue(caught);

        caught = false;

        try {
            this.assertTrue(false);
        } catch(e : AssertionException) {
            caught = true;
        }

        this.assertTrue(caught);

        this.testCount++;
    }

    /**************************************************************************/
    /*                             DIAGNOSTICS AREA                           */
    /**************************************************************************/

    /**
     * Indicates if the "fake test" was run. If it did, then the test case class
     * is not functionning properly.
     */
    public function isFakeTestRan() : Bool {
        return this.ranFakeTest;
    }

    /**
     * Indicates the number of times "setup" has been called, should be the same
     * number has the amount of tests in the test case.
     */
    public function getSetupCount() : Int {
        return this.setupCount;
    }

    /**
     * Indicates the number of times "tearDown" has been called, should be the
     * same number has the amount of tests in the test case.
     */
    public function getTearDownCount() : Int {
        return this.tearDownCount;
    }

    /**
     * Indicates the number of tests that were ran.
     */
    public function getTestCount() : Int {
        return this.testCount;
    }
}