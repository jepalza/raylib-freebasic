#Pragma once

#include once "crt/long.bi"
#include once "crt/stdarg.bi"

'' The following symbols have been renamed:
''     struct Color => RLColor

#inclib "raylib"

#if defined(__FB_CYGWIN__) or defined(__FB_LINUX__) or defined(__FB_FREEBSD__) or defined(__FB_OPENBSD__) or defined(__FB_NETBSD__)
    #inclib "GL"
    #inclib "X11"
#endif

#ifdef __FB_LINUX__
    #inclib "dl"
    #inclib "rt"
#elseif defined(__FB_CYGWIN__) or defined(__FB_FREEBSD__) or defined(__FB_OPENBSD__) or defined(__FB_NETBSD__)
    #inclib "Xrandr"
    #inclib "Xinerama"
    #inclib "Xi"
    #inclib "Xxf86vm"
    #inclib "Xcursor"
#elseif defined(__FB_DARWIN__)
    #inclib "OpenGL"
    #inclib "Cocoa"
#elseif defined(__FB_WIN32__)
    #inclib "opengl32"
    #inclib "gdi32"
    #inclib "winmm"
#endif

extern "C"

#define RAYLIB_H
const RAYLIB_VERSION_MAJOR = 5
const RAYLIB_VERSION_MINOR = 0
const RAYLIB_VERSION_PATCH = 0
#define RAYLIB_VERSION "5.0"

#ifndef PI
	const PI = 3.14159265358979323846
#endif

const DEG2RAD = PI / 180.0f
const RAD2DEG = 180.0f / PI
#define RL_MALLOC(sz) malloc(sz)
#define RL_CALLOC(n, sz) calloc(n, sz)
#define RL_REALLOC(ptr, sz) realloc(ptr, sz)
#define RL_FREE(ptr) free(ptr)
#define RL_COLOR_TYPE
#define RL_RECTANGLE_TYPE
#define RL_VECTOR2_TYPE
#define RL_VECTOR3_TYPE
#define RL_VECTOR4_TYPE
#define RL_QUATERNION_TYPE
#define RL_MATRIX_TYPE

#define LIGHTGRAY RLColor( 200, 200, 200, 255 )
#define GRAY RLColor( 130, 130, 130, 255 )
#define DARKGRAY RLColor( 80, 80, 80, 255 )
#define YELLOW RLColor( 253, 249, 0, 255 )
#define GOLD RLColor( 255, 203, 0, 255 )
#define ORANGE RLColor( 255, 161, 0, 255 )
#define PINK RLColor( 255, 109, 194, 255 )
#define RED RLColor( 230, 41, 55, 255 )
#define MAROON RLColor( 190, 33, 55, 255 )
#define GREEN RLColor( 0, 228, 48, 255 )
#define LIME RLColor( 0, 158, 47, 255 )
#define DARKGREEN RLColor( 0, 117, 44, 255 )
#define SKYBLUE RLColor( 102, 191, 255, 255 )
#define BLUE RLColor( 0, 121, 241, 255 )
#define DARKBLUE RLColor( 0, 82, 172, 255 )
#define PURPLE RLColor( 200, 122, 255, 255 )
#define VIOLET RLColor( 135, 60, 190, 255 )
#define DARKPURPLE RLColor( 112, 31, 126, 255 )
#define BEIGE RLColor( 211, 176, 131, 255 )
#define BROWN RLColor( 127, 106, 79, 255 )
#define DARKBROWN RLColor( 76, 63, 47, 255 )
#define WHITE RLColor( 255, 255, 255, 255 )
#define BLACK RLColor( 0, 0, 0, 255 )
#define BLANK RLColor( 0, 0, 0, 0 )
#define MAGENTA RLColor( 255, 0, 255, 255 )
#define RAYWHITE RLColor( 245, 245, 245, 255 )

#ifndef Vector2
	type Vector2
		x as single
		y as single
		declare constructor()
		declare constructor(x as single, y as single)
	end type

	constructor Vector2(x as single, y as single)
		this.x = x
		this.y = y
	end constructor
	
	constructor Vector2()
	end constructor
#endif




#ifndef Vector3
	type Vector3
		x as single
		y as single
		z as single
		declare constructor()
		declare constructor(x as single, y as single, z as single)
	end type
	
	constructor Vector3()
	end constructor

	constructor Vector3(x as single, y as single, z as single)
		this.x = x
		this.y = y
	    this.z = z
	end constructor
#endif




#ifndef Vector4
	type Vector4
		x as single
		y as single
		z as single
		w as single
		declare constructor()
		declare constructor(x as single, y as single, z as single, w as single)
	end type
	
	constructor Vector4()
	end constructor
	
	constructor Vector4(x as single, y as single, z as single, w as single)
		this.x = x
		this.y = y
		this.z = z
		this.w = w
	end constructor
#endif




#ifndef Quaternion
	type Quaternion as Vector4
#endif




#ifndef Matrix
	type Matrix
		m0 as single
		m4 as single
		m8 as single
		m12 as single
		m1 as single
		m5 as single
		m9 as single
		m13 as single
		m2 as single
		m6 as single
		m10 as single
		m14 as single
		m3 as single
		m7 as single
		m11 as single
		m15 as single
	end type
#EndIf




type RLColor
	r as ubyte
	g as ubyte
	b as ubyte
	a as ubyte
	declare constructor()
	declare constructor(r as ubyte, g as ubyte, b as ubyte, a as ubyte)
end type

constructor RLColor(r as ubyte, g as ubyte, b as ubyte, a as ubyte)
	this.r = r
	this.g = g
	this.b = b
	this.a = a
end constructor

constructor RLColor()
end constructor




type Rectangle
	x as single
	y as single
	width_ as single
	height_ as single
	declare constructor()
	declare constructor(x as single, y as single, width_ as single, height_ as single)
end type

constructor Rectangle()
end constructor

constructor Rectangle(x as single, y as single, width_ as single, height_ as single)
	this.x = x
	this.y = y
	this.width_ = width_
	this.height_ = height_
end constructor




type Image
	data_ as any ptr
	width_ as long
	height_ as long
	mipmaps as long
	format_ as long
end type

type Texture
	id as ulong
	width_ as long
	height_ as long
	mipmaps as long
	format_ as long
end type

type Texture2D as Texture
type TextureCubemap as Texture

type RenderTexture
	id as ulong
	texture as Texture
	depth as Texture
end type

type RenderTexture2D as RenderTexture

type NPatchInfo
	source as Rectangle
	left_ as long
	top as long
	right_ as long
	bottom as long
	layout as long
end type

type GlyphInfo
	value as long
	offsetX as long
	offsetY as long
	advanceX as long
	image_ as Image
end type

type Font
	baseSize as long
	glyphCount as long
	glyphPadding as long
	texture as Texture2D
	recs as Rectangle ptr
	glyphs as GlyphInfo ptr
end type




type Camera3D
	position as Vector3
	target as Vector3
	up as Vector3
	fovy as single
	projection as long
	declare constructor()
	declare constructor(position as Vector3, target as Vector3, up as Vector3, fovy as single, projection as long)
end type

constructor Camera3D() 
end constructor 

constructor Camera3D(position as Vector3, target as Vector3, up as Vector3, fovy as single, projection as long)
	this.position = position
	this.target = target
	this.up = up
	this.fovy = fovy
	this.projection = projection 
end constructor  

type Camera as Camera3D




type Camera2D
	offset as Vector2
	target as Vector2
	rotation as single
	zoom as single
	declare constructor()
	declare constructor(offset as Vector2, target as Vector2, rototation as single, zoom as single)
end type

constructor Camera2D()
end constructor

constructor Camera2D(offset as Vector2, target as Vector2, rotation as single, zoom as single)
	this.offset = offset
	this.target = target
	this.rotation = rotation 
	this.zoom = zoom
end constructor 




type Mesh
	vertexCount as long
	triangleCount as long
	vertices as single ptr
	texcoords as single ptr
	texcoords2 as single ptr
	normals as single ptr
	tangents as single ptr
	colors as ubyte ptr
	indices as ushort ptr
	animVertices as single ptr
	animNormals as single ptr
	boneIds as ubyte ptr
	boneWeights as single ptr
	vaoId as ulong
	vboId as ulong ptr
end type

type Shader
	id as ulong
	locs as long ptr
end type

type MaterialMap
	texture as Texture2D
	color as RLColor
	value as single
end type

type Material
	shader as Shader
	maps as MaterialMap ptr
	params(0 to 3) as single
end type

type Transform
	translation as Vector3
	rotation as Quaternion
	scale as Vector3
end type

type BoneInfo
	name_ as zstring * 32
	parent as long
end type

type Model
	transform as Matrix
	meshCount as long
	materialCount as long
	meshes as Mesh ptr
	materials as Material ptr
	meshMaterial as long ptr
	boneCount as long
	bones as BoneInfo ptr
	bindPose as Transform ptr
end type

' jepalza 2024, faltaba "names"
type ModelAnimation
    As Long boneCount           ' Number of bones
    As Long frameCount          ' Number of animation frames
    As BoneInfo Ptr bones         ' Bones information (skeleton)
    As Transform Ptr Ptr framePoses  ' Poses array by frame
    As ZString*32 names           ' Animation name
end type

type Ray
	position as Vector3
	direction as Vector3
end type

type RayCollision
	hit as boolean
	distance as single
	point_ as Vector3
	normal as Vector3
end type




' jepalza, 2024, mejor empleo de BoundingBox
'type BoundingBox
'	min as Vector3
'	max as Vector3
'end type

