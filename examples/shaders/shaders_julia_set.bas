/'*******************************************************************************************
*
*   raylib [shaders] example - julia sets
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by eggmund (@eggmund) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 eggmund (@eggmund) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'#if defined( PLATFORM_DESKTOP )
  #Define GLSL_VERSION            330
'#else   '' PLATFORM_RPI, PLATFORM_ANDROID, PLATFORM_WEB
'  #define GLSL_VERSION            100
'#endif

'' A few good julia sets
dim as const single POINTS_OF_INTEREST( 0 to 5, 0 to 1 ) = _
{ _
    { -0.348827, 0.607167 }, _
    { -0.786268, 0.169728 }, _
    { -0.8, 0.156 }, _
    { 0.285, 0.0 }, _
    { -0.835, -0.2321 }, _
    { -0.70176, -0.3842 } _
}

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [shaders] example - julia sets" )

'' Load julia set shader
'' NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
dim as Shader shader = LoadShader( 0, TextFormat("resources/shaders/glsl%i/julia_set.fs", GLSL_VERSION ) )

'' c constant to use in z^2 + c
dim as single c( 0 to 1 ) = { POINTS_OF_INTEREST( 0, 0 ), POINTS_OF_INTEREST( 0, 1 ) }

'' Offset and zoom to draw the julia set at. (centered on screen and default size)
dim as single offset( 0 to 1 ) = { -screenWidth / 2, -screenHeight / 2 }
dim as single zoom = 1.0f

dim as Vector2 offsetSpeed

'' Get variable (uniform) locations on the shader to connect with the program
'' NOTE: If uniform variable could not be found in the shader, function returns -1
dim as long _
  cLoc = GetShaderLocation( shader, "c" ), _
  zoomLoc = GetShaderLocation( shader, "zoom" ), _
  offsetLoc = GetShaderLocation( shader, "offset" )

'' Tell the shader what the screen dimensions, zoom, offset and c are
dim as single screenDims( 0 to 1 ) = { screenWidth, screenHeight }
SetShaderValue( shader, GetShaderLocation( shader, "screenDims" ), @screenDims( 0 ), SHADER_UNIFORM_VEC2 )

SetShaderValue( shader, cLoc, @c( 0 ), SHADER_UNIFORM_VEC2 )
SetShaderValue( shader, zoomLoc, @zoom, SHADER_UNIFORM_FLOAT )
SetShaderValue( shader, offsetLoc, @offset( 0 ), SHADER_UNIFORM_VEC2 )

'' Create a RenderTexture2D to be used for render to texture
dim as RenderTexture2D target = LoadRenderTexture( screenWidth, screenHeight )

dim as long incrementSpeed = 0        '' Multiplier of speed to change c value
dim as boolean showControls = true    '' Show controls
dim as boolean pause = false          '' Pause animation

SetTargetFPS( 60 )

