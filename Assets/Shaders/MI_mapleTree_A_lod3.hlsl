#define NUM_TEX_COORD_INTERPOLATORS 3
#define NUM_MATERIAL_TEXCOORDS_VERTEX 1
#define NUM_CUSTOM_VERTEX_INTERPOLATORS 0

struct Input
{
	//float3 Normal;
	float2 uv_MainTex : TEXCOORD0;
	float2 uv2_Material_Texture2D_0 : TEXCOORD1;
	float4 color : COLOR;
	float4 tangent;
	//float4 normal;
	float3 viewDir;
	float4 screenPos;
	float3 worldPos;
	//float3 worldNormal;
	float3 normal2;
};
struct SurfaceOutputStandard
{
	float3 Albedo;		// base (diffuse or specular) color
	float3 Normal;		// tangent space normal, if written
	half3 Emission;
	half Metallic;		// 0=non-metal, 1=metal
	// Smoothness is the user facing name, it should be perceptual smoothness but user should not have to deal with it.
	// Everywhere in the code you meet smoothness it is perceptual smoothness
	half Smoothness;	// 0=rough, 1=smooth
	half Occlusion;		// occlusion (default 1)
	float Alpha;		// alpha for transparencies
};

#define HDRP 1
//#define URP 1
#define UE5
#define HAS_CUSTOMIZED_UVS 1
#define MATERIAL_TANGENTSPACENORMAL 1
//struct Material
//{
	//samplers start
SAMPLER( SamplerState_Linear_Repeat );
SAMPLER( SamplerState_Linear_Clamp );
TEXTURE2D(       Material_Texture2D_0 );
SAMPLER(  samplerMaterial_Texture2D_0 );
float4 Material_Texture2D_0_TexelSize;
float4 Material_Texture2D_0_ST;
TEXTURE2D(       Material_Texture2D_1 );
SAMPLER(  samplerMaterial_Texture2D_1 );
float4 Material_Texture2D_1_TexelSize;
float4 Material_Texture2D_1_ST;
TEXTURE2D(       Material_Texture2D_2 );
SAMPLER(  samplerMaterial_Texture2D_2 );
float4 Material_Texture2D_2_TexelSize;
float4 Material_Texture2D_2_ST;

//};

#ifdef UE5
	#define UE_LWC_RENDER_TILE_SIZE			2097152.0
	#define UE_LWC_RENDER_TILE_SIZE_SQRT	1448.15466
	#define UE_LWC_RENDER_TILE_SIZE_RSQRT	0.000690533954
	#define UE_LWC_RENDER_TILE_SIZE_RCP		4.76837158e-07
	#define UE_LWC_RENDER_TILE_SIZE_FMOD_PI		0.673652053
	#define UE_LWC_RENDER_TILE_SIZE_FMOD_2PI	0.673652053
	#define INVARIANT(X) X
	#define PI 					(3.1415926535897932)

	#include "LargeWorldCoordinates.hlsl"
#endif
struct MaterialStruct
{
	float4 PreshaderBuffer[18];
	float4 ScalarExpressions[1];
	float VTPackedPageTableUniform[2];
	float VTPackedUniform[1];
};
#define SVTPackedUniform VTPackedUniform
static SamplerState View_MaterialTextureBilinearWrapedSampler;
static SamplerState View_MaterialTextureBilinearClampedSampler;
struct ViewStruct
{
	float GameTime;
	float RealTime;
	float DeltaTime;
	float PrevFrameGameTime;
	float PrevFrameRealTime;
	float MaterialTextureMipBias;	
	float4 PrimitiveSceneData[ 40 ];
	float4 TemporalAAParams;
	float2 ViewRectMin;
	float4 ViewSizeAndInvSize;
	float2 ResolutionFractionAndInv;
	float MaterialTextureDerivativeMultiply;
	uint StateFrameIndexMod8;
	uint StateFrameIndex;
	float FrameNumber;
	float2 FieldOfViewWideAngles;
	float4 RuntimeVirtualTextureMipLevel;
	float PreExposure;
	float4 BufferBilinearUVMinMax;
};
struct ResolvedViewStruct
{
	#ifdef UE5
		FLWCVector3 WorldCameraOrigin;
		FLWCVector3 PrevWorldCameraOrigin;
		FLWCVector3 PreViewTranslation;
		FLWCVector3 WorldViewOrigin;
	#else
		float3 WorldCameraOrigin;
		float3 PrevWorldCameraOrigin;
		float3 PreViewTranslation;
		float3 WorldViewOrigin;
	#endif
	float4 ScreenPositionScaleBias;
	float4x4 TranslatedWorldToView;
	float4x4 TranslatedWorldToCameraView;
	float4x4 TranslatedWorldToClip;
	float4x4 ViewToTranslatedWorld;
	float4x4 PrevViewToTranslatedWorld;
	float4x4 CameraViewToTranslatedWorld;
	float4 BufferBilinearUVMinMax;
	float4 XRPassthroughCameraUVs[ 2 ];
};
struct PrimitiveStruct
{
	float4x4 WorldToLocal;
	float4x4 LocalToWorld;
};

static ViewStruct View;
static ResolvedViewStruct ResolvedView;
static PrimitiveStruct Primitive;
uniform float4 View_BufferSizeAndInvSize;
uniform float4 LocalObjectBoundsMin;
uniform float4 LocalObjectBoundsMax;
static SamplerState Material_Wrap_WorldGroupSettings;
static SamplerState Material_Clamp_WorldGroupSettings;

#include "UnrealCommon.cginc"