' BoundingBox
Type BoundingBox
	declare constructor()
	declare constructor( as Vector3, as Vector3 )
	
    As Vector3 mins             ' Minimum vertex box-corner
    As Vector3 maxs             ' Maximum vertex box-corner
end type

constructor BoundingBox()
	end constructor
constructor BoundingBox( _min as Vector3, _max as Vector3 )
  this.mins = _min
  this.maxs = _max
end Constructor




type Wave
	frameCount as ulong
	sampleRate as ulong
	sampleSize as ulong
	channels as ulong
	data_ as any ptr
end type

type rAudioBuffer as rAudioBuffer_
type rAudioProcessor as rAudioProcessor_

type AudioStream
	buffer as rAudioBuffer ptr
	processor as rAudioProcessor ptr
	sampleRate as ulong
	sampleSize as ulong
	channels as ulong
end type

type Sound
	stream as AudioStream
	frameCount as ulong
end type

type Music
	stream as AudioStream
	frameCount as ulong
	looping as boolean
	ctxType as long
	ctxData as any ptr
end type

type VrDeviceInfo
	hResolution as long
	vResolution as long
	hScreenSize as single
	vScreenSize as single
	vScreenCenter as single
	eyeToScreenDistance as single
	lensSeparationDistance as single
	interpupillaryDistance as single
	lensDistortionValues(0 to 3) as single
	chromaAbCorrection(0 to 3) as single
end type

type VrStereoConfig
	projection(0 to 1) as Matrix
	viewOffset(0 to 1) as Matrix
	leftLensCenter(0 to 1) as single
	rightLensCenter(0 to 1) as single
	leftScreenCenter(0 to 1) as single
	rightScreenCenter(0 to 1) as single
	scale(0 to 1) as single
	scaleIn(0 to 1) as single
end type

type FilePathList
	capacity as ulong
	count as ulong
	paths as zstring ptr ptr
end type

type AutomationEvent
	frame as ulong
	type_ as ulong
	params(0 to 4) as long
end type

type AutomationEventList
	capacity as ulong
	count as ulong
	events as AutomationEvent ptr
end type

type ConfigFlags as long
enum
	FLAG_VSYNC_HINT = &h00000040
	FLAG_FULLSCREEN_MODE = &h00000002
	FLAG_WINDOW_RESIZABLE = &h00000004
	FLAG_WINDOW_UNDECORATED = &h00000008
	FLAG_WINDOW_HIDDEN = &h00000080
	FLAG_WINDOW_MINIMIZED = &h00000200
	FLAG_WINDOW_MAXIMIZED = &h00000400
	FLAG_WINDOW_UNFOCUSED = &h00000800
	FLAG_WINDOW_TOPMOST = &h00001000
	FLAG_WINDOW_ALWAYS_RUN = &h00000100
	FLAG_WINDOW_TRANSPARENT = &h00000010
	FLAG_WINDOW_HIGHDPI = &h00002000
	FLAG_WINDOW_MOUSE_PASSTHROUGH = &h00004000
	FLAG_MSAA_4X_HINT = &h00000020
	FLAG_INTERLACED_HINT = &h00010000
end enum

type TraceLogLevel as long
enum
	LOG_ALL = 0
	LOG_TRACE
	LOG_DEBUG
	LOG_INFO
	LOG_WARNING
	LOG_ERROR
	LOG_FATAL
	LOG_NONE
end enum

type KeyboardKey as long
enum
	KEY_NULL = 0
	KEY_APOSTROPHE = 39
	KEY_COMMA = 44
	KEY_MINUS = 45
	KEY_PERIOD = 46
	KEY_SLASH = 47
	KEY_ZERO = 48
	KEY_ONE = 49
	KEY_TWO = 50
	KEY_THREE = 51
	KEY_FOUR = 52
	KEY_FIVE = 53
	KEY_SIX = 54
	KEY_SEVEN = 55
	KEY_EIGHT = 56
	KEY_NINE = 57
	KEY_SEMICOLON = 59
	KEY_EQUAL = 61
	KEY_A = 65
	KEY_B = 66
	KEY_C = 67
	KEY_D = 68
	KEY_E = 69
	KEY_F = 70
	KEY_G = 71
	KEY_H = 72
	KEY_I = 73
	KEY_J = 74
	KEY_K = 75
	KEY_L = 76
	KEY_M = 77
	KEY_N = 78
	KEY_O = 79
	KEY_P = 80
	KEY_Q = 81
	KEY_R = 82
	KEY_S = 83
	KEY_T = 84
	KEY_U = 85
	KEY_V = 86
	KEY_W = 87
	KEY_X = 88
	KEY_Y = 89
	KEY_Z = 90
	KEY_LEFT_BRACKET = 91
	KEY_BACKSLASH = 92
	KEY_RIGHT_BRACKET = 93
	KEY_GRAVE = 96
	KEY_SPACE = 32
	KEY_ESCAPE = 256
	KEY_ENTER = 257
	KEY_TAB = 258
	KEY_BACKSPACE = 259
	KEY_INSERT = 260
	KEY_DELETE = 261
	KEY_RIGHT = 262
	KEY_LEFT = 263
	KEY_DOWN = 264
	KEY_UP = 265
	KEY_PAGE_UP = 266
	KEY_PAGE_DOWN = 267
	KEY_HOME = 268
	KEY_END = 269
	KEY_CAPS_LOCK = 280
	KEY_SCROLL_LOCK = 281
	KEY_NUM_LOCK = 282
	KEY_PRINT_SCREEN = 283
	KEY_PAUSE = 284
	KEY_F1 = 290
	KEY_F2 = 291
	KEY_F3 = 292
	KEY_F4 = 293
	KEY_F5 = 294
	KEY_F6 = 295
	KEY_F7 = 296
	KEY_F8 = 297
	KEY_F9 = 298
	KEY_F10 = 299
	KEY_F11 = 300
	KEY_F12 = 301
	KEY_LEFT_SHIFT = 340
	KEY_LEFT_CONTROL = 341
	KEY_LEFT_ALT = 342
	KEY_LEFT_SUPER = 343
	KEY_RIGHT_SHIFT = 344
	KEY_RIGHT_CONTROL = 345
	KEY_RIGHT_ALT = 346
	KEY_RIGHT_SUPER = 347
	KEY_KB_MENU = 348
	KEY_KP_0 = 320
	KEY_KP_1 = 321
	KEY_KP_2 = 322
	KEY_KP_3 = 323
	KEY_KP_4 = 324
	KEY_KP_5 = 325
	KEY_KP_6 = 326
	KEY_KP_7 = 327
	KEY_KP_8 = 328
	KEY_KP_9 = 329
	KEY_KP_DECIMAL = 330
	KEY_KP_DIVIDE = 331
	KEY_KP_MULTIPLY = 332
	KEY_KP_SUBTRACT = 333
	KEY_KP_ADD = 334
	KEY_KP_ENTER = 335
	KEY_KP_EQUAL = 336
	KEY_BACK = 4
	KEY_MENU = 82
	KEY_VOLUME_UP = 24
	KEY_VOLUME_DOWN = 25
end enum

type MouseButton as long
enum
	MOUSE_BUTTON_LEFT = 0
	MOUSE_BUTTON_RIGHT = 1
	MOUSE_BUTTON_MIDDLE = 2
	MOUSE_BUTTON_SIDE = 3
	MOUSE_BUTTON_EXTRA = 4
	MOUSE_BUTTON_FORWARD = 5
	MOUSE_BUTTON_BACK = 6
end enum

const MOUSE_MIDDLE_BUTTON = MOUSE_BUTTON_MIDDLE
const MOUSE_RIGHT_BUTTON = MOUSE_BUTTON_RIGHT
const MOUSE_LEFT_BUTTON = MOUSE_BUTTON_LEFT

type MouseCursor as long
enum
	MOUSE_CURSOR_DEFAULT = 0
	MOUSE_CURSOR_ARROW = 1
	MOUSE_CURSOR_IBEAM = 2
	MOUSE_CURSOR_CROSSHAIR = 3
	MOUSE_CURSOR_POINTING_HAND = 4
	MOUSE_CURSOR_RESIZE_EW = 5
	MOUSE_CURSOR_RESIZE_NS = 6
	MOUSE_CURSOR_RESIZE_NWSE = 7
	MOUSE_CURSOR_RESIZE_NESW = 8
	MOUSE_CURSOR_RESIZE_ALL = 9
	MOUSE_CURSOR_NOT_ALLOWED = 10
end enum

type GamepadButton as long
enum
	GAMEPAD_BUTTON_UNKNOWN = 0
	GAMEPAD_BUTTON_LEFT_FACE_UP
	GAMEPAD_BUTTON_LEFT_FACE_RIGHT
	GAMEPAD_BUTTON_LEFT_FACE_DOWN
	GAMEPAD_BUTTON_LEFT_FACE_LEFT
	GAMEPAD_BUTTON_RIGHT_FACE_UP
	GAMEPAD_BUTTON_RIGHT_FACE_RIGHT
	GAMEPAD_BUTTON_RIGHT_FACE_DOWN
	GAMEPAD_BUTTON_RIGHT_FACE_LEFT
	GAMEPAD_BUTTON_LEFT_TRIGGER_1
	GAMEPAD_BUTTON_LEFT_TRIGGER_2
	GAMEPAD_BUTTON_RIGHT_TRIGGER_1
	GAMEPAD_BUTTON_RIGHT_TRIGGER_2
	GAMEPAD_BUTTON_MIDDLE_LEFT
	GAMEPAD_BUTTON_MIDDLE
	GAMEPAD_BUTTON_MIDDLE_RIGHT
	GAMEPAD_BUTTON_LEFT_THUMB
	GAMEPAD_BUTTON_RIGHT_THUMB
