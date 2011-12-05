package haxe.unit2.tests.mocks;

import haxe.unit2.TestCaseImpl;

/**
 * This is a mock test case that tests the various functions of the TestCase class
 * This test should cover most basic functions of the TestCase implementation
 */
class MockTestCase1 extends TestCaseImpl {

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
    public override function run() : Void {
        this.testCount = 0;
        this.setupCount = 0;
        this.tearDownCount = 0;
        this.ranFakeTest = false;
        super.run();
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