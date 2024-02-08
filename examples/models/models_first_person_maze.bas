/'*******************************************************************************************
*
*   raylib [models] example - first person maze
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2019 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "crt.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - first person maze" )

dim as Camera camera

with camera
  .position = Vector3( 0.2f, 0.4f, 0.2f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .projection = CAMERA_PERSPECTIVE
end with

dim as Image imMap = LoadImage( "resources/cubicmap.png" )
dim as Texture2D cubicmap = LoadTextureFromImage( imMap )

dim as Mesh mesh = GenMeshCubicmap( imMap, Vector3( 1.0f, 1.0f, 1.0f ) )
dim as Model model = LoadModelFromMesh( mesh )

'' NOTE: By default each cube is mapped to one part of texture atlas
dim as Texture2D texture = LoadTexture( "resources/cubicmap_atlas.png" )
model.materials[ 0 ].maps[ MATERIAL_MAP_DIFFUSE ].texture = texture

'' Get map image data to be used for collision detection
dim as RLColor ptr mapPixels = LoadImageColors( imMap )
UnloadImage( imMap )

var _
  mapPosition = Vector3( -16.0f, 0.0f, -8.0f ), _
  playerPosition = camera.position

'SetCameraMode( camera, CAMERA_FIRST_PERSON )

DisableCursor() ' Limit cursor to relative movement inside the Window

SetTargetFPS( 60 )

'' Main game loop
do while(WindowShouldClose()=0)
  '' Update
  var oldCamPos = camera.position
  
  UpdateCamera( @camera, CAMERA_FIRST_PERSON )
  
  '' Check player collision (we simplify to 2D collision detection)
  var playerPos = Vector2( camera.position.x, camera.position.z )
  '' Collision radius (player is modelled as a cilinder for collision)
  dim as single playerRadius = 0.1f
  
  dim as long _
    playerCellX = clng( playerPos.x - mapPosition.x + 0.5f ), _
    playerCellY = clng( playerPos.y - mapPosition.z + 0.5f )
  
  '' Out-of-limits security check
  if( playerCellX < 0 ) then
    playerCellX = 0
  elseif( playerCellX >= cubicmap.width_ ) then
    playerCellX = cubicmap.width_ - 1
  end if
  
  if( playerCellY < 0 ) then
    playerCellY = 0
  elseif( playerCellY >= cubicmap.height_ ) then
    playerCellY = cubicmap.height_ - 1
  end if
  
  '' Check map collisions using image data and player position
  '' TODO: Improvement: Just check player surrounding cells for collision
  for y as integer = 0 to cubicmap.height_ - 1
    for x as integer = 0 to cubicmap.width_ - 1
      if( ( mapPixels[ y * cubicmap.width_ + x ].r = 255 ) andAlso _ '' Collision: white pixel, only check R channel
        ( CheckCollisionCircleRec( playerPos, playerRadius, _
        Rectangle( mapPosition.x - 0.5f + x * 1.0f, mapPosition.z - 0.5f + y * 1.0f, 1.0f, 1.0f ) ) ) ) then
        
        '' Collision detected, reset camera position
        camera.position = oldCamPos
      end if
    next
  next
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawModel( model, mapPosition, 1.0f, WHITE )
    EndMode3D()
    
    DrawTextureEx( cubicmap, Vector2( GetScreenWidth() - cubicmap.width_ * 4 - 20, 20 ), 0.0f, 4.0f, WHITE )
    DrawRectangleLines( GetScreenWidth() - cubicmap.width_ * 4 - 20, 20, cubicmap.width_ * 4, cubicmap.height_ * 4, GREEN )
    
    '' Draw player position radar
    DrawRectangle( GetScreenWidth() - cubicmap.width_ * 4 - 20 + playerCellX * 4, 20 + playerCellY * 4, 4, 4, RED )
    
    DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
'' TODO: freeing this causes a crash!
'free( mapPixels )

UnloadTexture( cubicmap )
UnloadTexture( texture )
UnloadModel( model )

CloseWindow()
