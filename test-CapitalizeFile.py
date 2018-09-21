import CapitalizeFile
import os
import unittest

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

if __name__ == '__main__':
    unittest.main()
