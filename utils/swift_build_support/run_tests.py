#!/usr/bin/env python3

# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2020 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors


"""
Small script used to easily run the swift_build_support module unit tests.
"""


import os
import sys
import unittest


MODULE_DIR = os.path.abspath(os.path.dirname(__file__))
UTILS_DIR = os.path.abspath(os.path.join(MODULE_DIR, os.pardir))


if __name__ == '__main__':
    # Add the swift/utils directory to the Python path.
    sys.path.append(UTILS_DIR)

    # Discover all tests for the module.
    module_tests = unittest.defaultTestLoader.discover(MODULE_DIR)

    # Create and run test suite.
    suite = unittest.TestSuite()
    suite.addTests(module_tests)

    runner = unittest.TextTestRunner()
    result = runner.run(suite)

    sys.exit(not result.wasSuccessful())
