/'*******************************************************************************************
*
*   raylib [audio] example - Raw audio streaming
*
*   Example originally created with raylib 1.6, last time updated with raylib 4.2
*
*   Example created by Ramon Santamaria (@raysan5) and reviewed by James Hofmann (@triplefox)
*
*   revisado por Joseba Epalza a version 5.0 Enero 2024 <jepalza gmail com>
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5) and James Hofmann (@triplefox)
*
********************************************************************************************'/

#include once "../raylib.bi"
#include once "crt.bi" ' Required for: memcpy()

#define MAX_SAMPLES               512
#define MAX_SAMPLES_PER_UPDATE   4096



' Cycles per second (hz)
dim Shared As single frequency = 440.0f

' Audio frequency, for smoothing
dim Shared As single audioFrequency = 440.0f

' Previous value, used to test if sine needs to be rewritten, and to smoothly modulate frequency
dim Shared As single oldFrequency = 1.0f

' Cursor to read and copy the samples of the sine wave buffer
dim Shared As long readCursor = 0




' Index for audio rendering
Dim Shared As single sineIdx = 0.0

' Audio input processing callback
Sub AudioInputCallback Cdecl ( buffer As Any ptr, frames As ulong)
    audioFrequency = frequency + (audioFrequency - frequency)*0.95f
    audioFrequency += 1.0f
    audioFrequency -= 1.0f
    Dim As Single incr = audioFrequency/44100.0f
    Dim As Short Ptr d = Cast(short ptr,buffer)

    for i As ulong = 0 To (frames-1)
        d[i] = cast(Short,32000.0f*sin(2*PI*sineIdx))
        sineIdx += incr
        if (sineIdx > 1.0f) Then sineIdx -= 1.0f
    Next
End Sub




' Initialization
const as long screenWidth = 800, screenHeight = 450

InitWindow( screenWidth, screenHeight, "raylib [audio] example - raw audio streaming" )

InitAudioDevice()

SetAudioStreamBufferSizeDefault(MAX_SAMPLES_PER_UPDATE)

' Init raw audio stream (sample rate: 44100, sample size: 16bit-short, channels: 1-mono)
dim as AudioStream stream = LoadAudioStream( 44100, 16, 1 )

SetAudioStreamCallback(stream, @AudioInputCallback)

' Buffer for the single cycle waveform we are synthesizing
dim as short ptr _data = Cast(Short Ptr ,Allocate( sizeof( short ) * MAX_SAMPLES ) )

' Frame buffer, describing the waveform when repeated over the course of a frame
dim as short ptr writeBuf = Cast(Short Ptr ,Allocate( sizeof( short ) * MAX_SAMPLES_PER_UPDATE ) )

' Start processing stream buffer (no data loaded currently)
PlayAudioStream( stream )

' Position read in to determine next frequency
dim as Vector2 mousePosition = Vector2( -100.0f, -100.0f )

' Computed size in samples of the sine wave
dim as long waveLength = 1

dim as Vector2 position = Vector2( 0, 0 )

SetTargetFPS( 30 )

' Main game loop
do while( not WindowShouldClose() )
  ' Update
  ' Sample mouse input.
  mousePosition = GetMousePosition()
  
  if( IsMouseButtonDown( MOUSE_LEFT_BUTTON ) ) then
    dim as single fp  = Cast(Single,mousePosition.y)
    frequency = 40.0f + Cast(Single,fp)
    
    Dim As Single pan = Cast(Single,mousePosition.x) / Cast(Single,screenWidth)
    SetAudioStreamPan(stream, pan)
  end if
  
  ' Rewrite the sine wave.
  ' Compute two cycles to allow the buffer padding, simplifying any modulation, resampling, etc.
  if( frequency <> oldFrequency ) then
    ' Compute wavelength. Limit size in both directions
    dim as long oldWavelength = waveLength
    
    waveLength = 22050 / frequency
    
    if( waveLength > MAX_SAMPLES / 2 ) then waveLength = MAX_SAMPLES / 2
    if( waveLength < 1 ) then waveLength = 1

    ' Write sine wave
    for i as long = 0 to ( waveLength * 2 ) - 1
      _data[ i ] = sin( ( ( 2 * PI * i / waveLength ) ) ) * 32000
    Next
    
   ' Make sure the rest of the line is flat
   for j As Integer = waveLength*2 To MAX_SAMPLES-1
       _data[ j ] = 0
   Next
      
    ' Scale read cursor's position to minimize transition artifacts
    'readCursor = int( readCursor * ( waveLength / oldWavelength ) )
    oldFrequency = frequency
  end if
  
  ' Draw
  BeginDrawing()
    ClearBackground( RAYWHITE )
    
    DrawText( TextFormat( "sine frequency: %i", Cast(Integer,frequency) ), GetScreenWidth() - 220, 10, 20, RED )
    DrawText( "click mouse button to change frequency or pan", 10, 10, 20, DARKGRAY )
    
    ' Draw the current buffer state proportionate to the screen
    for i as long = 0 to screenWidth - 1
      position.x = i
      position.y = 250 + 50 * _data[ i * MAX_SAMPLES / screenWidth ] / 32000
      
      DrawPixelV( position, RED )
    next
  EndDrawing()
loop

' De-Initialization
deallocate( _data )
deallocate( writeBuf )

UnloadAudioStream( stream )
CloseAudioDevice()

CloseWindow()
