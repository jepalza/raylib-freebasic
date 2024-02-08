/'*******************************************************************************************
*
*   raylib [audio] example - Module playing (streaming)
*
*   This example has been created using raylib 1.5 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2016 Ramon Santamaria (@raysan5)
*
********************************************************************************************'/

#include once "../raylib.bi"

#define MAX_CIRCLES  64

type CircleWave
  as Vector2 position
  as Single radius
  as Single alphas
  as Single speed
  as RLColor colour
end type

'' Initialization
const as long screenWidth = 800, screenHeight = 450

'' NOTE: Try to enable MSAA 4X
SetConfigFlags( FLAG_MSAA_4X_HINT )

InitWindow( screenWidth, screenHeight, "raylib [audio] example - module playing (streaming)" )

'' Initialize audio device
InitAudioDevice()                  

dim as RLColor colores( ... ) = { ORANGE, RED, GOLD, LIME, BLUE, VIOLET, BROWN, LIGHTGRAY, PINK, _
  											YELLOW, GREEN, SKYBLUE, PURPLE, BEIGE }

'' Creates ome circles for visual effect
dim as CircleWave circles( 0 to MAX_CIRCLES - 1 )

for i as integer = MAX_CIRCLES - 1 to 0 step -1
  with circles( i )
    .alphas = 0.0f
    .radius = GetRandomValue( 10, 40 )
    .position.x = GetRandomValue( .radius, screenWidth - .radius )
    .position.y = GetRandomValue( .radius, screenHeight - .radius )
    .speed = GetRandomValue( 1, 100 ) / 2000.0f
    .colour = colores( GetRandomValue( 0, 13 ) )
  end with
next

Dim as Music musica = LoadMusicStream( "resources/mini1111.xm" )

musica.looping = FALSE
dim as single pitch = 1.0f

PlayMusicStream( musica )

dim as single timePlayed = 0.0f
dim as BOOLEAN pause = FALSE 

'' Set our game to run at 60 frames-per-second
SetTargetFPS( 60 )               

'' Main game loop
do while( not WindowShouldClose() )
	
  '' Update musica buffer with new stream data
  UpdateMusicStream( musica )
  
  '' Restart musica playing (stop and play)
  if( IsKeyPressed( KEY_SPACE ) ) then
    StopMusicStream( musica )
    PlayMusicStream( musica )
    pause = FALSE
  end if
  
  '' Pause/Resume musica playing
  if( IsKeyPressed( KEY_P ) ) then
    pause xor= TRUE
    
    if( pause ) then
      PauseMusicStream( musica )
    else
      ResumeMusicStream( musica )
    end if
  end if
  
  if( IsKeyDown( KEY_DOWN ) ) then
    pitch -= 0.01f
  elseif( IsKeyDown( KEY_UP ) ) then
    pitch += 0.01f
  end if
  
  SetMusicPitch( musica, pitch )
  'SeekMusicStream( musica, 2 )
  SetMusicVolume( musica, 1 )  
 
  '' Get timePlayed scaled to bar dimensions
  timePlayed = GetMusicTimePlayed( musica ) / GetMusicTimeLength( musica ) * ( screenWidth - 40 )
  
  ''Color circles animation
  If( not pause ) then
    for i as integer = MAX_CIRCLES - 1 to 0 step -1
      with circles( i )
        .alphas += .speed
        .radius += .speed * 10.0f
        
        if( .alphas > 1.0f ) then .speed *= -1
        
        if( .alphas <= 0.0f ) then
          .alphas = 0.0f
          .radius = GetRandomValue( 10, 40 )
          .position.x = GetRandomValue( .radius, screenWidth - .radius)
          .position.y = GetRandomValue( .radius, screenHeight - .radius)
          .colour = colores( GetRandomValue( 0, 13 ) )
          .speed = GetRandomValue( 1, 100 ) / 2000.0f
        end if
      end with
    Next
  End if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    for i as integer = MAX_CIRCLES - 1 to 0 step -1
      with circles( i )
        DrawCircleV( .position, .radius, Fade( .colour, .alphas ) )
      end with
    next
    
    '' Draw time bar
    DrawRectangle( 20, screenHeight - 20 - 12, screenWidth - 40, 12, LIGHTGRAY )
    DrawRectangle( 20, screenHeight - 20 - 12, timePlayed, 12, MAROON )
    DrawRectangleLines( 20, screenHeight - 20 - 12, screenWidth - 40, 12, GRAY )
    
	   ' Draw help instructions
	   DrawRectangle(20, 20, 425, 145, WHITE)
	   DrawRectangleLines(20, 20, 425, 145, GRAY)
	   DrawText("PRESS SPACE TO RESTART MUSIC", 40, 40, 20, BLACK)
	   DrawText("PRESS P TO PAUSE/RESUME", 40, 70, 20, BLACK)
	   DrawText("PRESS UP/DOWN TO CHANGE SPEED", 40, 100, 20, BLACK)
	   DrawText(TextFormat("SPEED: %f", pitch), 40, 130, 20, MAROON)
            
  EndDrawing()
loop

'' De-Initialization
UnloadMusicStream(musica)
CloseAudioDevice()
CloseWindow()
