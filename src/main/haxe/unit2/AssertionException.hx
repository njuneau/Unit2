/*
 * Copyright (c) 2012-2013, Nicolas Juneau
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
package unit2;

import haxe.PosInfos;

/**
 * This kind of exception is thrown when an assertion fails in a test case
 */
class AssertionException {

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