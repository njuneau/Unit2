Haxe Unit2 Test framework
===============

Description
-----------------

This is a modification of Haxe's unit testing framework. Unit2 makes use of
class metadata_ in its test runners instead of relying on method names in order
to detect test methods. It is inspired by JUnit_'s way of working.

Unit2 also redefines how the test results are written out. Unit2 makes use of
"output writers" that lets the user easily implement his own way of outputting
the test results. For example, one might define an output writer that writes
HTML instead of plain text.

The assertion mechanism has also changed. Unit2 lets the TestRunner manage
errors - hence, any status management is moved out of the TestCase class.
Assertions now throw exceptions that can be caught by the TestRunner in order to
detect errors.

How to use
-----------------

Package inclusion
~~~~~~~~~~~~~~~~~~~~~~

The core framework is located inside the ``unit2`` package. The
``unit2.tests`` sub-package only contains the framework's test suite
(which is written using the original Haxe unit testing packages). The ``tests``
sub-package is purely optional for running tests using Unit2.

By including the ``unit2`` package in your projects, you'll be able to use
Unit2.

Writing a simple test suite
~~~~~~~~~~~~~~~~~~~~~~

Start by creating a class that extends ``unit2.TestCase``. This class will
hold your test case's unit tests. Add the ``@Test`` metadata tag to every
method you want executed by the test runner as a test.

You may also use the ``@Before`` and ``@After`` tags to annotate methods that
will be executed, respectively, before and after each test method. The can only
be one of each.

You may also use the ``@BeforeClass`` and ``@AfterClass`` tags to annotate
methods that will be executed, respectively, before and after all the tests
methods are ran (in a constructor/destructor fashion).

Once your test case is ready, create a new ``TestRunner`` instance and
add your test case class into it. Once you added all your test
cases, run the test runner.

Once the test runner has finished running, you can use an ``OutputWriter`` to
view the results. Unit2 ships with a default text-based ``OutputWriter``. Create
a ``unit2.output.TextOutputWriter`` instance and execute the
``writeResults`` method with your test runner as a parameter. This will return
a text formatted test report. You are free to output that string in the way you
want. For example, you can print it in the console, trace it or even display a
Web page with the results in it.

Copyright information
-----------------

Some of the framework's files were taken directly from Haxe 2's source code.
Although these files are now modified, they retain the copyright notices of the
original files.

.. _metadata: http://haxe.org/manual/metadata
.. _JUnit: http://junit.sourceforge.net/
