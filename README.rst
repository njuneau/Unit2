HaXe Unit2 Test framework
===============

Description
-----------------

This is a modification of haXe's unit testing framework. Unit2 makes use of
class metadata_ in its test runners instead on relying on method names in order
to detect test methods.

Unit2 also redefines how the test results are written out. Unit2 makes use of
"output writers" that lets the user easily implement his own way of outputting
its test results. For example, one might define an output writer that writes
HTML instead of plain text.

The assertion mechanism has also changed. Unit2 lets the TestRunner manage
errors - hence, any status management is moved out of the TestCase class.
Assertions now throw exceptions that can be caught by the TestRunner in order to
detect errors.

How to use
-----------------

Package inclusion
~~~~~~~~~~~~~~~~~~~~~~

The core framework is located inside the ``haxe.unit2 package``. The
``haxe.unit2.tests`` sub-package only contains the framework's test suite
(which is written using the original haXe unit testing packages). The ``tests``
sub-package is purely optional for running tests using Unit2.

By including the ``haxe.unit2`` package in your projects, you'll be able to use
Unit2.

Writing a simple test suite
~~~~~~~~~~~~~~~~~~~~~~

Start by creating a class that extends ``haxe.unit2.TestCase``. This class will
hold your test case's unit tests. Add the ``@Test`` metadata tag to every
method you want executed by the test runner as a test case. You can also
redefine the "prepare", "setup" and "tearDown" methods, which are called by the
TestRunner at specific times (refer to the method documentation).

Once your test case is ready, create a new ``TestRunner`` instance and include
add an instance of your test case class into it. Once you added all your test
cases, run the test runner.

Once the test runner has finished running, you can use an ``OutputWriter`` to
view the results. Unit2 ships with a default text-based ``OutputWriter``. Create
a ``haxe.unit2.output.TextOutputWriter`` instance and execute the
``writeResults`` method with your test runner as a parameter. This will return
a text formatted test report. You are free to output that string in the way you
want. For example, you can print it in the console, trace it or even display a
Web page with the results in it.

Future work
-----------------

As of now, only test methods are detected with metadata tags. In future
versions, tags could also be used to detect the ``prepare``, ``setup`` and
``tearDown`` methods. This way, the user could choose how to name them.

Also, the default ``TestRunner`` requires the user to call his test case's
constructors in order to add them to the ``TestRunner``. The ``TestRunner``
could take care of the construction, which would allow it to detect errors at
construction.


.. _metadata: http://haxe.org/manual/metadata