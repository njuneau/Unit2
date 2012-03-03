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

    private static var beforeCount : Int = 0;
    private static var afterCount : Int = 0;
    private static var ranFakeTest : Bool = false;
    private static var testCount : Int = 0;
    private static var beforeClassCount : Int = 0;
    private static var afterClassCount : Int = 0;

    /**************************************************************************/
    /*                               TESTING AREA                             */
    /**************************************************************************/

    /**
     * Reset all values at each run.
     */
    @BeforeClass
    public function beforeClass() : Void {
        testCount = 0;
        beforeCount = 0;
        afterCount = 0;
        ranFakeTest = false;

        beforeClassCount++;
    }

    @AfterClass
    public function afterClass() : Void {
        afterClassCount++;
    }

    /**
     * Increases before counts
     */
    @Before
    public function before() : Void {
        beforeCount++;
    }

    /**
     * Increases after counts
     */
    @After
    public function after() : Void {
        afterCount++;
    }

    /**
     * This is not a test. If the TestCase interprets this as a test case,
     * then the TestCase implementation is not working properly.
     */
    public function testFakeTest() {
        ranFakeTest = true;
    }

    /**
     * This is not a test. If the TestCase interprets this as a test case,
     * then the TestCase implementation is not working properly.
     */
    @NotATest
    public function testAnotherFakeTest() {
        ranFakeTest = true;
    }

    /**
     * This is a real test that should be ran. It does nothing.
     */
    @Test
    public function emptyTest() : Void {
        testCount++;
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

        testCount++;
    }

    /**************************************************************************/
    /*                             DIAGNOSTICS AREA                           */
    /**************************************************************************/

    /**
     * Reset the mock
     */
    public static function reset() {
        beforeClassCount = 0;
        afterClassCount = 0;
    }

    /**
     * Indicates if the "fake test" was run. If it did, then the test case class
     * is not functionning properly.
     */
    public static function isFakeTestRan() : Bool {
        return ranFakeTest;
    }

    /**
     * Indicates the number of times the "before test" has been called, should
     * be the same number as the amount of tests in the test case for this mock.
     */
    public static function getBeforeCount() : Int {
        return beforeCount;
    }

    /**
     * Indicates the number of times the "after test" has been called, should be
     * the same number as the amount of tests in the test case for this mock.
     */
    public static function getAfterCount() : Int {
        return afterCount;
    }

    /**
     * Indicates the number of tests that were ran.
     */
    public static function getTestCount() : Int {
        return testCount;
    }

    /**
     * Returns the amount of times the "before class" has been called. Should be
     * 1.
     */
    public static function getBeforeClassCount() : Int {
        return beforeClassCount;
    }

    /**
     * Returns the amount of times the "after class" has been called. Should be
     * 1.
     */
    public static function getAfterClassCount() : Int {
        return afterClassCount;
    }
}