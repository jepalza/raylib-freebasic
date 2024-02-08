/'*******************************************************************************************
*
*   raylib [core] example - 3d camera first person
*
*   This example has been created using raylib 1.3 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2015 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MAX_COLUMNS 20

'' Initialization
const as long screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [core] example - 3d camera first person" )

dim as Camera camera

with camera
  .position = Vector3( 4.0f, 2.0f, 4.0f )
  .target = Vector3( 0.0f, 1.8f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 60.0f
  .projection = CAMERA_PERSPECTIVE
end with

'' Generates some random columns
dim as single heights( 0 to MAX_COLUMNS - 1 )
dim as Vector3 positions( 0 to MAX_COLUMNS - 1 )

dim as RLColor colours( 0 to MAX_COLUMNS - 1 )

for i as integer = 0 to MAX_COLUMNS - 1
  heights( i ) = GetRandomValue( 1, 12 )
  positions( i ) = Vector3( GetRandomValue( -15, 15 ), heights( i ) / 2, GetRandomValue( -15, 15 ) )
  colours( i ) = RLColor( GetRandomValue( 20, 255 ), GetRandomValue( 10, 55 ), 30, 255 )
next

''SetCameraMode( camera, CAMERA_FIRST_PERSON ) ' despreciado en la V5.0, usar UPDATECAMERA

SetTargetFPS( 60 )

DisableCursor() ' limita el cursor a la ventana, y evitar que pierda movimiento al salir

'' Main game loop
do while WindowShouldClose()=0
  '' Update
  UpdateCamera( @camera, CAMERA_FIRST_PERSON  ) ' en la v5.0 usamos esta en lugar de setcameramode
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawPlane( Vector3( 0.0f, 0.0f, 0.0f ), Vector2( 32.0f, 32.0f ), LIGHTGRAY ) '' Draw ground
      DrawCube( Vector3( -16.0f, 2.5f, 0.0f ), 1.0f, 5.0f, 32.0f, BLUE )     '' Draw a blue wall
      DrawCube( Vector3( 16.0f, 2.5f, 0.0f ), 1.0f, 5.0f, 32.0f, LIME )      '' Draw a green wall
      DrawCube( Vector3( 0.0f, 2.5f, 16.0f ), 32.0f, 5.0f, 1.0f, GOLD )      '' Draw a yellow wall
      
      '' Draw some cubes around
      for i as integer = 0 to MAX_COLUMNS - 1
        DrawCube( positions( i ), 2.0f, heights( i ), 2.0f, colours( i ) )
        DrawCubeWires( positions( i ), 2.0f, heights( i ), 2.0f, MAROON )
      next
    EndMode3D()
    
    DrawRectangle( 10, 10, 220, 70, Fade( SKYBLUE, 0.5f ) )
    DrawRectangleLines( 10, 10, 220, 70, BLUE )
    
    DrawText( "First person camera default controls:", 20, 20, 10, BLACK )
    DrawText( "- Move with keys: W, A, S, D", 40, 40, 10, DARKGRAY )
    DrawText( "- Mouse move to look around", 40, 60, 10, DARKGRAY )
  EndDrawing()
loop

'' De-Initialization
CloseWindow()
