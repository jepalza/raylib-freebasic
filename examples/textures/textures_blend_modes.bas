/'*******************************************************************************************
*
*   raylib [textures] example - blend modes
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   This example has been created using raylib 3.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Karlo Licudine (@accidentalrebel) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2020 Karlo Licudine (@accidentalrebel)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [textures] example - blend modes" )

'' NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
dim as Image bgImage = LoadImage( "resources/cyberpunk_street_background.png" )
dim as Texture2D bgTexture = LoadTextureFromImage( bgImage )

dim as Image fgImage = LoadImage( "resources/cyberpunk_street_foreground.png" )
dim as Texture2D fgTexture = LoadTextureFromImage( fgImage )

'' Once image has been converted to texture and uploaded to VRAM, it can be unloaded from RAM
UnloadImage( bgImage )   
UnloadImage( fgImage )

const as long blendCountMax = 4
dim as BlendMode blendModes = 0

'' Main game loop
do while(WindowShouldClose()=0)
  '' Update
  if( IsKeyPressed( KEY_SPACE ) ) then
    if( blendModes >= ( blendCountMax - 1 ) ) then blendModes = 0 else blendModes += 1
  end if
  
  '' Draw
  BeginDrawing()
      ClearBackground( RAYWHITE )

      DrawTexture( bgTexture, screenWidth / 2 - bgTexture.width_ / 2, screenHeight / 2 - bgTexture.height_ / 2, WHITE )

      '' Apply the blend mode and then draw the foreground texture
      BeginBlendMode( blendModes )
          DrawTexture( fgTexture, screenWidth / 2 - fgTexture.width_ / 2, screenHeight / 2 - fgTexture.height_ / 2, WHITE )
      EndBlendMode()

      '' Draw the texts
      DrawText( "Press SPACE to change blend modes.", 310, 350, 10, GRAY )
      
      select case as const ( blendModes )
        case BLEND_ALPHA : DrawText( "Current: BLEND_ALPHA", ( screenWidth / 2 ) - 60, 370, 10, GRAY )
        case BLEND_ADDITIVE : DrawText( "Current: BLEND_ADDITIVE", ( screenWidth / 2 ) - 60, 370, 10, GRAY )
        case BLEND_MULTIPLIED : DrawText( "Current: BLEND_MULTIPLIED", ( screenWidth / 2 ) - 60, 370, 10, GRAY )
        case BLEND_ADD_COLORS : DrawText( "Current: BLEND_ADD_COLORS", ( screenWidth / 2 ) - 60, 370, 10, GRAY )
      end select
      
      DrawText( "(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)", screenWidth - 330, screenHeight - 20, 10, GRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( fgTexture )
UnloadTexture( bgTexture )

CloseWindow()