static MaterialStruct Material;
void InitializeExpressions()
{
	Material.PreshaderBuffer[0] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[1] = float4(1.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[2] = float4(1.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[3] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[4] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[5] = float4(0.375000,1.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[6] = float4(0.000000,-1.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[7] = float4(0.000000,-1.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[8] = float4(0.000000,0.000000,-1.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[9] = float4(0.000000,0.000000,-1.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[10] = float4(0.000000,0.000000,0.000000,1.000000);//(Unknown)
	Material.PreshaderBuffer[11] = float4(0.600000,-0.250000,0.600000,356.076019);//(Unknown)
	Material.PreshaderBuffer[12] = float4(-356.076019,0.600000,356.076019,0.000000);//(Unknown)
	Material.PreshaderBuffer[13] = float4(0.000000,0.000000,356.076019,0.000000);//(Unknown)
	Material.PreshaderBuffer[14] = float4(0.000000,100000.000000,593.460022,0.500000);//(Unknown)
	Material.PreshaderBuffer[15] = float4(0.820000,0.820000,0.820000,0.000000);//(Unknown)
	Material.PreshaderBuffer[16] = float4(0.820000,0.820000,0.820000,2.000000);//(Unknown)
	Material.PreshaderBuffer[17] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
}
MaterialFloat CustomExpression5(FMaterialVertexParameters Parameters,MaterialFloat x,MaterialFloat y)
{
return (atan2(y,x));
}

MaterialFloat CustomExpression4(FMaterialVertexParameters Parameters,MaterialFloat x,MaterialFloat y)
{
return (atan2(y,x));
}

MaterialFloat3 CustomExpression3(FMaterialVertexParameters Parameters,MaterialFloat3 x)
{
return length(x);
}

MaterialFloat3 CustomExpression2(FMaterialVertexParameters Parameters,MaterialFloat3 x)
{
return length(x);
}

MaterialFloat CustomExpression1(FMaterialPixelParameters Parameters,MaterialFloat x,MaterialFloat y)
{
return (atan2(y,x));
}

MaterialFloat CustomExpression0(FMaterialPixelParameters Parameters,MaterialFloat x,MaterialFloat y)
{
return (atan2(y,x));
}
float3 GetMaterialWorldPositionOffset(FMaterialVertexParameters Parameters)
{
	MaterialFloat3 Local64 = mul(MaterialFloat3(1.00000000,0.00000000,0.00000000), (MaterialFloat3x3)(ResolvedView.ViewToTranslatedWorld));
	MaterialFloat3 Local65 = Local64;
	MaterialFloat3 Local66 = (Local65 * ((MaterialFloat3)Material.PreshaderBuffer[12].x));
	MaterialFloat2 Local67 = Parameters.TexCoords[0].xy;
	MaterialFloat2 Local68 = (((MaterialFloat2)1.00000000) - DERIV_BASE_VALUE(Local67));
	MaterialFloat Local69 = DERIV_BASE_VALUE(Local68).r;
	MaterialFloat Local70 = (-0.50000000 + DERIV_BASE_VALUE(Local69));
	MaterialFloat Local71 = (DERIV_BASE_VALUE(Local70) * 2.00000000);
	MaterialFloat Local72 = DERIV_BASE_VALUE(Local68).g;
	MaterialFloat Local73 = (DERIV_BASE_VALUE(Local72) * 2.00000000);
	MaterialFloat2 Local74 = MaterialFloat2(DERIV_BASE_VALUE(Local71),DERIV_BASE_VALUE(Local73));
	MaterialFloat Local75 = DERIV_BASE_VALUE(Local74).r;
	MaterialFloat3 Local76 = (Local66 * ((MaterialFloat3)DERIV_BASE_VALUE(Local75)));
	MaterialFloat Local77 = DERIV_BASE_VALUE(Local74).g;
	MaterialFloat3 Local78 = (Material.PreshaderBuffer[13].xyz * ((MaterialFloat3)DERIV_BASE_VALUE(Local77)));
	MaterialFloat3 Local79 = (DERIV_BASE_VALUE(Local76) + DERIV_BASE_VALUE(Local78));
	FLWCVector3 Local80 = GetWorldPosition(Parameters);
	FLWCVector3 Local81 = LWCSubtract(LWCPromote(DERIV_BASE_VALUE(Local79)), DERIV_BASE_VALUE(Local80));
	FLWCVector3 Local82 = TransformLocalPositionToWorld(Parameters, Material.PreshaderBuffer[4].xyz);
	FLWCVector3 Local83 = LWCAdd(DERIV_BASE_VALUE(Local81), Local82);
	FLWCVector3 Local84 = LWCAdd(DERIV_BASE_VALUE(Local83), DERIV_BASE_VALUE(Local80));
	FLWCVector3 Local85 = ResolvedView.WorldCameraOrigin;
	FLWCVector3 Local86 = LWCSubtract(DERIV_BASE_VALUE(Local84), Local85);
	MaterialFloat3 Local87 = LWCToFloat(DERIV_BASE_VALUE(Local86));
	MaterialFloat3 Local88 = normalize(DERIV_BASE_VALUE(Local87));
	FLWCVector3 Local89 = LWCSubtract(Local85, DERIV_BASE_VALUE(Local80));
	MaterialFloat3 Local90 = LWCToFloat(DERIV_BASE_VALUE(Local89));
	MaterialFloat3 Local91 = CustomExpression2(Parameters,DERIV_BASE_VALUE(Local90));
	MaterialFloat3 Local92 = normalize(DERIV_BASE_VALUE(Local90));
	MaterialFloat3 Local93 = mul(MaterialFloat3(0.00000000,0.00000000,-1.00000000), (MaterialFloat3x3)(ResolvedView.ViewToTranslatedWorld));
	MaterialFloat3 Local94 = Local93;
	MaterialFloat Local95 = dot(DERIV_BASE_VALUE(Local92),Local94);
	MaterialFloat3 Local96 = (Local91 * ((MaterialFloat3)DERIV_BASE_VALUE(Local95)));
	MaterialFloat3 Local97 = (Local96 - ((MaterialFloat3)Material.PreshaderBuffer[13].w));
	MaterialFloat3 Local98 = (Local97 * ((MaterialFloat3)Material.PreshaderBuffer[14].y));
	MaterialFloat3 Local99 = saturate(Local98);
	MaterialFloat3 Local100 = (Local99 * ((MaterialFloat3)Material.PreshaderBuffer[14].z));
	MaterialFloat3 Local101 = (Local100 * ((MaterialFloat3)Material.PreshaderBuffer[14].w));
	MaterialFloat3 Local102 = (DERIV_BASE_VALUE(Local88) * Local101);
	FLWCVector3 Local103 = LWCSubtract(DERIV_BASE_VALUE(Local83), LWCPromote(Local102));
	MaterialFloat3 Local107 = mul(MaterialFloat3(1.00000000,0.00000000,0.00000000), (MaterialFloat3x3)(ResolvedView.PrevViewToTranslatedWorld));
	MaterialFloat3 Local108 = Local107;
	MaterialFloat3 Local109 = (Local108 * ((MaterialFloat3)Material.PreshaderBuffer[12].x));
	MaterialFloat3 Local110 = (Local109 * ((MaterialFloat3)DERIV_BASE_VALUE(Local75)));
	MaterialFloat3 Local111 = (DERIV_BASE_VALUE(Local110) + DERIV_BASE_VALUE(Local78));
	FLWCVector3 Local112 = GetPrevWorldPosition(Parameters);
	FLWCVector3 Local113 = LWCSubtract(LWCPromote(DERIV_BASE_VALUE(Local111)), DERIV_BASE_VALUE(Local112));
	FLWCVector3 Local114 = TransformLocalPositionToPrevWorld(Parameters, Material.PreshaderBuffer[4].xyz);
	FLWCVector3 Local115 = LWCAdd(DERIV_BASE_VALUE(Local113), Local114);
	FLWCVector3 Local116 = LWCAdd(DERIV_BASE_VALUE(Local115), DERIV_BASE_VALUE(Local112));
	FLWCVector3 Local117 = ResolvedView.PrevWorldCameraOrigin;
	FLWCVector3 Local118 = LWCSubtract(DERIV_BASE_VALUE(Local116), Local117);
	MaterialFloat3 Local119 = LWCToFloat(DERIV_BASE_VALUE(Local118));
	MaterialFloat3 Local120 = normalize(DERIV_BASE_VALUE(Local119));
	FLWCVector3 Local121 = LWCSubtract(Local117, DERIV_BASE_VALUE(Local112));
	MaterialFloat3 Local122 = LWCToFloat(DERIV_BASE_VALUE(Local121));
	MaterialFloat3 Local123 = CustomExpression3(Parameters,DERIV_BASE_VALUE(Local122));
	MaterialFloat3 Local124 = normalize(DERIV_BASE_VALUE(Local122));
	MaterialFloat3 Local125 = mul(MaterialFloat3(0.00000000,0.00000000,-1.00000000), (MaterialFloat3x3)(ResolvedView.PrevViewToTranslatedWorld));
	MaterialFloat3 Local126 = Local125;
	MaterialFloat Local127 = dot(DERIV_BASE_VALUE(Local124),Local126);
	MaterialFloat3 Local128 = (Local123 * ((MaterialFloat3)DERIV_BASE_VALUE(Local127)));
	MaterialFloat3 Local129 = (Local128 - ((MaterialFloat3)Material.PreshaderBuffer[13].w));
	MaterialFloat3 Local130 = (Local129 * ((MaterialFloat3)Material.PreshaderBuffer[14].y));
	MaterialFloat3 Local131 = saturate(Local130);
	MaterialFloat3 Local132 = (Local131 * ((MaterialFloat3)Material.PreshaderBuffer[14].z));
	MaterialFloat3 Local133 = (Local132 * ((MaterialFloat3)Material.PreshaderBuffer[14].w));
	MaterialFloat3 Local134 = (DERIV_BASE_VALUE(Local120) * Local133);
	FLWCVector3 Local135 = LWCSubtract(DERIV_BASE_VALUE(Local115), LWCPromote(Local134));
	MaterialFloat2 Local145 = (DERIV_BASE_VALUE(Local67) / MaterialFloat2(5.00000000,5.00000000));
	MaterialFloat3 Local146 = TransformLocalVectorToWorld(Parameters, MaterialFloat3(1.00000000,0.00000000,0.00000000));
	MaterialFloat Local147 = CustomExpression4(Parameters,Local146.xy.r,Local146.xy.g);
	MaterialFloat Local148 = (Local147.r / 6.28318501);
	MaterialFloat Local149 = frac(Local148);
	FLWCVector3 Local150 = LWCSubtract(Local85, Local82);
	MaterialFloat Local151 = CustomExpression5(Parameters,LWCToFloat(Local150).r,LWCToFloat(Local150).g);
	MaterialFloat Local152 = (Local151.r / 6.28318501);
	MaterialFloat Local153 = (Local152 * -1.00000000);
	MaterialFloat Local154 = (Local149 + Local153);
	MaterialFloat Local155 = (Local154 + 0.25000000);
	MaterialFloat Local156 = frac(Local155);
	MaterialFloat Local157 = frac(Local156);
	MaterialFloat2 Local158 = (MaterialFloat2(25.00000000,5.00000000) * MaterialFloat2(Local157,Local157));
	MaterialFloat2 Local159 = floor(Local158);
	MaterialFloat2 Local160 = (Local159 / MaterialFloat2(5.00000000,5.00000000));
	MaterialFloat2 Local161 = (DERIV_BASE_VALUE(Local145) + Local160);
	return LWCToFloat(Local103);;
}

void GetMaterialCustomizedUVs(FMaterialPixelParameters PixelParameters, inout float2 OutTexCoords[NUM_TEX_COORD_INTERPOLATORS])
{
	FMaterialVertexParameters Parameters = (FMaterialVertexParameters)0;
	Parameters.TangentToWorld = PixelParameters.TangentToWorld;
	Parameters.WorldPosition = PixelParameters.AbsoluteWorldPosition;
	Parameters.VertexColor = PixelParameters.VertexColor;
#if NUM_MATERIAL_TEXCOORDS_VERTEX > 0
	int m = min( NUM_MATERIAL_TEXCOORDS_VERTEX, NUM_TEX_COORD_INTERPOLATORS );
	for( int i = 0; i < m; i++ )
	{
		Parameters.TexCoords[i] = PixelParameters.TexCoords[i];
	}
#endif
	Parameters.PrimitiveId = PixelParameters.PrimitiveId;

	MaterialFloat3 Local64 = mul(MaterialFloat3(1.00000000,0.00000000,0.00000000), (MaterialFloat3x3)(ResolvedView.ViewToTranslatedWorld));
	MaterialFloat3 Local65 = Local64;
	MaterialFloat3 Local66 = (Local65 * ((MaterialFloat3)Material.PreshaderBuffer[12].x));
	MaterialFloat2 Local67 = Parameters.TexCoords[0].xy;
	MaterialFloat2 Local68 = (((MaterialFloat2)1.00000000) - DERIV_BASE_VALUE(Local67));
	MaterialFloat Local69 = DERIV_BASE_VALUE(Local68).r;
	MaterialFloat Local70 = (-0.50000000 + DERIV_BASE_VALUE(Local69));
	MaterialFloat Local71 = (DERIV_BASE_VALUE(Local70) * 2.00000000);
	MaterialFloat Local72 = DERIV_BASE_VALUE(Local68).g;
	MaterialFloat Local73 = (DERIV_BASE_VALUE(Local72) * 2.00000000);
	MaterialFloat2 Local74 = MaterialFloat2(DERIV_BASE_VALUE(Local71),DERIV_BASE_VALUE(Local73));
	MaterialFloat Local75 = DERIV_BASE_VALUE(Local74).r;
	MaterialFloat3 Local76 = (Local66 * ((MaterialFloat3)DERIV_BASE_VALUE(Local75)));
	MaterialFloat Local77 = DERIV_BASE_VALUE(Local74).g;
	MaterialFloat3 Local78 = (Material.PreshaderBuffer[13].xyz * ((MaterialFloat3)DERIV_BASE_VALUE(Local77)));
	MaterialFloat3 Local79 = (DERIV_BASE_VALUE(Local76) + DERIV_BASE_VALUE(Local78));
	FLWCVector3 Local80 = GetWorldPosition(Parameters);
	FLWCVector3 Local81 = LWCSubtract(LWCPromote(DERIV_BASE_VALUE(Local79)), DERIV_BASE_VALUE(Local80));
	FLWCVector3 Local82 = TransformLocalPositionToWorld(Parameters, Material.PreshaderBuffer[4].xyz);
	FLWCVector3 Local83 = LWCAdd(DERIV_BASE_VALUE(Local81), Local82);
	FLWCVector3 Local84 = LWCAdd(DERIV_BASE_VALUE(Local83), DERIV_BASE_VALUE(Local80));
	FLWCVector3 Local85 = ResolvedView.WorldCameraOrigin;
	FLWCVector3 Local86 = LWCSubtract(DERIV_BASE_VALUE(Local84), Local85);
	MaterialFloat3 Local87 = LWCToFloat(DERIV_BASE_VALUE(Local86));
	MaterialFloat3 Local88 = normalize(DERIV_BASE_VALUE(Local87));
	FLWCVector3 Local89 = LWCSubtract(Local85, DERIV_BASE_VALUE(Local80));
	MaterialFloat3 Local90 = LWCToFloat(DERIV_BASE_VALUE(Local89));
	MaterialFloat3 Local91 = CustomExpression2(Parameters,DERIV_BASE_VALUE(Local90));
	MaterialFloat3 Local92 = normalize(DERIV_BASE_VALUE(Local90));
	MaterialFloat3 Local93 = mul(MaterialFloat3(0.00000000,0.00000000,-1.00000000), (MaterialFloat3x3)(ResolvedView.ViewToTranslatedWorld));
	MaterialFloat3 Local94 = Local93;
	MaterialFloat Local95 = dot(DERIV_BASE_VALUE(Local92),Local94);
	MaterialFloat3 Local96 = (Local91 * ((MaterialFloat3)DERIV_BASE_VALUE(Local95)));
	MaterialFloat3 Local97 = (Local96 - ((MaterialFloat3)Material.PreshaderBuffer[13].w));
	MaterialFloat3 Local98 = (Local97 * ((MaterialFloat3)Material.PreshaderBuffer[14].y));
	MaterialFloat3 Local99 = saturate(Local98);
	MaterialFloat3 Local100 = (Local99 * ((MaterialFloat3)Material.PreshaderBuffer[14].z));
	MaterialFloat3 Local101 = (Local100 * ((MaterialFloat3)Material.PreshaderBuffer[14].w));
	MaterialFloat3 Local102 = (DERIV_BASE_VALUE(Local88) * Local101);
	FLWCVector3 Local103 = LWCSubtract(DERIV_BASE_VALUE(Local83), LWCPromote(Local102));
	MaterialFloat3 Local107 = mul(MaterialFloat3(1.00000000,0.00000000,0.00000000), (MaterialFloat3x3)(ResolvedView.PrevViewToTranslatedWorld));
	MaterialFloat3 Local108 = Local107;
	MaterialFloat3 Local109 = (Local108 * ((MaterialFloat3)Material.PreshaderBuffer[12].x));
	MaterialFloat3 Local110 = (Local109 * ((MaterialFloat3)DERIV_BASE_VALUE(Local75)));
	MaterialFloat3 Local111 = (DERIV_BASE_VALUE(Local110) + DERIV_BASE_VALUE(Local78));
	FLWCVector3 Local112 = GetPrevWorldPosition(Parameters);
	FLWCVector3 Local113 = LWCSubtract(LWCPromote(DERIV_BASE_VALUE(Local111)), DERIV_BASE_VALUE(Local112));
	FLWCVector3 Local114 = TransformLocalPositionToPrevWorld(Parameters, Material.PreshaderBuffer[4].xyz);
	FLWCVector3 Local115 = LWCAdd(DERIV_BASE_VALUE(Local113), Local114);
	FLWCVector3 Local116 = LWCAdd(DERIV_BASE_VALUE(Local115), DERIV_BASE_VALUE(Local112));
	FLWCVector3 Local117 = ResolvedView.PrevWorldCameraOrigin;
	FLWCVector3 Local118 = LWCSubtract(DERIV_BASE_VALUE(Local116), Local117);
	MaterialFloat3 Local119 = LWCToFloat(DERIV_BASE_VALUE(Local118));
	MaterialFloat3 Local120 = normalize(DERIV_BASE_VALUE(Local119));
	FLWCVector3 Local121 = LWCSubtract(Local117, DERIV_BASE_VALUE(Local112));
	MaterialFloat3 Local122 = LWCToFloat(DERIV_BASE_VALUE(Local121));
	MaterialFloat3 Local123 = CustomExpression3(Parameters,DERIV_BASE_VALUE(Local122));
	MaterialFloat3 Local124 = normalize(DERIV_BASE_VALUE(Local122));
	MaterialFloat3 Local125 = mul(MaterialFloat3(0.00000000,0.00000000,-1.00000000), (MaterialFloat3x3)(ResolvedView.PrevViewToTranslatedWorld));
	MaterialFloat3 Local126 = Local125;
	MaterialFloat Local127 = dot(DERIV_BASE_VALUE(Local124),Local126);
	MaterialFloat3 Local128 = (Local123 * ((MaterialFloat3)DERIV_BASE_VALUE(Local127)));
	MaterialFloat3 Local129 = (Local128 - ((MaterialFloat3)Material.PreshaderBuffer[13].w));
	MaterialFloat3 Local130 = (Local129 * ((MaterialFloat3)Material.PreshaderBuffer[14].y));
	MaterialFloat3 Local131 = saturate(Local130);
	MaterialFloat3 Local132 = (Local131 * ((MaterialFloat3)Material.PreshaderBuffer[14].z));
	MaterialFloat3 Local133 = (Local132 * ((MaterialFloat3)Material.PreshaderBuffer[14].w));
	MaterialFloat3 Local134 = (DERIV_BASE_VALUE(Local120) * Local133);
	FLWCVector3 Local135 = LWCSubtract(DERIV_BASE_VALUE(Local115), LWCPromote(Local134));
	MaterialFloat2 Local145 = (DERIV_BASE_VALUE(Local67) / MaterialFloat2(5.00000000,5.00000000));
	MaterialFloat3 Local146 = TransformLocalVectorToWorld(Parameters, MaterialFloat3(1.00000000,0.00000000,0.00000000));
	MaterialFloat Local147 = CustomExpression4(Parameters,Local146.xy.r,Local146.xy.g);
	MaterialFloat Local148 = (Local147.r / 6.28318501);
	MaterialFloat Local149 = frac(Local148);
	FLWCVector3 Local150 = LWCSubtract(Local85, Local82);
	MaterialFloat Local151 = CustomExpression5(Parameters,LWCToFloat(Local150).r,LWCToFloat(Local150).g);
	MaterialFloat Local152 = (Local151.r / 6.28318501);
	MaterialFloat Local153 = (Local152 * -1.00000000);
	MaterialFloat Local154 = (Local149 + Local153);
	MaterialFloat Local155 = (Local154 + 0.25000000);
	MaterialFloat Local156 = frac(Local155);
	MaterialFloat Local157 = frac(Local156);
	MaterialFloat2 Local158 = (MaterialFloat2(25.00000000,5.00000000) * MaterialFloat2(Local157,Local157));
	MaterialFloat2 Local159 = floor(Local158);
	MaterialFloat2 Local160 = (Local159 / MaterialFloat2(5.00000000,5.00000000));
	MaterialFloat2 Local161 = (DERIV_BASE_VALUE(Local145) + Local160);
	OutTexCoords[0] = Local161;
	OutTexCoords[1] = Local67;
	OutTexCoords[2] = Local100.xy;

}
void CalcPixelMaterialInputs(in out FMaterialPixelParameters Parameters, in out FPixelMaterialInputs PixelMaterialInputs)
{
	//WorldAligned texturing & others use normals & stuff that think Z is up
	Parameters.TangentToWorld[0] = Parameters.TangentToWorld[0].xzy;
	Parameters.TangentToWorld[1] = Parameters.TangentToWorld[1].xzy;
	Parameters.TangentToWorld[2] = Parameters.TangentToWorld[2].xzy;

	float3 WorldNormalCopy = Parameters.WorldNormal;

	// Initial calculations (required for Normal)
	MaterialFloat3 Local0 = mul(Material.PreshaderBuffer[2].xyz, (MaterialFloat3x3)(ResolvedView.ViewToTranslatedWorld));
	MaterialFloat3 Local1 = Local0;
	MaterialFloat3 Local2 = TransformLocalVectorToWorld(Parameters, MaterialFloat3(1.00000000,0.00000000,0.00000000));
	MaterialFloat Local3 = CustomExpression0(Parameters,Local2.xy.r,Local2.xy.g);
	MaterialFloat Local4 = (Local3.r / 6.28318501);
	MaterialFloat Local5 = frac(Local4);
	FLWCVector3 Local6 = ResolvedView.WorldCameraOrigin;
	FLWCVector3 Local7 = TransformLocalPositionToWorld(Parameters, Material.PreshaderBuffer[4].xyz);
	FLWCVector3 Local8 = LWCSubtract(Local6, Local7);
	MaterialFloat Local9 = CustomExpression1(Parameters,LWCToFloat(Local8).r,LWCToFloat(Local8).g);
	MaterialFloat Local10 = (Local9.r / 6.28318501);
	MaterialFloat Local11 = (Local10 * -1.00000000);
	MaterialFloat Local12 = (Local5 + Local11);
	MaterialFloat Local13 = (Local12 + 0.25000000);
	MaterialFloat Local14 = frac(Local13);
	MaterialFloat Local15 = (Local14 * Material.PreshaderBuffer[4].w);
	MaterialFloat Local16 = (Local14 * 5.00000000);
	MaterialFloat Local17 = (Local16 - Material.PreshaderBuffer[5].x);
	MaterialFloat Local18 = frac(Local17);
	MaterialFloat3 Local19 = normalize(LWCToFloat(Local8));
	MaterialFloat Local20 = dot(DERIV_BASE_VALUE(Local19),MaterialFloat3(0.00000000,0.00000000,-1.00000000));
	MaterialFloat Local21 = (Local18 * DERIV_BASE_VALUE(Local20));
	MaterialFloat Local22 = (Local21 * -1.25663686);
	MaterialFloat Local23 = (DERIV_BASE_VALUE(Local20) * 0.62831843);
	MaterialFloat Local24 = (Local22 + DERIV_BASE_VALUE(Local23));
	MaterialFloat Local25 = (Local24 * Material.PreshaderBuffer[5].y);
	MaterialFloat Local26 = (Local25 / 5.00000000);
	MaterialFloat Local27 = (Local15 + Local26);
	MaterialFloat Local28 = (Local27 * 6.28318548);
	MaterialFloat2 Local29 = Parameters.TexCoords[0].xy;
	MaterialFloat Local30 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local29), 6);
	MaterialFloat4 Local31 = ProcessMaterialLinearColorTextureLookup(Texture2DSampleBias(Material_Texture2D_0,samplerMaterial_Texture2D_0,DERIV_BASE_VALUE(Local29),View.MaterialTextureMipBias));
	MaterialFloat Local32 = MaterialStoreTexSample(Parameters, Local31, 6);
	MaterialFloat3 Local33 = (((MaterialFloat3)-0.50000000) + Local31.rgb);
	MaterialFloat3 Local34 = (Local33 * ((MaterialFloat3)2.00000000));
	MaterialFloat2 Local35 = Parameters.TexCoords[1].xy;
	MaterialFloat2 Local36 = (((MaterialFloat2)-0.50000000) + DERIV_BASE_VALUE(Local35));
	MaterialFloat2 Local37 = (DERIV_BASE_VALUE(Local36) * ((MaterialFloat2)2.00000000));
	MaterialFloat Local38 = DERIV_BASE_VALUE(Local37).r;
	MaterialFloat Local39 = (DERIV_BASE_VALUE(Local38) * Material.PreshaderBuffer[5].z);
	MaterialFloat Local40 = DERIV_BASE_VALUE(Local37).g;
	MaterialFloat Local41 = (DERIV_BASE_VALUE(Local40) * Material.PreshaderBuffer[5].w);
	MaterialFloat2 Local42 = MaterialFloat2(DERIV_BASE_VALUE(Local39),DERIV_BASE_VALUE(Local41));
	MaterialFloat3 Local43 = MaterialFloat3(DERIV_BASE_VALUE(Local42),0.00000000);
	MaterialFloat3 Local44 = (Local34 + DERIV_BASE_VALUE(Local43));
	MaterialFloat3 Local45 = RotateAboutAxis(MaterialFloat4(MaterialFloat3(0.00000000,0.00000000,1.00000000),Local28),((MaterialFloat3)0.00000000),Local44);
	MaterialFloat3 Local46 = (Local45 + Local44);
	MaterialFloat3 Local47 = (Local1 * ((MaterialFloat3)Local46.r));
	MaterialFloat3 Local48 = mul(Material.PreshaderBuffer[7].xyz, (MaterialFloat3x3)(ResolvedView.ViewToTranslatedWorld));
	MaterialFloat3 Local49 = Local48;
	MaterialFloat3 Local50 = (Local49 * ((MaterialFloat3)Local46.g));
	MaterialFloat3 Local51 = (Local47 + Local50);
	MaterialFloat3 Local52 = mul(Material.PreshaderBuffer[9].xyz, (MaterialFloat3x3)(ResolvedView.ViewToTranslatedWorld));
	MaterialFloat3 Local53 = Local52;
	MaterialFloat3 Local54 = (Local53 * ((MaterialFloat3)Local46.b));
	MaterialFloat3 Local55 = (Local54 + MaterialFloat3(0.00000000,0.00000000,0.00000000));
	MaterialFloat3 Local56 = (Local51 + Local55);

	// The Normal is a special case as it might have its own expressions and also be used to calculate other inputs, so perform the assignment here
	PixelMaterialInputs.Normal = Local56;


#if TEMPLATE_USES_STRATA
	Parameters.StrataPixelFootprint = StrataGetPixelFootprint(Parameters.WorldPosition_CamRelative, GetRoughnessFromNormalCurvature(Parameters));
	Parameters.SharedLocalBases = StrataInitialiseSharedLocalBases();
	Parameters.StrataTree = GetInitialisedStrataTree();
#if STRATA_USE_FULLYSIMPLIFIED_MATERIAL == 1
	Parameters.SharedLocalBasesFullySimplified = StrataInitialiseSharedLocalBases();
	Parameters.StrataTreeFullySimplified = GetInitialisedStrataTree();
#endif
#endif

	// Note that here MaterialNormal can be in world space or tangent space
	float3 MaterialNormal = GetMaterialNormal(Parameters, PixelMaterialInputs);

#if MATERIAL_TANGENTSPACENORMAL

#if FEATURE_LEVEL >= FEATURE_LEVEL_SM4
	// Mobile will rely on only the final normalize for performance
	MaterialNormal = normalize(MaterialNormal);
#endif

	// normalizing after the tangent space to world space conversion improves quality with sheared bases (UV layout to WS causes shrearing)
	// use full precision normalize to avoid overflows
	Parameters.WorldNormal = TransformTangentNormalToWorld(Parameters.TangentToWorld, MaterialNormal);

#else //MATERIAL_TANGENTSPACENORMAL

	Parameters.WorldNormal = normalize(MaterialNormal);

#endif //MATERIAL_TANGENTSPACENORMAL

#if MATERIAL_TANGENTSPACENORMAL
	// flip the normal for backfaces being rendered with a two-sided material
	Parameters.WorldNormal *= Parameters.TwoSidedSign;
#endif

	Parameters.ReflectionVector = ReflectionAboutCustomWorldNormal(Parameters, Parameters.WorldNormal, false);

#if !PARTICLE_SPRITE_FACTORY
	Parameters.Particle.MotionBlurFade = 1.0f;
#endif // !PARTICLE_SPRITE_FACTORY

	// Now the rest of the inputs
	MaterialFloat3 Local57 = lerp(MaterialFloat3(0.00000000,0.00000000,0.00000000),Material.PreshaderBuffer[10].xyz,Material.PreshaderBuffer[9].w);
	MaterialFloat Local58 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local29), 4);
	MaterialFloat4 Local59 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_1,samplerMaterial_Texture2D_1,DERIV_BASE_VALUE(Local29),View.MaterialTextureMipBias));
	MaterialFloat Local60 = MaterialStoreTexSample(Parameters, Local59, 4);
	MaterialFloat3 Local61 = PositiveClampedPow(Local59.rgb,((MaterialFloat3)Material.PreshaderBuffer[10].w));
	MaterialFloat3 Local62 = (Local61 * ((MaterialFloat3)Material.PreshaderBuffer[11].x));
	MaterialFloat Local63 = (Local59.a + Material.PreshaderBuffer[11].y);
	MaterialFloat3 Local104 = (Local59.rgb * Material.PreshaderBuffer[16].xyz);
	MaterialFloat3 Local105 = (Local104 * ((MaterialFloat3)Material.PreshaderBuffer[16].w));
	MaterialFloat3 Local106 = (Local105 * ((MaterialFloat3)Local59.a));
	MaterialFloat2 Local136 = Parameters.TexCoords[2].xy;
	MaterialFloat Local137 = DERIV_BASE_VALUE(Local136).r;
	MaterialFloat Local138 = (Material.PreshaderBuffer[14].w * DERIV_BASE_VALUE(Local137));
	MaterialFloat Local139 = (DERIV_BASE_VALUE(Local138) * 2.00000000);
	MaterialFloat Local140 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local29), 5);
	MaterialFloat4 Local141 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_2,samplerMaterial_Texture2D_2,DERIV_BASE_VALUE(Local29),View.MaterialTextureMipBias));
	MaterialFloat Local142 = MaterialStoreTexSample(Parameters, Local141, 5);
	MaterialFloat Local143 = lerp(Local141.r,1.00000000,Material.PreshaderBuffer[17].y);
	MaterialFloat Local144 = (DERIV_BASE_VALUE(Local139) * Local143);

	PixelMaterialInputs.EmissiveColor = Local57;
	PixelMaterialInputs.Opacity = Local63;
	PixelMaterialInputs.OpacityMask = Local63;
	PixelMaterialInputs.BaseColor = Local62;
	PixelMaterialInputs.Metallic = 0.00000000;
	PixelMaterialInputs.Specular = 0.00000000;
	PixelMaterialInputs.Roughness = 1.00000000;
	PixelMaterialInputs.Anisotropy = 0.00000000;
	PixelMaterialInputs.Normal = Local56;
	PixelMaterialInputs.Tangent = Parameters.TangentToWorld[0];
	PixelMaterialInputs.Subsurface = MaterialFloat4(Local106,Material.PreshaderBuffer[17].x);
	PixelMaterialInputs.AmbientOcclusion = 1.00000000;
	PixelMaterialInputs.Refraction = 0;
	PixelMaterialInputs.PixelDepthOffset = Local144;
	PixelMaterialInputs.ShadingModel = 6;
	PixelMaterialInputs.FrontMaterial = GetInitialisedStrataData();
	PixelMaterialInputs.SurfaceThickness = 0.01000000;
	PixelMaterialInputs.Displacement = 0.00000000;


