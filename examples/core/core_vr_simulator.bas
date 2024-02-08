 /'******************************************************************************************
*
*   raylib [core] example - VR Simulator (Oculus Rift CV1 parameters)
*
*   Example originally created with raylib 2.5, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2023 Ramon Santamaria (@raysan5)
*
*******************************************************************************************'/

#include "..\raylib.bi"

#if defined(PLATFORM_DESKTOP)
    #define GLSL_VERSION        330
#else   '' PLATFORM_ANDROID, PLATFORM_WEB
    #define GLSL_VERSION        100
#endif

''------------------------------------------------------------------------------------
'' Program main entry point
''------------------------------------------------------------------------------------

    '' Initialization
    ''--------------------------------------------------------------------------------------
    Dim As Integer screenWidth = 800 
    Dim As Integer screenHeight = 450 

    '' NOTE: screenWidth/screenHeight should match VR device aspect ratio
    InitWindow(screenWidth, screenHeight, "raylib [core] example - vr simulator") 

    '' VR device parameters definition
    Dim As VrDeviceInfo device 
    
    With device
        '' Oculus Rift CV1 parameters for simulator
        .hResolution = 2160                 '' Horizontal resolution in pixels
        .vResolution = 1200                 '' Vertical resolution in pixels
        .hScreenSize = 0.133793f            '' Horizontal size in meters
        .vScreenSize = 0.0669f              '' Vertical size in meters
        .vScreenCenter = 0.04678f           '' Screen center in meters
        .eyeToScreenDistance = 0.041f       '' Distance between eye and display in meters
        .lensSeparationDistance = 0.07f     '' Lens separation distance in meters
        .interpupillaryDistance = 0.07f     '' IPD (distance between pupils) in meters

        '' NOTE: CV1 uses fresnel-hybrid-asymmetric lenses with specific compute shaders
        '' Following parameters are just an approximation to CV1 distortion stereo rendering
        .lensDistortionValues(0) = 1.0f     '' Lens distortion constant parameter 0
        .lensDistortionValues(1) = 0.22f    '' Lens distortion constant parameter 1
        .lensDistortionValues(2) = 0.24f    '' Lens distortion constant parameter 2
        .lensDistortionValues(3) = 0.0f     '' Lens distortion constant parameter 3
        .chromaAbCorrection(0) = 0.996f     '' Chromatic aberration correction parameter 0
        .chromaAbCorrection(1) = -0.004f    '' Chromatic aberration correction parameter 1
        .chromaAbCorrection(2) = 1.014f     '' Chromatic aberration correction parameter 2
        .chromaAbCorrection(3) = 0.0f       '' Chromatic aberration correction parameter 3
    End with 

    '' Load VR stereo config for VR device parameteres (Oculus Rift CV1 parameters)
    Dim As VrStereoConfig config = LoadVrStereoConfig(device) 

    '' Distortion shader (uses device lens distortion and chroma)
    Dim As Shader distortion = LoadShader(0, TextFormat("resources/distortion%i.fs", GLSL_VERSION)) 

    '' Update distortion shader with lens and distortion-scale parameters
    SetShaderValue(distortion, GetShaderLocation(distortion, "leftLensCenter"),_
                   @config.leftLensCenter(0), SHADER_UNIFORM_VEC2) 
    SetShaderValue(distortion, GetShaderLocation(distortion, "rightLensCenter"),_
                   @config.rightLensCenter(0), SHADER_UNIFORM_VEC2) 
    SetShaderValue(distortion, GetShaderLocation(distortion, "leftScreenCenter"),_
                   @config.leftScreenCenter(0), SHADER_UNIFORM_VEC2) 
    SetShaderValue(distortion, GetShaderLocation(distortion, "rightScreenCenter"),_
                   @config.rightScreenCenter(0), SHADER_UNIFORM_VEC2) 

    SetShaderValue(distortion, GetShaderLocation(distortion, "scale"),_
                   @config.scale(0), SHADER_UNIFORM_VEC2) 
    SetShaderValue(distortion, GetShaderLocation(distortion, "scaleIn"),_
                   @config.scaleIn(0), SHADER_UNIFORM_VEC2) 
    SetShaderValue(distortion, GetShaderLocation(distortion, "deviceWarpParam"),_
                   @device.lensDistortionValues(0), SHADER_UNIFORM_VEC4) 
    SetShaderValue(distortion, GetShaderLocation(distortion, "chromaAbParam"),_
                   @device.chromaAbCorrection(0), SHADER_UNIFORM_VEC4) 

    '' Initialize framebuffer for stereo rendering
    '' NOTE: Screen size should match HMD aspect ratio
    Dim As RenderTexture2D target = LoadRenderTexture(device.hResolution, device.vResolution) 

    '' The target�s height is flipped (in the source Rectangle), due to OpenGL reasons
    Dim As Rectangle sourceRec = Rectangle( 0.0f, 0.0f, target.texture.width_, -target.texture.height_ ) 
    Dim As Rectangle destRec   = Rectangle( 0.0f, 0.0f, GetScreenWidth(), GetScreenHeight() ) 

    '' Define the camera to look into our 3d world
    Dim As Camera cameras  
    cameras.position = Vector3( 5.0f, 2.0f, 5.0f )     '' Camera position
    cameras.target = Vector3( 0.0f, 2.0f, 0.0f )       '' Camera looking at point
    cameras.up = Vector3( 0.0f, 1.0f, 0.0f )           '' Camera up vector
    cameras.fovy = 60.0f                                 '' Camera field-of-view Y
    cameras.projection = CAMERA_PERSPECTIVE              '' Camera projection type

    Dim As Vector3 cubePosition = Vector3( 0.0f, 0.0f, 0.0f )

    DisableCursor()                     '' Limit cursor to relative movement inside the window

    SetTargetFPS(90)                    '' Set our game to run at 90 frames-per-second
    ''--------------------------------------------------------------------------------------

    '' Main game loop
    while ( WindowShouldClose()=0)        '' Detect window close button or ESC key
     
        '' Update
        ''----------------------------------------------------------------------------------
        UpdateCamera(@camera, CAMERA_FIRST_PERSON) 
        ''----------------------------------------------------------------------------------

        '' Draw
        ''----------------------------------------------------------------------------------
        BeginTextureMode(target) 
            ClearBackground(RAYWHITE) 
            BeginVrStereoMode(config) 
                BeginMode3D(camera) 

                    DrawCube(cubePosition, 2.0f, 2.0f, 2.0f, RED) 
                    DrawCubeWires(cubePosition, 2.0f, 2.0f, 2.0f, MAROON) 
                    DrawGrid(40, 1.0f) 

                EndMode3D() 
            EndVrStereoMode() 
        EndTextureMode() 

        BeginDrawing() 
            ClearBackground(RAYWHITE) 
            BeginShaderMode(distortion) 
                DrawTexturePro(target.texture, sourceRec, destRec, Vector2( 0.0f, 0.0f ), 0.0f, WHITE) 
            EndShaderMode() 
            DrawFPS(10, 10) 
        EndDrawing() 
        ''----------------------------------------------------------------------------------
    
    Wend

    '' De-Initialization
    ''--------------------------------------------------------------------------------------
    UnloadVrStereoConfig(config)    '' Unload stereo config

    UnloadRenderTexture(target)     '' Unload stereo render fbo
    UnloadShader(distortion)        '' Unload distortion shader

    CloseWindow()                   '' Close window and OpenGL context
    ''--------------------------------------------------------------------------------------

