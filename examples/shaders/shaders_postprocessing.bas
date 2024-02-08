/'*******************************************************************************************
*
*   raylib [shaders] example - Apply a postprocessing shader to a scene
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   This example has been created using raylib 1.3 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2015 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include "../raylib.bi"

#if defined( PLATFORM_DESKTOP )
  #define GLSL_VERSION            330
#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
  #define GLSL_VERSION            100
#endif

#define MAX_POSTPRO_SHADERS         12

enum PostproShader
  FX_GRAYSCALE = 0
  FX_POSTERIZATION
  FX_DREAM_VISION
  FX_PIXELIZER
  FX_CROSS_HATCHING
  FX_CROSS_STITCHING
  FX_PREDATOR_VIEW
  FX_SCANLINES
  FX_FISHEYE
  FX_SOBEL
  FX_BLOOM
  FX_BLUR
  ''FX_FXAA
end enum

dim as const string postproShaderText( ... ) = { _
  "GRAYSCALE", _
  "POSTERIZATION", _
  "DREAM_VISION", _
  "PIXELIZER", _
  "CROSS_HATCHING", _
  "CROSS_STITCHING", _
  "PREDATOR_VIEW", _
  "SCANLINES", _
  "FISHEYE", _
  "SOBEL", _
  "BLOOM", _
  "BLUR" _
  _ ''"FXAA"
}

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

SetConfigFlags( FLAG_MSAA_4X_HINT )

InitWindow( screenWidth, screenHeight, "raylib [shaders] example - postprocessing shader" )

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 2.0f, 3.0f, 2.0f )
  .target = Vector3( 0.0f, 1.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .projection = CAMERA_PERSPECTIVE
end with

dim as Model model = LoadModel( "resources/models/church.obj" )
dim as Texture2D texture = LoadTexture( "resources/models/church_diffuse.png" )
model.materials[ 0 ].maps[ MATERIAL_MAP_DIFFUSE ].texture = texture

dim as Vector3 position

'' Load all postpro shaders
'' NOTE 1: All postpro shader use the base vertex shader (DEFAULT_VERTEX_SHADER)
'' NOTE 2: We load the correct shader depending on GLSL version
dim as Shader shaders( 0 to MAX_POSTPRO_SHADERS - 1 )

shaders( FX_GRAYSCALE ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/grayscale.fs", GLSL_VERSION ) )
shaders( FX_POSTERIZATION ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/posterization.fs", GLSL_VERSION ) )
shaders( FX_DREAM_VISION ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/dream_vision.fs", GLSL_VERSION ) )
shaders( FX_PIXELIZER ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/pixelizer.fs", GLSL_VERSION ) )
shaders( FX_CROSS_HATCHING ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/cross_hatching.fs", GLSL_VERSION ) )
shaders( FX_CROSS_STITCHING ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/cross_stitching.fs", GLSL_VERSION ) )
shaders( FX_PREDATOR_VIEW ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/predator.fs", GLSL_VERSION ) )
shaders( FX_SCANLINES ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/scanlines.fs", GLSL_VERSION ) )
shaders( FX_FISHEYE ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/fisheye.fs", GLSL_VERSION ) )
shaders( FX_SOBEL ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/sobel.fs", GLSL_VERSION ) )
shaders( FX_BLOOM ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/bloom.fs", GLSL_VERSION ) )
shaders( FX_BLUR ) = LoadShader( 0, TextFormat( "resources/shaders/glsl%i/blur.fs", GLSL_VERSION ) )

dim as long currentShader = FX_GRAYSCALE

'' Create a RenderTexture2D to be used for render to texture
dim as RenderTexture2D target = LoadRenderTexture( screenWidth, screenHeight )

'SetCameraMode( camera, CAMERA_ORBITAL )

SetTargetFPS( 60 )

'' Main game loop
do while(WindowShouldClose()=0)
  '' Update
  UpdateCamera( @camera, CAMERA_ORBITAL )

  if( IsKeyPressed( KEY_RIGHT ) ) then
    currentShader += 1
  elseif( IsKeyPressed( KEY_LEFT ) ) then
    currentShader -= 1
  end if
  
  if( currentShader >= MAX_POSTPRO_SHADERS ) then
    currentShader = 0
  elseif( currentShader < 0 ) then
    currentShader = MAX_POSTPRO_SHADERS - 1
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginTextureMode( target )
      ClearBackground( RAYWHITE )
      
      BeginMode3D( camera )
        DrawModel( model, position, 0.1f, WHITE )
        DrawGrid( 10, 1.0f )
      EndMode3D()
    EndTextureMode()  '' End drawing to texture (now we have a texture available for next passes)
    
    '' Render previously generated texture using selected postpro shader
    BeginShaderMode( shaders( currentShader) )
      '' NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
      DrawTextureRec( target.texture, Rectangle( 0, 0, target.texture.width_, -target.texture.height_ ), Vector2( 0, 0 ), WHITE )
    EndShaderMode()
    
    '' Draw 2d shapes and text over drawn texture
    DrawRectangle( 0, 9, 580, 30, Fade( LIGHTGRAY, 0.7f ) )
    
    DrawText( "(c) Church 3D model by Alberto Cano", screenWidth - 200, screenHeight - 20, 10, GRAY )
    
    DrawText( "CURRENT POSTPRO SHADER:", 10, 15, 20, BLACK )
    DrawText( postproShaderText( currentShader ), 330, 15, 20, RED )
    DrawText( "< >", 540, 10, 30, DARKBLUE )
    
    DrawFPS( 700, 15 )
  EndDrawing()
loop

'' De-Initialization

'' Unload all postpro shaders
for i as integer = 0 to MAX_POSTPRO_SHADERS - 1
  UnloadShader( shaders( i ) )
next

UnloadTexture( texture )
UnloadModel( model )
UnloadRenderTexture( target )

CloseWindow()
