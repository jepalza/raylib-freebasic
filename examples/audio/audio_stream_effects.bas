 /'******************************************************************************************
*
*   raylib [audio] example - Music stream processing effects
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2022-2023 Ramon Santamaria (@raysan5)
*
*******************************************************************************************'/

#include "..\raylib.bi"


' Required delay effect variables
Static Shared As Single Ptr delayBuffer '= NULL 
Static Shared As ULong delayBufferSize= 0 
Static Shared As ULong delayReadIndex= 2 
Static Shared As ULong delayWriteIndex= 0 

'------------------------------------------------------------------------------------
' Module Functions Declaration
'------------------------------------------------------------------------------------
Declare Sub AudioProcessEffectLPF Cdecl(buffer As Any Ptr , frames As ULong)    ' Audio effect: lowpass filter
Declare Sub AudioProcessEffectDelay cdecl(buffer As Any Ptr , frames As ULong)  ' Audio effect: delay

'------------------------------------------------------------------------------------
' Program main entry point
'------------------------------------------------------------------------------------


    ' Initialization
    '--------------------------------------------------------------------------------------
    Dim As Integer screenWidth = 800 
    Dim As Integer screenHeight = 450 

    InitWindow(screenWidth, screenHeight, "raylib [audio] example - stream effects") 

    InitAudioDevice()               ' Initialize audio device

    Dim As Music musica = LoadMusicStream("resources/country.mp3") 

    ' Allocate buffer for the delay effect
    delayBufferSize = 48000*2       ' 1 second delay (device sampleRate*channels)
    delayBuffer = Cast(Single Ptr,allocate(delayBufferSize * sizeof(single)) )

    PlayMusicStream(musica) 

    Dim As Single timePlayed = 0.0f         ' Time played normalized [0.0f..1.0f]
    Dim As BOOLEAN pause = FALSE               ' Music playing paused

    Dim As BOOLEAN enableEffectLPF = FALSE     ' Enable effect low-pass-filter
    Dim As BOOLEAN enableEffectDelay = FALSE   ' Enable effect delay (1 second)

    SetTargetFPS(60)                ' Set our game to run at 60 frames-per-second
    '--------------------------------------------------------------------------------------

    ' Main game loop
    while WindowShouldClose()=0    ' Detect window close button or ESC key
     
        ' Update
        '----------------------------------------------------------------------------------
        UpdateMusicStream(musica)    ' Update music buffer with new stream data

        ' Restart music playing (stop and play)
        if (IsKeyPressed(KEY_SPACE)) Then 
            StopMusicStream(musica) 
            PlayMusicStream(musica) 
        EndIf
  

        ' Pause/Resume music playing
        if (IsKeyPressed(KEY_P)) Then 
            pause = Not(pause)
            if (pause) Then 
            	PauseMusicStream(musica) 
            else
        			ResumeMusicStream(musica) 
            EndIf
        EndIf
  

        ' Add/Remove effect: lowpass filter
        if (IsKeyPressed(KEY_F)) Then 
            enableEffectLPF = Not(enableEffectLPF) 
            if (enableEffectLPF) Then 
            	AttachAudioStreamProcessor(musica.stream, @AudioProcessEffectLPF) 
            else
        			DetachAudioStreamProcessor(musica.stream, @AudioProcessEffectLPF) 
            EndIf
        EndIf
  

        ' Add/Remove effect: delay
        if (IsKeyPressed(KEY_D)) Then 
            enableEffectDelay = Not(enableEffectDelay) 
            if (enableEffectDelay) Then 
            	AttachAudioStreamProcessor(musica.stream, @AudioProcessEffectDelay) 
            else
        			DetachAudioStreamProcessor(musica.stream, @AudioProcessEffectDelay) 
            EndIf
        EndIf
  

        ' Get normalized time played for current music stream
        timePlayed = GetMusicTimePlayed(musica)/GetMusicTimeLength(musica) 

        if (timePlayed > 1.0f) Then timePlayed = 1.0f    ' Make sure time played is no longer than music
        '----------------------------------------------------------------------------------

        ' Draw
        '----------------------------------------------------------------------------------
        BeginDrawing() 

            ClearBackground(RAYWHITE) 

            DrawText("MUSIC SHOULD BE PLAYING!", 245, 150, 20, LIGHTGRAY) 

            DrawRectangle(200, 180, 400, 12, LIGHTGRAY) 
            DrawRectangle(200, 180, CInt(timePlayed*400.0f), 12, MAROON) 
            DrawRectangleLines(200, 180, 400, 12, GRAY) 

            DrawText("PRESS SPACE TO RESTART MUSIC ", 215, 230, 20, LIGHTGRAY) 
            DrawText("PRESS P TO PAUSE/RESUME MUSIC", 208, 260, 20, LIGHTGRAY) 

            DrawText(TextFormat("PRESS F TO TOGGLE LPF EFFECT  : %s", IIf(enableEffectLPF  , "ON" , "OFF")), 180, 320, 20, GRAY) 
            DrawText(TextFormat("PRESS D TO TOGGLE DELAY EFFECT: %s", IIf(enableEffectDelay, "ON" , "OFF")), 180, 350, 20, GRAY) 

        EndDrawing() 
        '----------------------------------------------------------------------------------
    
	Wend

    ' De-Initialization
    '--------------------------------------------------------------------------------------
    UnloadMusicStream(musica)    ' Unload music stream buffers from RAM

    CloseAudioDevice()          ' Close audio device (music streaming is automatically stopped)

    delete(delayBuffer)        ' Free delay buffer

    CloseWindow()               ' Close window and OpenGL context
    '--------------------------------------------------------------------------------------
	
	end
	
	

