package haxe.unit2.tests;

import haxe.unit.TestCase;
import haxe.unit2.tests.mocks.MockTestCase1;
import haxe.unit2.output.TextOutputWriter;

class TextOutputWriterTest extends TestCase {

    public function testTextOutputWriter() : Void {
        var mockTestCase : TestCase = new MockTestCase1();
        var outputWriter : TextOutputWriter = new TextOutputWriter();
        var result : String = outputWriter.writeResults(mockTestCase);
    }

}