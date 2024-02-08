/'*******************************************************************************************
*
*   raylib [textures] example - Draw part of the texture tiled
*
*   This example has been created using raylib 3.0 (www.raylib.com)
*   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
*
*   Copyright (c) 2020 Vlad Adrian (@demizdor) and Ramon Santamaria (@raysan5)
*
*   convertido a FreeBasic RayLib V5.0 por Joseba Epalza,2024 <jepalza gmail com >
*
********************************************************************************************'/
#include once "../raylib.bi"




'' Draw part of a texture (defined by a rectangle) with rotation and scale tiled into dest.
Sub DrawTextureTiled(texture As Texture2D , source As Rectangle , dest As Rectangle , origin As Vector2 , rotation As Single , scale As Single , tint As RLColor)

    if ((texture.id <= 0) OrElse (scale <= 0.0f)) Then return   '' Wanna see a infinite loop?!...just delete this line!
    if ((source.width_ = 0) OrElse (source.height_ = 0)) Then return 

    Dim As Integer tileWidth = (source.width_*scale), tileHeight = (source.height_*scale) 
    if ((dest.width_ < tileWidth) AndAlso (dest.height_ < tileHeight)) Then 
        '' Can fit only one tile
        DrawTexturePro(texture, Rectangle(source.x, source.y, (dest.width_/tileWidth)*source.width_, (dest.height_/tileHeight)*source.height_),_
                    Rectangle(dest.x, dest.y, dest.width_, dest.height_), origin, rotation, tint)  
    ElseIf  (dest.width_ <= tileWidth) Then
        '' Tiled vertically (one column)
        Dim As Integer dy = 0 
        While dy+tileHeight < dest.height_ 
            DrawTexturePro(texture, Rectangle(source.x, source.y, (dest.width_/tileWidth)*source.width_, source.height_), _ 
            		Rectangle(dest.x, dest.y + dy, dest.width_, tileHeight), origin, rotation, tint) 
        		dy += tileHeight
        Wend

        '' Fit last tile
        if (dy < dest.height_) Then
            DrawTexturePro(texture, Rectangle(source.x, source.y, (dest.width_/tileWidth)*source.width_, ((dest.height_ - dy)/tileHeight)*source.height_),_
                        Rectangle(dest.x, dest.y + dy, dest.width_, dest.height_ - dy), origin, rotation, tint)
        EndIf 
    ElseIf  (dest.height_ <= tileHeight) Then

        '' Tiled horizontally (one row)
        Dim As Integer dx = 0 
        While dx+tileWidth < dest.width_       
            DrawTexturePro(texture, Rectangle(source.x, source.y, source.width_, (dest.height_/tileHeight)*source.height_), _
            		Rectangle(dest.x + dx, dest.y, tileWidth, dest.height_), origin, rotation, tint) 
        		dx += tileWidth
        Wend 

        '' Fit last tile
        if (dx < dest.width_) Then 
            DrawTexturePro(texture, Rectangle(source.x, source.y, ((dest.width_ - dx)/tileWidth)*source.width_, (dest.height_/tileHeight)*source.height_),_
                        Rectangle(dest.x + dx, dest.y, dest.width_ - dx, dest.height_), origin, rotation, tint) 
        EndIf
    else

        '' Tiled both horizontally and vertically (rows and columns)
        Dim As Integer dx = 0
        While dx+tileWidth < dest.width_       
            Dim As Integer dy = 0 
            While dy+tileHeight < dest.height_       
                DrawTexturePro(texture, source, Rectangle(dest.x + dx, dest.y + dy, tileWidth, tileHeight), origin, rotation, tint) 
            	dy += tileHeight
            wend

            if (dy < dest.height_) Then 
                DrawTexturePro(texture, Rectangle(source.x, source.y, source.width_, ((dest.height_ - dy)/tileHeight)*source.height_),_
                    Rectangle(dest.x + dx, dest.y + dy, tileWidth, dest.height_ - dy), origin, rotation, tint) 
            EndIf
            dx += tileWidth
        Wend

        '' Fit last column of tiles
        if (dx < dest.width_) Then 
            Dim As Integer dy = 0 
            While dy+tileHeight < dest.height_       
                DrawTexturePro(texture, Rectangle(source.x, source.y, ((dest.width_ - dx)/tileWidth)*source.width_, source.height_),_
                        Rectangle(dest.x + dx, dest.y + dy, dest.width_ - dx, tileHeight), origin, rotation, tint) 
            	dy += tileHeight
            Wend

            '' Draw final tile in the bottom right corner
            if (dy < dest.height_) Then 
                DrawTexturePro(texture, Rectangle(source.x, source.y, ((dest.width_ - dx)/tileWidth)*source.width_, ((dest.height_ - dy)/tileHeight)*source.height_),_
                    Rectangle(dest.x + dx, dest.y + dy, dest.width_ - dx, dest.height_ - dy), origin, rotation, tint) 
            EndIf
        EndIf
  
    EndIf
  
