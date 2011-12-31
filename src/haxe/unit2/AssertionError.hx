package haxe.unit2;

import haxe.PosInfos;

/**
 * This kind of error is thrown when an assertion fails in a test case
 */
class AssertionError {

    private var message : String;
    private var posInfos : PosInfos;

    /**
     * Creates a new assertion error with an error message and the origin of the
     * error.
     */
    public function new(message : String, posInfos : PosInfos) {
        this.message = message;
        this.posInfos = posInfos;
    }

    /**
     * Returns the error message
     */
    public function getMessage() : String {
        return this.message;
    }

    /**
     * Returns the informations about the origin of the error
     */
    public function getPosInfos() : PosInfos {
        return this.posInfos;
    }

    /**
     * Returns the string representation of the error
     */
    public function toString() : String {
        return this.message;
    }
}