#if MATERIAL_USES_ANISOTROPY
	Parameters.WorldTangent = CalculateAnisotropyTangent(Parameters, PixelMaterialInputs);
#else
	Parameters.WorldTangent = 0;
#endif
}

#define UnityObjectToWorldDir TransformObjectToWorld

void SetupCommonData( int Parameters_PrimitiveId )
{
	View_MaterialTextureBilinearWrapedSampler = SamplerState_Linear_Repeat;
	View_MaterialTextureBilinearClampedSampler = SamplerState_Linear_Clamp;

	Material_Wrap_WorldGroupSettings = SamplerState_Linear_Repeat;
	Material_Clamp_WorldGroupSettings = SamplerState_Linear_Clamp;

	View.GameTime = View.RealTime = _Time.y;// _Time is (t/20, t, t*2, t*3)
	View.PrevFrameGameTime = View.GameTime - unity_DeltaTime.x;//(dt, 1/dt, smoothDt, 1/smoothDt)
	View.PrevFrameRealTime = View.RealTime;
	View.DeltaTime = unity_DeltaTime.x;
	View.MaterialTextureMipBias = 0.0;
	View.TemporalAAParams = float4( 0, 0, 0, 0 );
	View.ViewRectMin = float2( 0, 0 );
	View.ViewSizeAndInvSize = View_BufferSizeAndInvSize;
	View.ResolutionFractionAndInv = float2( View_BufferSizeAndInvSize.x / View_BufferSizeAndInvSize.y, 1.0 / ( View_BufferSizeAndInvSize.x / View_BufferSizeAndInvSize.y ));
	View.MaterialTextureDerivativeMultiply = 1.0f;
	View.StateFrameIndexMod8 = 0;
	View.FrameNumber = (int)_Time.y;
	View.FieldOfViewWideAngles = float2( PI * 0.42f, PI * 0.42f );//75degrees, default unity
	View.RuntimeVirtualTextureMipLevel = float4( 0, 0, 0, 0 );
	View.PreExposure = 0;
	View.BufferBilinearUVMinMax = float4(
		View_BufferSizeAndInvSize.z * ( 0 + 0.5 ),//EffectiveViewRect.Min.X
		View_BufferSizeAndInvSize.w * ( 0 + 0.5 ),//EffectiveViewRect.Min.Y
		View_BufferSizeAndInvSize.z * ( View_BufferSizeAndInvSize.x - 0.5 ),//EffectiveViewRect.Max.X
		View_BufferSizeAndInvSize.w * ( View_BufferSizeAndInvSize.y - 0.5 ) );//EffectiveViewRect.Max.Y

	for( int i2 = 0; i2 < 40; i2++ )
		View.PrimitiveSceneData[ i2 ] = float4( 0, 0, 0, 0 );

	float4x4 LocalToWorld = transpose( UNITY_MATRIX_M );
    LocalToWorld[3] = float4(ToUnrealPos(LocalToWorld[3]), LocalToWorld[3].w);
	float4x4 WorldToLocal = transpose( UNITY_MATRIX_I_M );
	float4x4 ViewMatrix = transpose( UNITY_MATRIX_V );
	float4x4 InverseViewMatrix = transpose( UNITY_MATRIX_I_V );
	float4x4 ViewProjectionMatrix = transpose( UNITY_MATRIX_VP );
	uint PrimitiveBaseOffset = Parameters_PrimitiveId * PRIMITIVE_SCENE_DATA_STRIDE;
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 0 ] = LocalToWorld[ 0 ];//LocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 1 ] = LocalToWorld[ 1 ];//LocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 2 ] = LocalToWorld[ 2 ];//LocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 3 ] = LocalToWorld[ 3 ];//LocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 5 ] = float4( ToUnrealPos( SHADERGRAPH_OBJECT_POSITION ), 100.0 );//ObjectWorldPosition
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 6 ] = WorldToLocal[ 0 ];//WorldToLocal
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 7 ] = WorldToLocal[ 1 ];//WorldToLocal
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 8 ] = WorldToLocal[ 2 ];//WorldToLocal
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 9 ] = WorldToLocal[ 3 ];//WorldToLocal
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 10 ] = LocalToWorld[ 0 ];//PreviousLocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 11 ] = LocalToWorld[ 1 ];//PreviousLocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 12 ] = LocalToWorld[ 2 ];//PreviousLocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 13 ] = LocalToWorld[ 3 ];//PreviousLocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 18 ] = float4( ToUnrealPos( SHADERGRAPH_OBJECT_POSITION ), 0 );//ActorWorldPosition
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 19 ] = LocalObjectBoundsMax - LocalObjectBoundsMin;//ObjectBounds
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 21 ] = mul( LocalToWorld, float3( 1, 0, 0 ) );
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 23 ] = LocalObjectBoundsMin;//LocalObjectBoundsMin 
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 24 ] = LocalObjectBoundsMax;//LocalObjectBoundsMax

