import sys

def writeToFileInAllCaps(fileNameToRead, fileNameToWrite):
    print ('Capitalizing', fileNameToRead)
    with open(fileNameToRead, 'r') as fileToRead:
        with open(fileNameToWrite, 'w') as fileToWrite:
            fileToWrite.write(fileToRead.read().upper())
            print ('Output written to', fileNameToWrite)

def main():
    if (len(sys.argv) != 3):
        print ('Must provide an input and output file name!')
        return
    writeToFileInAllCaps(sys.argv[1], sys.argv[2])

if __name__ == "__main__": 
    main()