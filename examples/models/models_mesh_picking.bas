/'*******************************************************************************************
*
*   raylib [models] example - Mesh picking in 3d mode, ground plane, triangle, mesh
*
*   Example originally created with raylib 1.7, last time updated with raylib 4.0
*
*   Example contributed by Joel Davis (@joeld42) and reviewed by Ramon Santamaria (@raysan5)
*
*   convertido a FreeBasic por Joseba Epalza, 2024 <jepalza gmail com>
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2023 Joel Davis (@joeld42) and Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "../raymath.bi"

#define FLT_MAX     340282346638528859811704183484516925440.0f '' Maximum value of a float, from bit pattern 01111111011111111111111111111111

'' Initialization
const as long screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [models] example - mesh picking" )

'' Define the camera to look into our 3d world
dim as Camera cameras

with cameras
  .position = Vector3( 20.0f, 20.0f, 20.0f )
  .target = Vector3( 0.0f, 8.0f, 0.0f )
  .up = Vector3( 0.0f, 1.6f, 0.0f )
  .fovy = 45.0f
  .projection = CAMERA_PERSPECTIVE
end with

dim as Ray rays '' Picking ray

dim as Model tower = LoadModel( "resources/models/obj/turret.obj" )
dim as Texture2D texture = LoadTexture( "resources/models/obj/turret_diffuse.png" )
tower.materials[ 0 ].maps[ MATERIAL_MAP_DIFFUSE ].texture = texture

var towerPos = Vector3( 0.0f, 0.0f, 0.0f )
dim as BoundingBox towerBBox = GetMeshBoundingBox( tower.meshes[ 0 ] )

dim as BOOLEAN hitMeshBBox = false, hitTriangle = FALSE 

' Ground quad
Dim As Vector3 g0 = Vector3( -50.0f, 0.0f, -50.0f)
Dim As Vector3 g1 = Vector3( -50.0f, 0.0f,  50.0f)
Dim As Vector3 g2 = Vector3(  50.0f, 0.0f,  50.0f)
Dim As Vector3 g3 = Vector3 ( 50.0f, 0.0f, -50.0f)
    
'' Test triangle
Dim As Vector3 ta = Vector3( -25.0, 0.5, 0.0 )
Dim As Vector3 tb = Vector3( -4.0, 2.5, 1.0 )
Dim As Vector3 tc = Vector3( -8.0, 6.5, 0.0 )

Dim As Vector3 bary = Vector3( 0.0f, 0.0f, 0.0f )

' Test sphere
Dim As Vector3 sp = Vector3( -30.0f, 5.0f, 5.0f )
Dim As Single sr  = 4.0f
    
'SetCameraMode( camera, CAMERA_FREE )

SetTargetFPS( 60 )

