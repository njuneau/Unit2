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
import haxe.Stack;

/**
 * A test case consists of a set of unit tests related to a certain code
 * component.
 *
 * In order to write unit tests, write methods annotated with the @Test
 * metadata element. Each test test will be executed sequentially. Before
 * the execution of a unit test, the "setup" method will be called and after the
 * execution of each test, the "tearDown" method will be called. You will have
 * to override these methods in your own TestCase implementation, should you
 * need them.
 */
class TestCase #if mt_build implements mt.Protect, #end {

    private var status : TestStatus;

    /**
     * Default empty constructor
     */
    public function new() {
        this.status = new TestStatus();
    }

    /**
     * This method is called before a TestRunner starts executing tests on this
     * instance. It is not called each time a test is ran - it is ran once per
     * TestCase instance.
     */
    public function prepare() : Void {}

    /**
     * This method is called before each test is ran
     */
    public function setup() : Void {}

    /**
     * This method is called after each test is ran
     */
    public function tearDown() : Void {
        status.setDone(true);
    }

    /**
     * Asserts that the given value is true. If it is not true, the test will fail.
     */
    private function assertTrue(b : Bool, ?c : PosInfos) : Void {
        if(b != true) {
            this.status.setSuccess(false);
            this.status.setError("Expected true but was given false");
            this.status.setPosInfos(c);
            throw status;
        }
    }

    /**
     * Asserts that the given value is false. If it is not false, the test will fail.
     */
    private function assertFalse(b : Bool, ?c : PosInfos) : Void {
        if(b != false) {
            this.status.setSuccess(false);
            this.status.setError("Expected false but was given true");
            this.status.setPosInfos(c);
            throw status;
        }
    }

    /**
     * Asserts that two given objects are equal. If they are not, the test will fail.
     */
    private function assertEquals<T>(expected : T, actual : T, ?c : PosInfos) : Void 	{
        if (actual != expected){
            this.status.setSuccess(false);
            this.status.setError("Expected '" + expected + "' but was given '" + actual + "'");
            this.status.setPosInfos(c);
            throw status;
        }
    }

    /**
     * Returns this class' status
     */
    public function getStatus() : TestStatus {
        return this.status;
    }

    /**
     * Sets this class' status
     */
    public function setStatus(status : TestStatus) {
        this.status = status;
    }
}