end enum

type GamepadAxis as long
enum
	GAMEPAD_AXIS_LEFT_X = 0
	GAMEPAD_AXIS_LEFT_Y = 1
	GAMEPAD_AXIS_RIGHT_X = 2
	GAMEPAD_AXIS_RIGHT_Y = 3
	GAMEPAD_AXIS_LEFT_TRIGGER = 4
	GAMEPAD_AXIS_RIGHT_TRIGGER = 5
end enum

type MaterialMapIndex as long
enum
	MATERIAL_MAP_ALBEDO = 0
	MATERIAL_MAP_METALNESS
	MATERIAL_MAP_NORMAL
	MATERIAL_MAP_ROUGHNESS
	MATERIAL_MAP_OCCLUSION
	MATERIAL_MAP_EMISSION
	MATERIAL_MAP_HEIGHT
	MATERIAL_MAP_CUBEMAP
	MATERIAL_MAP_IRRADIANCE
	MATERIAL_MAP_PREFILTER
	MATERIAL_MAP_BRDF
end enum

const MATERIAL_MAP_DIFFUSE = MATERIAL_MAP_ALBEDO
const MATERIAL_MAP_SPECULAR = MATERIAL_MAP_METALNESS

type ShaderLocationIndex as long
enum
	SHADER_LOC_VERTEX_POSITION = 0
	SHADER_LOC_VERTEX_TEXCOORD01
	SHADER_LOC_VERTEX_TEXCOORD02
	SHADER_LOC_VERTEX_NORMAL
	SHADER_LOC_VERTEX_TANGENT
	SHADER_LOC_VERTEX_COLOR
	SHADER_LOC_MATRIX_MVP
	SHADER_LOC_MATRIX_VIEW
	SHADER_LOC_MATRIX_PROJECTION
	SHADER_LOC_MATRIX_MODEL
	SHADER_LOC_MATRIX_NORMAL
	SHADER_LOC_VECTOR_VIEW
	SHADER_LOC_COLOR_DIFFUSE
	SHADER_LOC_COLOR_SPECULAR
	SHADER_LOC_COLOR_AMBIENT
	SHADER_LOC_MAP_ALBEDO
	SHADER_LOC_MAP_METALNESS
	SHADER_LOC_MAP_NORMAL
	SHADER_LOC_MAP_ROUGHNESS
	SHADER_LOC_MAP_OCCLUSION
	SHADER_LOC_MAP_EMISSION
	SHADER_LOC_MAP_HEIGHT
	SHADER_LOC_MAP_CUBEMAP
	SHADER_LOC_MAP_IRRADIANCE
	SHADER_LOC_MAP_PREFILTER
	SHADER_LOC_MAP_BRDF
end enum

const SHADER_LOC_MAP_DIFFUSE = SHADER_LOC_MAP_ALBEDO
const SHADER_LOC_MAP_SPECULAR = SHADER_LOC_MAP_METALNESS

type ShaderUniformDataType as long
enum
	SHADER_UNIFORM_FLOAT = 0
	SHADER_UNIFORM_VEC2
	SHADER_UNIFORM_VEC3
	SHADER_UNIFORM_VEC4
	SHADER_UNIFORM_INT
	SHADER_UNIFORM_IVEC2
	SHADER_UNIFORM_IVEC3
	SHADER_UNIFORM_IVEC4
	SHADER_UNIFORM_SAMPLER2D
end enum

type ShaderAttributeDataType as long
enum
	SHADER_ATTRIB_FLOAT = 0
	SHADER_ATTRIB_VEC2
	SHADER_ATTRIB_VEC3
	SHADER_ATTRIB_VEC4
end enum

type PixelFormat as long
enum
	PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1
	PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA
	PIXELFORMAT_UNCOMPRESSED_R5G6B5
	PIXELFORMAT_UNCOMPRESSED_R8G8B8
	PIXELFORMAT_UNCOMPRESSED_R5G5B5A1
	PIXELFORMAT_UNCOMPRESSED_R4G4B4A4
	PIXELFORMAT_UNCOMPRESSED_R8G8B8A8
	PIXELFORMAT_UNCOMPRESSED_R32
	PIXELFORMAT_UNCOMPRESSED_R32G32B32
	PIXELFORMAT_UNCOMPRESSED_R32G32B32A32
	PIXELFORMAT_UNCOMPRESSED_R16
	PIXELFORMAT_UNCOMPRESSED_R16G16B16
	PIXELFORMAT_UNCOMPRESSED_R16G16B16A16
	PIXELFORMAT_COMPRESSED_DXT1_RGB
	PIXELFORMAT_COMPRESSED_DXT1_RGBA
	PIXELFORMAT_COMPRESSED_DXT3_RGBA
	PIXELFORMAT_COMPRESSED_DXT5_RGBA
	PIXELFORMAT_COMPRESSED_ETC1_RGB
	PIXELFORMAT_COMPRESSED_ETC2_RGB
	PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA
	PIXELFORMAT_COMPRESSED_PVRT_RGB
	PIXELFORMAT_COMPRESSED_PVRT_RGBA
	PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA
	PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA
end enum

type TextureFilter as long
enum
	TEXTURE_FILTER_POINT = 0
	TEXTURE_FILTER_BILINEAR
	TEXTURE_FILTER_TRILINEAR
	TEXTURE_FILTER_ANISOTROPIC_4X
	TEXTURE_FILTER_ANISOTROPIC_8X
	TEXTURE_FILTER_ANISOTROPIC_16X
end enum

type TextureWrap as long
enum
	TEXTURE_WRAP_REPEAT = 0
	TEXTURE_WRAP_CLAMP
	TEXTURE_WRAP_MIRROR_REPEAT
	TEXTURE_WRAP_MIRROR_CLAMP
end enum

type CubemapLayout as long
enum
	CUBEMAP_LAYOUT_AUTO_DETECT = 0
	CUBEMAP_LAYOUT_LINE_VERTICAL
	CUBEMAP_LAYOUT_LINE_HORIZONTAL
	CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR
	CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE
	CUBEMAP_LAYOUT_PANORAMA
end enum

type FontType as long
enum
	FONT_DEFAULT = 0
	FONT_BITMAP
	FONT_SDF
end enum

type BlendMode as long
enum
	BLEND_ALPHA = 0
	BLEND_ADDITIVE
	BLEND_MULTIPLIED
	BLEND_ADD_COLORS
	BLEND_SUBTRACT_COLORS
	BLEND_ALPHA_PREMULTIPLY
	BLEND_CUSTOM
  BLEND_CUSTOM_SEPARATE
end enum

type Gesture as long
enum
	GESTURE_NONE = 0
	GESTURE_TAP = 1
	GESTURE_DOUBLETAP = 2
	GESTURE_HOLD = 4
	GESTURE_DRAG = 8
	GESTURE_SWIPE_RIGHT = 16
	GESTURE_SWIPE_LEFT = 32
	GESTURE_SWIPE_UP = 64
	GESTURE_SWIPE_DOWN = 128
	GESTURE_PINCH_IN = 256
	GESTURE_PINCH_OUT = 512
end enum

type CameraMode as long
enum
	CAMERA_CUSTOM = 0
	CAMERA_FREE
	CAMERA_ORBITAL
	CAMERA_FIRST_PERSON
	CAMERA_THIRD_PERSON
end enum

type CameraProjection as long
enum
	CAMERA_PERSPECTIVE = 0
	CAMERA_ORTHOGRAPHIC
end enum

type NPatchLayout as long
enum
	NPATCH_NINE_PATCH = 0
	NPATCH_THREE_PATCH_VERTICAL
	NPATCH_THREE_PATCH_HORIZONTAL
end enum

type TraceLogCallback as sub(byval logLevel as long, byval text as const zstring ptr, byval args as va_list)

type LoadFileDataCallback as function(byval fileName as const zstring ptr, byval dataSize as long ptr) as ubyte ptr

type SaveFileDataCallback as function(byval fileName as const zstring ptr, byval data_ as any ptr, byval dataSize as long) as boolean

type LoadFileTextCallback as function(byval fileName as const zstring ptr) as zstring ptr

type SaveFileTextCallback as function(byval fileName as const zstring ptr, byval text as zstring ptr) as boolean

