/'*******************************************************************************************
*
*   raylib [core] example - Windows drop files
*
*   This example only works on platforms that support drag & drop (Windows, Linux, OSX, Html5?)
*
*   This example has been created using raylib 1.3 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2015 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MAX_FILEPATH_RECORDED   4096
#define MAX_FILEPATH_SIZE       2048

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [core] example - drop files" )

dim as long filePathCounter = 0
Dim As ZString Ptr filePaths(MAX_FILEPATH_RECORDED)' We will register a maximum of filepaths

' Allocate space for the required file paths
for i As Integer=0 to MAX_FILEPATH_RECORDED-1
  filePaths(i) = Cast(ZString Ptr,allocate(MAX_FILEPATH_SIZE))
Next

SetTargetFPS( 60 )

'' Main game loop
do while( WindowShouldClose()=0)
	
  if( IsFileDropped() ) Then
  	Dim as FilePathList droppedFiles = LoadDroppedFiles( )
   Dim As Integer offset 
   offset = filePathCounter
   for i As integer= 0 to droppedFiles.count-1
       if (filePathCounter < (MAX_FILEPATH_RECORDED - 1)) Then
           TextCopy(filePaths(offset + i), droppedFiles.paths[i])
           filePathCounter+=1
       EndIf
   next

   UnloadDroppedFiles(droppedFiles) ' Unload filepaths from memory
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground(RAYWHITE)
    
    if( filePathCounter = 0 ) then
      DrawText( "Drop your files to this window!", 100, 40, 20, DARKGRAY )
    else
      DrawText( "Dropped files:", 100, 40, 20, DARKGRAY )
      
      for i as integer = 0 to filePathCounter - 1
        if( i mod 2 = 0 ) then
          DrawRectangle( 0, 85 + 40 * i, screenWidth, 40, Fade( LIGHTGRAY, 0.5f ) )
        else
          DrawRectangle( 0, 85 + 40 * i, screenWidth, 40, Fade( LIGHTGRAY, 0.3f ) )
        end If
        DrawText( *filePaths(i), 120, 100 + 40 * i, 10, GRAY )
      next
      
      DrawText( "Drop new files...", 100, 110 + 40 * filePathCounter, 20, DARKGRAY )
    end if
  EndDrawing()
loop

'' De-Initialization
    for i As integer = 0 to MAX_FILEPATH_RECORDED-1
        Delete (filePaths(i)) ' Free allocated memory for all filepaths
    Next
    
CloseWindow()