#ifdef UE5
	ResolvedView.WorldCameraOrigin = LWCPromote( ToUnrealPos( _WorldSpaceCameraPos.xyz ) );
	ResolvedView.PreViewTranslation = LWCPromote( float3( 0, 0, 0 ) );
	ResolvedView.WorldViewOrigin = LWCPromote( float3( 0, 0, 0 ) );
#else
	ResolvedView.WorldCameraOrigin = ToUnrealPos( _WorldSpaceCameraPos.xyz );
	ResolvedView.PreViewTranslation = float3( 0, 0, 0 );
	ResolvedView.WorldViewOrigin = float3( 0, 0, 0 );
#endif
	ResolvedView.PrevWorldCameraOrigin = ResolvedView.WorldCameraOrigin;
	ResolvedView.ScreenPositionScaleBias = float4( 1, 1, 0, 0 );
	ResolvedView.TranslatedWorldToView		 = ViewMatrix;
	ResolvedView.TranslatedWorldToCameraView = ViewMatrix;
	ResolvedView.TranslatedWorldToClip		 = ViewProjectionMatrix;
	ResolvedView.ViewToTranslatedWorld		 = InverseViewMatrix;
	ResolvedView.PrevViewToTranslatedWorld = ResolvedView.ViewToTranslatedWorld;
	ResolvedView.CameraViewToTranslatedWorld = InverseViewMatrix;
	ResolvedView.BufferBilinearUVMinMax = View.BufferBilinearUVMinMax;
	Primitive.WorldToLocal = WorldToLocal;
	Primitive.LocalToWorld = LocalToWorld;
}
#define VS_USES_UNREAL_SPACE 1
float3 PrepareAndGetWPO( float4 VertexColor, float3 UnrealWorldPos, float3 UnrealNormal, float4 InTangent,
						 float4 UV0, float4 UV1 )
{
	InitializeExpressions();
	FMaterialVertexParameters Parameters = (FMaterialVertexParameters)0;

	float3 InWorldNormal = UnrealNormal;
	float4 tangentWorld = InTangent;
	tangentWorld.xyz = normalize( tangentWorld.xyz );
	//float3x3 tangentToWorld = CreateTangentToWorldPerVertex( InWorldNormal, tangentWorld.xyz, tangentWorld.w );
	Parameters.TangentToWorld = float3x3( normalize( cross( InWorldNormal, tangentWorld.xyz ) * tangentWorld.w ), tangentWorld.xyz, InWorldNormal );

	
	#ifdef VS_USES_UNREAL_SPACE
		UnrealWorldPos = ToUnrealPos( UnrealWorldPos );
	#endif
	Parameters.WorldPosition = UnrealWorldPos;
	#ifdef VS_USES_UNREAL_SPACE
		Parameters.TangentToWorld[ 0 ] = Parameters.TangentToWorld[ 0 ].xzy;
		Parameters.TangentToWorld[ 1 ] = Parameters.TangentToWorld[ 1 ].xzy;
		Parameters.TangentToWorld[ 2 ] = Parameters.TangentToWorld[ 2 ].xzy;//WorldAligned texturing uses normals that think Z is up
	#endif

	Parameters.VertexColor = VertexColor;

#if NUM_MATERIAL_TEXCOORDS_VERTEX > 0			
	Parameters.TexCoords[ 0 ] = float2( UV0.x, UV0.y );
#endif
#if NUM_MATERIAL_TEXCOORDS_VERTEX > 1
	Parameters.TexCoords[ 1 ] = float2( UV1.x, UV1.y );
#endif
#if NUM_MATERIAL_TEXCOORDS_VERTEX > 2
	for( int i = 2; i < NUM_TEX_COORD_INTERPOLATORS; i++ )
	{
		Parameters.TexCoords[ i ] = float2( UV0.x, UV0.y );
	}
#endif

	Parameters.PrimitiveId = 0;

	SetupCommonData( Parameters.PrimitiveId );

#ifdef UE5
	Parameters.PrevFrameLocalToWorld = MakeLWCMatrix( float3( 0, 0, 0 ), Primitive.LocalToWorld );
#else
	Parameters.PrevFrameLocalToWorld = Primitive.LocalToWorld;
#endif
	
	float3 Offset = float3( 0, 0, 0 );
	Offset = GetMaterialWorldPositionOffset( Parameters );
	#ifdef VS_USES_UNREAL_SPACE
		//Convert from unreal units to unity
		Offset /= float3( 100, 100, 100 );
		Offset = Offset.xzy;
	#endif
	return Offset;
}