declare sub InitWindow(byval width_ as long, byval height_ as long, byval title as const zstring ptr)
declare function WindowShouldClose() as boolean
declare sub CloseWindow()
declare function IsWindowReady() as boolean
declare function IsWindowFullscreen() as boolean
declare function IsWindowHidden() as boolean
declare function IsWindowMinimized() as boolean
declare function IsWindowMaximized() as boolean
declare function IsWindowFocused() as boolean
declare function IsWindowResized() as boolean
declare function IsWindowState(byval flag as ulong) as boolean
declare sub SetWindowState(byval flags as ulong)
declare sub ClearWindowState(byval flags as ulong)
declare sub ToggleFullscreen()
declare sub ToggleBorderlessWindow()
declare sub MaximizeWindow()
declare sub MinimizeWindow()
declare sub RestoreWindow()
declare sub SetWindowIcon(byval image_ as Image)
declare sub SetWindowIcons(byval images as Image ptr, byval count as long)
declare sub SetWindowTitle(byval title as const zstring ptr)
declare sub SetWindowPosition(byval x as long, byval y as long)
declare sub SetWindowMonitor(byval monitor as long)
declare sub SetWindowMinSize(byval width_ as long, byval height_ as long)
declare sub SetWindowMaxSize(byval width_ as long, byval height_ as long)
declare sub SetWindowSize(byval width_ as long, byval height_ as long)
declare sub SetWindowOpacity(byval opacity as single)
declare sub SetWindowFocused()
declare function GetWindowHandle() as any ptr
declare function GetScreenWidth() as long
declare function GetScreenHeight() as long
declare function GetRenderWidth() as long
declare function GetRenderHeight() as long
declare function GetMonitorCount() as long
declare function GetCurrentMonitor() as long
declare function GetMonitorPosition(byval monitor as long) as Vector2
declare function GetMonitorWidth(byval monitor as long) as long
declare function GetMonitorHeight(byval monitor as long) as long
declare function GetMonitorPhysicalWidth(byval monitor as long) as long
declare function GetMonitorPhysicalHeight(byval monitor as long) as long
declare function GetMonitorRefreshRate(byval monitor as long) as long
declare function GetWindowPosition() as Vector2
declare function GetWindowScaleDPI() as Vector2
declare function GetMonitorName(byval monitor as long) as const zstring ptr
declare sub SetClipboardText(byval text as const zstring ptr)
declare function GetClipboardText() as const zstring ptr
declare sub EnableEventWaiting()
declare sub DisableEventWaiting()
declare sub SwapScreenBuffer()
declare sub PollInputEvents()
declare sub WaitTime(byval seconds as double)
declare sub ShowCursor()
declare sub HideCursor()
declare function IsCursorHidden() as boolean
declare sub EnableCursor()
declare sub DisableCursor()
declare function IsCursorOnScreen() as boolean
declare sub ClearBackground(byval color as RLColor)
declare sub BeginDrawing()
declare sub EndDrawing()
declare sub BeginMode2D(byval camera as Camera2D)
declare sub EndMode2D()
declare sub BeginMode3D(byval camera as Camera3D)
declare sub EndMode3D()
declare sub BeginTextureMode(byval target as RenderTexture2D)
declare sub EndTextureMode()
declare sub BeginShaderMode(byval shader as Shader)
declare sub EndShaderMode()
declare sub BeginBlendMode(byval mode as long)
declare sub EndBlendMode()
declare sub BeginScissorMode(byval x as long, byval y as long, byval width_ as long, byval height_ as long)
declare sub EndScissorMode()
declare sub BeginVrStereoMode(byref config as VrStereoConfig)
declare sub EndVrStereoMode()
declare function LoadVrStereoConfig(byval device as VrDeviceInfo) as VrStereoConfig
declare sub UnloadVrStereoConfig(byref config as VrStereoConfig)
declare function LoadShader(byval vsFileName as const zstring ptr, byval fsFileName as const zstring ptr) as Shader
declare function LoadShaderFromMemory(byval vsCode as const zstring ptr, byval fsCode as const zstring ptr) as Shader
declare function IsShaderReady(byval shader as Shader) as byte
declare function GetShaderLocation(byval shader as Shader, byval uniformName as const zstring ptr) as long
declare function GetShaderLocationAttrib(byval shader as Shader, byval attribName as const zstring ptr) as long
declare sub SetShaderValue(byval shader as Shader, byval locIndex as long, byval value as const any ptr, byval uniformType as long)
declare sub SetShaderValueV(byval shader as Shader, byval locIndex as long, byval value as const any ptr, byval uniformType as long, byval count as long)
declare sub SetShaderValueMatrix(byval shader as Shader, byval locIndex as long, byval mat as Matrix)
declare sub SetShaderValueTexture(byval shader as Shader, byval locIndex as long, byval texture as Texture2D)
declare sub UnloadShader(byval shader as Shader)
declare function GetMouseRay(byval mousePosition as Vector2, byval camera as Camera) as Ray
declare function GetCameraMatrix(byval camera as Camera) as Matrix
declare function GetCameraMatrix2D(byval camera as Camera2D) as Matrix
declare function GetWorldToScreen(byval position as Vector3, byval camera as Camera) as Vector2
declare function GetScreenToWorld2D(byval position as Vector2, byval camera as Camera2D) as Vector2
declare function GetWorldToScreenEx(byval position as Vector3, byval camera as Camera, byval width_ as long, byval height_ as long) as Vector2
declare function GetWorldToScreen2D(byval position as Vector2, byval camera as Camera2D) as Vector2
declare sub SetTargetFPS(byval fps as long)
declare function GetFPS() as long
declare function GetFrameTime() as single
declare function GetTime() as double
declare function GetRandomValue(byval min as long, byval max as long) as long
declare sub SetRandomSeed(byval seed as ulong)
declare sub TakeScreenshot(byval fileName as const zstring ptr)
declare sub SetConfigFlags(byval flags as ulong)
declare sub TraceLog(byval logLevel as long, byval text as const zstring ptr, ...)
declare sub SetTraceLogLevel(byval logLevel as long)
declare function MemAlloc(byval size as long) as any ptr
declare function MemRealloc(byval ptr as any ptr, byval size as long) as any ptr
declare sub MemFree(byval ptr as any ptr)
declare sub OpenURL(byval url as const zstring ptr)
declare sub SetTraceLogCallback(byval callback as TraceLogCallback)
declare sub SetLoadFileDataCallback(byval callback as LoadFileDataCallback)
declare sub SetSaveFileDataCallback(byval callback as SaveFileDataCallback)
declare sub SetLoadFileTextCallback(byval callback as LoadFileTextCallback)
declare sub SetSaveFileTextCallback(byval callback as SaveFileTextCallback)
declare function LoadFileData(byval fileName as const zstring ptr, byval dataSize as long ptr) as ubyte ptr
declare sub UnloadFileData(byval data_ as ubyte ptr)
declare function SaveFileData(byval fileName as const zstring ptr, byval data_ as any ptr, byval dataSize as long) as boolean
declare function ExportDataAsCode(byval data_ as const zstring ptr, byval dataSize as long, byval fileName as const zstring ptr) as boolean
declare function LoadFileText(byval fileName as const zstring ptr) as zstring ptr
declare sub UnloadFileText(byval text as zstring ptr)
declare function SaveFileText(byval fileName as const zstring ptr, byval text as zstring ptr) as boolean
declare function FileExists(byval fileName as const zstring ptr) as boolean
declare function DirectoryExists(byval dirPath as const zstring ptr) as boolean
declare function IsFileExtension(byval fileName as const zstring ptr, byval ext as const zstring ptr) as boolean
declare function GetFileLength(byval fileName as const zstring ptr) as long
declare function GetFileExtension(byval fileName as const zstring ptr) as const zstring ptr
declare function GetFileName(byval filePath as const zstring ptr) as const zstring ptr
declare function GetFileNameWithoutExt(byval filePath as const zstring ptr) as const zstring ptr
declare function GetDirectoryPath(byval filePath as const zstring ptr) as const zstring ptr
declare function GetPrevDirectoryPath(byval dirPath as const zstring ptr) as const zstring ptr
declare function GetWorkingDirectory() as const zstring ptr
declare function GetApplicationDirectory() as const zstring ptr
declare function ChangeDirectory(byval dir_ as const zstring ptr) as boolean
declare function IsPathFile(byval path as const zstring ptr) as boolean
declare function LoadDirectoryFiles(byval dirPath as const zstring ptr) as FilePathList
declare function LoadDirectoryFilesEx(byval basePath as const zstring ptr, byval filter as const zstring ptr, byval scanSubdirs as boolean) as FilePathList
declare sub UnloadDirectoryFiles(byval files as FilePathList)
declare function IsFileDropped() as boolean
declare function LoadDroppedFiles() as FilePathList
declare sub UnloadDroppedFiles(byval files as FilePathList)
declare function GetFileModTime(byval fileName as const zstring ptr) as clong
declare function CompressData(byval data_ as const ubyte ptr, byval dataSize as long, byval compDataSize as long ptr) as ubyte ptr
declare function DecompressData(byval compData as const ubyte ptr, byval compDataSize as long, byval dataSize as long ptr) as ubyte ptr
declare function EncodeDataBase64(byval data_ as const ubyte ptr, byval dataSize as long, byval outputSize as long ptr) as zstring ptr
declare function DecodeDataBase64(byval data_ as const ubyte ptr, byval outputSize as long ptr) as ubyte ptr

declare function LoadAutomationEventList(byval fileName as const zstring ptr) as AutomationEventList
declare sub UnloadAutomationEventList(byval list_ as AutomationEventList ptr)
declare function ExportAutomationEventList(byval list_ as AutomationEventList, byval fileName as const zstring ptr) as boolean
declare sub SetAutomationEventList(byval list_ as AutomationEventList ptr)
declare sub SetAutomationEventBaseFrame(byval frame_ as long)
declare sub StartAutomationEventRecording()
declare sub StopAutomationEventRecording()
declare sub PlayAutomationEvent(byval frame_ as AutomationEvent)


