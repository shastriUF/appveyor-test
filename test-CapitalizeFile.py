import CapitalizeFile
import os
import sys
import unittest
from unittest.mock import patch

class TestCapitalization(unittest.TestCase):
    def testUnitTestAssert(self):
        self.assertEqual(1, 1)
    
    def testCapitalizeFile(self):
        with open('.inputFile', 'w') as inputFile:
            inputFile.write('Hello world!')
        CapitalizeFile.writeToFileInAllCaps('.inputFile', '.outputFile')
        with open('.outputFile', 'r') as outputFile:
            self.assertEqual(outputFile.read(), 'HELLO WORLD!')
        os.remove('.inputFile')
        os.remove('.outputFile')
    
    def testCallCapitalizeFileWithBadArguments(self):
        with patch.object(sys, 'argv', ["CapitalizeFile.py", "InputFile"]):
            with self.assertRaises(RuntimeError):
                CapitalizeFile.main()

if __name__ == '__main__':
    unittest.main()