End Sub






#define SIZEOF_ARRAY( A ) ( ( ubound( A ) - lbound( A ) ) + 1 )
#define OPT_WIDTH       220       '' Max width for the options container
#define MARGIN_SIZE       8       '' Size for the margins
#define COLOR_SIZE       16       '' Size of the color select buttons

'' Initialization
dim as long _
  screenWidth = 800, screenHeight = 450

SetConfigFlags( FLAG_WINDOW_RESIZABLE )
InitWindow( screenWidth, screenHeight, "raylib [textures] example - Draw part of a texture tiled" )

'' NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
dim as Texture texPattern = LoadTexture( "resources/patterns.png" )
SetTextureFilter( texPattern, TEXTURE_FILTER_TRILINEAR )

'' Coordinates for all patterns inside the texture
dim As Rectangle recPattern( ... ) = { _
  Rectangle( 3, 3, 66, 66 ), _
  Rectangle( 75, 3, 100, 100 ), _
  Rectangle( 3, 75, 66, 66 ), _
  Rectangle( 7, 156, 50, 50 ), _
  Rectangle( 85, 106, 90, 45 ), _
  Rectangle( 75, 154, 100, 60 ) }

'' Setup colours
dim As RLColor colours( ... ) = { BLACK, MAROON, ORANGE, BLUE, PURPLE, BEIGE, LIME, RED, DARKGRAY, SKYBLUE }
dim as long MAX_COLORS = SIZEOF_ARRAY( colours )

dim as Rectangle colorRec( 0 to MAX_COLORS - 1 )

'' Calculate rectangle for each color
dim as long x = 0, y = 0, i = 0

do while( i < MAX_COLORS )
  with colorRec( i )
    .x = 2 + MARGIN_SIZE + x
    .y = 22 + 256 + MARGIN_SIZE + y
    .width_ = COLOR_SIZE * 2
    .height_ = COLOR_SIZE
  end with
  
  if( i = ( MAX_COLORS / 2 - 1 ) ) then
    x = 0 
    y += COLOR_SIZE + MARGIN_SIZE
  else
    x += ( COLOR_SIZE * 2 + MARGIN_SIZE )
  end if
  
  i += 1 : x += 1 : y += 1
loop

dim as long activePattern = 0, activeCol = 0
dim as single scale = 1.0f, rotation = 0.0f

SetTargetFPS( 60 )

