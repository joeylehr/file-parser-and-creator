# file-parser-and-creator

Notes:
  - V1 (original_version.rb) parses the specific original files  (comma.txt, pipe.txt, space.txt). The methods (comma_file_parser, pipe_file_parser, space_file_parser) are hard-coded to read the content of each file. While the file successfully returns a file with all the consolidated information, there is no flexbility for the application to take in additional files.

  - V2 can take additional files as it loops through the entire "text_files" directory instead of having the file names being hard-coded into the methods. Additionally, the app can take a file that mixes all three formats (pipe, comma, space) within one file.

  - V2 adds a file number to each file that's created and places it into the Goal folder. 
  
  - The two text files that are currently in Goals folder are a result of running 'refactored_version.rb'. 

      -> The older folder was ran with the three original files. 

      -> The newer file, was ran with an additional file (added.txt) which proofs that the looping in V2 works as well as the parser being able to read 

Limitations:
  - If an additional file is added and the content doesn't follow one of the three formats originally listed, the program will break. V3 would offer more flexibility with the type of text file layout options.

  - Empty lines (returns) in the text files are an issue for the parser.

  - No error handling, in V3 errors would be added.

