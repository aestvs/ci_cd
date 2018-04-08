
# Define a configuration

Configuration HelloWorldConfig 

{

       Node localhost 

       {

              File TestFile {

                     Ensure = "Present"

                     DestinationPath = "c:\temp\HelloWorld.txt"

                     Contents = "Hello World!"

              }

       }

}

# Apply configuration 

HelloWorldConfig 

Start-DscConfiguration -Wait -Verbose -Path .\HelloWorldConfig