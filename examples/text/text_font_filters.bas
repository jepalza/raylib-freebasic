/'*******************************************************************************************
*
*   raylib [text] example - Font filters
*
*   After font loading, font texture atlas filter could be configured for a softer
*   display of the font when scaling it to different sizes, that way, it's not required
*   to generate multiple fonts at multiple sizes (as long as the scaling is not very different)
*
*   This example has been created using raylib 1.3.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2015 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [text] example - font filters" )

dim as string msg = "Loaded Font"

'' NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

'' TTF Font loading with custom generation parameters
dim as Font font = LoadFontEx( "resources/KAISG.ttf", 96, 0, 0 )

'' Generate mipmap levels to use trilinear filtering
'' NOTE: On 2D drawing it won't be noticeable, it looks like FILTER_BILINEAR
GenTextureMipmaps( @font.texture )

dim as single fontSize = font.baseSize
var fontPosition = Vector2( 40, screenHeight / 2 - 80 )
dim as Vector2 textSize

'' Setup texture scaling filter
SetTextureFilter( font.texture, TEXTURE_FILTER_POINT )
dim as long currentFontFilter = 0      '' FILTER_POINT

SetTargetFPS( 60 )

'' Main game loop
do while(WindowShouldClose()=0)
  '' Update
  fontSize += GetMouseWheelMove()  *4.0f

  '' Choose font texture filter method
  if( IsKeyPressed( KEY_ONE ) ) then
    SetTextureFilter( font.texture, TEXTURE_FILTER_POINT )
    currentFontFilter = 0
  elseif( IsKeyPressed( KEY_TWO ) ) then
    SetTextureFilter( font.texture, TEXTURE_FILTER_BILINEAR )
    currentFontFilter = 1
  elseif( IsKeyPressed( KEY_THREE ) ) then
    '' NOTE: Trilinear filter won't be noticed on 2D drawing
    SetTextureFilter( font.texture, TEXTURE_FILTER_TRILINEAR )
    currentFontFilter = 2
  end if
  
  textSize = MeasureTextEx( font, msg, fontSize, 0 )
  
  if( IsKeyDown( KEY_LEFT ) ) then
    fontPosition.x -= 10
  elseif( IsKeyDown( KEY_RIGHT ) ) then
    fontPosition.x += 10
  end if
  
  '' Load a dropped TTF file dynamically (at current fontSize)
  if( IsFileDropped() ) then
    dim as FilePathList droppedFiles = LoadDroppedFiles( )
    Print droppedFiles.paths[ 0 ]
    '' NOTE: We only support first ttf/otf file dropped
    if( IsFileExtension( droppedFiles.paths[ 0 ], ".ttf" ) orElse IsFileExtension( droppedFiles.paths[ 0 ], ".otf" ) ) then
      UnloadFont(font)
      font = LoadFontEx( droppedFiles.paths[ 0 ], fontSize, 0, 0 )
    end If
    UnloadDroppedFiles(droppedFiles)
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( "Use mouse wheel to change font size", 20, 20, 10, GRAY )
    DrawText( "Use KEY_RIGHT and KEY_LEFT to move text", 20, 40, 10, GRAY )
    DrawText( "Use 1, 2, 3 to change texture filter", 20, 60, 10, GRAY )
    DrawText( "Drop a new TTF font for dynamic loading", 20, 80, 10, DARKGRAY )

    DrawTextEx( font, msg, fontPosition, fontSize, 0, BLACK )

    '' TODO: It seems texSize measurement is not accurate due to chars offsets...
    ''DrawRectangleLines(fontPosition.x, fontPosition.y, textSize.x, textSize.y, RED);

    DrawRectangle( 0, screenHeight - 80, screenWidth, 80, LIGHTGRAY )
    DrawText( TextFormat( "Font size: %02.02f", fontSize ), 20, screenHeight - 50, 10, DARKGRAY )
    DrawText( TextFormat( "Text size: [%02.02f, %02.02f]", textSize.x, textSize.y ), 20, screenHeight - 30, 10, DARKGRAY )
    DrawText( "CURRENT TEXTURE FILTER:", 250, 400, 20, GRAY )

    if( currentFontFilter = 0 ) then
      DrawText( "POINT", 570, 400, 20, BLACK )
    elseif( currentFontFilter = 1 ) then
      DrawText( "BILINEAR", 570, 400, 20, BLACK )
    elseif( currentFontFilter = 2 ) then
      DrawText( "TRILINEAR", 570, 400, 20, BLACK )
    end if
  EndDrawing()
loop

'' De-Initialization
UnloadFont( font )

CloseWindow()
