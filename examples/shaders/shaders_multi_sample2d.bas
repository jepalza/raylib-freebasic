/'*******************************************************************************************
*
*   raylib [shaders] example - Multiple sample2D with default batch system
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   This example has been created using raylib 3.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2020 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#if defined( PLATFORM_DESKTOP )
  #define GLSL_VERSION            330
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  #define GLSL_VERSION            100
#endif

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib - multiple sample2D" )

dim as Image imRed = GenImageColor( 800, 450, RLColor( 255, 0, 0, 255 ) )
dim as Texture texRed = LoadTextureFromImage( imRed )
UnloadImage( imRed )

dim as Image imBlue = GenImageColor( 800, 450, RLColor( 0, 0, 255, 255 ) )
dim as Texture texBlue = LoadTextureFromImage( imBlue )
UnloadImage( imBlue )

dim as Shader shader = LoadShader( 0, TextFormat("resources/shaders/glsl%i/color_mix.fs", GLSL_VERSION ) )

'' Get an additional sampler2D location to be enabled on drawing
dim as long texBlueLoc = GetShaderLocation( shader, "texture1" )

SetTargetFPS( 60 )

'' Main game loop
do while(WindowShouldClose()=0)
  '' Update
  ''----------------------------------------------------------------------------------
  '' ...
  ''----------------------------------------------------------------------------------
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginShaderMode( shader )
      '' WARNING: Additional samplers are enabled for all draw calls in the batch,
      '' EndShaderMode() forces batch drawing and consequently resets active textures
      '' to let other sampler2D to be activated on consequent drawings (if required)
      SetShaderValueTexture( shader, texBlueLoc, texBlue )
      
      '' We are drawing texRed using default sampler2D texture0 but
      '' an additional texture units is enabled for texBlue (sampler2D texture1)
      DrawTexture( texRed, 0, 0, WHITE )
    EndShaderMode()
  EndDrawing()
loop

'' De-Initialization
UnloadShader( shader )
UnloadTexture( texRed )
UnloadTexture( texBlue )

CloseWindow()
