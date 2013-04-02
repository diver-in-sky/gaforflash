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
 */

package com.google.analytics.data
{
	import library.ASTUce.framework.TestCase;
    
    import flash.utils.getTimer;
    
    public class CustomVariablesTest extends TestCase
    {
        public function CustomVariablesTest(name:String="")
        {
            super(name);
        }

        public function testSetCustomVar():void
        {
            var cv:CustomVariables = new CustomVariables();

            cv.setVariable(new CustomVariable(1, "test_name", "test_val", CustomVariables.VISITOR_SCOPE));
            assertEquals("1=test_name=test_val=1", cv.renderCookieString());
            assertEquals(1, cv.getVariables().length);

            // add variable to new slot
            cv.setVariable(new CustomVariable(2, "test_name2", "test_val2", CustomVariables.VISITOR_SCOPE));
            assertEquals(2, cv.getVariables().length);

            // replace variable in occupied slot
            cv.setVariable(new CustomVariable(1, "test_name1", "test_val1", CustomVariables.VISITOR_SCOPE));
            assertEquals(2, cv.getVariables().length);
        }

        public function testGetVisitorCustomVar():void
        {
            var cv:CustomVariables = new CustomVariables();

            cv.setVariable(new CustomVariable(1, "test_name1", "test_val1", CustomVariables.VISITOR_SCOPE));
            cv.setVariable(new CustomVariable(2, "test_name2", "test_val2", CustomVariables.PAGE_SCOPE));

            assertEquals("test_val1", cv.getVisitorCustomVar(1));
            assertEquals(null, cv.getVisitorCustomVar(2));
        }

        public function testRemoveVariable():void
        {
            var cv:CustomVariables = new CustomVariables();

            cv.setVariable(new CustomVariable(1, "test_name", "test_val", CustomVariables.VISITOR_SCOPE));
            assertEquals(1, cv.getVariables().length);

            cv.removeVariable(2);
            assertEquals(1, cv.getVariables().length);

            cv.removeVariable(1);
            assertEquals(0, cv.getVariables().length);
        }

        public function testRemovePageVariables():void
        {
            var cv:CustomVariables = new CustomVariables();

            cv.setVariable(new CustomVariable(1, "test_name", "test_val", CustomVariables.VISITOR_SCOPE));
            cv.setVariable(new CustomVariable(2, "test_name", "test_val", CustomVariables.PAGE_SCOPE));

            assertEquals(2, cv.getVariables().length);

            cv.removePageVariables();
            assertEquals(1, cv.getVariables().length);
            assertEquals(CustomVariables.VISITOR_SCOPE, cv.getVariables()[0].scope);
        }

        public function testUrlString():void
        {
            var cv:CustomVariables = new CustomVariables();

            cv.setVariable(new CustomVariable(1, "name1", "value1", CustomVariables.VISITOR_SCOPE));
            cv.setVariable(new CustomVariable(3, "name2", "value2", CustomVariables.PAGE_SCOPE));
            cv.setVariable(new CustomVariable(5, "name3", "value3", CustomVariables.SESSION_SCOPE));

            assertEquals("8(name1*3!name2*5!name3)9(value1*3!value2*5!value3)11(1*5!2)", cv.getX10().renderUrlString());
        }

    }
}