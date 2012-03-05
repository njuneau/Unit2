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
 * In order to write unit tests, write methods annotated with the "@Test"
 * metadata element. Each test test will be executed sequentially.
 *
 * There also may be one method annotated "@Before" - it will be executed before
 * each test method. The "@After" tag may also be used in the same fashion - the
 * method will then be executed after the test method.
 *
 * For test case initialisation and termination, "@BeforeClass" and
 * "@AfterClass" may be used on methods to have them exectuted, respectively,
 * before all the tests are ran and after all the tests are ran. There can only
 * be one "@BeforeClass" and one "@AfterClass"-annotated method.
 *
 */
class TestCase {

    /**
     * Asserts that the given value is true. If it is not true, an error will be thrown.
     */
    private function assertTrue(b : Bool, ?c : PosInfos) : Void {
        if(b != true) {
            throw new AssertionException("Expected true, but was given false", c);
        }
    }

    /**
     * Asserts that the given value is false. If it is not false, an error will be thrown
     */
    private function assertFalse(b : Bool, ?c : PosInfos) : Void {
        if(b != false) {
            throw new AssertionException("Expected false, but was given true", c);
        }
    }

    /**
     * Asserts that two given objects are equal. If they are not, an error will be thrown
     */
    private function assertEquals<T>(expected : T, actual : T, ?c : PosInfos) : Void {
        if (actual != expected) {
            throw new AssertionException("Expected '" + expected + "', but was given '" + actual + "'", c);
        }
    }

}