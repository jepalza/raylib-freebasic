/'*******************************************************************************************
*
*   raylib [shapes] example - Draw raylib logo using basic shapes
*
*   This example has been created using raylib 1.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [shapes] example - raylib logo using shapes" )

SetTargetFPS( 60 )

'' Main game loop
do while(WindowShouldClose()=0)
  '' Update
  ''----------------------------------------------------------------------------------
  '' TODO: Update your variables here
  ''----------------------------------------------------------------------------------
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )

    DrawRectangle( screenWidth / 2 - 128, screenHeight / 2 - 128, 256, 256, BLACK )
    DrawRectangle( screenWidth / 2 - 112, screenHeight / 2 - 112, 224, 224, RAYWHITE )
    DrawText( "raylib", screenWidth / 2 - 44, screenHeight / 2 + 48, 50, BLACK )

    DrawText( "this is NOT a texture!", 350, 370, 10, GRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