'' Main game loop
do while(WindowShouldClose()=0)
  '' Update
  screenWidth = GetScreenWidth()
  screenHeight = GetScreenHeight()
  
  '' Handle mouse
  if( IsMouseButtonPressed( MOUSE_LEFT_BUTTON ) ) then
    dim as Vector2 mouse = GetMousePosition()
    
    '' Check which pattern was clicked and set it as the active pattern
    for i as integer = 0 to SIZEOF_ARRAY( recPattern ) - 1
      if( CheckCollisionPointRec( mouse, Rectangle( 2 + MARGIN_SIZE + recPattern( i ).x, 40 + MARGIN_SIZE + recPattern( i ).y, recPattern( i ).width_, recPattern( i ).height_ ) ) ) then
        activePattern = i 
        exit for
      end if
    next
    
    '' Check to see which color was clicked and set it as the active color
    for i as integer = 0 to MAX_COLORS - 1
      if( CheckCollisionPointRec( mouse, colorRec( i ) ) ) then
        activeCol = i
        exit for
      end if
    next
  end if
  
  '' Handle keys
  '' Change scale
  if( IsKeyPressed( KEY_UP ) ) then scale += 0.25f
  if( IsKeyPressed( KEY_DOWN ) ) then scale -= 0.25f
  if( scale > 10.0f ) then
    scale = 10.0f
  elseif( scale <= 0.0f ) then
    scale = 0.25f
  end if
  
  '' Change rotation
  if( IsKeyPressed( KEY_LEFT ) ) then rotation -= 25.0f
  if( IsKeyPressed( KEY_RIGHT ) ) then rotation += 25.0f
  
  '' Reset
  if( IsKeyPressed( KEY_SPACE ) ) then
    rotation = 0.0f : scale = 1.0f
  end if
  
  '' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    '' Draw the tiled area
    DrawTextureTiled( texPattern, recPattern( activePattern ), Rectangle( OPT_WIDTH + MARGIN_SIZE, MARGIN_SIZE, screenWidth - OPT_WIDTH - 2 * MARGIN_SIZE, screenHeight - 2 * MARGIN_SIZE ), _
      Vector2( 0.0f, 0.0f ), rotation, scale, colours( activeCol ) )
    
    '' Draw options
    DrawRectangle( MARGIN_SIZE, MARGIN_SIZE, OPT_WIDTH - MARGIN_SIZE, screenHeight - 2 * MARGIN_SIZE, ColorAlpha( LIGHTGRAY, 0.5f ) )
    
    DrawText( "Select Pattern", 2 + MARGIN_SIZE, 30 + MARGIN_SIZE, 10, BLACK )
    DrawTexture( texPattern, 2 + MARGIN_SIZE, 40 + MARGIN_SIZE, BLACK )
    DrawRectangle( 2 + MARGIN_SIZE + recPattern( activePattern ).x, 40 + MARGIN_SIZE + recPattern( activePattern ).y, recPattern( activePattern ).width_, recPattern( activePattern ).height_, ColorAlpha( DARKBLUE, 0.3f ) )
    
    DrawText( "Select Color", 2 + MARGIN_SIZE, 10 + 256 + MARGIN_SIZE, 10, BLACK )
    
    for i as integer = 0 to MAX_COLORS - 1
      DrawRectangleRec( colorRec( i ), colours( i ) )
      if( activeCol = i ) then DrawRectangleLinesEx( colorRec( i ), 3.0f, ColorAlpha( WHITE, 0.5f ) )
    next
    
    DrawText( "Scale (UP/DOWN to change)", 2 + MARGIN_SIZE, 80 + 256 + MARGIN_SIZE, 10, BLACK )
    DrawText( TextFormat( "%.2fx", scale ), 2 + MARGIN_SIZE, 92 + 256 + MARGIN_SIZE, 20, BLACK )
    
    DrawText( "Rotation (LEFT/RIGHT to change)", 2 + MARGIN_SIZE, 122 + 256 + MARGIN_SIZE, 10, BLACK )
    DrawText( TextFormat( "%.0f degrees", rotation ), 2 + MARGIN_SIZE, 134 + 256 + MARGIN_SIZE, 20, BLACK )
    
    DrawText( "Press [SPACE] to reset", 2 + MARGIN_SIZE, 164 + 256 + MARGIN_SIZE, 10, DARKBLUE )
    
    '' Draw FPS
    DrawText( TextFormat( "%i FPS", GetFPS() ), 2 + MARGIN_SIZE, 2 + MARGIN_SIZE, 20, BLACK )
  EndDrawing()
loop

'' De-Initialization
UnloadTexture( texPattern )

CloseWindow()