void SurfaceReplacement( Input In, out SurfaceOutputStandard o )
{
	InitializeExpressions();

	float3 Z3 = float3( 0, 0, 0 );
	float4 Z4 = float4( 0, 0, 0, 0 );

	float3 UnrealWorldPos = float3( In.worldPos.x, In.worldPos.y, In.worldPos.z );

	float3 UnrealNormal = In.normal2;	

	FMaterialPixelParameters Parameters = (FMaterialPixelParameters)0;
#if NUM_TEX_COORD_INTERPOLATORS > 0			
	Parameters.TexCoords[ 0 ] = float2( In.uv_MainTex.x, 1.0 - In.uv_MainTex.y );
#endif
#if NUM_TEX_COORD_INTERPOLATORS > 1
	Parameters.TexCoords[ 1 ] = float2( In.uv2_Material_Texture2D_0.x, 1.0 - In.uv2_Material_Texture2D_0.y );
#endif
#if NUM_TEX_COORD_INTERPOLATORS > 2
	for( int i = 2; i < NUM_TEX_COORD_INTERPOLATORS; i++ )
	{
		Parameters.TexCoords[ i ] = float2( In.uv_MainTex.x, 1.0 - In.uv_MainTex.y );
	}
#endif
	Parameters.PostProcessUV = In.uv_MainTex;
	Parameters.VertexColor = In.color;
	Parameters.WorldNormal = UnrealNormal;
	Parameters.ReflectionVector = half3( 0, 0, 1 );
	//Parameters.CameraVector = normalize( _WorldSpaceCameraPos.xyz - UnrealWorldPos.xyz );
	//Parameters.CameraVector = mul( ( float3x3 )unity_CameraToWorld, float3( 0, 0, 1 ) ) * -1;	
	float3 CameraDirection = (-1 * mul((float3x3)UNITY_MATRIX_M, transpose(mul(UNITY_MATRIX_I_M, UNITY_MATRIX_I_V)) [2].xyz));//From ShaderGraph
	Parameters.CameraVector = CameraDirection;
	Parameters.LightVector = half3( 0, 0, 0 );
	//float4 screenpos = In.screenPos;
	//screenpos /= screenpos.w;
	Parameters.SvPosition = In.screenPos;
	Parameters.ScreenPosition = Parameters.SvPosition;

	Parameters.UnMirrored = 1;

	Parameters.TwoSidedSign = 1;


	float3 InWorldNormal = UnrealNormal;	
	float4 tangentWorld = In.tangent;
	tangentWorld.xyz = normalize( tangentWorld.xyz );
	//float3x3 tangentToWorld = CreateTangentToWorldPerVertex( InWorldNormal, tangentWorld.xyz, tangentWorld.w );
	Parameters.TangentToWorld = float3x3( normalize( cross( InWorldNormal, tangentWorld.xyz ) * tangentWorld.w ), tangentWorld.xyz, InWorldNormal );

	//WorldAlignedTexturing in UE relies on the fact that coords there are 100x larger, prepare values for that
	//but watch out for any computation that might get skewed as a side effect
	UnrealWorldPos = ToUnrealPos( UnrealWorldPos );
	
	Parameters.AbsoluteWorldPosition = UnrealWorldPos;
	Parameters.WorldPosition_CamRelative = UnrealWorldPos;
	Parameters.WorldPosition_NoOffsets = UnrealWorldPos;

	Parameters.WorldPosition_NoOffsets_CamRelative = Parameters.WorldPosition_CamRelative;
	Parameters.LightingPositionOffset = float3( 0, 0, 0 );

	Parameters.AOMaterialMask = 0;

	Parameters.Particle.RelativeTime = 0;
	Parameters.Particle.MotionBlurFade;
	Parameters.Particle.Random = 0;
	Parameters.Particle.Velocity = half4( 1, 1, 1, 1 );
	Parameters.Particle.Color = half4( 1, 1, 1, 1 );
	Parameters.Particle.TranslatedWorldPositionAndSize = float4( UnrealWorldPos, 0 );
	Parameters.Particle.MacroUV = half4( 0, 0, 1, 1 );
	Parameters.Particle.DynamicParameter = half4( 0, 0, 0, 0 );
	Parameters.Particle.LocalToWorld = float4x4( Z4, Z4, Z4, Z4 );
	Parameters.Particle.Size = float2( 1, 1 );
	Parameters.Particle.SubUVCoords[ 0 ] = Parameters.Particle.SubUVCoords[ 1 ] = float2( 0, 0 );
	Parameters.Particle.SubUVLerp = 0.0;
	Parameters.TexCoordScalesParams = float2( 0, 0 );
	Parameters.PrimitiveId = 0;
	Parameters.VirtualTextureFeedback = 0;

	FPixelMaterialInputs PixelMaterialInputs = (FPixelMaterialInputs)0;
	PixelMaterialInputs.Normal = float3( 0, 0, 1 );
	PixelMaterialInputs.ShadingModel = 0;
	//PixelMaterialInputs.FrontMaterial = GetStrataUnlitBSDF( float3( 0, 0, 0 ), float3( 0, 0, 0 ) );

	SetupCommonData( Parameters.PrimitiveId );
	//CustomizedUVs
	#if NUM_TEX_COORD_INTERPOLATORS > 0 && HAS_CUSTOMIZED_UVS
		float2 OutTexCoords[ NUM_TEX_COORD_INTERPOLATORS ];
		//Prevent uninitialized reads
		for( int i = 0; i < NUM_TEX_COORD_INTERPOLATORS; i++ )
		{
			OutTexCoords[ i ] = float2( 0, 0 );
		}
		GetMaterialCustomizedUVs( Parameters, OutTexCoords );
		for( int i = 0; i < NUM_TEX_COORD_INTERPOLATORS; i++ )
		{
			Parameters.TexCoords[ i ] = OutTexCoords[ i ];
		}
	#endif
	//<-
	CalcPixelMaterialInputs( Parameters, PixelMaterialInputs );

	#define HAS_WORLDSPACE_NORMAL 1
	#if HAS_WORLDSPACE_NORMAL
		PixelMaterialInputs.Normal = mul( PixelMaterialInputs.Normal, (MaterialFloat3x3)( transpose( Parameters.TangentToWorld ) ) );
	#endif

	o.Albedo = PixelMaterialInputs.BaseColor.rgb;
	o.Alpha = PixelMaterialInputs.Opacity;
	if( PixelMaterialInputs.OpacityMask < 0.333 ) discard;

	o.Metallic = PixelMaterialInputs.Metallic;
	o.Smoothness = 1.0 - PixelMaterialInputs.Roughness;
	o.Normal = normalize( PixelMaterialInputs.Normal );
	o.Emission = PixelMaterialInputs.EmissiveColor.rgb;
	o.Occlusion = PixelMaterialInputs.AmbientOcclusion;

	//BLEND_ADDITIVE o.Alpha = ( o.Emission.r + o.Emission.g + o.Emission.b ) / 3;
}