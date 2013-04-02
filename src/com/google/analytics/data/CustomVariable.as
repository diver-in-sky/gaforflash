/*
 * Copyright 2008 Adobe Systems Inc., 2008 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Contributor(s):
 *   Andrey Tereskin <tereskin@gmail.com>.
 */
package com.google.analytics.data {


/**
 *
 * This class encapsulate one custom variable value
 *
 */
public class CustomVariable {

    /**
     * Number of slot from 1-5, inclusive.
     */
    private var _slot:int;

    /**
     * Name for the custom variable.
     */
    private var _name:String;

    /**
     * Value for the custom variable.
     */
    private var _value:String;

    /**
     * 1 - visitor-level
     * 2 - session-level
     * 3 - page-level
     */
    private var _scope:int;

    public function CustomVariable(slot:int,  name:String, value:String, scope:int) {
        _slot = slot;
        _name = name;
        _value = value;
        _scope = scope;
    }


    public function get slot():int {
        return _slot;
    }

    public function get name():String {
        return _name;
    }

    public function get value():String {
        return _value;
    }

    public function get scope():int {
        return _scope;
    }
}
}