declare function IsKeyPressed(byval key as long) as boolean
declare function IsKeyPressedRepeat(byval key as long) as boolean
declare function IsKeyDown(byval key as long) as boolean
declare function IsKeyReleased(byval key as long) as boolean
declare function IsKeyUp(byval key as long) as boolean
declare sub SetExitKey(byval key as long)
declare function GetKeyPressed() as long
declare function GetCharPressed() as long
declare function IsGamepadAvailable(byval gamepad as long) as boolean
declare function GetGamepadName(byval gamepad as long) as const zstring ptr
declare function IsGamepadButtonPressed(byval gamepad as long, byval button as long) as boolean
declare function IsGamepadButtonDown(byval gamepad as long, byval button as long) as boolean
declare function IsGamepadButtonReleased(byval gamepad as long, byval button as long) as boolean
declare function IsGamepadButtonUp(byval gamepad as long, byval button as long) as boolean
declare function GetGamepadButtonPressed() as long
declare function GetGamepadAxisCount(byval gamepad as long) as long
declare function GetGamepadAxisMovement(byval gamepad as long, byval axis as long) as single
declare function SetGamepadMappings(byval mappings as const zstring ptr) as long
declare function IsMouseButtonPressed(byval button as long) as boolean
declare function IsMouseButtonDown(byval button as long) as boolean
declare function IsMouseButtonReleased(byval button as long) as boolean
declare function IsMouseButtonUp(byval button as long) as boolean
declare function GetMouseX() as long
declare function GetMouseY() as long
declare function GetMousePosition() as Vector2
declare function GetMouseDelta() as Vector2
declare sub SetMousePosition(byval x as long, byval y as long)
declare sub SetMouseOffset(byval offsetX as long, byval offsetY as long)
declare sub SetMouseScale(byval scaleX as single, byval scaleY as single)
declare function GetMouseWheelMove() as single
declare function GetMouseWheelMoveV() as Vector2
declare sub SetMouseCursor(byval cursor as long)
declare function GetTouchX() as long
declare function GetTouchY() as long
declare function GetTouchPosition(byval index as long) as Vector2
declare function GetTouchPointId(byval index as long) as long
declare function GetTouchPointCount() as long
declare sub SetGesturesEnabled(byval flags as ulong)
declare function IsGestureDetected(byval gesture as ulong) as boolean
declare function GetGestureDetected() as long
declare function GetGestureHoldDuration() as single
declare function GetGestureDragVector() as Vector2
declare function GetGestureDragAngle() as single
declare function GetGesturePinchVector() as Vector2
declare function GetGesturePinchAngle() as single
declare sub UpdateCamera(byval camera as Camera ptr, byval mode as long)
declare sub UpdateCameraPro(byval camera as Camera ptr, byval movement as Vector3, byval rotation as Vector3, byval zoom as single)
declare sub SetShapesTexture(byval texture as Texture2D, byval source as Rectangle)
declare sub DrawPixel(byval posX as long, byval posY as long, byval color as RLColor)
declare sub DrawPixelV(byval position as Vector2, byval color as RLColor)
declare sub DrawLine(byval startPosX as long, byval startPosY as long, byval endPosX as long, byval endPosY as long, byval color as RLColor)
declare sub DrawLineV(byval startPos as Vector2, byval endPos as Vector2, byval color as RLColor)
declare sub DrawLineEx(byval startPos as Vector2, byval endPos as Vector2, byval thick as single, byval color as RLColor)
declare sub DrawLineBezier(byval startPos as Vector2, byval endPos as Vector2, byval thick as single, byval color as RLColor)
declare sub DrawLineBezierQuad(byval startPos as Vector2, byval endPos as Vector2, byval controlPos as Vector2, byval thick as single, byval color as RLColor)
declare sub DrawLineBezierCubic(byval startPos as Vector2, byval endPos as Vector2, byval startControlPos as Vector2, byval endControlPos as Vector2, byval thick as single, byval color as RLColor)
declare sub DrawLineStrip(byval points as Vector2 ptr, byval pointCount as long, byval color as RLColor)
declare sub DrawCircle(byval centerX as long, byval centerY as long, byval radius as single, byval color as RLColor)
declare sub DrawCircleSector(byval center as Vector2, byval radius as single, byval startAngle as single, byval endAngle as single, byval segments as long, byval color as RLColor)
declare sub DrawCircleSectorLines(byval center as Vector2, byval radius as single, byval startAngle as single, byval endAngle as single, byval segments as long, byval color as RLColor)
declare sub DrawCircleGradient(byval centerX as long, byval centerY as long, byval radius as single, byval color1 as RLColor, byval color2 as RLColor)
declare sub DrawCircleV(byval center as Vector2, byval radius as single, byval color as RLColor)
declare sub DrawCircleLines(byval centerX as long, byval centerY as long, byval radius as single, byval color as RLColor)
declare sub DrawEllipse(byval centerX as long, byval centerY as long, byval radiusH as single, byval radiusV as single, byval color as RLColor)
declare sub DrawEllipseLines(byval centerX as long, byval centerY as long, byval radiusH as single, byval radiusV as single, byval color as RLColor)
declare sub DrawRing(byval center as Vector2, byval innerRadius as single, byval outerRadius as single, byval startAngle as single, byval endAngle as single, byval segments as long, byval color as RLColor)
declare sub DrawRingLines(byval center as Vector2, byval innerRadius as single, byval outerRadius as single, byval startAngle as single, byval endAngle as single, byval segments as long, byval color as RLColor)
declare sub DrawRectangle(byval posX as long, byval posY as long, byval width_ as long, byval height_ as long, byval color as RLColor)
declare sub DrawRectangleV(byval position as Vector2, byval size as Vector2, byval color as RLColor)
declare sub DrawRectangleRec(byval rec as Rectangle, byval color as RLColor)
declare sub DrawRectanglePro(byval rec as Rectangle, byval origin as Vector2, byval rotation as single, byval color as RLColor)
declare sub DrawRectangleGradientV(byval posX as long, byval posY as long, byval width_ as long, byval height_ as long, byval color1 as RLColor, byval color2 as RLColor)
declare sub DrawRectangleGradientH(byval posX as long, byval posY as long, byval width_ as long, byval height_ as long, byval color1 as RLColor, byval color2 as RLColor)
declare sub DrawRectangleGradientEx(byval rec as Rectangle, byval col1 as RLColor, byval col2 as RLColor, byval col3 as RLColor, byval col4 as RLColor)
declare sub DrawRectangleLines(byval posX as long, byval posY as long, byval width_ as long, byval height_ as long, byval color as RLColor)
declare sub DrawRectangleLinesEx(byval rec as Rectangle, byval lineThick as single, byval color as RLColor)
declare sub DrawRectangleRounded(byval rec as Rectangle, byval roundness as single, byval segments as long, byval color as RLColor)
declare sub DrawRectangleRoundedLines(byval rec as Rectangle, byval roundness as single, byval segments as long, byval lineThick as single, byval color as RLColor)
declare sub DrawTriangle(byval v1 as Vector2, byval v2 as Vector2, byval v3 as Vector2, byval color as RLColor)
declare sub DrawTriangleLines(byval v1 as Vector2, byval v2 as Vector2, byval v3 as Vector2, byval color as RLColor)
declare sub DrawTriangleFan(byval points as Vector2 ptr, byval pointCount as long, byval color as RLColor)
declare sub DrawTriangleStrip(byval points as Vector2 ptr, byval pointCount as long, byval color as RLColor)
declare sub DrawPoly(byval center as Vector2, byval sides as long, byval radius as single, byval rotation as single, byval color as RLColor)
declare sub DrawPolyLines(byval center as Vector2, byval sides as long, byval radius as single, byval rotation as single, byval color as RLColor)
declare sub DrawPolyLinesEx(byval center as Vector2, byval sides as long, byval radius as single, byval rotation as single, byval lineThick as single, byval color as RLColor)
declare function CheckCollisionRecs(byval rec1 as Rectangle, byval rec2 as Rectangle) as boolean
declare function CheckCollisionCircles(byval center1 as Vector2, byval radius1 as single, byval center2 as Vector2, byval radius2 as single) as boolean
declare function CheckCollisionCircleRec(byval center as Vector2, byval radius as single, byval rec as Rectangle) as boolean
declare function CheckCollisionPointRec(byval point_ as Vector2, byval rec as Rectangle) as boolean
declare function CheckCollisionPointCircle(byval point_ as Vector2, byval center as Vector2, byval radius as single) as boolean
declare function CheckCollisionPointTriangle(byval point_ as Vector2, byval p1 as Vector2, byval p2 as Vector2, byval p3 as Vector2) as boolean
declare function CheckCollisionPointPoly(byval point as Vector2, byval points as Vector2 ptr, byval pointCount as long) as byte
declare function CheckCollisionLines(byval startPos1 as Vector2, byval endPos1 as Vector2, byval startPos2 as Vector2, byval endPos2 as Vector2, byval collisionPoint as Vector2 ptr) as boolean
declare function CheckCollisionPointLine(byval point_ as Vector2, byval p1 as Vector2, byval p2 as Vector2, byval threshold as long) as boolean
declare function GetCollisionRec(byval rec1 as Rectangle, byval rec2 as Rectangle) as Rectangle
declare function LoadImage(byval fileName as const zstring ptr) as Image
declare function LoadImageRaw(byval fileName as const zstring ptr, byval width_ as long, byval height_ as long, byval format_ as long, byval headerSize as long) as Image
declare function LoadImageSVG(byval fileNameOrString as const zstring ptr, byval width_ as long, byval height_ as long) as Image
declare function LoadImageAnim(byval fileName as const zstring ptr, byval frames as long ptr) as Image
declare function LoadImageFromMemory(byval fileType as const zstring ptr, byval fileData as const ubyte ptr, byval dataSize as long) as Image
declare function LoadImageFromTexture(byval texture as Texture2D) as Image
declare function LoadImageFromScreen() as Image
declare function IsImageReady(byval image_ as Image) as byte
declare sub UnloadImage(byval image_ as Image)
declare function ExportImage(byval image_ as Image, byval fileName as const zstring ptr) as boolean
declare function ExportImageToMemory(byval image_ as Image, byval fileType as const zstring ptr, byval fileSie as long) as zstring ptr
declare function ExportImageAsCode(byval image_ as Image, byval fileName as const zstring ptr) as boolean
declare function GenImageColor(byval width_ as long, byval height_ as long, byval color as RLColor) as Image
declare function GenImageGradientLinear(byval width_ as long, byval height_ as long, byval direction as long, byval start_ as RLColor, byval end_ as RLColor) as Image
declare function GenImageGradientRadial(byval width_ as long, byval height_ as long, byval density as single, byval inner as RLColor, byval outer as RLColor) as Image
declare function GenImageGradientSquare(byval width_ as long, byval height_ as long, byval density as single, byval inner as RLColor, byval outer as RLColor) as Image
declare function GenImageChecked(byval width_ as long, byval height_ as long, byval checksX as long, byval checksY as long, byval col1 as RLColor, byval col2 as RLColor) as Image
declare function GenImageWhiteNoise(byval width_ as long, byval height_ as long, byval factor as single) as Image
declare function GenImagePerlinNoise(byval width_ as long, byval height_ as long, byval offsetX as long, byval offsetY as long, byval scale as single) as Image
declare function GenImageCellular(byval width_ as long, byval height_ as long, byval tileSize as long) as Image
declare function GenImageText(byval width_ as long, byval height_ as long, byval text_ as const zstring ptr) as Image
declare function ImageCopy(byval image_ as Image) as Image
declare function ImageFromImage(byval image_ as Image, byval rec as Rectangle) as Image
declare function ImageText(byval text as const zstring ptr, byval fontSize as long, byval color as RLColor) as Image
declare function ImageTextEx(byval font as Font, byval text as const zstring ptr, byval fontSize as single, byval spacing as single, byval tint as RLColor) as Image
declare sub ImageFormat(byval image_ as Image ptr, byval newFormat as long)
declare sub ImageToPOT(byval image_ as Image ptr, byval fill as RLColor)
declare sub ImageCrop(byval image_ as Image ptr, byval crop as Rectangle)
declare sub ImageAlphaCrop(byval image_ as Image ptr, byval threshold as single)
declare sub ImageAlphaClear(byval image_ as Image ptr, byval color as RLColor, byval threshold as single)
declare sub ImageAlphaMask(byval image_ as Image ptr, byval alphaMask as Image)
declare sub ImageAlphaPremultiply(byval image_ as Image ptr)
declare sub ImageBlurGaussian(byval image_ as Image ptr, byval blurSize as long)
declare sub ImageResize(byval image_ as Image ptr, byval newWidth as long, byval newHeight as long)
declare sub ImageResizeNN(byval image_ as Image ptr, byval newWidth as long, byval newHeight as long)
declare sub ImageResizeCanvas(byval image_ as Image ptr, byval newWidth as long, byval newHeight as long, byval offsetX as long, byval offsetY as long, byval fill as RLColor)
declare sub ImageMipmaps(byval image_ as Image ptr)
declare sub ImageDither(byval image_ as Image ptr, byval rBpp as long, byval gBpp as long, byval bBpp as long, byval aBpp as long)
declare sub ImageFlipVertical(byval image_ as Image ptr)
declare sub ImageFlipHorizontal(byval image_ as Image ptr)
declare sub ImageRotate(byval image_ as Image ptr, byval degrees as long)
declare sub ImageRotateCW(byval image_ as Image ptr)
declare sub ImageRotateCCW(byval image_ as Image ptr)
declare sub ImageColorTint(byval image_ as Image ptr, byval color as RLColor)
declare sub ImageColorInvert(byval image_ as Image ptr)
declare sub ImageColorGrayscale(byval image_ as Image ptr)
declare sub ImageColorContrast(byval image_ as Image ptr, byval contrast as single)
declare sub ImageColorBrightness(byval image_ as Image ptr, byval brightness as long)
declare sub ImageColorReplace(byval image_ as Image ptr, byval color as RLColor, byval replace as RLColor)
declare function LoadImageColors(byval image_ as Image) as RLColor ptr
declare function LoadImagePalette(byval image_ as Image, byval maxPaletteSize as long, byval colorCount as long ptr) as RLColor ptr
declare sub UnloadImageColors(byval colors as RLColor ptr)
declare sub UnloadImagePalette(byval colors as RLColor ptr)
declare function GetImageAlphaBorder(byval image_ as Image, byval threshold as single) as Rectangle
declare function GetImageColor(byval image_ as Image, byval x as long, byval y as long) as RLColor
declare sub ImageClearBackground(byval dst as Image ptr, byval color as RLColor)
declare sub ImageDrawPixel(byval dst as Image ptr, byval posX as long, byval posY as long, byval color as RLColor)
declare sub ImageDrawPixelV(byval dst as Image ptr, byval position as Vector2, byval color as RLColor)
declare sub ImageDrawLine(byval dst as Image ptr, byval startPosX as long, byval startPosY as long, byval endPosX as long, byval endPosY as long, byval color as RLColor)
declare sub ImageDrawLineV(byval dst as Image ptr, byval start as Vector2, byval end_ as Vector2, byval color as RLColor)
declare sub ImageDrawCircle(byval dst as Image ptr, byval centerX as long, byval centerY as long, byval radius as long, byval color as RLColor)
declare sub ImageDrawCircleV(byval dst as Image ptr, byval center as Vector2, byval radius as long, byval color as RLColor)
declare sub ImageDrawCircleLines(byval dst as Image ptr, byval centerX as long, byval centerY as long, byval radius as long, byval color_ as RLColor)
declare sub ImageDrawCircleLinesV(byval dst as Image ptr, byval center as Vector2, byval radius as long, byval color_ as RLColor)
declare sub ImageDrawRectangle(byval dst as Image ptr, byval posX as long, byval posY as long, byval width_ as long, byval height_ as long, byval color as RLColor)
declare sub ImageDrawRectangleV(byval dst as Image ptr, byval position as Vector2, byval size as Vector2, byval color as RLColor)
declare sub ImageDrawRectangleRec(byval dst as Image ptr, byval rec as Rectangle, byval color as RLColor)
declare sub ImageDrawRectangleLines(byval dst as Image ptr, byval rec as Rectangle, byval thick as long, byval color as RLColor)
declare sub ImageDraw(byval dst as Image ptr, byval src as Image, byval srcRec as Rectangle, byval dstRec as Rectangle, byval tint as RLColor)
declare sub ImageDrawText(byval dst as Image ptr, byval text as const zstring ptr, byval posX as long, byval posY as long, byval fontSize as long, byval color as RLColor)
declare sub ImageDrawTextEx(byval dst as Image ptr, byval font as Font, byval text as const zstring ptr, byval position as Vector2, byval fontSize as single, byval spacing as single, byval tint as RLColor)
declare function LoadTexture(byval fileName as const zstring ptr) as Texture2D
declare function LoadTextureFromImage(byval image_ as Image) as Texture2D
declare function LoadTextureCubemap(byval image_ as Image, byval layout as long) as TextureCubemap
declare function LoadRenderTexture(byval width_ as long, byval height_ as long) as RenderTexture2D
declare function IsTextureReady(byval texture as Texture2D) as byte
declare sub UnloadTexture(byval texture as Texture2D)
declare function IsRenderTextureReady(byval target as RenderTexture2D) as byte
declare sub UnloadRenderTexture(byval target as RenderTexture2D)
declare sub UpdateTexture(byval texture as Texture2D, byval pixels as const any ptr)
declare sub UpdateTextureRec(byval texture as Texture2D, byval rec as Rectangle, byval pixels as const any ptr)
declare sub GenTextureMipmaps(byval texture as Texture2D ptr)
declare sub SetTextureFilter(byval texture as Texture2D, byval filter as long)
declare sub SetTextureWrap(byval texture as Texture2D, byval wrap as long)
declare sub DrawTexture(byval texture as Texture2D, byval posX as long, byval posY as long, byval tint as RLColor)
declare sub DrawTextureV(byval texture as Texture2D, byval position as Vector2, byval tint as RLColor)
declare sub DrawTextureEx(byval texture as Texture2D, byval position as Vector2, byval rotation as single, byval scale as single, byval tint as RLColor)
declare sub DrawTextureRec(byval texture as Texture2D, byval source as Rectangle, byval position as Vector2, byval tint as RLColor)
declare sub DrawTexturePro(byval texture as Texture2D, byval source as Rectangle, byval dest as Rectangle, byval origin as Vector2, byval rotation as single, byval tint as RLColor)
declare sub DrawTextureNPatch(byval texture as Texture2D, byval NPatchInfo_ as NPatchInfo, byval dest as Rectangle, byval origin as Vector2, byval rotation as single, byval tint as RLColor)
declare function Fade(byval color as RLColor, byval alpha_ as single) as RLColor
declare function ColorToInt(byval color_ as RLColor) as long
declare function ColorNormalize(byval color_ as RLColor) as Vector4
declare function ColorFromNormalized(byval normalized as Vector4) as RLColor
declare function ColorToHSV(byval color as RLColor) as Vector3
declare function ColorFromHSV(byval hue as single, byval saturation as single, byval value as single) as RLColor
declare function ColorTint(byval color_ as RLColor, byval tint as RLColor) as RLColor
declare function ColorBrightness(byval color_ as RLColor, byval factor as single) as RLColor
declare function ColorContrast(byval color_ as RLColor, byval contrast as single) as RLColor
declare function ColorAlpha(byval color_ as RLColor, byval alpha_ as single) as RLColor
declare function ColorAlphaBlend(byval dst as RLColor, byval src as RLColor, byval tint as RLColor) as RLColor
declare function GetColor(byval hexValue as ulong) as RLColor
declare function GetPixelColor(byval srcPtr as any ptr, byval format_ as long) as RLColor
declare sub SetPixelColor(byval dstPtr as any ptr, byval color as RLColor, byval format_ as long)
declare function GetPixelDataSize(byval width_ as long, byval height_ as long, byval format_ as long) as long
declare function GetFontDefault() as Font
declare function LoadFont(byval fileName as const zstring ptr) as Font
declare function LoadFontEx(byval fileName as const zstring ptr, byval fontSize as long, byval codepoints as long ptr, byval codepointCount as long) as Font
declare function LoadFontFromImage(byval image_ as Image, byval key as RLColor, byval firstChar as long) as Font
declare function LoadFontFromMemory(byval fileType as const zstring ptr, byval fileData as const ubyte ptr, byval dataSize as long, byval fontSize as long, byval codepoints as long ptr, byval codepointCount as long) as Font
declare function IsFontReady(byval font as Font) as byte
declare function LoadFontData(byval fileData as const ubyte ptr, byval dataSize as long, byval fontSize as long, byval codepoints as long ptr, byval codepointCount as long, byval type as long) as GlyphInfo ptr
declare function GenImageFontAtlas(byval glyphs as const GlyphInfo ptr, byval glyphRecs as Rectangle ptr ptr, byval glyphCount as long, byval fontSize as long, byval padding as long, byval packMethod as long) as Image
declare sub UnloadFontData(byval glyphs as GlyphInfo ptr, byval glyphCount as long)
declare sub UnloadFont(byval font as Font)
declare function ExportFontAsCode(byval font as Font, byval fileName as const zstring ptr) as boolean
declare sub DrawFPS(byval posX as long, byval posY as long)
declare sub DrawText(byval text as const zstring ptr, byval posX as long, byval posY as long, byval fontSize as long, byval color as RLColor)
declare sub DrawTextEx(byval font as Font, byval text as const zstring ptr, byval position as Vector2, byval fontSize as single, byval spacing as single, byval tint as RLColor)
declare sub DrawTextPro(byval font as Font, byval text as const zstring ptr, byval position as Vector2, byval origin as Vector2, byval rotation as single, byval fontSize as single, byval spacing as single, byval tint as RLColor)
declare sub DrawTextCodepoint(byval font as Font, byval codepoint as long, byval position as Vector2, byval fontSize as single, byval tint as RLColor)
declare sub DrawTextCodepoints(byval font as Font, byval codepoints as const long ptr, byval codepointCount as long, byval position as Vector2, byval fontSize as single, byval spacing as single, byval tint as RLColor)

