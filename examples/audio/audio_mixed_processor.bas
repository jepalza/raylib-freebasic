 /'******************************************************************************************
*
*   raylib [audio] example - Mixed audio processing
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example contributed by hkc (@hatkidchan) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2023 hkc (@hatkidchan)
*
*******************************************************************************************'/
#include "..\raylib.bi"
'#include "math.bi"

Dim Shared As Single exponent= 1.0f                  '' Audio exponentiation value
Dim Shared As Single averageVolume(400) = { 0.0f }    '' Average volume history

''------------------------------------------------------------------------------------
'' Audio processing function
''------------------------------------------------------------------------------------
Sub ProcessAudio Cdecl(buffer As Any Ptr , frames As UInteger)

    Dim As Single Ptr samples = cast(Single Ptr,buffer)    '' Samples internally stored as <float>s
    Dim As Single average = 0.0f                '' Temporary average volume

    for frame As UInteger = 0 To frames-1       
     
        Dim As Single Ptr Left_  = @samples[frame * 2 + 0] 
        Dim As Single Ptr right_ = @samples[frame * 2 + 1] 

        *left_  = (Abs(*left_ ) ^ exponent) * IIf( (*left_ < 0.0f), -1.0f , 1.0f ) 
        *right_ = (Abs(*right_) ^ exponent) * IIf( (*right_ < 0.0f), -1.0f , 1.0f ) 

        average += Abs(*left_ ) / frames    '' accumulating average volume
        average += Abs(*right_) / frames 
    
    Next

    '' Moving history to the left
    for i as Integer = 0 To 398
    	averageVolume(i) = averageVolume(i + 1)
    Next

    averageVolume(399) = average          '' Adding last average value
End Sub

''------------------------------------------------------------------------------------
'' Program main entry point
''------------------------------------------------------------------------------------

    '' Initialization
    ''--------------------------------------------------------------------------------------
    Dim As Integer screenWidth = 800 
    Dim As Integer screenHeight = 450 

    InitWindow(screenWidth, screenHeight, "raylib [audio] example - processing mixed output") 

    InitAudioDevice()               '' Initialize audio device

    AttachAudioMixedProcessor(@ProcessAudio) 

    Dim As Music music = LoadMusicStream("resources/country.mp3") 
    Dim As Sound sound = LoadSound("resources/coin.wav") 

    PlayMusicStream(music) 

    SetTargetFPS(60)                '' Set our game to run at 60 frames-per-second
    ''--------------------------------------------------------------------------------------

    '' Main game loop
    while ( Not WindowShouldClose())    '' Detect window close button or ESC key
     
        '' Update
        ''----------------------------------------------------------------------------------
        UpdateMusicStream(music)    '' Update music buffer with new stream data

        '' Modify processing variables
        ''----------------------------------------------------------------------------------
        if (IsKeyPressed(KEY_LEFT)) Then exponent -= 0.05f 
        if (IsKeyPressed(KEY_RIGHT)) Then exponent += 0.05f 

        if (exponent <= 0.5f) Then exponent = 0.5f 
        if (exponent >= 3.0f) Then exponent = 3.0f 

        if (IsKeyPressed(KEY_SPACE)) Then PlaySound(sound) 

        '' Draw
        ''----------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            DrawText("MUSIC SHOULD BE PLAYING!", 255, 150, 20, LIGHTGRAY) 

            DrawText(TextFormat("EXPONENT = %.2f", exponent), 215, 180, 20, LIGHTGRAY) 

            DrawRectangle(199, 199, 402, 34, LIGHTGRAY) 
            for i As Integer = 0 To 399      
             
                DrawLine(201 + i, 232 - averageVolume(i) * 32, 201 + i, 232, MAROON) 
            
            Next
            DrawRectangleLines(199, 199, 402, 34, GRAY) 

            DrawText("PRESS SPACE TO PLAY OTHER SOUND", 200, 250, 20, LIGHTGRAY) 
            DrawText("USE LEFT AND RIGHT ARROWS TO ALTER DISTORTION", 140, 280, 20, LIGHTGRAY) 

        EndDrawing() 
        ''----------------------------------------------------------------------------------
    
    Wend

    '' De-Initialization
    ''--------------------------------------------------------------------------------------
    UnloadMusicStream(music)    '' Unload music stream buffers from RAM

    DetachAudioMixedProcessor(@ProcessAudio)   '' Disconnect audio processor

    CloseAudioDevice()          '' Close audio device (music streaming is automatically stopped)

    CloseWindow()               '' Close window and OpenGL context
    ''--------------------------------------------------------------------------------------

