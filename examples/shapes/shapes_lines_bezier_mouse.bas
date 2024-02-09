 /'******************************************************************************************
*
*   raylib [shapes] example - Cubic-bezier lines
*
*   Example originally created with raylib 1.7, last time updated with raylib 1.7
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2024 Ramon Santamaria (@raysan5)
*
*   actualizado a 5.0 por Joseba Epalza,2024 <jepalza gmail com>
*******************************************************************************************'/

#include "../raylib.bi"

''------------------------------------------------------------------------------------
'' Program main entry point
''------------------------------------------------------------------------------------

    '' Initialization
    ''--------------------------------------------------------------------------------------
    Dim As Integer screenWidth = 800 
    Dim As Integer screenHeight = 450 

    SetConfigFlags(FLAG_MSAA_4X_HINT) 
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - cubic-bezier lines") 

    Dim As Vector2 startPoint = Vector2( 30, 30 )
    Dim As Vector2 endPoint = Vector2( screenWidth - 30, screenHeight - 30 ) 
    Dim As BOOLEAN moveStartPoint = FALSE  
    Dim As BOOLEAN moveEndPoint = FALSE  

    SetTargetFPS(60)                '' Set our game to run at 60 frames-per-second
    ''--------------------------------------------------------------------------------------

    '' Main game loop
    while ( Not WindowShouldClose())    '' Detect window close button or ESC key
     
        '' Update
        ''----------------------------------------------------------------------------------
        Dim As Vector2 mouse = GetMousePosition() 

        if (CheckCollisionPointCircle(mouse, startPoint, 10.0f) AndAlso IsMouseButtonDown(MOUSE_BUTTON_LEFT)) Then  
        		moveStartPoint = TRUE
        ElseIf  (CheckCollisionPointCircle(mouse, endPoint, 10.0f) AndAlso IsMouseButtonDown(MOUSE_BUTTON_LEFT)) Then
				moveEndPoint = TRUE  
        EndIf
        if (moveStartPoint) Then 
            startPoint = mouse 
            if (IsMouseButtonReleased(MOUSE_BUTTON_LEFT)) Then moveStartPoint = FALSE
        EndIf
  

        if (moveEndPoint) Then 
            endPoint = mouse 
            if (IsMouseButtonReleased(MOUSE_BUTTON_LEFT)) Then moveEndPoint = FALSE
        EndIf
  
        ''----------------------------------------------------------------------------------

        '' Draw
        ''----------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            DrawText("MOVE START-END POINTS WITH MOUSE", 15, 20, 20, GRAY) 

            '' Draw line Cubic Bezier, in-out interpolation (easing), no control points
            DrawLineBezier(startPoint, endPoint, 4.0f, BLUE) 

            '' Draw start-end spline circles with some details
            DrawCircleV(startPoint, IIf(CheckCollisionPointCircle(mouse, startPoint, 10.0f) , 14 , 8) , iif(moveStartPoint , RED , BLUE) ) 
            DrawCircleV(endPoint,   IIf(CheckCollisionPointCircle(mouse, endPoint  , 10.0f) , 14 , 8) , IIf(moveEndPoint   , RED , BLUE) ) 

        EndDrawing() 
        ''----------------------------------------------------------------------------------
    
   Wend

    '' De-Initialization
    ''--------------------------------------------------------------------------------------
    CloseWindow()         '' Close window and OpenGL context
    ''--------------------------------------------------------------------------------------

