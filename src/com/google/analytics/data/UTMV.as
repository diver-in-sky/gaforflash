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
 *   Zwetan Kjukov <zwetan@gmail.com>.
 *   Marc Alcaraz <ekameleon@gmail.com>.
 *   Andrey Tereskin <tereskin@gmail.com>.
 */

package com.google.analytics.data
{

import com.google.analytics.utils.Timespan;
import com.google.analytics.log;
import core.Logger;

/* Urchin Tracking Module Cookie V.
       The user defined cookie.
       
       This cookie is not normally present in a default configuration of the tracking code.
       The __utmv cookie passes the information provided via the setCustomVariable() method and
       deprecated method setVar(), which you use to create a custom user segment.
       
       This string is then passed to the Analytics servers in the GIF request URL via the utmcc parameter.
       This cookie is only written if you have added the setCustomVariable() (or setVar()) method for the tracking
       code on your website page.
       
       expiration:
       2 years from set/update.
       
       format:
       __utmv=<domainHash>.<value>

       <value> := <var value>|<custom variables values>

       <custom variables values>:=<custom variable slot>=<customer variable name>=<custom variable value>=<scope of custom variable>

       <var value> - user defined by setVar() value, can be empty

       example: __utmv=133458700.|1=Registered=Yes=1^3=UserID=30666=1^4=Cookie=30666=1
     */
    public class UTMV extends UTMCookie
    {
        private var _log:Logger;

        private var _domainHash: Number; //0
        private var _varValue: String;      //1
        private var _customVars: CustomVariables;
        
        /**
         * Creates a new UTMV instance.
         */
        public function UTMV( domainHash:Number = NaN, value:String = "", custom:CustomVariables = null )
        {
            super( "utmv",
                   "__utmv",
                   ["domainHash","allVars"],
                   Timespan.twoyears * 1000 );

            LOG::P{ _log = log.tag( "UTMV" ); }

            _domainHash = domainHash;
            _varValue = value;
            _customVars = custom;
            update();
        }
              
        /**
         * The domain hash value.
         */
        public function get domainHash():Number
        {
            return _domainHash;
        }
        
        /**
        * @private
        */
        public function set domainHash( value:Number ):void
        {
            _domainHash = value;
            update();
        }

        /**
         * String value for deprecated varValue and concatenated custom variables values
         */
        public function get allVars():String
        {
            var res:String = _varValue;
            LOG::P{ _log.v( "allVars [_varValue=" + _varValue + " _customVars=" + ((_customVars)?_customVars.renderCookieString():"") + "]" ); }
            if (_customVars) {
                const rendered:String = _customVars.renderCookieString();
                if (rendered != "") {
                    res += "|" + _customVars.renderCookieString();
                }
            }
            return res;
        }

        /**
         * @private
         */
        public function set allVars(value:String):void
        {
            LOG::P{ _log.v( "allVars set [value=" + value + " length" + value.split("|", 2).length + "]" ); }
            var results:Array = value.split("|", 2);
            _customVars = new CustomVariables();
            if (results.length == 2) {
                _varValue = results[0];
                var varStrings:Array = results[1].split("^");
                LOG::P{ _log.v( "allVars set [results0=" + results[0] + " results1=" + results[1] + "]" ); }
                for each(var variable:String in varStrings) {
                    LOG::P{ _log.v( "allVars set [variable=" + variable + "]" ); }
                    var fields:Array = variable.split("=");
                    if (fields.length == 4)
                    {
                        const index:int = int(fields[0]);
                        const scope:int = int(fields[3]);
                        if ((index >= 1) && (index <= 5) && (scope == CustomVariables.VISITOR_SCOPE))
                        {
                            const custVar:CustomVariable = new CustomVariable(index, fields[1], fields[2], scope);
                            _customVars.setVariable(custVar);
                        }
                    }
                }
            }
            update();
        }

        /**
         * User defined value set with deprecated setVar method.
         */
        public function get varValue():String
        {
            return _varValue;
        }
        
        /**
        * @private
        */
        public function set varValue( value:String ):void
        {
            _varValue = value;
            update();
        }

        public function get customVars():CustomVariables
        {
            return _customVars;
        }

        public function set customVars(customVars:CustomVariables):void
        {
            _customVars = customVars;
            update();
        }
    }
}