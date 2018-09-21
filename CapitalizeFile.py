import sys

def main():
    if (len(sys.argv) != 3):
        print ('Must provide an input and output file name!')
        return
    inputFileName = sys.argv[1]
    outputFileName = sys.argv[2]
    print ('Capitalizing', inputFileName)

    fileToRead = open(inputFileName, 'r')
    fileToWrite = open(outputFileName, 'w')
    
    for l in fileToRead:
        fileToWrite.write(l.upper())
    
    print ('Output written to', outputFileName)
    fileToWrite.close()
    fileToRead.close()

if __name__ == "__main__": 
    main()