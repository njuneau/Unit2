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

import haxe.PosInfos;

/**
 * This class indicates the status of a test case
 */
class TestStatus {

    private var done : Bool;
    private var success : Bool;
    private var error : String;
    private var backTrace : String;
    private var methodName : String;
    private var className : String;

    /**
     * Intialises the status to not done, failing. Specify the class' name
     * and the method's name.
     */
    public function new(className : String, methodName : String) {
        this.className = className;
        this.methodName = methodName;
        this.done = false;
        this.success = false;
        this.error = null;
        this.backTrace = null;
    }

    /**
     * Sets the done status of the test
     */
    public function setDone( done : Bool ) : Void {
        this.done = done;
    }

    /**
     * Indicates if a test is done
     */
    public function isDone() : Bool {
        return this.done;
    }

    /**
     * Sets the success status of a test
     */
     public function setSuccess( success : Bool ) {
        this.success = success;
    }

    /**
     * Indicates if a test was a success
     */
    public function isSuccess() : Bool {
        return this.success;
    }

    /**
     * Sets the error message of a test that failed
     */
    public function setError(error : String) : Void {
        this.error = error;
    }

    /**
     * Returns this status' method name
     */
    public function getMethodName() : String {
        return this.methodName;
    }

    /**
     * Return this status' class name
     */
    public function getClassName() : String {
        return this.className;
    }

    /**
     * Returns the error message of a test that failed. Returns null if there
     * are no errors for the test
     */
    public function getError() : String {
        return this.error;
    }

    /**
     * Sets the error's backtrace
     */
    public function setBackTrace(backTrace : String) {
        this.backTrace = backTrace;
    }

    /**
     * Returns the backtrace of the error, if any. Returns null if there was no
     * errors.
     */
    public function getBackTrace() : String {
        return this.backTrace;
    }

}