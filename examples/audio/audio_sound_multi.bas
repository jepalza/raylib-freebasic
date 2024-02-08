 /'******************************************************************************************
*
*   raylib [audio] example - Playing sound multiple times
*
*   Example originally created with raylib 4.6
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2023 Jeffery Myers (@JeffM2501)
*
*******************************************************************************************'/

#include "..\raylib.bi"

#define MAX_SOUNDS 10
Dim Shared As Sound soundArray(MAX_SOUNDS)
Dim Shared As Integer currentSound 

''------------------------------------------------------------------------------------
'' Program main entry point
''------------------------------------------------------------------------------------


    '' Initialization
    ''--------------------------------------------------------------------------------------
    Dim As Integer screenWidth = 800 
    Dim As Integer screenHeight = 450 

    InitWindow(screenWidth, screenHeight, "raylib [audio] example - playing sound multiple times") 

    InitAudioDevice()       '' Initialize audio device

    '' load the sound list
    soundArray(0) = LoadSound("resources/sound.wav")          '' Load WAV audio file into the first slot as the ´source´ sound
                                                              '' this sound owns the sample data
    for i As Integer = 1 To  MAX_SOUNDS-1       
     
        soundArray(i) = LoadSoundAlias(soundArray(0))         '' Load an alias of the sound into slots 1-9. These do not own the sound data, but can be played
    
    Next
    currentSound = 0                                          '' set the sound list to the start

    SetTargetFPS(60)                '' Set our game to run at 60 frames-per-second
    ''--------------------------------------------------------------------------------------

    '' Main game loop
    while ( Not WindowShouldClose())    '' Detect window close button or ESC key
     
        '' Update
        ''----------------------------------------------------------------------------------
        if (IsKeyPressed(KEY_SPACE)) Then 

         
            PlaySound(soundArray(currentSound))             '' play the next open sound slot
            currentSound+=1                                   '' increment the sound slot
            if (currentSound >= MAX_SOUNDS) Then 
                 '' if the sound slot is out of bounds, go back to 0
                currentSound = 0
            EndIf
  

            '' Note: a better way would be to look at the list for the first sound that is not playing and use that slot
        
        EndIf
  

        ''----------------------------------------------------------------------------------

        '' Draw
        ''----------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            DrawText("Press SPACE to PLAY a WAV sound!", 200, 180, 20, LIGHTGRAY) 

        EndDrawing() 
        ''----------------------------------------------------------------------------------
    
   Wend
    

    '' De-Initialization
    ''--------------------------------------------------------------------------------------
    for i As Integer = 1 To  MAX_SOUNDS-1       
        UnloadSoundAlias(soundArray(i))
    Next
    '' Unload sound aliases
    UnloadSound(soundArray(0))               '' Unload source sound data

    CloseAudioDevice()      '' Close audio device

    CloseWindow()           '' Close window and OpenGL context
    ''--------------------------------------------------------------------------------------
