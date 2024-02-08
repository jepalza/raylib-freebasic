/'*******************************************************************************************
*
*   raylib [models] example - Models loading
*
*   raylib supports multiple models file formats:
*
*     - OBJ > Text file, must include vertex position-texcoords-normals information,
*             if files references some .mtl materials file, it will be loaded (or try to)
*     - GLTF > Modern text/binary file format, includes lot of information and it could
*              also reference external files, raylib will try loading mesh and materials data
*     - IQM > Binary file format including mesh vertex data but also animation data,
*             raylib can load .iqm animations.  
*
*   This example has been created using raylib 2.6 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2014-2019 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

'' Initialization
const as long _
  screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - models loading" )

dim as Camera cameras

with cameras
  cameras.position = Vector3( 50.0f, 50.0f, 50.0f )
  cameras.target = Vector3( 0.0f, 10.0f, 0.0f )
  cameras.up = Vector3( 0.0f, 1.0f, 0.0f )
  cameras.fovy = 45.0f
  cameras.projection = CAMERA_PERSPECTIVE
end with

dim as Model model = LoadModel( "resources/models/obj/castle.obj" )
dim as Texture2D textures = LoadTexture( "resources/models/obj/castle_diffuse.png" )
model.materials[0].maps[MATERIAL_MAP_DIFFUSE].texture = textures

var position = Vector3( 0.0f, 0.0f, 0.0f )

dim as BoundingBox bounds = GetMeshBoundingBox( model.meshes[ 0 ] )
'' NOTE: bounds are calculated from the original size of the model,
'' if model is scaled on drawing, bounds must be also scaled

'SetcamerasMode( cameras, cameras_FREE )

dim as BOOLEAN  selected = FALSE 

SetTargetFPS( 60 )

DisableCursor()  ' Limit cursor to relative movement inside the Window

'' Main game loop
do while(WindowShouldClose()=0)
  '' Update
  Updatecamera( @cameras, CAMERA_FREE )
  
  '' Load new models/textures on drag&drop
  if( IsFileDropped() ) then
    dim as FilePathList droppedFiles = LoadDroppedFiles( )
    
    if( droppedFiles.count = 1 ) then '' Only support one file dropped
      '' Model file formats supported
      if( IsFileExtension( droppedFiles.paths[ 0 ], ".obj" ) orElse _
          IsFileExtension( droppedFiles.paths[ 0 ], ".gltf" ) orElse _
          IsFileExtension( droppedFiles.paths[ 0 ], ".iqm" ) ) then       
        
        UnloadModel( model )                    '' Unload previous model
        model = LoadModel( droppedFiles.paths[ 0 ] )  '' Load new model
        model.materials[ 0 ].maps[ MATERIAL_MAP_DIFFUSE ].texture = textures '' Set current map diffuse texture
        
        bounds = GetMeshBoundingBox( model.meshes[ 0 ] )
        
        '' TODO: Move cameras position from target enough distance to visualize model properly
      elseif( IsFileExtension( droppedFiles.paths[ 0 ], ".png" ) ) then '' Texture file formats supported
        '' Unload current model texture and load new one
        UnloadTexture( textures )
        textures = LoadTexture( droppedFiles.paths[ 0 ] )
        model.materials[ 0 ].maps[ MATERIAL_MAP_DIFFUSE ].texture = textures
      end if
    end if
    UnloadDroppedFiles(droppedFiles)
  end if
  
  '' Select model on mouse click
  if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then
    '' Check collision between ray and box
  if( GetRayCollisionBox( GetMouseRay( GetMousePosition(), cameras ), bounds ).hit ) then
      selected xor= TRUE 
    else
      selected = FALSE 
    end if
  end if
  
  '' Draw
  BeginDrawing()
      ClearBackground( RAYWHITE )
      
      BeginMode3D( cameras )
          DrawModel( model, position, 1.0f, WHITE )
          DrawGrid( 20, 10.0f )
          if( selected ) then DrawBoundingBox( bounds, GREEN )
      EndMode3D()
      
      DrawText( "Drag & drop model to load mesh/texture.", 10, GetScreenHeight() - 20, 10, DARKGRAY )
      if( selected ) then DrawText( "MODEL SELECTED", GetScreenWidth() - 110, 10, 10, GREEN )
      
      DrawText( "(c) Castle 3D model by Alberto Cano", screenWidth - 200, screenHeight - 20, 10, GRAY )
      DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( textures )
UnloadModel( model )

CloseWindow()
