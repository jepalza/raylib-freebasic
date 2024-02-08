/'*******************************************************************************************
*
*   raylib [models] example - Heightmap loading and drawing
*
*   This example has been created using raylib 1.8 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2015 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - heightmap loading and drawing" )

'' Define our custom camera to look into our 3d world
dim as Camera camera

with camera 
  .position = Vector3( 18.0f, 18.0f, 18.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .projection = CAMERA_PERSPECTIVE
end with

dim as Image image = LoadImage( "resources/heightmap.png" )
dim as Texture2D texture = LoadTextureFromImage( image )

dim as Mesh mesh = GenMeshHeightmap( image, Vector3( 16, 8, 16  ) )
dim as Model model = LoadModelFromMesh( mesh )

model.materials[ 0 ].maps[ MATERIAL_MAP_DIFFUSE ].texture = texture
var mapPosition = Vector3( -8.0f, 0.0f, -8.0f )

UnloadImage( image )

'SetCameraMode( camera, CAMERA_ORBITAL )

SetTargetFPS( 60 )

'' Main game loop
do while(WindowShouldClose()=0)
    '' Update
    UpdateCamera( @camera, CAMERA_ORBITAL )
    
    '' Draw
    BeginDrawing()
        ClearBackground( RAYWHITE )
        
        BeginMode3D( camera )
          DrawModel( model, mapPosition, 1.0f, RED )
          DrawGrid( 20, 1.0f )
        EndMode3D()
        
        DrawTexture( texture, screenWidth - texture.width_ - 20, 20, WHITE )
        DrawRectangleLines( screenWidth - texture.width_ - 20, 20, texture.width_, texture.height_, GREEN )
        
        DrawFPS( 10, 10 )
    EndDrawing()
loop

'' De-Initialization
UnloadTexture( texture )
UnloadModel( model )

CloseWindow()
