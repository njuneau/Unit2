package haxe.unit2.output;

import haxe.unit2.TestCase;
import haxe.unit2.TestRunner;

/**
 * An output writer is used to format and output the results of a test suite
 * in a standardised manner.
 */
interface OutputWriter {

    /**
     * Write the results of a test suite
     */
    public function writeResults(testRunner : TestRunner) : String;

}