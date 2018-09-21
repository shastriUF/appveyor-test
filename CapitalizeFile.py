import sys

def main():
    if (len(sys.argv) != 3):
        print ('Must provide an input and output file name!')
        return
    inputFileName = sys.argv[1]
    outputFileName = sys.argv[2]
    print ('Capitalizing', inputFileName)

    with open(inputFileName, 'r') as fileToRead:
        with open(outputFileName, 'w') as fileToWrite:
            fileToWrite.write(fileToRead.read().upper())            
            print ('Output written to', outputFileName)

if __name__ == "__main__": 
    main()