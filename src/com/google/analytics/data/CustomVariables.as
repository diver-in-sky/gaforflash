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
 * This class encapsulate collection of custom variables.
 *
 */
public class CustomVariables {

    public static const VISITOR_SCOPE:int = 1;
    public static const SESSION_SCOPE:int = 2;
    public static const PAGE_SCOPE:int = 3;

    public static const NAMES_CODE:int = 8;
    public static const VALUES_CODE:int = 9;
    public static const SCOPES_CODE:int = 11;

    private var _variables:Array = [];

    public function CustomVariables() {
    }

    public function setVariable(customVar:CustomVariable):void {
        var callback:Function = function(cv:CustomVariable, i:int, a:Array):Boolean {
            return cv.slot != customVar.slot;
        };
        _variables = _variables.filter(callback);
        _variables.push(customVar);
    }

    public function getVariables():Array {
        return _variables.slice();
    }

    public function getVisitorCustomVar(index:int):String {
        var callback:Function = function(cv:CustomVariable, i:int, a:Array):Boolean {
            return cv.slot == index && cv.scope == VISITOR_SCOPE
        };
        var res:Array = _variables.filter(callback);
        if (res.length > 0) {
            return res[0].value;
        }
        return null;
    }

    public function removeVariable(index:int):void {
        var callback:Function = function(cv:CustomVariable, i:int, a:Array):Boolean {
            return cv.slot != index
        };
        _variables = _variables.filter(callback);
    }

    public function removePageVariables():void {
        var callback:Function = function(cv:CustomVariable, i:int, a:Array):Boolean {
            return cv.scope != PAGE_SCOPE
        };
        _variables = _variables.filter(callback);
    }

    public function renderCookieString():String {
        var customVars:Array = [];
        for( var i:int = 0; i < _variables.length; i++ )
        {
            const customVar:CustomVariable = _variables[i];
            if (customVar.scope == VISITOR_SCOPE) {
                customVars.push(customVar.slot + "=" + customVar.name + "=" + customVar.value + "=" + customVar.scope);
            }
        }
        return customVars.join("^");
    }

    /**
     * Create instance of X10 to reuse X10 method renderUrlString to generate url string for custom variables
     * Example of url string: 8(name1*name2*test*5!name5)9(value*value2*value3*5!value5)11(1*1*2*5!1)
     */
    public function getX10():X10
    {
        var x10model:X10 = new X10();
        for( var i:int = 0; i < _variables.length; i++ )
        {
            const customVar:CustomVariable = _variables[i];
            x10model.setKey(NAMES_CODE, customVar.slot, customVar.name);
            x10model.setKey(VALUES_CODE, customVar.slot, customVar.value);
            // render only scope != PAGE_SCOPE
            if (customVar.scope != CustomVariables.PAGE_SCOPE) {
                x10model.setKey(SCOPES_CODE, customVar.slot, "" + customVar.scope);
            }
        }
        return x10model;
    }
}
}