'' Main game loop
do while(WindowShouldClose()=0)
  '' Update
  '' Press [1 - 6] to reset c to a point of interest
  if( IsKeyPressed( KEY_ONE ) orElse _
      IsKeyPressed( KEY_TWO ) orElse _
      IsKeyPressed( KEY_THREE ) orElse _
      IsKeyPressed( KEY_FOUR ) orElse _
      IsKeyPressed( KEY_FIVE ) orElse _
      IsKeyPressed( KEY_SIX ) ) then
      
    if( IsKeyPressed(KEY_ONE)) then
      c( 0 ) = POINTS_OF_INTEREST( 0, 0 ) : c( 1 ) = POINTS_OF_INTEREST( 0, 1 )
    elseif( IsKeyPressed( KEY_TWO ) ) then
      c( 0 ) = POINTS_OF_INTEREST( 1, 0 ) : c( 1 ) = POINTS_OF_INTEREST( 1, 1 )
    elseif( IsKeyPressed( KEY_THREE ) ) then
      c( 0 ) = POINTS_OF_INTEREST( 2, 0 ) : c( 1 ) = POINTS_OF_INTEREST( 2, 1 )
    elseif( IsKeyPressed( KEY_FOUR ) ) then
      c( 0 ) = POINTS_OF_INTEREST( 3, 0 ) : c( 1 ) = POINTS_OF_INTEREST( 3, 1 )
    elseif( IsKeyPressed( KEY_FIVE ) ) then
      c( 0 ) = POINTS_OF_INTEREST( 4, 0 ) : c( 1 ) = POINTS_OF_INTEREST( 4, 1 )
    elseif( IsKeyPressed( KEY_SIX ) ) then
      c( 0 ) = POINTS_OF_INTEREST( 5, 0 ) : c( 1 ) = POINTS_OF_INTEREST( 5, 1 )
    end if
    
    SetShaderValue( shader, cLoc, @c( 0 ), SHADER_UNIFORM_VEC2 )
  end if
  
  if( IsKeyPressed( KEY_SPACE ) ) then pause xor= true '' Pause animation (c change)
  if( IsKeyPressed( KEY_F1 ) ) then showControls xor= true  '' Toggle whether or not to show controls
  
  if( not pause ) then
    if( IsKeyPressed( KEY_RIGHT ) ) then
      incrementSpeed += 1
    elseif( IsKeyPressed( KEY_LEFT ) ) then
      incrementSpeed -= 1
    end if
    
    '' TODO: The idea is to zoom and move around with mouse
    '' Probably offset movement should be proportional to zoom level
    if( IsMouseButtonDown( MOUSE_LEFT_BUTTON ) orElse IsMouseButtonDown( MOUSE_RIGHT_BUTTON ) ) then
      if( IsMouseButtonDown( MOUSE_LEFT_BUTTON ) ) then zoom += zoom * 0.003f
      if( IsMouseButtonDown( MOUSE_RIGHT_BUTTON ) ) then zoom -= zoom * 0.003f
      
      dim as Vector2 mousePos = GetMousePosition()
      
      offsetSpeed.x = mousePos.x -screenWidth / 2
      offsetSpeed.y = mousePos.y -screenHeight / 2
      
      '' Slowly move camera to targetOffset
      offset( 0 ) += GetFrameTime() * offsetSpeed.x * 0.8f
      offset( 1 ) += GetFrameTime() * offsetSpeed.y * 0.8f
    else
      offsetSpeed = Vector2( 0.0f, 0.0f )
    end if
    
    SetShaderValue( shader, zoomLoc, @zoom, SHADER_UNIFORM_FLOAT )
    SetShaderValue( shader, offsetLoc, @offset( 0 ), SHADER_UNIFORM_VEC2 )
    
    '' Increment c value with time
    dim as single amount = GetFrameTime() * incrementSpeed * 0.0005f
    c( 0 ) += amount
    c( 1 ) += amount
    
    SetShaderValue( shader, cLoc, @c( 0 ), SHADER_UNIFORM_VEC2 )
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( BLACK )
    
    '' Using a render texture to draw Julia set
    BeginTextureMode( target )
      ClearBackground( BLACK )
      
      '' Draw a rectangle in shader mode to be used as shader canvas
      '' NOTE: Rectangle uses font white character texture coordinates,
      '' so shader can not be applied here directly because input vertexTexCoord
      '' do not represent full screen coordinates (space where want to apply shader)
      DrawRectangle( 0, 0, GetScreenWidth(), GetScreenHeight(), BLACK )
    EndTextureMode()
    
    '' Draw the saved texture and rendered julia set with shader
    '' NOTE: We do not invert texture on Y, already considered inside shader
    BeginShaderMode( shader )
      DrawTexture( target.texture, 0, 0, WHITE )
    EndShaderMode()
    
    if( showControls ) then
      DrawText( "Press Mouse buttons right/left to zoom in/out and move", 10, 15, 10, RAYWHITE )
      DrawText( "Press KEY_F1 to toggle these controls", 10, 30, 10, RAYWHITE )
      DrawText( "Press KEYS [1 - 6] to change point of interest", 10, 45, 10, RAYWHITE )
      DrawText( "Press KEY_LEFT | KEY_RIGHT to change speed", 10, 60, 10, RAYWHITE )
      DrawText( "Press KEY_SPACE to pause movement animation", 10, 75, 10, RAYWHITE )
    end if
  EndDrawing()
loop

'' De-Initialization
UnloadShader( shader )
UnloadRenderTexture( target )

CloseWindow()