'------------------------------------------------------------------------------------
' Module Functions Definition
'------------------------------------------------------------------------------------
' Audio effect: lowpass filter
Sub AudioProcessEffectLPF cdecl(buffer As Any Ptr , frames As ULong)

    static As Single low(1) = { 0.0f, 0.0f } 
    Static As Single cutoff = 70.0f / 44100.0f  ' 70 Hz lowpass filter
    dim As Single k = cutoff / (cutoff + 0.1591549431f)  ' RC filter formula

    for i As ULong = 0 To (frames*2)-1 Step 2      
     
        Dim As Single l = Cast(Single Ptr,buffer)[i], r = Cast(Single Ptr,buffer)[i + 1]
        low(0) += k * (l - low(0)) 
        low(1) += k * (r - low(1)) 
        Cast(Single Ptr,buffer)[i] = low(0) 
        Cast(Single Ptr,buffer)[i + 1] = low(1) 
    
    Next
End Sub

' Audio effect: delay
Sub AudioProcessEffectDelay Cdecl(buffer As Any Ptr , frames As ULong)

    for i As ULong = 0 To (frames*2)-1  Step 2     
     
        Dim As Single leftDelay  = delayBuffer[delayReadIndex ]     ' ERROR: Reading buffer -> WHY??? Maybe thread related???
        delayReadIndex+=1
        Dim As Single rightDelay = delayBuffer[delayReadIndex ] 
        delayReadIndex+=1

        if (delayReadIndex = delayBufferSize) Then delayReadIndex = 0 

        Cast(Single Ptr,buffer)[i] = 0.5f*Cast(Single Ptr,buffer)[i] + 0.5f*leftDelay 
        Cast(Single Ptr,buffer)[i + 1] = 0.5f*Cast(Single Ptr,buffer)[i + 1] + 0.5f*rightDelay 

        delayBuffer[delayWriteIndex ] = Cast(Single Ptr,buffer)[i] 
        delayReadIndex+=1
        delayBuffer[delayWriteIndex ] = Cast(Single Ptr,buffer)[i + 1] 
        delayReadIndex+=1
        if (delayWriteIndex = delayBufferSize) Then delayWriteIndex = 0 
    
    Next
End Sub