'' Main game loop
do while(WindowShouldClose()=0)
  '' Update
  if (IsCursorHidden()) Then UpdateCamera( @cameras, CAMERA_FIRST_PERSON )

  ' Toggle camera controls
  if (IsMouseButtonPressed(MOUSE_BUTTON_RIGHT)) then
      if (IsCursorHidden()) Then 
      	EnableCursor()
      else 
      	DisableCursor()
      EndIf
  EndIf
        
  '' Display information about closest hit
  dim as RayCollision collision
  
  dim as string hitObjectName = "None"
  
  collision.distance = FLT_MAX
  collision.hit = FALSE 
  
  dim as RLColor cursorColor = WHITE
  
  
  '' Get ray and test against ground, triangle, and mesh
  rays = GetMouseRay( GetMousePosition(), cameras )
  
  '' ----- Check ray collision aginst ground plane
  dim as RayCollision groundHitInfo = GetRayCollisionQuad( rays, g0, g1, g2, g3 )
  if( (groundHitInfo.hit<>0) andAlso ( groundHitInfo.distance < collision.distance ) ) then
    collision = groundHitInfo
    cursorColor = GREEN
    hitObjectName = "Ground"
  end if
  
  '' ----- Check ray collision against test triangle
  dim as RayCollision triHitInfo = GetRayCollisionTriangle( rays, ta, tb, tc )
  if( (triHitInfo.hit<>0) andAlso ( triHitInfo.distance < collision.distance ) ) then
    collision = triHitInfo
    cursorColor = PURPLE
    hitObjectName = "Triangle"
    
    bary = Vector3Barycenter( collision.point_, ta, tb, tc )
  end if
  
  '' ----- Check ray collision against test sphere
  dim as RayCollision sphereHitInfo = GetRayCollisionSphere(rays, sp, sr)
  if ((sphereHitInfo.hit<>0) AndAlso (sphereHitInfo.distance < collision.distance)) then
      collision = sphereHitInfo
      cursorColor = ORANGE
      hitObjectName = "Sphere"
  EndIf
          
  '' ----- Check ray collision against bounding box first, before trying the full ray-mesh test
  Dim As RayCollision boxHitInfo = GetRayCollisionBox(rays, towerBBox)
  if ((boxHitInfo.hit<>0) AndAlso (boxHitInfo.distance < collision.distance)) then
	   collision = boxHitInfo
	   cursorColor = ORANGE
	   hitObjectName = "Box"
	
	   ' Check ray collision against model meshes
	   Dim As RayCollision meshHitInfo 
	   for m As Integer = 0 To tower.meshCount-1
	       ' NOTE: We consider the model.transform for the collision check but 
	       ' it can be checked against any transform Matrix, used when checking against same
	       ' model drawn multiple times with multiple transforms
	       meshHitInfo = GetRayCollisionMesh(rays, tower.meshes[m], tower.transform)
	       if (meshHitInfo.hit) Then
	           ' Save the closest hit mesh
	           if ((collision.hit=0) OrElse (collision.distance > meshHitInfo.distance)) Then collision = meshHitInfo
	           Exit For 'Stop once one mesh collision is detected, the colliding mesh is m
	       EndIf
	   Next
    
    If meshHitInfo.hit then
      collision = meshHitInfo
      cursorColor = ORANGE
      hitObjectName = "Mesh"
    end if
  end if
 
  
  '----------------------------------------------------------------------------------
  ' Draw
  '--------------------------------------------------------------------------------
  BeginDrawing()
      ClearBackground( RAYWHITE )
      
      BeginMode3D( cameras )
          '' Draw the tower
          '' WARNING: If scale is different than 1.0f,
          '' not considered by GetCollisionRayModel()
          DrawModel( tower, towerPos, 1.0f, WHITE )
          
          '' Draw the test triangle
          DrawLine3D( ta, tb, PURPLE )
          DrawLine3D( tb, tc, PURPLE )
          DrawLine3D( tc, ta, PURPLE )

          ' Draw the test sphere
          DrawSphereWires(sp, sr, 8, 8, PURPLE)
                          
          '' Draw the mesh bbox if we hit it
          if( boxHitInfo.hit ) then DrawBoundingBox( towerBBox, LIME )
          
          '' If we hit something, draw the cursor at the hit point
          if( collision.hit ) then
            DrawCube( collision.point_, 0.3, 0.3, 0.3, cursorColor )
            DrawCubeWires( collision.point_, 0.3, 0.3, 0.3, RED )
            
            dim as Vector3 normalEnd
            
            normalEnd.x = collision.point_.x + collision.normal.x
            normalEnd.y = collision.point_.y + collision.normal.y
            normalEnd.z = collision.point_.z + collision.normal.z
            
            DrawLine3D(collision.point_, normalEnd, RED )
          end if
          
          DrawRay( rays, MAROON )
          DrawGrid( 10, 10.0f )
      EndMode3D()
      
      '' Draw some debug GUI text
      DrawText( TextFormat( "Hit Object: %s", hitObjectName ), 10, 50, 10, BLACK )
      
      if( collision.hit ) then
        dim as long ypos = 70
        
        DrawText( TextFormat( "Distance: %3.2f", collision.distance ), 10, ypos, 10, BLACK )
        DrawText( TextFormat( "Hit Pos: %3.2f %3.2f %3.2f", _
          collision.point_.x, _
          collision.point_.y, _
          collision.point_.z ), 10, ypos + 15, 10, BLACK )
        
        DrawText( TextFormat( "Hit Norm: %3.2f %3.2f %3.2f", _
          collision.normal.x, _
          collision.normal.y, _
          collision.normal.z ), 10, ypos + 30, 10, BLACK )
        
        if( triHitInfo.hit<>0) AndAlso ( TextIsEqual(hitObjectName, "Triangle") ) then 
        		DrawText( TextFormat( "Barycenter: %3.2f %3.2f %3.2f", bary.x, bary.y, bary.z ), 10, ypos + 45, 10, BLACK )
        EndIf
      end if
      
      DrawText( "Use Mouse to Move Camera", 10, 430, 10, GRAY )
      DrawText( "(c) Turret 3D model by Alberto Cano", screenWidth - 200, screenHeight - 20, 10, GRAY )
      
      DrawFPS( 10, 10 )
  EndDrawing()
loop

'' De-Initialization
UnloadModel( tower )
UnloadTexture( texture )

CloseWindow()