declare sub SetTextLineSpacing(byval spaceing as long)

declare function MeasureText(byval text as const zstring ptr, byval fontSize as long) as long
declare function MeasureTextEx(byval font as Font, byval text as const zstring ptr, byval fontSize as single, byval spacing as single) as Vector2
declare function GetGlyphIndex(byval font as Font, byval codepoint as long) as long
declare function GetGlyphInfo(byval font as Font, byval codepoint as long) as GlyphInfo
declare function GetGlyphAtlasRec(byval font as Font, byval codepoint as long) as Rectangle
declare function LoadUTF8(byval codepoints as const long ptr, byval length_ as long) as zstring ptr
declare sub UnloadUTF8(byval text as zstring ptr)
declare function LoadCodepoints(byval text_ as const zstring ptr, byval count as long ptr) as long ptr
declare sub UnloadCodepoints(byval codepoints as long ptr)
declare function GetCodepoint(byval text as const zstring ptr, byval codepointSize as long ptr) as long
declare function GetCodepointNext(byval text as const zstring ptr, byval codepointSize as long ptr) as long
declare function GetCodepointPrevious(byval text as const zstring ptr, byval codepointSize as long ptr) as long
declare function CodepointToUTF8(byval codepoint as long, byval utf8Size as long ptr) as const zstring ptr
declare function TextCodepointsToUTF8(byval codepoints as const long ptr, byval length as long) as zstring ptr
declare function TextCopy(byval dst as zstring ptr, byval src as const zstring ptr) as long
declare function TextIsEqual(byval text1 as const zstring ptr, byval text2 as const zstring ptr) as boolean
declare function TextLength(byval text as const zstring ptr) as ulong
declare function TextFormat(byval text as const zstring ptr, ...) as const zstring ptr
declare function TextSubtext(byval text as const zstring ptr, byval position as long, byval length as long) as const zstring ptr
declare function TextReplace(byval text as zstring ptr, byval replace as const zstring ptr, byval by as const zstring ptr) as zstring ptr
declare function TextInsert(byval text as const zstring ptr, byval insert as const zstring ptr, byval position as long) as zstring ptr
declare function TextJoin(byval textList as const zstring ptr ptr, byval count as long, byval delimiter as const zstring ptr) as const zstring ptr
declare function TextSplit(byval text as const zstring ptr, byval delimiter as byte, byval count as long ptr) as const zstring ptr ptr
declare sub TextAppend(byval text as zstring ptr, byval append as const zstring ptr, byval position as long ptr)
declare function TextFindIndex(byval text as const zstring ptr, byval find as const zstring ptr) as long
declare function TextToUpper(byval text as const zstring ptr) as const zstring ptr
declare function TextToLower(byval text as const zstring ptr) as const zstring ptr
declare function TextToPascal(byval text as const zstring ptr) as const zstring ptr
declare function TextToInteger(byval text as const zstring ptr) as long
declare sub DrawLine3D(byval startPos as Vector3, byval endPos as Vector3, byval color as RLColor)
declare sub DrawPoint3D(byval position as Vector3, byval color as RLColor)
declare sub DrawCircle3D(byval center as Vector3, byval radius as single, byval rotationAxis as Vector3, byval rotationAngle as single, byval color as RLColor)
declare sub DrawTriangle3D(byval v1 as Vector3, byval v2 as Vector3, byval v3 as Vector3, byval color as RLColor)
declare sub DrawTriangleStrip3D(byval points as Vector3 ptr, byval pointCount as long, byval color as RLColor)
declare sub DrawCube(byval position as Vector3, byval width_ as single, byval height_ as single, byval length as single, byval color as RLColor)
declare sub DrawCubeV(byval position as Vector3, byval size as Vector3, byval color as RLColor)
declare sub DrawCubeWires(byval position as Vector3, byval width_ as single, byval height_ as single, byval length as single, byval color as RLColor)
declare sub DrawCubeWiresV(byval position as Vector3, byval size as Vector3, byval color as RLColor)
declare sub DrawSphere(byval centerPos as Vector3, byval radius as single, byval color as RLColor)
declare sub DrawSphereEx(byval centerPos as Vector3, byval radius as single, byval rings as long, byval slices as long, byval color as RLColor)
declare sub DrawSphereWires(byval centerPos as Vector3, byval radius as single, byval rings as long, byval slices as long, byval color as RLColor)
declare sub DrawCylinder(byval position as Vector3, byval radiusTop as single, byval radiusBottom as single, byval height_ as single, byval slices as long, byval color as RLColor)
declare sub DrawCylinderEx(byval startPos as Vector3, byval endPos as Vector3, byval startRadius as single, byval endRadius as single, byval sides as long, byval color as RLColor)
declare sub DrawCylinderWires(byval position as Vector3, byval radiusTop as single, byval radiusBottom as single, byval height_ as single, byval slices as long, byval color as RLColor)
declare sub DrawCylinderWiresEx(byval startPos as Vector3, byval endPos as Vector3, byval startRadius as single, byval endRadius as single, byval sides as long, byval color as RLColor)
declare sub DrawCapsule(byval startPos as Vector3, byval endPos as Vector3, byval radius as single, byval slices as long, byval rings as long, byval color_ as RLColor)
declare sub DrawCapsuleWires(byval startPos as Vector3, byval endPos as Vector3, byval radius as single, byval slices as long, byval rings as long, byval color_ as RLColor)
declare sub DrawPlane(byval centerPos as Vector3, byval size as Vector2, byval color as RLColor)
declare sub DrawRay(byval ray as Ray, byval color as RLColor)
declare sub DrawGrid(byval slices as long, byval spacing as single)
declare function LoadModel(byval fileName as const zstring ptr) as Model
declare function LoadModelFromMesh(byval mesh as Mesh) as Model
declare function IsModelReady(byval model as Model) as byte
declare sub UnloadModel(byval model as Model)
declare function GetModelBoundingBox(byval model as Model) as BoundingBox
declare sub DrawModel(byval model as Model, byval position as Vector3, byval scale as single, byval tint as RLColor)
declare sub DrawModelEx(byval model as Model, byval position as Vector3, byval rotationAxis as Vector3, byval rotationAngle as single, byval scale as Vector3, byval tint as RLColor)
declare sub DrawModelWires(byval model as Model, byval position as Vector3, byval scale as single, byval tint as RLColor)
declare sub DrawModelWiresEx(byval model as Model, byval position as Vector3, byval rotationAxis as Vector3, byval rotationAngle as single, byval scale as Vector3, byval tint as RLColor)
declare sub DrawBoundingBox(byval box as BoundingBox, byval color as RLColor)
declare sub DrawBillboard(byval camera as Camera, byval texture as Texture2D, byval position as Vector3, byval size as single, byval tint as RLColor)
declare sub DrawBillboardRec(byval camera as Camera, byval texture as Texture2D, byval source as Rectangle, byval position as Vector3, byval size as Vector2, byval tint as RLColor)
declare sub DrawBillboardPro(byval camera as Camera, byval texture as Texture2D, byval source as Rectangle, byval position as Vector3, byval up as Vector3, byval size as Vector2, byval origin as Vector2, byval rotation as single, byval tint as RLColor)
declare sub UploadMesh(byval mesh as Mesh ptr, byval dynamic as boolean)
declare sub UpdateMeshBuffer(byval mesh as Mesh, byval index as long, byval data_ as const any ptr, byval dataSize as long, byval offset as long)
declare sub UnloadMesh(byval mesh as Mesh)
declare sub DrawMesh(byval mesh as Mesh, byval material as Material, byval transform as Matrix)
declare sub DrawMeshInstanced(byval mesh as Mesh, byval material as Material, byval transforms as const Matrix ptr, byval instances as long)
declare function ExportMesh(byval mesh as Mesh, byval fileName as const zstring ptr) as boolean
declare function GetMeshBoundingBox(byval mesh as Mesh) as BoundingBox
declare sub GenMeshTangents(byval mesh as Mesh ptr)
declare function GenMeshPoly(byval sides as long, byval radius as single) as Mesh
declare function GenMeshPlane(byval width_ as single, byval length as single, byval resX as long, byval resZ as long) as Mesh
declare function GenMeshCube(byval width_ as single, byval height_ as single, byval length as single) as Mesh
declare function GenMeshSphere(byval radius as single, byval rings as long, byval slices as long) as Mesh
declare function GenMeshHemiSphere(byval radius as single, byval rings as long, byval slices as long) as Mesh
declare function GenMeshCylinder(byval radius as single, byval height_ as single, byval slices as long) as Mesh
declare function GenMeshCone(byval radius as single, byval height_ as single, byval slices as long) as Mesh
declare function GenMeshTorus(byval radius as single, byval size as single, byval radSeg as long, byval sides as long) as Mesh
declare function GenMeshKnot(byval radius as single, byval size as single, byval radSeg as long, byval sides as long) as Mesh
declare function GenMeshHeightmap(byval heightmap as Image, byval size as Vector3) as Mesh
declare function GenMeshCubicmap(byval cubicmap as Image, byval cubeSize as Vector3) as Mesh
declare function LoadMaterials(byval fileName as const zstring ptr, byval materialCount as long ptr) as Material ptr
declare function LoadMaterialDefault() as Material
declare function IsMaterialReady(byval material as Material) as byte
declare sub UnloadMaterial(byval material as Material)
declare sub SetMaterialTexture(byval material as Material ptr, byval mapType as long, byval texture as Texture2D)
declare sub SetModelMeshMaterial(byval model as Model ptr, byval meshId as long, byval materialId as long)
declare function LoadModelAnimations(byval fileName as const zstring ptr, byval animCount as long ptr) as ModelAnimation ptr
declare sub UpdateModelAnimation(byval model as Model, byval anim as ModelAnimation, byval frame as long)
declare sub UnloadModelAnimation(byval anim as ModelAnimation)
declare sub UnloadModelAnimations(byval animations as ModelAnimation ptr, byval count as long)
declare function IsModelAnimationValid(byval model as Model, byval anim as ModelAnimation) as boolean
declare function CheckCollisionSpheres(byval center1 as Vector3, byval radius1 as single, byval center2 as Vector3, byval radius2 as single) as boolean
declare function CheckCollisionBoxes(byval box1 as BoundingBox, byval box2 as BoundingBox) as boolean
declare function CheckCollisionBoxSphere(byval box as BoundingBox, byval center as Vector3, byval radius as single) as boolean
declare function GetRayCollisionSphere(byval ray as Ray, byval center as Vector3, byval radius as single) as RayCollision
declare function GetRayCollisionBox(byval ray as Ray, byval box as BoundingBox) as RayCollision
declare function GetRayCollisionMesh(byval ray as Ray, byval mesh as Mesh, byval transform as Matrix) as RayCollision
declare function GetRayCollisionTriangle(byval ray as Ray, byval p1 as Vector3, byval p2 as Vector3, byval p3 as Vector3) as RayCollision
declare function GetRayCollisionQuad(byval ray as Ray, byval p1 as Vector3, byval p2 as Vector3, byval p3 as Vector3, byval p4 as Vector3) as RayCollision
type AudioCallback as sub(byval bufferData as any ptr, byval frames as ulong)
declare sub InitAudioDevice()
declare sub CloseAudioDevice()
declare function IsAudioDeviceReady() as boolean
declare sub SetMasterVolume(byval volume as single)
declare function GetMasterVolume() as single
declare function LoadWave(byval fileName as const zstring ptr) as Wave
declare function LoadWaveFromMemory(byval fileType as const zstring ptr, byval fileData as const ubyte ptr, byval dataSize as long) as Wave
declare function IsWaveReady(byval wave as Wave) as byte
declare function LoadSound(byval fileName as const zstring ptr) as Sound
declare function LoadSoundFromWave(byval wave as Wave) as Sound
declare function LoadSoundAlias(byval source as Sound) as Sound
declare function IsSoundReady(byval sound as Sound) as byte
declare sub UpdateSound(byval sound as Sound, byval data_ as const any ptr, byval sampleCount as long)
declare sub UnloadWave(byval wave as Wave)
declare sub UnloadSound(byval sound as Sound)
declare sub UnloadSoundAlias(byval alias as Sound)
declare function ExportWave(byval wave as Wave, byval fileName as const zstring ptr) as boolean
declare function ExportWaveAsCode(byval wave as Wave, byval fileName as const zstring ptr) as boolean
declare sub PlaySound(byval sound as Sound)
declare sub StopSound(byval sound as Sound)
declare sub PauseSound(byval sound as Sound)
declare sub ResumeSound(byval sound as Sound)
declare function IsSoundPlaying(byval sound as Sound) as boolean
declare sub SetSoundVolume(byval sound as Sound, byval volume as single)
declare sub SetSoundPitch(byval sound as Sound, byval pitch as single)
declare sub SetSoundPan(byval sound as Sound, byval pan as single)
declare function WaveCopy(byval wave as Wave) as Wave
declare sub WaveCrop(byval wave as Wave ptr, byval initSample as long, byval finalSample as long)
declare sub WaveFormat(byval wave as Wave ptr, byval sampleRate as long, byval sampleSize as long, byval channels as long)
declare function LoadWaveSamples(byval wave as Wave) as single ptr
declare sub UnloadWaveSamples(byval samples as single ptr)
declare function LoadMusicStream(byval fileName as const zstring ptr) as Music
declare function LoadMusicStreamFromMemory(byval fileType as const zstring ptr, byval data_ as const ubyte ptr, byval dataSize as long) as Music
declare function IsMusicReady(byval music as Music) as byte
declare sub UnloadMusicStream(byval music as Music)
declare sub PlayMusicStream(byval music as Music)
declare function IsMusicStreamPlaying(byval music as Music) as boolean
declare sub UpdateMusicStream(byval music as Music)
declare sub StopMusicStream(byval music as Music)
declare sub PauseMusicStream(byval music as Music)
declare sub ResumeMusicStream(byval music as Music)
declare sub SeekMusicStream(byval music as Music, byval position as single)
declare sub SetMusicVolume(byval music as Music, byval volume as single)
declare sub SetMusicPitch(byval music as Music, byval pitch as single)
declare sub SetMusicPan(byval music as Music, byval pan as single)
declare function GetMusicTimeLength(byval music as Music) as single
declare function GetMusicTimePlayed(byval music as Music) as single
declare function LoadAudioStream(byval sampleRate as ulong, byval sampleSize as ulong, byval channels as ulong) as AudioStream
declare function IsAudioStreamReady(byval stream as AudioStream) as byte
declare sub UnloadAudioStream(byval stream as AudioStream)
declare sub UpdateAudioStream(byval stream as AudioStream, byval data_ as const any ptr, byval frameCount as long)
declare function IsAudioStreamProcessed(byval stream as AudioStream) as boolean
declare sub PlayAudioStream(byval stream as AudioStream)
declare sub PauseAudioStream(byval stream as AudioStream)
declare sub ResumeAudioStream(byval stream as AudioStream)
declare function IsAudioStreamPlaying(byval stream as AudioStream) as boolean
declare sub StopAudioStream(byval stream as AudioStream)
declare sub SetAudioStreamVolume(byval stream as AudioStream, byval volume as single)
declare sub SetAudioStreamPitch(byval stream as AudioStream, byval pitch as single)
declare sub SetAudioStreamPan(byval stream as AudioStream, byval pan as single)
declare sub SetAudioStreamBufferSizeDefault(byval size as long)
declare sub SetAudioStreamCallback(byval stream as AudioStream, byval callback as AudioCallback)
declare sub AttachAudioStreamProcessor(byval stream as AudioStream, byval processor as AudioCallback)
declare sub DetachAudioStreamProcessor(byval stream as AudioStream, byval processor as AudioCallback)
declare sub AttachAudioMixedProcessor(byval processor as AudioCallback)
declare sub DetachAudioMixedProcessor(byval processor as AudioCallback)

end extern
