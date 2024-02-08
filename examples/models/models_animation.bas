/'*******************************************************************************************
*
*   raylib [models] example - Load 3d model with animations and play them
*
*   This example has been created using raylib 2.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Example contributed by Culacant (@culacant) and reviewed by Ramon Santamaria (@raysan5)
*
*   Copyright (c) 2019 Culacant (@culacant) and Ramon Santamaria (@raysan5)
*
********************************************************************************************
*
* To export a model from blender, make sure it is not posed, the vertices need to be in the 
* same position as they would be in edit mode.
* and that the scale of your models is set to 0. Scaling can be done from the export menu.
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - model animation" )

'' Define the camera to look into our 3d world
dim as Camera camera

with camera
  .position = Vector3( 10.0f, 10.0f, 10.0f )
  .target = Vector3( 0.0f, 0.0f, 0.0f )
  .up = Vector3( 0.0f, 1.0f, 0.0f )
  .fovy = 45.0f
  .projection = CAMERA_PERSPECTIVE
end with

dim as Model models = LoadModel( "resources/models/iqm/guy.iqm" )             '' Load the animated model mesh and basic data
dim as Texture2D texture = LoadTexture( "resources/models/iqm/guytex.png" )  '' Load model texture and set material
SetMaterialTexture( @models.materials[ 0 ], MATERIAL_MAP_DIFFUSE, texture )            '' Set model material map texture

var position = Vector3( 0.0f, 0.0f, 0.0f ) '' Set model position

'' Load animation data
dim as long animsCount = 0
dim as ModelAnimation ptr anims = LoadModelAnimations( "resources/models/iqm/guyanim.iqm", @animsCount )
dim as long animFrameCounter = 0

'SetCameraMode( camera, CAMERA_FREE )

DisableCursor() ' limita el cursor a la ventana, y evitar que pierda movimiento al salir 

SetTargetFPS( 60 )

'' Main game loop
do while(WindowShouldClose()=0)
  '' Update
  UpdateCamera( @camera, CAMERA_FIRST_PERSON )
  
  '' Play animation when spacebar is held down
  if( IsKeyDown( KEY_SPACE ) ) then
    animFrameCounter += 1
    UpdateModelAnimation( models, anims[ 0 ], animFrameCounter )
    if( animFrameCounter >= anims[ 0 ].frameCount ) then animFrameCounter = 0
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    BeginMode3D( camera )
      DrawModelEx( models, position, Vector3( 1.0f, 0.0f, 0.0f ), -90.0f, Vector3( 1.0f, 1.0f, 1.0f ), WHITE )

      for i as integer = 0 to models.boneCount - 1
        DrawCube( anims[ 0 ].framePoses[ animFrameCounter ][ i ].translation, 0.2f, 0.2f, 0.2f, RED )
      next
      
      DrawGrid( 10, 1.0f )
    EndMode3D()
    
    DrawText( "PRESS SPACE to PLAY MODEL ANIMATION", 10, 10, 20, MAROON )
    DrawText( "(c) Guy IQM 3D model by @culacant", screenWidth - 200, screenHeight - 20, 10, GRAY )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( texture )

'' Unload model animations data
UnloadModelAnimation( *anims )

UnloadModel( models )
CloseWindow()
